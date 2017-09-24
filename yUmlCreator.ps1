function Is-MatchOld([string] $line1, [string] $line2) {
    if (($line1 -imatch ".*\[JsonProperty\(PropertyName.*""(\w+)""\s*\)\].*") -eq $true) {
            [string] $jsonName = $($matches[1])
            if (($line2 -imatch ".*public\s+(?:List\<)?\w+[\[\]\.]*\w*[\[\]\?]*(?:\>)?\s+(\w+).*") -eq $true) { 
                [string] $propName = $($matches[1])
                if ([string]::IsNullOrEmpty($propName) -or [string]::IsNullOrEmpty($jsonName)) {
                    Write-Error ('Property is blank 1: ' + $line1 + ' 2: ' + $line2)
                }
                if (($jsonName -imatch $propName) -eq $true) {
                    return $true
                }
            }
    }
    elseif ($line1 -imatch ".*\[JsonProperty\(DefaultValueHandling = DefaultValueHandling.Ignore, PropertyName = ""(\w+)""\s*\)\].*") {
            [string] $jsonName = $($matches[1])
            if (($line2 -imatch ".*public\s+(?:List\<)?\w+[\[\]\.]*\w*[\[\]\?]*(?:\>)?\s+(\w+).*") -eq $true) { 
                [string] $propName = $($matches[1])
                if ([string]::IsNullOrEmpty($propName) -or [string]::IsNullOrEmpty($jsonName)) {
                    Write-Error ('Property is blank 1: ' + $line1 + ' 2: ' + $line2)
                }
                if (($jsonName -imatch $propName) -eq $true) {
                    return $true
                }
            }

    }
    return $false
}

function Is-Match([string] $line1, [string] $line2) {
    if (($line1 -imatch ".*\[JsonProperty\(PropertyName.*""(\w+)""\s*\)\].*") -eq $true) {
            [string] $jsonName = $($matches[1])
            if (($line2 -imatch ".*public\s+(?:List\<)?\w+[\[\]\.]*\w*[\[\]\?]*(?:\>)?\s+(\w+).*") -eq $true) { 
                [string] $propName = $($matches[1])
                if ([string]::IsNullOrEmpty($propName) -or [string]::IsNullOrEmpty($jsonName)) {
                    Write-Error ('Property is blank 1: ' + $line1 + ' 2: ' + $line2)
                }
                if (($jsonName -imatch $propName) -eq $true) {
                    return $true
                }
            }
    }
    elseif ($line1 -imatch ".*\[JsonProperty\(DefaultValueHandling = DefaultValueHandling.Ignore, PropertyName = ""(\w+)""\s*\)\].*") {
            [string] $jsonName = $($matches[1])
            if (($line2 -imatch ".*public\s+(?:List\<)?\w+[\[\]\.]*\w*[\[\]\?]*(?:\>)?\s+(\w+).*") -eq $true) { 
                [string] $propName = $($matches[1])
                if ([string]::IsNullOrEmpty($propName) -or [string]::IsNullOrEmpty($jsonName)) {
                    Write-Error ('Property is blank 1: ' + $line1 + ' 2: ' + $line2)
                }
                if (($jsonName -imatch $propName) -eq $true) {
                    return $true
                }
            }

    }
    return $false
}


function Should-Not-Match([string] $jsonPropName, [string] $propName, [string] $returnType) {
    $line1 = "[JsonProperty(PropertyName = """ + $jsonPropName + """)]"
    $line2 = "public " + $returnType + " " + $propName + " { get; set; }"
    if (Is-Match -line1 $line1 -line2 $line2) {  Write-Error ('Should not have matched 1: ' + $line1 + ' 2: ' + $line2) } else { Write-Host 'ok'}

}

function Should-Match([string] $jsonPropName, [string] $propName, [string] $returnType) {
    $line1 = "[JsonProperty(PropertyName = """ + $jsonPropName + """)]"
    $line2 = "public " + $returnType + " " + $propName + " { get; set; }"
    if (Is-Match -line1 $line1 -line2 $line2) { Write-Host 'ok'  } else { Write-Error ('Should not have matched 1: ' + $line1 + ' 2: ' + $line2) }
}



function No-Default-Should-Not-Match([string] $jsonPropName, [string] $propName, [string] $returnType) {
    $line1 = "[JsonProperty(DefaultValueHandling = DefaultValueHandling.Ignore, PropertyName = """ + $jsonPropName + """)]"
    $line2 = "public " + $returnType + " " + $propName + " { get; set; }"
    if (Is-Match -line1 $line1 -line2 $line2) {  Write-Error ('Should not have matched 1: ' + $line1 + ' 2: ' + $line2) } else { Write-Host 'ok'}

}

function No-Default-Should-Match([string] $jsonPropName, [string] $propName, [string] $returnType) {
    $line1 = "[JsonProperty(DefaultValueHandling = DefaultValueHandling.Ignore, PropertyName = """ + $jsonPropName + """)]"
    $line2 = "public " + $returnType + " " + $propName + " { get; set; }"
    if (Is-Match -line1 $line1 -line2 $line2) { Write-Host 'ok'  } else { Write-Error ('Should not have matched 1: ' + $line1 + ' 2: ' + $line2) }
}

function Test-Cases() {
    No-Default-Should-Not-Match -jsonPropName 'totalSpent' -propName 'TotalOrderAmount' -returnType 'decimal?'
    No-Default-Should-Not-Match -jsonPropName 'totalSpent' -propName 'TotalOrderAmount' -returnType 'List<decimal>'
    No-Default-Should-Not-Match -jsonPropName 'totalSpent' -propName 'TotalOrderAmount' -returnType 'List<decimal?>'
    No-Default-Should-Not-Match -jsonPropName 'totalSpent' -propName 'TotalOrderAmount' -returnType 'List<DW.Total>'
    No-Default-Should-Not-Match -jsonPropName 'totalSpent' -propName 'TotalOrderAmount' -returnType 'DW.Total'
    No-Default-Should-Not-Match -jsonPropName 'totalSpent' -propName 'TotalOrderAmount' -returnType 'DW.Total?'



    No-Default-Should-Match -jsonPropName 'totalSpent' -propName 'TotalSpent' -returnType 'decimal?'
    No-Default-Should-Match -jsonPropName 'totalSpent' -propName 'TotalSpent' -returnType 'List<decimal>'
    No-Default-Should-Match -jsonPropName 'totalSpent' -propName 'TotalSpent' -returnType 'List<decimal?>'
    No-Default-Should-Match -jsonPropName 'totalSpent' -propName 'TotalSpent' -returnType 'List<DW.Total>'
    No-Default-Should-Match -jsonPropName 'totalSpent' -propName 'TotalSpent' -returnType 'DW.Total'
    No-Default-Should-Match -jsonPropName 'totalSpent' -propName 'TotalSpent' -returnType 'DW.Total?'



    Should-Not-Match -jsonPropName 'totalSpent' -propName 'TotalOrderAmount' -returnType 'decimal?'
    Should-Not-Match -jsonPropName 'totalSpent' -propName 'TotalOrderAmount' -returnType 'List<decimal>'
    Should-Not-Match -jsonPropName 'totalSpent' -propName 'TotalOrderAmount' -returnType 'List<decimal?>'
    Should-Not-Match -jsonPropName 'totalSpent' -propName 'TotalOrderAmount' -returnType 'List<DW.Total>'
    Should-Not-Match -jsonPropName 'totalSpent' -propName 'TotalOrderAmount' -returnType 'DW.Total'
    Should-Not-Match -jsonPropName 'totalSpent' -propName 'TotalOrderAmount' -returnType 'DW.Total?'



    Should-Match -jsonPropName 'totalSpent' -propName 'TotalSpent' -returnType 'decimal?'
    Should-Match -jsonPropName 'totalSpent' -propName 'TotalSpent' -returnType 'List<decimal>'
    Should-Match -jsonPropName 'totalSpent' -propName 'TotalSpent' -returnType 'List<decimal?>'
    Should-Match -jsonPropName 'totalSpent' -propName 'TotalSpent' -returnType 'List<DW.Total>'
    Should-Match -jsonPropName 'totalSpent' -propName 'TotalSpent' -returnType 'DW.Total'
    Should-Match -jsonPropName 'totalSpent' -propName 'TotalSpent' -returnType 'DW.Total?'

}

Test-Cases