# Como instalar e testar o PWA (Açaí Show)

### Passo a passo rápido (Windows)

1) Verifique os arquivos na pasta do projeto:
   - Sistema-completo-fabio-certo.html
   - manifest.json
   - sw.js
   - icon-192.svg (adicionado)
   - icon-512.svg (adicionado)
   - logo-acai.png (se você adicionou este PNG, ele também será usado como ícone de app)

2) Servir localmente via Python (recomendado) — abra PowerShell na pasta do projeto:

```pwsh
# se tiver Python 3
python -m http.server 8000
```

3) Abra no navegador (Chrome/Edge recomendado):

http://localhost:8000/Sistema-completo-fabio-certo.html

4) Verifique se o Service Worker foi registrado:
   - Abra DevTools (F12) -> Aba Application (ou Application/Service Workers)
   - Em "Service Workers" verifique se `sw.js` está registrado e ativo.

5) Verifique o Manifest:
   - Em Application -> Manifest: confirme que o `manifest.json` foi lido e os ícones aparecem.

6) Instalar o PWA:
   - Se o navegador detectar o PWA, aparecerá um botão de "Install" na barra de endereço ou
   - No Chrome/Edge: Menu (três pontos) -> Install "AçaíShow".

7) Teste offline:
   - No DevTools -> Network, marque "Offline".
   - Recarregue a página. A página deverá carregar com os recursos em cache e os dados do LocalStorage devem estar disponíveis.

Notas importantes
- Service Worker só funciona em `http://localhost` ou em `https://` (não funciona com file://).
- Os ícones gerados são placeholders em SVG. Para um ícone mais adequado, coloque `icon-192.png` e `icon-512.png` na raiz.
   - Se você já tem um PNG (por exemplo `Logo Açai show.png`), ele será referenciado automaticamente no `manifest.json`.
   - Recomendo renomear esse arquivo para `icon-512.png` e criar uma versão `icon-192.png` para melhor compatibilidade (evita espaços e caracteres especiais no nome do arquivo).
      - Se preferir, use o script `make-icons.ps1` para gerar `icon-192.png` e `icon-512.png` a partir do arquivo `Logo Açai show.png`.
      - Para facilitar tudo junto, você pode executar `serve-and-open.ps1` que chama `make-icons.ps1`, inicia um servidor local e abre o navegador automaticamente.

   Como usar os scripts (PowerShell):

   1) Abra o PowerShell na pasta do projeto.
   2) Rode o comando (permite execução temporária de scripts):

   ```pwsh
   powershell -ExecutionPolicy Bypass -File .\serve-and-open.ps1
   ```

   Isso irá gerar icons (se sua logo `Logo Açai show.png` existir), iniciar um servidor em `http://localhost:8000` e abrir a página no navegador. A partir daí siga os passos de instalar o PWA descritos acima.
- Se o service worker não carregar alterações de arquivos HTML/JS, use DevTools -> Application -> Service Workers -> Update on reload, ou Unregister e recarregue.

Backup do histórico (export manual)
- Para criar um backup rápido, abra DevTools -> Console e cole:

```js
copy(JSON.stringify({
  comanda: localStorage.getItem('acai_comanda'),
  historico: localStorage.getItem('acai_historico'),
  caixa: localStorage.getItem('acai_caixa_status')
}, null, 2));
```

Isso copia o JSON para sua área de transferência; cole em um arquivo `.json` e salve como backup.

Se quiser, eu:
- Gero PNGs a partir desses SVGs (se preferir PNGs),
- Adiciono um modal "Como instalar" diretamente na interface,
- Crio um script PowerShell para iniciar servidor e abrir o browser automaticamente.

Me diz qual opção prefere que eu execute a seguir.
