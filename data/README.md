# Dados do projeto

## Organização

```text
data/
├── auxiliares/
│   ├── municipios.csv
│   └── populacao_ibge_2025.csv
├── derivados/
│   ├── arboviroses_comparacao_snapshot.csv
│   ├── tendencia_zika_uf.csv
│   └── zika_mensal_uf_24m.csv
└── sinan_zika/
    └── ZIKABR16.csv ... ZIKABR26.csv
```

### `auxiliares/`

- `municipios.csv`: normalização de códigos de município e UF;
- `populacao_ibge_2025.csv`: população residente por UF utilizada como denominador da incidência.

### `derivados/`

- `arboviroses_comparacao_snapshot.csv`: agregado mensal usado para comparar Zika, Chikungunya e Febre Amarela;
- `zika_mensal_uf_24m.csv`: agregado mensal de entrada para a análise em Python;
- `tendencia_zika_uf.csv`: saída da regressão linear por UF.

Esses três arquivos são produtos do processamento do projeto, não fontes externas independentes.

## Arquivos não versionados

Os microdados `ZIKABR16.csv` a `ZIKABR26.csv` devem ser baixados do conjunto oficial:

https://dadosabertos.saude.gov.br/dataset/arboviroses-zika-virus

Coloque todos os 11 arquivos em `data/sinan_zika/`, mantendo os nomes originais. O `.gitignore` impede que eles sejam enviados ao GitHub.

## Definição utilizada

Casos prováveis correspondem a todas as notificações suspeitas, exceto as classificadas como descartadas. As análises geográficas utilizam a UF e o município de residência.

## Atualização

1. Substitua o arquivo anual mais recente em `data/sinan_zika/`.
2. Execute `scripts/configurar_caminhos.ps1` se a pasta do repositório tiver mudado.
3. Se necessário, recalcule `data/derivados/tendencia_zika_uf.csv` com o script Python.
4. Abra `dashboard/Projeto.pbip` e selecione **Atualizar**.
