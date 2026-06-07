# BLM4522 - Ağ Tabanlı Paralel Dağıtım Sistemleri Final Projeleri

Bu depo, kurumsal veritabanı mimarilerinde hata toleransı (Fault Tolerance), güvenlik (Security) ve operasyonel otomasyon süreçlerinin inşasını ve test edilmesini içeren üç farklı teknik uygulamayı barındırmaktadır.

## Geliştirici
* **Ad Soyad:** Ali Bahadır Uyumaz
* **Öğrenci No:** 22290875

## Proje Mimarisi ve Uygulama Katmanları

Bu depo, bir veritabanı sisteminin güvenliğini ve sürekliliğini sağlamak için entegre edilmiş üç ana modüle ayrılmıştır:

### 1. [Proje 2: Veritabanı Yedekleme ve Felaketten Kurtarma Planı](./Proje_2_Felaketten_Kurtarma/Felaketten_Kurtarma_Raporu.md)
Sistemin kasten çökertilmesi ve veri kaybı senaryolarına karşı *Point-in-time restore* (belirli bir zamana geri dönüş) mimarisinin uygulanması ve felaket kurtarma (Disaster Recovery) simülasyonu.

### 2. [Proje 3: Veritabanı Güvenliği ve Erişim Kontrolü](./Proje_3_Veritabani_Guvenligi/Guvenlik_Erisim_Raporu.md)
*Role-Based Access Control* (RBAC) ile granüler yetkilendirme, *Transparent Data Encryption* (TDE) ile veri şifreleme, SQL Injection koruması ve *Audit Logs* ile anomali takibi.

### 3. [Proje 7: Veritabanı Yedekleme Otomasyonu ve Arşivleme Mimarisi](./Proje_7_Yedekleme_Otomasyon/Yedekleme_Otomasyon_Raporu.md)
Veritabanı motoru seviyesinde yazılan `sp_OtomatikYedekleme` stored procedure'ü, `sqlcmd` CLI entegrasyonu ve Windows Task Scheduler ile tam otomatik, insansız yedekleme döngüsünün kurulması.
