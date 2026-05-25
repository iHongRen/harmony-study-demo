## code_counter.py 使用说明

`code_counter.py` 是一个面向 HarmonyOS 项目的代码行数统计脚本，按语言分类统计非空行数，并输出总行数与扫描文件数。

脚本位置：
- [code_counter.py](/Users/cxy/Desktop/CXY/harmony-study-demo/scripts/code_counter.py)

## 功能特点

- 统计非空行（空行不计入）
- 按语言分类汇总（ArkTS、TS、JS、JSON5、XML 等）
- 支持自定义排除目录
- 支持仅统计指定语言
- 支持输出每个文件的明细（`--show-detail`）
- 输出总扫描文件数

## 命令格式

```bash
python3 scripts/code_counter.py <project_path> [--exclude ...] [--include ...] [--show-detail]
```

## 参数说明

- `project_path`：项目根目录（必填）
- `--exclude`：额外排除目录，可传多个
- `--include`：仅统计指定语言，可传多个
- `--show-detail`：打印逐文件统计与按语言分组明细

## 使用示例

统计当前项目：

```bash
python3 scripts/code_counter.py .
```

统计指定目录并额外排除文档与临时目录：

```bash
python3 scripts/code_counter.py ./entry --exclude docs temp
```

仅统计 ArkTS 与 TypeScript：

```bash
python3 scripts/code_counter.py . --include ArkTS TypeScript
```

输出详细文件明细：

```bash
python3 scripts/code_counter.py . --show-detail
```

## 支持统计的语言/文件类型

- `ArkTS`：`.ets`
- `JavaScript`：`.js`、`jsx`
- `TypeScript`：`.ts`、`.tsx`
- `CSS`：`.css`、`.less`
- `HTML`：`.html`
- `C/C++`：`.c`、`.cpp`、`.h`
- `json`：`.json`
- `json5`：`.json5`
- `xml`：`.xml`
- `Dart`：`.dart`

> 注意：脚本中 `JavaScript` 的 `jsx` 当前写为 `jsx`（无点号），如需统计 `.jsx` 文件，建议将其改为 `.jsx`。

## 默认排除目录

脚本默认排除以下目录（可通过 `--exclude` 继续追加）：

```txt
node_modules .git build oh_modules dist output logs test tests _tests
.idea .vscode .gradle .hvigor
```

## 输出说明

脚本输出包含以下信息：

- 项目路径、排除目录、统计语言
- 按语言汇总的代码行数与占比
- 总代码行数
- 扫描文件数
- （可选）逐文件详细统计与按语言分组明细
