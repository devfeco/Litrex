# API Abonelik ve Doğrulama Sistemi Geliştirme Rehberi

Bu döküman, mobil uygulamada yapılan "Restore Subscription" (Abonelik Geri Yükleme) ve sıkılaştırılmış satın alma doğrulama süreçlerini desteklemek için API tarafında yapılması gereken iyileştirmeleri ve güvenlik önlemlerini detaylandırmaktadır.

---

## 1. Genel Güvenlik ve Kimlik Doğrulama (Top-Priority)

Uygulamanın her isteğinde `Authorization: Bearer <token>` gönderilmesi sağlandı. API tarafında şu kontroller ZORUNLU hale getirilmelidir:

- **Token Validasyonu**: Her istekte gelen Bearer token'ın geçerliliği kontrol edilmelidir. Geçersiz veya süresi dolmuş tokenlar için `401 Unauthorized` dönülmelidir.
- **Oturum Çakışması (409 Conflict)**: Eğer kullanıcı başka bir cihazda oturum açtıysa, eski token geçersiz kılınmalı ve `409 Conflict` hata kodu dönülmelidir. (Uygulama bu kodu aldığında otomatik çıkış yapar).

---

## 2. Abonelik Doğrulama Uç Noktası (`OST_premium_status.php`)

Bu endpoint, hem yeni satın alımlar hem de "Geri Yükle" (Restore) işlemleri için tek merkezdir.

### İstenen Parametreler (POST)
```json
{
  "purchase_token": "google_play_purchase_token_string",
  "product_id": "premium_monthly",
  "order_id": "GPA.33xx-xxxx-xxxx-xxxxx",
  "purchase_time": "16123456789",
  "type": "android"
}
```

### API Tarafında Yapılması Gereken İşlemler:

1.  **Sunucu Taraflı Doğrulama (Server-Side Verification)**:
    - Gelen `purchase_token` ve `product_id` kullanılarak **Google Play Developer API** üzerinden doğrulama yapılmalıdır. 
    - Uygulama içinden gelen veriye asla %100 güvenilmemelidir. Google API'den dönen `purchaseState: 0` (Purchased) durumu kontrol edilmelidir.

2.  **Mükerrer Kayıt Kontrolü (Idempotency)**:
    - Bir `order_id` veya `purchase_token` veri tabanında daha önce başka bir kullanıcı adına kaydedilmiş mi kontrol edilmelidir (Fraud protection).
    - Eğer aynı kullanıcı aynı token ile tekrar gelirse (Restore durumu), hata vermek yerine "Zaten Aktif" olarak işlem başarılı sayılmalı ve güncel kullanıcı verisi dönülmelidir.

3.  **Veritabanı Güncelleme**:
    - Kullanıcının `is_premium` alanı `1` yapılmalıdır.
    - Google'dan gelen `expiryTimeMillis` değerine göre kullanıcının `premium_expiry_date` alanı güncellenmelidir.
    - Opsiyonel: `purchases` adında bir log tablosuna tüm transaction detayları (`order_id`, `token`, `amount`, `date`) kaydedilmelidir.

### Başarılı Yanıt Formatı:
```json
{
  "success": true,
  "message": "Premium status updated successfully",
  "user": {
    "id": 1,
    "name": "Ahmet Yılmaz",
    "email": "ahmet@example.com",
    "is_premium": 1,
    "premium_expiry_date": "2026-03-16 21:00:00",
    "status": "active",
    "token": "current_auth_token"
  }
}
```

---

## 3. "Restore" (Geri Yükleme) Mekanizması Nasıl Çalışır?

Kullanıcı uygulamada "Satın Alımları Geri Yükle" butonuna bastığında:
1. Flutter, Google Play'den daha önce satın alınmış tüm ürünleri sorgular.
2. Google Play, kullanıcıya ait tüm geçerli abonelikleri döner.
3. Uygulama, her bir abonelik için API'deki `OST_premium_status.php` adresine istek atar.
4. **API'nin görevi:** Eğer bu abonelik veritabanında bu kullanıcı için kayıtlı değilse kaydetmek, kayıtlıysa durumu teyit edip kullanıcıyı Premium olarak işaretlemektir.

---

## 4. Kritik Kontrol Listesi (Backend)

- [ ] **Google Play Service Account**: API'nin Google ile konuşabilmesi için bir Service Account `.json` dosyası ve gerekli kütüphane kurulumu yapıldı mı?
- [ ] **Abonelik İptali Takibi**: Google Real-Time Developer Notifications (RTDN) kullanılarak aboneliğini iptal eden veya süresi dolan kullanıcıların otomatik olarak Premium yetkisinin alınması sağlandı mı?
- [ ] **Middleware**: Tüm `/api/auth/` altındaki isteklere token zorunluluğu getiren bir middleware eklendi mi?

---

## 5. Veritabanı Önerisi

Aboneliklerin takibi için şu alanların olması tavsiye edilir:
```sql
ALTER TABLE users ADD COLUMN is_premium TINYINT(1) DEFAULT 0;
ALTER TABLE users ADD COLUMN premium_expiry_date DATETIME DEFAULT NULL;
ALTER TABLE users ADD COLUMN last_purchase_token TEXT DEFAULT NULL;
```
