param($dir, [bool] $recurse=$true)

function Add-toLookup($errType, $lookup) {
    if (-not $lookup.ContainsKey($errType)) {
        $lookup.Add($errType, 1)
    } else {
        $lookup[$errType] = $lookup[$errType] + 1
    }
}

function Read-Files($dir, $recurse) {
    $regExPattern = ".*new (?<vaeEx>Vae[a-z]+).*"
    $regExExcluePattern = ".*//.*new Vae.*"
    $excludeFolders = ("*test*","*Test*","*node_modules*")
    $lookup = @{}
    if ($recurse) {
        gci -Path $dir -Filter '*.cs' -Exclude $excludeFolders -Recurse | foreach-object {  type $_.FullName } | where { $_ -imatch $regExPattern } | 
            foreach { Add-toLookup -errType $matches['vaeEx'] -lookup $lookup }
    }
    else { 
        gci -Path $dir -Filter '*.cs' | foreach-object {  type $_.FullName } | where { $_ -imatch $regExPattern -and (-not ($_ -imatch $regExExcluePattern) ) } | 
            foreach { Add-toLookup -errType $matches['vaeEx'] -lookup $lookup }
    }
    $lookup.GetEnumerator() | sort -Property value -Descending | Format-Table -AutoSize
}

Read-Files -dir $dir -recurse $recurse
