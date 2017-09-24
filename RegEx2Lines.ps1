param($dir, [bool] $recurse=$true)

function Is-Match([string] $jsonName, [string] $line2) {

    if (($line2 -imatch ".*public\s+(?:List\<)?\w+[\[\]\.]*\w*[\[\]\?]*(?:\>)?\s+(\w+).*") -eq $true) { 
        [string] $propName = $($matches[1])
        if ([string]::IsNullOrEmpty($propName) -or [string]::IsNullOrEmpty($jsonName)) {
            Write-Error ('Property is blank jsonProp: ' + $jsonName + ' 2: ' + $line2)
            return $false
        }
        if (($jsonName -imatch $propName) -eq $true) {
            return $true
        }
    }
    return $false
}



function Read-aFile($filePath) {
    [string] $signalReplace = "****XXXX_ReplaceMe_XXXX****"
    [bool] $replacedSomething = $false

    write-host $filePath
    $fileContent = (Get-Content -Path $filePath).Replace("`r`n","`n") 
    $originalFileContent = (Get-Content -Path $filePath).Replace("`r`n","`n") 
    for($i = 0; $i -lt $fileContent.Length; $i = $i + 1) {
        $line1 = $fileContent[$i]
        if (($line1 -imatch ".*\[JsonProperty\(PropertyName.*""(\w+)""\s*\)\].*") -eq $true) {
            [string] $jsonName = $($matches[1])
            $i = $i + 1
            $line2 = $fileContent[$i]

            if (Is-Match -jsonName $jsonName -line2 $line2) {
                $fileContent[($i-1)] = $signalReplace
                $replacedSomething = $true
            }


            #if (($line2 -imatch ".*public\s+\w+[\[\]\?\.]*\s+(\w+).*|.*public\s+\w+\?\s+(\w+).*|.*public\s+List\<.*\>\s*(\w+).*|.*public\s+\w+\.\w+\s+(\w+).*") -eq $true) { 
            #if (($line2 -imatch ".*public\s+\w+[\[\]\.]*\w*[\[\]\?]*\s+(\w+).*|.*public\s+List\<.*\>\s*(\w+).*") -eq $true) { 
            #    [string] $propName = $($matches[1])
#
            #    if (($jsonName -imatch $propName) -eq $true) {
           ##         $fileContent[($i-1)] = $signalReplace
           #         $replacedSomething = $true
          #      }
           # }
    
        }
        elseif ($line1 -imatch ".*\[JsonProperty\(DefaultValueHandling\s*=\s*DefaultValueHandling.Ignore, PropertyName\s*=\s*""(\w+)""\s*\)\].*") {
            $jsonName = $($matches[1])
            $i = $i + 1
            $line2 = $fileContent[$i]
            if (Is-Match -jsonName $jsonName -line2 $line2) {
                $fileContent[($i-1)] = "`t`t[JsonProperty(DefaultValueHandling = DefaultValueHandling.Ignore)]"
                $replacedSomething = $true
            }
            
        }   

    }
        
    if ($replacedSomething -and (-not ([string]::IsNullOrEmpty($fileContent))) ) {
        $fileContent = $fileContent | where {$_ -ne $signalReplace}
        if ($fileContent -eq $null) {
            Write-Error 'FileContent problem!!!!!'
            return
        }
        Try {
            $fileContent | Out-File -FilePath $filePath -Encoding UTF8 -Force
        }
        Catch {
            Write-Error ($_.Exception.Message)
            Write-Error ('Restoring original file ' + $filePath)
            $originalFileContent | Out-File -FilePath $filePath -Encoding utf8 -Force
        }
    }

}


function Read-Files($dir, $recurse) {
    if ($recurse) {
        gci -Path $dir -Filter '*.cs' -Recurse |  foreach-object { Read-aFile -filePath ($_.FullName)}
    }
    else {
        gci -Path $dir -Filter '*.cs' |  foreach-object { Read-aFile -filePath ($_.FullName)}
    }
}


Read-Files -dir $dir -recurse $recurse







#"[JsonProperty(PropertyName = 'roles')]" -imatch ".*\[JsonProperty.*PropertyName.*'(\w+)'.*"


#if (("public int Roles { get; set; }" -imatch ".*public\s+\w+\s+(\w+).*") -eq $true) { $($matches[1])}