# 📚 Litrex eBook - Authentication API Rehberi

Bu dokümantasyon, Litrex eBook uygulamasının PHP backend entegrasyonu için gerekli tüm bilgileri içerir.

---

## 📁 Dosya Yapısı

```
api/
├── config/
│   └── database.php          # Veritabanı bağlantısı
├── utils/
│   ├── jwt.php               # JWT token işlemleri
│   └── auth_middleware.php   # Authentication middleware
├── auth/
│   ├── login.php             # Kullanıcı girişi
│   ├── register.php          # Kullanıcı kaydı
│   ├── forgot_password.php   # Şifre sıfırlama isteği
│   ├── reset_password.php    # Şifre sıfırlama
│   ├── profile.php           # Profil bilgilerini getir
│   ├── update_profile.php    # Profil güncelle
│   ├── update_avatar.php     # Avatar güncelle
│   ├── change_password.php   # Şifre değiştir
│   ├── logout.php            # Çıkış yap
│   └── delete_account.php    # Hesabı sil
```

---

## 🗄️ Veritabanı Tabloları

### users tablosu

```sql
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL UNIQUE,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### password_resets tablosu

```sql
CREATE TABLE `password_resets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `token` varchar(10) NOT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `expires_at` timestamp NOT NULL,
  PRIMARY KEY (`id`),
  KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## ⚙️ Konfigürasyon Dosyaları

### config/database.php

```php
<?php
define('DB_HOST', 'localhost');
define('DB_NAME', 'litrex_db');
define('DB_USER', 'root');
define('DB_PASS', '');

function getConnection() {
    try {
        $conn = new PDO(
            "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=utf8mb4",
            DB_USER,
            DB_PASS,
            [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
        );
        return $conn;
    } catch(PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Database connection failed']);
        exit;
    }
}
```

### utils/jwt.php

```php
<?php
define('JWT_SECRET', 'your-super-secret-key-change-this-in-production-min-32-chars');

function generateToken($userId, $email) {
    $header = base64_encode(json_encode(['typ' => 'JWT', 'alg' => 'HS256']));
    $payload = base64_encode(json_encode([
        'user_id' => $userId,
        'email' => $email,
        'iat' => time(),
        'exp' => time() + (7 * 24 * 60 * 60) // 7 gün
    ]));
    $signature = base64_encode(hash_hmac('sha256', "$header.$payload", JWT_SECRET, true));
    return "$header.$payload.$signature";
}

function verifyToken($token) {
    $parts = explode('.', $token);
    if (count($parts) !== 3) return null;
    
    [$header, $payload, $signature] = $parts;
    $validSignature = base64_encode(hash_hmac('sha256', "$header.$payload", JWT_SECRET, true));
    
    if ($signature !== $validSignature) return null;
    
    $data = json_decode(base64_decode($payload), true);
    if ($data['exp'] < time()) return null;
    
    return $data;
}
```

### utils/auth_middleware.php

```php
<?php
require_once __DIR__ . '/jwt.php';

function authenticate() {
    $headers = getallheaders();
    $authHeader = $headers['Authorization'] ?? $headers['authorization'] ?? '';
    
    if (empty($authHeader) || !preg_match('/Bearer\s+(.*)$/i', $authHeader, $matches)) {
        http_response_code(401);
        echo json_encode(['success' => false, 'message' => 'Token gerekli']);
        exit;
    }
    
    $token = $matches[1];
    $userData = verifyToken($token);
    
    if (!$userData) {
        http_response_code(401);
        echo json_encode(['success' => false, 'message' => 'Geçersiz veya süresi dolmuş token']);
        exit;
    }
    
    return $userData;
}
```

---

## 🔐 API Endpoint'leri

### 1. Kullanıcı Kaydı - POST /auth/register.php

**Request:**
```json
{
  "name": "Test User",
  "email": "test@example.com",
  "password": "123456",
  "phone": "5551234567"  // Opsiyonel
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Kayıt başarılı",
  "user": {
    "id": 1,
    "name": "Test User",
    "email": "test@example.com",
    "phone": "5551234567",
    "avatar": null,
    "bio": null,
    "created_at": "2026-01-17 12:00:00",
    "updated_at": "2026-01-17 12:00:00"
  },
  "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
}
```

**Error Response (400):**
```json
{
  "success": false,
  "message": "Bu email zaten kayıtlı"
}
```

**PHP Kodu:**
```php
<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

require_once '../config/database.php';
require_once '../utils/jwt.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);

$name = trim($data['name'] ?? '');
$email = trim($data['email'] ?? '');
$password = $data['password'] ?? '';
$phone = trim($data['phone'] ?? '');

// Validasyon
if (empty($name) || empty($email) || empty($password)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Ad, email ve şifre gerekli']);
    exit;
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Geçersiz email formatı']);
    exit;
}

if (strlen($password) < 6) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Şifre en az 6 karakter olmalı']);
    exit;
}

$conn = getConnection();

// Email kontrolü
$stmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
$stmt->execute([$email]);
if ($stmt->fetch()) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Bu email zaten kayıtlı']);
    exit;
}

// Kullanıcı oluştur
$hashedPassword = password_hash($password, PASSWORD_DEFAULT);
$stmt = $conn->prepare("INSERT INTO users (name, email, password, phone) VALUES (?, ?, ?, ?)");
$stmt->execute([$name, $email, $hashedPassword, $phone ?: null]);

$userId = $conn->lastInsertId();

// Kullanıcıyı getir
$stmt = $conn->prepare("SELECT id, name, email, phone, avatar, bio, created_at, updated_at FROM users WHERE id = ?");
$stmt->execute([$userId]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

// Token oluştur
$token = generateToken($userId, $email);

echo json_encode([
    'success' => true,
    'message' => 'Kayıt başarılı',
    'user' => $user,
    'token' => $token
]);
```

---

### 2. Kullanıcı Girişi - POST /auth/login.php

**Request:**
```json
{
  "email": "test@example.com",
  "password": "123456"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Giriş başarılı",
  "user": {
    "id": 1,
    "name": "Test User",
    "email": "test@example.com",
    "phone": "5551234567",
    "avatar": "https://example.com/avatars/user1.jpg",
    "bio": "Kitap kurdu",
    "created_at": "2026-01-17 12:00:00",
    "updated_at": "2026-01-17 12:00:00"
  },
  "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
}
```

**Error Response (401):**
```json
{
  "success": false,
  "message": "Email veya şifre hatalı"
}
```

**PHP Kodu:**
```php
<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

require_once '../config/database.php';
require_once '../utils/jwt.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);

$email = trim($data['email'] ?? '');
$password = $data['password'] ?? '';

if (empty($email) || empty($password)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Email ve şifre gerekli']);
    exit;
}

$conn = getConnection();

$stmt = $conn->prepare("SELECT * FROM users WHERE email = ?");
$stmt->execute([$email]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user || !password_verify($password, $user['password'])) {
    http_response_code(401);
    echo json_encode(['success' => false, 'message' => 'Email veya şifre hatalı']);
    exit;
}

// Şifreyi yanıttan çıkar
unset($user['password']);

$token = generateToken($user['id'], $user['email']);

echo json_encode([
    'success' => true,
    'message' => 'Giriş başarılı',
    'user' => $user,
    'token' => $token
]);
```

---

### 3. Profil Getir - GET /auth/profile.php

**Headers:**
```
Authorization: Bearer <token>
```

**Success Response (200):**
```json
{
  "success": true,
  "user": {
    "id": 1,
    "name": "Test User",
    "email": "test@example.com",
    "phone": "5551234567",
    "avatar": "https://example.com/avatars/user1.jpg",
    "bio": "Kitap kurdu",
    "created_at": "2026-01-17 12:00:00",
    "updated_at": "2026-01-17 12:00:00"
  }
}
```

**PHP Kodu:**
```php
<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');

require_once '../config/database.php';
require_once '../utils/auth_middleware.php';

$userData = authenticate();

$conn = getConnection();
$stmt = $conn->prepare("SELECT id, name, email, phone, avatar, bio, created_at, updated_at FROM users WHERE id = ?");
$stmt->execute([$userData['user_id']]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user) {
    http_response_code(404);
    echo json_encode(['success' => false, 'message' => 'Kullanıcı bulunamadı']);
    exit;
}

echo json_encode([
    'success' => true,
    'user' => $user
]);
```

---

### 4. Profil Güncelle - POST /auth/update_profile.php

**Headers:**
```
Authorization: Bearer <token>
```

**Request:**
```json
{
  "name": "Updated Name",
  "phone": "5559876543",
  "bio": "Yeni biyografi"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Profil güncellendi",
  "user": {
    "id": 1,
    "name": "Updated Name",
    "email": "test@example.com",
    "phone": "5559876543",
    "avatar": "https://example.com/avatars/user1.jpg",
    "bio": "Yeni biyografi",
    "created_at": "2026-01-17 12:00:00",
    "updated_at": "2026-01-17 13:00:00"
  }
}
```

**PHP Kodu:**
```php
<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

require_once '../config/database.php';
require_once '../utils/auth_middleware.php';

$userData = authenticate();

$data = json_decode(file_get_contents('php://input'), true);

$name = trim($data['name'] ?? '');
$phone = $data['phone'] ?? null;
$bio = $data['bio'] ?? null;

if (empty($name)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Ad gerekli']);
    exit;
}

$conn = getConnection();

$stmt = $conn->prepare("UPDATE users SET name = ?, phone = ?, bio = ?, updated_at = NOW() WHERE id = ?");
$stmt->execute([$name, $phone, $bio, $userData['user_id']]);

// Güncellenmiş kullanıcıyı getir
$stmt = $conn->prepare("SELECT id, name, email, phone, avatar, bio, created_at, updated_at FROM users WHERE id = ?");
$stmt->execute([$userData['user_id']]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

echo json_encode([
    'success' => true,
    'message' => 'Profil güncellendi',
    'user' => $user
]);
```

---

### 5. Avatar Güncelle - POST /auth/update_avatar.php

**Headers:**
```
Authorization: Bearer <token>
Content-Type: multipart/form-data
```

**Request (form-data):**
```
avatar: [file]
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Avatar güncellendi",
  "user": {
    "id": 1,
    "name": "Test User",
    "email": "test@example.com",
    "phone": "5551234567",
    "avatar": "https://example.com/avatars/1_1705500000.jpg",
    "bio": "Kitap kurdu",
    "created_at": "2026-01-17 12:00:00",
    "updated_at": "2026-01-17 13:00:00"
  }
}
```

**PHP Kodu:**
```php
<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

require_once '../config/database.php';
require_once '../utils/auth_middleware.php';

$userData = authenticate();

if (!isset($_FILES['avatar'])) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Avatar dosyası gerekli']);
    exit;
}

$file = $_FILES['avatar'];
$allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];

if (!in_array($file['type'], $allowedTypes)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Geçersiz dosya tipi']);
    exit;
}

if ($file['size'] > 5 * 1024 * 1024) { // 5MB limit
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Dosya çok büyük (max 5MB)']);
    exit;
}

// Dosya adı oluştur
$ext = pathinfo($file['name'], PATHINFO_EXTENSION);
$filename = $userData['user_id'] . '_' . time() . '.' . $ext;
$uploadDir = '../uploads/avatars/';

if (!is_dir($uploadDir)) {
    mkdir($uploadDir, 0755, true);
}

$uploadPath = $uploadDir . $filename;

if (!move_uploaded_file($file['tmp_name'], $uploadPath)) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Dosya yüklenemedi']);
    exit;
}

// Avatar URL'i oluştur
$baseUrl = 'https://yourdomain.com/api/uploads/avatars/'; // Değiştirin!
$avatarUrl = $baseUrl . $filename;

$conn = getConnection();

// Eski avatarı sil
$stmt = $conn->prepare("SELECT avatar FROM users WHERE id = ?");
$stmt->execute([$userData['user_id']]);
$oldAvatar = $stmt->fetchColumn();
if ($oldAvatar) {
    $oldFile = $uploadDir . basename($oldAvatar);
    if (file_exists($oldFile)) {
        unlink($oldFile);
    }
}

// Yeni avatarı kaydet
$stmt = $conn->prepare("UPDATE users SET avatar = ?, updated_at = NOW() WHERE id = ?");
$stmt->execute([$avatarUrl, $userData['user_id']]);

// Güncellenmiş kullanıcıyı getir
$stmt = $conn->prepare("SELECT id, name, email, phone, avatar, bio, created_at, updated_at FROM users WHERE id = ?");
$stmt->execute([$userData['user_id']]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

echo json_encode([
    'success' => true,
    'message' => 'Avatar güncellendi',
    'user' => $user
]);
```

---

### 6. Şifre Değiştir - POST /auth/change_password.php

**Headers:**
```
Authorization: Bearer <token>
```

**Request:**
```json
{
  "current_password": "123456",
  "new_password": "newpassword123"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Şifre değiştirildi"
}
```

**Error Response (400):**
```json
{
  "success": false,
  "message": "Mevcut şifre hatalı"
}
```

**PHP Kodu:**
```php
<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

require_once '../config/database.php';
require_once '../utils/auth_middleware.php';

$userData = authenticate();

$data = json_decode(file_get_contents('php://input'), true);

$currentPassword = $data['current_password'] ?? '';
$newPassword = $data['new_password'] ?? '';

if (empty($currentPassword) || empty($newPassword)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Tüm alanlar gerekli']);
    exit;
}

if (strlen($newPassword) < 6) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Yeni şifre en az 6 karakter olmalı']);
    exit;
}

$conn = getConnection();

// Mevcut şifreyi kontrol et
$stmt = $conn->prepare("SELECT password FROM users WHERE id = ?");
$stmt->execute([$userData['user_id']]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!password_verify($currentPassword, $user['password'])) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Mevcut şifre hatalı']);
    exit;
}

// Yeni şifreyi kaydet
$hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);
$stmt = $conn->prepare("UPDATE users SET password = ?, updated_at = NOW() WHERE id = ?");
$stmt->execute([$hashedPassword, $userData['user_id']]);

echo json_encode([
    'success' => true,
    'message' => 'Şifre değiştirildi'
]);
```

---

### 7. Şifre Sıfırlama İsteği - POST /auth/forgot_password.php

**Request:**
```json
{
  "email": "test@example.com"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Şifre sıfırlama kodu emailinize gönderildi"
}
```

**PHP Kodu:**
```php
<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

require_once '../config/database.php';

$data = json_decode(file_get_contents('php://input'), true);
$email = trim($data['email'] ?? '');

if (empty($email)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Email gerekli']);
    exit;
}

$conn = getConnection();

// Email kontrol
$stmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
$stmt->execute([$email]);
if (!$stmt->fetch()) {
    // Güvenlik için yine de başarılı mesaj döner
    echo json_encode(['success' => true, 'message' => 'Şifre sıfırlama kodu emailinize gönderildi']);
    exit;
}

// 6 haneli kod oluştur
$token = str_pad(random_int(0, 999999), 6, '0', STR_PAD_LEFT);
$expiresAt = date('Y-m-d H:i:s', strtotime('+15 minutes'));

// Eski tokenları sil
$stmt = $conn->prepare("DELETE FROM password_resets WHERE email = ?");
$stmt->execute([$email]);

// Yeni token kaydet
$stmt = $conn->prepare("INSERT INTO password_resets (email, token, expires_at) VALUES (?, ?, ?)");
$stmt->execute([$email, $token, $expiresAt]);

// Email gönder (kendi email fonksiyonunuzla değiştirin)
// mail($email, "Şifre Sıfırlama Kodu", "Kodunuz: $token");

// Development için kodu response'da döndürüyoruz (production'da kaldırın!)
echo json_encode([
    'success' => true,
    'message' => 'Şifre sıfırlama kodu emailinize gönderildi',
    'debug_token' => $token // ⚠️ Production'da bu satırı kaldırın!
]);
```

---

### 8. Şifre Sıfırlama - POST /auth/reset_password.php

**Request:**
```json
{
  "email": "test@example.com",
  "token": "123456",
  "password": "newpassword123"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Şifre başarıyla sıfırlandı"
}
```

**Error Response (400):**
```json
{
  "success": false,
  "message": "Geçersiz veya süresi dolmuş kod"
}
```

**PHP Kodu:**
```php
<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

require_once '../config/database.php';

$data = json_decode(file_get_contents('php://input'), true);

$email = trim($data['email'] ?? '');
$token = trim($data['token'] ?? '');
$password = $data['password'] ?? '';

if (empty($email) || empty($token) || empty($password)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Tüm alanlar gerekli']);
    exit;
}

if (strlen($password) < 6) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Şifre en az 6 karakter olmalı']);
    exit;
}

$conn = getConnection();

// Token kontrol
$stmt = $conn->prepare("SELECT * FROM password_resets WHERE email = ? AND token = ? AND expires_at > NOW()");
$stmt->execute([$email, $token]);
$reset = $stmt->fetch();

if (!$reset) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Geçersiz veya süresi dolmuş kod']);
    exit;
}

// Şifreyi güncelle
$hashedPassword = password_hash($password, PASSWORD_DEFAULT);
$stmt = $conn->prepare("UPDATE users SET password = ?, updated_at = NOW() WHERE email = ?");
$stmt->execute([$hashedPassword, $email]);

// Token'ı sil
$stmt = $conn->prepare("DELETE FROM password_resets WHERE email = ?");
$stmt->execute([$email]);

echo json_encode([
    'success' => true,
    'message' => 'Şifre başarıyla sıfırlandı'
]);
```

---

### 9. Çıkış Yap - POST /auth/logout.php

**Headers:**
```
Authorization: Bearer <token>
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Çıkış yapıldı"
}
```

**PHP Kodu:**
```php
<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

// Opsiyonel: Token'ı blacklist'e ekleyebilirsiniz
echo json_encode([
    'success' => true,
    'message' => 'Çıkış yapıldı'
]);
```

---

### 10. Hesap Silme - POST /auth/delete_account.php

**Headers:**
```
Authorization: Bearer <token>
```

**Request:**
```json
{
  "password": "123456"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Hesap silindi"
}
```

**PHP Kodu:**
```php
<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

require_once '../config/database.php';
require_once '../utils/auth_middleware.php';

$userData = authenticate();

$data = json_decode(file_get_contents('php://input'), true);
$password = $data['password'] ?? '';

if (empty($password)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Şifre gerekli']);
    exit;
}

$conn = getConnection();

// Şifreyi kontrol et
$stmt = $conn->prepare("SELECT password FROM users WHERE id = ?");
$stmt->execute([$userData['user_id']]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!password_verify($password, $user['password'])) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Şifre hatalı']);
    exit;
}

// Kullanıcıyı sil
$stmt = $conn->prepare("DELETE FROM users WHERE id = ?");
$stmt->execute([$userData['user_id']]);

echo json_encode([
    'success' => true,
    'message' => 'Hesap silindi'
]);
```

---

## 🔑 Flutter Tarafında Kullanım

### NetworkUtils.dart'ta Header Ayarları

Token'ın header'a eklenmesi için `buildHeaderTokens()` fonksiyonunu güncelleyin:

```dart
Map<String, String> buildHeaderTokens() {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // AuthStore'dan token'ı al
  if (authStore.authToken != null && authStore.authToken!.isNotEmpty) {
    headers['Authorization'] = 'Bearer ${authStore.authToken}';
  }
  
  return headers;
}
```

---

## ⚠️ Önemli Güvenlik Notları

1. **JWT_SECRET**: Minimum 32 karakter, rastgele ve güçlü olmalı
2. **HTTPS**: Production'da mutlaka HTTPS kullanın
3. **Password**: `password_hash()` ve `password_verify()` kullanın
4. **SQL Injection**: Prepared statements kullanın (PDO)
5. **File Upload**: Dosya tipini ve boyutunu kontrol edin
6. **CORS**: Production'da spesifik origin'lere izin verin
7. **Rate Limiting**: Brute force saldırılarına karşı koruma ekleyin

---

## 📝 API Base URL

Flutter'da `lib/utils/constant.dart` dosyasındaki `mDomainUrl` değerini güncelleyin:

```dart
const mDomainUrl = "https://yourdomain.com/api/";
```

---

## ✅ Checklist

- [ ] Veritabanı tablolarını oluştur
- [ ] config/database.php'yi düzenle
- [ ] JWT_SECRET'ı değiştir
- [ ] Avatar upload dizinini oluştur
- [ ] HTTPS ayarla
- [ ] Flutter'da mDomainUrl'i güncelle
- [ ] Email gönderim fonksiyonunu ekle
