# PROJE 7: YEDEKLEME OTOMASYONU VE ARŞİVLEME MİMARİSİ — GÜNLÜK ÇALIŞMA RAPORU

**Öğrenci:** Ali Bahadır Uyumaz (22290875)
**Kapsam:** T-SQL Dinamik Programlama, CLI Entegrasyonu ve Sistem Otomasyonu
**Platform:** MSSQL Server & Windows OS

---

## Gün 1: Gelişmiş T-SQL Motoru ve Dinamik İsimlendirme

Manuel yedekleme süreçlerindeki en büyük risk olan "dosya üzerine yazma" (overwrite) sorununu kökten çözmek için veritabanı motoru seviyesinde akıllı bir prosedür inşa edilmiştir.

* **Dinamik Prosedür Gelişimi:** `sp_OtomatikYedekleme` adında, dışarıdan parametre alabilen bir merkezi yönetim motoru yazılmıştır.
* **Zaman Damgası (Timestamp) Teknolojisi:** Yedek dosyalarının sonuna `yyyyMMdd_HHmmss` formatında saniye hassasiyetinde bir damga eklenmesi sağlanmıştır. Bu sayede her yedek, zaman çizelgesinde benzersiz bir arşiv dosyası olarak kaydedilmektedir.
* **Mantıksal Karar Yapısı:** Prosedürün içine yerleştirilen `IF-ELSE` blokları sayesinde; Full, Differential ve Log yedekleri tek bir komut üzerinden, parametre kontrollü olarak yönetilebilir hale getirilmiştir.

## Gün 2: İşletim Sistemi Entegrasyonu ve Batch Scripting

Yazılan SQL mantığının veritabanı arayüzünden (SSMS) bağımsız bir şekilde tetiklenebilmesi için işletim sistemi katmanıyla bir köprü kurulmuştur.

* **CLI Entegrasyonu:** Windows komut satırı aracı olan `sqlcmd` kullanılarak, veritabanına komut gönderebilen kurumsal bir kanal açılmıştır.
* **Otomasyon Scripti (.bat):** `02_Otomatik_Yedek_Gorevi.bat` dosyası hazırlanmış ve SQL Server'ın sessiz modda (Silent Mode) yedek alması sağlanmıştır.
* **Operasyonel Fayda:** Bu script sayesinde, veritabanı yöneticisinin arayüze bağlanma zorunluluğu ortadan kalkmış, yedekleme işlemi tek bir sistem komutuna indirgenmiştir.

## Gün 3: Zamanlanmış Görevler ve Kesintisiz İş Sürekliliği

Projenin nihai hedefi olan "insansız operasyon" için hazırlanan tüm bileşenler Windows Görev Zamanlayıcısı (Task Scheduler) çatısı altında birleştirilmiştir.

* **Zamanlanmış Tetikleyici:** Hazırlanan batch script, her gece saat 03:00'te otomatik çalışacak şekilde sisteme tanımlanmıştır.
* **Otomasyon Doğrulaması:** Yapılan testlerde, sistemin hiçbir müdahale gerektirmeksizin `C:\SQL_Backups\` klasöründe tarih-saat mühürlü yedek dosyalarını başarıyla oluşturduğu fiziksel olarak kanıtlanmıştır.
* **Sonuç:** İnsan inisiyatifi devreden çıkarılarak, veri güvenliği %100 otomatik ve hatasız bir döngüye sokulmuştur.