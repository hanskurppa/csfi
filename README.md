# Kielitiedoston asentaminen
Lataa ja tallenna `fi.locale` tiedosto kansioon
```
C:\Program Files (x86)\Steam\steamapps\common\Cities_Skylines\Files\Locale
```
Käynnistä **Launcher** > **Play** > **Options** > **Gameplay** > valitse **Language** = **SUOMI (FINNISH)**

# Kielitiedoston päivitys, kun pelistä on tullut uusi build
Avaa *Start-kuvakkeen päällä hiiren oikea > Windows PowerShell (järjestelmänvalvoja)* >  ja siirry Locale kansioon
```
cd "C:\Program Files (x86)\Steam\steamapps\common\Cities_Skylines\Files\Locale"
```

Kopioi Locale kansioon nämä tiedostot
```
CitiesSkylines_EN_1.3.1.exe
fi.po
sortpo.ps1
```

Esim. PowerShellissä
```
Invoke-RestMethod "https://github.com/hanskurppa/csfi/blob/main/CitiesSkylines_EN_1.3.1.exe?raw=true" -OutFile CitiesSkylines_EN_1.3.1.exe
Invoke-RestMethod "https://raw.githubusercontent.com/hanskurppa/csfi/main/sortpo.ps1" -OutFile sortpo.ps1
Invoke-RestMethod "https://raw.githubusercontent.com/hanskurppa/csfi/main/fi.po" -OutFile fi.po
```

Käynnistä Localization Tool
```
.\CitiesSkylines_EN_1.3.1.exe
```

Aseta Export-kohdassa

locale file = `C:\Program Files (x86)\Steam\steamapps\common\Cities_Skylines\Files\Locale\en.locale`  
export path = `C:\Program Files (x86)\Steam\steamapps\common\Cities_Skylines\Files\Locale`

Klikkaa Export-kohdassa **start**

Suorita PowerShell-ikkunassa
```
.\sortpo.ps1
```

Saattaa tulla punaista virhetekstiä, mutta ne voi jättää huomiotta.  
Kun suoritus on valmis, **tee uudet käännökset** `fi_origsort.po` tiedostoon.  
Mene lopuksi takaisin Localization Tool ja aseta Import-kohtaan

origin locale = `C:\Program Files (x86)\Steam\steamapps\common\Cities_Skylines\Files\Locale\en.locale`  
import profile = `C:\Program Files (x86)\Steam\steamapps\common\Cities_Skylines\Files\Locale\fi_origsort.po`  
export path = `C:\Program Files (x86)\Steam\steamapps\common\Cities_Skylines\Files\Locale\fi.locale`  
native text = `SUOMI`  
english text = `(FINNISH)`

Klikkaa Import kohdassa **start**

Käynnistä peli ja tarkista että suomikäännös toimii edelleen.

# Käännöksen edistyminen
Testattu 18.2.2021 versiolla 1.13.1-f1.

**Käännetty (5165/10946 47%)**  
Kaikki käyttöliittymäelementit, poislukien editorit ja näppäinasetukset.  
Lähes kaikki pääohjeikkunat (Advisor).  
Lähes kaikki tietonäkymät, paneelit, tilastot ja politiikat.  
Lähes kaikki kohteiden nimet (title).  
Lähes kaikki työkaluvihjeet (tooltip).  
Osa rakennusten ja propsien kuvauksista (desc, short desc).  
Osa skenaarioteksteistä (trigger).

**Kääntämättä - työn alla**  
Loput propsien nimet.  
Loput rakennusten ja propsien kuvaukset.  
Loput ohjeikkunat, eli Advisorin pienet ponnahdusviestit.  
Merkkipaalut -paneelin loput työkaluvihjeet.  
Loput skenaariotekstit.  
Editorit.  
Näppäinasetukset.  
Mitä uutta -paneeli.

**Kääntämättä - ei työn alla / ei ole tarkoitus kääntää**  
Chirpit. Liian monta käännettäväksi.  
Erisnimet, paikannimet, nimisäännöt. Muutama kauppa testiksi käännetty.  
Saavutukset/Achievements. Näitä ei ole Steamissakaan suomenkielisenä.  
Lauseke/Legal Disclaimer -tekstit.  
Credits/Tekijät.
