Param(
  [string]$library = 'lodash',
  [string]$srcPath = '.',
  [string]$fileFilter = '*.js'
)

$lookup = @{}
gci $srcPath -Filter $fileFilter -Recurse | Get-Content | Where-Object {$_ -imatch "import (\w+) from '$library/(\w+)'.*" } | ForEach-Object { if ($lookup.containsKey($matches[1])) { $lookup.set_item($matches[1], $lookup.get_item($matches[1]) + 1) } else { $lookup.add($matches[1], 1)} }
$lookup.getEnumerator() | Sort-Object -Property @{Expression = "value"; Descending = $True}, @{Expression = "name"; Descending = $False}
