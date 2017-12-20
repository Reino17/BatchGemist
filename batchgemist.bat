@ECHO off
CLS

REM BatchGemist versie 1.6
REM 
REM   Veranderingslogboek:
REM     xx-xx-2017 v1.6:
REM       - 
REM     26-10-2016 v1.51:
REM       - Ondersteuning voor Collegerama TU Delft verwijderd i.v.m. copyright van het
REM         beeldmateriaal.
REM       - NPO extractor: Spaties in video-url van videofragmenten verholpen, waardoor ze nu wel
REM         zijn te downloaden / af te spelen. Extra beschikbaarheids controle toegevoegd voor
REM         videofragmenten die uiteindelijk toch niet beschikbaar zijn.
REM     16-10-2016 v1.5:
REM       [Batch code]
REM         - Onder :Input waar mogelijk 'GOTO'-commando's onderaan in IF-statement ondergebracht.
REM         - :Formats sterk geoptimaliseerd door veel van de speciale queries onderaan bij de
REM           desbetreffende extractors onder te brengen.
REM         - Onder :Task extra IF-statement toegevoegd voor de twee extractors die Youtube-urls
REM           teruggeven. Omdat mijn script het downloaden van Youtube-urls niet ondersteunt, wordt
REM           deze vraag in dit geval overgeslagen.
REM         - Onder :Task extra IF-statement toegevoegd voor oude 'Silverlight' videostreams, omdat
REM           deze geen fragment selectie in de video-url ondersteunen.
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
REM         - 101TV extractor: Gerepareerd en ondersteuning toegevoegd voor Youtube-urls.
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
REM         - Dumpert extractor: Youtube-url controle voorheen onder :Formats nu geïntegreerd.
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
REM       - Gerepareerd: rtlXL 720p progressieve videostream, niet meer werkende video-url in Disney
REM         videoclips extractor en naam video in Disney- en Cartoon Network extractor.
REM       - :Download opgeschoond.
REM     30-03-2016 v1.4:
REM       - Xidel queries geüpdatet in lijn met versie 0.9.1.20160322.
REM       - Disney extractor geoptimaliseerd en is nu af. Tijdelijke oplossing aan :Formats
REM         toegevoegd voor het downloaden van de progressieve videostreams.
REM         LET OP: voor het downloaden van de dynamische videostreams is FFMpeg ná 16 maart nodig!
REM       - Ondersteuning toegevoegd voor: Cartoon Network.
REM       - Samenvoeging programma-url controle NPO en NPOLive teniet gedaan en een aparte regel
REM         voor de livestream van NPO 3 toegevoegd, omdat deze voor problemen bleef zorgen.
REM         Hierdoor :NPO_meta en :NPOLive_meta ook geüpdatet.
REM       - NOS- en 101TV extractor geoptimaliseerd door beter inzicht in Xidel's mogelijkheden.
REM       - NPO extractor geoptimaliseerd en, dankzij een nieuwe versie van Xidel, uitgebreid met
REM         een extra beschikbaarheids controle. Ook procenttekens in gecodeerde video-urls worden
REM         nu goed weergegeven.
REM       - rtlXL extractor gerepareerd: Samenstelling video-url progressieve videostreams. Extra
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
REM       - Programma-url controle van NPO en NPOLive samengevoegd met prid-check, vanwege de
REM         livestream van NPO 3, die als enige 'live' niet in de url heeft.
REM       - Gerepareerd: Escape characters in video-urls van Collegerama TU Delft.
REM       - De :Formats_xxx subroutines teruggebracht tot één grote.
REM       - Overzicht ondersteunde websites onder :Help ingekort.
REM     15-11-2015 v1.2:
REM       - Ondersteuning toegevoegd voor: NPO Doc, Eenvandaag, Telegraaf en Disney videoclips.
REM       - Door ondersteuning van Telegraaf, :Formats_json2 aangemaakt en :Tweakers ondergebracht
REM         bij :Input.
REM       - Door ondersteuning van Eenvandaag, tijdcode-calculaties voor :NPO videofragmenten aan
REM         Xidel overgelaten.
REM       - NPO extractor opgedeeld in :NPO_meta en :NPO.
REM       - Extra FOR-loop toegevoegd voor eventueel achtervoegsel in rtl-embed-url.
REM     04-10-2015 v1.1:
REM       - Script aanzienlijk verkort door websites en veel voorkomende functies onder te verdelen
REM         in aparte subroutines.
REM       - Ondersteuning toegevoegd voor: Ketnet en 24Kitchen.
REM       - RTVNoord-, RTVDrenthe- en RTVDrenthe_Live extractor vernieuwd.
REM     29-09-2015 v1.0:
REM       - Eerste versie.
REM
REM BatchGemist is geschreven door Reino Wijnsma en is terug te vinden op
REM http://rwijnsma.home.xs4all.nl/uitzendinggemist/batchgemist.htm.
REM Copyright (C) 2017 Reino Wijnsma. Op dit script is de GNU GPLv3 Licentie van toepassing.

SET ver=1.6-git
REM Venster (buffer)grootte en kleur wijzigen (https://stackoverflow.com/a/13351373)
MODE con: cols=100 lines=32
COLOR 1f
FOR /F "tokens=4,5 delims=[.XP " %%A IN ('VER') DO (
	IF %%A.%%B LSS 6.1 (
		FOR /F "tokens=3" %%A IN ('REG QUERY "HKLM\SOFTWARE\Microsoft\PowerShell\1" /v Install ^| FIND "Install"') DO (
			IF NOT "%%A"=="0x1" (
				TITLE BatchGemist %ver%
				ECHO Venster buffergrootte niet kunnen wijzigen, omdat PowerShell niet is ge‹nstalleerd.
				ECHO PowerShell 2.0 voor Windows XP: https://www.microsoft.com/en-us/download/details.aspx?id=16818
				ECHO PowerShell 2.0 voor Windows Vista x86: https://www.microsoft.com/en-us/download/details.aspx?id=9864
				ECHO PowerShell 2.0 voor Windows Vista x64: https://www.microsoft.com/en-us/download/details.aspx?id=9239
				ECHO.
				ECHO.
			) ELSE (
				powershell -command "&{$H=get-host;$W=$H.ui.rawui;$B=$W.buffersize;$B.width=100;$B.height=1024;$W.buffersize=$B;$W.windowtitle='BatchGemist %ver%';}"
			)
		)
	) ELSE (
		powershell -command "&{$H=get-host;$W=$H.ui.rawui;$B=$W.buffersize;$B.width=100;$B.height=1024;$W.buffersize=$B;$W.windowtitle='BatchGemist %ver%';}"
	)
)

REM ================================================================================================

:Check
SET xidel="xidel.exe"
SET ffmpeg="ffmpeg.exe"
SET mpc=""

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
ECHO Voer programma-url in (of 'h' voor hulp):
SET /P url=
IF NOT DEFINED url GOTO :EOF
IF /I "%url%"=="v" GOTO Versie
IF /I "%url%"=="h" GOTO Help
:Process
IF NOT "%url: =%"=="%url%" (
	ECHO.
	ECHO Spaties in programma-url niet toegestaan.
	ECHO.
	ECHO.
	GOTO Input
) ELSE IF "%url%"=="npo-radio" (
	GOTO NPORadio
) ELSE IF "%url%"=="npo-gids" (
	GOTO NPOGids
) ELSE IF NOT "%url:npo.nl/live=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% --user-agent "BatchGemist %ver%" "%url%" -e "prid:=//@media-id" --output-format^=cmd^"') DO %%A
	GOTO NPO
) ELSE IF NOT "%url:npo.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel%
	-e ^"prid:^=extract(
	      '%url%'^,
	      '.+/(.+\d+^)'^,
	      1
	    ^)^,
	    date:^=replace(
	      '%url%'^,
	      '.+?(\d+^)-(\d+^)-(\d+^).+'^,
	      '$1$2$3'
	    ^)^" --output-format^=cmd^"') DO %%A
	GOTO NPO
) ELSE IF NOT "%url:gemi.st=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel%
	-e ^"prid:^=extract(
	      '%url%'^,
	      '.+/(.+\d+^)'^,
	      1
	    ^)^,
	    date:^=replace(
	      '%url%'^,
	      '.+?(\d+^)-(\d+^)-(\d+^).+'^,
	      '$1$2$3'
	    ^)^" --output-format^=cmd^"') DO %%A
	GOTO NPO
) ELSE IF NOT "%url:uitzendinggemist.net/aflevering=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	-e ^"url:^=x:request(
	      {
	        'data':let $a:^=(
	          //iframe[@class]/@src^,
	          extract(
	            //@onclick^,
	            '(http.+?^)'''^,
	            1
	          ^)
	        ^) return
	        replace(
	          $a^,
	          '.+(?:/^|^=^)(.+^)'^,
	          if (contains($a^,'npo'^)^) then
	            'http://www.npo.nl/$1'
	          else if (contains($a^,'rtl'^)^) then
	            'http://www.rtl.nl/video/$1'
	          else
	            'http://www.kijk.nl/video/$1'
	        ^)^,
	        'user-agent':'BatchGemist %ver%'^,
	        'method':'HEAD'
	      }
	    ^)/url^" --output-format^=cmd^"') DO %%A
	GOTO Process
) ELSE IF NOT "%url:2doc.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	-e ^"prid:^=(//@data-media-id^)[1]^,
	    date:^=replace(
	      (//@datetime^)[1]^,
	      '(\d+^)-(\d+^)-(\d+^)'^,
	      '$3$2$1'
	    ^)^" --output-format^=cmd^"') DO %%A
	GOTO NPO
) ELSE IF NOT "%url:anderetijden.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	-e ^"if ^(count^(//figure[@data-mid]^)^=1^) then
	      prid:^=//figure[@data-mid]/@data-mid
	    else
	      videos:^=[
	        //figure[@data-mid]/{
	          position^(^):{
	            'name':.//h2^,
	            'prid':@data-mid^,
	            'goto':'NPO'
	          }
	        }
	      ]^" --output-format^=cmd^"') DO %%A
	IF DEFINED prid GOTO NPO
) ELSE IF NOT "%url:schooltv.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	-e ^"prid:^=//div/@data-mid^,
	    date:^=replace(
	      //dd[span[@property^='datePublished']]^,
	      '(\d+^)-(\d+^)-(\d+^)'^,
	      '$1$2$3'
	    ^)^" --output-format^=cmd^"') DO %%A
	GOTO NPO
) ELSE IF NOT "%url:willemwever.kro-ncrv.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "prid:=//@data-video-id" --output-format^=cmd^"') DO %%A
	GOTO NPO
) ELSE IF NOT "%url:nos.nl/livestream=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	--xquery ^"name:^=//h1^|^|replace^(
	            '%date%'^,
	            '.+?^(\d+^)-^(\d+^)-^(\d+^)'^,
	            ': Livestream ^($1$2$3^)'
	          ^)^,
	          let $a:^=//video/x:request^(
	            {
	              'post':serialize-json^(
	                {
	                  'stream':string^(@data-stream^)
	                }
	              ^)^,
	              'url':@data-path
	            }
	          ^)/json/json^(
	            substring-before^(
	              url^,
	              'p^&amp^;callback'
	            ^)
	          ^) return
	          formats:^=[
	            {
	              'format':'hls-master'^,
	              'extension':'m3u8'^,
	              'url':$a
	            }^,
	            for $x in tail^(
	              tokenize^(
	                extract^(
	                  unparsed-text^($a^)^,
	                  '^(#EXT-X-STREAM-INF.+m3u8$^)'^,
	                  1^,'ms'
	                ^)^,
	                '#EXT-X-STREAM-INF:'
	              ^)
	            ^) ! {
	              'format':'hls-'^|^|extract^(
	                .^,
	                'BANDWIDTH^=^(\d+^)\d{3}'^,
	                1
	              ^)^,
	              'extension':'m3u8'^,
	              'resolution':extract^(
	                .^,
	                'RESOLUTION^=^(.+^)^,'^,
	                1
	              ^)^,
	              'vbitrate':extract^(
	                .^,
	                'video^=^(\d+^)\d{3}'^,
	                1
	              ^) ! ^(
	                if ^(.^) then
	                  concat^(
	                    'v:'^,
	                    .^,
	                    'k'
	                  ^)
	                else
	                  ''
	              ^)^,
	              'abitrate':replace^(
	                .^,
	                '.+audio.+?^(\d+^)\d{3}.+'^,
	                'a:$1k'^,
	                's'
	              ^)^,
	              'url':resolve-uri^(
	                '.'^,
	                $a
	              ^)^|^|extract^(
	                .^,
	                '^(.+m3u8^)'^,
	                1
	              ^)
	            } order by $x/format return $x
	          ]^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:nos.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	--xquery ^"declare function local:extract^($arg^){
	            [
	              for $x at $i in $arg order by extract^(
	                $x/@data-label^,
	                '^(\d+^)p'^,
	                1
	              ^) count $i
	              let $a:^=if ^(
	                contains^(
	                  $x/@src^,
	                  'content-ip'
	                ^)
	              ^) then
	                x:request^(
	                  {
	                    'post':serialize-json^(
	                      [
	                        {
	                          'file':string^($x/@src^)
	                        }
	                      ]
	                    ^)^,
	                    'url':'https://nos.nl/video/resolve/'
	                  }
	                ^)//file
	              else
	                $x/@src
	              return
	              system^(
	                x'cmd /c ^"FFMpeg\ffmpeg-N-87867-g0655810-win32-static_legacy.exe^" -i {$a} 2^>^&amp^;1'
	              ^) ! {
	                'format':'mp4-'^|^|$i^,
	                'extension':'mp4'^,
	                'resolution':extract^(
	                  .^,
	                  'Video:.+^, ^(\d+x\d+^)'^,
	                  1
	                ^)^,
	                'vbitrate':replace^(
	                  .^,
	                  '.+Video:.+?^(\d+^) kb.+'^,
	                  'v:$1k'^,
	                  's'
	                ^)^,
	                'abitrate':replace^(
	                  .^,
	                  '.+Audio:.+?^(\d+^) kb.+'^,
	                  'a:$1k'^,
	                  's'
	                ^)^,
	                'url':$a
	              }
	            ]
	          }^;
	          if ^(//div[@class^='video-play']^) then
	            videos:^=[
	              //div[@class^='video-play']/a/doc^(@href^)/{
	                position^(^):{
	                  'name':concat^(
	                    'NOS: '^,
	                    replace^(
	                      //h1^,
	                      '[^&quot^;^&apos^;]'^,
	                      ''''''
	                    ^)^,
	                    replace^(
	                      //@datetime^,
	                      '^(\d+^)-^(\d+^)-^(\d+^).+'^,
	                      ' ^($3$2$1^)'
	                    ^)
	                  ^)^,
	                  'formats':local:extract^(//source^)
	                }
	              }
	            ]
	          else ^(
	            name:^=concat^(
	              'NOS: '^,
	              replace^(
	                //h1^,
	                '[^&quot^;^&apos^;]'^,
	                ''''''
	              ^)^,
	              replace^(
	                //@datetime^,
	                '^(\d+^)-^(\d+^)-^(\d+^).+'^,
	                ' ^($3$2$1^)'
	              ^)
	            ^)^,
	            formats:^=local:extract^(//source^)
	          ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:eenvandaag.avrotros.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%" -e "prid:=json(//@data-at-player)/video_id" --output-format^=cmd^"') DO %%A
	GOTO NPO
) ELSE IF NOT "%url:static.rtl.nl/embed=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel%
	-e ^"uuid:^=extract(
	      '%url%'^,
	      'uuid=([\w-]+^)'^,
	      1
	    ^)^" --output-format^=cmd^"') DO %%A
	GOTO rtlXL
) ELSE IF NOT "%url:rtlxl.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel%
	-e ^"uuid:^=extract(
	      '%url%'^,
	      'video/([\w-]+^)'^,
	      1
	    ^)^" --output-format^=cmd^"') DO %%A
	GOTO rtlXL
) ELSE IF NOT "%url:rtl.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel%
	-e ^"uuid:^=extract(
	      '%url%'^,
	      'video/([\w-]+^)'^,
	      1
	    ^)^" --output-format^=cmd^"') DO %%A
	GOTO rtlXL
) ELSE IF NOT "%url:rtlnieuws.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% --user-agent "BatchGemist %ver%" "%url%"
	-e ^"uuid:^=extract(
	      //div[@class^='videoContainer']//@src^,
	      '^=(.+^)/'^,
	      1
	    ^)^" --output-format^=cmd^"') DO %%A
	GOTO rtlXL
) ELSE IF NOT "%url:rtlz.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% --user-agent "BatchGemist %ver%" "%url%"
	-e ^"uuid:^=//iframe/extract(
	      @src^,
	      'uuid^=(.+?^)/'^,
	      1
	    ^)[.]^" --output-format^=cmd^"') DO %%A
	GOTO rtlXL
) ELSE IF NOT "%url:kijk.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel%
	-e ^"prid:^=extract(
	      '%url%'^,
	      '(?:video^|videos^)/(\w+^)'^,
	      1
	    ^)^" --output-format^=cmd^"') DO %%A
	GOTO Kijk
) ELSE IF NOT "%url:sbs6.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel%
	-e ^"prid:^=extract(
	      '%url%'^,
	      'videos/(\w+^)'^,
	      1
	    ^)^" --output-format^=cmd^"') DO %%A
	GOTO Kijk
) ELSE IF NOT "%url:www.omropfryslan.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	--xquery ^"if (contains($url^,'live'^)^) then
	            let $a:^=json(
	              doc(
	                //script/extract(
	                  .^,
	                  'playlist: \^"(.+^^^)\^"'^,1
	                ^)[.]
	              ^)
	            ^)(2^)/(sources^)(^) return (
	              name:^=concat(
	                substring-before(
	                  //meta[@itemprop^='name']/@content^,
	                  'TV'
	                ^)^,
	                replace(
	                  '%date%'^,
	                  '.+?(\d+^)-(\d+^)-(\d+^)'^,
	                  '- Livestream ($1$2$3^)'
	                ^)
	              ^)^,
	              json:^=[
	                doc(
	                  $a[type^='rtmp']/file
	                ^)//video/{
	                  'format':concat(
	                    'rtsp-'^,
	                    @system-bitrate idiv 1000
	                  ^)^,
	                  'url':concat(
	                    replace(
	                      //@base^,
	                      'rtmp'^,
	                      'rtsp'
	                    ^)^,
	                    @src
	                  ^)
	                }^,
	                let $b:^=$a[type^='hls']/file return (
	                  {
	                    'format':'meta'^,
	                    'url':$b
	                  }^,
	                  tail(
	                    tokenize(
	                      unparsed-text($b^)^,
	                      '#EXT-X-STREAM-INF:'
	                    ^)
	                  ^) ! {
	                    'format':string(
	                      extract(
	                        .^,
	                        'BANDWIDTH^=(\d+^)'^,1
	                      ^) idiv 1000
	                    ^)^,
	                    'url':concat(
	                      resolve-uri('.'^,$b^)^,
	                      extract(
	                        .^,
	                        '(.+m3u8^)'^,1
	                      ^)
	                    ^)
	                  }
	                ^)
	              ]^,
	              formats:^=join($json(^)/format^,'^, '^)^,
	              best:^=$json(^)[last(^)]/format
	            ^)
	          else
	            let $a:^=replace(
	              //meta[@property^='article:published_time']/@content^,
	              '(\d+^)-(\d+^)-(\d+^).+'^,
	              ' ($3$2$1^)'
	            ^)
	            let $b:^=//script/json(
	              extract(
	                .^,
	                '(\{\^"sources\^".+?^)\^)'^,1^,'s'
	              ^)[.]
	            ^) return
	            if (count($b^)^=1^) then (
	              name:^=concat(
	                'Omrop FryslGn - '^,
	                if (contains($url^,'utstjoering'^)^) then
	                  substring-before(
	                    //meta[@itemprop^='name']/@content^,
	                    ' fan'
	                  ^)
	                else
	                  replace(
	                    $b//idstring^,
	                    '^&amp^;quot^;'^,
	                    ''''''
	                  ^)^,
	                $a
	              ^)^,
	              json:^=[
	                $b/(sources^)(^)/{
	                  'format':replace(
	                    label^,
	                    '(\d+^).'^,
	                    'mp4-$1'
	                  ^)^,
	                  'url':file
	                }
	              ]^,
	              formats:^=join($json(^)/format^,'^, '^)^,
	              best:^=$json(^)[last(^)]/format
	            ^) else (
	              json:^=[
	                $b/{
	                  position(^)^|^|'e':{
	                    'name':concat(
	                      'Omrop FryslGn - '^,
	                      replace(
	                        .//idstring^,
	                        '^&amp^;quot^;'^,
	                        ''''''
	                      ^)^,
	                      $a
	                    ^)^,
	                    'formats':(sources^)(^)/{
	                      'format':replace(
	                        label^,
	                        '(\d+^).'^,
	                        'mp4-$1'
	                      ^)^,
	                      'url':file
	                    }
	                  }
	                }
	              ]^,
	              videos:^=join($json(^)(^)^,'^, '^)
	            ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.rtvnoord.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	--xquery ^"if (contains($url^,'livetv'^)^) then (
	            name:^=replace(
	              '%date%'^,
	              '.+?(\d+^)-(\d+^)-(\d+^)'^,
	              'RTV Noord - Livestream ($1$2$3^)'
	            ^)^,
	            let $a:^=doc(
	              doc(
	                doc(
	                  //iframe/@src
	                ^)//@src
	              ^)/extract(.^,'\^"playlist\^": \^"(.+^^^)\^"^,'^,1^)
	            ^)//@file return
	            json:^=[
	              {
	                'format':'meta'^,
	                'url':$a
	              }^,
	              tail(
	                tokenize(
	                  unparsed-text($a^)^,
	                  '#EXT-X-STREAM-INF:'
	                ^)
	              ^) ! {
	                'format':string(
	                  extract(
	                    .^,'BANDWIDTH^=(\d+^)'^,1
	                  ^) idiv 1000
	                ^)^,
	                'url':concat(
	                  resolve-uri('.'^,$a^)^,
	                  extract(
	                    .^,'(.+m3u8^)'^,1
	                  ^)
	                ^)
	              }
	            ]^,
	            formats:^=join($json(^)/format^,'^, '^)^,
	            best:^=$json(^)[last(^)]/format
	          ^) else
	            let $a:^=replace(
	              //@datetime^,
	              '(\d+^)-(\d+^)-(\d+^).+'^,
	              ' ($3$2$1^)'
	            ^)
	            let $b:^=//div[@data-button^='player-still-overlay icon-play'] return
	            if (count($b^)^=1^) then (
	              name:^=if (//meta[@property^='og:type']/@content^='video:episode'^) then
	                concat(
	                  'RTV Noord - '^,
	                  //div[@class^='media-details']/h3^,
	                  replace(
	                    //@data-media^,
	                    '.+?/(\d+^).{3}(\d{2}^)(\d{2}^).+'^,
	                    ' ($3$2$1^)'
	                  ^)
	                ^)
	              else
	                concat(
	                  'RTV Noord - '^,
	                  replace(
	                    $b/@title^,
	                    '[^&quot^;^&apos^;]'^,
	                    ''''''
	                  ^)^,
	                  $a
	                ^)^,
	                v_url:^=$b/@data-media
	            ^) else (
	              json:^=[
	                $b ! {
	                  position(^)^|^|'e':{
	                    'name':concat(
	                      'RTV Noord - '^,
	                      replace(
	                        @title^,
	                        '[^&quot^;^&apos^;]'^,
	                        ''''''
	                      ^)^,
	                      $a
	                    ^)^,
	                    'url':@data-media
	                  }
	                }
	              ]^,
	              videos:^=join($json(^)(^)^,'^, '^)
	            ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.rtvdrenthe.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	--xquery ^"let $a:^=//meta[@property^='og:type']/@content
	          let $b:^=replace(
	            //@datetime^,
	            '(\d+^)-(\d+^)-(\d+^).+'^,
	            ' ($3$2$1^)'
	          ^)
	          let $c:^=//div[@data-button^='player-still-overlay icon-play'] return
	          if (count($c^)^=1^) then
	            if ($a^) then (
	              name:^=if ($a^='video:episode'^) then
	                concat(
	                  'RTV Drenthe - '^,
	                  //div[@class^='media-details']/h3^,
	                  replace(
	                    //@data-media^,
	                    '.+?(\d{4}^)(\d{2}^)(\d{2}^).+'^,
	                    ' ($3$2$1^)'
	                  ^)
	                ^)
	              else
	                concat(
	                  'RTV Drenthe - '^,
	                  replace(
	                    $c/@title^,
	                    '[^&quot^;^&apos^;]'^,
	                    ''''''
	                  ^)^,
	                  $b
	                ^)^,
	                v_url:^=$c/@data-media
	            ^) else (
	              name:^=replace(
	                '%date%'^,
	                '.+?(\d+^)-(\d+^)-(\d+^)'^,
	                'RTV Drenthe - Livestream ($1$2$3^)'
	              ^)^,
	              v_url:^=concat(
	                resolve-uri(
	                  '.'^,
	                  //@data-media
	                ^)^,
	                extract(
	                  unparsed-text(//@data-media^)^,
	                  '(.+m3u8^)'^,1
	                ^)
	              ^)
	            ^)
	          else (
	            json:^=[
	              $c ! {
	                position(^)^|^|'e':{
	                  'name':concat(
	                    'RTV Drenthe - '^,
	                    replace(
	                      @title^,
	                      '[^&quot^;^&apos^;]'^,
	                      ''''''
	                    ^)^,
	                    $b
	                  ^)^,
	                  'url':@data-media
	                }
	              }
	            ]^,
	            videos:^=join($json(^)(^)^,'^, '^)
	          ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.rtvnh.nl/live/tv=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	--xquery ^"name:^=replace(
	            '%date%'^,
	            '.+?(\d+^)-(\d+^)-(\d+^)'^,
	            'RTV NH - Livestream ($1$2$3^)'
	          ^)^,
	          let $a:^=json(
	            replace(
	              replace(
	                //script/extract(
	                  .^,
	                  'sources: (.+^)^,\s+\]'^,1^,'s'
	                ^)[.]^,
	                '^,\s+\}'^,
	                '}'
	              ^)^,
	              'rtmp'^,
	              'rtsp'
	            ^)^|^|']'
	          ^)(^) return
	          json:^=[
	            $a[type!^='hls']/{
	              'format':replace(
	                file^,
	                '(.+?^):.+(.^)'^,
	                '$1-$2'
	              ^)^,
	              'url':file
	            }^,
	            {
	              'format':'meta'^,
	              'url':$a[type^='hls']/file
	            }^,
	            tail(
	              tokenize(
	                unparsed-text($a[type^='hls']/file^)^,
	                '#EXT-X-STREAM-INF:'
	              ^)
	            ^) ! {
	              'format':string(
	                extract(
	                  .^,
	                  'BANDWIDTH^=(\d+^)'^,1
	                ^) idiv 1000
	              ^)^,
	              'url':concat(
	                resolve-uri(
	                  '.'^,
	                  $a[type^='hls']/file
	                ^)^,
	                extract(
	                  .^,
	                  '(.+m3u8^)'^,1
	                ^)
	              ^)
	            }
	          ]^,
	          let $b:^=(
	            $json(^)[contains(format^,'rtsp'^)]/format^,
	            $json(^)[format^='meta']/format^,
	            for $x in $json(^)[format castable as int]/format order by $x return $x
	          ^) return (
	            formats:^=join($b^,'^, '^)^,
	            best:^=$b[last(^)]
	          ^)^" --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.rtvnh.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	--xquery ^"let $a:^=replace(
	            //meta[@property^='article:published_time']/@content^,
	            '(\d+^)-(\d+^)-(\d+^).+'^,
	            ' ($3$2$1^)'
	          ^)
	          let $b:^=[
	            if (//div/@data-video^) then
	              //div/@data-video ! {
	                'name':concat(
	                  'RTV NH - '^,
	                  //meta[@property^='og:title']/@content^,
	                  $a
	                ^)^,
	                'id':.
	              }
	            else
	              (^)^,
	            if (//@class^='video-container'^) then
	              //div[@class^='video-container']/{
	                'name':if (contains($url^,'gemist'^)^) then
	                  concat(
	                    'RTV NH - '^,
	                    //div[@class^='banner_label']^,
	                    replace(
	                      //a[@class^='video-player']/@href^,
	                      '.+?(\d+^)/(\d+^)/(\d+^).+'^,
	                      ' ($3$2$1^)'
	                    ^)
	                  ^)
	                else
	                  concat(
	                    'RTV NH - '^,
	                    //script/extract(
	                      .^,
	                      'title.+: (.+^)'''^,1
	                    ^)[.]^,
	                    $a
	                  ^)^,
	                'id':substring-after(@id^,'video'^)
	              }
	            else
	              (^)^,
	            if (//iframe^) then
	              //iframe/{
	                'name':concat(
	                  'RTV NH - '^,
	                  //meta[@property^='og:title']/@content^,
	                  $a
	                ^)^,
	                'id':substring-after(@src^,'^='^)
	              }
	            else
	              (^)
	          ] return
	          if (count($b(^)^)^=1^) then
	            $b(^)/(
	              name:^=name^,
	              json:^=doc(
	                concat(
	                  'http://www.rtvnh.nl/media/smil/video/'^,
	                  id
	                ^)
	              ^)/[
	                //@src ! {
	                  'format':concat(
	                    'rtsp-'^,
	                    extract(
	                      .^,
	                      '_(\d+^)'^,1
	                    ^)
	                  ^)^,
	                  'url':concat(
	                    replace(
	                      //@base^,
	                      'rtmp'^,
	                      'rtsp'
	                    ^)^,
	                    substring-after(.^,'mp4:'^)
	                  ^)
	                }^,
	                //@src ! {
	                  'format':extract(
	                    .^,
	                    '_(\d+^)'^,1
	                  ^)^,
	                  'url':let $c:^=concat(
	                    replace(
	                      replace(
	                        //@base^,
	                        'rtmp'^,
	                        'http'
	                      ^)^,
	                      ':\d+'^,
	                      ''
	                    ^)^,
	                    substring-after(.^,'mp4:'^)^,
	                    '/playlist.m3u8'
	                  ^) return
	                  concat(
	                    resolve-uri('.'^,$c^)^,
	                    extract(
	                      unparsed-text($c^)^,
	                      '(.+m3u8^)'^,1
	                    ^)
	                  ^)
	                }
	              ]^,
	              formats:^=join($json(^)/format^,'^, '^)^,
	              best:^=$json(^)[last(^)]/format
	            ^)
	          else (
	            json:^=[
	              $b(^)/{
	                position(^)^|^|'e':{
	                  'name':name^,
	                  'formats':doc(
	                    concat(
	                      'http://www.rtvnh.nl/media/smil/video/'^,
	                      id
	                    ^)
	                  ^)/[
	                    //@src ! {
	                      'format':concat(
	                        'rtsp-'^,
	                        extract(
	                          .^,
	                          '_(\d+^)'^,1
	                        ^)
	                      ^)^,
	                      'url':concat(
	                        replace(
	                          //@base^,
	                          'rtmp'^,
	                          'rtsp'
	                        ^)^,
	                        substring-after(.^,'mp4:'^)
	                      ^)
	                    }^,
	                    //@src ! {
	                      'format':extract(
	                        .^,
	                        '_(\d+^)'^,1
	                      ^)^,
	                      'url':let $c:^=concat(
	                        replace(
	                          replace(
	                            //@base^,
	                            'rtmp'^,
	                            'http'
	                          ^)^,
	                          ':\d+'^,
	                          ''
	                        ^)^,
	                        substring-after(.^,'mp4:'^)^,
	                        '/playlist.m3u8'
	                      ^) return
	                      concat(
	                        resolve-uri('.'^,$c^)^,
	                        extract(
	                          unparsed-text($c^)^,
	                          '(.+m3u8^)'^,1
	                        ^)
	                      ^)
	                    }
	                  ]
	                }
	              }
	            ]^,
	            videos:^=join($json(^)(^)^,'^, '^)
	          ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF "%url%"=="http://www.omroepflevoland.nl/kijken" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	--xquery ^"name:^=replace(
	            '%date%'^,
	            '.+?(\d+^)-(\d+^)-(\d+^)'^,
	            'Omroep Flevoland - Livestream ($1$2$3^)'
	          ^)^,
	          json:^=[
	            for $x in reverse(
	              json(
	                //script/extract(
	                  .^,
	                  concat(
	                    (//div[@class^='jwplayercontainer']^)[1]//@id^,
	                    '.+sources:(.+?\]^)'
	                  ^)^,
	                  1^,'s'
	                ^)[.]
	              ^)(^)
	            ^) return (
	              if (ends-with($x/file^,'m3u8'^)^) then
	                tail(
	                  tokenize(
	                    unparsed-text($x/file^)^,
	                    '#EXT-X-STREAM-INF:'
	                  ^)
	                ^) ! {
	                  'format':string(
	                    extract(
	                      .^,
	                      'BANDWIDTH^=(\d+^)'^,1
	                    ^) idiv 1000
	                  ^)^,
	                  'url':concat(
	                    resolve-uri(
	                      '.'^,
	                      $x/file
	                    ^)^,
	                    extract(.^,'(.+m3u8^)'^,1^)
	                  ^)
	                }
	              else
	                {
	                  'format':replace(
	                    replace(
	                      $x/file^,
	                      '(.+?^):.+\.(.+^)'^,
	                      '$1-$2'
	                    ^)^,
	                    'rtmp'^,
	                    'rtsp'
	                  ^)^,
	                  'url':replace(
	                    $x/file^,
	                    'rtmp'^,
	                    'rtsp'
	                  ^)
	                }
	            ^)
	          ]^,
	          formats:^=join($json(^)/format^,'^, '^)^,
	          best:^=$json(^)[last(^)]/format^" --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.omroepflevoland.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	--xquery ^"let $a:^=//div[@class^='jwplayercontainer'] return
	          if (count($a^)^=2^) then (
	            name:^=concat(
	              'Omroep Flevoland - '^,
	              if (contains($url^,'kijken'^)^) then
	                //meta[@name^='keywords']/@content
	              else
	                extract(
	                  $a[1]/@data-video-name^,
	                  '.+?- (.+^) -'^,1
	                ^)^,
	              replace(
	                //meta[@property^='article:published_time']/@content^,
	                '(\d+^)-(\d+^)-(\d+^).+'^,
	                ' ($3$2$1^)'
	              ^)
	            ^)^,
	            json:^=[
	              for $x in json(
	                //script/extract(
	                  .^,
	                  concat(
	                    $a[1]/div/@id^,
	                    '.+sources:(.+?\]^)'
	                  ^)^,
	                  1^,'s'
	                ^)[.]
	              ^)(^)[starts-with(file^,'http'^)] return (
	                if (ends-with($x/file^,'m3u8'^)^) then (
	                  {
	                    'format':'meta'^,
	                    'url':$x/file
	                  }^,
	                  tail(
	                    tokenize(
	                      unparsed-text($x/file^)^,
	                      '#EXT-X-STREAM-INF:'
	                    ^)
	                  ^) ! {
	                    'format':string(
	                      extract(
	                        .^,
	                        'BANDWIDTH^=(\d+^)'^,1
	                      ^) idiv 1000
	                    ^)^,
	                    'url':concat(
	                      resolve-uri(
	                        '.'^,
	                        $x/file
	                      ^)^,
	                      extract(
	                        .^,
	                        '(.+m3u8^)'^,1
	                      ^)
	                    ^)
	                  }
	                ^) else
	                  ('laag'^,'middel'^,'hoog'^) ! {
	                    'format':concat('mp4-'^,.^)^,
	                    'url':replace(
	                      $x/file^,
	                      'middel'^,
	                      .
	                    ^)
	                  }
	              ^)
	            ]^,
	            let $b:^=(
	              $json(^)[contains(format^,'mp4'^)]/format^,
	              $json(^)[format^='meta']/format^,
	              for $x in $json(^)[format castable as int]/format order by $x return $x
	            ^) return (
	              formats:^=join($b^,'^, '^)^,
	              best:^=$b[last(^)]
	            ^)
	          ^) else (
	            json:^=[
	              for $x at $i in remove(
	                $a^,
	                count($a^)
	              ^) return {
	                $i^|^|'e':{
	                  'name':concat(
	                    'Omroep Flevoland - '^,
	                    extract(
	                      $x/@data-video-name^,
	                      '.+?- (.+^) -'^,1
	                    ^)^,
	                    replace(
	                      //meta[@property^='article:published_time']/@content^,
	                      '(\d+^)-(\d+^)-(\d+^).+'^,
	                      ' ($3$2$1^)'
	                    ^)
	                  ^)^,
	                  'formats':for $y in json(
	                    //script/extract(
	                      .^,
	                      concat(
	                        $x/div/@id^,
	                        '.+sources:(.+?\]^)'
	                      ^)^,
	                      1^,'s'
	                    ^)[.]
	                  ^)(^)[starts-with(file^,'http'^)] return (
	                    if (ends-with($y/file^,'m3u8'^)^) then (
	                      {
	                        'format':'meta'^,
	                        'url':$y/file
	                      }^,
	                      tail(
	                        tokenize(
	                          unparsed-text($y/file^)^,
	                          '#EXT-X-STREAM-INF:'
	                        ^)
	                      ^) ! {
	                        'format':string(
	                          extract(
	                            .^,
	                            'BANDWIDTH^=(\d+^)'^,1
	                          ^) idiv 1000
	                        ^)^,
	                        'url':concat(
	                          resolve-uri(
	                            '.'^,
	                            $y/file
	                          ^)^,
	                          extract(
	                            .^,
	                            '(.+m3u8^)'^,1
	                          ^)
	                        ^)
	                      }
	                    ^) else
	                      ('laag'^,'middel'^,'hoog'^) ! {
	                        'format':concat('mp4-'^,.^)^,
	                        'url':replace(
	                          $y/file^,
	                          'middel'^,
	                          .
	                        ^)
	                      }
	                  ^)
	                }
	              }
	            ]^,
	            videos:^=join($json(^)(^)^,'^, '^)
	          ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.rtvoost.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	--xquery ^"let $a:^=//meta[@property^='og:type']/@content
	          let $b:^=replace(
	            //meta[
	              if (@property^='video:release_date'^) then
	                @property^='video:release_date'
	              else
	                @property^='article:published_time'
	            ]/@content^,
	            '(\d+^)-(\d+^)-(\d+^).+'^,
	            ' ($3$2$1^)'
	          ^)
	          let $c:^=//script/extract(
	            .^,
	            '\$\.ajax\(\^"(.+^^^)\^"'^,1
	          ^)[.] return
	          if (count($c^)^=1^) then (
	            if ($a^='video.other'^) then (
	              name:^=replace(
	                '%date%'^,
	                '.+?(\d+^)-(\d+^)-(\d+^)'^,
	                'RTV Oost - Livestream ($1$2$3^)'
	              ^)^,
	              let $d:^=json($c^)//file return
	              json:^=[
	                {
	                  'format':'meta'^,
	                  'url':$d
	                }^,
	                tail(
	                  tokenize(
	                    unparsed-text($d^)^,
	                    '#EXT-X-STREAM-INF:'
	                  ^)
	                ^) ! {
	                  'format':string(
	                    extract(
	                      .^,'BANDWIDTH^=(\d+^)'^,1
	                    ^) idiv 1000
	                  ^)^,
	                  'url':concat(
	                    resolve-uri('.'^,$d^)^,
	                    extract(
	                      .^,
	                      '(.+m3u8^)'^,1
	                    ^)
	                  ^)
	                }
	              ]
	            ^) else (
	              name:^=concat(
	                'RTV Oost - '^,
	                if ($a^='video.episode'^) then
	                  extract(
	                    //meta[@property^='og:title']/@content^,
	                    '(.+^) van \d+'^,1
	                  ^)
	                else
	                  //meta[@property^='og:title']/@content^,
	                $b
	              ^)^,
	              json:^=[
	                (json($c^)//sources^)(^)/{
	                  'format':replace(
	                    label^,
	                    '(\d+^).'^,
	                    'mp4-$1'
	                  ^)^,
	                  'url':file
	                }
	              ]
	            ^)^,
	            let $e:^=(
	              $json(^)[format^='meta']/format^,
	              for $x in $json(^)[format!^='meta']/format order by $x return $x
	            ^) return (
	              formats:^=join($e^,'^, '^)^,
	              best:^=$e[last(^)]
	            ^)
	          ^) else (
	            json:^=[
	              for $x at $i in $c return {
	                $i^|^|'e':{
	                  'name':concat(
	                    'RTV Oost - '^,
	                    //div[@id^=concat('video'^,$i^)]/span[@class^='mediaTitle']^,
	                    $b
	                  ^)^,
	                  'formats':[
	                    (json($x^)//sources^)(^)/{
	                      'format':replace(
	                        label^,
	                        '(\d+^).'^,
	                        'mp4-$1'
	                      ^)^,
	                      'url':file
	                    }
	                  ]
	                }
	              }
	            ]^,
	            videos:^=join($json(^)(^)^,'^, '^)
	          ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.at5.nl/live=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "http://www.at5.nl/video/json?s=live"
	--xquery ^"name:^=replace(
	            '%date%'^,
	            '.+?(\d+^)-(\d+^)-(\d+^)'^,
	            'AT5 - Livestream ($1$2$3^)'
	          ^)^,
	          let $a:^=json($raw^)/source/(def^)(^) return
	          json:^=[
	            ('a'^,'b'^,'c'^,'d'^) ! {
	              'format':concat('rtsp-'^,.^)^,
	              'url':concat(
	                replace(
	                  $a[type^='rtmp']/file^,
	                  '.+?(:.+^).'^,
	                  'rtsp$1'
	                ^)^,
	                .
	              ^)
	            }^,
	            {
	              'format':'meta'^,
	              'url':$a[type^='hls']/file
	            }^,
	            tail(
	              tokenize(
	                unparsed-text($a[type^='hls']/file^)^,
	                '#EXT-X-STREAM-INF:'
	              ^)
	            ^) ! {
	              'format':string(
	                extract(
	                  .^,
	                  'BANDWIDTH^=(\d+^)'^,1
	                ^) idiv 1000
	              ^)^,
	              'url':concat(
	                resolve-uri(
	                  '.'^,
	                  $a[type^='hls']/file
	                ^)^,
	                extract(
	                  .^,
	                  '(.+m3u8^)'^,1
	                ^)
	              ^)
	            }
	          ]^,
	          let $b:^=(
	            $json(^)[contains(format^,'rtsp'^)]/format^,
	            $json(^)[format^='meta']/format^,
	            for $x in $json(^)[format castable as int]/format order by $x return $x
	          ^) return (
	            formats:^=join($b^,'^, '^)^,
	            best:^=$b[last(^)]
	          ^)^" --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.at5.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	--xquery ^"name:^=concat(
	            'AT5 - '^,
	            replace(
	              if (contains($url^,'gemist'^)^) then
	                concat(
	                  if (contains(//div[@class^='banner_label']^,'Nieuws'^)^) then
	                    'Nieuws'
	                  else
	                    concat(
	                      //div[@class^='banner_label']^,
	                      '- '^,
	                      //div[@class^='banner_title']
	                    ^)^,
	                  replace(
	                    //a[@class^='video-player']/@href^,
	                    '.+(\d{4}^)/(\d{2}^)/(\d{2}^).+'^,
	                    ' ($3$2$1^)'
	                  ^)
	                ^)
	              else
	                concat(
	                  //meta[@property^='og:title']/@content^,
	                  replace(
	                    //meta[@property^='article:published_time']/@content^,
	                    '(\d+^)-(\d+^)-(\d+^).+'^,
	                    ' ($3$2$1^)'
	                  ^)
	                ^)^,
	              '[^&quot^;^&apos^;]'^,
	              ''''''
	            ^)
	          ^)^,
	          if (//iframe^) then
	            (^)
	          else (
	            let $a:^=json(
	              concat(
	                'http://www.at5.nl/video/json?m^='^,
	                (
	                  //div[@class^='video-container']/substring-after(@id^,'video'^)^,
	                  //div/@data-video
	                ^)
	              ^)
	            ^)/source return
	            json:^=[
	              ('low'^,'medium'^,'hi'^) ! {
	                'format':concat('mp4-'^,.^)^,
	                'url':replace(
	                  $a/(fb^)(1^)/file^,
	                  '(hi^)'^,
	                  .
	                ^)
	              }^,
	              for $x in ('low'^,'medium'^,'hi'^) ! replace(
	                $a/(def^)(^)[type^='hls']/file^,
	                '(hi^)'^,
	                .
	              ^) return
	              tail(
	                tokenize(
	                  unparsed-text($x^)^,
	                  '#EXT-X-STREAM-INF:'
	                ^)
	              ^) ! {
	                'format':string(
	                  extract(
	                    .^,
	                    'BANDWIDTH^=(\d+^)'^,1
	                  ^) idiv 1000
	                ^)^,
	                'url':concat(
	                  resolve-uri('.'^,$x^)^,
	                  extract(
	                    .^,
	                    '(.+m3u8^)'^,1
	                  ^)
	                ^)
	              }
	            ]^,
	            formats:^=join($json(^)/format^,'^, '^)^,
	            best:^=$json(^)[last(^)]/format
	          ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.rtvutrecht.nl/live=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	-e ^"prid:^=//script/extract(
	      .^,
	      '\^"prid\^": \^"(.+^^^)\^"'^,1
	    ^)[.]^" --output-format^=cmd^"') DO %%A
	GOTO NPO
) ELSE IF NOT "%url:www.rtvutrecht.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	--xquery ^"let $a:^=//script/extract(
	            .^,
	            '(http.+mp4^)'^,1
	          ^)[.] return
	          if (count($a^)^=1^) then (
	            name:^=concat(
	              'RTV Utrecht - '^,
	              if (contains($url^,'gemist'^)^) then
	                substring-before(
	                  //h2[@class^='h2-large-met-grijs border-top'][1]^,
	                  ' -'
	                ^)
	              else
	                replace(
	                  if (//p[@class^='margin-bottom-5 fragment-bijschrift']^) then
	                    //p[@class^='margin-bottom-5 fragment-bijschrift']
	                  else
	                    //meta[@name^='og:title']/@content^,
	                  '[^&quot^;^&apos^;]'^,
	                  ''''''
	                ^)^,
	                replace(
	                  $a^,
	                  '.+(\d{4}^)/(\d{2}^)/(\d{2}^).+'^,
	                  ' ($3$2$1^)'
	                ^)
	            ^)^,
	            v_url:^=$a
	          ^) else (
	            json:^=[
	              for $x at $i in $a return {
	                $i^|^|'e':{
	                  'name':concat(
	                    'RTV Utrecht - '^,
	                    replace(
	                      //p[@class^='margin-bottom-5 fragment-bijschrift'][$i]^,
	                      '[^&quot^;^&apos^;]'^,
	                      ''''''
	                    ^)^,
	                    replace(
	                      $x^,
	                      '.+(\d{4}^)/(\d{2}^)/(\d{2}^).+'^,
	                      ' ($3$2$1^)'
	                    ^)
	                  ^)^,
	                  'url':$x
	                }
	              }
	            ]^,
	            videos:^=join($json(^)(^)^,'^, '^)
	          ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.omroepgelderland.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	--xquery ^"let $a:^=//meta[@property^='og:type']/@content
	          let $b:^=replace(
	            //@datetime^,
	            '(\d+^)-(\d+^)-(\d+^).+'^,
	            ' ($3$2$1^)'
	          ^)
	          let $c:^=//div[@data-button^='player-still-overlay icon-play'] return
	          if (count($c^)^=1^) then
	            if ($a^) then (
	              name:^=if ($a^='video:episode'^) then
	                concat(
	                  'Omroep Gelderland - '^,
	                  (//h3^)[1]^,
	                  replace(
	                    //@data-media^,
	                    '.+?(\d+^)/(\d+^)/\d{4}(\d+^).+'^,
	                    ' ($3$2$1^)'
	                  ^)
	                ^)
	              else
	                concat(
	                  'Omroep Gelderland - '^,
	                  replace(
	                    $c/@title^,
	                    '[^&quot^;^&apos^;]'^,
	                    ''''''
	                  ^)^,
	                  $b
	                ^)^,
	              v_url:^=$c/@data-media
	            ^) else (
	              name:^=replace(
	                '%date%'^,
	                '.+?(\d+^)-(\d+^)-(\d+^)'^,
	                'Omroep Gelderland - Livestream ($1$2$3^)'
	              ^)^,
	              v_url:^=extract(
	                unparsed-text(//@data-media^)^,
	                '(.+m3u8^)'^,1
	              ^)
	            ^)
	          else (
	            json:^=[
	              for $x at $i in $c return {
	                $i^|^|'e':{
	                  'name':concat(
	                    'Omroep Gelderland - '^,
	                    replace(
	                      $x/@title^,
	                      '[^&quot^;^&apos^;]'^,
	                      ''''''
	                    ^)^,
	                    $a
	                  ^)^,
	                  'url':$x/@data-media
	                }
	              }
	            ]^,
	            videos:^=join($json(^)(^)^,'^, '^)
	          ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.omroepwest.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	--xquery ^"let $a:^=//meta[@property^='og:type']/@content return
	          if (count(//@data-script^)^=1^) then
	            json(
	              extract(
	                unparsed-text(//@data-script^)^,
	                'var opts ^= (.+^)^;'^,1
	              ^)
	            ^)/(
	              if ($a^) then (
	                name:^=if ($a^='video:episode'^) then
	                  replace(
	                    clipData/title^,
	                    '(\d+^)-(\d+^)-(\d+^).+- (.+^)'^,
	                    'Omroep West - $4 ($3$2$1^)'
	                  ^)
	                else
	                  concat(
	                    'Omroep West - '^,
	                    replace(
	                      clipData/title^,
	                      '[^&quot^;^&apos^;]'^,
	                      ''''''
	                    ^)^,
	                    replace(
	                      clipData/publisheddate^,
	                      '(\d+^)-(\d+^)-(\d+^).+'^,
	                      ' ($3$2$1^)'
	                    ^)
	                  ^)^,
	                let $b:^=publicationData/defaultMediaAssetPath return
	                json:^=[
	                  clipData/(assets^)(^)/{
	                    'format':concat('mp4-'^,bandwidth^)^,
	                    'url':concat($b^,src^)
	                  }
	                ]
	              ^) else (
	                name:^=replace(
	                  '%date%'^,
	                  '.+?(\d+^)-(\d+^)-(\d+^)'^,
	                  'Omroep West - Livestream ($1$2$3^)'
	                ^)^,
	                let $b:^=clipData/(assets^)(1^)/concat('http:'^,src^) return
	                json:^=[
	                  {
	                    'format':'meta'^,
	                    'url':$b
	                  }^,
	                  tail(
	                    tokenize(
	                      unparsed-text($b^)^,
	                      '#EXT-X-STREAM-INF:'
	                    ^)
	                  ^) ! {
	                    'format':string(
	                      extract(
	                        .^,
	                        'BANDWIDTH^=(\d+^)'^,1
	                      ^) idiv 1000
	                    ^)^,
	                    'url':concat(
	                      resolve-uri('.'^,$b^)^,
	                      extract(
	                        .^,
	                        '(.+m3u8^)'^,1
	                      ^)
	                    ^)
	                  }
	                ]
	              ^)^,
	              let $c:^=(
	                $json(^)[format^='meta']/format^,
	                for $x in $json(^)[format!^='meta']/format order by $x return $x
	              ^) return (
	                formats:^=join($c^,'^, '^)^,
	                best:^=$c[last(^)]
	              ^)
	            ^)
	          else (
	            json:^=[
	              //@data-script ! {
	                position(^)^|^|'e':json(
	                  extract(
	                    unparsed-text(.^)^,
	                    'var opts ^= (.+^)^;'^,1
	                  ^)
	                ^)/{
	                  'name':concat(
	                    'Omroep West - '^,
	                    replace(
	                      clipData/title^,
	                      '[^&quot^;^&apos^;]'^,
	                      ''''''
	                    ^)^,
	                    replace(
	                      clipData/publisheddate^,
	                      '(\d+^)-(\d+^)-(\d+^).+'^,
	                      ' ($3$2$1^)'
	                    ^)
	                  ^)^,
	                  'formats':let $b:^=publicationData/defaultMediaAssetPath return [
	                    clipData/(assets^)(^)/{
	                      'format':concat('mp4-'^,bandwidth^)^,
	                      'url':concat($b^,src^)
	                    }
	                  ]
	                }
	              }
	            ]^,
	            videos:^=join($json(^)(^)^,'^, '^)
	          ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.rijnmond.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	--xquery ^"let $a:^=//meta[@property^='og:type']/@content return
	          if (count(//@data-script^)^=1^) then
	            json(
	              extract(
	                unparsed-text(//@data-script^)^,
	                'var opts ^= (.+^)^;'^,1
	              ^)
	            ^)/(
	              if ($a^) then (
	                name:^=concat(
	                  'RTV Rijnmond - '^,
	                  if ($a^='video:episode'^) then
	                    substring-before(
	                      clipData/title^,
	                      ' -'
	                    ^)
	                  else
	                    replace(
	                      clipData/title^,
	                      '[^&quot^;^&apos^;]'^,
	                      ''''''
	                    ^)^,
	                  replace(
	                    clipData/publisheddate^,
	                    '(\d+^)-(\d+^)-(\d+^).+'^,
	                    ' ($3$2$1^)'
	                  ^)
	                ^)^,
	                let $b:^=publicationData/defaultMediaAssetPath return
	                json:^=[
	                  clipData/(assets^)(^)/{
	                    'format':concat('mp4-'^,bandwidth^)^,
	                    'url':concat($b^,src^)
	                  }
	                ]^,
	                let $c:^=for $x in $json(^)/format order by $x return $x return (
	                  formats:^=join($c^,'^, '^)^,
	                  best:^=$c[last(^)]
	                ^)
	              ^) else (
	                name:^=replace(
	                  '%date%'^,
	                  '.+?(\d+^)-(\d+^)-(\d+^)'^,
	                  'RTV Rijnmond - Livestream ($1$2$3^)'
	                ^)^,
	                let $b:^=clipData/(assets^)(1^)/concat('http:'^,src^) return
	                v_url:^=concat(
	                  resolve-uri('.'^,$b^)^,
	                  extract(
	                    unparsed-text($b^)^,
	                    '(.+m3u8^)'^,1
	                  ^)
	                ^)
	              ^)
	            ^)
	          else (
	            json:^=[
	              //@data-script ! {
	                position(^)^|^|'e':json(
	                  extract(
	                    unparsed-text(.^)^,
	                    'var opts ^= (.+^)^;'^,1
	                  ^)
	                ^)/{
	                  'name':concat(
	                    'RTV Rijnmond - '^,
	                    replace(
	                      clipData/title^,
	                      '[^&quot^;^&apos^;]'^,
	                      ''''''
	                    ^)^,
	                    replace(
	                      clipData/publisheddate^,
	                      '(\d+^)-(\d+^)-(\d+^).+'^,
	                      ' ($3$2$1^)'
	                    ^)
	                  ^)^,
	                  'formats':let $b:^=publicationData/defaultMediaAssetPath return [
	                    clipData/(assets^)(^)/{
	                      'format':concat('mp4-'^,bandwidth^)^,
	                      'url':concat($b^,src^)
	                    }
	                  ]
	                }
	              }
	            ]^,
	            videos:^=join($json(^)(^)^,'^, '^)
	          ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.omroepzeeland.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	-e ^"name:^=if (contains($url^,'streams'^)^) then
	      replace(
	        '%date%'^,
	        '.+?(\d+^)-(\d+^)-(\d+^)'^,
	        'Omroep Zeeland - Livestream ($1$2$3^)'
	      ^)
	    else
	      concat(
	        'Omroep Zeeland - '^,
	        //meta[@property^='og:title']/@content^,
	        replace(
	          //div[@class^='field field-post-date']^,
	          '.+?(\d+^)-(\d+^)-(\d+^).+'^,
	          ' ($1$2$3^)'
	        ^)
	      ^)^"
	-f ^"if (//script[contains(@src^,'bbvms'^)]^) then
	      //script[contains(@src^,'bbvms'^)]/@src
	    else
	      concat(
	        'http://omroepzeeland.bbvms.com/p/OmroepZeelandDefault/c/'^,
	        //@data-bbwid^,
	        '.js'
	      ^)^"
	--xquery ^"json(
	            extract(
	              $raw^,
	              'var opts ^= (.+^)^;'^,1
	            ^)
	          ^)/(
	            let $a:^=publicationData/defaultMediaAssetPath return
	            json:^=[
	              if (contains($url^,'livetv'^)^) then (
	                clipData/(assets^)(^)[mediatype^='MP4_MAIN']/{
	                  'format':concat('rtmp-'^,bandwidth^)^,
	                  'url':src
	                }^,
	                for $x in clipData/(assets^)(^)[mediatype^='MP4_IPOD']/concat('http:'^,src^) return
	                tail(
	                  tokenize(
	                    unparsed-text($x^)^,
	                    '#EXT-X-STREAM-INF:'
	                  ^)
	                ^) ! {
	                  'format':string(
	                    extract(
	                      .^,
	                      'BANDWIDTH^=(\d+^)'^,1
	                    ^) idiv 1000
	                  ^)^,
	                  'url':concat(
	                    resolve-uri('.'^,$x^)^,
	                    extract(
	                      .^,
	                      '(.+m3u8^)'^,1
	                    ^)
	                  ^)
	                }
	              ^) else
	                clipData/(assets^)(^)/{
	                  'format':concat(
	                    replace(
	                      src^,
	                      '.+\.(.+^)'^,
	                      '$1-'
	                    ^)^,
	                    bandwidth
	                  ^)^,
	                  'url':concat($a^,src^)
	                }
	            ]^,
	            let $b:^=(
	              for $x in $json(^)[contains(format^,'rtmp'^)]/format order by $x return $x^,
	              for $x in $json(^)[not(contains(format^,'rtmp'^)^)]/format order by $x return $x
	            ^) return (
	              formats:^=join($b^,'^, '^)^,
	              best:^=$b[last(^)]
	            ^)
	          ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.omroepbrabant.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	--xquery ^"if (count((//@data-url^,//@data-script^)^)^=1^) then
	            json(
	              extract(
	                unparsed-text(
	                  (
	                    //@data-url^,
	                    //@data-script
	                  ^)
	                ^)^,
	                'var opts ^= (.+^)^;'^,1
	              ^)
	            ^)/clipData/(
	              if (contains($url^,'Portal'^)^) then (
	                name:^=replace(
	                  '%date%'^,
	                  '.+?(\d+^)-(\d+^)-(\d+^)'^,
	                  'Omroep Brabant - Livestream ($1$2$3^)'
	                ^)^,
	                let $a:^=substring-before(
	                  (assets^)(1^)/src^,
	                  '?'
	                ^) return
	                json:^=[
	                  {
	                    'format':'meta'^,
	                    'url':$a
	                  }^,
	                  tail(
	                    tokenize(
	                      unparsed-text($a^)^,
	                      '#EXT-X-STREAM-INF:'
	                    ^)
	                  ^) ! {
	                    'format':string(
	                      extract(
	                        .^,
	                        'BANDWIDTH^=(\d+^)'^,1
	                      ^) idiv 1000
	                    ^)^,
	                    'url':concat(
	                      resolve-uri('.'^,$a^)^,
	                      extract(
	                        .^,
	                        '.+/(.+m3u8^)'^,1
	                      ^)
	                    ^)
	                  }
	                ]
	              ^) else (
	                name:^=concat(
	                  'Omroep Brabant - '^,
	                  replace(
	                    title^,
	                    '[^&quot^;^&apos^;]'^,
	                    ''''''
	                  ^)^,
	                  replace(
	                    publisheddate^,
	                    '(\d+^)-(\d+^)-(\d+^).+'^,
	                    ' ($3$2$1^)'
	                  ^)
	                ^)^,
	                json:^=[
	                  (assets^)(^)/{
	                    'format':concat(
	                      'mp4-'^,
	                      bandwidth
	                    ^)^,
	                    'url':src
	                  }
	                ]
	              ^)^,
	              let $b:^=(
	                $json(^)[format^='meta']/format^,
	                for $x in $json(^)[format!^='meta']/format order by $x return $x
	              ^) return (
	                formats:^=join($b^,'^, '^)^,
	                best:^=$b[last(^)]
	              ^)
	            ^)
	          else (
	            if (//@data-script^) then (
	              json:^=[
	                //@data-script ! {
	                  position(^)^|^|'e':json(
	                    extract(
	                      unparsed-text(.^)^,
	                      'var opts ^= (.+^)^;'^,1
	                    ^)
	                  ^)/clipData/{
	                    'name':concat(
	                      'Omroep Brabant - '^,
	                      replace(
	                        title^,
	                        '[^&quot^;^&apos^;]'^,
	                        ''''''
	                      ^)^,
	                      replace(
	                        publisheddate^,
	                        '(\d+^)-(\d+^)-(\d+^).+'^,
	                        ' ($3$2$1^)'
	                      ^)
	                    ^)^,
	                    'formats':[
	                      (assets^)(^)/{
	                        'format':concat(
	                          'mp4-'^,
	                          bandwidth
	                        ^)^,
	                        'url':src
	                      }
	                    ]
	                  }
	                }
	              ]^,
	              videos:^=join($json(^)(^)^,'^, '^)
	            ^) else
	              (^)
	          ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:l1-live.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	-e ^"prid:^=//script/extract(
	      .^,
	      'prid: \^"(.+^^^)\^"'^,1
	    ^)[.]^" --output-format^=cmd^"') DO %%A
	GOTO NPO
) ELSE IF NOT "%url:l1.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	--xquery ^"let $a:^=//div/script[contains(@src^,'video'^)]/@src return
	          if (count($a^)^=1^) then
	            json(
	              extract(
	                unparsed-text($a^)^,
	                'var opts ^= (.+^)^;'^,1
	              ^)
	            ^)/(
	              if (clipData^) then
	                let $b:^=.//defaultMediaAssetPath return
	                clipData/(
	                  name:^=concat(
	                    'L1 - '^,
	                    replace(
	                      replace(
	                        title^,
	                        '(.+^) -.+'^,
	                        '$1'
	                      ^)^,
	                      '[^&quot^;^&apos^;]'^,
	                      ''''''
	                    ^)^,
	                    replace(
	                      publisheddate^,
	                      '(\d+^)-(\d+^)-(\d+^).+'^,
	                      ' ($3$2$1^)'
	                    ^)
	                  ^)^,
	                  json:^=[
	                    (assets^)(^)/{
	                      'format':concat(
	                        'mp4-'^,
	                        bandwidth
	                      ^)^,
	                      'url':concat(
	                        $b^,
	                        src
	                      ^)
	                    }
	                  ]^,
	                  let $c:^=for $x in $json(^)/format order by $x return $x return (
	                    formats:^=join($c^,'^, '^)^,
	                    best:^=$c[last(^)]
	                  ^)
	                ^)
	              else
	                (^)
	            ^)
	          else (
	            json:^=[
	              for $x at $i in $a return {
	                $i^|^|'e':json(
	                  extract(
	                    unparsed-text($x^)^,
	                    'var opts ^= (.+^)^;'^,1
	                  ^)
	                ^)/(
	                  let $b:^=.//defaultMediaAssetPath return
	                  clipData/{
	                    'name':concat(
	                      'L1 - '^,
	                      replace(
	                        replace(
	                          title^,
	                          '(.+^) -.+'^,
	                          '$1'
	                        ^)^,
	                        '[^&quot^;^&apos^;]'^,
	                        ''''''
	                      ^)^,
	                      replace(
	                        publisheddate^,
	                        '(\d+^)-(\d+^)-(\d+^).+'^,
	                        ' ($3$2$1^)'
	                      ^)
	                    ^)^,
	                    'formats':[
	                      (assets^)(^)/{
	                        'format':concat(
	                          'mp4-'^,
	                          bandwidth
	                        ^)^,
	                        'url':concat(
	                          $b^,
	                          src
	                        ^)
	                      }
	                    ]
	                  }
	                ^)
	              }
	            ]^,
	            videos:^=join($json(^)(^)^,'^, '^)
	          ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:www.telegraaf.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	-e ^"name:^=concat(
	      'Telegraaf - '^,
	      //h2^,
	      replace(
	        //script/extract(
	          .^,
	          'getPubDate.+?(\d+^)'^,1^,'s'
	        ^)[.]^,
	        '(\d{4}^)(\d{2}^)(\d{2}^)'^,
	        ' ($3$2$1^)'
	      ^)
	    ^)^"
	-f ^"//iframe/@src^"
	-f ^"//script/extract(
	      .^,
	      'playlist: \^"(.+^^^)\^"'^,1
	    ^)[.]^"
	--xquery ^"json:^=$json//locations/[
	            let $a:^=(adaptive^)(2^)/src return (
	              {
	                'format':'meta'^,
	                'url':$a
	              }^,
	              tail(
	                tokenize(
	                  unparsed-text($a^)^,
	                  '#EXT-X-STREAM-INF:'
	                ^)
	              ^) ! {
	                'format':string(
	                  extract(
	                    .^,
	                    'BANDWIDTH^=(\d+^)'^,1
	                  ^) idiv 1000
	                ^)^,
	                'url':concat(
	                  resolve-uri('.'^,$a^)^,
	                  extract(
	                    .^,
	                    '(.+m3u8^)'^,1
	                  ^)
	                ^)
	              }
	            ^)^,
	            (progressive^)(^)/{
	              'format':concat('mp4-'^,height^)^,
	              'url':.//src
	            }
	          ]^,
	          let $b:^=(
	            for $x in $json(^)[contains(format^,'mp4'^)]/format order by $x return $x^,
	            $json(^)[format^='meta']/format^,
	            for $x in $json(^)[format castable as int]/format order by $x return $x
	          ^) return (
	            formats:^=join($b^,'^, '^)^,
	            best:^=$b[last(^)]
	          ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:vtm.be=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	--xquery ^"let $a:^=concat(
	            //meta[@property^='og:site_name']/@content^,
	            if (//meta[@itemprop^='articleProgram']^) then
	              concat(
	                ' - '^,
	                //meta[@itemprop^='articleProgram']/@content
	              ^)
	            else
	              (^)
	          ^)
	          let $b:^=[
	            {
	              '1e':{
	                'name':replace(
	                  concat(
	                    $a^,
	                    ' - '^,
	                    //meta[@property^='og:title']/@content^,
	                    replace(
	                      (
	                        //@datetime[1]^,
	                        //meta[@property^='article:published_time']/@content
	                      ^)^,
	                      '(\d+^)-(\d+^)-(\d+^).+'^,
	                      ' ($3$2$1^)'
	                    ^)
	                  ^)^,
	                  '[^&quot^;^&apos^;]'^,
	                  ''''''
	                ^)^,
	                'url'://source/@src
	              }
	            }^,
	            //script/json(
	              extract(
	                .^,
	                'vmmaplayer^=(.+^)^;'^,1
	              ^)[.]
	            ^)/{
	              position(^)+1^|^|'e':{
	                'name':concat(
	                  $a^,
	                  ' - '^,
	                  title^,
	                  replace(
	                    videoUrl^,
	                    '.+?(\d+^)/(\d+^)/(\d+^).+'^,
	                    ' ($3$2$1^)'
	                  ^)
	                ^)^,
	                'url':videoUrl
	              }
	            }
	          ] return
	          if ($b(^)('2e'^)^) then (
	            json:^=$b^,
	            videos:^=join($json(^)(^)^,'^, '^)
	          ^) else
	            $b(^)('1e'^) ! (
	              name:^=name^,
	              v_url:^=url
	            ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:nickelodeon.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	-e ^"let $a:^=//meta[@itemprop^='name']/@content return
	    doc(
	      //@data-mrss
	    ^)/(
	      name:^=concat(
	        'Nickelodeon - '^,
	        $a^,
	        replace(
	          //pubDate^,
	          '(\d+^)-(\d+^)-(\d+^).+'^,
	          ' ($3$2$1^)'
	        ^)
	      ^)^,
	      json:^=[
	        doc(
	          //media:content/@url
	        ^)//rendition/{
	          'format':concat('mp4-'^,@bitrate^)^,
	          'url':src
	        }
	      ]
	    ^)^,
	    formats:^=join($json(^)/format^,'^, '^)^,
	    best:^=$json(^)[last(^)]/format^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:ketnet.be=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	--xquery ^"let $a:^=replace(
	            //script/extract(
	              .^,
	              '^= new Date\((.+?^)\^)^;'^,1
	            ^)[.] div 1000 * dayTimeDuration('PT1S'^) + date('1970-01-01'^)^,
	            '(\d+^)-(\d+^)-(\d+^)'^,
	            ' ($3$2$1^)'
	          ^) return
	          json(
	            //script/extract(
	              .^,
	              'playerConfig ^= (.+\}^)'^,1
	            ^)[.]
	          ^)/(
	            if (unparsed-text-available(.//hls^)^) then (
	              name:^=concat(
	                'Ketnet - '^,
	                title^,
	                $a
	              ^)^,
	              let $b:^=.//hls return
	              json:^=[
	                {
	                  'format':'meta'^,
	                  'url':$b
	                }^,
	                tail(
	                  tokenize(
	                    unparsed-text($b^)^,
	                    '#EXT-X-STREAM-INF:'
	                  ^)
	                ^) ! {
	                  'format':string(
	                    extract(
	                      .^,
	                      'BANDWIDTH^=(\d+^)'^,1
	                    ^) idiv 1000
	                  ^)^,
	                  'url':concat(
	                    resolve-uri('.'^,$b^)^,
	                    extract(
	                      .^,
	                      '(.+m3u8^)'^,1
	                    ^)
	                  ^)
	                }
	              ]^,
	              let $c:^=(
	                $json(^)[format^='meta']/format^,
	                for $x in $json(^)[format castable as int]/format order by $x return $x
	              ^) return (
	                formats:^=join($c^,'^, '^)^,
	                best:^=$c[last(^)]
	              ^)
	            ^) else
	              (^)
	          ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:disney.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	-f ^"json(
	      //script/extract(
	        .^,
	        'burger^=(.+^):\('^,1
	      ^)[.]
	    ^)/(.//embedURL^)[1]^"
	--xquery ^"let $ref:^=string-to-base64Binary(
	            concat(
	              'http://'^,
	              $host
	            ^)
	          ^) return
	          json(
	            //script/extract(
	              .^,
	              '(\{.+\}^)'^,1
	            ^)[.]
	          ^)/(
	            (.//externals^)(^)[1]/(
	              name:^=concat(
	                'Disney- '^,
	                .//name^,
	                replace(
	                  .//createdAt * dayTimeDuration('PT1S'^) + date('1970-01-01'^)^,
	                  '(\d+^)-(\d+^)-(\d+^)'^,
	                  ' ($3$2$1^)'
	                ^)
	              ^)^,
	              dataUrl:^=.//dataUrl
	            ^)^,
	            json:^=[
	              let $a:^=.//flavors/concat(
	                substring-before(
	                  $dataUrl^,
	                  'format'
	                ^)^,
	                'flavorIds/'^,
	                join(
	                  .(^)[height!^=0][format^='mp4']/extract(
	                    url^,
	                    'flavorId/(.+?^)/'^,1
	                  ^)^,
	                  '^,'
	                ^)^,
	                '/format/applehttp/protocol/http?referrer^='^,
	                $ref
	              ^) return (
	                {
	                  'format':'meta'^,
	                  'url':x:request(
	                    {
	                      'data':$a^,
	                      'method':'HEAD'^,
	                      'error-handling':'4xx^=accept'
	                    }
	                  ^)/(
	                    if (contains($headers[1]^,'404'^)^) then
	                      (^)
	                    else
	                      url
	                  ^)
	                }^,
	                tail(
	                  tokenize(
	                    unparsed-text($a^)^,
	                    '#EXT-X-STREAM-INF:'
	                  ^)
	                ^) ! {
	                  'format':string(
	                    extract(
	                      .^,
	                      'BANDWIDTH^=(\d+^)'^,1
	                    ^) idiv 1000
	                  ^)^,
	                  'url':extract(
	                    .^,
	                    '(.+m3u8.+^)'^,1
	                  ^)
	                }^,
	                (.//flavors^)(^)[height!^=0]/{
	                  'format':concat(
	                    replace(
	                      format^,
	                      '.+-(.+^)'^,
	                      '$1'
	                    ^)^,
	                    '-'^,
	                    bitrate
	                  ^)^,
	                  'url':url
	                }
	              ^)
	            ]
	          ^)^,
	          let $b:^=(
	            for $x in $json(^)[contains(format^,'-'^)]/format order by $x return $x^,
	            $json(^)[format^='meta']/format^,
	            for $x in $json(^)[format castable as int]/format order by $x return $x
	          ^) return (
	            formats:^=join($b^,'^, '^)^,
	            best:^=$b[last(^)]
	          ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:cartoonnetwork.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	-f ^"concat(
	      'http://cdnapi.kaltura.com/api_v3/index.php?service^=multirequest^&format^=1^&1:service^=session^&1:action^=startWidgetSession^&1:widgetId^=_'^,
	      //@data-partner-id^,
	      '^&2:ks^={1:result:ks}^&2:service^=baseentry^&2:action^=get^&2:entryId^='^,
	      //@data-video-id^,
	      '^&3:ks^={1:result:ks}^&3:service^=flavorAsset^&3:action^=getByEntryId^&3:entryId^='^,
	      //@data-video-id
	    ^)^"
	--xquery ^"name:^=$json(2^)/concat(
	            'Cartoon Network - '^,
	            name^,
	            replace(
	              createdAt * dayTimeDuration('PT1S'^) + date('1970-01-01'^)^,
	              '(\d+^)-(\d+^)-(\d+^)'^,
	              ' ($3$2$1^)'
	            ^)
	          ^)^,
	          json:^=[
	            $json(3^)(^)/{
	              'format':if (isOriginal^='true'^) then
	                'mp4-source'
	              else 
	                concat(
	                  fileExt^,
	                  '-'^,
	                  bitrate
	                ^)^,
	              'url':x:request(
	                {
	                  'data':concat(
	                    substring-before(
	                      $json(2^)/downloadUrl^,
	                      'raw'
	                    ^)^,
	                    'playManifest/entryId/'^,
	                    $json(2^)/id^,
	                    '/flavorId/'^,
	                    id^,
	                    '/format/url/protocol/http/a.'^,
	                    fileExt
	                  ^)^,
	                  'method':'HEAD'^,
	                  'error-handling':'4xx^=accept'
	                }
	              ^)/(
	                if (contains(headers[1]^,'404'^)^) then
	                  (^)
	                else
	                  url
	              ^)
	            }[url]
	          ]^,
	          let $a:^=for $x in $json(^)/format order by $x return $x return (
	            formats:^=join($a^,'^, '^)^,
	            best:^=$a[last(^)]
	          ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:24kitchen.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	-e ^"name:^=concat(
	      '24Kitchen - '^,
	      //h1[@class^='fn title']
	    ^)^"
	-f ^"extract(
	      $raw^,
	      'tp:releaseUrl^=\^"(.+^^^)\^"'^,1
	    ^)^"
	--xquery ^"json:^=[
	            //video/{
	              'format':concat(
	                'mp4-'^,
	                @system-bitrate idiv 1000
	              ^)^,
	              'url':@src
	            }
	          ]^,
	          let $a:^=for $x in $json(^)/format order by $x return $x return (
	            formats:^=join($a^,'^, '^)^,
	            best:^=$a[last(^)]
	          ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:dumpert.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% -H "Cookie: nsfw=1;cpc=10" --user-agent "BatchGemist %ver%" "%url%"
	--xquery ^"let $a:^=json(
	            if (//@data-files^) then
	              binary-to-string(
	                base64Binary(//div/@data-files^)
	              ^)
	            else
	              //script/extract(
	                .^,
	                '(\{.+\}^)^,'^,1
	              ^)[.]
	          ^) return
	          if ($a/embed^) then
	            v_url:^=replace(
	              $a/embed^,
	              'youtube:'^,
	              'https://youtu.be/'
	            ^)
	          else (
	            name:^=concat(
	              'Dumpert - '^,
	              //meta[@name^='title']/@content
	            ^)^,
	            json:^=[
	              $a(^)[.!^='still'] ! {
	                'format':.^,
	                'url':$a(.^)
	              }
	            ]^,
	            let $b:^=(
	              for $x in $json(^)[format!^='720p']/format order by $x return $x^,
	              $json(^)[format^='720p']/format
	            ^) return (
	              formats:^=join($b^,'^, '^)^,
	              best:^=$b[last(^)]
	            ^)
	          ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:comedycentral.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	-e ^"let $a:^=if (count(//@data-mrss^)^=1^) then
	      concat(
	        //h1^,
	        ' - '^,
	        (//h2^)[1]
	      ^)
	    else
	      //li[
	        contains(
	          a/@href^,
	          extract(
	            $url^,
	            '.+^=(.+^)^|.+/(\d+^)'^,(1^,2^)
	          ^)[.]
	        ^)
	      ] ! (
	        if (@data-franchise^) then
	          concat(
	            @data-franchise^,
	            ' - '^,
	            a/@title
	          ^)
	        else
	          replace(
	            @data-title^,
	            ':'^,
	            ''
	          ^)
	      ^)
	    return
	    doc(
	      if (count(//@data-mrss^)^=1^) then
	        //@data-mrss
	      else
	        //li[
	          contains(
	            a/@href^,
	            extract(
	              $url^,
	              '.+^=(.+^)^|.+/(\d+^)'^,(1^,2^)
	            ^)[.]
	          ^)
	        ]/@data-mrss
	    ^)/(
	      name:^=concat(
	        'Comedy Central - '^,
	        $a^,
	        replace(
	          //pubDate^,
	          '(\d+^)-(\d+^)-(\d+^).+'^,
	          ' ($3$2$1^)'
	        ^)
	      ^)^,
	      doc(
	        //media:content/@url
	      ^)/(
	        if (//rendition^) then (
	          json:^=[
	            //rendition/{
	              'format':concat('mp4-'^,@bitrate^)^,
	              'url':src
	            }
	          ]^,
	          formats:^=join($json(^)/format^,'^, '^)^,
	          best:^=$json(^)[last(^)]/format
	        ^) else
	          (^)
	      ^)
	    ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:nl.funnyclips.cc=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	-e ^"let $a:^=//meta[@property^='og:title']/@content return
	    doc(
	      //script/extract(
	        .^,
	        '\{\}^, ''(.+^)'''^,1
	      ^)[.]
	    ^)/(
	      name:^=concat(
	        'Funny Clips - '^,
	        $a^,
	        replace(
	          //pubDate^,
	          '(\d+^)-(\d+^)-(\d+^).+'^,
	          ' ($3$2$1^)'
	        ^)
	      ^)^,
	      doc(
	        //media:content/@url
	      ^)/(
	        if (//rendition^) then (
	          json:^=[
	            //rendition/{
	              'format':concat('mp4-'^,@bitrate^)^,
	              'url':src
	            }
	          ]^,
	          formats:^=join($json(^)/format^,'^, '^)^,
	          best:^=$json(^)[last(^)]/format
	        ^) else
	          (^)
	      ^)
	    ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:mtv.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	-e ^"json(
	      //script/extract(
	        .^,
	        'pagePlaylist ^= (.+^)^;'^,1
	      ^)[.]
	    ^)(^)[
	      id^=extract(
	        $url^,
	        '.+/(\d+^)-'^,1
	      ^)
	    ]/(
	      let $a:^=if (subtitle!^=null^) then
	        concat(
	          title^,
	          ' - '^,
	          subtitle
	        ^)
	      else
	        title
	      return
	      doc(mrss^)/(
	        name:^=concat(
	          $a^,
	          replace(
	            //pubDate^,
	            '(\d+^)-(\d+^)-(\d+^).+'^,
	            ' ($3$2$1^)'
	          ^)
	        ^)^,
	        doc(
	          //media:content/@url
	        ^)/(
	          if (//rendition^) then (
	            json:^=[
	              //rendition/{
	                'format':concat('mp4-'^,@bitrate^)^,
	                'url':src
	              }
	            ]^,
	            formats:^=join($json(^)/format^,'^, '^)^,
	            best:^=$json(^)[last(^)]/format
	          ^) else
	            (^)
	        ^)
	      ^)
	    ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:foxtv.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	-e ^"date:^=replace(
	      extract(
	        $raw^,
	        'publishingDate^=(\d{8}^)'^,1
	      ^)^,
	      '(\d{4}^)(\d{2}^)(\d{2}^)'^,
	      ' ($3$2$1^)'
	    ^)^"
	-f ^"extract(
	      $raw^,
	      'tp:releaseUrl^=\^"(.+^^^)\^"'^,1
	    ^)^"
	--xquery ^"name:^=concat(
	            'FOX - '^,
	            replace(
	              //param[@name^='fullTitle']/@value^,
	              '[^&quot^;^&apos^;]'^,
	              ''''''
	            ^)^,
	            $date
	          ^)^,
	          s_url:^=//textstream[@lang^='nl'][@type^='text/srt']/@src^"
	-f ^"//video/@src^"
	--xquery ^"json:^=[
	            {
	              'format':'meta'^,
	              'url':$url
	            }^,
	            tail(
	              tokenize(
	                $raw^,
	                '#EXT-X-STREAM-INF:'
	              ^)
	            ^) ! {
	              'format':string(
	                extract(
	                  .^,
	                  'BANDWIDTH^=(\d+^)'^,1
	                ^) idiv 1000
	              ^)^,
	              'url':extract(
	                .^,
	                '(.+m3u8^)'^,1
	              ^)
	            }
	          ]^,
	          let $a:^=(
	            $json(^)[format^='meta']/format^,
	            for $x in $json(^)[format!^='meta']/format order by $x return $x
	          ^) return (
	            formats:^=join($a^,'^, '^)^,
	            best:^=$a[last(^)]
	          ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:foxsports.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	-f ^"concat(
	      'http://www.foxsports.nl/videodata/'^,
	      //@data-videoid^,
	      '.xml'
	    ^)^"
	-e ^"name:^=concat(
	      'FOX Sports - '^,
	      //title^,
	      replace(
	        //publicationDate^,
	        '(\d{4}^)(\d{2}^)(\d{2}^).+'^,
	        ' ($3$2$1^)'
	      ^)
	    ^)^"
	-f ^"//videoSource[@format^='HLS']/uri^"
	--xquery ^"json:^=[
	            {
	              'format':'meta'^,
	              'url':$url
	            }^,
	            tail(
	              tokenize(
	                $raw^,
	                '#EXT-X-STREAM-INF:'
	              ^)
	            ^) ! {
	              'format':string(
	                extract(
	                  .^,'BANDWIDTH^=(\d+^)'^,1
	                ^) idiv 1000
	              ^)^,
	              'url':concat(
	                resolve-uri('.'^)^,
	                extract(
	                  .^,
	                  '(.+m3u8^)'^,1
	                ^)
	              ^)
	            }
	          ]^,
	          let $a:^=(
	            $json(^)[format^='meta']/format^,
	            for $x in $json(^)[format!^='meta']/format order by $x return $x
	          ^) return (
	            formats:^=join($a^,'^, '^)^,
	            best:^=$a[last(^)]
	          ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:abhd.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	-e ^"let $a:^=[
	      //script/reverse(
	        extract(
	          .^,
	          '(http.+mp4^)'^,1^,'*'
	        ^)[.]
	      ^) !
	        {
	          'format':concat(
	            'mp4-'^,
	            position(^)
	          ^)^,
	          'url':.
	        }
	    ] return (
	      name:^=concat(
	        'ABHD - '^,
	        //div[@id^='playerObject']//a^,
	        replace(
	          $a(1^)/url^,
	          '.+?/(\d+^)/(\d{2}^)(\d{2}^).+'^,
	          ' ($3$2$1^)'
	        ^)
	      ^)^,
	      if (count($a(^)/url^)^=1^) then
	        v_url:^=$a(^)/url
	      else (
	        json:^=$a^,
	        let $b:^=$a(^)/format return (
	          formats:^=join($b^,'^, '^)^,
	          best:^=$b[last(^)]
	        ^)
	      ^)
	    ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:autojunk.nl=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% "%url%"
	-e ^"name:^=concat(
	      'Autojunk - '^,
	      //meta[@property^='og:title']/@content^,
	      replace(
	        //span[@class^='posted']^,
	        '.+?(\d+^)-(\d+^)-(\d+^).+'^,
	        ' ($1$2$3^)'
	      ^)
	    ^)^,
	    //div[@id^='playerWrapper']/(
	      if (iframe^) then
	        v_url:^=replace(
	          iframe/@src^,
	          '.+/(.+^)'^,
	          'https://youtu.be/$1'
	        ^)
	      else
	        let $a:^=[
	          script/extract(
	            .^,'myfile ^= ''(.+^)'''^,1^,'*'
	          ^)[.] !
	            {
	              'format':concat(
	                replace(
	                  .^,
	                  '.+\.(.+^)'^,
	                  '$1-'
	                ^)^,
	                position(^)
	              ^)^,
	              'url':.
	            }
	        ] return
	        if (count($a(^)/url^)^=1^) then
	          v_url:^=$a(^)/url
	        else (
	          json:^=$a^,
	          let $b:^=$a(^)/format return (
	            formats:^=join($b^,'^, '^)^,
	            best:^=$b[last(^)]
	          ^)
	        ^)
	    ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE IF NOT "%url:tweakers.net=%"=="%url%" (
	FOR /F "delims=" %%A IN ('^"%xidel% --method^=POST "%url%"
	--xquery ^"declare function local:extract^($arg^){
	            $arg/[
	              for $x in ^(progressive^)^(^) order by $x/height return
	              system^(
	                x'cmd /c ^"FFMpeg\ffmpeg-N-87867-g0655810-win32-static_legacy.exe^" -i {$x//src} 2^>^&amp^;1'
	              ^) ! {
	                'format':'pg-'^|^|$x/height^,
	                'extension':'mp4'^,
	                'resolution':extract^(
	                  .^,
	                  'Video:.+^, ^(\d+x\d+^)'^,
	                  1
	                ^)^,
	                'vbitrate':replace^(
	                  .^,
	                  '.+Video:.+?^(\d+^) kb.+'^,
	                  'v:$1k'^,
	                  's'
	                ^)^,
	                'abitrate':replace^(
	                  .^,
	                  '.+Audio:.+?^(\d+^) kb.+'^,
	                  'a:$1k'^,
	                  's'
	                ^)^,
	                'url':$x//src
	              }^,
	              let $a:^=^(adaptive^)^(^)[ends-with^(src^,'m3u8'^)]/src return ^(
	                {
	                  'format':'hls-master'^,
	                  'extension':'m3u8'^,
	                  'url':$a
	                }^,
	                for $x in tail^(
	                  tokenize^(
	                    extract^(
	                      unparsed-text^($a^)^,
	                      '^(#EXT-X-STREAM-INF.+m3u8$^)'^,
	                      1^,'ms'
	                    ^)^,
	                    '#EXT-X-STREAM-INF:'
	                  ^)
	                ^) ! {
	                  'format':'hls-'^|^|extract^(
	                    .^,
	                    'BANDWIDTH^=^(\d+^)\d{3}'^,
	                    1
	                  ^)^,
	                  'extension':'m3u8'^,
	                  'resolution':extract^(
	                    .^,
	                    'RESOLUTION^=^(.+?^)^,'^,
	                    1
	                  ^)^,
	                  'vbitrate':extract^(
	                    .^,
	                    'video^=^(\d+^)\d{3}'^,
	                    1
	                  ^) ! ^(
	                    if ^(.^) then
	                      concat^(
	                        'v:'^,
	                        .^,
	                        'k'
	                      ^)
	                    else
	                      ''
	                  ^)^,
	                  'abitrate':replace^(
	                    .^,
	                    '.+audio.+?^(\d+^)\d{3}.+'^,
	                    'a:$1k'^,
	                    's'
	                  ^)^,
	                  'url':resolve-uri^(
	                    '.'^,
	                    $a
	                  ^)^|^|extract^(
	                    .^,
	                    '^(.+m3u8^)'^,
	                    1
	                  ^)
	                } order by $x/format return $x
	              ^)
	            ]
	          }^;
	          if ^(//iframe^) then
	            videos:^=[
	              //iframe/doc^(@src^)/{
	                position^(^):json^(
	                  //script/extract^(
	                    .^,
	                    '''video''^,^(.+^)\^)^;'^,
	                    1
	                  ^)[.]
	                ^)/^(.//items^)^(^)/{
	                  'name':'Tweakers: '^|^|replace^(
	                    title^,
	                    '[^&quot^;^&apos^;]'^,
	                    ''''''
	                  ^)^,
	                  't':duration^,
	                  'duration':duration * dayTimeDuration^('PT1S'^) + time^('00:00:00'^)^,
	                  'formats':local:extract^(locations^)
	                }
	              }
	            ]
	          else
	            json^(
	              //script/extract^(
	                .^,
	                '''video''^,^(.+^)\^)^;'^,
	                1
	              ^)[.]
	            ^)/^(.//items^)^(^)/^(
	              name:^='Tweakers: '^|^|replace^(
	                title^,
	                '[^&quot^;^&apos^;]'^,
	                ''''''
	              ^)^,
	              t:^=duration^,
	              duration:^=$t * dayTimeDuration^('PT1S'^) + time^('00:00:00'^)^,
	              formats:^=local:extract^(locations^)
	            ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
) ELSE (
	ECHO.
	ECHO Ongeldige programma-url.
	ECHO.
	ECHO.
	GOTO Input
)

IF DEFINED videos (
	GOTO Videos
) ELSE IF DEFINED formats (
	GOTO Formats
) ELSE IF DEFINED v_url (
	IF NOT "%%v_url:youtu.be=%%"=="%%v_url%%" (
		GOTO Render
	) ELSE (
		GOTO Select
	)
) ELSE (
	ECHO.
	ECHO Video niet ^(meer^) beschikbaar.
	ECHO.
	ECHO.
	ENDLOCAL
	GOTO Input
)

REM ================================================================================================

:NPO
FOR /F "delims=" %%A IN ('^"%xidel% "http://e.omroep.nl/metadata/%prid%"
--xquery ^"json^(
            extract^(
              $raw^,
              '\^(^(.+^)\^)'^,
              1
            ^)
          ^)[not^(error^)] ! ^(
            name:^=if ^(medium^='live'^) then
              concat^(
                titel^,
                replace^(
                  '%date%'^,
                  '.+?^(\d+^)-^(\d+^)-^(\d+^)'^,
                  ': Livestream ^($1$2$3^)'
                ^)
              ^)
            else
              replace^(
                concat^(
                  if ^(count^(.//naam^)^=1^) then
                    .//naam
                  else
                    join^(
                      .//naam^,
                      ' en '
                    ^)^,
                  ': '^,
                  if ^(ptype^='episode'^) then ^(
                    if ^(aflevering_titel^) then ^(
                      if ^(contains^(titel^,aflevering_titel^)^) then
                        titel
                      else ^(
                        if ^(contains^(aflevering_titel^,titel^)^) then
                          aflevering_titel
                        else
                          concat^(
                            titel^,
                            ' - '^,
                            aflevering_titel
                          ^)
                      ^)
                    ^) else
                      titel
                  ^) else
                    concat^(
                      .//serie_titel^,
                      ' - '^,
                      titel
                    ^)^,
                  if ^(matches^('%date%'^,'^^\d'^)^) then
                    ' ^(%date%^)'
                  else
                    replace^(
                      x:request^(
                        {
                          'data':'http://www.npo.nl/%prid%'^,
                          'method':'HEAD'
                        }
                      ^)/url^,
                      '.+?^(\d+^)-^(\d+^)-^(\d+^).+'^,
                      ' ^($1$2$3^)'
                    ^)
                ^)^,
                '[^&quot^;^&apos^;]'^,
                ''''''
              ^)^,
            if ^(tijdsduur^) then ^(
              duration:^=tijdsduur^,
              t:^=hours-from-time^(tijdsduur^)*3600+minutes-from-time^(tijdsduur^)*60+seconds-from-time^(tijdsduur^)^,
              if ^(start^) then ^(
                start:^=start^,
                ^(hours-from-time^(start^)*3600+minutes-from-time^(start^)*60+seconds-from-time^(start^)^) ! ^(
                  ss:^=.^,
                  if ^(. mod 30^=0^) then ^(
                    if ^(.^=30^) then
                      ^(^)
                    else
                      ss1:^=. - 30^,
                    ss2:^=30
                  ^) else ^(
                    if ^(.^<30^) then
                      ^(^)
                    else
                      ss1:^=. - ^(. mod 30^)^,
                    ss2:^=. mod 30
                  ^)
                ^)^,
                end:^=eind^,
                to:^=hours-from-time^(eind^)*3600+minutes-from-time^(eind^)*60+seconds-from-time^(eind^)
              ^) else
                ^(^)^,
              if ^(publicatie_eind^) then ^(
                let $a:^=dateTime^(publicatie_eind^) - current-dateTime^(^) return
                expire:^=concat^(
                  replace^(
                    publicatie_eind^,
                    '^(\d+^)-^(\d+^)-^(\d+^)T^(.+^)\+.+'^,
                    '$3-$2-$1 $4'
                  ^)^,
                  ' ^(nog '^,
                  days-from-duration^($a^) ! ^(
                    if ^(.^=0^) then
                      ^(^)
                    else if ^(.^=1^) then
                      .^|^|' dag en '
                    else
                      .^|^|' dagen en '
                  ^)^,
                  hours-from-duration^($a^) ! ^(
                    if ^(.^=0^) then
                      ^(^)
                    else
                      .^|^|'u'
                  ^)^,
                  minutes-from-duration^($a^) ! ^(
                    if ^(.^=0^) then
                      ^(^)
                    else
                      .^|^|'m'
                  ^)^,
                  round^(
                    seconds-from-duration^($a^)
                  ^)^,
                  's^)'
                ^)
              ^) else
                ^(^)
            ^) else
              ^(^)^,
            if ^(tt888^='ja'^) then
              s_url:^='http://tt888.omroep.nl/tt888/%prid%'
            else
              ^(^)
          ^)^,
          let $a:^=x:request^(
                {
                  'data':'http://ida.omroep.nl/app.php/%prid%?token^='^|^|json^(
                    'http://ida.omroep.nl/app.php/auth'
                  ^)/token^,
                  'error-handling':'4xx^=accept'
                }
              ^)[
                contains^(
                  headers[1]^,
                  '200'
                ^)
              ]/json/^(items^)^(^)^(^)^,
              $b:^=^(
                for $x in reverse^(
                  $a[contentType^='odi'][format^='mp4']
                ^)/x:request^(
                  {
                    'data':replace^(
                      url^,
                      'jsonp'^,
                      'json'
                    ^)^,
                    'error-handling':'4xx^=accept'
                  }
                ^)[
                  contains^(
                    headers[1]^,
                    '200'
                  ^)
                ]/json/substring-before^(
                  url^,
                  '?'
                ^) return
                system^(
                  x'cmd /c %ffmpeg% -i {$x} 2^>^&amp^;1'
                ^) ! {
                  'format':'pg-'^|^|extract^(
                    $x^,
                    '.+/^([a-z]+^)'^,
                    1
                  ^)^,
                  'extension':'m4v'^,
                  'resolution':extract^(
                    .^,
                    'Video:.+^, ^(\d+x\d+^)'^,
                    1
                  ^)^,
                  'vbitrate':replace^(
                    .^,
                    '.+Video:.+?^(\d+^) kb.+'^,
                    'v:$1k'^,
                    's'
                  ^)^,
                  'abitrate':replace^(
                    .^,
                    '.+Audio:.+?^(\d+^) kb.+'^,
                    'a:$1k'^,
                    's'
                  ^)^,
                  'url':$x
                }^,
                let $b:^=$a[format^='hls']/x:request^(
                  {
                    'data':replace^(
                      url^,
                      'jsonp'^,
                      'json'
                    ^)^,
                    'error-handling':'4xx^=accept'
                  }
                ^)[
                  contains^(
                    headers[1]^,
                    '200'
                  ^)
                ]/^(
                  if ^(doc^) then
                    json^(doc^)
                  else
                    json/url
                ^) return ^(
                  {
                    'format':'hls-master'^,
                    'extension':'m3u8'^,
                    'url':$b
                  }[url]^,
                  for $x in tail^(
                    tokenize^(
                      extract^(
                        unparsed-text^($b^)^,
                        '^(#EXT-X-STREAM-INF.+m3u8$^)'^,
                        1^,'ms'
                      ^)^,
                      '#EXT-X-STREAM-INF:'
                    ^)
                  ^) ! {
                    'format':'hls-'^|^|extract^(
                      .^,
                      'BANDWIDTH^=^(\d+^)\d{3}'^,
                      1
                    ^)^,
                    'extension':'m3u8'^,
                    'resolution':extract^(
                      .^,
                      'RESOLUTION^=^(.+^)^,'^,
                      1
                    ^)^,
                    'vbitrate':extract^(
                      .^,
                      'video^=^(\d+^)\d{3}'^,
                      1
                    ^) ! ^(
                      if ^(.^) then
                        concat^(
                          'v:'^,
                          .^,
                          'k'
                        ^)
                      else
                        ''
                    ^)^,
                    'abitrate':replace^(
                      .^,
                      '.+audio.+?^(\d+^)\d{3}.+'^,
                      'a:$1k'^,
                      's'
                    ^)^,
                    'url':resolve-uri^(
                      '.'^,
                      $b
                    ^)^|^|extract^(
                      .^,
                      '^(.+m3u8^)'^,
                      1
                    ^)
                  } order by $x/format return $x
                ^)^,
                for $x at $i in reverse^(
                  $a[contentType^='url'][format^='mp4']
                ^) ! x:request^(
                  {
                    'data':url^,
                    'method':'HEAD'^,
                    'error-handling':'xxx^=accept'
                  }
                ^)[some $x in ^('200'^,'302'^) satisfies contains^(headers[1]^,$x^)]/^(
                  if ^(contains^(url^,'content-ip'^)^) then
                    x:request^(
                      {
                        'post':serialize-json^(
                          [
                            {
                              'file':url
                            }
                          ]
                        ^)^,
                        'url':'https://nos.nl/video/resolve/'
                      }
                    ^)//file
                  else
                    url
                ^) return
                system^(
                  x'cmd /c %ffmpeg% -i {$x} 2^>^&amp^;1'
                ^) ! {
                  'format':replace^(
                    $x^,
                    '.+\.^(.+^)'^,
                    '$1-'
                  ^)^|^|$i^,
                  'extension':'mp4'^,
                  'resolution':extract^(
                    .^,
                    'Video:.+^, ^(\d+x\d+^)'^,
                    1
                  ^)^,
                  'vbitrate':replace^(
                    .^,
                    '.+Video:.+?^(\d+^) kb.+'^,
                    'v:$1k'^,
                    's'
                  ^)^,
                  'abitrate':replace^(
                    .^,
                    '.+Audio:.+?^(\d+^) kb.+'^,
                    'a:$1k'^,
                    's'
                  ^)^,
                  'url':$x
                }
              ^)
          return
          if ^($b^) then
            formats:^=[$b]
          else
            ^(^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A

IF DEFINED formats (
	GOTO Formats
) ELSE (
	ECHO.
	ECHO Video nog niet, of niet meer beschikbaar.
	ECHO.
	ECHO.
	GOTO Input
)

REM ================================================================================================

:rtlXL
FOR /F "delims=" %%A IN ('^"%xidel% "http://www.rtl.nl/system/s4m/vfd/version=2/uuid=%uuid%/fmt=adaptive/"
--xquery ^"$json/^(
            name:^=replace^(
              concat^(
                .//station^,
                ': '^,
                abstracts/name^,
                ' - '^,
                if ^(.//classname^='uitzending'^) then
                  episodes/name
                else
                  .//title^,
                replace^(
                  .//original_date * dayTimeDuration^('PT1S'^) + date^('1970-01-01'^)^,
                  '^(\d+^)-^(\d+^)-^(\d+^)'^,
                  ' ^($3$2$1^)'
                ^)
              ^)^,
              '[^&quot^;^&apos^;]'^,
              ''''''
            ^)^,
            q:^=.//quality^,
            ^(material^)^(^)/^(
              let $a:^=duration return
              round^(
                seconds-from-time^($a^)
              ^) ! ^(
                duration:^=concat^(
                  extract^(
                    $a^,
                    '^(.+:^)'^,
                    1
                  ^)^,
                  if ^(.^<10^) then
                    '0'^|^|.
                  else
                    .
                ^)^,
                t:^=hours-from-time^($a^)*3600+minutes-from-time^($a^)*60+.
              ^)^,
              if ^(^(.//ddr_timeframes^)^(^)[model^='AVOD']/stop^) then
                let $a:^=^(.//ddr_timeframes^)^(^)[model^='AVOD']/stop * dayTimeDuration^('PT1S'^) + dateTime^('1970-01-01T00:00:00'^)^,
                    $b:^=$a - current-dateTime^(^)
                return
                expire:^=concat^(
                  replace^(
                    $a^,
                    '^(\d+^)-^(\d+^)-^(\d+^)T^(.+^)'^,
                    '$3-$2-$1 $4'
                  ^)^,
                  ' ^(nog '^,
                  days-from-duration^($b^) ! ^(
                    if ^(.^=0^) then
                      ^(^)
                    else if ^(.^=1^) then
                      .^|^|' dag en '
                    else
                      .^|^|' dagen en '
                  ^)^,
                  hours-from-duration^($b^) ! ^(
                    if ^(.^=0^) then
                      ^(^)
                    else
                      .^|^|'u'
                  ^)^,
                  minutes-from-duration^($b^) ! ^(
                    if ^(.^=0^) then
                      ^(^)
                    else
                      .^|^|'m'
                  ^)^,
                  round^(
                    seconds-from-duration^($b^)
                  ^)^,
                  's^)'
                ^)
              else
                ^(^)
            ^)
          ^)^"
-f ^"$json/^(
      if ^(meta/nr_of_videos_total^=0^) then
        ^(^)
      else
        concat^(
          meta/videohost^,
          material/videopath
        ^)
    ^)^"
--xquery ^"let $a:^=if ^($q^='HD'^) then
            ^('a2t'^,'a3t'^,'nettv'^)
          else
            ^('a2t'^,'a3t'^) return
          formats:^=[
            for $x at $i in ^(
              $a ! replace^(
                $url^,
                '.+^(/comp.+^)m3u8'^,
                concat^(
                  'http://pg.us.rtl.nl/rtlxl/network/'^,
                  .^,
                  '/progressive$1mp4'
                ^)
              ^)
            ^) return
            system^(
              x'cmd /c ^"FFMpeg\ffmpeg-N-87867-g0655810-win32-static_legacy.exe^" -user_agent \^"BatchGemist %ver%\^" -i {$x} 2^>^&amp^;1'
            ^) ! {
              'format':'pg-'^|^|$a[$i]^,
              'extension':'mp4'^,
              'resolution':extract^(
                .^,
                'Video:.+^, ^(\d+x\d+^)'^,
                1
              ^)^,
              'vbitrate':replace^(
                .^,
                '.+Video:.+?^(\d+^) kb.+'^,
                'v:$1k'^,
                's'
              ^)^,
              'abitrate':replace^(
                .^,
                '.+Audio:.+?^(\d+^) kb.+'^,
                'a:$1k'^,
                's'
              ^)^,
              'url':$x^,
              'teapot':true
            }^,
            {
              'format':'hls-master'^,
              'extension':'m3u8'^,
              'url':$url
            }^,
            for $x in tail^(
              tokenize^(
                $raw^,
                '#EXT-X-STREAM-INF:'
              ^)
            ^) ! {
              'format':'hls-'^|^|extract^(
                .^,
                'BANDWIDTH^=^(\d+^)\d{3}'^,
                1
              ^)^,
              'extension':'m3u8'^,
              'resolution':extract^(
                .^,
                'RESOLUTION^=^(.+^)'^,
                1
              ^)^,
              'vbitrate':extract^(
                .^,
                'video^=^(\d+^)\d{3}'^,
                1
              ^) ! ^(
                if ^(.^) then
                  concat^(
                    'v:'^,
                    .^,
                    'k'
                  ^)
                else
                  ''
              ^)^,
              'abitrate':replace^(
                .^,
                '.+audio.+?^(\d+^)\d{3}.+'^,
                'a:$1k'^,
                's'
              ^)^,
              'url':extract^(
                .^,
                '^(.+m3u8^)'^,
                1
              ^)
            } order by $x/format return $x
          ]^" --output-encoding^=oem --output-format^=cmd^"') DO %%A

IF DEFINED formats (
	GOTO Formats
) ELSE (
	ECHO.
	ECHO Video nog niet, of niet meer beschikbaar.
	ECHO.
	ECHO.
	GOTO Input
)

REM ================================================================================================

:Kijk
FOR /F "delims=" %%A IN ('^"%xidel% "http://api.kijk.nl/v1/default/entitlement/%prid%"
--xquery ^"$json/playerInfo[not^(hasDRM^)]/^(
            if ^(.//enddate^) then
              dateTime^(
                replace^(
                  .//enddate/date^,
                  ' '^,
                  'T'
                ^)
              ^) ! ^(
                let $a:^=. - current-dateTime^(^) return
                expire:^=concat^(
                  replace^(
                    .^,
                    '^(\d+^)-^(\d+^)-^(\d+^)T^(.+^)'^,
                    '$3-$2-$1 $4'
                  ^)^,
                  ' ^(nog '^,
                  days-from-duration^($a^) ! ^(
                    if ^(.^=0^) then
                      ^(^)
                    else if ^(.^=1^) then
                      .^|^|' dag en '
                    else
                      .^|^|' dagen en '
                  ^)^,
                  hours-from-duration^($a^) ! ^(
                    if ^(.^=0^) then
                      ^(^)
                    else
                      .^|^|'u'
                  ^)^,
                  minutes-from-duration^($a^) ! ^(
                    if ^(.^=0^) then
                      ^(^)
                    else
                      .^|^|'m'
                  ^)^,
                  round^(
                    seconds-from-duration^($a^)
                  ^)^,
                  's^)'
                ^)
              ^)
            else
              ^(^)^,
            let $a:^=doc^(
                  'http:'^|^|embed_video_url
                ^)[//@data-video-id]/x:request^(
                  {
                    'headers':
                      'Accept: application/json^;pk^='^|^|
                      extract^(
                        unparsed-text^(
                          //script[
                            contains^(
                              @src^,
                              //@data-account
                            ^)
                          ]/@src
                        ^)^,
                        'policyKey:\^"^(.+?^)\^"'^,
                        1
                      ^)^,
                    'url':concat^(
                      'https://edge.api.brightcove.com/playback/v1/accounts/'^,
                      //@data-account^,
                      '/videos/'^,
                      //@data-video-id
                    ^)^,
                    'error-handling':'xxx^=accept'
                  }
                ^)/json[not^(.//error_code^)]^,
                $b:^=json^(embed_api_url^)[videoId]
            return ^(
              if ^($a^) then
                $a/^(
                  name:^=if ^(.//sbs_videotype^='vod'^) then
                    concat^(
                      if ^(.//sbs_station^='veronicatv'^) then
                        'Veronica'
                      else
                        upper-case^(.//sbs_station^)^,
                      ': '^,
                      name^,
                      if ^(string-length^(.//sbs_episode^)^<^=7^) then
                        ' '^|^|.//sbs_episode
                      else
                        ^(^)^,
                      replace^(
                        .//sko_dt^,
                        '^(\d{4}^)^(\d{2}^)^(\d{2}^)'^,
                        ' ^($3$2$1^)'
                      ^)
                    ^)
                  else
                    concat^(
                      .//sbs_program^,
                      ': '^,
                      name^,
                      replace^(
                        published_at^,
                        '^(\d+^)-^(\d+^)-^(\d+^).+'^,
                        ' ^($3$2$1^)'
                      ^)
                    ^)^,
                  t:^=round^(duration div 1000^)
                ^)
              else
                $b/^(
                  name:^=concat^(
                    if ^(.//sbs_videotype^='vod'^) then
                      if ^(.//sbs_station^='veronicatv'^) then
                        'Veronica'
                      else
                        upper-case^(.//sbs_station^)
                    else
                      .//sbs_program^,
                    ': '^,
                    .//title^,
                    replace^(
                      .//sko_dt^,
                      '^(\d{4}^)^(\d{2}^)^(\d{2}^)'^,
                      ' ^($3$2$1^)'
                    ^)
                  ^)^,
                  t:^=.//duration
                ^)^,
              duration:^=$t * dayTimeDuration^('PT1S'^) + time^('00:00:00'^)^,
              'https://empprdsubtitles.blob.core.windows.net/vtt/Sanoma/SBS/%prid%_dbzyr6/vtt/nl.vtt' ! ^(
                if ^(unparsed-text-available^(.^)^) then
                  s_url:^=.
                else
                  ^(^)
              ^)^,
              formats:^=[
                if ^($a//sbs_videotype^='vod'^) then ^(
                  for $x in $a/^(sources^)^(^)[container^='MP4'] order by $x/size return $x/{
                    'format':'pg-'^|^|avg_bitrate idiv 1000^,
                    'extension':'mp4'^,
                    'resolution':concat^(
                      width^,
                      'x'^,
                      height
                    ^)^,
                    'url':replace^(
                      stream_name^,
                      'mp4:'^,
                      extract^(
                        $a/^(sources^)^(^)/src^,
                        '^(.+nl/^)'^,
                        1
                      ^)
                    ^)
                  }^,
                  {
                    'format':'hls-master'^,
                    'extension':'m3u8'^,
                    'url':$a/^(sources^)^(^)/src
                  }^,
                  tail^(
                    tokenize^(
                      unparsed-text^(
                        $a/^(sources^)^(^)/src
                      ^)^,
                      '#EXT-X-STREAM-INF:'
                    ^)
                  ^) ! {
                    'format':'hls-'^|^|extract^(
                      .^,
                      'BANDWIDTH^=^(\d+^)\d{3}'^,
                      1
                    ^)^,
                    'extension':'m3u8'^,
                    'resolution':extract^(
                      .^,
                      'RESOLUTION^=^(.+?^)^,'^,
                      1
                    ^)^,
                    'url':resolve-uri^(
                      '.'^,
                      $a/^(sources^)^(^)/src
                    ^)^|^|extract^(
                      .^,
                      '^(.+m3u8^)'^,
                      1
                    ^)
                  }
                ^) else
                  for $x in $a/^(sources^)^(^)[src] order by $x/size return $x/{
                    'format':'pg-'^|^|avg_bitrate idiv 1000^,
                    'extension':'mp4'^,
                    'resolution':concat^(
                      width^,
                      'x'^,
                      height
                    ^)^,
                    'url':src
                  }^,
                $b/^(
                  {
                    'format':'hls-master_hd'^,
                    'extension':'m3u8'^,
                    'url':playlist
                  }^,
                  tail^(
                    tokenize^(
                      unparsed-text^(playlist^)^,
                      '#EXT-X-STREAM-INF:'
                    ^)
                  ^) ! {
                    'format':replace^(
                      .^,
                      '.+BANDWIDTH^=^(\d+^)\d{3}.+'^,
                      'hls-$1_hd'^,
                      's'
                    ^)^,
                    'extension':'m3u8'^,
                    'resolution':extract^(
                      .^,
                      'RESOLUTION^=^(.+^)'^,
                      1
                    ^)^,
                    'url':extract^(
                      .^,
                      '^(.+m3u8^)'^,
                      1
                    ^)
                  }
                ^)
              ]
            ^)
          ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A

IF DEFINED formats (
	GOTO Formats
) ELSE (
	ECHO.
	ECHO Video nog niet, of niet meer beschikbaar.
	ECHO.
	ECHO.
	GOTO Input
)

REM ================================================================================================

:NPORadio
SETLOCAL
ECHO.
ECHO Beschikbare radiozenders:
ECHO.
%xidel% "http://radio-app.omroep.nl/player/script/player.js" ^
--xquery ^"for $x in json(^
             extract(^
               $raw,^
               'NPW.config.channels=(.+),NPW.config.comscore_configurations',^
               1^
             )^
           )()[name!='demo'] order by $x/id return^
           concat('  ',^
             $x/id,^
             '. ',^
             $x/name^
           )^"
ECHO.
SET /P "id=Voer nummer in van gewenste radiozender: "
IF NOT DEFINED id (
	ECHO.
	ENDLOCAL
	GOTO Input
)
FOR /F "delims=" %%A IN ('^"%xidel% "http://radio-app.omroep.nl/player/script/player.js"
--xquery ^"json^(
            extract^(
              $raw^,
              'NPW.config.channels^=^(.+^)^,NPW.config.comscore_configurations'^,
              1
            ^)
          ^)^(^)[name!^='demo'][id^=%id%]/^(
            name:^=name^|^|replace^(
              '%date%'^,
              '.+?^(\d+^)-^(\d+^)-^(\d+^)'^,
              ': Livestream ^($1$2$3^)'
            ^)^,
            formats:^=[
              for $x in ^(audiostreams^)^(^)[protocol^='http'] order by $x/bitrate return
              $x/{
                'format':concat^(
                  audiocodec^,
                  '-'^,
                  bitrate
                ^)^,
                'abitrate':concat^(
                  'a:'^,
                  bitrate^,
                  'k'
                ^)^,
                'url':url
              }^,
              ^(videostreams^)^(^)[protocol^='prid']/^(
                let $a:^=json^(
                  concat^(
                    'http://ida.omroep.nl/app.php/'^,
                    url^,
                    '?token^='^,
                    json^(
                      'http://ida.omroep.nl/app.php/auth'
                    ^)/token
                  ^)
                ^)/json^(
                  replace^(
                    .//url^,
                    'jsonp'^,
                    'json'
                  ^)
                ^) return ^(
                  {
                    'format':'hls-master'^,
                    'extension':'m3u8'^,
                    'url':$a
                  }^,
                  for $x in tail^(
                    tokenize^(
                      extract^(
                        unparsed-text^($a^)^,
                        '^(#EXT-X-STREAM-INF.+m3u8$^)'^,
                        1^,'ms'
                      ^)^,
                      '#EXT-X-STREAM-INF:'
                    ^)
                  ^) ! {
                    'format':'hls-'^|^|extract^(
                      .^,
                      'BANDWIDTH^=^(\d+^)\d{3}'^,
                      1
                    ^)^,
                    'extension':'m3u8'^,
                    'resolution':extract^(
                      .^,
                      'RESOLUTION^=^(.+^)^,'^,
                      1
                    ^)^,
                    'vbitrate':extract^(
                      .^,
                      'video^=^(\d+^)\d{3}'^,
                      1
                    ^) ! ^(
                      if ^(.^) then
                        concat^(
                          'v:'^,
                          .^,
                          'k'
                        ^)
                      else
                        ''
                    ^)^,
                    'abitrate':replace^(
                      .^,
                      '.+audio.+?^(\d+^)\d{3}.+'^,
                      'a:$1k'^,
                      's'
                    ^)^,
                    'url':resolve-uri^(
                      '.'^,
                      $a
                    ^)^|^|extract^(
                      .^,
                      '^(.+m3u8^)'^,
                      1
                    ^)
                  } order by $x/format return $x
                ^)
              ^)
            ]
          ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A

IF DEFINED formats (
	GOTO Formats
) ELSE (
	ECHO.
	ECHO Ongeldig nummer.
	ECHO.
	ENDLOCAL
	GOTO NPORadio
)

REM ================================================================================================

:NPOGids
SETLOCAL
ECHO.
ECHO Voer datum in als dd-mm-jjjj:
FOR /F "delims=" %%A IN ('^"%xidel%
-e ^"let $a:^=replace^(
      read^(^)^,
      '^(\d+^)-^(\d+^)-^(\d+^)'^,
      '$3-$2-$1'
    ^) return
    if ^($a castable as date^) then
      date2:^=$a
    else
      ^(^)^" --output-format^=cmd^"') DO %%A
IF NOT DEFINED date2 (
	ECHO.
	ECHO Ongeldige datum.
	ECHO.
	ENDLOCAL
	GOTO NPOGids
)

ECHO.
%xidel% "https://www.npo.nl/gids?date=%date2%&type=tv" ^
--xquery ^"let $json:=[^
                for $x in //div[^
                  @id=(^
                    'channel-NED1',^
                    'channel-NED2',^
                    'channel-NED3'^
                  )^
                ]//a[.//span[@class='npo-epg-play']]/{^
                  'tijdstip':.//span[@class='npo-epg-time'],^
                  'zender':@data-channel,^
                  'titel':.//span[@class='npo-epg-title'],^
                  'url':@href^
                }^
                group by $url:=$x/extract(^
                           url,^
                           '.+/(.+)',^
                           1^
                         )^
                order by $x[1]/extract(^
                           url,^
                           '.+/(.+)/',^
                           1^
                         ),^
                         $x[1]/tijdstip^
                return $x[1]^
              ],^
              $width:=string-length(^
                count($json())^
              )^
          for $x at $i in $json() return^
          '  '^|^|join(^
            (^
              substring(^
                concat(^
                  $i,^
                  '.',^
                  string-join(^
                    (1 to $width) ! ' '^
                  )^
                ),^
                1,^
                $width+1^
              ),^
              (^
                'tijdstip',^
                'zender',^
                'titel'^
              ) ! $x(.)^
            ),^
            '  '^
          )^"
ECHO.
SET /P "id=Voer nummer in van gewenst programma: "
IF NOT DEFINED id (
	ECHO.
	ENDLOCAL
	GOTO Input
)
FOR /F "delims=" %%A IN ('^"%xidel% "https://www.npo.nl/gids?date=%date2%&type=tv"
--xquery ^"let $json:^=[
            for $x in //div[
              @id^=^(
                'channel-NED1'^,
                'channel-NED2'^,
                'channel-NED3'
              ^)
            ]//a[.//span[@class^='npo-epg-play']]/{
              'tijdstip':.//span[@class^='npo-epg-time']^,
              'zender':@data-channel^,
              'titel':.//span[@class^='npo-epg-title']^,
              'url':@href
            }
            group by $url:^=$x/extract^(
                       url^,
                       '.+/^(.+^)'^,
                       1
                     ^)
            order by $x[1]/extract^(
                       url^,
                       '.+/^(.+^)/'^,
                       1
                     ^)^,
                     $x[1]/tijdstip
            return $x[1]
          ] return
          prid:^=$json^(%id%^)/extract^(
            url^,
            '.+/^(.+^)'^,
            1
          ^)^" --output-format^=cmd^"') DO %%A

IF DEFINED prid (
	GOTO NPO
) ELSE (
	ECHO.
	ECHO Ongeldig nummer.
	ECHO.
	ENDLOCAL
	GOTO NPOGids
)

REM ================================================================================================

:Videos
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F "delims=" %%A IN ('ECHO %videos% ^| %xidel% - -e "count($json())"') DO (
	IF "%%A"=="1" (
		FOR /F "delims=" %%A IN ('ECHO %videos% ^| %xidel%
		- --xquery ^"$json^(^)^('1'^)/^(
		              name:^=name^,
		              duration:^=duration^,
		              t:^=t^,
		              if ^(url^) then
		                v_url:^=url
		              else
		                formats:^=formats
		            ^)^" --output-encoding^=oem --output-format^=cmd') DO %%A
	) ELSE (
		ECHO.
		ECHO Beschikbare video's:
		ECHO.
		ECHO %videos% | %xidel% ^
		- -e ^"$json^(^)/concat^(^
		        '  '^,^
		        .^(^)^,^
		        '. '^,^
		        .//name^
		      ^)^"
		ECHO.
		SET /P "video=Kies gewenste video: [1] "
		IF NOT DEFINED video SET "video=1"
		FOR /F "delims=" %%A IN ('ECHO %videos% ^| %xidel%
		- --xquery ^"$json^(^)^('!video!'^)/^(
		              if ^(goto^) then ^(
		                goto:^=goto^,
		                prid:^=prid
		              ^) else ^(
		                name:^=name^,
		                duration:^=duration^,
		                t:^=t^,
		                if ^(url^) then
		                  v_url:^=url
		                else
		                  formats:^=formats
		              ^)
		            ^)^" --output-encoding^=oem --output-format^=cmd') DO %%A
	)
)

IF DEFINED goto (
	GOTO %goto%
) ELSE IF DEFINED formats (
	GOTO Formats
) ELSE IF DEFINED v_url (
	GOTO Select
) ELSE (
	ECHO.
	ECHO Ongeldige video.
	ECHO.
	ENDLOCAL
	GOTO Videos
)

REM ================================================================================================

:Formats
SETLOCAL ENABLEDELAYEDEXPANSION
ECHO.
FOR /F "delims=" %%A IN ('ECHO %formats% ^| %xidel% - -e "count($json())"') DO (
	IF "%%A"=="1" (
		ECHO Beschikbaar formaat:
		ECHO.
		ECHO %formats% | %xidel% ^
		- --xquery ^"let $a:^=^(^
		                  'extension'^,^
		                  'resolution'^,^
		                  'vbitrate'^,^
		                  'abitrate'^
		                ^)^,^
		                $b:^=$a ^^! max(^
		                  $json^(^)^(.^) ^^! string-length^(.^)^
		                ^)^,^
		                $c:^=string-join(^
		                  ^(1 to sum^($b^)^) ^^! ' '^
		                ^)^
		            for $x in $json^(^) return^
		            '  '^|^|string-join^(^
		              for $y at $i in $a return^
		              substring^(^
		                $x^($y^)^|^|$c^,^
		                1^,^
		                $b[$i]+2^
		              ^)^
		            ^)^"
		FOR /F "delims=" %%A IN ('ECHO %formats% ^| %xidel% - -e "v_url:=$json()/url" --output-format^=cmd') DO %%A
	) ELSE (
		ECHO Beschikbare formaten:
		ECHO.
		ECHO %formats% | %xidel% ^
		- --xquery ^"let $a:^=^(^
		                  'format'^,^
		                  'extension'^,^
		                  'resolution'^,^
		                  'vbitrate'^,^
		                  'abitrate'^
		                ^)^,^
		                $b:^=$a ^^! max(^
		                  $json^(^)^(.^) ^^! string-length^(.^)^
		                ^)^,^
		                $c:^=string-join(^
		                  ^(1 to sum^($b^)^) ^^! ' '^
		                ^)^
		            for $x in $json^(^) return^
		            '  '^|^|string-join^(^
		              for $y at $i in $a return^
		              substring^(^
		                $x^($y^)^|^|$c^,^
		                1^,^
		                $b[$i]+2^
		              ^)^
		            ^)^"
		ECHO.
		FOR /F "delims=" %%A IN ('ECHO %formats% ^| %xidel% - -e "$json()[last()]/format"') DO (
			SET /P "format=Voer gewenst formaat in: [%%A] "
			IF NOT DEFINED format SET "format=%%A"
		)
		FOR /F "delims=" %%A IN ('ECHO %formats% ^| %xidel% ^
		- -e ^"$json^(^)[format^='!format!']/^(
		        v_url:^=url^,
		        if ^(teapot^) then
		          ffmpeg_ua:^='-user_agent \^"BatchGemist %ver%\^"'
		        else
		          ^(^)
		      ^)^" --output-format^=cmd') DO %%A
	)
)

IF DEFINED v_url (
	GOTO Select
) ELSE (
	ECHO.
	ECHO Ongeldig formaat.
	ECHO.
	ENDLOCAL
	GOTO Formats
)

REM ================================================================================================

:Select
SETLOCAL DISABLEDELAYEDEXPANSION
IF NOT DEFINED duration (
	FOR /F "delims=" %%A IN ('^"%xidel%
	-e ^"let $a:^=extract^(
	      system^('cmd /c %ffmpeg% -i %v_url% 2^>^&1'^)^,
	      'Duration: ^(.+?^)^,'^,
	      1
	    ^) return
	    if ^($a castable as time^) then 
	      round^(
	        seconds-from-time^($a^)
	      ^) ! ^(
	        duration:^=concat^(
	          extract^(
	            $a^,
	            '^(.+:^)'^,
	            1
	          ^)^,
	          if ^(.^<10^) then
	            '0'^|^|.
	          else
	            .
	        ^)^,
	        t:^=hours-from-time^($a^)*3600+minutes-from-time^($a^)*60+.
	      ^)
	    else
	      (^)^" --output-format^=cmd^"') DO %%A
)
FOR /F "delims=" %%A IN ('^"%xidel%
-e ^"name:^=replace^(
      normalize-space^('%name%'^)^,
      '[^<^>/\\^|?*]'^,
      ''
    ^)^" --output-encoding^=oem --output-format^=cmd^"') DO %%A
ECHO.
IF DEFINED duration (
	ECHO Naam:       %name%
	ECHO Tijdsduur:  %duration% ^(%t%%duration:~8,4%s^)
	IF DEFINED ss (
		ECHO Begin:      %start% ^(%ss%s^)
		ECHO Einde:      %end% ^(%to%s^)
	)
	IF DEFINED expire ECHO Gratis tot: %expire%
) ELSE (
	ECHO Naam: %name%
)

ECHO.
ECHO   1. Audio/video-url weergeven.
ECHO   2. Audio/video downloaden.
IF EXIST %mpc% (
	ECHO   3. Audio/video openen met MPC-HC/BE.
	ECHO   4. Audio/video openen met FFmpeg en streamen naar MPC-HC/BE.
)
ECHO.
SET id=
SET /P "id=Voer keuze in: [1] "
IF NOT DEFINED id (
	GOTO Render
) ELSE IF "%id%"=="1" (
	GOTO Render
) ELSE IF "%id%"=="2" (
	GOTO Download
) ELSE IF EXIST %mpc% (
	IF "%id%"=="3" GOTO Play
	IF "%id%"=="4" GOTO Play
	ECHO.
	ECHO Ongeldige keuze.
	ECHO.
	ENDLOCAL
	GOTO Select
) ELSE (
	ECHO.
	ECHO Ongeldige keuze.
	ECHO.
	ENDLOCAL
	GOTO Select
)

ECHO.
ECHO.
ENDLOCAL
ENDLOCAL
ENDLOCAL
GOTO Input

REM ================================================================================================

:Render
IF DEFINED ss (
	FOR /F "delims=" %%A IN ('^"%xidel%
	-e ^"concat^(
	      '%v_url%?start^^^='^,
	      round^(%ss1%+%ss2%^)^,
	      '^^^&end^^^='^,
	      round^(%to%^)
	    ^)^"^"') DO SET "v_url=%%A"
)
ECHO.
ECHO Audio- of video-url:
ECHO %v_url%
ECHO|SET /P ="%v_url:^=%"|clip.exe
ECHO.
ECHO Url gekopieerd naar het klembord.
ECHO.
ECHO.
ENDLOCAL
ENDLOCAL
ENDLOCAL
GOTO Input

REM ================================================================================================

:Play
SETLOCAL ENABLEDELAYEDEXPANSION
IF DEFINED ss (
	IF "%id%"=="3" (
		FOR /F "delims=" %%A IN ('^"%xidel%
		-e ^"concat^(
		      '?start^='^,
		      round^(%ss1%+%ss2%^)^,
		      '^&end^='^,
		      round^(%to%^)
		    ^)^"^"') DO %mpc% %v_url%%%A /close
	)
	IF "%id%"=="4" %ffmpeg% -v fatal -ss %ss1% -i %v_url% -ss %ss2% -t %t% -c copy -f nut - | %mpc% - /close
) ELSE IF DEFINED s_url (
	ECHO.
	SET /P "subs=Inclusief ondertiteling? [j/N] "
	IF /I "!subs!"=="j" (
		IF "%id%"=="3" %mpc% %v_url% /sub %s_url% /close
		IF "%id%"=="4" %ffmpeg% -v fatal %ffmpeg_ua% -i %v_url% -c copy -f nut - | %mpc% - /sub %s_url% /close
	) ELSE (
		IF "%id%"=="3" %mpc% %v_url% /close
		IF "%id%"=="4" %ffmpeg% -v fatal %ffmpeg_ua% -i %v_url% -c copy -f nut - | %mpc% - /close
	)
) ELSE (
	IF "%id%"=="3" %mpc% %v_url% /close
	IF "%id%"=="4" %ffmpeg% -v fatal %ffmpeg_ua% -i %v_url% -c copy -f nut - | %mpc% - /close
)
ECHO.
ECHO.
ENDLOCAL
ENDLOCAL
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
	ECHO Opslaan in:
	FOR /F "delims=" %%A IN ('^"%xidel%
	--xquery ^"let $a:^=extract(
	                read(^)^,
	                '(.:\\^|\\\\^)(.+^)'^,
	                (1^,2^)
	              ^),
	              $b:^=concat(
	                $a[1]^,
	                replace(
	                  if (ends-with($a[2]^,'\'^)^) then
	                    $a[2]
	                  else
	                    $a[2]^|^|'\'^,
	                  '[^<^>/^|?*:^^]'^,
	                  ''
	                ^)
	              ^)
	          return (
	            $b^,
	            file:create-dir($b^)
	          ^)^" --output-encoding^=oem^"') DO SET "map=%%A"
)

FOR /F "tokens=1 delims=?" %%A IN ("%v_url%") DO (
	IF /I "%%~xA"==".m4a"  SET ext=.m4a
	IF /I "%%~xA"==".m4v"  SET ext=.mp4
	IF /I "%%~xA"==".mp4"  SET ext=.mp4
	IF /I "%%~xA"==".m3u8" SET ext=.mp4
	IF /I "%%~xA"==".asf"  SET ext=.wmv
)

SET "name=%name::=-%"
ECHO.
ECHO Bestandsnaam: %name%%ext%
SET /P "rename=Wijzigen? [J/n] "
IF /I NOT "%rename%"=="n" (
	ECHO Nieuwe bestandsnaam ^(zonder extensie^):
	FOR /F "delims=" %%A IN ('^"%xidel%
	-e ^"replace(
	      replace(
	        read(^)^,
	        ':'^,
	        '-'
	      ^)^
	      '[^<^>/\\^|?*^^]'^,
	      ''
	    ^)^" --output-encoding^=oem^"') DO SET "name=%%A"
)

SETLOCAL ENABLEDELAYEDEXPANSION
IF DEFINED s_url (
	ECHO.
	SET /P "subs=Ondertiteling Downloaden? [j/N] "
	IF /I "!subs!"=="j" (
		ECHO.
		SET /P "mux=Ondertiteling Muxen? [j/N] "
		IF /I NOT "!mux!"=="j" SET mux=
	) ELSE (
		SET subs=
	)
)

ECHO.
IF DEFINED ss1 (
	IF DEFINED mux (
		%ffmpeg% -hide_banner -ss %ss1% -i %v_url% -ss %ss1% -i %s_url% -ss %ss2% -t %t% -c copy -bsf:a aac_adtstoasc -c:s srt -metadata:s:s language=dut "!map!%name%.mkv"
	) ELSE (
		%ffmpeg% -hide_banner -ss %ss1% -i %v_url% -ss %ss2% -t %t% -c copy -bsf:a aac_adtstoasc "!map!%name%%ext%"
		IF DEFINED subs ECHO. & %ffmpeg% -hide_banner -ss %ss1% -i %s_url% -ss %ss2% -t %t% "!map!%name%.srt"
	)
) ELSE IF DEFINED ss2 (
	IF DEFINED mux (
		%ffmpeg% -hide_banner -i %v_url% -i %s_url% -ss %ss2% -t %t% -c copy -bsf:a aac_adtstoasc -c:s srt -metadata:s:s language=dut "!map!%name%.mkv"
	) ELSE (
		%ffmpeg% -hide_banner -i %v_url% -ss %ss2% -t %t% -c copy -bsf:a aac_adtstoasc "!map!%name%%ext%"
		IF DEFINED subs ECHO. & %ffmpeg% -hide_banner -i %s_url% -ss %ss2% -t %t% "!map!%name%.srt"
	)
) ELSE (
	SET /P "part=Fragment downloaden? [j/N] "
	IF /I "!part!"=="j" (
		ECHO Voer begintijd in ^(in seconden, of als uu:mm:ss[.xxx]^):
		FOR /F "delims=" %%A IN ('^"%xidel%
		-e ^"let $a:^=read(^) return
		    if ($a^) then
		      let $a:^=if ($a castable as time^) then
		        hours-from-time($a^)*3600+minutes-from-time($a^)*60+seconds-from-time($a^)
		      else
		        $a
		      return
		      if ($a^=0^) then
		        (^)
		      else
		        if ($a mod 30^=0^) then (
		          if ($a^=30^) then
		            (^)
		          else
		            ss1:^=$a - 30^,
		          ss2:^=30
		        ^) else (
		          if ($a^<30^) then
		            (^)
		          else
		            ss1:^=$a - ($a mod 30^)^,
		          ss2:^=$a mod 30
		        ^)
		    else
		      (^)^" --output-format^=cmd^"') DO %%A
		ECHO Voer tijdsduur in ^(in seconden, of als uu:mm:ss[.xxx]^):
		SET /P t=
		IF DEFINED mux (
			IF DEFINED ss1 (
				IF DEFINED t (
					%ffmpeg% -hide_banner %ffmpeg_ua% -ss !ss1! -i %v_url% -ss !ss1! -i %s_url% -ss !ss2! -t !t! -c copy -bsf:a aac_adtstoasc -c:s srt -metadata:s:s language=dut "!map!%name%.mkv"
				) ELSE (
					%ffmpeg% -hide_banner %ffmpeg_ua% -ss !ss1! -i %v_url% -ss !ss1! -i %s_url% -ss !ss2! -c copy -bsf:a aac_adtstoasc -c:s srt -metadata:s:s language=dut "!map!%name%.mkv"
				)
			) ELSE IF DEFINED ss2 (
				IF DEFINED t (
					%ffmpeg% -hide_banner %ffmpeg_ua% -i %v_url% -i %s_url% -ss !ss2! -t !t! -c copy -bsf:a aac_adtstoasc -c:s srt -metadata:s:s language=dut "!map!%name%.mkv"
				) ELSE (
					%ffmpeg% -hide_banner %ffmpeg_ua% -i %v_url% -i %s_url% -ss !ss2! -c copy -bsf:a aac_adtstoasc -c:s srt -metadata:s:s language=dut "!map!%name%.mkv"
				)
			) ELSE (
				%ffmpeg% -hide_banner %ffmpeg_ua% -i %v_url% -i %s_url% -t !t! -c copy -bsf:a aac_adtstoasc -c:s srt -metadata:s:s language=dut "!map!%name%.mkv"
			)
		) ELSE (
			IF DEFINED ss1 (
				IF DEFINED t (
					%ffmpeg% -hide_banner %ffmpeg_ua% -ss !ss1! -i %v_url% -ss !ss2! -t !t! -c copy -bsf:a aac_adtstoasc "!map!%name%%ext%"
					IF DEFINED subs ECHO. & %ffmpeg% -hide_banner -ss !ss1! -i %s_url% -ss !ss2! -t !t! "!map!%name%.srt"
				) ELSE (
					%ffmpeg% -hide_banner %ffmpeg_ua% -ss !ss1! -i %v_url% -ss !ss2! -c copy -bsf:a aac_adtstoasc "!map!%name%%ext%"
					IF DEFINED subs ECHO. & %ffmpeg% -hide_banner -ss !ss1! -i %s_url% -ss !ss2! "!map!%name%.srt"
				)
			) ELSE IF DEFINED ss2 (
				IF DEFINED t (
					%ffmpeg% -hide_banner %ffmpeg_ua% -i %v_url% -ss !ss2! -t !t! -c copy -bsf:a aac_adtstoasc "!map!%name%%ext%"
					IF DEFINED subs ECHO. & %ffmpeg% -hide_banner -i %s_url% -ss !ss2! -t !t! "!map!%name%.srt"
				) ELSE (
					%ffmpeg% -hide_banner %ffmpeg_ua% -i %v_url% -ss !ss2! -c copy -bsf:a aac_adtstoasc "!map!%name%%ext%"
					IF DEFINED subs ECHO. & %ffmpeg% -hide_banner -i %s_url% -ss !ss2! "!map!%name%.srt"
				)
			) ELSE (
				%ffmpeg% -hide_banner %ffmpeg_ua% -i %v_url% -t !t! -c copy -bsf:a aac_adtstoasc "!map!%name%%ext%"
				IF DEFINED subs ECHO. & %ffmpeg% -hide_banner -i %s_url% -t !t! "!map!%name%.srt"
			)
		)
	) ELSE (
		ECHO.
		IF DEFINED mux (
			%ffmpeg% -hide_banner %ffmpeg_ua% -i %v_url% -i %s_url% -c copy -bsf:a aac_adtstoasc -c:s srt -metadata:s:s language=dut "!map!%name%.mkv"
		) ELSE (
			%ffmpeg% -hide_banner %ffmpeg_ua% -i %v_url% -c copy -bsf:a aac_adtstoasc "!map!%name%%ext%"
			IF DEFINED subs ECHO. & %ffmpeg% -hide_banner -i %s_url% "!map!%name%.srt"
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

:Versie
ECHO.
ECHO BatchGemist %ver%
%xidel% -e ^"replace(^
              system('%xidel:"=% --version'),^
              '(.+)\r\n.+(\.\d+)\..+',^
              '$1$2',^
              's'^
            )^"
%xidel% -e ^"replace(^
              system('%ffmpeg:"=% -version'),^
              '(.+?) (?:version )?([\w.-]+).+',^
              '$1 $2',^
              's'^
            )^"
ECHO.
ECHO.
GOTO Input

REM ================================================================================================

:Help
ECHO.
ECHO   [Beschrijving]
ECHO     BatchGemist is een batchscript om video's van verscheidene websites te downloaden, of de
ECHO     video-url ervan te achterhalen.
ECHO.
ECHO   [Benodigdheden]
ECHO     - xidel.exe (http://videlibri.sourceforge.net/xidel.html#downloads)
ECHO       Xidel is het hart van BatchGemist en is verantwoordelijk voor het ontleden van zo'n beetje
ECHO       alle gegevens.
ECHO       Download Xidel (versie 0.9.7.5651* of nieuwer) en plaats 'xidel.exe' in dezelfde map als dit
ECHO       batchscript, of wijzig de programma-map in dit script onder ":Check".
ECHO       * https://sourceforge.net/projects/videlibri/files/Xidel/Xidel development/
ECHO     - ffmpeg.exe (http://ffmpeg.zeranoe.com/builds)
ECHO       Met de gegenereerde video-url als invoer zorgt FFMpeg ervoor dat de video effici‰nt wordt
ECHO       gedownload.
ECHO       Download FFMpeg en plaats 'ffmpeg.exe' in dezelfde map als dit batchscript, of wijzig de
ECHO       programma-map in dit script onder ":Check".
ECHO     - clip.exe (http://www.c3scripts.com/tutorials/msdos/clip.zip) [Windows XP]
ECHO       Clip kopieert de video-url naar het klembord. Vanaf Windows Vista wordt 'clip.exe' standaard
ECHO       meegeleverd, dus dit is alleen voor Windows XP gebruikers.
ECHO       Download Clip en plaats 'clip.exe' in de C:\WINDOWS\system32 map.
ECHO     - mpc-hc.exe/mpc-be.exe (https://mpc-hc.org/downloads/, https://sourceforge.net/projects/mpcbe
ECHO       /files/MPC-BE/) (optioneel)
ECHO       Met Media Player Classic - Home Cinema / Black Edition kan een gegenereerde video-url
ECHO       rechtstreeks geopend worden.
ECHO       Download MPC-HC/BE, plaats 'mpc-hc.exe' of 'mpc-be.exe' in dezelfde map als dit batchscript
ECHO       en voeg de programma-map toe in dit script onder ":Check".
ECHO.
ECHO   [Ondersteunde websites]
ECHO     npo.nl                eenvandaag.nl         omropfryslan.nl           rtvutrecht.nl
ECHO.
PAUSE
ECHO.
ECHO     gemi.st               rtlxl.nl              rtvnoord.nl               omroepgelderland.nl
ECHO     2doc.nl               rtl.nl                rtvdrenthe.nl             omroepwest.nl
ECHO     anderetijden.nl       rtlnieuws.nl          rtvnh.nl                  rijnmond.nl
ECHO     schooltv.nl           rtlz.nl               omroepflevoland.nl        omroepzeeland.nl
ECHO     willemwever.nl        kijk.nl               rtvoost.nl                omroepbrabant.nl
ECHO     nos.nl                sbs6.nl               at5.nl                    l1.nl
ECHO.
ECHO     telegraaf.nl          dumpert.nl            autojunk.nl
ECHO     vtm.be                comedycentral.nl      tweakers.net
ECHO     nickelodeon.nl        nl.funnyclips.cc
ECHO     ketnet.be             mtv.nl
ECHO     disney.nl             foxtv.nl
ECHO     cartoonnetwork.nl     foxsports.nl
ECHO     24kitchen.nl          abhd.nl
ECHO.
ECHO   [Gebruik]
ECHO     Surf naar ‚‚n van de ondersteunde websites en kopieer de programma-url van een gewenst
ECHO     programma. Start dit batch-script en plak deze url d.m.v. rechtermuis-knop + plakken (Ctrl+V
ECHO     werkt hier niet).
ECHO     Voer 'npo-radio' in voor een opsomming van alle NPO radiozenders.
ECHO     Voer 'npo-gids' in voor een opsomming van alle tv-programma's die op NPO1, NPO2 en NPO3 zijn
ECHO     geweest.
ECHO.
ECHO     Dan volgt een opsomming van beschikbare formaten en wordt er gevraagd een keuze te maken.
ECHO     E‚n formaat, tussen blokhaken, is altijd voorgeselecteerd om de hoogste resolutie/bitrate.
ECHO     Voor dit formaat kun je gewoon op ENTER drukken. Formaten die beginnen met 'hls' zijn
ECHO     dynamische videostreams en eindigen op 'm3u8'. Formaten die beginnen met 'pg' zijn
ECHO     progressieve videostreams en eindigen op 'mp4/m4v'.
ECHO     Deze stap wordt overgeslagen als er maar ‚‚n formaat beschikbaar is.
ECHO.
PAUSE
ECHO.
ECHO     Vervolgens krijg je de keuze om de gegenereerde audio/video-url weer te geven, te downloaden,
ECHO     of te openen met MPC-HC/BE (als je die hebt toegevoegd onder ":Check"). Optie 1 tussen blok-
ECHO     haken is voorgeselecteerd. In dat geval kun je dan gewoon op ENTER drukken.
ECHO     Voor de ja/nee-vragen die dan volgen geldt dit ook. De keuze met hoofdletter is voor-
ECHO     geselecteerd. Voor 'ja' bij "[J/n]" kun je dan gewoon op ENTER drukken.
ECHO.
ECHO     Voer 'v' in voor de versie nummers van BatchGemist, Xidel en FFMpeg.
ECHO     Druk op ENTER om BatchGemist af te sluiten.
ECHO.
ECHO.
IF DEFINED check (
	PAUSE & GOTO :EOF
) ELSE (
	GOTO Input
)
