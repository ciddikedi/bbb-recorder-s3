Record BigBlueButton meetings and upload to s3

* Web servisi, alınan kayıt isteklerini pueue kuyruğuna ekler. Host makinede pueue aracı kurulu olmalıdır.

* Recorder, toplantı kayıtlarını izleyerek mp4 formatına dönüştürür ve s3 depolama alanına aktarır.

Web servisini ayağa kaldırmak için;

`docker run -d --restart always -v /root/.config/pueue/pueue.yml:/root/.config/pueue/pueue.yml -p 80:5000 -v /usr/share/pueue/:/usr/share/pueue/ bedrettinyuce/add-pueue-service`

Web servisinin kullanımı;

`/addqueue/?playback=https://DENEME.EDU.TR/playback/presentation/2.3/MEETINGID&externalId=EXTERNALID`

Recorder aracını çalıştırmak için;

Depolama alanı bilgileri `/usr/local/bigbluebutton/core/scripts/s3_creds.yml` dosyası içine şu şekilde eklenmelidir;

* **endpoint:** Depolama alanına ait URL adresi.
* **access_key_id:** Erişim anahtarı.
* **secret_access_key:** Gizli anahtar.
* **bucket:** Toplantıların kaydedileceği bucket.
* **region:** Depolama bölgesi. UZEP depolaması için **DEFAULT** kalabilir.

`docker run -v /var/bigbluebutton/record_mp4/:/var/bigbluebutton/record_mp4/ -v /usr/local/bigbluebutton/core/scripts/s3_creds.yml:/usr/local/bigbluebutton/s3_creds.yml bedrettinyuce/bbbrecorder-s3 -p https://DENEME.EDU.TR/playback/presentation/2.3/MEETINGID -m DOSYAADI`