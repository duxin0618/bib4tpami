---
name: mybib4tpami
description: 把 .bib / .docx / .pdf / .tex / 单条参考文献转换成 IEEE（TPAMI）标准引用格式，并按用户点击选择交付为 BibTeX 文件、Word 文档、Markdown 或直接输出。当用户提供参考文献文件、论文 PDF/Word、粘贴的参考文献，或提到 "IEEE 引用格式 / TPAMI 参考文献 / bib 规范化 / reference style" 时使用。
version: 1.0.0
author: dx
license: MIT
tags: [IEEE, TPAMI, Bibliography, BibTeX, Citation, Academic Writing]
---

# mybib4tpami — IEEE / TPAMI 参考文献格式化

把任意来源的文献信息，统一整理成 IEEE Reference Guide（v3.28.2025）标准格式，并按用户选择的载体交付。

**核心原则：绝不允许臆造文献信息。** 作者、页码、年份、DOI 查不到就标注 `[待核实]`，不要用"看起来合理"的数字填充。

---

## Step 0（强制）先询问交付格式

**在任何其他动作之前**，用 `AskUserQuestion` 问一次，恰好四个选项：

| 选项 | 含义 |
|---|---|
| `BibTeX 文件` | 产出 `.bib`，可直接 `\bibliography{}` |
| `Word 文档` | 产出 `.docx`，`[1] [2] …` 编号的参考文献列表 |
| `Markdown` | 产出 `.md`，编号列表 |
| `直接输出` | 直接在对话里给出编号列表 |

- 只问这一个问题，不要顺带问其它问题。
- **例外**：用户消息里已经明确说了要哪种（例如"给我一个 bib"），可直接采用并在回复开头写一句"按你指定的 BibTeX 格式交付"，不要重复问。
- **非 Claude 环境**（Codex 等没有 `AskUserQuestion` 工具时）：把同样这四个选项写成编号列表提问一次，然后停下等回复，不要自作主张替用户选。

## Step 1 识别并抽取输入

| 输入 | 做法 |
|---|---|
| `.bib` | 直接读；**保留所有 cite key 和未引用条目**，不要删条目 |
| `.docx / .doc / .rtf / .odt` | `scripts/extract_text.sh` |
| `.pdf` | `scripts/extract_text.sh`（pdftotext → swift PDFKit → pypdf 自动降级） |
| `.tex` | `scripts/extract_text.sh`（抽取 `thebibliography` 内的 `\bibitem`） |
| 纯文本 / 单条参考文献 | 直接用 |

若输入是**整篇论文**（不是纯参考文献表）：只取 `REFERENCES` / `参考文献` 标题之后到 `作者简介` / `Biography` / `Appendix` 之前的部分。

PDF/Word 抽出的文本有两个坑，拼回条目时要处理：
- 行尾断词（`off-` 换行 `policy`）：只有当 `-` 后接小写字母时才是断词，合并；`Model-based` 这类原本带连字符的复合词要按原文判断，必要时回原文核对。
- 页眉页脚、页码、`===PAGE n===` 标记一律剔除。

## Step 2 归一化字段

对每条文献抽出：`author, title, venue, year, volume, number, pages, doi, arxiv_id, publisher`。

**信息不全时先联网核实**，优先顺序：DBLP → PMLR / NeurIPS proceedings / OpenReview / AAAI OJS → ACM DL → IEEE Xplore → 出版社页面。
核实原则：
- 只补**查到出处**的字段；
- 会议/期刊的正式名称与缩写以官方为准（例如 `medDreamer` 官方标题首字母就是小写）；
- 两个来源冲突时（例如不同的 proceedings 分页），采用 DBLP / 官方 proceedings 的值，并在交付说明里注明。

## Step 3 套用 IEEE 规则

读 `references/ieee-style-rules.md`（格式模板）和 `references/venue-abbreviations.md`（会议/期刊缩写表）。

高频规则速记：
- 作者：`J. K. Author`（名缩写在前、姓在后）；**超过 6 位作者**只写第一作者 + `et al.`；`Jr./Sr./III` 前不加逗号。
- 期刊：`Abbrev. Title, vol. x, no. x, pp. xxx–xxx, Abbrev. Month, year, doi: xxx.`
- 会议：`in Proc. Abbrev. Conf., year, pp. xxx–xxx.` —— 默认**不带** `(NeurIPS)` 括号、不带届次、不带地点。
- arXiv：`..., year, arXiv: 2004.07219.`
- 书：`Title of Book. City, State, Country: Publisher, year.`
- 除 URL 结尾外，每条都要以句点结尾；页码用 en dash（`–`）。

## Step 4 生成与质检

| 规模 | 做法 |
|---|---|
| **≥3 条 或 整个 `.bib`** | 启动 **A 智能体**（改写）+ **B 智能体**（只读审核）。B 按 `references/review-checklist.md` 逐条查，输出"必须改 / 建议改"表格；A 只改"必须改"项；最多循环 2 轮 |
| **1~2 条** | 不启子代理，自己按 `references/review-checklist.md` 过一遍 |

A/B 的分工与提示词可直接照搬本文件末尾的「Appendix A / B」。

## Step 5 验证

**输出 `.bib` 时：**
1. 跑 `scripts/validate_bib.sh <file>`，必须 0 error。
2. 若本机有 `pdflatex` + `bibtex` + `IEEEtran.bst`，在 `/tmp` 建临时目录，写一个 `\nocite{*}` 的最小文档编译一遍，确认 `.blg` 无 warning、`.bbl` 渲染正确。**不要**在用户的稿件目录里生成 aux/log/pdf。

**输出文本（word / markdown / 直接输出）时：**
- 跑 `scripts/check_style.sh <file>`，确认没有全称会议名、没有单短横页码、没有误小写缩写。

## Step 6 交付

| 格式 | 产物 | 回复里要说 |
|---|---|---|
| BibTeX | `<原名>_ieee.bib` | 条目数、cite key 列表、哪些字段标了 `[待核实]` |
| Word | `<原名>_references.docx`，用 `scripts/to_docx.sh` | 文件路径 |

生成 Word 前先写一个中间文件 `refs.txt`：**每条一行**（不折行）、`[n]` 开头、需要斜体的部分用 `*...*` 包住。按 `IEEEtran.bst` 的实际排版，期刊名、会议 `Proc. ...`、书名都是斜体（已用 `RSC.bbl` 的 `\emph` 核实）。`to_docx.sh` 会输出 Times New Roman 10 pt、0.25 英寸悬挂缩进的参考文献列表。
| Markdown | `<原名>_references.md` | 文件路径 |
| 直接输出 | 聊天里的 `[1] …` 列表 | "可直接粘贴进参考文献表" |

交付时另附一小段「本次核实/修正了什么」，把改过的元数据（页码、作者、年份）列出来，方便用户复核。

---

## 快速参考

- **IEEE 格式模板** → `references/ieee-style-rules.md`
- **BibTeX 字段怎么写才不会被 `IEEEtran.bst` 弄坏** → `references/bibtex-field-guide.md`
- **会议/期刊缩写** → `references/venue-abbreviations.md`
- **审核清单** → `references/review-checklist.md`
- **真实 before/after 样例** → `references/examples.md`

## 支持的文献类型

期刊论文、会议论文（含 workshop）、arXiv 预印本、书籍/章节、学位论文、技术报告、标准、专利、数据集、网页。冷门类型按 `ieee-style-rules.md` 的 Basic Format 套用。

---

## Appendix A — A 智能体提示词模板

> 你是 A 智能体：把文献信息改写成 IEEE 标准格式。
> 1. 读 `references/ieee-style-rules.md`、`references/bibtex-field-guide.md`、`references/venue-abbreviations.md`。
> 2. 输出 `.bib` 时：只写数据字段，不写渲染串；期刊/会议名直接用缩写；页码用 ASCII `--`；title 中的缩写词用花括号保护（`{MOPO}`、`{Q}-Learning`、`{OOD}`、`{RL}`）；arXiv 用 `@misc` + `note={arXiv: xxxx}`；保留全部 cite key。
> 3. 输出纯文本时：直接把规则套成最终字符串，不要保留 BibTeX 语法。
> 4. 缺失字段先联网核实（DBLP / PMLR / NeurIPS / AAAI / ACM DL / IEEE Xplore），查不到标 `[待核实]`，**不许编**。
> 5. 交付：逐条改动摘要 + 核实到的事实与来源 + 仍不确定的字段。

## Appendix B — B 智能体提示词模板

> 你是 B 智能体：**只读**审核，不得修改任何文件。
> 按 `references/review-checklist.md` 逐条检查，输出表格：`条目 | 问题类型 | 严重度（必须改/建议改/可忽略）| 现状 | 应改成什么`。
> 只报真实问题，不要凑数；最后给出「必须改」条目数与总体结论。
> 对最容易出错的 6~8 条，按 bst 规则写出预期渲染结果，供与编译产物对照。
