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

## Download do pacote de dados

Todas as bases necessárias foram reunidas em um único pacote:

- [Download — bases do Dashboard de Zika (Google Drive)](https://drive.google.com/uc?export=download&id=1TgI6bbyCCGLmpjxKTdG3yV2eWcsXDQpA)

Após baixar e extrair o ZIP, copie as pastas `auxiliares`, `derivados` e `sinan_zika` para `data/`. A estrutura final deve conter, entre outros arquivos, `data/sinan_zika/ZIKABR16.csv` até `data/sinan_zika/ZIKABR26.csv`.

Os microdados anuais não são versionados no GitHub. Sua fonte oficial é o conjunto [SINAN/Vírus Zika — Portal de Dados Abertos do SUS](https://dadosabertos.saude.gov.br/dataset/arboviroses-zika-virus), e o `.gitignore` impede que os arquivos sejam enviados acidentalmente ao repositório.

## Definição utilizada

Casos prováveis correspondem a todas as notificações suspeitas, exceto as classificadas como descartadas. As análises geográficas utilizam a UF e o município de residência.

## Atualização

1. Substitua o arquivo anual mais recente em `data/sinan_zika/`.
2. Execute `scripts/configurar_caminhos.ps1` se a pasta do repositório tiver mudado.
3. Se necessário, recalcule `data/derivados/tendencia_zika_uf.csv` com o script Python.
4. Abra `dashboard/Projeto.pbip` e selecione **Atualizar**.
