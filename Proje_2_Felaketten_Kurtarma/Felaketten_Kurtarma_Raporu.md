# FELAKETTEN KURTARMA VE YEDEKLEME STRATEJİSİ — TEKNİK UYGULAMA RAPORU

**Proje 2: Veritabanı Yedekleme ve Felaketten Kurtarma Planı (Disaster Recovery)**
**Platform:** MSSQL Server
**Mimari Kapsam:** Full/Diff/Log Backups, Tail-Log Backup, Point-in-Time Restore

---

## Gün 1: Kurtarma Modeli ve Temel Çizgi (Baseline) İnşası

Olası bir felaket anında sistemin belirli bir saniyeye geri döndürülebilmesi (Point-in-Time Restore) için temel altyapı hazırlanmıştır.
* **Kurtarma Modeli Güncellemesi:** Veritabanındaki hiçbir işlemin (transaction) kaybolmaması için `DB_Performans` veritabanının Recovery Model ayarı `FULL` statüsüne çekilmiştir.
* **Sıfır Noktası (Baseline):** Sistemin mevcut durumunun tam bir fotoğrafını çekmek amacıyla `C:\SQL_Backups\` fiziksel dizinine ilk Tam Yedek (Full Backup) alınmıştır. Bu yedek, tüm kurtarma senaryolarının temel dayanağıdır.

## Gün 2: Katmanlı Yedekleme Stratejisi (Differential & Log)

Sistemin sürekli çalıştığı ve yeni verilerin aktığı senaryosu simüle edilerek, kurumsal bir yedekleme hiyerarşisi kurulmuştur.
* **Veri Akışı Simülasyonu:** `Olist_Orders` (Siparişler) tablosuna, veri bütünlüğü kurallarına (Foreign Key) uygun şekilde yeni kayıtlar eklenmiştir.
* **Fark Yedeği (Differential Backup):** Tam yedekten sonra değişen verileri hızlıca güvence altına almak için Fark Yedeği alınmıştır.
* **İşlem Günlüğü (Transaction Log) Yedeği:** Zamanda saniye bazlı yolculuk yapabilmenin teknik zorunluluğu olan Transaction Log yedeği alınarak zincir tamamlanmıştır.

## Gün 3: Felaket Simülasyonu ve Sistem Kurtarma (Point-in-Time Restore)

Kurulan yedekleme mimarisinin dayanıklılığını kanıtlamak için kontrollü bir insan hatası (User Error) yaratılmış ve sistem başarıyla kurtarılmıştır.
* **Felaket (Disaster) Anı:** `WHERE` koşulu unutulmuş bir `UPDATE` sorgusu çalıştırılarak tüm siparişlerin `order_status` verileri `HATALI_VERI_KAYBI` metniyle kirlenmiştir. Felaket saati (Örn: 17:43:58) sistemden çekilerek kaydedilmiştir.
* **Kuyruk Logu (Tail-Log Backup):** Sistem kilitlenerek (`NORECOVERY`) felaket anını ve sonrasını içeren son log yedeği alınmış, aktif işlemler izole edilmiştir.
* **Zincirleme Restorasyon:** Kopan zaman zincirini (LSN) bağlamak için Full, Differential ve Log yedekleri sırasıyla sisteme okutulmuştur.
* **Zamanda Yolculuk (STOPAT):** Kuyruk logu okutulurken `STOPAT` parametresi kullanılarak, SQL motoru tam olarak felaketten 1 saniye öncesinde durdurulmuştur.
* **Zafer Kontrolü:** Kirlenen verilerin tamamen temizlendiği ve orijinal sipariş statülerinin kayıpsız olarak geri geldiği kanıtlanmış, veritabanı `MULTI_USER` moduyla tekrar erişime açılmıştır.