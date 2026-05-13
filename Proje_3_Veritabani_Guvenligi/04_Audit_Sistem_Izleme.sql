-- 1. ADIM: Sunucu seviyesinde Denetim (Audit) Nesnesini yarat
USE master;
GO

CREATE SERVER AUDIT Olist_Security_Audit
TO FILE 
( 
    FILEPATH = 'C:\SQL_Audits\' -- C diskinde bu klasörü manuel oluştur!
)
WITH 
(
    ON_FAILURE = CONTINUE -- Disk dolarsa sistemi durdurma, loglamayı geç
);
GO

-- Denetimi aktif et
ALTER SERVER AUDIT Olist_Security_Audit WITH (STATE = ON);
GO

-- 2. ADIM: Veritabanı seviyesinde spesifik kuralları (Specification) yarat
USE DB_Performans;
GO

CREATE DATABASE AUDIT SPECIFICATION Olist_DB_Audit
FOR SERVER AUDIT Olist_Security_Audit
-- Olist_Customers tablosundaki tüm SELECT işlemlerini kaydet
ADD (SELECT ON dbo.Olist_Customers BY public)
WITH (STATE = ON);
GO