@echo off
echo Kurumsal Yedekleme Otomasyonu Baslatiliyor...
echo Hedef: DB_Performans (Fark Yedegi)
sqlcmd -S localhost -E -d DB_Performans -Q "EXEC sp_OtomatikYedekleme @YedekTipi='DIFF'"
echo Gorev Basariyla Tamamlandi.
pause
