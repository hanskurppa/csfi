$enfile = cat -Encoding utf8 "C:\Program Files (x86)\Steam\steamapps\common\Cities_Skylines\Files\Locale\en.po"
$fifile = cat -Encoding utf8 "C:\Program Files (x86)\Steam\steamapps\common\Cities_Skylines\Files\Locale\fi.po"
$OutOrigSort = "C:\Program Files (x86)\Steam\steamapps\common\Cities_Skylines\Files\Locale\fi_origsort.po"
$OutSorted = "C:\Program Files (x86)\Steam\steamapps\common\Cities_Skylines\Files\Locale\fi_sorted.po"

Remove-Variable en -ea 0 -wa 0 | out-null
Remove-Variable fi -ea 0 -wa 0 | out-null
Remove-Variable fiorigsort -ea 0 -wa 0 | out-null
Remove-Variable fisorted -ea 0 -wa 0 | out-null
$en = [pscustomobject]@{}
$fi = [pscustomobject]@{}
$fiorigsort = @()
$fisorted = @()

for ($i=0; $i -lt $enfile.count; $i++) {
    if ($enfile[$i] -cmatch "^#\.\s+`"(.+)`"") {
        $j = $i + 2

        $en | Add-Member -NotePropertyName $Matches[1] -NotePropertyValue $enfile[$i..$j]
    }
}

for ($i=0; $i -lt $fifile.count; $i++) {
    if ($fifile[$i] -cmatch "^#\.\s+`"(.+)`"") {
        $j = $i + 2

        $fi | Add-Member -NotePropertyName $Matches[1] -NotePropertyValue $fifile[$i..$j]
    }
}

$names = $en.psobject.properties | ? membertype -eq noteproperty | select -exp name
$cnt = 0

foreach ($i in $names) {
    write-output "$cnt - $i"
    
    $fiorigsort += $fi.$i
    $cnt++
}

$sortednames = $names | sort
$cnt = 0

foreach ($i in $sortednames) {
    write-output "$cnt - $i"
    
    $fisorted += $fi.$i
    $cnt++
}

copy-item -force -ea 0 -wa 0 $OutOrigSort "$OutOrigSort$((date).Ticks.ToString())" | Out-Null
out-file -Encoding utf8 -Force -InputObject $fiorigsort -FilePath $OutOrigSort

copy-item -force -ea 0 -wa 0 $OutSorted "$OutSorted$((date).Ticks.ToString())" | Out-Null
out-file -Encoding utf8 -Force -InputObject $fisorted -FilePath $OutSorted