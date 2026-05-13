USE DB_Performans;
GO

-- 1. SİMÜLASYON: Tabloda GERÇEKTEN var olan bir müşteriyi bulup sipariş atıyoruz.
INSERT INTO Olist_Orders (order_id, customer_id, order_status, order_purchase_timestamp)
SELECT TOP 1 'TEST-ORDER-DIFF-001', customer_id, 'delivered', GETDATE() 
FROM Olist_Customers;
GO

-- 2. FARK YEDEĞİ (Önceki boş yedeğin üzerine yazmak için INIT eklendi)
BACKUP DATABASE DB_Performans 
TO DISK = 'C:\SQL_Backups\DB_Performans_Diff.bak' 
WITH DIFFERENTIAL, INIT, 
     NAME = 'DB_Performans - Fark Yedegi',
     STATS = 10;
GO

-- 3. SİMÜLASYON: Yine gerçek bir müşteri seçerek ikinci sipariş akışını simüle ediyoruz.
INSERT INTO Olist_Orders (order_id, customer_id, order_status, order_purchase_timestamp)
SELECT TOP 1 'TEST-ORDER-LOG-002', customer_id, 'shipped', GETDATE() 
FROM Olist_Customers 
ORDER BY customer_id DESC; -- Farklı bir müşteri ID'si almak için
GO

-- 4. İŞLEM GÜNLÜĞÜ YEDEĞİ (Önceki boş yedeğin üzerine yazmak için INIT eklendi)
BACKUP LOG DB_Performans 
TO DISK = 'C:\SQL_Backups\DB_Performans_Log.trn' 
WITH INIT, 
     NAME = 'DB_Performans - Log Yedegi',
     STATS = 10;
GO