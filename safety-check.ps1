<#
 safety-check.ps1
 Script leve para inspecionar o workspace em busca de padrões potencialmente perigosos.
 Ele NÃO executa nada — apenas faz leitura e relatório.

 Uso:
   powershell -NoProfile -ExecutionPolicy Bypass -File .\safety-check.ps1

 O script procura por palavras-chave como: Remove-Item, Stop-Process, Start-Process, netsh,
 Set-ExecutionPolicy, Invoke-WebRequest (com URL externa), e exibe onde aparecem.
#>

Write-Host "Iniciando verificação de segurança (apenas leitura)..." -ForegroundColor Cyan

$patterns = @( 
  'Remove-Item',
  'Stop-Process',
  'Start-Process',
  'netsh',
  'Set-ExecutionPolicy',
  'Invoke-WebRequest',
  'DownloadFile',
  'Add-Type',
  'Start-Job',
  'Register-ScheduledTask'
)

$files = Get-ChildItem -Path (Get-Location) -Recurse -File -Include *.ps1,*.js,*.json,*.html,*.css -ErrorAction SilentlyContinue

$report = @()

foreach ($f in $files) {
  $content = Get-Content -Path $f.FullName -ErrorAction SilentlyContinue
  for ($i = 0; $i -lt $content.Length; $i++) {
    $line = $content[$i]
    foreach ($p in $patterns) {
      if ($line -match [regex]::Escape($p)) {
        $report += [PSCustomObject]@{
          File = $f.FullName
          LineNumber = $i + 1
          Pattern = $p
          Line = $line.Trim()
        }
      }
    }
    # detectar Invoke-WebRequest/DownloadFile com URL externo
    if ($line -match 'Invoke-WebRequest|DownloadFile') {
      if ($line -match "https?://") {
        $report += [PSCustomObject]@{
          File = $f.FullName
          LineNumber = $i + 1
          Pattern = 'External-Download'
          Line = $line.Trim()
        }
      }
    }
  }
}

if ($report.Count -eq 0) {
  Write-Host "Nenhum padrão potencialmente perigoso encontrado nos arquivos verificados." -ForegroundColor Green
  exit 0
}

Write-Host "Padrões potencialmente perigosos encontrados:" -ForegroundColor Yellow
$report | Format-Table -AutoSize

Write-Host "\nRecomendações:" -ForegroundColor Cyan
Write-Host "- Revise manualmente cada ocorrência listada antes de executar qualquer script." -ForegroundColor White
Write-Host "- Faça um backup da pasta do projeto antes de executar scripts que alterem arquivos ou criem processos." -ForegroundColor White
Write-Host "- Se quiser, me peça para revisar detalhadamente qualquer arquivo listado (posso explicar linha a linha)." -ForegroundColor White

exit 0
