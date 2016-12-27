@ECHO off
CLS

REM BatchGemist versie 1.52 beta
REM 
REM   Veranderingslogboek:
REM     xx-xx-2016 v1.52:
REM       - 
REM     26-10-2016 v1.51:
REM       - Ondersteuning voor Collegerama TU Delft verwijderd i.v.m. copyright van het
REM         beeldmateriaal.
REM       - NPO extractor: Spaties in videolink van videofragmenten verholpen, waardoor ze nu wel
REM         zijn te downloaden / af te spelen. Extra beschikbaarheids controle toegevoegd voor
REM         videofragmenten die uiteindelijk toch niet beschikbaar zijn.
REM     16-10-2016 v1.5:
REM       [Batch code]
REM         - Onder :Input waar mogelijk 'GOTO'-commando's onderaan in IF-statement ondergebracht.
REM         - :Formats sterk geoptimaliseerd door veel van de speciale queries onderaan bij de
REM           desbetreffende extractors onder te brengen.
REM         - Onder :Task extra IF-statement toegevoegd voor de twee extractors die Youtube-links
REM           teruggeven. Omdat mijn script het downloaden van Youtube-links niet ondersteunt, wordt
REM           deze vraag in dit geval overgeslagen.
REM         - Onder :Task extra IF-statement toegevoegd voor oude 'Silverlight' videostreams, omdat
REM           deze geen fragment selectie in de videolink ondersteunen.
REM         - Aan :Download de mogelijkheid toegevoegd om ondertiteling van de NPO te muxen.
REM         - Onder :Download de FFMpeg-commando '-user_agent', om rtlXL's progressieve videostreams
REM           te kunnen downloaden, verwijderd. Voor andere websites gaf dit teveel problemen. Omdat
REM           bij rtlXL's progressieve videostreams het nog wel eens gebeurd dat het beeld en geluid
REM           niet synchroon lopen, heeft het downloaden van de dynamische videostreams sowieso de
REM           voorkeur.
REM         - Door betere tekencodering detectie in Xidel 0.9.4. is 'CHCP' overbodig geworden.
REM         - Waar nodig extra 'ENDLOCAL'-commando's toegevoegd, omdat in een bepaalde situatie niet
REM           alle variabelen waren gereset.
REM       [Xidel queries]
REM         - Queries geüpdatet in lijn met versie 0.9.4.
REM         - ALLE websites opnieuw nagelopen!
REM         - Formaat selectie verbeterd: Bij iedere extractor is de volgorde van beschikbare
REM           formaten nu eerst progressief en dan dynamisch. En per variant is de kwaliteit
REM           oplopend.
REM         - Bestandsnaamgeving verbeterd, waardoor aanhalings- en uitroeptekens nu wel goed worden
REM           verwerkt in de bestandsnaam.
REM         - NPO_meta extractor uitgebreide bestandsnaamgeving gegeven. Hierdoor zijn de
REM           naar-NPO_meta-verwijzende-extractors alleen nog verantwoordelijk voor het achterhalen
REM           van de programma ID en eventueel de datum.
REM         - NPO extractor: Sterk geoptimaliseerd en teruggebracht tot twee queries. Extra
REM           beschikbaarheids controles toegevoegd. Alleen de beveiligde progressieve
REM           videofragmenten geen nu nog door de resolver. 'Silverlight' videostream controle
REM           voorheen onder :Formats nu geïntegreerd.
REM         - rtlXL extractor: De bestandsnaamgeving combineert nu de originele datum en niet die
REM           van de herhaling. Extra controle toegevoegd voor als de 720p progressieve videostream
REM           niet beschikbaar is.
REM         - Kijk extractor: Gerepareerd en extra beschikbaarheids controle toegevoegd.
REM         - NPO Doc extractor hernoemt naar 2Doc.
REM         - Schooltv extractor: Gerepareerd.
REM         - NOS extractor: Gerepareerd en ondersteuning toegevoegd voor artikelen met meerdere
REM           video's.
REM         - EenVandaag extractor: Ondersteuning toegevoegd voor complete uitzendingen.
REM         - 101TV extractor: Gerepareerd en ondersteuning toegevoegd voor Youtube-links.
REM         - Alle regionale omroep extractors: Gerepareerd, sterk geoptimaliseerd en bijna allemaal
REM           ondersteunen ze nu livestreams, uitzendingen en artikelen al dan niet met meerdere
REM           video's.
REM         - Telegraaf extractor: Gerepareerd en ondersteuning toegevoegd voor dynamische
REM           videostreams.
REM         - Nickelodeon: De bestandsnaamgeving combineert nu de originele datum en niet die van de
REM           herhaling.
REM         - Ketnet extractor: De bestandsnaamgeving combineert nu een datum.
REM         - Disney extractor: Gerepareerd en samengevoegd. De bestandsnaamgeving combineert nu een
REM           datum. Beschikbaarheids controle voorheen onder :Formats nu geïntegreerd.
REM         - Cartoon Network extractor: De bestandsnaamgeving combineert nu een datum.
REM           Beschikbaarheids controle voorheen onder :Formats nu geïntegreerd.
REM         - Dumpert extractor: Youtube-link controle voorheen onder :Formats nu geïntegreerd.
REM         - Comedy Central extractor: Bestandsnaamgeving verbeterd.
REM         - Funny Clips extractor: De bestandsnaamgeving combineert nu een datum.
REM         - MTV extractor: Bestandsnaamgeving verbeterd.
REM         - Tweakers extractor: Gerepareerd, bestandsnaamgeving verbeterd en ondersteuning
REM           toegevoegd voor artikelen/reviews met meerdere video's.
REM         - Collegerama TU Delft extractor: Ondersteuning toegevoegd voor colleges met meerdere
REM           video's.
REM         - Ondersteuning toegevoegd voor: Andere Tijden, Willem Wever, NOS Livestreams,
REM           101TV Livestream, http://rtl.nl/#!/... en FOX Sports.
REM     25-04-2016 v1.41:
REM       - Gerepareerd: rtlXL 720p progressieve videostream, niet meer werkende videolink in Disney
REM         videoclips extractor en naam video in Disney- en Cartoon Network extractor.
REM       - :Download opgeschoond.
REM     30-03-2016 v1.4:
REM       - Xidel queries geüpdatet in lijn met versie 0.9.1.20160322.
REM       - Disney extractor geoptimaliseerd en is nu af. Tijdelijke oplossing aan :Formats
REM         toegevoegd voor het downloaden van de progressieve videostreams.
REM         LET OP: voor het downloaden van de dynamische videostreams is FFMpeg ná 16 maart nodig!
REM       - Ondersteuning toegevoegd voor: Cartoon Network.
REM       - Samenvoeging programmalink controle NPO en NPOLive teniet gedaan en een aparte regel
REM         voor de livestream van NPO 3 toegevoegd, omdat deze voor problemen bleef zorgen.
REM         Hierdoor :NPO_meta en :NPOLive_meta ook geüpdatet.
REM       - NOS- en 101TV extractor geoptimaliseerd door beter inzicht in Xidel's mogelijkheden.
REM       - NPO extractor geoptimaliseerd en, dankzij een nieuwe versie van Xidel, uitgebreid met
REM         een extra beschikbaarheids controle. Ook procenttekens in gecodeerde videolinks worden
REM         nu goed weergegeven.
REM       - rtlXL extractor gerepareerd: Samenstelling videolink progressieve videostreams. Extra
REM         FFMpeg parameter aan :Download toegevoegd voor het kunnen downloaden van de dynamische
REM         videostreams.
REM       - Kijk extractor uitgebreid met ondersteuning voor progressieve videostreams.
REM       - Gerepareerd: Niet meer werkende Tweakers extractor, kleine foutjes in :Formats,
REM         :Download en in de AT5 Gemist-, RTV Utrecht Gemist- en RTV Utrecht Nieuws extractor.
REM     10-02-2016 v1.3:
REM       - Ondersteuning toegevoegd voor: NOS, 101TV, RTL Nieuws, alle regionale omroepen(!) en
REM         Disney uitzendingen.
REM         LET OP: Ondersteuning voor Disney uitzendingen is nog in ontwikkeling!
REM       - Alle andere websites opnieuw nagelopen, sterk geoptimaliseerd, ondersteuning uitgebreid
REM         en waar mogelijk bij :Input ondergebracht.
REM       - NPO extractor grondig aangepakt waardoor nog meer video's worden ondersteund, waaronder
REM         beveiligde progressieve videofragmenten. Op nos.nl, waar ze ook voorkomen, worden ze ook
REM         ondersteund.
REM       - Programmalink controle van NPO en NPOLive samengevoegd met prid-check, vanwege de
REM         livestream van NPO 3, die als enige 'live' niet in de url heeft.
REM       - Gerepareerd: Escape characters in videolinks van Collegerama TU Delft.
REM       - De :Formats_xxx subroutines teruggebracht tot één grote.
REM       - Overzicht ondersteunde websites onder :Help ingekort.
REM     15-11-2015 v1.2:
REM       - Ondersteuning toegevoegd voor: NPO Doc, Eenvandaag, Telegraaf en Disney videoclips.
REM       - Door ondersteuning van Telegraaf, :Formats_json2 aangemaakt en :Tweakers ondergebracht
REM         bij :Input.
REM       - Door ondersteuning van Eenvandaag, tijdcode-calculaties voor :NPO videofragmenten aan
REM         Xidel overgelaten.
REM       - NPO extractor opgedeeld in :NPO_meta en :NPO.
REM       - Extra FOR-loop toegevoegd voor eventueel achtervoegsel in rtl-embed-link.
REM     04-10-2015 v1.1:
REM       - Script aanzienlijk verkort door websites en veel voorkomende functies onder te verdelen
REM         in aparte subroutines.
REM       - Ondersteuning toegevoegd voor: Ketnet en 24Kitchen.
REM       - RTVNoord-, RTVDrenthe- en RTVDrenthe_Live extractor vernieuwd.
REM     29-09-2015 v1.0:
REM       - Eerste versie.
REM 
REM BatchGemist is geschreven door Reino Wijnsma.
REM http://rwijnsma.home.xs4all.nl/uitzendinggemist/batchgemist.htm

TITLE BatchGemist 1.52 beta

REM ================================================================================================

:Check
SET xidel="xidel.exe"
SET ffmpeg="ffmpeg.exe"

SET check=
IF NOT EXIST %xidel% (
	SET check=1
	ECHO %xidel% niet gevonden.
)
IF NOT EXIST %ffmpeg% (
	SET check=1
	ECHO %ffmpeg% niet gevonden.
)
IF NOT EXIST %SystemRoot%\System32\clip.exe (
	SET check=1
	ECHO "clip.exe" niet gevonden.
)

IF DEFINED check (
	ECHO.
	PAUSE
	GOTO Help
)

SET "XIDEL_OPTIONS=--silent"
GOTO Input

REM ================================================================================================

:Input
ENDLOCAL
SETLOCAL
ECHO Voer programmalink in (of 'h' voor hulp):
SET /P url=
IF /I "%url%"=="h" GOTO Help
IF "%url%"=="" GOTO :EOF
IF NOT "%url: =%"=="%url%" (
	ECHO.
	ECHO Spaties in programmalink niet toegestaan.
	ECHO.
	ECHO.
	GOTO Input
) ELSE IF NOT "%url:npo.nl/live=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "prid:=//@data-prid" --output-format^=cmd^"') DO %%A
	GOTO NPOLive_meta
) ELSE IF "%url%"=="http://www.npo.nl/npo3" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "prid:=//@data-prid" --output-format^=cmd^"') DO %%A
	GOTO NPOLive_meta
) ELSE IF NOT "%url:npo.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "prid:=extract($url,'.+/(.+\d+)',1),date:=replace($url,'.+?(\d+)-(\d+)-(\d+).+','$1$2$3')" --output-format^=cmd^"') DO %%A
	GOTO NPO_meta
) ELSE IF NOT "%url:gemi.st=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "prid:=extract($url,'.+/(.+\d+)',1),date:=replace($url,'.+?(\d+)-(\d+)-(\d+).+','$1$2$3')" --output-format^=cmd^"') DO %%A
	GOTO NPO_meta
) ELSE IF NOT "%url:2doc.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "prid:=(//@data-media-id)[1],date:=replace((//@datetime)[1],'(\d+)-(\d+)-(\d+)','$3$2$1')" --output-format^=cmd^"') DO %%A
	GOTO NPO_meta
) ELSE IF NOT "%url:anderetijden.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "prid:=(//@data-prid)[1]" --output-format^=cmd^"') DO %%A
	GOTO NPO_meta
) ELSE IF NOT "%url:schooltv.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "prid:=//div/@data-mid,date:=replace(//dd[span[@property='datePublished']],'(\d+)-(\d+)-(\d+)','$1$2$3')" --output-format^=cmd^"') DO %%A
	GOTO NPO_meta
) ELSE IF NOT "%url:willemwever.kro-ncrv.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "prid:=//@data-video-id" --output-format^=cmd^"') DO %%A
	GOTO NPO_meta
) ELSE IF NOT "%url:nos.nl/livestream=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "name:=concat(//h1,replace('%date%','.+?(\d+)-(\d+)-(\d+)',' - Livestream ($1$2$3)')),pjson:=serialize-json({'stream':string(//@data-stream)})" -d "{$pjson}" "http://www-ipv4.nos.nl/livestream/resolve/" -f "{'data':substring-before($json/url,'p&callback'),'input-format':'json'}" -f "$json" --xquery "json:=[{'format':'meta','url':substring-before($url,'?')},tail(tokenize($raw,'#EXT-X-STREAM-INF:')) ! {'format':string(extract(.,'BANDWIDTH=(\d+)',1) idiv 1000),'url':concat(resolve-uri('.'),extract(.,'(.+m3u8)',1))}],let $a:=($json()[format='meta']/format,for $x in $json()[format!='meta']/format order by $x return $x) return (formats:=join($a,', '),best:=$a[last()])" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:nos.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" --xquery "if (//div[@class='video-play']) then if (count(//div[@class='video-play'])=1) then doc(//div[@class='video-play']/a/@href)/(name:=concat('NOS - ',replace(//meta[@property='og:title']/@content,'[&quot;&apos;]',''''''),replace(//@datetime,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)')),json:=[//source/{'format':replace(@data-label,'.+?(\d+).','mp4-$1'),'url':if (contains(@src,'content-ip')) then x:request({'post':serialize-json([{\"file\":string(@src)}]),'url':'http://nos.nl/video/resolve/'})//file else @src}]) else json:=[//div[@class='video-play']/a/doc(@href)/{position()||'e':{'name':concat('NOS - ',replace(//meta[@property='og:title']/@content,'[&quot;&apos;]',''''''),replace(//@datetime,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)')),'formats'://source/{'format':replace(@data-label,'.+?(\d+).','mp4-$1'),'url':if (contains(@src,'content-ip')) then x:request({'post':serialize-json([{\"file\":string(@src)}]),'url':'http://nos.nl/video/resolve/'})//file else @src}}}] else (name:=concat('NOS - ',if (//meta[@property='og:title']) then replace(//meta[@property='og:title']/@content,'[&quot;&apos;]','''''') else substring-after(//h1,'NOS '),replace(//@datetime,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)')),json:=[//source/{'format':replace(@data-label,'.+?(\d+).','mp4-$1'),'url':if (contains(@src,'content-ip')) then x:request({'post':serialize-json([{\"file\":string(@src)}]),'url':'http://nos.nl/video/resolve/'})//file else @src}]),if ($json(1)/format) then let $a:=for $x in $json()/format order by $x return $x return (formats:=join($a,', '),best:=$a[last()]) else videos:=join($json()(),', ')" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:eenvandaag.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" --xquery "prid:=//script/extract(.,'prid: \"(.+^)\"',1)[.],if (not(contains($url,'broadcast'))) then (name:=concat('EenVandaag - ',replace(//meta[@name='twitter:title']/@content,'[&quot;&apos;]',''''''),replace(//meta[@name='twitter:player:stream']/@content,'.+std\.(\d{4})(\d{2})(\d{2}).+',' ($3$2$1)')),//script/json(extract(.,'options: (.+?\})',1,'s'))/(ss:=startAt,to:=endAt,t:=($to)-($ss)),pubopties:=json(extract(unparsed-text(concat('http://e.omroep.nl/metadata/',$prid)),'\((.+)\)',1))/pubopties) else ()" --output-encoding^=oem --output-format^=cmd^"') DO %%A
	IF DEFINED pubopties (
		GOTO NPO
	) ELSE (
		GOTO NPO_meta
	)
) ELSE IF NOT "%url:www.101.tv/live=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -f "(//@data-src)[1]" -e "prid:=//script/extract(.,'prid: \"(.+^)\"',1)[.]" --output-format^=cmd^"') DO %%A
	GOTO NPOLive_meta
) ELSE IF NOT "%url:www.101.tv=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "if (//p/iframe) then _url:=replace(//p/iframe/@src,'.+/(.+)','https://youtu.be/$1') else doc(concat('http://media.bnn.nl/video/',extract($url,'.+/(.+)',1),'/bnntv')) ! (name:=concat('101TV - ',//title),_url:=//file)" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:rtlxl.nl=%"=="%url%" (
	FOR /F %%A IN ("%url%") DO SET "uuid=%%~nA"
	GOTO rtlXL
) ELSE IF NOT "%url:rtl.nl/#!=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% -e "uuid:=json(concat('http://rtl.nl/api/v3/item/',extract('%url%','.+/((\w+-){4}[^-]+)',1)))//ExternalId" --output-format^=cmd^"') DO %%A
	GOTO rtlXL
) ELSE IF NOT "%url:rtl.nl/system/videoplayer=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% -e "uuid:=extract('%url%/','=(.+?)/',1)" --output-format^=cmd^"') DO %%A
	GOTO rtlXL
) ELSE IF NOT "%url:rtlnieuws.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% --user-agent "BatchGemist 1.52 beta" "%url%" -e "uuid:=extract(//div[@class='videoContainer']//@src,'=(.+)/',1)" --output-format^=cmd^"') DO %%A
	GOTO rtlXL
) ELSE IF NOT "%url:www.kijk.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -f "replace(replace(parse-html('<html>'||substring-after($raw,'<![endif]>'))//meta[@name='video_src']/@content,'federated_f9','htmlFederated'),'videoId','@videoPlayer')" --xquery "json(extract(//body,'experienceJSON = (.+\});',1))/(if (.//mediaDTO) then .//mediaDTO/(name:=concat(if (customFields/sbs_station='veronicatv') then 'Veronica' else upper-case(customFields/sbs_station),' - ',displayName,replace(creationDate div 1000 * dayTimeDuration('PT1S') + date('1970-01-01'),'(\d+)-(\d+)-(\d+)',' ($3$2$1)')),json:=if ((renditions)()[size=0]) then [let $a:=(renditions)()[size=0]/defaultURL return ({'format':'meta','url':$a},tail(tokenize(unparsed-text($a),'#EXT-X-STREAM-INF:')) ! {'format':string(extract(.,'BANDWIDTH=(\d+)',1) idiv 1000),'url':concat(resolve-uri('.',$a),extract(.,'(.+m3u8)',1))}),json(concat('http://hbb.sbs6.nl/backend/veamerapi/index/method/video/brightCoveId/',id))/(videos)() ! {'format':replace(.,'.+-(\d+).*\.(.+)','$2-$1'),'url':.}] else [(renditions)()/{'format':concat('mp4_',encodingRate idiv 1000),'url':defaultURL}],let $b:=(for $x in $json()[contains(format,'mp4')]/format order by $x return $x,$json()[format='meta']/format,for $x in $json()[format castable as double]/format order by $x return $x) return (formats:=join($b,', '),best:=$b[last()])) else ())" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.omropfryslan.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "if (contains($url,'live')) then let $a:=json(doc(//script/extract(.,'playlist: \"(.+^)\"',1)[.]))(2)/(sources)() return (name:=concat(substring-before(//meta[@itemprop='name']/@content,'TV'),replace('%date%','.+?(\d+)-(\d+)-(\d+)','- Livestream ($1$2$3)')),json:=[doc($a[type='rtmp']/file)//video/{'format':concat('rtsp-',@system-bitrate idiv 1000),'url':concat(replace(//@base,'rtmp','rtsp'),@src)},let $b:=$a[type='hls']/file return ({'format':'meta','url':$b},tail(tokenize(unparsed-text($b),'#EXT-X-STREAM-INF:')) ! {'format':string(extract(.,'BANDWIDTH=(\d+)',1) idiv 1000),'url':concat(resolve-uri('.',$b),extract(.,'(.+m3u8)',1))})],formats:=join($json()/format,', '),best:=$json()[last()]/format) else let $a:=replace(//meta[@property='article:published_time']/@content,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)') return let $b:=//script/json(extract(.,'(\{\"sources\".+?)\)',1,'s')[.]) return if (count($b)=1) then (name:=concat('Omrop Fryslân - ',if (contains($url,'utstjoering')) then substring-before(//meta[@itemprop='name']/@content,' fan') else replace($b//idstring,'&quot;',''''''),$a),json:=[$b/(sources)()/{'format':replace(label,'(\d+).','mp4-$1'),'url':file}],formats:=join($json()/format,', '),best:=$json()[last()]/format) else (json:=[$b/{position()||'e':{'name':concat('Omrop Fryslân - ',replace(.//idstring,'&quot;',''''''),$a),'formats':(sources)()/{'format':replace(label,'(\d+).','mp4-$1'),'url':file}}}],videos:=join($json()(),', '))" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.rtvnoord.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" --xquery "if (contains($url,'livetv')) then (name:=replace('%date%','.+?(\d+)-(\d+)-(\d+)','RTV Noord - Livestream ($1$2$3)'),let $a:=doc(doc(doc(//iframe/@src)//@src)/extract(.,'\"playlist\": \"(.+^)\",',1))//@file return json:=[{'format':'meta','url':$a},tail(tokenize(unparsed-text($a),'#EXT-X-STREAM-INF:')) ! {'format':string(extract(.,'BANDWIDTH=(\d+)',1) idiv 1000),'url':concat(resolve-uri('.',$a),extract(.,'(.+m3u8)',1))}],formats:=join($json()/format,', '),best:=$json()[last()]/format) else let $a:=replace(//@datetime,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)') return let $b:=//div[@data-button='player-still-overlay icon-play'] return if (count($b)=1) then (name:=if (//meta[@property='og:type']/@content='video:episode') then concat('RTV Noord - ',//div[@class='media-details']/h3,replace(//@data-media,'.+?/(\d+).{3}(\d{2})(\d{2}).+',' ($3$2$1)')) else concat('RTV Noord - ',replace($b/@title,'[&quot;&apos;]',''''''),$a),_url:=$b/@data-media) else (json:=[$b ! {position()||'e':{'name':concat('RTV Noord - ',replace(@title,'[&quot;&apos;]',''''''),$a),'url':@data-media}}],videos:=join($json()(),', '))" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.rtvdrenthe.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" --xquery "let $a:=//meta[@property='og:type']/@content return let $b:=replace(//@datetime,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)') return let $c:=//div[@data-button='player-still-overlay icon-play'] return if (count($c)=1) then if ($a) then (name:=if ($a='video:episode') then concat('RTV Drenthe - ',//div[@class='media-details']/h3,replace(//@data-media,'.+?(\d{4})(\d{2})(\d{2}).+',' ($3$2$1)')) else concat('RTV Drenthe - ',replace($c/@title,'[&quot;&apos;]',''''''),$b),_url:=$c/@data-media) else (name:=replace('%date%','.+?(\d+)-(\d+)-(\d+)','RTV Drenthe - Livestream ($1$2$3)'),_url:=concat(resolve-uri('.',//@data-media),extract(unparsed-text(//@data-media),'(.+m3u8)',1))) else (json:=[$c ! {position()||'e':{'name':concat('RTV Drenthe - ',replace(@title,'[&quot;&apos;]',''''''),$b),'url':@data-media}}],videos:=join($json()(),', '))" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.rtvnh.nl/live/tv=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" --xquery "name:=replace('%date%','.+?(\d+)-(\d+)-(\d+)','RTV NH - Livestream ($1$2$3)'),let $a:=json(replace(replace(//script/extract(.,'sources: (.+),\s+\]',1,'s')[.],',\s+\}','}'),'rtmp','rtsp')||']')() return json:=[$a[type!='hls']/{'format':replace(file,'(.+?):.+(.)','$1-$2'),'url':file},{'format':'meta','url':$a[type='hls']/file},tail(tokenize(unparsed-text($a[type='hls']/file),'#EXT-X-STREAM-INF:')) ! {'format':string(extract(.,'BANDWIDTH=(\d+)',1) idiv 1000),'url':concat(resolve-uri('.',$a[type='hls']/file),extract(.,'(.+m3u8)',1))}],let $b:=($json()[contains(format,'rtsp')]/format,$json()[format='meta']/format,for $x in $json()[format castable as double]/format order by $x return $x) return (formats:=join($b,', '),best:=$b[last()])" --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.rtvnh.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "let $a:=replace(//meta[@property='article:published_time']/@content,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)') return let $b:=[if (//div/@data-video) then //div/@data-video ! {'name':concat('RTV NH - ',//meta[@property='og:title']/@content,$a),'id':.} else (),if (//@class='video-container') then //div[@class='video-container']/{'name':if (contains($url,'gemist')) then concat('RTV NH - ',//div[@class='banner_label'],replace(//a[@class='video-player']/@href,'.+?(\d+)/(\d+)/(\d+).+',' ($3$2$1)')) else concat('RTV NH - ',//script/extract(.,'title.+: (.+)''',1)[.],$a),'id':substring-after(@id,'video')} else (),if (//iframe) then //iframe/{'name':concat('RTV NH - ',//meta[@property='og:title']/@content,$a),'id':substring-after(@src,'=')} else ()] return if (count($b())=1) then $b()/(name:=name,json:=doc(concat('http://www.rtvnh.nl/media/smil/video/',id))/[//@src ! {'format':concat('rtsp-',extract(.,'_(\d+)',1)),'url':concat(replace(//@base,'rtmp','rtsp'),substring-after(.,'mp4:'))},//@src ! {'format':extract(.,'_(\d+)',1),'url':let $c:=concat(replace(replace(//@base,'rtmp','http'),':\d+',''),substring-after(.,'mp4:'),'/playlist.m3u8') return concat(resolve-uri('.',$c),extract(unparsed-text($c),'(.+m3u8)',1))}],formats:=join($json()/format,', '),best:=$json()[last()]/format) else (json:=[$b()/{position()||'e':{'name':name,'formats':doc(concat('http://www.rtvnh.nl/media/smil/video/',id))/[//@src ! {'format':concat('rtsp-',extract(.,'_(\d+)',1)),'url':concat(replace(//@base,'rtmp','rtsp'),substring-after(.,'mp4:'))},//@src ! {'format':extract(.,'_(\d+)',1),'url':let $c:=concat(replace(replace(//@base,'rtmp','http'),':\d+',''),substring-after(.,'mp4:'),'/playlist.m3u8') return concat(resolve-uri('.',$c),extract(unparsed-text($c),'(.+m3u8)',1))}]}}],videos:=join($json()(),', '))" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF "%url%"=="http://www.omroepflevoland.nl/kijken" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" --xquery "name:=replace('%date%','.+?(\d+)-(\d+)-(\d+)','Omroep Flevoland - Livestream ($1$2$3)'),json:=[for $x in reverse(json(//script/extract(.,concat((//div[@class='jwplayercontainer'])[1]//@id,'.+sources:(.+?\])'),1,'s')[.])()) return (if (ends-with($x/file,'m3u8')) then tail(tokenize(unparsed-text($x/file),'#EXT-X-STREAM-INF:')) ! {'format':string(extract(.,'BANDWIDTH=(\d+)',1) idiv 1000),'url':concat(resolve-uri('.',$x/file),extract(.,'(.+m3u8)',1))} else {'format':replace(replace($x/file,'(.+?):.+\.(.+)','$1-$2'),'rtmp','rtsp'),'url':replace($x/file,'rtmp','rtsp')})],formats:=join($json()/format,', '),best:=$json()[last()]/format" --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.omroepflevoland.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" --xquery "let $a:=if (contains($url,'kijken')) then (//div[@class='jwplayercontainer'])[1] else //div[@class='jwplayercontainer'][@onclick] return if (count($a)=1) then (name:=concat('Omroep Flevoland - ',if (contains($url,'kijken')) then //meta[@name='keywords']/@content else extract($a/@data-video-name,'.+?- (.+) -',1),replace(//meta[@property='article:published_time']/@content,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)')),json:=[for $x in tail(reverse(json(//script/extract(.,concat($a/div/@id,'.+sources:(.+?\])'),1,'s')[.])())) return (if (ends-with($x/file,'m3u8')) then ({'format':'meta','url':$x/file},tail(tokenize(unparsed-text($x/file),'#EXT-X-STREAM-INF:')) ! {'format':string(extract(.,'BANDWIDTH=(\d+)',1) idiv 1000),'url':concat(resolve-uri('.',$x/file),extract(.,'(.+m3u8)',1))}) else ('laag','middel','hoog') ! {'format':concat('mp4-',.),'url':replace($x/file,'middel',.)})],let $b:=($json()[contains(format,'mp4')]/format,$json()[format='meta']/format,for $x in $json()[format castable as double]/format order by $x return $x) return (formats:=join($b,', '),best:=$b[last()])) else (json:=[for $x at $i in $a return {$i||'e':{'name':concat('Omroep Flevoland - ',extract($x/@data-video-name,'.+?- (.+) -',1),replace(//meta[@property='article:published_time']/@content,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)')),'formats':for $y in tail(reverse(json(//script/extract(.,concat($x/div/@id,'.+sources:(.+?\])'),1,'s')[.])())) return (if (ends-with($y/file,'m3u8')) then ({'format':'meta','url':$y/file},tail(tokenize(unparsed-text($y/file),'#EXT-X-STREAM-INF:')) ! {'format':string(extract(.,'BANDWIDTH=(\d+)',1) idiv 1000),'url':concat(resolve-uri('.',$y/file),extract(.,'(.+m3u8)',1))}) else ('laag','middel','hoog') ! {'format':concat('mp4-',.),'url':replace($y/file,'middel',.)})}}],videos:=join($json()(),', '))" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.rtvoost.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" --xquery "let $a:=//meta[@property='og:type']/@content return let $b:=replace(//meta[if (@property='video:release_date') then @property='video:release_date' else @property='article:published_time']/@content,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)') return let $c:=//script/extract(.,'\$\.ajax\(\"(.+^)\"',1)[.] return if (count($c)=1) then (if ($a='video.other') then (name:=replace('%date%','.+?(\d+)-(\d+)-(\d+)','RTV Oost - Livestream ($1$2$3)'),let $d:=json($c)//file return json:=[{'format':'meta','url':$d},tail(tokenize(unparsed-text($d),'#EXT-X-STREAM-INF:')) ! {'format':string(extract(.,'BANDWIDTH=(\d+)',1) idiv 1000),'url':concat(resolve-uri('.',$d),extract(.,'(.+m3u8)',1))}]) else (name:=concat('RTV Oost - ',if ($a='video.episode') then extract(//meta[@property='og:title']/@content,'(.+) van \d+',1) else //meta[@property='og:title']/@content,$b),json:=[(json($c)//sources)()/{'format':replace(label,'(\d+).','mp4-$1'),'url':file}]),let $e:=($json()[format='meta']/format,for $x in $json()[format!='meta']/format order by $x return $x) return (formats:=join($e,', '),best:=$e[last()])) else (json:=[for $x at $i in $c return {$i||'e':{'name':concat('RTV Oost - ',//div[@id=concat('video',$i)]/span[@class='mediaTitle'],$b),'formats':[(json($x)//sources)()/{'format':replace(label,'(\d+).','mp4-$1'),'url':file}]}}],videos:=join($json()(),', '))" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.at5.nl/live=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "http://www.at5.nl/video/json?s=live" --xquery "name:=replace('%date%','.+?(\d+)-(\d+)-(\d+)','AT5 - Livestream ($1$2$3)'),let $a:=json($raw)/source/(def)() return json:=[('a','b','c','d') ! {'format':concat('rtsp-',.),'url':concat(replace($a[type='rtmp']/file,'.+?(:.+).','rtsp$1'),.)},{'format':'meta','url':$a[type='hls']/file},tail(tokenize(unparsed-text($a[type='hls']/file),'#EXT-X-STREAM-INF:')) ! {'format':string(extract(.,'BANDWIDTH=(\d+)',1) idiv 1000),'url':concat(resolve-uri('.',$a[type='hls']/file),extract(.,'(.+m3u8)',1))}],let $b:=($json()[contains(format,'rtsp')]/format,$json()[format='meta']/format,for $x in $json()[format castable as double]/format order by $x return $x) return (formats:=join($b,', '),best:=$b[last()])" --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.at5.nl/gemist=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "name:=concat('AT5 - ',//div[@class='banner_label'],replace(//a[@class='video-player']/@href,'.+(\d{4})/(\d{2})/(\d{2}).+',' ($3$2$1)')),let $a:=json(replace(//script/extract(.,'sources: (.+),\s+\]',1,'s')[.],',\s+\}','}')||']')() return json:=[('low','medium','hi') ! {'format':concat('mp4-',.),'url':replace($a[last()]/file,'(.+_).+(\.mp4)',concat('$1',.,'$2'))},for $x in ('low','medium','hi') ! replace($a[type='hls']/file,'(.+_).+(\.mp4)',concat('$1',.,'$2')) return tail(tokenize(unparsed-text($x),'#EXT-X-STREAM-INF:')) ! {'format':string(extract(.,'BANDWIDTH=(\d+)',1) idiv 1000),'url':concat(resolve-uri('.',$x),extract(.,'(.+m3u8)',1))}],formats:=join($json()/format,', '),best:=$json()[last()]/format" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.at5.nl/artikelen=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "name:=concat('AT5 - ',//meta[@property='og:title']/@content,replace(//meta[@property='article:published_time']/@content,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)'))" -f "concat('http://www.at5.nl/embedder/smil?m=',//div/@data-video)" -e "json:=[//@src ! {'format':concat('mp4-',extract(.,'_(.+)\.',1)),'url':concat('http://rtvnh-dl1.streamgate.nl',substring-after(.,'content2'))},for $x in //@src ! concat(replace(//@base,'rtmp','http'),substring-after(.,'mp4:'),'/playlist.m3u8') return tail(tokenize(unparsed-text($x),'#EXT-X-STREAM-INF:')) ! {'format':string(extract(.,'BANDWIDTH=(\d+)',1) idiv 1000),'url':concat(resolve-uri('.',$x),extract(.,'(.+m3u8)',1))}],formats:=join($json()/format,', '),best:=$json()[last()]/format" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.rtvutrecht.nl/live=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "prid:=//script/extract(.,'\"prid\": \"(.+^)\"',1)[.]" --output-format^=cmd^"') DO %%A
	GOTO NPOLive_meta
) ELSE IF NOT "%url:www.rtvutrecht.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" --xquery "if (count(//div[contains(@id,'videoplayer')])=1) then let $a:=//script/extract(.,'(http.+mp4)',1)[.] return (name:=concat('RTV Utrecht - ',if (contains($url,'gemist')) then substring-before(//h2[@class='h2-large-met-grijs border-top'][1],' -') else replace(if (//p[@class='margin-bottom-5 fragment-bijschrift']/text()) then //p[@class='margin-bottom-5 fragment-bijschrift'] else //meta[@name='og:title']/@content,'[&quot;&apos;]',''''''),replace($a,'.+(\d{4})/(\d{2})/(\d{2}).+',' ($3$2$1)')),_url:=$a) else (json:=[for $x at $i in //div[contains(@id,'videoplayer')]/@id return {$i||'e':let $a:=//script[contains(.,$x)]/extract(.,'(http.+mp4)',1)[.] return {'name':concat('RTV Utrecht - ',replace(//p[@class='margin-bottom-5 fragment-bijschrift'][$i],'[&quot;&apos;]',''''''),replace($a,'.+(\d{4})/(\d{2})/(\d{2}).+',' ($3$2$1)')),'url':$a}}],videos:=join($json()(),', '))" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.omroepgelderland.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" --xquery "let $a:=//meta[@property='og:type']/@content return let $b:=replace(//@datetime,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)') return let $c:=//div[@data-button='player-still-overlay icon-play'] return if (count($c)=1) then if ($a) then (name:=if ($a='video:episode') then concat('Omroep Gelderland - ',(//h3)[1],replace(//@data-media,'.+?(\d+)/(\d+)/\d{4}(\d+).+',' ($3$2$1)')) else concat('Omroep Gelderland - ',replace($c/@title,'[&quot;&apos;]',''''''),$b),_url:=$c/@data-media) else (name:=replace('%date%','.+?(\d+)-(\d+)-(\d+)','Omroep Gelderland - Livestream ($1$2$3)'),url:=extract(unparsed-text(//@data-media),'(.+m3u8)',1)) else (json:=[for $x at $i in $c return {$i||'e':{'name':concat('Omroep Gelderland - ',replace($x/@title,'[&quot;&apos;]',''''''),$a),'url':$x/@data-media}}],videos:=join($json()(),', '))" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.omroepwest.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" --xquery "let $a:=//meta[@property='og:type']/@content return if (count(//@data-script)=1) then json(extract(unparsed-text(//@data-script),'var opts = (.+);',1))/(if ($a) then (name:=if ($a='video:episode') then replace(clipData/title,'(\d+)-(\d+)-(\d+).+- (.+)','Omroep West - $4 ($3$2$1)') else concat('Omroep West - ',replace(clipData/title,'[&quot;&apos;]',''''''),replace(clipData/publisheddate,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)')),let $b:=publicationData/defaultMediaAssetPath return json:=[clipData/(assets)()/{'format':concat('mp4-',bandwidth),'url':concat($b,src)}]) else (name:=replace('%date%','.+?(\d+)-(\d+)-(\d+)','Omroep West - Livestream ($1$2$3)'),let $b:=clipData/(assets)(1)/concat('http:',src) return json:=[{'format':'meta','url':$b},tail(tokenize(unparsed-text($b),'#EXT-X-STREAM-INF:')) ! {'format':string(extract(.,'BANDWIDTH=(\d+)',1) idiv 1000),'url':concat(resolve-uri('.',$b),extract(.,'(.+m3u8)',1))}]),let $c:=($json()[format='meta']/format,for $x in $json()[format!='meta']/format order by $x return $x) return (formats:=join($c,', '),best:=$c[last()])) else (json:=[//@data-script ! {position()||'e':json(extract(unparsed-text(.),'var opts = (.+);',1))/{'name':concat('Omroep West - ',replace(clipData/title,'[&quot;&apos;]',''''''),replace(clipData/publisheddate,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)')),'formats':let $b:=publicationData/defaultMediaAssetPath return [clipData/(assets)()/{'format':concat('mp4-',bandwidth),'url':concat($b,src)}]}}],videos:=join($json()(),', '))" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.rijnmond.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" --xquery "let $a:=//meta[@property='og:type']/@content return if (count(//@data-script)=1) then json(extract(unparsed-text(//@data-script),'var opts = (.+);',1))/(if ($a) then (name:=concat('RTV Rijnmond - ',if ($a='video:episode') then substring-before(clipData/title,' -') else replace(clipData/title,'[&quot;&apos;]',''''''),replace(clipData/publisheddate,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)')),let $b:=publicationData/defaultMediaAssetPath return json:=[clipData/(assets)()/{'format':concat('mp4-',bandwidth),'url':concat($b,src)}],let $c:=for $x in $json()/format order by $x return $x return (formats:=join($c,', '),best:=$c[last()])) else (name:=replace('%date%','.+?(\d+)-(\d+)-(\d+)','RTV Rijnmond - Livestream ($1$2$3)'),let $b:=clipData/(assets)(1)/concat('http:',src) return _url:=concat(resolve-uri('.',$b),extract(unparsed-text($b),'(.+m3u8)',1)))) else (json:=[//@data-script ! {position()||'e':json(extract(unparsed-text(.),'var opts = (.+);',1))/{'name':concat('RTV Rijnmond - ',replace(clipData/title,'[&quot;&apos;]',''''''),replace(clipData/publisheddate,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)')),'formats':let $b:=publicationData/defaultMediaAssetPath return [clipData/(assets)()/{'format':concat('mp4-',bandwidth),'url':concat($b,src)}]}}],videos:=join($json()(),', '))" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.omroepzeeland.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "name:=if (contains($url,'streams')) then replace('%date%','.+?(\d+)-(\d+)-(\d+)','Omroep Zeeland - Livestream ($1$2$3)') else concat('Omroep Zeeland - ',//meta[@property='og:title']/@content,replace(//div[@class='field field-post-date'],'.+?(\d+)-(\d+)-(\d+).+',' ($1$2$3)'))" -f "if (//script[contains(@src,'bbvms')]) then //script[contains(@src,'bbvms')]/@src else concat('http://omroepzeeland.bbvms.com/p/OmroepZeelandDefault/c/',//@data-bbwid,'.js')" --xquery "json(extract($raw,'var opts = (.+);',1))/(let $a:=publicationData/defaultMediaAssetPath return json:=[if (contains($url,'livetv')) then (clipData/(assets)()[mediatype='MP4_MAIN']/{'format':concat('rtmp-',bandwidth),'url':src},for $x in clipData/(assets)()[mediatype='MP4_IPOD']/src return tail(tokenize(unparsed-text($x),'#EXT-X-STREAM-INF:')) ! {'format':string(extract(.,'BANDWIDTH=(\d+)',1) idiv 1000),'url':concat(resolve-uri('.',$x),extract(.,'(.+m3u8)',1))}) else clipData/(assets)()/{'format':concat(replace(src,'.+\.(.+)','$1-'),bandwidth),'url':concat($a,src)}],let $b:=(for $x in $json()[contains(format,'rtmp')]/format order by $x return $x,for $x in $json()[not(contains(format,'rtmp'))]/format order by $x return $x) return (formats:=join($b,', '),best:=$b[last()]))" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.omroepbrabant.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" --xquery "let $a:=//meta[@property='og:type'] return if (count((//@data-url,//@data-script))=1) then json(extract(unparsed-text((//@data-url,//@data-script)),'var opts = (.+);',1))/clipData/(if ($a) then (name:=concat('Omroep Brabant - ',replace(title,'[&quot;&apos;]',''''''),replace(publisheddate,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)')),json:=[(assets)()/{'format':concat('mp4-',bandwidth),'url':src}]) else (name:=replace('%date%','.+?(\d+)-(\d+)-(\d+)','Omroep Brabant - Livestream ($1$2$3)'),let $b:=substring-before((assets)(1)/src,'?') return json:=[{'format':'meta','url':$b},tail(tokenize(unparsed-text($b),'#EXT-X-STREAM-INF:')) ! {'format':string(extract(.,'BANDWIDTH=(\d+)',1) idiv 1000),'url':concat(resolve-uri('.',$b),extract(.,'.+/(.+m3u8)',1))}]),let $c:=($json()[format='meta']/format,for $x in $json()[format!='meta']/format order by $x return $x) return (formats:=join($c,', '),best:=$c[last()])) else (json:=[//@data-script ! {position()||'e':json(extract(unparsed-text(.),'var opts = (.+);',1))/clipData/{'name':concat('Omroep West - ',replace(title,'[&quot;&apos;]',''''''),replace(publisheddate,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)')),'formats':[(assets)()/{'format':concat('mp4-',bandwidth),'url':src}]}}],videos:=join($json()(),', '))" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.l1.nl/epg_nowon/popup/tv=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -f "//iframe/@src" -e "prid:=//script/extract(.,'prid: \"(.+^)\"',1)[.]" --output-format^=cmd^"') DO %%A
	GOTO NPOLive_meta
) ELSE IF NOT "%url:www.l1.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" --xquery "json(extract(unparsed-text((//iframe ! doc(concat('http:',@src))//@src,//script[contains(@src,'bbvms')]/@src)),'var opts = (.+);',1))/(if (clipData) then (name:=concat('L1 - ',replace(clipData/title,'(.+) -.+','$1'),replace(clipData/publisheddate,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)')),let $a:=publicationData/defaultMediaAssetPath return json:=[clipData/(assets)()/{'format':concat('mp4-',bandwidth),'url':concat($a,src)}],let $b:=for $x in $json()/format order by $x return $x return (formats:=join($b,', '),best:=$b[last()])) else ())" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.telegraaf.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "name:=concat('Telegraaf - ',//h2,replace(//script/extract(.,'getPubDate.+?(\d+)',1,'s')[.],'(\d{4})(\d{2})(\d{2})',' ($3$2$1)'))" -f "//iframe/@src" -f "//script/extract(.,'playlist: \"(.+^)\"',1)[.]" --xquery "json:=$json//locations/[let $a:=(adaptive)(2)/src return ({'format':'meta','url':$a},tail(tokenize(unparsed-text($a),'#EXT-X-STREAM-INF:')) ! {'format':string(extract(.,'BANDWIDTH=(\d+)',1) idiv 1000),'url':concat(resolve-uri('.',$a),extract(.,'(.+m3u8)',1))}),(progressive)()/{'format':concat('mp4-',height),'url':.//src}],let $b:=(for $x in $json()[contains(format,'mp4')]/format order by $x return $x,$json()[format='meta']/format,for $x in $json()[format castable as double]/format order by $x return $x) return (formats:=join($b,', '),best:=$b[last()])" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:nickelodeon.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "let $a:=//meta[@itemprop='name']/@content return doc(//@data-mrss)/(name:=concat('Nickelodeon - ',$a,replace(//pubDate,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)')),json:=[doc(//media:content/@url)//rendition/{'format':concat('mp4-',@bitrate),'url':src}]),formats:=join($json()/format,', '),best:=$json()[last()]/format" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:ketnet.be=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" --xquery "let $a:=replace(//script/extract(.,'= new Date\((.+?)\);',1)[.] div 1000 * dayTimeDuration('PT1S') + date('1970-01-01'),'(\d+)-(\d+)-(\d+)',' ($3$2$1)') return json(//script/extract(.,'playerConfig = (.+\})',1)[.])/(if (unparsed-text-available(.//hls)) then (name:=concat('Ketnet - ',title,$a),let $b:=.//hls return json:=[{'format':'meta','url':$b},tail(tokenize(unparsed-text($b),'#EXT-X-STREAM-INF:')) ! {'format':string(extract(.,'BANDWIDTH=(\d+)',1) idiv 1000),'url':concat(resolve-uri('.',$b),extract(.,'(.+m3u8)',1))}],let $c:=($json()[format='meta']/format,for $x in $json()[format castable as double]/format order by $x return $x) return (formats:=join($c,', '),best:=$c[last()])) else ())" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:disney.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "ref:=string-to-base64Binary(concat('http://',$host))" -f "let $a:=//script/json(extract(.,'burger=(.+):\(',1)[.])//externals return concat('http://cdnapi.kaltura.com/api_v3/index.php?service=multirequest&format=1&1:service=session&1:action=startWidgetSession&1:widgetId=_',$a//account,'&2:service=baseentry&2:action=get&2:entryId=',$a//data_id,'&3:service=flavorAsset&3:action=getByEntryId&3:entryId=',$a//data_id)" --xquery "name:=$json(2)/concat('Disney - ',name,replace(createdAt * dayTimeDuration('PT1S') + date('1970-01-01'),'(\d+)-(\d+)-(\d+)',' ($3$2$1)')),json:=[let $a:=concat(substring-before($json(2)/dataUrl,'format'),'flavorIds/',join($json(3)()[isWeb='true']/id,','),'/format/applehttp/protocol/http?referrer=',$ref) return ({'format':'meta','url':x:request({'data':$a,'method':'HEAD','error-handling':'4xx=accept'})/(if (contains($headers[1],'404')) then () else url)},tail(tokenize(unparsed-text($a),'#EXT-X-STREAM-INF:')) ! {'format':string(extract(.,'BANDWIDTH=(\d+)',1) idiv 1000),'url':extract(.,'(.+m3u8.+)',1)},$json(3)()/{'format':if (isOriginal='true') then 'mp4-source' else concat(fileExt,'-',bitrate),'url':x:request({'data':concat($json(2)/dataUrl,'/flavorId/',id,'?referrer=',$ref),'method':'HEAD','error-handling':'4xx=accept'})/(if (contains($headers[1],'404')) then () else url)}[url])],let $b:=(for $x in $json()[contains(format,'-')]/format order by $x return $x,$json()[format='meta']/format,for $x in $json()[format castable as double]/format order by $x return $x) return (formats:=join($b,', '),best:=$b[last()])" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:cartoonnetwork.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -f "concat('http://cdnapi.kaltura.com/api_v3/index.php?service=multirequest&format=1&1:service=session&1:action=startWidgetSession&1:widgetId=_',//@data-partner-id,'&2:ks={1:result:ks}&2:service=baseentry&2:action=get&2:entryId=',//@data-video-id,'&3:ks={1:result:ks}&3:service=flavorAsset&3:action=getByEntryId&3:entryId=',//@data-video-id)" --xquery "name:=$json(2)/concat('Cartoon Network - ',name,replace(createdAt * dayTimeDuration('PT1S') + date('1970-01-01'),'(\d+)-(\d+)-(\d+)',' ($3$2$1)')),json:=[$json(3)()/{'format':if (isOriginal='true') then 'mp4-source' else concat(fileExt,'-',bitrate),'url':x:request({'data':concat(substring-before($json(2)/downloadUrl,'raw'),'playManifest/entryId/',$json(2)/id,'/flavorId/',id,'/format/url/protocol/http/a.',fileExt),'method':'HEAD','error-handling':'4xx=accept'})/(if (contains(headers[1],'404')) then () else url)}[url]],let $a:=for $x in $json()/format order by $x return $x return (formats:=join($a,', '),best:=$a[last()])" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:24kitchen.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "name:=concat('24Kitchen - ',//h1[@class='fn title'])" -f "extract($raw,'tp:releaseUrl=\"(.+^)\"',1)" --xquery "json:=[//video/{'format':concat('mp4-',@system-bitrate idiv 1000),'url':@src}],let $a:=for $x in $json()/format order by $x return $x return (formats:=join($a,', '),best:=$a[last()])" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:dumpert.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% -H "Cookie: nsfw=1;cpc=10" --user-agent "BatchGemist 1.52 beta" "%url%" --xquery "let $a:=json(if (//@data-files) then binary-to-string(base64Binary(//div/@data-files)) else //script/extract(.,'(\{.+\}),',1)[.]) return if ($a/embed) then _url:=replace($a/embed,'youtube:','https://youtu.be/') else (name:=concat('Dumpert - ',//meta[@name='title']/@content),json:=[$a()[.!='still'] ! {'format':.,'url':$a(.)}],let $b:=(for $x in $json()[format!='720p']/format order by $x return $x,$json()[format='720p']/format) return (formats:=join($b,', '),best:=$b[last()]))" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:comedycentral.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "let $a:=if (count(//@data-mrss)=1) then concat(//h1,' - ',(//h2)[1]) else //li[contains(a/@href,extract($url,'.+=(.+)|.+/(\d+)',(1,2))[.])] ! (if (@data-franchise) then concat(@data-franchise,' - ',a/@title) else replace(@data-title,':','')) return doc(if (count(//@data-mrss)=1) then //@data-mrss else //li[contains(a/@href,extract($url,'.+=(.+)|.+/(\d+)',(1,2))[.])]/@data-mrss)/(name:=concat('Comedy Central - ',$a,replace(//pubDate,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)')),doc(//media:content/@url)/(if (//rendition) then (json:=[//rendition/{'format':concat('mp4-',@bitrate),'url':src}],formats:=join($json()/format,', '),best:=$json()[last()]/format) else ()))" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:nl.funnyclips.cc=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "let $a:=//meta[@property='og:title']/@content return doc(//script/extract(.,'\{\}, ''(.+)''',1)[.])/(name:=concat('Funny Clips - ',$a,replace(//pubDate,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)')),doc(//media:content/@url)/(if (//rendition) then (json:=[//rendition/{'format':concat('mp4-',@bitrate),'url':src}],formats:=join($json()/format,', '),best:=$json()[last()]/format) else ()))" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:mtv.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "json(//script/extract(.,'pagePlaylist = (.+);',1)[.])()[id=extract($url,'.+/(\d+)-',1)]/(let $a:=if (subtitle!=null) then concat(title,' - ',subtitle) else title return doc(mrss)/(name:=concat($a,replace(//pubDate,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)')),doc(//media:content/@url)/(if (//rendition) then (json:=[//rendition/{'format':concat('mp4-',@bitrate),'url':src}],formats:=join($json()/format,', '),best:=$json()[last()]/format) else ())))" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:foxsports.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -f "concat('http://www.foxsports.nl/videodata/',//@data-videoid,'.xml')" -e "name:=concat('FOX Sports - ',//title,replace(//publicationDate,'(\d{4})(\d{2})(\d{2}).+',' ($3$2$1)'))" -f "//videoSource[@format='HLS']/uri" --xquery "json:=[{'format':'meta','url':$url},tail(tokenize($raw,'#EXT-X-STREAM-INF:')) ! {'format':string(extract(.,'BANDWIDTH=(\d+)',1) idiv 1000),'url':concat(resolve-uri('.'),extract(.,'(.+m3u8)',1))}],let $a:=($json()[format='meta']/format,for $x in $json()[format!='meta']/format order by $x return $x) return (formats:=join($a,', '),best:=$a[last()])" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:tweakers.net=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% --method^=POST "%url%" --xquery "if (//iframe) then let $a:=replace(//span[@itemprop='datePublished']/@content,'(\d+)-(\d+)-(\d+).+',' ($3$2$1)') return if (count(//iframe)=1) then json(doc(substring-before(//iframe/@src,'?'))//script/extract(.,',(\{.+)\)',1)[.])/(name:=concat('Tweakers - ',(.//title)[1],$a),json:=[(.//progressive)()/{'format':concat('mp4-',height),'url':(sources)()/src}]) else json:=[//iframe/doc(substring-before(./@src,'?'))/{position()||'e':json(//script/extract(.,',(\{.+)\)',1)[.])/{'name':concat('Tweakers - ',(.//title)[1],$a),'formats':(.//progressive)()/{'format':concat('mp4-',height),'url':(sources)()/src}}}] else json(//script/extract(.,',(\{.+)\)',1)[.])/(name:=concat('Tweakers - ',(.//title)[1]),json:=[(.//progressive)()/{'format':concat('mp4-',height),'url':(sources)()/src}]),if ($json(1)/format) then let $b:=for $x in $json()/format order by $x return $x return (formats:=join($b,', '),best:=$b[last()]) else videos:=join($json()(),', ')" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE (
	ECHO.
	ECHO Ongeldige programmalink.
	ECHO.
	ECHO.
	GOTO Input
)

IF DEFINED json (
	GOTO Formats
) ELSE IF DEFINED _url (
	GOTO Task
) ELSE (
	ECHO.
	ECHO Video niet (meer^) beschikbaar.
	ECHO.
	ECHO.
	ENDLOCAL
	GOTO Input
)

REM ================================================================================================

:NPO_meta
FOR /F "delims=" %%A IN ('^"%xidel% "http://e.omroep.nl/metadata/%prid%" --xquery "json(extract($raw,'\((.+)\)',1))/(name:=replace(concat(if (count(.//naam)=1) then .//naam else join(.//naam,' en '),' - ',if (ptype='episode') then (if (aflevering_titel) then (if (contains(titel,aflevering_titel)) then titel else (if (contains(aflevering_titel,titel)) then aflevering_titel else concat(titel,' - ',aflevering_titel))) else titel) else concat(.//serie_titel,' - ',titel),if (matches('%date%','^\d')) then ' (%date%)' else replace(x:request({'data':concat('http://www.npo.nl/',prid)})/url,'.+?(\d+)-(\d+)-(\d+).+',' ($1$2$3)')),'[&quot;&apos;]',''''''),prid:=prid,pubopties:=pubopties,streams:=streams,t:=if (tijdsduur instance of string) then hours-from-time(tijdsduur)*3600+minutes-from-time(tijdsduur)*60+seconds-from-time(tijdsduur) else (),ss:=hours-from-time(start)*3600+minutes-from-time(start)*60+seconds-from-time(start),to:=hours-from-time(eind)*3600+minutes-from-time(eind)*60+seconds-from-time(eind),tt888:=tt888)" --output-encoding^=oem --output-format^=cmd^"') DO %%A
GOTO NPO

REM ================================================================================================

:NPO
IF DEFINED pubopties (
	FOR /F "delims=" %%A IN ('ECHO %pubopties% ^| %xidel% "http://ida.omroep.nl/npoplayer/i.js" -e "token:=replace(extract($raw,'\"(.+^)\"',1),'^(.{5})((.*?)(\d)(.*?)(\d)(.*)|(.{6})(.)(.)(.*))(.{5})$','$1$3$6$5$4$7$8$10$9$11$12')" - --xquery "let $a:=for $x in $json/(if (contains(.(),'adaptive')) then tokenize(('adaptive '||join(.()[.!='adaptive'],',')),' ') else join(.(),',')) return if ($x='adaptive') then substring-before(json(concat('http://ida.omroep.nl/odi/?prid=%prid%&amp;puboptions=',$x,'&amp;adaptive=yes&amp;token=',$token))/(streams)(),'p&amp;callback') ! (if (unparsed-text-available(.)) then for $x in json(.) return ({'format':'meta','url':$x/url},tail(tokenize(unparsed-text($x/url),'#EXT-X-STREAM-INF:')) ! {'format':string(extract(.,'BANDWIDTH=(\d+)',1) idiv 1000),'url':concat(resolve-uri('.',$x/url),extract(.,'(.+m3u8)',1))}) else ()) else json(concat('http://ida.omroep.nl/odi/?prid=%prid%&amp;puboptions=',$x,'&amp;adaptive=no&amp;token=',$token))/(streams)() ! (if (unparsed-text-available(substring-before(.,'p&amp;callback'))) then json(substring-before(.,'p&amp;callback'))/{'format':concat('mp4-',extract(url,'.+/([a-z]+)',1)),'url':substring-before(url,'?')} else ()) return if ($a) then (json:=[$a],let $b:=(reverse($a[contains(format,'mp4')]/format),$a[format='meta']/format,for $x in $a[format castable as double]/format order by $x return $x) return (formats:=join($b,', '),best:=$b[last()])) else ()" --output-format^=cmd') DO %%A
) ELSE IF DEFINED streams (
	FOR /F "delims=" %%A IN ('ECHO %streams% ^| %xidel% - --xquery "if (count($json()/url)=1) then _url:=x:request({'data':$json()/url,'method':'HEAD','error-handling':'xxx=accept'})/(if (some $x in ('200','302') satisfies contains(headers[1],$x)) then url else ()) else let $a:=$json()/{'format':if (type) then concat('mp4-',max($json()/kwaliteit)+1) else concat(if (formaat='h264') then 'mp4' else formaat,'-',kwaliteit),'url':if (ends-with(url,'asf')) then doc(url)//@href else if (contains(url,'content-ip')) then x:request({'post':serialize-json([{\"file\":url}]),'url':'http://nos.nl/video/resolve/'})//file else x:request({'data':url,'method':'HEAD','error-handling':'xxx=accept'})/(if (some $x in ('200','302') satisfies contains(headers[1],$x)) then url else ())}[url] return if ($a) then (json:=[$a],let $b:=(for $x in $json()[contains(format,'wmv')]/format order by $x return $x,for $x in $json()[contains(format,'mp4')]/format order by $x return $x) return (formats:=join($b,', '),best:=$b[last()])) else ()" --output-format^=cmd') DO %%A
) ELSE (
	ECHO.
	ECHO Video niet beschikbaar.
	ECHO.
	ECHO.
	GOTO Input
)

IF DEFINED json (
	GOTO Formats
) ELSE IF DEFINED _url (
	GOTO Task
) ELSE (
	ECHO.
	ECHO Video niet beschikbaar.
	ECHO.
	ECHO.
	GOTO Input
)

REM ================================================================================================

:NPOLive_meta
FOR /F "delims=" %%A IN ('^"%xidel% "http://e.omroep.nl/metadata/%prid%" -e "json(extract($raw,'\((.+)\)',1))/(name:=concat(titel,replace('%date%','.+?(\d+)-(\d+)-(\d+)',' - Livestream ($1$2$3)')),hls:=(streams)()[type='hls']/url)" --output-encoding^=oem --output-format^=cmd^"') DO %%A
GOTO NPOLive

REM ================================================================================================

:NPOLive
FOR /F "delims=" %%A IN ('^"%xidel% "http://ida.omroep.nl/npoplayer/i.js" -f "concat('http://ida.omroep.nl/aapi/?stream=%hls%&token=',replace(extract($raw,'\"(.+^)\"',1),'^(.{5})((.*?)(\d)(.*?)(\d)(.*)|(.{6})(.)(.)(.*))(.{5})$','$1$3$6$5$4$7$8$10$9$11$12'))" -f "$json/stream" -e "json:=[{'format':'meta','url':$url},tail(tokenize($raw,'#EXT-X-STREAM-INF:')) ! {'format':string(extract(.,'BANDWIDTH=(\d+)',1) idiv 1000),'url':concat(resolve-uri('.'),extract(.,'(.+m3u8)',1))}],formats:=join($json()/format,', '),best:=$json()[last()]/format" --output-format^=cmd^"') DO %%A

IF DEFINED json (
	GOTO Formats
) ELSE (
	ECHO.
	ECHO Livestream niet beschikbaar.
	ECHO.
	ECHO.
	GOTO Input
)

REM ================================================================================================

:rtlXL
FOR /F "delims=" %%A IN ('^"%xidel% "http://www.rtl.nl/system/s4m/vfd/version=2/uuid=%uuid%/fmt=adaptive/" --xquery "$json/(name:=replace(concat(.//station,' - ',abstracts/name,' - ',if (.//classname='uitzending') then episodes/name else .//title,replace(.//original_date * dayTimeDuration('PT1S') + date('1970-01-01'),'(\d+)-(\d+)-(\d+)',' ($3$2$1)')),'[&quot;&apos;]',''''''),q:=.//quality)" -f "$json/(if (meta/nr_of_videos_total=0) then () else concat(meta/videohost,material/videopath))" --xquery "json:=[{'format':'meta','url':$url},tail(tokenize($raw,'#EXT-X-STREAM-INF:')) ! {'format':string(extract(.,'BANDWIDTH=(\d+)',1) idiv 1000),'url':extract(.,'(.+m3u8)',1)},{'format':'mp4-a2t','url':concat('http://pg.us.rtl.nl/rtlxl/network/a2t/progressive/',replace(substring-after($url,'/adaptive/'),'m3u8','mp4'))},{'format':'mp4-a3t','url':concat('http://pg.us.rtl.nl/rtlxl/network/a3t/progressive/',replace(substring-after($url,'/adaptive/'),'m3u8','mp4'))},if ($q='HD') then {'format':'mp4-nettv','url':concat('http://pg.us.rtl.nl/rtlxl/network/nettv/progressive/',replace(substring-after($url,'/adaptive/'),'m3u8','mp4'))} else ()],let $a:=($json()[contains(format,'mp4')]/format,$json()[format='meta']/format,for $x in $json()[format castable as double]/format order by $x return $x) return (formats:=join($a,', '),best:=$a[last()])" --output-encoding^=oem --output-format^=cmd^"') DO %%A

IF DEFINED json (
	GOTO Formats
) ELSE (
	ECHO.
	ECHO Video nog niet, of niet meer beschikbaar.
	ECHO.
	ECHO.
	GOTO Input
)

REM ================================================================================================

:Formats
SETLOCAL ENABLEDELAYEDEXPANSION
IF DEFINED videos (
	ECHO.
	ECHO Beschikbare video's: %videos%
	SET /P "video=Kies gewenste video: "
	FOR /F %%A IN ('^"%xidel% -e "if (matches('%videos%','^(.*\W)?!video!(\W.*)?$')) then '!video!' else 'error'"^"') DO (
		IF "%%A"=="error" (
			ECHO.
			ECHO Ongeldige video.
			ECHO.
			ECHO.
			ENDLOCAL
			GOTO Input
		)
	)
	FOR /F "delims=" %%A IN ('ECHO !json! ^| %xidel% - --xquery "$json()('!video!')/(name:=name,if (formats) then (json:=formats,let $a:=($json()[contains(format,'rtsp')]/format,for $x in $json()[contains(format,'mp4')]/format order by $x return $x,$json()[format='meta']/format,for $x in $json()[format castable as double]/format order by $x return $x) return (formats:=join($a,', '),best:=$a[last()])) else _url:=url)" --output-encoding^=oem --output-format^=cmd') DO %%A
)
IF DEFINED _url (
	GOTO Task
)

ECHO.
ECHO Beschikbare formaten: %formats%
SET /P "format=Voer gewenst formaat in: [%best%] "
IF "%format%"=="" SET "format=%best%"
FOR /F %%A IN ('^"%xidel% -e "if (matches('%formats%','^(.*\W)?%format%(\W.*)?$')) then '%format%' else 'error'"^"') DO (
	IF "%%A"=="error" (
		ECHO.
		ECHO Ongeldig formaat.
		ECHO.
		ECHO.
		ENDLOCAL
		GOTO Input
	)
)
FOR /F "delims=" %%A IN ('ECHO !json! ^| %xidel% - -e "_url:=$json()[format='%format%']/url" --output-format^=cmd') DO %%A
GOTO Task

REM ================================================================================================

:Task
SETLOCAL ENABLEDELAYEDEXPANSION
IF "%_url:youtu.be=%"=="%_url%" (
	ECHO.
	SET /P "task=Videolink achterhalen, of Downloaden? [V/d] "
	IF /I "!task!"=="d" GOTO Download

	IF DEFINED ss (
		IF "%_url:mms://=%"=="%_url%" (
			FOR /F "delims=" %%A IN ('^"%xidel% -e "concat('%_url%?start=',round(%ss%),'^&end=',round(%to%))"^"') DO SET "_url=%%A"
		)
	)
)

ECHO.
ECHO Videolink:
ECHO %_url%
ECHO|SET /P ="%_url:^=%"|clip.exe
ECHO.
ECHO Videolink gekopieerd naar het klembord.
ECHO.
ECHO.
ENDLOCAL
ENDLOCAL
GOTO Input

REM ================================================================================================

:Download
ECHO.
ECHO Doelmap: %~dp0
SET /P "remap=Wijzigen? [J/n] "
IF /I "%remap%"=="n" (
	SET "map=%~dp0"
) ELSE (
	SET /P "map=Opslaan in: "
)
IF NOT "%map:~-1%"=="\" SET "map=%map%\"

FOR /F "tokens=1 delims=?" %%A IN ("%_url%") DO (
	IF /I "%%~xA"==".m4a"  SET "ext=.m4a"
	IF /I "%%~xA"==".m4v"  SET "ext=.mp4"
	IF /I "%%~xA"==".mp4"  SET "ext=.mp4"
	IF /I "%%~xA"==".m3u8" SET "ext=.mp4"
	IF /I "%%~xA"==".asf"  SET "ext=.wmv"
)

ECHO.
SETLOCAL DISABLEDELAYEDEXPANSION
FOR /F "delims=" %%A IN ('^"%xidel% -e "name:=replace(replace(normalize-space('%name%'),':','-'),'[<>/\\|?*^]','')" --output-encoding^=oem --output-format^=cmd^"') DO %%A
ECHO Bestandsnaam: %name%
SET /P "rename=Wijzigen? [J/n] "
IF /I NOT "%rename%"=="n" (
	SET /P "name=Nieuwe bestandsnaam: "
)

SETLOCAL ENABLEDELAYEDEXPANSION
IF "%tt888%"=="ja" (
	ECHO.
	SET /P "subs=Ondertiteling Downloaden? [j/N] "
	IF /I "!subs!"=="j" (
		SET subs=1
		ECHO.
		SET /P "mux=Ondertiteling Muxen? [j/N] "
		IF /I "!mux!"=="j" (
			SET mux=1
		) ELSE (
			SET mux=
		)
	) ELSE (
		SET subs=
	)
)

IF NOT "%_url:mms://=%"=="%_url%" SET "_url=%_url:mms://=mmsh://%"

ECHO.
IF DEFINED ss (
	IF DEFINED mux (
		%ffmpeg% -hide_banner -ss %ss% -i "%_url%" -sub_charenc CP1252 -i "http://e.omroep.nl/tt888/%prid%" -t %t% -c copy -bsf:a aac_adtstoasc -c:s mov_text -metadata:s:s language=dut "!map!%name%%ext%"
	) ELSE (
		%ffmpeg% -hide_banner -ss %ss% -i "%_url%" -t %t% -c copy -bsf:a aac_adtstoasc "!map!%name%%ext%"
		IF DEFINED subs ECHO. & %ffmpeg% -hide_banner -ss %ss% -sub_charenc CP1252 -i "http://e.omroep.nl/tt888/%prid%" -t %t% "!map!%name%.srt"
	)
) ELSE (
	SET /P "part=Fragment downloaden? [j/N] "
	IF /I "!part!"=="j" (
		SET /P "ss=Voer begintijd in (in seconden, of als uu:mm:ss[.xxx]) []: "
		SET /P "t=Voer tijdsduur in (in seconden, of als uu:mm:ss[.xxx]) []: "
		ECHO.
		IF DEFINED mux (
			IF NOT DEFINED ss (
				%ffmpeg% -hide_banner -i "%_url%" -sub_charenc CP1252 -i "http://e.omroep.nl/tt888/%prid%" -t !t! -c copy -bsf:a aac_adtstoasc -c:s mov_text -metadata:s:s language=dut "!map!%name%%ext%"
			) ELSE IF "!ss!"=="0" (
				%ffmpeg% -hide_banner -i "%_url%" -sub_charenc CP1252 -i "http://e.omroep.nl/tt888/%prid%" -t !t! -c copy -bsf:a aac_adtstoasc -c:s mov_text -metadata:s:s language=dut "!map!%name%%ext%"
			) ELSE IF NOT DEFINED t (
				%ffmpeg% -hide_banner -ss !ss! -i "%_url%" -sub_charenc CP1252 -i "http://e.omroep.nl/tt888/%prid%" -c copy -bsf:a aac_adtstoasc -c:s mov_text -metadata:s:s language=dut "!map!%name%%ext%"
			) ELSE (
				%ffmpeg% -hide_banner -ss !ss! -i "%_url%" -sub_charenc CP1252 -i "http://e.omroep.nl/tt888/%prid%" -t !t! -c copy -bsf:a aac_adtstoasc -c:s mov_text -metadata:s:s language=dut "!map!%name%%ext%"
			)
		) ELSE (
			IF NOT DEFINED ss (
				%ffmpeg% -hide_banner -i "%_url%" -t !t! -c copy -bsf:a aac_adtstoasc "!map!%name%%ext%"
				IF DEFINED subs ECHO. & %ffmpeg% -hide_banner -sub_charenc CP1252 -i "http://e.omroep.nl/tt888/%prid%" -t !t! "!map!%name%.srt"
			) ELSE IF "!ss!"=="0" (
				%ffmpeg% -hide_banner -i "%_url%" -t !t! -c copy -bsf:a aac_adtstoasc "!map!%name%%ext%"
				IF DEFINED subs ECHO. & %ffmpeg% -hide_banner -sub_charenc CP1252 -i "http://e.omroep.nl/tt888/%prid%" -t !t! "!map!%name%.srt"
			) ELSE IF NOT DEFINED t (
				%ffmpeg% -hide_banner -ss !ss! -i "%_url%" -c copy -bsf:a aac_adtstoasc "!map!%name%%ext%"
				IF DEFINED subs ECHO. & %ffmpeg% -hide_banner -ss !ss! -sub_charenc CP1252 -i "http://e.omroep.nl/tt888/%prid%" "!map!%name%.srt"
			) ELSE (
				%ffmpeg% -hide_banner -ss !ss! -i "%_url%" -t !t! -c copy -bsf:a aac_adtstoasc "!map!%name%%ext%"
				IF DEFINED subs ECHO. & %ffmpeg% -hide_banner -ss !ss! -sub_charenc CP1252 -i "http://e.omroep.nl/tt888/%prid%" -t !t! "!map!%name%.srt"
			)
		)
	) ELSE (
		ECHO.
		IF DEFINED mux (
			%ffmpeg% -hide_banner -i "%_url%" -sub_charenc CP1252 -i "http://e.omroep.nl/tt888/%prid%" -c copy -bsf:a aac_adtstoasc -c:s mov_text -metadata:s:s language=dut "!map!%name%%ext%"
		) ELSE (
			%ffmpeg% -hide_banner -i "%_url%" -c copy -bsf:a aac_adtstoasc "!map!!name!%ext%"
			IF DEFINED subs ECHO. & %ffmpeg% -hide_banner -sub_charenc CP1252 -i "http://e.omroep.nl/tt888/%prid%" "!map!%name%.srt"
		)
	)
)
ECHO.
ECHO.
ENDLOCAL
ENDLOCAL
ENDLOCAL
ENDLOCAL
GOTO Input

REM ================================================================================================

:Help
ECHO.
ECHO   [Beschrijving]
ECHO     BatchGemist is een batchscript om video's van verscheidene websites te downloaden, of de
ECHO     videolink ervan te achterhalen.
ECHO.
ECHO   [Benodigdheden]
ECHO     - xidel.exe (http://videlibri.sourceforge.net/xidel.html#downloads)
ECHO       Xidel is het hart van BatchGemist en is verantwoordelijk voor het ontleden van zo'n beetje
ECHO       alle gegevens.
ECHO       Download Xidel (versie 0.9.4 of nieuwer) en plaats 'xidel.exe' in dezelfde map als dit
ECHO       batchscript, of wijzig de programma-map in dit script onder ":Check".
ECHO     - ffmpeg.exe (http://ffmpeg.zeranoe.com/builds)
ECHO       Met de gegenereerde videolink als invoer zorgt FFMpeg ervoor dat de video effici‰nt wordt
ECHO       gedownload.
ECHO       Download FFMpeg en plaats 'ffmpeg.exe' in dezelfde map als dit batchscript, of wijzig de
ECHO       programma-map in dit script onder ":Check".
ECHO     - clip.exe (http://www.c3scripts.com/tutorials/msdos/clip.zip) [Windows XP]
ECHO       Clip kopieert de videolink naar het klembord. Vanaf Windows Vista wordt 'clip.exe' standaard
ECHO       meegeleverd, dus dit is alleen voor Windows XP gebruikers.
ECHO       Download Clip en plaats 'clip.exe' in de C:\WINDOWS\system32 map.
ECHO.
ECHO   [Ondersteunde websites]
ECHO     npo.nl                eenvandaag.nl         omropfryslan.nl           rtvutrecht.nl
ECHO     gemi.st               101.tv                rtvnoord.nl               omroepgelderland.nl
ECHO     2doc.nl                                     rtvdrenthe.nl             omroepwest.nl
ECHO     anderetijden.nl       rtl.nl                rtvnh.nl                  rijnmond.nl
ECHO     schooltv.nl           rtlxl.nl              omroepflevoland.nl        omroepzeeland.nl
ECHO     willemwever.nl        rtlnieuws.nl          rtvoost.nl                omroepbrabant.nl
ECHO     nos.nl                kijk.nl               at5.nl                    l1.nl
ECHO.
ECHO.
PAUSE
ECHO.
ECHO     telegraaf.nl              comedycentral.nl
ECHO     nickelodeon.nl            nl.funnyclips.cc
ECHO     ketnet.be                 mtv.nl
ECHO     disney.nl                 foxsports.nl
ECHO     cartoonnetwork.nl         tweakers.net
ECHO     24kitchen.nl              collegerama.tudelft.nl
ECHO     dumpert.nl
ECHO.
ECHO   [Gebruik]
ECHO     Surf naar ‚‚n van de ondersteunde websites en kopieer de programmalink van een gewenst
ECHO     programma. Start dit batch-script en plak deze link d.m.v. rechtermuis-knop + plakken (Ctrl+V
ECHO     werkt hier niet).
ECHO.
ECHO     Dan volgt een opsomming van beschikbare formaten en wordt er gevraagd een keuze te maken.
ECHO     E‚n formaat, tussen blokhaken, is altijd voorgeselecteerd om de hoogste resolutie. Voor dit
ECHO     formaat kun je gewoon op ENTER drukken. Het formaat 'meta' en de formaten met alleen een getal
ECHO     zijn dynamische videostreams. De formaten die beginnen met 'mp4' zijn progressieve
ECHO     videostreams.
ECHO     Deze stap wordt overgeslagen als er maar ‚‚n formaat beschikbaar is.
ECHO.
ECHO     Dan volgen een aantal keuzevragen, beginnend met 'Videolink achterhalen, of Downloaden?
ECHO     [V/d]'. De keuze met hoofdletter is voorgeselecteerd. Voor 'Videolink achterhalen' kun je dan
ECHO     gewoon op ENTER drukken. Voor 'Downloaden' moet je wel 'd' invullen.
ECHO     Voor de '[J/n]'-, of '[j/N]'-vragen die dan volgen geldt precies hetzelfde. De keuze met
ECHO     hoofdletter is voorgeselecteerd.
ECHO.
ECHO     Druk op ENTER om BatchGemist af te sluiten.
ECHO.
ECHO.
IF DEFINED check (
	PAUSE & GOTO :EOF
) ELSE (
	GOTO Input
)
