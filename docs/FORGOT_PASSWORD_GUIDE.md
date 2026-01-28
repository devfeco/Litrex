# Şifremi Unuttum (Forgot Password) Backend Uygulama Rehberi

Bu belge, "Şifremi Unuttum" özelliğinin Flutter tarafındaki akışına uygun olarak backend (PHP/MySQL) tarafında yapılması gereken değişiklikleri ve kod mantığını içerir.

## 1. Veritabanı Değişiklikleri

Şifre sıfırlama kodlarını güvenli bir şekilde saklamak için yeni bir tabloya ihtiyacımız var.

**Tablo Adı:** `password_resets`

Aşağıdaki SQL komutunu çalıştırarak tabloyu oluşturun:

```sql
CREATE TABLE `password_resets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `token` varchar(10) NOT NULL, -- 6 haneli doğrulama kodu (örn: 123456)
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 2. API Endpointleri

Uygulamanın çalışması için aşağıdaki iki endpoint'in oluşturulması gerekmektedir.

### A. Şifre Sıfırlama Kodu Gönder (`api/auth/forgot_password.php`)

Bu servis, kullanıcının girdiği email adresine 6 haneli bir doğrulama kodu gönderir.

**İstek (Request):**
- Method: `POST`
- Parametreler:
  - `email`: (String) Kullanıcının email adresi.

**Mantık (Logic):**
1.  Gelen `email` adresini veritabanında (`users` tablosunda) kontrol et.
    -   Eğer kullanıcı yoksa: `{"success": false, "message": "Bu email adresi ile kayıtlı kullanıcı bulunamadı."}` dön.
2.  6 haneli rastgele bir kod üret (örn: `123456`).
3.  `password_resets` tablosuna `email` ve `token` (kod) bilgisini kaydet.
    -   *İpucu: Aynı email için eski kayıtları silebilirsiniz veya sadece en sonuncuyu geçerli sayabilirsiniz.*
4.  Kullanıcıya bu kodu içeren bir email gönder.
    -   Email Başlığı: "Şifre Sıfırlama Kodu"
    -   Email İçeriği: "Şifrenizi sıfırlamak için kullanmanız gereken kod: **123456**"
5.  Başarılı yanıt dön: `{"success": true, "message": "Doğrulama kodu email adresinize gönderildi."}`

---

### B. Şifreyi Sıfırla (`api/auth/reset_password.php`)

Bu servis, kullanıcının email adresi, doğrulama kodu ve yeni şifresini alarak şifre güncelleme işlemini yapar.

**İstek (Request):**
- Method: `POST`
- Parametreler:
  - `email`: (String) Kullanıcının email adresi.
  - `token`: (String) Kullanıcının girdiği 6 haneli kod.
  - `password`: (String) Kullanıcının belirlediği yeni şifre.

**Mantık (Logic):**
1.  `password_resets` tablosunda gelen `email` ve `token` eşleşmesini kontrol et.
    -   Eğer eşleşme yoksa veya süre (örn: 1 saat) geçmişse: `{"success": false, "message": "Geçersiz veya süresi dolmuş kod."}` dön.
2.  Kod geçerliyse, `users` tablosunda ilgili kullanıcının `password` alanını güncelle.
    -   **Önemli:** Yeni şifreyi `password_hash()` (PHP) veya kullandığınız hashleme yöntemiyle güvenli bir şekilde kaydettiğinizden emin olun.
3.  `password_resets` tablosundan kullanılan kodu sil (tek kullanımlık olması için).
4.  Başarılı yanıt dön: `{"success": true, "message": "Şifreniz başarıyla güncellendi. Giriş yapabilirsiniz."}`

---

## 3. Flutter Tarafındaki Akış

Mobil uygulama tarafı şu anda bu yapıyı destekleyecek şekilde hazırdır:

1.  **Adım 1:** Kullanıcı email adresini girer -> `forgot_password.php` çağrılır.
2.  **Adım 2:** Kullanıcı emailine gelen kodu girer -> (Lokal olarak bir sonraki adıma geçilir).
3.  **Adım 3:** Kullanıcı yeni şifresini belirler -> `reset_password.php` çağrılır (`email`, `token`, `newPassword` ile).
4.  Backend kodu doğrularsa şifre güncellenir ve kullanıcı giriş ekranına yönlendirilir.
