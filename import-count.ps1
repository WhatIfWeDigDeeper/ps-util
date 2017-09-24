$lookup = @{}
gci -Filter *.js -Recurse | Get-Content | Where-Object {$_ -imatch "import (\w+) from 'lodash/(\w+)'.*" } | ForEach-Object { write-host $matches[1] }
