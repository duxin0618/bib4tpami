#!/usr/bin/env bash
# 检查渲染后的参考文献文本是否符合 IEEE 格式
# 用法: check_style.sh <refs.txt>   （每条以 [n] 开头，可跨行）
set -uo pipefail

if [ $# -lt 1 ] || [ ! -f "$1" ]; then
  echo "usage: $(basename "$0") <refs.txt>" >&2
  exit 2
fi

FILE="$1"
echo "== 检查 $FILE =="

report=$(awk '
function flush(   label, hit) {
  if (item == "") return
  label = idx
  # 1. 年份
  if (item !~ /(19|20)[0-9][0-9]/)
    printf "ERROR  %s 缺年份\n", label
  # 3. 全称会议名 / arXiv preprint
  if (item ~ /Proceedings of|Conference on|arXiv preprint/)
    printf "ERROR  %s 出现全称会议名或 arXiv preprint\n", label
  # 4. 括号式会议缩写
  if (item ~ /\((NeurIPS|ICML|ICLR|AAAI|IJCAI|KDD|CVPR|ICCV|ECCV)\)/)
    printf "ERROR  %s 会议名带了缩写括号\n", label
  # 5. 单短横页码范围
  if (item ~ /[0-9]+-[0-9]+/)
    printf "ERROR  %s 页码出现单短横（应为 en dash）\n", label
  # 6. 范围却用了单页标记（"p. 12–34" 应为 "pp. 12–34"；"pp." 不误报）
  if (item ~ /(^|[^A-Za-z])p\. [0-9]+[ \t]*[–—-][ \t]*[0-9]+/)
    printf "ERROR  %s 页码范围用了 \"p.\"（应为 \"pp.\"）\n", label
  # 7. 缩写被误小写
  if (item ~ /(^|[^A-Za-z])(mopo|morel|combo|d4rl|neorl|alvinn|meddreamer|ood|rl|q-learning)([^A-Za-z]|$)/)
    printf "WARN   %s 可能有被误小写的缩略词\n", label
  count++
  item = ""
}

/^[[:space:]]*\[[0-9]+\]/ {
  flush()
  match($0, /\[[0-9]+\]/)
  idx = substr($0, RSTART, RLENGTH)
  item = $0
  next
}
{ if (item != "") item = item " " $0 }
END {
  flush()
  printf "-- 共解析 %d 条\n", count
}
' "$FILE" || true)

if [ -n "$report" ]; then
  printf '%s\n' "$report"
fi
n_err=$(printf '%s\n' "$report" | grep -c '^ERROR' || true)
n_warn=$(printf '%s\n' "$report" | grep -c '^WARN' || true)
n_err=${n_err:-0}; n_warn=${n_warn:-0}

echo "-- 结果: ${n_err} error, ${n_warn} warning"
echo "-- 提示: ERROR 需修正；WARN 请人工确认"
if [ "$n_err" -gt 0 ]; then
  echo "FAIL"
  exit 1
fi
echo "PASS"
exit 0
