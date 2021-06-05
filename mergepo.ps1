<#
    Skripti pyrkii yhdistämään päivitetyn en.locale tiedoston sisällön
    viimeisimmän suomikäännöksen kanssa.

    Jos päivitetyssä en.localessa on uusia kääntämättömiä kohteita,
    niiden msgstr jää tyhjäksi ja ne voi kääntää tiedostoon jonka
    tämä skripti luo.

    locale/po tiedostojen purkamiseen ja pakkaamiseen täytyy käyttää sovellusta
    Cities Skylines Localization Tool
    https://forum.paradoxplaza.com/forum/threads/release-cities-skylines-localization-tool.844524/

    Steam-asennuksen oletuskansio kielitiedostoille
    C:\Program Files (x86)\Steam\steamapps\common\Cities_Skylines\Files\Locale


    1. Päivitä Cities uusimpaan versioon


    2. Pura päivitetyn version en.locale
        export
            locale file = C:\Program Files (x86)\Steam\steamapps\common\Cities_Skylines\Files\Locale\en.locale
            export path = C:\Program Files (x86)\Steam\steamapps\common\Cities_Skylines\Files\Locale
        klikkaa export > start


    3. Kopioi viimeisimmän suomikäännöksen po-tiedosto 
       tämän skriptin kansioon tiedostoksi fi.po

       Jos löytyy vain fi.locale, voit purkaa sen kuten en.locale


    4. Suorita tämä skripti
       Skripti päivittää tiedoston fi.po sisällön


    5. Tee uudet käännökset tiedostoon fi.po


    6. Pakkaa päivitetty käännös tiedostoksi fi.locale
        import
            origin locale = C:\Program Files (x86)\Steam\steamapps\common\Cities_Skylines\Files\Locale\en.locale
            import pofile = C:\<skriptinkansio>\fi.po
            export path = C:\Program Files (x86)\Steam\steamapps\common\Cities_Skylines\Files\Locale\fi.locale
            native text = SUOMI
            english text = (FINNISH)
        klikkaa import > start
    
    7. Käynnistä Cities ja testaa että käännös toimii

    8. Kun teet "käännösluuppia", toista 6-7
       Localization Tool ikkuna voi olla auki.
       Riittää että klikkaat import > start, ja pelin käännös päivittyy.
       Cities voi olla käynnissä, 
       mutta käy vaihtamassa Asetuksissa kieli ENGLISH ja takaisin SUOMI.
#>

$EnImportFile = Get-Content -Encoding utf8 -Path (Join-Path $PSScriptRoot "en.po")
$FiImportFile = Get-Content -Encoding utf8 -Path (Join-Path $PSScriptRoot "fi.po")

<#
    Esimerkki alkuperäisestä englanninkielisestä tekstistä

    PS> $en[0] | fl
    
    msg    : BUILDING_TITLE[Panda Sanctuary]:0
    msgid  : Panda Sanctuary
    msgstr :
#>
$en = for ($i=0; $i -lt $EnImportFile.count; $i++) {
    if ($EnImportFile[$i] -cmatch "^#\.\s+`"(.+)`"") {
		[pscustomobject]@{
            "msg"    = $Matches[1]
            "msgid"  = $($EnImportFile[$i+1] -replace '^msgid\s+"','' -replace '"$','')
            "msgstr" = $($EnImportFile[$i+2] -replace '^msgstr\s+"','' -replace '"$','')
        }
    }
}

<#
    Esimerkki aiemmin käännetystä tekstistä

    PS> $fi[0] | fl

    msg    : BUILDING_TITLE[Panda Sanctuary]:0
    msgid  : Panda Sanctuary
    msgstr : Pandan rauhoitusalue


    Esimerkki kääntämättömästä tekstistä

    PS> $fi | ? msgstr -eq "" | select -first 1 | fl

    msg    : BUILDING_TITLE[Liberal Arts Administration 01]:0
    msgid  : Liberal Arts Administration Building
    msgstr :
#>
$fi = for ($i=0; $i -lt $FiImportFile.count; $i++) {
    if ($FiImportFile[$i] -cmatch "^#\.\s+`"(.+)`"") {
        [pscustomobject]@{
            "msg"    = $Matches[1]
            "msgid"  = $($FiImportFile[$i+1] -replace '^msgid\s+"','' -replace '"$','')
            "msgstr" = $($FiImportFile[$i+2] -replace '^msgstr\s+"','' -replace '"$','')
        }
    }
}

$cnt = 0
$FiMsgCache = $fi.msg | ForEach-Object {@{"$_" = $cnt++}}
$cnt = 0

$FiMerged = foreach ($i in $en) {
    Write-Progress -Activity "fi.po [ $($cnt) / $($en.count) ]" -CurrentOperation $i.msg -PercentComplete ((($cnt++) / $en.count) * 100)

    $FiMsg = $null = $fi[$($FiMsgCache."$($i.msg)")]

    if ($FiMsg -and ($FiMsg.msgid -ne $i.msgid)) {
        [pscustomobject]@{
            "msg"    = $i.msg
            "msgid"  = $i.msgid
            "msgstr" = $FiMsg.msgid
        }
    } elseif ($FiMsg -and ($FiMsg.msgstr -ne "")) {
        [pscustomobject]@{
            "msg"    = $i.msg
            "msgid"  = $i.msgid
            "msgstr" = $FiMsg.msgstr
        }
    } else {
        $i
    }
}

# Varmuuskopioidaan olemassa oleva
Move-Item (Join-Path $PSScriptRoot "fi.po") (Join-Path (Join-Path $PSScriptRoot "pobackup") "fi_$((Get-Date).Ticks.ToString()).po")

# Päivitetään fi.po tiedoston sisältö
foreach ($i in $FiMerged) {
    "#. ""$($i.msg)""`nmsgid ""$($i.msgid)""`nmsgstr ""$($i.msgstr)""" | Out-File -Force -Append -Encoding utf8 -FilePath (Join-Path $PSScriptRoot "fi.po")
}

$DoneCnt = $FiMerged.count - ($FiMerged | Where-Object msgstr -eq '').count
$AllCnt = $FiMerged.count
$DonePct = [math]::round($DoneCnt/$AllCnt*100, 0)
$SearchRegex = "## Käännetty \(.+\)"
$ReplaceString = "## Käännetty ($DoneCnt/$AllCnt $DonePct%)"

#(Get-Content -Encoding utf8 -Path (Join-Path $PSScriptRoot "README.md")) |
#    ForEach-Object {$_ -Replace $SearchRegex, $ReplaceString} |
#        Set-Content -WhatIf -Encoding utf8 -Path (Join-Path $PSScriptRoot "README.md")
