# Backend Avatar Yükleme API Gereksinimleri (API_CHANGES_AVATAR.md)

Bu belge, Flutter uygulamasındaki avatar güncelleme fonksiyonunun çalışabilmesi için backend tarafında oluşturulması gereken API endpoint'ini detaylandırır.

## Mevcut Durum
Flutter uygulamasında `EditProfileScreen.dart` ve `AuthApis.dart` dosyaları `auth/update_avatar.php` endpoint'ine istek göndermektedir. Ancak bu endpoint backend'de mevcut değildir.

## Yapılması Gerekenler

Backend tarafında `auth` klasörü altında `update_avatar.php` dosyası oluşturulmalı ve aşağıdaki özelliklere sahip olmalıdır.

### Endpoint Özellikleri

- **URL**: `/api/auth/update_avatar.php`
- **Method**: POST
- **Content-Type**: `multipart/form-data`
- **Header**: `Authorization: Bearer <user_token>` (Kullanıcı doğrulaması için)

### İstek Parametreleri (Body)

| Parametre | Tip | Zorunlu | Açıklama |
| :--- | :--- | :--- | :--- |
| `avatar` | File (Binary) | Evet | Yüklenecek resim dosyası. (jpg, png, jpeg) |

### İşleyiş Mantığı

1.  **Kimlik Doğrulama**:
    -   Header'dan gelen Bearer token ile kullanıcının oturum açmış olduğu doğrulanmalıdır.
    -   Geçersiz token durumunda `401 Unauthorized` dönülmelidir.

2.  **Dosya Kontrolü**:
    -   Gelen isteğin bir dosya içerip içermediği kontrol edilmelidir.
    -   Dosya türü (mime-type) kontrol edilmelidir (sadece resim dosyaları kabul edilmelidir).
    -   Dosya boyutu kontrol edilebilir (örn. max 5MB).

3.  **Dosya Yükleme**:
    -   Dosya sunucuda uygun bir klasöre (örn. `assets/images/users/` veya `uploads/avatars/`) kaydedilmelidir.
    -   Dosya ismi benzersiz (unique) hale getirilmelidir (örn. `timestamp_userid.jpg`).
    -   (Opsiyonel) Eski avatar dosyası sunucudan silinebilir.

4.  **Veritabanı Güncelleme**:
    -   İlgili kullanıcının `users` tablosundaki `avatar` sütunu, yeni yüklenen dosyanın **tam URL'i** ile güncellenmelidir.
    -   Örn: `https://litresfer.com/uploads/avatars/12345_avatar.jpg`

5.  **Yanıt (Response)**:
    -   Başarılı işlem sonucunda güncel kullanıcı objesini içeren JSON dönülmelidir.

### Örnek Başarılı Yanıt (200 OK)

```json
{
  "success": true,
  "message": "Avatar başarıyla güncellendi.",
  "user": {
    "id": 123,
    "name": "Kullanıcı Adı",
    "email": "user@example.com",
    "avatar": "https://litresfer.com/uploads/avatars/new_avatar_123.jpg",
    "phone": "5551234567",
    "bio": "Merhaba dünya"
    // ... diğer kullanıcı bilgileri
  }
}
```

### Örnek Hata Yanıtı (400 Bad Request)

```json
{
  "success": false,
  "message": "Dosya yüklenemedi. Lütfen geçerli bir resim dosyası seçin."
}
```
