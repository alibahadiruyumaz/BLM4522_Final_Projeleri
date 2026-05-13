-- 1. ADIM: Master veritabanında anahtar ve sertifika oluşturma
USE master;
GO

-- Eğer daha önce oluşturulmuşsa hata vermemesi için kontrol
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE symmetric_key_id = 101)
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Karmasik_Sifre_123!_TDE';
END
GO

-- Sertifikayı oluşturuyoruz
CREATE CERTIFICATE TDE_Olist_Cert 
WITH SUBJECT = 'Olist Veritabani TDE Sertifikasi';
GO

-- 2. ADIM: Kendi veritabanımıza geçip şifrelemeyi başlatma
USE DB_Performans;
GO

-- Veritabanı Şifreleme Anahtarını (DEK) oluşturuyoruz. AES_256 askeri standarttır.
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE TDE_Olist_Cert;
GO

-- Veritabanında şifrelemeyi aktif ediyoruz
ALTER DATABASE DB_Performans SET ENCRYPTION ON;
GO