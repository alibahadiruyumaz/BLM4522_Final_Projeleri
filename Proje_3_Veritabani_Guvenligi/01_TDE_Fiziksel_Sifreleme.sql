-- 1. ADIM: Master veritabanında anahtar ve sertifika oluşturma
USE master;
GO

-- Eğer daha önce oluşturulmuşsa hata vermemesi için kontrol
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE symmetric_key_id = 101)
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Karmasik_Sifre_123!_TDE';
END
GO

-- Sertifikayı oluşturuyoruz (zaten varsa atla)
IF NOT EXISTS (SELECT * FROM sys.certificates WHERE name = 'TDE_Olist_Cert')
BEGIN
    CREATE CERTIFICATE TDE_Olist_Cert 
    WITH SUBJECT = 'Olist Veritabani TDE Sertifikasi';
END
GO

-- 2. ADIM: Kendi veritabanımıza geçip şifrelemeyi başlatma
USE DB_Performans;
GO

-- Veritabanı Şifreleme Anahtarını (DEK) oluşturuyoruz (zaten varsa atla)
IF NOT EXISTS (SELECT * FROM sys.dm_database_encryption_keys WHERE database_id = DB_ID('DB_Performans'))
BEGIN
    CREATE DATABASE ENCRYPTION KEY
    WITH ALGORITHM = AES_256
    ENCRYPTION BY SERVER CERTIFICATE TDE_Olist_Cert;
END
GO

-- Şifreleme zaten aktif değilse aktif et
IF NOT EXISTS (
    SELECT * FROM sys.dm_database_encryption_keys 
    WHERE database_id = DB_ID('DB_Performans') AND encryption_state = 3
)
BEGIN
    ALTER DATABASE DB_Performans SET ENCRYPTION ON;
END
GO