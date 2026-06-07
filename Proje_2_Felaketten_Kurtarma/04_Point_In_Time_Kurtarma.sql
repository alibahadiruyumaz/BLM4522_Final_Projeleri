USE master;
GO



-- 1. TÜM AKTİF BAĞLANTILARI ZORLA KOPAR (Exclusive access için zorunlu)
ALTER DATABASE DB_Performans SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- 2. TAIL-LOG YEDEĞİ AL (felaket anı ile son log arasındaki boşluğu kapat)
BACKUP LOG DB_Performans
TO DISK = 'C:\SQL_Backups\DB_Performans_Tail.trn'
WITH NORECOVERY, INIT, STATS = 10;
GO

-- 3. TAM YEDEK DÖNÜŞÜ
RESTORE DATABASE DB_Performans 
FROM DISK = 'C:\SQL_Backups\DB_Performans_Full.bak' 
WITH NORECOVERY, REPLACE;
GO

-- 4. FARK YEDEĞİ DÖNÜŞÜ
RESTORE DATABASE DB_Performans 
FROM DISK = 'C:\SQL_Backups\DB_Performans_Diff.bak' 
WITH NORECOVERY;
GO

-- 5. ARA İŞLEM GÜNLÜĞÜ YEDEĞİ
RESTORE LOG DB_Performans 
FROM DISK = 'C:\SQL_Backups\DB_Performans_Log.trn' 
WITH NORECOVERY;
GO

-- 6. ZAMANDA GERİ DÖNÜŞ (Tail-Log + STOPAT)

RESTORE LOG DB_Performans 
FROM DISK = 'C:\SQL_Backups\DB_Performans_Tail.trn' 
WITH RECOVERY, STOPAT = '2026-06-07 16:11:26.863';
GO

-- 7. ERİŞİMİ TEKRAR AÇ
ALTER DATABASE DB_Performans SET MULTI_USER;
GO

-- 8. ZAFER KONTROLÜ
USE DB_Performans;
GO
SELECT TOP 10 order_id, order_status 
FROM Olist_Orders;
GO