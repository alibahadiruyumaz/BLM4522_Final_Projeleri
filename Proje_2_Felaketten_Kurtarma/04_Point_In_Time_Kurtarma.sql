USE master;
GO

-- 1. BAĞLANTILARI KES
-- Veritabanı kullanımdayken üzerine restore yapılamaz. Diğer tüm kullanıcıları atıyoruz.
ALTER DATABASE DB_Performans SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- 2. KUYRUK LOG YEDEĞİ (Tail-Log Backup)
-- Veritabanını "Restoring" (Kurtarma) moduna kilitliyoruz (NORECOVERY) 
-- ve aradaki kayıp zamanı yakalamak için son bir log alıyoruz.
BACKUP LOG DB_Performans 
TO DISK = 'C:\SQL_Backups\DB_Performans_Tail.trn' 
WITH INIT, NORECOVERY; 
GO

-- 3. TAM YEDEK DÖNÜŞÜ
-- Sıfır noktasına dönüyoruz ama veritabanını henüz uyandırmıyoruz (NORECOVERY).
RESTORE DATABASE DB_Performans 
FROM DISK = 'C:\SQL_Backups\DB_Performans_Full.bak' 
WITH NORECOVERY, REPLACE;
GO

-- 4. FARK YEDEĞİ DÖNÜŞÜ
-- Tam yedekten sonraki değişiklikleri hızlıca yüklüyoruz.
RESTORE DATABASE DB_Performans 
FROM DISK = 'C:\SQL_Backups\DB_Performans_Diff.bak' 
WITH NORECOVERY;
GO

-- 5. ZAMANDA YOLCULUK (Point-in-Time Restore)
-- İşte mühendisliğin kalbi: Kuyruk logunu okutuyoruz ama "STOPAT" ile tam o saniyede durduruyoruz.
RESTORE LOG DB_Performans 
FROM DISK = 'C:\SQL_Backups\DB_Performans_Tail.trn' 
WITH RECOVERY, STOPAT = '2026-05-13 17:43:58.853';
GO

-- 6. ERİŞİMİ AÇ
ALTER DATABASE DB_Performans SET MULTI_USER;
GO

-- 7. ZAFER KONTROLÜ
-- Veriler o korkunç 'HATALI_VERI_KAYBI' yazısından kurtulup eski haline dönmüş mü görelim.
USE DB_Performans;
GO
SELECT TOP 10 order_id, order_status 
FROM Olist_Orders;
GO