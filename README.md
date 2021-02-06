# Kielitiedoston asentaminen
Lataa ja tallenna `fi.locale` tiedosto kansioon
```
C:\Program Files (x86)\Steam\steamapps\common\Cities_Skylines\Files\Locale
```
Käynnistä Launcher > Play > Options > Gameplay > valitse Language = SUOMI (FINNISH)

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

Esim PowerShellissä
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

Kun suoritus valmis, tee uudet käännökset fi_origsort.po tiedostoon. Mene lopuksi takaisin Localization Tool ja aseta Import-kohtaan

origin locale = `C:\Program Files (x86)\Steam\steamapps\common\Cities_Skylines\Files\Locale\en.locale`

import profile = `C:\Program Files (x86)\Steam\steamapps\common\Cities_Skylines\Files\Locale\fi_origsort.po`

export path = `C:\Program Files (x86)\Steam\steamapps\common\Cities_Skylines\Files\Locale\fi.locale`

native text = `SUOMI`

english text = `(FINNISH)`

Klikkaa Import kohdassa **start**

Käynnistä peli ja tarkista että suomikäännös toimii edelleen.
