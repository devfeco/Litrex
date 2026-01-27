# Backend Admin Kontrol Rehberi (Sıfırlama ve Banlama)

Bu rehber, uygulama içerisindeki cihaz sıfırlama ve kullanıcı banlama özelliklerinin backend tarafında nasıl uygulanacağını açıklar.

## 1. Veritabanı Değişiklikleri

### Cihaz Sıfırlama (Device Reset)
Cihaz bazlı sıfırlama takibi için `user_devices` gibi bir tablo veya mevcut bir tabloda cihaz ID'lerini tutan bir yapı gereklidir.
- **Tablo:** `device_controls` (veya benzeri)
- **Sütunlar:** `device_id` (VARCHAR), `is_reset_required` (TINYINT: 0 veya 1)

### Kullanıcı Banlama (User Banning)
Kullanıcıların durumunu takip etmek için `users` tablosuna bir sütun eklenmelidir.
- **Tablo:** `users`
- **Sütun:** `status` (VARCHAR: 'active', 'banned', 'suspended' vb.)

---

## 2. API Endpoint Uygulaması

**Endpoint:** `auth/check_reset.php`
**Method:** POST
**Parametreler:** `device_id` (Gerekli), `user_id` (Opsiyonel, auth token üzerinden de alınabilir)

### Örnek PHP Uygulaması (Mantıksal Akış)

```php
<?php
// Gerekli veritabanı bağlantısı ve auth kontrolleri...

$device_id = $_POST['device_id'];
$user_id = $current_user_id; // Token'dan gelen kullanıcı ID

$response = [
    'status' => 'ok',
    'user_status' => 'active'
];

// 1. Kullanıcı Ban Kontrolü
$userQuery = "SELECT status FROM users WHERE id = $user_id";
$user = $db->query($userQuery)->fetch();

if ($user && $user['status'] == 'banned') {
    $response['user_status'] = 'banned';
    $response['status'] = 'banned'; // Uygulama tarafında yedek kontrol
    echo json_encode($response);
    exit;
}

// 2. Cihaz Sıfırlama Kontrolü
$deviceQuery = "SELECT is_reset_required FROM device_controls WHERE device_id = '$device_id'";
$deviceControl = $db->query($deviceQuery)->fetch();

if ($deviceControl && $deviceControl['is_reset_required'] == 1) {
    $response['status'] = 'reset';
    
    // Sıfırlama komutu okundu olarak işaretlenmeli (opsiyonel)
    // $db->query("UPDATE device_controls SET is_reset_required = 0 WHERE device_id = '$device_id'");
}

echo json_encode($response);
?>
```

---

## 3. Admin Panel İşlemleri

### Cihazı Sıfırla Butonu
Admin panelinde bir kullanıcı cihazı seçildiğinde:
1. `device_controls` tablosunda ilgili `device_id` için `is_reset_required` değerini `1` yapın.
2. Uygulama bir sonraki açılışında bu kontrolü yapacak ve indirmeleri silip çıkış yapacaktır.

### Kullanıcıyı Banla Butonu
Admin panelinde bir kullanıcıyı banladığınızda:
1. `users` tablosundaki `status` değerini `'banned'` yapın.
2. Uygulama açılışta veya herhangi bir API isteğinde bu durumu fark edip kullanıcıyı dışarı atacaktır.

## 4. Özet Akış (Frontend & Backend)
1. Uygulama açılır (`SplashScreen`).
2. Uygulama sunucuya `device_id` gönderir (`check_reset.php`).
3. Backend önce kullanıcı banlı mı diye bakar, sonra cihaz sıfırlanmalı mı diye bakar.
4. Yanıt `{"user_status": "banned"}` ise uygulama login ekranına atar.
5. Yanıt `{"status": "reset"}` ise uygulama indirilen kitapları siler ve login ekranına atar.
