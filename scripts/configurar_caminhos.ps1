$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$definitionRoot = Join-Path $repoRoot 'dashboard\Projeto.SemanticModel\definition\tables'

if (-not (Test-Path -LiteralPath $definitionRoot)) {
    throw "Definições do modelo não encontradas em: $definitionRoot"
}

$dataDir = Join-Path $repoRoot 'data'
$sinanDir = Join-Path $dataDir 'sinan_zika'
$auxiliaresDir = Join-Path $dataDir 'auxiliares'
$derivadosDir = Join-Path $dataDir 'derivados'
$municipios = Join-Path $auxiliaresDir 'municipios.csv'

$targets = @{
    'fdata.tmdl' = @{
        Pattern = 'Folder\.Files\("[^"]*\\data"\)'
        Replacement = 'Folder.Files("' + $sinanDir + '")'
    }
    'Arboviroses.tmdl' = @{
        Pattern = 'File\.Contents\("[^"]*\\arboviroses_comparacao_snapshot\.csv"\)'
        Replacement = 'File.Contents("' + (Join-Path $derivadosDir 'arboviroses_comparacao_snapshot.csv') + '")'
    }
    'Populacao.tmdl' = @{
        Pattern = 'File\.Contents\("[^"]*\\populacao_ibge_2025\.csv"\)'
        Replacement = 'File.Contents("' + (Join-Path $auxiliaresDir 'populacao_ibge_2025.csv') + '")'
    }
    'TendenciaPython.tmdl' = @{
        Pattern = 'File\.Contents\("[^"]*\\tendencia_zika_uf\.csv"\)'
        Replacement = 'File.Contents("' + (Join-Path $derivadosDir 'tendencia_zika_uf.csv') + '")'
    }
    'dMunicipalities.tmdl' = @{
        Pattern = 'File\.Contents\("[^"]*\\municipios\.csv"\)'
        Replacement = 'File.Contents("' + $municipios + '")'
    }
}

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
$changed = 0

foreach ($entry in $targets.GetEnumerator()) {
    $file = Join-Path $definitionRoot $entry.Key
    if (-not (Test-Path -LiteralPath $file)) {
        throw "Arquivo esperado não encontrado: $file"
    }

    $original = [System.IO.File]::ReadAllText($file)
    $updated = [regex]::Replace($original, $entry.Value.Pattern, $entry.Value.Replacement)

    if ($updated -eq $original) {
        Write-Warning "Nenhuma alteração necessária ou padrão não encontrado: $($entry.Key)"
        continue
    }

    [System.IO.File]::WriteAllText($file, $updated, $utf8NoBom)
    $changed++
    Write-Host "Atualizado: $($entry.Key)"
}

Write-Host ""
Write-Host "Caminho base configurado: $repoRoot"
Write-Host "Arquivos atualizados: $changed"
Write-Host "Abra dashboard\Projeto.pbip no Power BI Desktop e selecione Atualizar."
