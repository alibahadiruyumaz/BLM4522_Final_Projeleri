USE DB_Performans;
GO

-- 1. Rolü Oluştur 
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'DataAnalystRole' AND type = 'R')
BEGIN
    CREATE ROLE DataAnalystRole;
END
GO

-- 2. Role Gerekli Yetkileri Tanımla (Sadece Okuma)
GRANT SELECT ON Olist_Customers TO DataAnalystRole;
GRANT SELECT ON Olist_Orders TO DataAnalystRole;
GRANT SELECT ON Olist_Order_Items TO DataAnalystRole;
GO

-- 3. Kullanıcıyı Role Ata (zaten üyeyse hata vermez)
-- Not: AnalistLogin'in sunucu seviyesinde zaten var olduğunu varsayıyoruz.
IF IS_ROLEMEMBER('DataAnalystRole', 'AnalistUser') = 0
BEGIN
    ALTER ROLE DataAnalystRole ADD MEMBER AnalistUser;
END
GO