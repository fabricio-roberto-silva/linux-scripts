#!/usr/bin/env bash
# check-disk-usage.sh
# Avisa quando algum filesystem passa do limite de uso (padrão: 80%).
# Uso: ./check-disk-usage.sh [limite_percentual]
# Saída: código 0 se tudo OK, 1 se algum filesystem passou do limite.

set -euo pipefail

THRESHOLD="${1:-80}"
status=0

while read -r usage mount; do
  pct="${usage%\%}"
  if (( pct >= THRESHOLD )); then
    echo "WARNING: ${mount} em ${pct}% (limite ${THRESHOLD}%)"
    status=1
  fi
done < <(df -P -x tmpfs -x devtmpfs | awk 'NR>1 {print $5, $6}')

if (( status == 0 )); then
  echo "OK: todos os filesystems abaixo de ${THRESHOLD}%"
fi

exit "$status"
