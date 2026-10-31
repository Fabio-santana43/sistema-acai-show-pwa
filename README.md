[Relatorio-Qa-Acai-Show-Fabio-Santana.pdf](https://github.com/user-attachments/files/34223750/Relatorio-Qa-Acai-Show-Fabio-Santana.pdf)
# 🍧 Açaí Show - Sistema de Comandas PWA
Sistema de gestão de comandas para loja de Açaí, desenvolvido com HTML/JS e funcionalidade PWA (Offline). 
Projeto real usado na minha loja em Taguatinga, DF - Taguatinga.

<img width="1904" height="1030" alt="Captura de tela 2026-10-30 000713" src="https://github.com/user-attachments/assets/337b3425-d207-4cdb-add3-adc495919c4d" /><img width="1907" height="1031" alt="Captura de tela 2026-10-30 000929" src="https://github.com/user-attachments/assets/cea8f14b-b985-4895-96c6-2dfeb114cb34" />
<img width="1906" height="1029" alt="Captura de tela 2026-10-30 000858" src="https://github.com/user-attachments/assets/054b5a24-ecc7-466b-8f87-421fc58a31f9" />
<img width="1904" height="1030" alt="Captura de tela 2026-10-30 000813" src="https://github.com/user-attachments/assets/48c8a347-bcf0-457d-9a9d-2ecf7913f76c" />
<img width="1893" height="1006" alt="Captura de tela 2026-10-30 000739" src="https://github.com/user-attachments/assets/725ee50c-51be-4811-8c96-ec1a1fb0bc48" />
# Açaí Show - Sistema de Comanda PWA

Sistema PWA offline para comandas de açaí, com manifest.json + sw.js, demo live.

**Demo:** https://fabio-santana43.github.io/sistema-acai-show-pwa/
**【entity-GitHub¦canonical_name=GitHub】:** https://github.com/Fabio-santana43/sistema-acai-show-pwa

## Funcionalidades
- Identificação da comanda
- Escolha tamanho/base: Açaí 200/300/500/700ml, Promoção, Casadinho, Cupuaçu
- Complementos, Coberturas, Adicionais pagos
- Resumo da Comanda com Limpar/Imprimir/Fechar Caixa/Abrir Caixa
- Histórico de Vendas + Fechamento de Caixa com PDF
- PWA offline - funciona sem internet

## Testes de QA - 6 testes manuais passando ✅

✅ Validação, soma infinita, bloqueio negativo, confirmações e tratamento de erro
Testado manualmente - Pronto para automação com Cypress

### Casos de Teste

**CT01 - Validar comanda vazia**
- Tentar adicionar comanda sem tamanho/base
- Esperado: Mensagem "Selecione um tamanho/base ou adicione um produto."
- Status: ✅ PASSOU

**CT02 - Cálculo quantidade alta (estresse)**
- 20x Chantilly (R$2) + 20x Paçoca (R$2) + 10x Nutella (R$4) + Copo 700ml R$20
- Esperado: R$140,00
- Status: ✅ PASSOU - Soma infinita segura

**CT02.1 - Bloqueio valor negativo**
- Clicar - quando está em 0
- Esperado: Não ir para -1, travar em 0/1
- Status: ✅ PASSOU

**CT03.2 - Confirmação limpar comanda**
- Clicar Limpar Comanda
- Esperado: "Tem certeza que deseja limpar toda a comanda?"
- Status: ✅ PASSOU

**CT03.3a - Tratamento histórico vazio**
- Ver histórico sem venda registrada
- Esperado: "Nenhuma venda registrada hoje."
- Status: ✅ PASSOU - Tratamento de erro

**CT03.3b - Fechamento de caixa + PDF**
- Fechar caixa com R$16,00
- Esperado: "Total de vendas do dia: R$16,00" + "Caixa encerrado com sucesso!" + PDF + reset R$0,00
- Status: ✅ PASSOU

### Próximos Passos
- CT04 - PWA Offline: Testar sem wifi (manifest.json + sw.js)
- CT05 - Cypress: Automatizar CT01-CT03
- CT06 - Conversão €: R$ para € para food truck Lisboa/Porto

