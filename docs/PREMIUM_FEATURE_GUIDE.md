# Premium Özelliği & Uygulama İçi Satın Alma Entegrasyon Kılavuzu

Bu kılavuz, uygulamanızdaki Premium (Abonelik) özelliğini Google Play Console üzerinden canlıya almak ve başarıyla çalıştırmak için izlemeniz gereken adımları içerir. Demo modları kaldırıldı, artık üretim (production) için hazırsınız.

## 1. Backend İşlemleri (PHP API & Veritabanı)

Uygulamanın kullanıcılarınızın premium olup olmadığını anlaması için veritabanında ve API tarafında bu değişiklikleri yapmalısınız.

### Adım 1.1: Veritabanı Güncellemesi
Mevcut `users` veya kullanıcı tablonuza aşağıdaki kolonları ekleyin.

```sql
ALTER TABLE `users`
ADD COLUMN `is_premium` TINYINT(1) DEFAULT 0,
ADD COLUMN `premium_expiry_date` DATETIME NULL,
ADD COLUMN `subscription_id` VARCHAR(255) NULL;
```

### Adım 1.2: Doğrulama Endpoints (PHP)
Uygulama satın alma başarılı olduğunda bu endpoint'e istek atacak. `premium_status.php` gibi bir dosya oluşturun:

**Önemli:** Güvenlik için Google Play Developer API kullanarak sunucu taraflı doğrulama (Server-side Verification) yapılması şiddetle önerilir. Ancak başlangıç için basit mantık şöyledir:

`POST /api/premium_status.php`
```php
<?php
include 'db_connect.php'; // Kendi DB bağlantınızı dahil edin

$user_id = $_POST['user_id'];
$product_id = $_POST['product_id']; // premium_monthly veya premium_quarterly
$purchase_token = $_POST['purchase_token'];

// Süre hesapla
$duration = "+1 month";
if (strpos($product_id, 'quarterly') !== false) {
    $duration = "+3 month";
}

$expiry_date = date('Y-m-d H:i:s', strtotime($duration));

// Kullanıcıyı güncelle
$sql = "UPDATE users SET is_premium=1, premium_expiry_date='$expiry_date', subscription_id='$purchase_token' WHERE id='$user_id'";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["status" => "success", "message" => "Premium aktif edildi", "expiry_date" => $expiry_date]);
} else {
    echo json_encode(["status" => "error", "message" => "Veritabanı hatası"]);
}
?>
```

## 2. Google Play Console Kurulumu (Kritik)

Uygulama içi satın alımların çalışması için bu adımları **kesinlikle** yapmalısınız.

### Adım 2.1: Merchant Hesabı
*   Google Play Console menüsünde **Setup > Payments profile** (Ödeme profili) kısmına gidin ve bir ödeme hesabı oluşturun. Bu olmadan ücretli ürün satamazsınız.

### Adım 2.2: Abonelik Oluşturma
*   Console'da uygulamanızı seçin.
*   Soldaki menüden **Monetize > Products > Subscriptions** (Abonelikler) kısmına gidin.
*   **Create Subscription** deyin.

**Ürün 1 (Aylık):**
*   **Product ID:** `premium_monthly` (Kod içinde bu ID kullanıldı, aynısı olmalı!)
*   **Name:** Aylık Premium
*   **Base Plan:** Auto-renewing, Monthly, Fiyat belirleyin (Örn: 49.99 TRY).

**Ürün 2 (3 Aylık):**
*   **Product ID:** `premium_quarterly` (Kod içinde bu ID kullanıldı!)
*   **Name:** 3 Aylık Premium
*   **Base Plan:** Auto-renewing, 3 Months, Fiyat belirleyin (Örn: 129.99 TRY).

### Adım 2.3: Lisans Testçileri (License Testing)
Gerçek para harcamadan test etmek için:
*   Console Ana Menü -> **Setup > License Testing**
*   Test yapacağınız Gmail adreslerini buraya ekleyin.
*   **License response** kısmını `RESPOND_NORMALLY` seçin.

## 3. Uygulama Testi

### Adım 3.1: İmzalı Sürüm (Signed APK/AAB)
*   **Debug modunda (flutter run) In-App Purchase çalışmayabilir.**
*   Uygulamanızı imzalayarak bir **App Bundle (.aab)** oluşturun: `flutter build appbundle`
*   Bu sürümü Google Play Console'da **Internal Testing** (Dahili Test) kanalına yükleyin.

### Adım 3.2: Test Cihazı
*   Internal Testing'e eklediğiniz mail adresiyle giriş yapılmış gerçek bir Android cihaz kullanın.
*   Emülatör kullanacaksanız, **Google Play Store** içeren bir emülatör imajı olduğundan emin olun ve lisans testçisi hesabınızla Play Store'a giriş yapın.

## 4. Sorun Giderme

*   **"Ürünler bulunamadı" hatası alıyorum:**
    *   Uygulama yayında mı (Internal/Alpha/Beta)? Taslak modu bazen yetmez.
    *   Product ID'ler (`premium_monthly`) Console ile birebir aynı mı?
    *   Test cihazındaki Google hesabı, Lisans Testçileri listesinde var mı?
    
*   **Satın alma gerçekleşiyor ama backend güncellenmiyor:**
    *   `_verifyPurchase` metodundaki API çağrısını kontrol edin.
    *   Sunucunuzun loglarını inceleyin.
