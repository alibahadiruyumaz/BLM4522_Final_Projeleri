USE master;
GO

SELECT 
    event_time AS [Saldiri_Zamani], 
    server_principal_name AS [Giris_Yapan_Kullanici], 
    object_name AS [Hedef_Tablo], 
    statement AS [Calistirilan_Tehlikeli_Sorgu]
FROM sys.fn_get_audit_file('C:\SQL_Audits\*.sqlaudit', DEFAULT, DEFAULT)
WHERE statement LIKE '%1=1%';
GO