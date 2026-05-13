USE master;
GO

-- 1. TAM YEDEK DÖNÜŞÜ (Veritabanı zaten Restoring modunda, REPLACE ile eziyoruz)
RESTORE DATABASE DB_Performans 
FROM DISK = 'C:\SQL_Backups\DB_Performans_Full.bak' 
WITH NORECOVERY, REPLACE;
GO

-- 2. FARK YEDEĞİ DÖNÜŞÜ
RESTORE DATABASE DB_Performans 
FROM DISK = 'C:\SQL_Backups\DB_Performans_Diff.bak' 
WITH NORECOVERY;
GO

-- 3. EKSİK OLAN HALKA: ARA İŞLEM GÜNLÜĞÜ YEDEĞİ (İşte unuttuğumuz adım)
RESTORE LOG DB_Performans 
FROM DISK = 'C:\SQL_Backups\DB_Performans_Log.trn' 
WITH NORECOVERY;
GO

-- 4. ZAMANDA YOLCULUK (Kuyruk Logu ve STOPAT)
RESTORE LOG DB_Performans 
FROM DISK = 'C:\SQL_Backups\DB_Performans_Tail.trn' 
WITH RECOVERY, STOPAT = '2026-05-13 17:43:58.853';
GO

-- 5. ERİŞİMİ AÇ
ALTER DATABASE DB_Performans SET MULTI_USER;
GO

-- 6. ZAFER KONTROLÜ
USE DB_Performans;
GO
SELECT TOP 10 order_id, order_status 
FROM Olist_Orders;
GO