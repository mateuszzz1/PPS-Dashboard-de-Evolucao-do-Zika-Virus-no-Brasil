# Validação da entrega final

Data da validação: **08/08/2026**  
Data de corte encontrada nos microdados: **31/07/2026**

## Modelo

- 8 tabelas;
- 6 relacionamentos muitos-para-um e unidirecionais;
- 48 medidas DAX centralizadas;
- 5 páginas no relatório;
- mapa personalizado incluído no diretório `CustomVisuals` do PBIP.

## Indicadores reconciliados

| Indicador | Valor |
|---|---:|
| Notificações | 556.082 |
| Confirmados | 179.461 |
| Descartados | 260.673 |
| Casos prováveis YTD 2026 | 1.897 |
| Casos prováveis no mesmo período de 2025 | 2.824 |
| Óbitos pelo agravo no período de 2026 | 4 |
| UFs na análise de tendência | 27 |

## Verificações realizadas

- abertura do PBIP no Power BI Desktop;
- ausência de alterações não salvas;
- atualização do arquivo `ZIKABR26.csv` para 10.033 linhas;
- reconciliação do total consolidado;
- verificação dos filtros Ano, Estado (UF) e Doença;
- conferência do card de letalidade;
- inspeção visual das cinco páginas;
- execução das células analíticas do relatório final contra os arquivos atuais.

## Observação de qualidade

Dos quatro registros de 2026 com evolução “Óbito pelo agravo”, três estão confirmados e um está classificado como descartado. A medida atual do dashboard contabiliza os quatro registros e usa casos prováveis como denominador, resultando em 0,211%. O relatório técnico apresenta também a alternativa restrita aos não descartados.
