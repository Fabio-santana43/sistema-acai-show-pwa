# make-icons-from-logo.ps1
# Procura por um arquivo PNG com 'logo' no nome e gera icon-192.png e icon-512.png
$cwd = Get-Location
$logo = Get-ChildItem -Path $cwd -Filter '*logo*.png' -File -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $logo) {
  Write-Host "Nenhum arquivo 'logo*.png' encontrado na pasta: $cwd" -ForegroundColor Yellow
  exit 1
}
$source = $logo.FullName
$dest192 = Join-Path $cwd 'icon-192.png'
$dest512 = Join-Path $cwd 'icon-512.png'

Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile($source)

function Save-Resized($img, $width, $height, $dest) {
  $thumb = New-Object System.Drawing.Bitmap $width, $height
  $g = [System.Drawing.Graphics]::FromImage($thumb)
  $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $g.DrawImage($img, 0, 0, $width, $height)
  $thumb.Save($dest, [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose()
  $thumb.Dispose()
  Write-Host "Gerado: $dest"
}

try {
  Save-Resized $img 192 192 $dest192
  Save-Resized $img 512 512 $dest512
  Write-Host "Ícones gerados com sucesso." -ForegroundColor Green
} catch {
  Write-Host "Erro ao gerar ícones: $_" -ForegroundColor Red
  exit 1
} finally {
  $img.Dispose()
}
