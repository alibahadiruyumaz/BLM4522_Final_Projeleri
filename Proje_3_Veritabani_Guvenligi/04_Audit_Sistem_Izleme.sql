-- 1. ADIM: Sunucu seviyesinde Denetim (Audit) Nesnesini yarat
USE master;
GO

-- Audit nesnesi zaten varsa önce durdur ve sil, sonra yeniden oluştur
IF EXISTS (SELECT * FROM sys.server_audits WHERE name = 'Olist_Security_Audit')
BEGIN
    ALTER SERVER AUDIT Olist_Security_Audit WITH (STATE = OFF);
    DROP SERVER AUDIT Olist_Security_Audit;
END
GO

CREATE SERVER AUDIT Olist_Security_Audit
TO FILE 
( 
    FILEPATH = 'C:\SQL_Audits\' 
)
WITH 
(
    ON_FAILURE = CONTINUE 
);
GO

-- Denetimi aktif et
ALTER SERVER AUDIT Olist_Security_Audit WITH (STATE = ON);
GO

-- 2. ADIM: Veritabanı seviyesinde spesifik kuralları (Specification) yarat
USE DB_Performans;
GO

-- Specification zaten varsa önce durdur ve sil, sonra yeniden oluştur
IF EXISTS (SELECT * FROM sys.database_audit_specifications WHERE name = 'Olist_DB_Audit')
BEGIN
    ALTER DATABASE AUDIT SPECIFICATION Olist_DB_Audit WITH (STATE = OFF);
    DROP DATABASE AUDIT SPECIFICATION Olist_DB_Audit;
END
GO

CREATE DATABASE AUDIT SPECIFICATION Olist_DB_Audit
FOR SERVER AUDIT Olist_Security_Audit
-- Olist_Customers tablosundaki tüm SELECT işlemlerini kaydet
ADD (SELECT ON dbo.Olist_Customers BY public)
WITH (STATE = ON);
GO