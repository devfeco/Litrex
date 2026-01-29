# Backend Satın Alım Doğrulama (OST_premium_status.php)

Bu belge, uygulamanın `OST_premium_status.php` dosyasında (veya ilgili route'unda) yapması gereken işlemleri adım adım anlatır. Uygulama tarafında yapılan son güncellemelerle birlikte, backend artık `type` ('android' veya 'ios') parametresini de almaktadır.

## Endpoint Özellikleri

- **URL**: `/api/OST_premium_status.php`
- **Method**: POST
- **Header**: `Authorization: Bearer <user_token>` (Kullanıcı giriş yapmış olmalı)

## Gelen İstek Parametreleri (JSON veya POST body)

| Parametre | Tip | Açıklama |
| :--- | :--- | :--- |
| `purchase_token` | String | Google Play'den gelen doğrulama tokenı (Android) veya Receipt Data (iOS). |
| `product_id` | String | Satın alınan ürün ID'si (örn: `premium_monthly`). |
| `order_id` | String | Benzersiz sipariş numarası (GPA.xxxx...). |
| `type` | String | İşletim sistemi: `'android'` veya `'ios'`. |
| `purchase_time` | String | İşlem zamanı (loglama için opsiyonel). |

---

## Backend İşleyiş Mantığı

### 1. Kimlik ve Girdi Kontrolü
1.  Gelen `Bearer` token ile kullanıcının oturumu doğrulanmalı ve `user_id` elde edilmelidir.
2.  Gerekli parametrelerin (`purchase_token`, `order_id`, `type`) dolu olduğu kontrol edilmelidir.

### 2. Çift İşlem Kontrolü (Anti-Fraud)
1.  Veritabanınızda `transactions` tablosunu kontrol edin.
2.  Eğer gelen `order_id` daha önce veritabanına kaydedilmişse ve `status = 'success'` ise:
    *   İşlemi tekrar yapmaya gerek yoktur.
    *   Direkt olarak `success: true` dönün (Kullanıcı restore işlemi yapıyor olabilir).
    *   HATA DÖNMEYİN, çünkü kullanıcı parayı ödemiştir, sadece app tarafında flush edilememiştir.

### 3. Platform Bazlı Doğrulama

#### DURUM A: Android (`type == 'android'`)
Google Play Developer API'yi kullanarak token'ı doğrulamanız gerekir.

1.  **Google Client Kütüphanesi**: PHP için `google/apiclient` kütüphanesini kullanın.
2.  **Service Account**: Google Play Console'dan indirdiğiniz `.json` anahtar dosyasını sunucuda güvenli bir yere koyun.
3.  **Doğrulama İsteği**:
    ```php
    $client = new Google_Client();
    $client->setAuthConfig('/path/to/service-account.json');
    $client->addScope('https://www.googleapis.com/auth/androidpublisher');
    
    $service = new Google_Service_AndroidPublisher($client);
    $packageName = 'com.litrex.ebook'; // App package name
    
    try {
        // Token'ı Google'a sor
        $purchase = $service->purchases_subscriptions->get($packageName, $product_id, $purchase_token);
        
        // Ödeme Durumu Kontrolü
        // paymentState: 1 (Payment Received), 2 (Free Trial), 0 (Pending)
        if ($purchase->paymentState !== 1 && $purchase->paymentState !== 2) {
             throw new Exception("Ödeme henüz tamamlanmadı veya başarısız.");
        }
    } catch (Exception $e) {
        // Token geçersiz veya Google hatası
        return json_encode(['success' => false, 'message' => 'Google doğrulama hatası: ' . $e->getMessage()]);
    }
    ```

#### DURUM B: iOS (`type == 'ios'`)
Apple Verify Receipt endpoint'ini kullanın.
*   Sandbox (Test): `https://sandbox.itunes.apple.com/verifyReceipt`
*   Production: `https://buy.itunes.apple.com/verifyReceipt`
*   Status `0` dönerse başarılıdır.

### 4. İşlem Kaydı ve Premium Verme
Doğrulama başarılıysa:

1.  **Users Tablosunu Güncelle**:
    *   Kullanıcının `is_premium` alanını `1` yapın.
    *   Varsa `premium_expires_at` (bitiş tarihi) güncelleyin.
        *   `product_id` içinde 'monthly' geçiyorsa +1 ay.
        *   'quarterly' geçiyorsa +3 ay.
2.  **İşlem Kaydı (Log)**:
    *   `transactions` tablosuna `user_id`, `order_id`, `amount`, `provider` (Google/Apple), `status` ('success') kaydedin.

### 5. Başarılı Yanıt Formatı
Uygulamanın beklediği format şu şekildedir:

```json
{
  "success": true,
  "message": "Premium başarıyla aktif edildi.",
  "user": {
      "id": 123,
      "name": "Ahmet",
      "email": "...",
      "is_premium": 1,
      // ... diğer güncel kullanıcı bilgileri
  }
}
```

### 6. Hatalı Yanıt Formatı

```json
{
  "success": false,
  "message": "Doğrulama hatası: Geçersiz token."
}
```

## Özet Akış Şeması
1. App -> API (Token + OrderID ile istek atar)
2. API -> Google/Apple (Token geçerli mi?)
3. Google/Apple -> API (Evet, geçerli)
4. API -> DB (Kullanıcıyı Premium yap, siparişi kaydet)
5. API -> App (Success: true)
6. App -> Google/Apple (CompletePurchase - Siparişi kapat)
