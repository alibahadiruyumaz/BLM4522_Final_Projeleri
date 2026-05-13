USE DB_Performans;
GO

-- 1. Rolü Oluştur
CREATE ROLE DataAnalystRole;
GO

-- 2. Role Gerekli Yetkileri Tanımla (Sadece Okuma)
GRANT SELECT ON Olist_Customers TO DataAnalystRole;
GRANT SELECT ON Olist_Orders TO DataAnalystRole;
GRANT SELECT ON Olist_Order_Items TO DataAnalystRole;
GO

-- 3. Kullanıcıyı (Eğer vize projesinden kalma ise) Role Ata
-- Not: AnalistLogin'in sunucu seviyesinde zaten var olduğunu varsayıyoruz.
-- ALTER ROLE komutu ile kullanıcıyı gruba dahil ediyoruz.
ALTER ROLE DataAnalystRole ADD MEMBER AnalistUser;
GO