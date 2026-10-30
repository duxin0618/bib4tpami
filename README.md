# mybib4tpami

> 把 `.bib` / `.docx` / `.pdf` / `.tex` / 单条参考文献，整理成 **IEEE（TPAMI）标准引用格式**。
> 一个可装的 Agent Skill：Claude Code、Codex 通用，装上就能用，实验室内部可以直接共享。

![license](https://img.shields.io/badge/license-MIT-blue)
![platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20Windows(WSL)-lightgrey)
![agent](https://img.shields.io/badge/agent-Claude%20Code%20%7C%20Codex-green)

---

## 目录

- [它解决什么问题](#它解决什么问题)
- [快速开始](#快速开始)
- [怎么用](#怎么用)
- [它内部做了什么](#它内部做了什么)
- [目录结构](#目录结构)
- [依赖](#依赖)
- [常见问题](#常见问题)
- [自定义](#自定义)
- [已知局限](#已知局限)

---

## 它解决什么问题

投 TPAMI / IEEE 期刊时，参考文献格式的坑集中在几处，手工改既慢又容易漏：

| 你原来的写法 | 整理后（`IEEEtran.bst` 实际渲染） |
|---|---|
| `booktitle = {Proceedings of the Conference on Advances in Neural Information Processing Systems (NeurIPS)}` | `in Proc. Adv. Neural Inf. Process. Syst., 2019, pp. 11761–11771.` |
| `pages = {1693–1704}`（Unicode 连字符） | 会被 bst 误判成单页 `p. 1693–1704`；改成 ASCII `--` 才输出 `pp. 1693–1704` |
| `title = {MOPO: Model-Based Offline Policy Optimization}` | 不加保护会被折成 `"Mopo: Model-based offline policy optimization,"`；用 `{MOPO}` 保护后正确 |
| `journal = {arXiv preprint arXiv:2004.07219}` | `..., 2020, arXiv: 2004.07219.` |
| `pages = {15260-15274}` | `pp. 15260–15274`（en dash，不是短横） |

这个 skill 把这些规则、缩写表、校验脚本和一套 A/B 双智能体审核流程打包在一起，**你只需要把文件丢给它**。

几条设计原则：

- **绝不臆造**：作者、页码、年份查不到就标 `[待核实]`，不拿"看起来合理"的数字填坑。
- **先问再用**：动手前一定先问你要哪种交付格式（BibTeX / Word / Markdown / 直接输出）。
- **可验证**：输出 `.bib` 会跑静态校验，本机有 TeX 就真编译一遍核对 `.bbl`。

---

## 快速开始

先拿到仓库：

```bash
git clone https://github.com/<your-name>/mybib4tpami.git
cd mybib4tpami
```

### 1. Claude Code

```bash
mkdir -p ~/.claude/skills
cp -r . ~/.claude/skills/mybib4tpami
```

Windows（PowerShell）：

```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\.claude\skills\mybib4tpami"
Copy-Item -Recurse * "$env:USERPROFILE\.claude\skills\mybib4tpami"
```

重启 Claude Code（或新开一个会话），然后：

```
/mybib4tpami
```

也可以不敲命令，直接说「帮我把这个 bib 改成 IEEE 格式」——它会靠 `description` 自动触发。

### 2. Codex

Codex 用的是同一套 Agent Skills 标准（`SKILL.md` + 可选 `scripts/`、`references/`），本仓库可以直接放进去，**不需要改任何文件**。

```bash
# 用户级：所有项目都能用
mkdir -p ~/.agents/skills
cp -r . ~/.agents/skills/mybib4tpami
```

较早的 Codex 版本读的是 `~/.codex/skills/`，两个都放一份最省事：

```bash
mkdir -p ~/.codex/skills && cp -r . ~/.codex/skills/mybib4tpami
```

调用方式（任选其一）：

- 在输入框里 `$mybib4tpami` 显式提及；
- `/skills` 打开技能菜单选它；
- 直接描述需求，靠 `description` 自动匹配。

> Codex 只要求 frontmatter 里有 `name` 和 `description`，本仓库多出来的 `version` / `author` / `tags` 会被忽略，不影响使用。
> 另外 Codex 没有 `AskUserQuestion` 工具，第一步的格式选择会退化成**编号选项的文字提问**，效果一样。

### 3. 整个实验室一起用（推荐）

不必每个人都去装一遍：把 skill 放进**论文仓库**里，队友 clone 下来就自带。

```bash
cd your-paper-repo
mkdir -p .claude/skills .agents/skills
cp -r /path/to/mybib4tpami .claude/skills/     # Claude Code 项目级
cp -r /path/to/mybib4tpami .agents/skills/     # Codex 项目级
git add .claude .agents && git commit -m "add mybib4tpami skill"
```

---

## 怎么用

### 支持的输入

| 你给它 | 它怎么处理 |
|---|---|
| `.bib` | 直接解析，**保留全部 cite key 和未被引用的条目**（不会帮你删条目） |
| `.docx` / `.doc` / `.rtf` / `.odt` | `textutil` / `pandoc` 抽文本；若是整篇论文，只截取 `REFERENCES` 到 `Appendix` 之间 |
| `.pdf` | `pdftotext` → macOS PDFKit → `pypdf` 逐级降级；自动处理行尾断词、剔除页眉页码 |
| `.tex` | 抽取 `thebibliography` 里的 `\bibitem`（用 `\bibliography{}` 的会提示你直接给 `.bib`） |
| 粘贴的一段文本 / 单条文献 | 直接用，单条不启子代理，直接给结果 |

### 调用示例

```
/mybib4tpami 帮我把 refs.bib 规范化，导出 Word
```
```
/mybib4tpami 这篇 PDF 的参考文献要重排成 IEEE 格式
```
```
/mybib4tpami S. Fujimoto, D. Meger, D. Precup, "Off-policy deep reinforcement learning
without exploration," ICML 2019, pp. 2052-2062
```

### 四种交付格式

第一次调用它会弹出四个选项（如果你在消息里已经说清楚要哪种，它会跳过提问）：

| 选项 | 产物 | 适用场景 |
|---|---|---|
| **BibTeX 文件** | `<原名>_ieee.bib` | 继续用 `\bibliography{}` 编译 |
| **Word 文档** | `<原名>_references.docx` | 给不写 LaTeX 的合作者；Times New Roman 10 pt、0.25 英寸悬挂缩进、期刊名斜体 |
| **Markdown** | `<原名>_references.md` | 放 README、Notion、GitHub issue |
| **直接输出** | 聊天里的 `[1] [2] …` 列表 | 复制粘贴进现成的参考文献表 |

交付时还会附一段「本次核实/修正了什么」，把动过的页码、作者、年份列出来，方便你复核。

---

## 它内部做了什么

```
Step 0  问你要哪种格式（四选一，强制）
  ↓
Step 1  抽输入：bib / docx / pdf / tex / 纯文本
  ↓
Step 2  归一化字段；缺的先联网查（DBLP → PMLR/NeurIPS/OpenReview → ACM DL → IEEE Xplore）
        查不到 → 标 [待核实]，不编造
  ↓
Step 3  套 IEEE 规则（作者缩写、期刊/会议缩写、en dash、arXiv 写法…）
  ↓
Step 4  ≥3 条或整个 .bib → A 智能体改写 + B 智能体只读审核，最多 2 轮
        1~2 条 → 自己按清单过一遍
  ↓
Step 5  验证：`.bib` 跑 validate_bib.sh（+ 可选真编译）；文本跑 check_style.sh
  ↓
Step 6  按格式交付
```

**为什么不直接让一个模型改？** 因为格式错误大多是"看着对但渲染错"——B 智能体只读不写，专门拿着 bst 规则去挑 A 的刺（比如 `{MOPO}` 没加花括号、页码用了 Unicode 连字符），比同一个模型自审有效得多。

---

## 目录结构

```
mybib4tpami/
├── SKILL.md                       # 主流程（Step 0–6 + A/B 提示词模板）
├── README.md                      # 就是你正在看的这个
├── references/
│   ├── ieee-style-rules.md        # IEEE Reference Guide 精炼版：各类文献的 Basic Format
│   ├── bibtex-field-guide.md      # IEEEtran.bst v1.14 的字段写法与坑（最容易踩）
│   ├── venue-abbreviations.md     # 会议 / 期刊 / 出版社缩写对照表
│   ├── review-checklist.md        # B 智能体的审核清单
│   └── examples.md                # 真实 before/after（含 5 处元数据纠错）
└── scripts/
    ├── extract_text.sh            # 输入抽取：bib / docx / pdf / tex
    ├── pdftext.swift              # macOS PDF 抽取兜底（PDFKit）
    ├── validate_bib.sh            # .bib 静态校验，有 error 就 exit 1
    ├── check_style.sh             # 渲染后文本的格式断言，有 error 就 exit 1
    └── to_docx.sh                 # 参考文献列表 → .docx（RTF → textutil，或 pandoc）
```

脚本都可以单独跑，不依赖 skill：

```bash
./scripts/validate_bib.sh refs.bib       # 0 error 才 PASS
./scripts/check_style.sh refs.txt        # 每条以 [n] 开头
./scripts/extract_text.sh paper.pdf
./scripts/to_docx.sh refs.txt out.docx   # refs.txt 每行一条，*斜体* 用星号标
```

---

## 依赖

| 功能 | 依赖 | 缺失时 |
|---|---|---|
| 读 `.docx/.doc/.rtf` | `textutil`（macOS 自带）或 `pandoc` | 提示先另存为 `.txt` |
| 读 `.pdf` | `pdftotext` / macOS `swift` / Python `pypdf`，任一即可 | 提示粘贴文本 |
| 输出 `.docx` | `textutil` 或 `pandoc` | 提示改用 Markdown |
| 编译验证 | `pdflatex` + `bibtex` + `IEEEtran.bst` | 退化为静态校验 |

全部**优雅降级并说明原因**，不会静默失败。Linux 上建议 `apt install poppler-utils pandoc`，Windows 建议在 WSL 或 Git Bash 里跑。

---

## 常见问题

**Q：改完 `.bib` 了，但 PDF 里的参考文献没变？**
A：`.bbl` 是中间产物，需要重跑：`bibtex <main> && pdflatex <main> && pdflatex <main>`。

**Q：它会不会瞎编作者和页码？**
A：不会。查不到出处就写 `[待核实]` 并在交付说明里点出来，由你决定。

**Q：我的目标是 ICRA 而不是 TPAMI，能用吗？**
A：能用。基础规则就是 IEEE Reference Guide，会议缩写表里已覆盖 NeurIPS / ICML / ICLR / AAAI / IJCAI / KDD / CVPR / ICCV / ECCV / ACL / EMNLP / CoRL / RSS / ICRA / IROS 等。

**Q：为什么会议名没有 `(NeurIPS)` 括号？**
A：默认对齐 TPAMI 已发表论文的写法（不带括号、不带届次、不带地点）。要改见下一节。

**Q：中文参考文献？**
A：目前按英文 IEEE 格式处理，`validate_bib.sh` 会把非 ASCII 字符当 error 报出来。中文文献建议手工处理或另建分支规则。

---

## 自定义

| 想改什么 | 改哪里 |
|---|---|
| 想让会议名带 `(NeurIPS)` / 届次 / 地点 | `references/venue-abbreviations.md` + `SKILL.md` Step 3 |
| 补充你的领域的会议/期刊缩写 | 追加到 `references/venue-abbreviations.md` 的表格 |
| 审核更严 / 更松 | `references/review-checklist.md` 增删条目 |
| 换 Word 字体、字号、缩进 | `scripts/to_docx.sh` 里的 `\fs20`（=10 pt）、`\li360\fi-360`（=0.25 英寸悬挂） |

**关于 et al. 的 6 位门槛**：IEEE 规范是超过 6 位作者就用 et al.，但 `IEEEtran.bst` 默认阈值是 10 位。要严格化，在你稿件的 `.tex` 里加：

```latex
\bstctlcite{IEEEexample:BSTcontrol}
```
```bibtex
@IEEEtranBSTCTL{IEEEexample:BSTcontrol,
  CTLuse_forced_etal       = "yes",
  CTLmax_names_forced_etal = "6",
  CTLnames_show_etal       = "1",
}
```

Skill 会提示这一点，但**不会擅自改你的稿件**。

---

## 已知局限

- `IEEEtran.bst v1.14` 不输出 `doi` 字段，`.bib` 里保留 doi 无害，但不会出现在 PDF 里。
- Word 输出是**参考文献列表**（编号 + 悬挂缩进），不是整篇 IEEE 双栏模板论文。
- 会议名缩写采用 TPAMI 范文的写法，与某些 IEEE 期刊模板的默认输出略有差异（IEEE 官方其实允许两种）。
- PDF 抽取依赖排版质量，双栏 + 复杂数学的 PDF 偶尔会串行；遇到明显错乱时直接把文本贴给它更省事。
- 联网核实用的是 agent 自带的搜索能力，查不到时会老实标 `[待核实]`——**最终定稿前请自己再扫一眼**。

---

## 许可

MIT。随便用、随便改，改好了欢迎 PR 回来。
