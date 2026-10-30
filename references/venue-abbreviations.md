# 会议 / 期刊缩写对照表

左列是常见全称，右列是本 skill 默认使用的 `booktitle` / `journal` 值（可直接复制）。
未收录的按下节规则现场构造。

---

## 1. 机器学习 / 人工智能会议

| 会议 | booktitle |
|---|---|
| Advances in Neural Information Processing Systems (NeurIPS / NIPS) | `Proc. Adv. Neural Inf. Process. Syst.` |
| International Conference on Machine Learning (ICML) | `Proc. Int. Conf. Mach. Learn.` |
| International Conference on Learning Representations (ICLR) | `Proc. Int. Conf. Learn. Represent.` |
| AAAI Conference on Artificial Intelligence | `Proc. AAAI Conf. Artif. Intell.` |
| International Joint Conference on Artificial Intelligence (IJCAI) | `Proc. Int. Joint Conf. Artif. Intell.` |
| ACM SIGKDD Conference on Knowledge Discovery and Data Mining (KDD) | `Proc. ACM SIGKDD Conf. Knowl. Discov. Data Mining` |
| Conference on Robot Learning (CoRL) | `Proc. Conf. Robot Learn.` |
| Robotics: Science and Systems (RSS) | `Proc. Robot.: Sci. Syst.` |
| IEEE International Conference on Robotics and Automation (ICRA) | `Proc. IEEE Int. Conf. Robot. Autom.` |
| IEEE/RSJ International Conference on Intelligent Robots and Systems (IROS) | `Proc. IEEE/RSJ Int. Conf. Intell. Robots Syst.` |
| Conference on Empirical Methods in Natural Language Processing (EMNLP) | `Proc. Conf. Empirical Methods Natural Lang. Process.` |
| Annual Meeting of the Association for Computational Linguistics (ACL) | `Proc. Annu. Meeting Assoc. Comput. Linguistics` |
| IEEE/CVF Conference on Computer Vision and Pattern Recognition (CVPR) | `Proc. IEEE/CVF Conf. Comput. Vis. Pattern Recognit.` |
| IEEE/CVF International Conference on Computer Vision (ICCV) | `Proc. IEEE/CVF Int. Conf. Comput. Vis.` |
| European Conference on Computer Vision (ECCV) | `Proc. Eur. Conf. Comput. Vis.` |
| International Conference on Artificial Intelligence and Statistics (AISTATS) | `Proc. Int. Conf. Artif. Intell. Statist.` |
| Conference on Uncertainty in Artificial Intelligence (UAI) | `Proc. Conf. Uncertainty Artif. Intell.` |
| International Conference on Automated Planning and Scheduling (ICAPS) | `Proc. Int. Conf. Autom. Planning Scheduling` |

## 2. IEEE 期刊

| 期刊 | journal |
|---|---|
| IEEE Transactions on Pattern Analysis and Machine Intelligence | `IEEE Trans. Pattern Anal. Mach. Intell.` |
| IEEE Transactions on Industrial Informatics | `IEEE Trans. Ind. Informat.` |
| IEEE Transactions on Neural Networks and Learning Systems | `IEEE Trans. Neural Netw. Learn. Syst.` |
| IEEE Transactions on Cybernetics | `IEEE Trans. Cybern.` |
| IEEE Transactions on Knowledge and Data Engineering | `IEEE Trans. Knowl. Data Eng.` |
| IEEE Transactions on Automation Science and Engineering | `IEEE Trans. Autom. Sci. Eng.` |
| IEEE Transactions on Systems, Man, and Cybernetics: Systems | `IEEE Trans. Syst., Man, Cybern., Syst.` |
| IEEE Transactions on Image Processing | `IEEE Trans. Image Process.` |
| IEEE Transactions on Signal Processing | `IEEE Trans. Signal Process.` |
| IEEE Transactions on Automatic Control | `IEEE Trans. Autom. Control` |
| IEEE Transactions on Robotics | `IEEE Trans. Robot.` |
| IEEE Robotics and Automation Letters | `IEEE Robot. Autom. Lett.` |
| IEEE Journal of Selected Topics in Signal Processing | `IEEE J. Sel. Topics Signal Process.` |
| IEEE/CAA Journal of Automatica Sinica | `IEEE/CAA J. Autom. Sinica` |
| Proceedings of the IEEE | `Proc. IEEE` |

## 3. 常见非 IEEE 期刊

| 期刊 | journal |
|---|---|
| Journal of Machine Learning Research | `J. Mach. Learn. Res.` |
| Machine Learning | `Mach. Learn.` |
| Artificial Intelligence | `Artif. Intell.` |
| Neural Computation | `Neural Comput.` |
| Nature | `Nature`（单词刊名不缩写） |
| Science | `Science`（单词刊名不缩写） |
| International Journal of Robotics Research | `Int. J. Robot. Res.` |
| Autonomous Robots | `Auton. Robots` |
| Transportation Research Part C | `Transp. Res. C, Emerg. Technol.` |

## 4. 出版社缩写

| 出版社 | 缩写 |
|---|---|
| MIT Press | `MIT Press` |
| Springer | `Springer` |
| Springer-Verlag | `Springer-Verlag` |
| Elsevier | `Elsevier` |
| Wiley | `Wiley` |
| IEEE Press | `IEEE Press` |
| ACM | `ACM` |
| Cambridge University Press | `Cambridge Univ. Press` |
| Oxford University Press | `Oxford Univ. Press` |
| Princeton University Press | `Princeton Univ. Press` |
| Morgan Kaufmann | `Morgan Kaufmann` |
| Publish or Perish | `Publish or Perish` |

---

## 5. 未收录时的构造规则

1. 用 IEEE 的常见缩写词：`Proc.`, `Conf.`, `Int.`, `Symp.`, `Workshop`, `Annu.`, `Trans.`, `J.`, `Lett.`, `Rev.`, `Comput.`, `Inf.`, `Syst.`, `Learn.`, `Recognit.`, `Vis.`, `Autom.`, `Robot.`, `Artif.`, `Intell.`, `Neural`, `Netw.`, `Process.`, `Eng.`, `Sci.`, `Technol.`。
2. 去掉冠词与介词：`of the`、`on`、`for`（`for` 视语境可保留）。
3. 保留专有名词原样（`NeurIPS` 不进 booktitle，但 `AAAI`、`IEEE`、`ACM` 保留）。
4. 拿不准就查：IEEE Xplore 该刊页面、DBLP 的 venue 缩写、或 Google Scholar 的 "IEEE style" 引用。
5. **同一份文献表内必须统一**——不要一半带届次、一半不带。
