USE master;
GO

-- 1. Kurtarma Modelini FULL Olarak Ayarla (Point-in-time restore için zorunludur)
ALTER DATABASE DB_Performans SET RECOVERY FULL;
GO

-- 2. İlk Tam Yedeği (Full Backup) Al
-- Bu işlem veritabanının o anki tam kopyasını diske yazar.
BACKUP DATABASE DB_Performans 
TO DISK = 'C:\SQL_Backups\DB_Performans_Full.bak' 
WITH FORMAT, 
     INIT, 
     NAME = 'DB_Performans - Tam Yedek',
     STATS = 10;
GO