$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$definitionRoot = Join-Path $repoRoot 'dashboard\Projeto.SemanticModel\definition\tables'

if (-not (Test-Path -LiteralPath $definitionRoot)) {
    throw "Definicoes do modelo nao encontradas em: $definitionRoot"
}

$dataDir = Join-Path $repoRoot 'data'
$sinanDir = Join-Path $dataDir 'sinan_zika'
$auxiliaresDir = Join-Path $dataDir 'auxiliares'
$derivadosDir = Join-Path $dataDir 'derivados'
$municipios = Join-Path $auxiliaresDir 'municipios.csv'

$requiredFiles = @(
    $municipios,
    (Join-Path $auxiliaresDir 'populacao_ibge_2025.csv'),
    (Join-Path $derivadosDir 'arboviroses_comparacao_snapshot.csv'),
    (Join-Path $derivadosDir 'tendencia_zika_uf.csv'),
    (Join-Path $derivadosDir 'zika_mensal_uf_24m.csv')
)

16..26 | ForEach-Object {
    $requiredFiles += Join-Path $sinanDir ("ZIKABR{0:D2}.csv" -f $_)
}

$missingFiles = @($requiredFiles | Where-Object { -not (Test-Path -LiteralPath $_) })
if ($missingFiles.Count -gt 0) {
    throw "Bases ausentes. Extraia o ZIP diretamente dentro da pasta data antes de executar o script:`n - $($missingFiles -join "`n - ")"
}

$targets = @{
    'fdata.tmdl' = @{
        Pattern = 'Folder\.Files\("[^"]*\\data(?:\\sinan_zika)?"\)'
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
$alreadyConfigured = 0

foreach ($entry in $targets.GetEnumerator()) {
    $file = Join-Path $definitionRoot $entry.Key
    if (-not (Test-Path -LiteralPath $file)) {
        throw "Arquivo esperado nao encontrado: $file"
    }

    $original = [System.IO.File]::ReadAllText($file)
    $updated = [regex]::Replace($original, $entry.Value.Pattern, $entry.Value.Replacement)

    if ($updated -eq $original) {
        if ($original.Contains($entry.Value.Replacement)) {
            $alreadyConfigured++
            Write-Host "Ja configurado: $($entry.Key)"
            continue
        }

        throw "Padrao de caminho nao encontrado em: $($entry.Key)"
    }

    [System.IO.File]::WriteAllText($file, $updated, $utf8NoBom)
    $changed++
    Write-Host "Atualizado: $($entry.Key)"
}

Write-Host ""
Write-Host "Caminho base configurado: $repoRoot"
Write-Host "Arquivos alterados: $changed"
Write-Host "Arquivos ja configurados: $alreadyConfigured"
Write-Host "Abra dashboard\Projeto.pbip no Power BI Desktop e selecione Atualizar."
