USE DB_Performans;
GO

CREATE OR ALTER PROCEDURE GetCustomerByState_Vulnerable
    @State NVARCHAR(100)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    -- Girdi hiçbir filtrelemeden geçmeden doğrudan dinamik sorguya ekleniyor.
    SET @SQL = 'SELECT customer_id, customer_city FROM Olist_Customers WHERE customer_state = ''' + @State + '''';
    EXEC(@SQL);
END;
GO