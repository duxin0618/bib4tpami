#!/usr/bin/env bash
# 静态校验 .bib 是否符合 IEEEtran.bst 的写法要求
# 用法: validate_bib.sh <file.bib>
# 退出码: 0 = 无 error（可有 warning）；1 = 有 error；2 = 用法错误
set -uo pipefail

if [ $# -lt 1 ] || [ ! -f "$1" ]; then
  echo "usage: $(basename "$0") <file.bib>" >&2
  exit 2
fi

FILE="$1"
errors=0
warnings=0

err() { printf 'ERROR  %s\n' "$*"; errors=$((errors + 1)); }
warn() { printf 'WARN   %s\n' "$*"; warnings=$((warnings + 1)); }

echo "== 校验 $FILE =="

# 1. 条目数
n_entries=$(grep -cE '^[[:space:]]*@[A-Za-z]+[[:space:]]*\{' "$FILE" || true)
echo "-- 条目数: $n_entries"
[ "$n_entries" -gt 0 ] || err "没有解析到任何 @entry"

# 2. 非 ASCII 字符（Unicode 连字符、弯引号、全角空格等）
nonascii=$(LC_ALL=C grep -n '[^ -~	]' "$FILE" || true)
if [ -n "$nonascii" ]; then
  echo "$nonascii" | while IFS= read -r line; do
    printf 'ERROR  非 ASCII 字符: %s\n' "$line"
  done
  errors=$((errors + $(printf '%s\n' "$nonascii" | wc -l | tr -d ' ')))
fi

# 3. 禁用写法：全称会议名 / 缩写括号 / arXiv preprint
banned=$(grep -niE 'Proceedings of|Conference on|arXiv preprint|\((NeurIPS|ICML|ICLR|AAAI|IJCAI|KDD|CVPR|ICCV|ECCV)\)' "$FILE" || true)
if [ -n "$banned" ]; then
  echo "$banned" | while IFS= read -r line; do
    printf 'ERROR  禁用写法: %s\n' "$line"
  done
  errors=$((errors + $(printf '%s\n' "$banned" | wc -l | tr -d ' ')))
fi

# 4. pages 字段：页码范围必须用 ASCII "--"
while IFS= read -r line; do
  [ -z "$line" ] && continue
  value=$(printf '%s' "$line" | sed -E 's/.*\{([^}]*)\}.*/\1/' | tr -d ' ')
  if printf '%s' "$value" | grep -qE '^[0-9]+-[0-9]+$'; then
    err "pages 用了单短横（应为 ASCII \"--\"）: $line"
  fi
done < <(grep -nE '^[[:space:]]*pages[[:space:]]*=' "$FILE" || true)

# 5. 重复 key
dup=$(grep -oE '^[[:space:]]*@[A-Za-z]+[[:space:]]*\{[^,]+' "$FILE" \
      | sed -E 's/.*\{//; s/[[:space:]]+$//' | sort | uniq -d || true)
if [ -n "$dup" ]; then
  echo "$dup" | while IFS= read -r k; do printf 'ERROR  重复 cite key: %s\n' "$k"; done
  errors=$((errors + $(printf '%s\n' "$dup" | wc -l | tr -d ' ')))
fi

# 6. 花括号配平（全文）
open=$(tr -cd '{' < "$FILE" | wc -c | tr -d ' ')
close=$(tr -cd '}' < "$FILE" | wc -c | tr -d ' ')
[ "$open" -eq "$close" ] || err "花括号不配平: { = $open, } = $close"

# 7. 逐条必填字段
field_report=$(awk '
function flush(   why) {
  if (buf == "") return
  why = ""
  if (buf !~ /title[ \t]*=/)   why = why " 缺 title;"
  if (buf !~ /year[ \t]*=/)    why = why " 缺 year;"
  if (etype == "article") {
    if (buf !~ /author[ \t]*=/)  why = why " 缺 author;"
    if (buf !~ /journal[ \t]*=/) why = why " 缺 journal;"
  } else if (etype == "inproceedings" || etype == "conference") {
    if (buf !~ /author[ \t]*=/)    why = why " 缺 author;"
    if (buf !~ /booktitle[ \t]*=/) why = why " 缺 booktitle;"
    if (buf !~ /pages[ \t]*=/)     why = why " 缺 pages（ICLR 等无页码可忽略）;"
  } else if (etype == "book") {
    if (buf !~ /publisher[ \t]*=/) why = why " 缺 publisher;"
    if (buf !~ /address[ \t]*=/)   why = why " 缺 address;"
  } else if (etype == "misc") {
    if (buf !~ /note[ \t]*=/ && buf !~ /howpublished[ \t]*=/) why = why " 缺 note/howpublished;"
  }
  if (why != "") printf "WARN   条目 %-28s %s\n", key, why
  buf = ""
}

/^[[:space:]]*@/ {
  flush()
  etype = tolower($0)
  sub(/^[[:space:]]*@/, "", etype)
  sub(/[[:space:]]*\{.*/, "", etype)
  key = $0
  sub(/^[^\{]*\{/, "", key)
  sub(/,.*/, "", key)
  buf = $0
  next
}
{ if (buf != "") buf = buf "\n" $0 }
END { flush() }
' "$FILE")

if [ -n "$field_report" ]; then
  printf '%s\n' "$field_report"
  n_warn=$(printf '%s\n' "$field_report" | grep -c '^WARN' || true)
  warnings=$((warnings + n_warn))
fi

# 8. 汇总
echo "-- 结果: ${errors} error, ${warnings} warning"
if [ "$errors" -gt 0 ]; then
  echo "FAIL"
  exit 1
fi
echo "PASS"
exit 0
