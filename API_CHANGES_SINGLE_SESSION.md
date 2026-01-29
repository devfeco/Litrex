# Tek Oturum (Single Session) & Cihaz Kontrolü API Gereksinimleri (API_CHANGES_SINGLE_SESSION.md)

Bu belge, uygulamanın aynı anda sadece tek bir cihazda aktif olmasını sağlamak için backend tarafında yapılması gereken değişiklikleri kapsar.

## Amaç
Bir kullanıcı yeni bir cihazdan giriş yaptığında, eski cihazdaki oturumun otomatik olarak sonlanması ve uygulamanın kullanıcıyı çıkışa zorlaması (indirilen içeriklerin silinmesi dahil).

## Yapılması Gerekenler

### 1. Veritabanı Güncellemesi
`users` tablosunda `device_id` sütununun olduğundan emin olun (Varchar/String).

### 2. Login Endpoint (`auth/login.php`)
Kullanıcı giriş yaptığında:
1.  Gelen `device_id` verisini `users` tablosunda ilgili kullanıcı için güncelleyin.
2.  Oluşturulan **JWT Token** içerisine (payload kısmına) bu `device_id` bilgisini ekleyin.

**Örnek Token Payload:**
```json
{
  "iss": "litresfer.com",
  "iat": 1678886400,
  "exp": 1679491200,
  "sub": "123", (User ID)
  "device_id": "android_id_123456789" // EKLENECEK ALAN
}
```

### 3. Auth Middleware / Token Doğrulama
Sisteme gelen **HER** kimlik doğrulamalı (Bearer Token içeren) istekte aşağıdaki kontrol yapılmalıdır.
**ÖNEMLİ:** Bu kontrol, özellikle uygulama açılışında çağrılan `auth/check_reset.php` veya `auth/profile.php` gibi endpoint'lerde **kesinlikle** uygulanmalıdır. Aksi takdirde uygulama açılışta oturumun düştüğünü anlayamaz.

1.  Token decode edilir ve içindeki `sub` (user_id) ve `device_id` okunur.
2.  Veritabanından bu kullanıcının (`user_id`) güncel `device_id` değeri sorgulanır.
3.  **Kritik Kontrol:**
    -   Eğer **Token içindeki device_id** != **Veritabanındaki güncel device_id** ise;
    -   Bu, kullanıcının bu token'ı aldıktan sonra başka bir cihazdan giriş yaptığı anlamına gelir.
    -   İstek reddedilmeli ve **409 Conflict** kodu dönülmelidir.

### 4. Hata Yanıtı (409 Conflict)
Eşleşme sağlanmadığında dönülecek HTTP Status Code: **409**
JSON Body:
```json
{
  "success": false,
  "message": "Oturumunuz başka bir cihazda açıldığı için sonlandırıldı."
}
```

## Akış Örneği
1.  Kullanıcı **Cihaz A** ile giriş yapar. DB'ye Cihaz A ID'si yazılır. Token A üretilir (içinde Cihaz A ID var).
2.  Kullanıcı **Cihaz B** ile giriş yapar. DB güncellenir (Cihaz B ID). Token B üretilir.
3.  Kullanıcı **Cihaz A** ile bir istek atar (Token A ile).
4.  Backend kontrol eder: Token A içindeki ID (Cihaz A) != DB'deki güncel ID (Cihaz B).
5.  Backend **409** hatası döner.
6.  Mobil uygulama 409 hatasını yakalar, yerel verileri (indirilen kitaplar) siler ve kullanıcıyı giriş ekranına atar.
