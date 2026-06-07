USE DB_Performans;
GO

-- 1. SİMÜLASYON: Test siparişi zaten varsa önce sil, sonra ekle
IF EXISTS (SELECT 1 FROM Olist_Orders WHERE order_id = 'TEST-ORDER-DIFF-001')
    DELETE FROM Olist_Orders WHERE order_id = 'TEST-ORDER-DIFF-001';

INSERT INTO Olist_Orders (order_id, customer_id, order_status, order_purchase_timestamp)
SELECT TOP 1 'TEST-ORDER-DIFF-001', customer_id, 'delivered', GETDATE() 
FROM Olist_Customers;
GO

-- 2. FARK YEDEĞİ
BACKUP DATABASE DB_Performans 
TO DISK = 'C:\SQL_Backups\DB_Performans_Diff.bak' 
WITH DIFFERENTIAL, INIT, 
     NAME = 'DB_Performans - Fark Yedegi',
     STATS = 10;
GO

-- 3. SİMÜLASYON: Test siparişi zaten varsa önce sil, sonra ekle
IF EXISTS (SELECT 1 FROM Olist_Orders WHERE order_id = 'TEST-ORDER-LOG-002')
    DELETE FROM Olist_Orders WHERE order_id = 'TEST-ORDER-LOG-002';

INSERT INTO Olist_Orders (order_id, customer_id, order_status, order_purchase_timestamp)
SELECT TOP 1 'TEST-ORDER-LOG-002', customer_id, 'shipped', GETDATE() 
FROM Olist_Customers 
ORDER BY customer_id DESC;
GO

-- 4. İŞLEM GÜNLÜĞÜ YEDEĞİ
BACKUP LOG DB_Performans 
TO DISK = 'C:\SQL_Backups\DB_Performans_Log.trn' 
WITH INIT, 
     NAME = 'DB_Performans - Log Yedegi',
     STATS = 10;
GO