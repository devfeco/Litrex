# Google Login API Entegrasyon Rehberi

Bu döküman, Flutter uygulamasından gelen Google giriş isteklerini karşılayacak olan PHP backend kodunu ve veritabanı gereksinimlerini içerir.

## 1. Veritabanı Değişiklikleri

`users` tablosuna Google'dan gelen verileri ve giriş tipini saklamak için şu alanları kontrol edin veya ekleyin:

```sql
ALTER TABLE users ADD COLUMN google_id VARCHAR(255) DEFAULT NULL;
ALTER TABLE users ADD COLUMN photo_url TEXT DEFAULT NULL;
ALTER TABLE users ADD COLUMN login_type ENUM('email', 'google', 'apple') DEFAULT 'email';
```

---

## 2. API Endpoint: `auth/google_login.php`

Aşağıdaki kod taslağı, Google'dan gelen verilerle kullanıcıyı kaydetme veya giriş yaptırma mantığını açıklar.

```php
<?php
header('Content-Type: application/json');
require_once '../config.php'; // DB bağlantısı ve gerekli tanımlar

// Gelen POST verilerini al
$input = json_decode(file_get_contents('php://input'), true);

$email = $input['email'] ?? null;
$name = $input['name'] ?? 'Google User';
$photo_url = $input['photo_url'] ?? null;
$id_token = $input['id_token'] ?? null; // Güvenlik için Google Library ile doğrulanabilir
$device_id = $input['device_id'] ?? null;

if (!$email) {
    echo json_encode(["success" => false, "message" => "Email adresi zorunludur."]);
    exit;
}

// 1. Kullanıcıyı email ile ara
$stmt = $db->prepare("SELECT * FROM users WHERE email = ?");
$stmt->execute([$email]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if ($user) {
    // Kullanıcı zaten var, bilgilerini güncelle (isteğe bağlı) ve giriş yaptır
    $updateStmt = $db->prepare("UPDATE users SET name = ?, photo_url = ?, login_type = 'google', device_id = ? WHERE email = ?");
    $updateStmt->execute([$name, $photo_url, $device_id, $email]);
    $userId = $user['id'];
} else {
    // Yeni kullanıcı oluştur
    $insertStmt = $db->prepare("INSERT INTO users (name, email, photo_url, login_type, device_id, created_at) VALUES (?, ?, ?, 'google', ?, NOW())");
    $insertStmt->execute([$name, $email, $photo_url, $device_id]);
    $userId = $db->lastInsertId();
}

// Güncel kullanıcı bilgilerini çek
$stmt = $db->prepare("SELECT id, name, email, photo_url as avatar, bio, created_at, is_premium FROM users WHERE id = ?");
$stmt->execute([$userId]);
$userData = $stmt->fetch(PDO::FETCH_ASSOC);

// JWT Token veya Session ID oluştur (Var olan sisteminize göre)
$token = generateToken($userId); // Sizin sisteminizdeki token fonksiyonu

echo json_encode([
    "success" => true,
    "message" => "Giriş başarılı.",
    "token" => $token,
    "user" => [
        "id" => (int)$userData['id'],
        "name" => $userData['name'],
        "email" => $userData['email'],
        "avatar" => $userData['avatar'],
        "bio" => $userData['bio'],
        "created_at" => $userData['created_at'],
        "is_premium" => (int)$userData['is_premium']
    ]
]);

function generateToken($userId) {
    // Projenizdeki mevcut token oluşturma mantığını buraya uygulayın
    return bin2hex(random_bytes(32)); 
}
?>
```

---

## 3. Güvenlik Notu (Opsiyonel ama Önerilen)

Backend tarafında `id_token` doğrulaması yapmak isterseniz, Google'ın PHP kütüphanesini (`google/apiclient`) kullanarak token'ın gerçekten Google tarafından verildiğini doğrulayabilirsiniz:

```php
// Composer ile google/apiclient yüklü olmalıdır
$client = new Google_Client(['client_id' => 'YOUR_GOOGLE_CLIENT_ID']);
$payload = $client->verifyIdToken($id_token);
if ($payload) {
  $userid = $payload['sub'];
  // Token geçerli
} else {
  // Token geçersiz
}
```

## 4. Flutter Tarafında Gönderilen Veriler
*   `email`: Kullanıcının Google email adresi.
*   `name`: Kullanıcının Google'daki görünen adı.
*   `id_token`: Firebase/Google tarafından üretilen güvenli token.
*   `photo_url`: Kullanıcının profil resmi linki.
*   `device_id`: Cihazın benzersiz kimliği (Çoklu cihaz engelleme için).
