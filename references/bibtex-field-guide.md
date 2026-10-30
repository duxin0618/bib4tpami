# BibTeX 字段写法（配合 IEEEtran.bst v1.14）

> **最重要的一条**：`.bib` 里写的是**数据**，不是排版结果。不要写 `pages = {pp. 1--2}`、不要写 `journal = {IEEE Trans. ..., vol. 45, no. 12}`。所有 `vol./no./pp./doi:` 都由 `.bst` 生成。

---

## 1. 期刊

```bibtex
@ARTICLE{key,
  author  = {Last, First and Last, First},
  journal = {IEEE Trans. Pattern Anal. Mach. Intell.},
  title   = {Offline Model-Based Adaptable Policy Learning for Decision-Making in Out-of-Support Regions},
  year    = {2023},
  month   = {Dec.},
  volume  = {45},
  number  = {12},
  pages   = {15260--15274},
  doi     = {10.1109/TPAMI.2023.3317131},
}
```

- `journal` 必须**手写缩写**，bst 不会自动缩写。
- `month` 写成 `{Feb.}` 这种带点缩写；不写也能编译，但 IEEE 规范要求 IEEE Transactions 尽量带月份。
- ⚠️ **IEEEtran.bst v1.14 不输出 `doi` 字段**（`.bbl` 里不会出现 doi）。保留 doi 字段无害，但不要指望它出现在 PDF 里；若期刊强制要求 DOI，需要换支持 doi 的 bst 或手工处理。

## 2. 会议

```bibtex
@inproceedings{key,
  author    = {Fujimoto, Scott and Meger, David and Precup, Doina},
  title     = {Off-Policy Deep Reinforcement Learning without Exploration},
  booktitle = {Proc. Int. Conf. Mach. Learn.},
  pages     = {2052--2062},
  year      = {2019},
}
```

- `booktitle` 写 `Proc.` + 缩写，例如 `Proc. Adv. Neural Inf. Process. Syst.`。
- **不要**写 `Proceedings of the Conference on ...`、不要写 `(NeurIPS)`、不要写届次或地点（见 `ieee-style-rules.md` 第 13 节）。
- ICLR 等无页码的会议：直接省略 `pages`。

## 3. 页码：必须是 ASCII `--`

| 写法 | 结果 |
|---|---|
| `pages = {2052--2062}` | ✅ `pp. 2052--2062` |
| `pages = {2052-2062}` | ⚠️ 可能被当成单个字符串 |
| `pages = {2052–2062}`（Unicode en dash） | ❌ bst 认不出范围，渲染成 `p. 2052–2062` |

> 复制 PDF/网页时最容易带入 Unicode 连字符。用 `LC_ALL=C grep -n '[^ -~	]' file.bib` 检查。

## 4. 标题大小写：用花括号保护缩写

`IEEEtran.bst` 会把 title 折成 sentence case。专有缩写若不保护会被小写：

```bibtex
title = {{MOPO}: Model-Based Offline Policy Optimization}   % → "MOPO: Model-based ..."
title = {Stabilizing Off-Policy {Q}-Learning ...}            % → "Stabilizing off-policy Q-learning ..."
title = {Offline Reinforcement Learning with {OOD} ...}      % → "... with OOD ..."
title = {{D4RL}: Datasets ...}                               % → "D4RL: Datasets ..."
```

要点：
- 花括号**只包住缩写本身**：`{Q}-Learning` 会变成 `Q-learning`（Learning 仍被折小写，符合 IEEE sentence case）。
- 别把整个标题包起来，否则句子其余部分的大写不会被规范化。
- 常见需要保护的词：`MOPO`、`MOReL`、`COMBO`、`RAMBO-RL`、`Cal-QL`、`D4RL`、`NeoRL`、`OOD`、`RL`、`ALVINN`、`EHR`、`Q`、`Model-Bellman`、以及方法名（如 `medDreamer` 官方就是小写 m）。

## 5. arXiv：`@misc` + `note`

`IEEEtran.bst` 没有 arXiv 类型。用 `@misc` 可以让输出顺序刚好等于 IEEE 的 `..., year, arXiv: xxxx.`：

```bibtex
@misc{key,
  author = {Fu, Justin and Kumar, Aviral and Nachum, Ofir and Tucker, George and Levine, Sergey},
  title  = {{D4RL}: Datasets for Deep Data-Driven Reinforcement Learning},
  year   = {2020},
  note   = {arXiv: 2004.07219},
}
```

渲染结果：`J. Fu et al., "D4RL: Datasets for deep data-driven reinforcement learning," 2020, arXiv: 2004.07219.`

> 不要用 `@article` + `journal = {arXiv preprint arXiv:xxxx}`，那样会渲染成 `arXiv preprint arXiv:xxxx, 2020.`，与官方格式不符。

## 6. 书籍

```bibtex
@book{key,
  author    = {Sutton, Richard S. and Barto, Andrew G.},
  title     = {{Reinforcement Learning: An Introduction}},
  address   = {Cambridge, MA, USA},
  publisher = {MIT Press},
  year      = {2018},
}
```

- `address` + `publisher` 才能渲染成 `Cambridge, MA, USA: MIT Press, 2018`。
- 书名用 title case，并用花括号整题保护。

## 7. 作者字段

- 统一 `Last, First Middle`；多位作者用 ` and` 连接。
- 不要用 `and others` 代替未知作者——要么查全，要么保留原作者列表。
- 复合姓（`Hamel-De Le Court`、`Sobol Mark`）整体写在姓的位置：`Hamel-De Le Court, Edwin`。

## 8. et al. 阈值

`IEEEtran.bst` 默认 **超过 10 位作者**才用 et al.，而 IEEE 规范是**超过 6 位**。
若稿件要严格遵守，在 `.tex` 导言区（`\begin{document}` 前）加：

```latex
\bstctlcite{IEEEexample:BSTcontrol}
```

并在 `.bib` 中加：

```bibtex
@IEEEtranBSTCTL{IEEEexample:BSTcontrol,
  CTLmax_names_forced_etal       = "6",
  CTLnames_show_etal             = "1",
  CTLuse_forced_etal             = "yes",
}
```

> 这属于改 `.tex`，**先征得用户同意**再动。

## 9. 编译自检（不要污染用户目录）

```bash
mkdir -p /tmp/bibcheck && cd /tmp/bibcheck
cat > t.tex <<'EOF'
\documentclass{article}
\begin{document}
\nocite{*}
\bibliographystyle{IEEEtran}
\bibliography{refs}
\end{document}
EOF
cp /path/to/refs.bib . ; cp /path/to/IEEEtran.bst .
pdflatex -interaction=nonstopmode t >/dev/null; bibtex t; pdflatex -interaction=nonstopmode t >/dev/null
grep -i "warning\|error" t.blg
```

`\nocite{*}` 能强制渲染**所有**条目（包括正文未引用的），便于一次性检查全部格式。

## 10. 交付 BibTeX 时的检查清单

- [ ] 条目数与输入一致，cite key 全部保留
- [ ] `journal` / `booktitle` 全是缩写，无 `Proceedings of` / `Conference on` / `(NeurIPS)`
- [ ] 所有 `pages` 是 ASCII `--`
- [ ] title 中的缩写都有花括号保护
- [ ] 文件无非 ASCII 字符
- [ ] `validate_bib.sh` 退出码为 0
