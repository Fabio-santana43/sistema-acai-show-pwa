# serve-and-open.ps1
# Gera ícones (chama make-icons.ps1) e inicia um servidor HTTP simples em http://localhost:8000
# Uso (PowerShell):
#   powershell -ExecutionPolicy Bypass -File .\serve-and-open.ps1

# Passo 1: gerar ícones (se a logo existir)
if (Test-Path "./make-icons.ps1") {
  Write-Host "Gerando ícones (se necessário)..."
  try { & .\make-icons.ps1 } catch { Write-Host "Falha ao gerar ícones: $_" -ForegroundColor Red }
}

# Função para obter Content-Type simples
function Get-ContentType([string]$ext) {
  switch ($ext.ToLower()) {
    '.html' { 'text/html' }
    '.htm' { 'text/html' }
    '.js' { 'application/javascript' }
    '.json' { 'application/json' }
    '.css' { 'text/css' }
    '.png' { 'image/png' }
    '.svg' { 'image/svg+xml' }
    '.jpg' { 'image/jpeg' }
    '.jpeg' { 'image/jpeg' }
    '.gif' { 'image/gif' }
    default { 'application/octet-stream' }
  }
}

$prefix = 'http://localhost:8000/'
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($prefix)
$listener.Start()
Write-Host "Servidor rodando em $prefix" -ForegroundColor Green

# Abre o navegador na página principal
Start-Process "$prefix`\Sistema-completo-fabio-certo.html"

try {
  while ($listener.IsListening) {
    $context = $listener.GetContext()
    $req = $context.Request
    $path = $req.Url.LocalPath.TrimStart('/')
    if ([string]::IsNullOrEmpty($path)) { $path = 'Sistema-completo-fabio-certo.html' }
    # prevenir traversal
    $path = $path -replace '\\','/'
    $full = Join-Path (Get-Location) $path
    if (-not (Test-Path $full)) {
      # fallback to index
      $full = Join-Path (Get-Location) 'Sistema-completo-fabio-certo.html'
    }
    $ext = [System.IO.Path]::GetExtension($full)
    $bytes = [System.IO.File]::ReadAllBytes($full)
    $context.Response.ContentType = Get-ContentType $ext
    $context.Response.ContentLength64 = $bytes.Length
    $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    $context.Response.OutputStream.Close()
  }
} finally {
  $listener.Stop()
  $listener.Close()
}
