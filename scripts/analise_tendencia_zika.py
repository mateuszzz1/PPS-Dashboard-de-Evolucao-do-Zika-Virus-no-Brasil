"""Calcula a tendência mensal de casos prováveis de Zika por UF.

Entrada: agregado mensal produzido pelo modelo Power BI.
Saída: uma linha por UF com regressão linear dos últimos 24 meses.
"""

from __future__ import annotations

import argparse
from pathlib import Path

import numpy as np
import pandas as pd


def calcular_tendencia(input_csv: Path, output_csv: Path) -> pd.DataFrame:
    dados = pd.read_csv(input_csv, dtype={"Cod_UF": "string"})
    dados["Data"] = pd.to_datetime(
        dados["Ano"].astype(str) + "-" + dados["Mes"].astype(str).str.zfill(2) + "-01"
    )

    periodo_final = dados["Data"].max()
    meses = pd.date_range(end=periodo_final, periods=24, freq="MS")
    resultados: list[dict[str, object]] = []

    for cod_uf in sorted(dados["Cod_UF"].dropna().unique()):
        serie = (
            dados.loc[dados["Cod_UF"] == cod_uf, ["Data", "Casos"]]
            .set_index("Data")
            .reindex(meses, fill_value=0)
        )
        y = serie["Casos"].astype(float).to_numpy()
        x = np.arange(len(y), dtype=float)
        inclinacao, intercepto = np.polyfit(x, y, 1)
        previsto = inclinacao * x + intercepto
        soma_quadrados = float(np.sum((y - y.mean()) ** 2))
        r2 = 0.0 if soma_quadrados == 0 else 1 - float(np.sum((y - previsto) ** 2)) / soma_quadrados
        media = float(y.mean())
        variacao_relativa = 0.0 if media == 0 else float(inclinacao / media)

        if variacao_relativa > 0.02:
            tendencia = "Crescente"
        elif variacao_relativa < -0.02:
            tendencia = "Decrescente"
        else:
            tendencia = "Estável"

        resultados.append(
            {
                "Cod_UF": cod_uf,
                "PeriodoInicial": meses.min().date().isoformat(),
                "PeriodoFinal": meses.max().date().isoformat(),
                "Meses": len(meses),
                "CasosPeriodo": int(y.sum()),
                "MediaMensal": round(media, 4),
                "InclinacaoMensal": round(float(inclinacao), 6),
                "VariacaoMensalRelativa": round(variacao_relativa, 6),
                "R2": round(max(0.0, min(1.0, r2)), 6),
                "Tendencia": tendencia,
            }
        )

    resultado = pd.DataFrame(resultados)
    output_csv.parent.mkdir(parents=True, exist_ok=True)
    resultado.to_csv(output_csv, index=False, encoding="utf-8-sig")
    return resultado


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("input_csv", type=Path)
    parser.add_argument("output_csv", type=Path)
    args = parser.parse_args()
    resultado = calcular_tendencia(args.input_csv, args.output_csv)
    print(f"UFs analisadas: {len(resultado)}")
    print(f"Período: {resultado['PeriodoInicial'].min()} a {resultado['PeriodoFinal'].max()}")
    print(f"Saída: {args.output_csv}")


if __name__ == "__main__":
    main()
