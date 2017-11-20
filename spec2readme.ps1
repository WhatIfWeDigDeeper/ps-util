Param(
  [string]$srcPath = '.',
  [string]$targetReadme = 'README.md',
  [string]$fileFilter = '*Tests.js'
)

function Get-Header($file) {
  $fileName = $file.Name.replace('Tests', '').replace('.js', '')
  "# $fileName"
}

function Process-File($file) {
  return Get-Content $file.FullName | Where-Object {$_ -imatch "^\s*describe\('.*|^\s*it\('.*" } | Where-Object {$_ -imatch "([describe|it]*)\('([^']*)',.*" } | ForEach-Object { if($matches[1] -eq "it"){ "  * it " + $matches[2]} else { "### " + $matches[2]}}
}

gci $srcPath -Filter $fileFilter -Recurse | ForEach-Object { Get-Header($_); Process-File($_) } | Out-File $targetReadme
