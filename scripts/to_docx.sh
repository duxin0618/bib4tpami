#!/usr/bin/env bash
# 把参考文献列表（每行一条，[1] 开头，支持 *斜体*）转成 .docx
# 用法: to_docx.sh <refs.txt> <out.docx>
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "usage: $(basename "$0") <refs.txt> <out.docx>" >&2
  exit 2
fi

IN="$1"
OUT="$2"
[ -f "$IN" ] || { echo "ERROR: 找不到 $IN" >&2; exit 2; }

tmpdir="$(mktemp -d /tmp/mybib4tpami.XXXXXX)"
trap 'rm -rf "$tmpdir"' EXIT

if command -v textutil >/dev/null 2>&1; then
  rtf="$tmpdir/refs.rtf"
  {
    printf '{\\rtf1\\ansi\\ansicpg1252\\deff0\n'
    printf '{\\fonttbl{\\f0\\froman Times New Roman;}}\n'
    printf '\\f0\\fs20\n'
    while IFS= read -r line || [ -n "$line" ]; do
      [ -z "$line" ] && continue
      # 反斜杠/花括号转义 → 非 ASCII 转 RTF \uNNNN?（否则 textutil 会丢整段）→ *斜体* 转 {\i ...}
      esc=$(printf '%s' "$line" | perl -CSD -pe '
        s/\\/\\\\/g;
        s/\{/\\{/g;
        s/\}/\\}/g;
        s/([^\x00-\x7F])/sprintf("\\u%d?", ord($1) - (ord($1) > 32767 ? 65536 : 0))/ge;
        s/\*([^*]+)\*/{\\i $1}/g;
      ')
      printf '\\pard\\li360\\fi-360\\sa60 %s\\par\n' "$esc"
    done < "$IN"
    printf '}\n'
  } > "$rtf"
  textutil -convert docx -output "$OUT" "$rtf"

elif command -v pandoc >/dev/null 2>&1; then
  md="$tmpdir/refs.md"
  : > "$md"
  while IFS= read -r line || [ -n "$line" ]; do
    [ -z "$line" ] && continue
    printf '%s\n\n' "$line" >> "$md"
  done < "$IN"
  pandoc "$md" -o "$OUT"

else
  echo "ERROR: 生成 .docx 需要 textutil（macOS）或 pandoc。" >&2
  echo "       可改为输出 Markdown / 纯文本，或先安装 pandoc。" >&2
  exit 3
fi

[ -f "$OUT" ] && echo "OK: $OUT"
