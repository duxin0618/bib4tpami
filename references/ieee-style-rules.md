# IEEE Reference Style — 规则速查

来源：*IEEE Reference Guide* (IEEE Publication Operations, v3.28.2025)。
下列模板中的 `Abbrev.` 表示使用缩写（见 `venue-abbreviations.md`）。

---

## 1. 通则

- 参考文献编号 `[1]` 左对齐、单独成列，正文中以方括号引用。
- 正文引用多个文献要写全：`[1], [2], [3]`，**不要**写成 `[1]–[3]`。
- 作者名：名的首字母在前，姓在后，如 `J. K. Author`。
  - `Jr.`、`Sr.`、`III` 前不加逗号：`Michael Smith Jr.`。
  - IEEE 出版物列全部作者，**最多 6 位**；超过 6 位写第一作者 + `et al.`。
  - 非 IEEE 出版物若原始信息未给全，可用 `et al.`。
- 除 URL 结尾的条目外，每条都以句点结尾（含带 DOI 的条目）。
- 日期至少到年份；确实无日期写 `(n.d.)`。
- IEEE Transactions 要尽量补**期号（no.）和月份**；early access 用上线日期。
- 两个月份同期时用斜杠：`Jul./Aug.`。
- 不要合并条目，一条一个编号；不要使用 `ibid.` / `op. cit.`。

## 2. 期刊论文（Periodical）

**基本格式**

```
J. K. Author, "Name of paper," Abbrev. Title of Periodical, vol. x, no. x, pp. xxx–xxx, Abbrev. Month, year.
```

**带 DOI**

```
J. K. Author, "Name of paper," Abbrev. Title of Periodical, vol. x, no. x, pp. xxx–xxx, Abbrev. Month, year, doi: 10.xxxx/xxxxx.
```

**Early access**（已在线但未定卷期）

```
J. K. Author, "Name of paper," Abbrev. Title of Periodical, early access, Dec. 11, 2018, doi: 10.1109/XXXX.2018.2886261.
```

**Article ID**（无页码，给文章号）

```
J. K. Author, "Name of paper," Abbrev. Title of Periodical, vol. x, no. x, Abbrev. Month, year, Art. no. xxx.
```

**已录用未出版**

```
J. K. Author, "Name of paper," Abbrev. Title of Periodical, to be published.
```

**已投稿未录用**

```
J. K. Author, "Name of paper," submitted for publication.
```

> 期刊名只有一个单词时不缩写，写全称（如 `Science`、`Nature`）。

## 3. 会议论文（Conference）

**会议论文集（印刷版）**

```
J. K. Author, "Title of paper," in Abbrev. Name of Conf., year, pp. xxx–xxx.
```

**带 DOI**

```
J. K. Author, "Title of paper," in Abbrev. Name of Conf., year, pp. xxx–xxx, doi: 10.xxxx/xxxxx.
```

**带地点（可选）**

```
J. K. Author, "Title of paper," in Abbrev. Name of Conf., City, State, Country, year, pp. xxx–xxx.
```

**在线**

```
J. K. Author, "Title of paper," in Abbrev. Name of Conf., year, pp. xxx–xxx. [Online]. Available: http://www.url.com
```

**会议名缩写规则**
- 常用词：`Proc.`（Proceedings）、`Conf.`（Conference）、`Int.`（International）、`Symp.`（Symposium）、`Workshop`、`Annu.`、`Tech. Dig.`。
- 省略 `of the`、`on` 之类冠词/介词。
- 有届次时用数字形式：`1st`、`2nd`、`36th`（不写 `First`）。
- 已发表会议论文**必须有页码**；确实没有（如 ICLR、部分 OpenReview 论文）则省略 pages。

## 4. 书籍

**整本**

```
J. K. Author, Title of Book, xth ed. City, State, Country: Abbrev. Publisher, year, pp. xxx–xxx.
```

**章节**

```
J. K. Author, "Title of chapter," in Title of Published Book, X. Editor, Ed. City, State, Country: Abbrev. Publisher, year, ch. x, pp. xxx–xxx.
```

**在线版本**：末尾加 `. [Online]. Available: http://www.url.com`。

> 书名用 title case（实词首字母大写）；期刊/会议/论文标题在 IEEE 里用 sentence case（仅首词、冒号后首词与专有名词大写）。

## 5. arXiv 预印本

```
J. K. Author, "Title of paper," year, arXiv: 2004.07219.
```

> 若论文已在期刊/会议正式发表，优先引用正式版本，不要引 arXiv。

## 6. 学位论文

```
J. K. Author, "Title of thesis," Ph.D. dissertation, Abbrev. Dept., Abbrev. Univ., City, State, Country, year.
J. K. Author, "Title of thesis," M.S. thesis, Abbrev. Dept., Abbrev. Univ., City, State, Country, year.
```

> `thesis` / `dissertation` 按作者原始用法保留，不要按学位等级擅自替换。

## 7. 技术报告

```
J. K. Author, "Title of report," Abbrev. Co., City, State, Country, Rep. xxx, year.
```

## 8. 标准

```
Title of Standard, Standard number, year.
```

## 9. 专利

```
J. K. Author, "Title of patent," U.S. Patent 3 624 125, Jul. 16, 1990.
```

## 10. 数据集

```
Author, Date, "Title of Dataset," Source, doi: 10.xxxx/xxxxx.
```

## 11. 网页 / 博客

```
J. K. Author, "Title of the post," Title of the Website, Month, Day, Year. [Online]. Available: http://www.url.com
```

需要时加 `Accessed: Feb. 1, 2009.`（放在 `[Online]` 之前）。

## 12. 常见缩写

| 全称 | 缩写 | 全称 | 缩写 |
|---|---|---|---|
| Proceedings | Proc. | volume | vol. |
| Conference | Conf. | number | no. |
| International | Int. | pages | pp. |
| Symposium | Symp. | page | p. |
| Annual | Annu. | Article number | Art. no. |
| Technical Digest | Tech. Dig. | Editor(s) | Ed(s). |
| Transactions | Trans. | Journal | J. |
| Letters | Lett. | Review | Rev. |

月份缩写：Jan., Feb., Mar., Apr., May, Jun., Jul., Aug., Sep., Oct., Nov., Dec.

---

## 13. 本 skill 的默认约定（与 TPAMI 已发表论文一致）

以下约定不是 IEEE 规范的唯一写法，但为了整份文献表**风格统一**，默认采用：

1. 会议名缩写后**不加** `(NeurIPS)` 之类括号。
2. 会议名**不加届次**、**不加地点**（IEEE 中地点是可选项）。
3. 期刊/会议名一律用缩写形式。
4. 有 DOI 的条目保留 DOI；没有则不加（不臆造）。
5. 参考文献表按正文首次引用顺序编号。
