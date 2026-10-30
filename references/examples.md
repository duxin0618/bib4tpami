# 真实 before / after 样例

以下全部来自一次真实的 TPAMI 稿件规范化（`IEEEtran.bst` v1.14 实测）。

---

## 1. 会议名全称 → 缩写

**Before**
```bibtex
booktitle = {Proceedings of the Conference on Advances in Neural Information Processing Systems (NeurIPS)},
```
**After**
```bibtex
booktitle = {Proc. Adv. Neural Inf. Process. Syst.},
```
**渲染**：`in Proc. Adv. Neural Inf. Process. Syst., 2019, pp. 11761–11771.`

## 2. 期刊名全称 → 缩写 + 补月份

**Before**
```bibtex
journal={IEEE Transactions on Pattern Analysis and Machine Intelligence},
year={2023}, volume={45}, number={12}, pages={15260-15274},
```
**After**
```bibtex
journal={IEEE Trans. Pattern Anal. Mach. Intell.},
year={2023}, month={Dec.}, volume={45}, number={12}, pages={15260--15274},
```
**渲染**：`IEEE Trans. Pattern Anal. Mach. Intell., vol. 45, no. 12, pp. 15260–15274, Dec. 2023.`

## 3. Unicode 连字符 → ASCII `--`

**Before**
```bibtex
pages = {1693–1704},
```
**After**
```bibtex
pages = {1693--1704},
```
**为什么**：Unicode en dash 会让 bst 判断不出页码范围，渲染成 `p. 1693–1704`（单页标记 + rangeless），而不是 `pp.`。

## 4. 标题缩写被 bst 折成小写

**Before**
```bibtex
title = {MOPO: Model-Based Offline Policy Optimization},
title = {Stabilizing Off-Policy Q-Learning via Bootstrapping Error Reduction},
title = {Offline Reinforcement Learning with OOD State Correction and OOD Action Suppression},
```
**After**
```bibtex
title = {{MOPO}: Model-Based Offline Policy Optimization},
title = {Stabilizing Off-Policy {Q}-Learning via Bootstrapping Error Reduction},
title = {Offline Reinforcement Learning with {OOD} State Correction and {OOD} Action Suppression},
```
**渲染**：`"MOPO: Model-based offline policy optimization,"`、`"Stabilizing off-policy Q-learning via ..."`、`"... with OOD state correction and OOD action suppression,"`

## 5. arXiv 条目

**Before**
```bibtex
@article{fu2020d4rl,
  title   = {D4RL: Datasets for Deep Data-Driven Reinforcement Learning},
  journal = {arXiv preprint arXiv:2004.07219},
  year    = {2020},
}
```
**After**
```bibtex
@misc{fu2020d4rl,
  title  = {{D4RL}: Datasets for Deep Data-Driven Reinforcement Learning},
  author = {Fu, Justin and Kumar, Aviral and Nachum, Ofir and Tucker, George and Levine, Sergey},
  year   = {2020},
  note   = {arXiv: 2004.07219},
}
```
**渲染**：`J. Fu, A. Kumar, O. Nachum, G. Tucker, and S. Levine, "D4RL: Datasets for deep data-driven reinforcement learning," 2020, arXiv: 2004.07219.`

## 6. 书籍补出版地

**Before**
```bibtex
@book{sutton,
  title = {Reinforcement learning: an introduction},
  publisher = {The MIT Press},
  year = {2018},
}
```
**After**
```bibtex
@book{sutton,
  title = {{Reinforcement Learning: An Introduction}},
  address = {Cambridge, MA, USA},
  publisher = {MIT Press},
  year = {2018},
}
```
**渲染**：`R. S. Sutton and A. G. Barto, Reinforcement Learning: An Introduction. Cambridge, MA, USA: MIT Press, 2018.`

## 7. 元数据纠错（联网核实后才改）

| 条目 | 错误 | 正确 |
|---|---|---|
| Kumar et al., BEAR, NeurIPS 2019 | 漏第三作者 | Kumar, Fu, **Soh**, Tucker, Levine；pp. 11761–11771 |
| Wu et al., BRAC | 标成 ICLR 2020 | 实为**预印本** arXiv:1911.11361（该投稿未中） |
| Goodall et al., AAAI 2026 | `and others` | 3 位作者，第二位 `Hamel-De Le Court, Edwin` |
| Xu et al., KDD 2026 | `MedDreamer` | 官方标题首字母小写 `medDreamer` |
| Ajay et al. | booktitle 写成 ICML | 实为 **ICLR 2023** |

## 8. 单条文献的最终形态（直接输出时）

```
[1] S. Fujimoto, D. Meger, and D. Precup, "Off-policy deep reinforcement
    learning without exploration," in Proc. Int. Conf. Mach. Learn., 2019,
    pp. 2052–2062.

[2] A. Kumar, J. Fu, M. Soh, G. Tucker, and S. Levine, "Stabilizing
    off-policy Q-learning via bootstrapping error reduction," in Proc. Adv.
    Neural Inf. Process. Syst., 2019, pp. 11761–11771.
```
