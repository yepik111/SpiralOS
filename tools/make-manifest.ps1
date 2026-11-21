param([string]$Version,[string]$Message)
$root=(Resolve-Path "github-repo").Path
$utf8=New-Object System.Text.UTF8Encoding($false)
[IO.File]::WriteAllText("$root\VERSION",$Version+"`n",$utf8)
$cl="$root\CHANGELOG.md"; $old=""; if(Test-Path $cl){$old=[IO.File]::ReadAllText($cl)}
[IO.File]::WriteAllText($cl,"## $Version ($(Get-Date -Format yyyy-MM-dd))`n- $Message`n`n"+$old,$utf8)
Get-ChildItem "$root\rootfs" -Recurse -File | ForEach-Object {
  $b=[IO.File]::ReadAllBytes($_.FullName)
  if($b -notcontains 0){ $s=[Text.Encoding]::UTF8.GetString($b) -replace "`r`n","`n"; [IO.File]::WriteAllBytes($_.FullName,$utf8.GetBytes($s)) }
}
$lines=@(((Get-FileHash "$root\VERSION" -Algorithm SHA256).Hash.ToLower())+"  VERSION")
Get-ChildItem "$root\rootfs" -Recurse -File | Sort-Object FullName | ForEach-Object {
  $rel=$_.FullName.Substring($root.Length+1).Replace('\','/')
  $lines+=((Get-FileHash $_.FullName -Algorithm SHA256).Hash.ToLower()+"  "+$rel)
}
[IO.File]::WriteAllText("$root\MANIFEST.sha256",($lines -join "`n")+"`n",$utf8)
