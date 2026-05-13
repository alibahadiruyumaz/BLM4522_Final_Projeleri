**Proje 3: Veritabanı Güvenliği ve Erişim Kontrolü** **Platform:** MSSQL Server  
**Mimari Kapsam:** Transparent Data Encryption (TDE), Role-Based Access Control (RBAC), SQL Server Auditing, SQL Injection Savunması

---

## Gün 1: Fiziksel Veri Güvenliği (TDE) ve Anahtar İzolasyonu

Veritabanı dosyalarının (`.mdf`, `.ndf`, `.ldf`) ve alınacak yedeklerin disk seviyesinde fiziksel olarak çalınmasına karşı **Transparent Data Encryption (TDE)** mimarisi kurulmuştur.

Uygulanan mimari adımlar:
1. `master` veritabanı üzerinde işletim sistemi seviyesinde korunan bir Master Key ve `TDE_Olist_Cert` adında bir sunucu sertifikası oluşturulmuştur.
2. Hedef `DB_Performans` veritabanında, oluşturulan sertifikaya bağlı ve `AES_256` askeri standart şifreleme algoritması kullanan Database Encryption Key (DEK) tanımlanarak TDE aktif edilmiştir.
3. **Kritik İzolasyon:** Olası bir donanım veya sunucu çökmesi durumunda şifreli verilerin kurtarılabilmesi (Disaster Recovery) amacıyla, Master Key ve Sertifika (Private Key dahil) veritabanı dizininden tamamen izole edilmiş fiziksel bir klasöre (`C:\SQL_Keys\`) yedeklenmiştir.

## Gün 2: Granüler Erişim Kontrolü (RBAC)

Kullanıcılara doğrudan yetki atanması (Direct Grant) güvenlik zafiyetlerine ve operasyonel yönetim zorluklarına yol açtığından, sistemde En Az Yetki Prensibi (Principle of Least Privilege) uygulanmıştır.

* **Rol İnşası:** Operasyonel veri analistleri için `DataAnalystRole` adında özel bir veritabanı rolü oluşturulmuştur.
* **Yetki Sınırlandırması:** Bu role, sadece müşteri, sipariş ve ürün detay tablolarında okuma (`SELECT`) yetkisi verilmiştir. Veri manipülasyonu (`INSERT`, `UPDATE`, `DELETE`) ve şema değişikliği yetkileri varsayılan olarak kısıtlanmıştır.
* Mevcut analist girişleri bu role üye yapılarak erişim yönetimi merkezi ve ölçeklenebilir hale getirilmiştir.

## Gün 3: Sistem Telemetrisi ve Denetim (Audit Logs)

Sistemdeki yetkisiz erişimleri ve anormallikleri takip edebilmek için SQL Server Audit mekanizması yapılandırılmıştır.

* Sunucu seviyesinde `Olist_Security_Audit` nesnesi yaratılmış ve logların veritabanından bağımsız, fiziksel bir işletim sistemi klasörüne (`C:\SQL_Audits\`) `.sqlaudit` formatında yazılması sağlanmıştır.
* Veritabanı seviyesinde oluşturulan denetim belirtimi (Audit Specification) ile, özellikle hassas kişisel veriler barındıran `Olist_Customers` tablosuna yapılan her türlü `SELECT` okuma girişimi (başarılı veya başarısız) izlemeye alınmıştır.

## Gün 4: Sızma Testi (SQL Injection) ve Güvenlik Yaması

Kurulan güvenlik katmanlarının ve denetim mekanizmasının uygulama katmanındaki zafiyetlere karşı tepkisini ölçmek amacıyla kontrollü bir sızma testi gerçekleştirilmiştir.

1. **Zafiyetin Simülasyonu:** Girdi denetimi (Input Validation) yapmayan ve parametreleri dinamik SQL metnine doğrudan birleştiren (String Concatenation) hatalı bir Stored Procedure (`GetCustomerByState_Vulnerable`) sisteme eklenmiştir.
2. **Sömürü (Exploitation):** Sisteme `SP' OR 1=1; --` payload'ı gönderilerek mantıksal doğrulama atlatılmış ve tek bir eyalet verisi beklenirken tüm müşteri veri tabanının dışarı sızdırılması sağlanmıştır.
3. **Zafiyetin Kapatılması (Patching):** İlgili Stored Procedure, parametrik sorgu (Parameterized Query) mimarisiyle yeniden yazılarak (`GetCustomerByState_Secure`) güncellenmiştir. Aynı payload tekrar gönderildiğinde, SQL motoru girdiyi komut değil, salt metin (literal) olarak yorumlamış ve saldırı etkisiz hale getirilmiştir.
4. **İstihbarat Doğrulaması:** Saldırı sonrasında `sys.fn_get_audit_file` fonksiyonu ile `C:\SQL_Audits\` dizinindeki loglar analiz edilmiştir. Gerçekleştirilen saldırının tam zamanı, işlemi yapan kullanıcı hesabı ve enjekte edilen tehlikeli SQL komutunun (`OR 1=1`) sisteme silinemez bir şekilde kaydedildiği kanıtlanmıştır.

---