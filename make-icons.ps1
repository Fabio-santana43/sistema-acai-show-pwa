# make-icons.ps1
# Redimensiona 'Logo Açai show.png' para icon-192.png e icon-512.png
# Uso: execute na pasta do projeto: .\make-icons.ps1

$source = "Logo Açai show.png"
$dest192 = "icon-192.png"
$dest512 = "icon-512.png"

if (-not (Test-Path $source)) {
  Write-Host "Arquivo de origem não encontrado: $source"
  Write-Host "Coloque sua logo (PNG) com o nome 'Logo Açai show.png' na mesma pasta e execute novamente." -ForegroundColor Yellow
  exit 1
}

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
} catch {
  Write-Host "Erro ao gerar ícones: $_" -ForegroundColor Red
} finally {
  $img.Dispose()
}

Write-Host "Concluído. Agora você pode rodar o servidor para testar o PWA." -ForegroundColor Green
