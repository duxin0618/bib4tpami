#!/usr/bin/env bash
# 从 .bib / .docx / .doc / .rtf / .odt / .pdf / .tex / 纯文本中抽取文本
# 用法: extract_text.sh <file>
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "usage: $(basename "$0") <file>" >&2
  exit 2
fi

file="$1"
script_dir="$(cd "$(dirname "$0")" && pwd)"

[ -f "$file" ] || { echo "ERROR: 文件不存在: $file" >&2; exit 2; }

base="$(basename "$file")"
ext="$(printf '%s' "${base##*.}" | tr '[:upper:]' '[:lower:]')"

case "$ext" in
  bib)
    cat "$file"
    ;;

  tex)
    # 抽取 thebibliography 环境；若没有该环境，退化为提取全部 \bibitem
    if grep -q '\\begin{thebibliography}' "$file"; then
      sed -n '/\\begin{thebibliography}/,/\\end{thebibliography}/p' "$file"
    elif grep -q '\\bibitem' "$file"; then
      awk '/\\bibitem/{f=1} f' "$file"
    else
      echo "ERROR: 该 .tex 没有内联参考文献（用的是 \\bibliography{...}）。请直接提供被引用的 .bib 文件。" >&2
      exit 4
    fi
    ;;

  docx|doc|odt|rtf|html|htm|webarchive)
    if command -v textutil >/dev/null 2>&1; then
      textutil -convert txt -stdout "$file"
    elif command -v pandoc >/dev/null 2>&1; then
      pandoc -t plain "$file"
    else
      echo "ERROR: 读取 $ext 需要 macOS 的 textutil 或 pandoc。可先手动另存为 .txt 再重试。" >&2
      exit 3
    fi
    ;;

  pdf)
    if command -v pdftotext >/dev/null 2>&1; then
      pdftotext -layout "$file" -
    elif command -v swift >/dev/null 2>&1 && [ -f "$script_dir/pdftext.swift" ]; then
      swift "$script_dir/pdftext.swift" "$file" 2>/dev/null
    elif python3 -c 'import pypdf' >/dev/null 2>&1; then
      python3 - "$file" <<'PY'
import sys
from pypdf import PdfReader
reader = PdfReader(sys.argv[1])
for i, page in enumerate(reader.pages):
    print(f"===PAGE {i+1}===")
    print(page.extract_text() or "")
PY
    else
      echo "ERROR: 没有可用的 PDF 抽取工具（pdftotext / swift / pypdf 均不可用）。请把参考文献粘贴成文本。" >&2
      exit 3
    fi
    ;;

  txt|md|markdown|*)
    cat "$file"
    ;;
esac
