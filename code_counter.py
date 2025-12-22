import argparse
import os
from collections import defaultdict

# 鸿蒙项目代码行数统计工具
# ===================== 鸿蒙项目专属配置 =====================
HARMONY_EXTENSIONS = {
    'ArkTS': ['.ets'],          # 主力开发语言
    'JavaScript': ['.js', 'jsx'],  # 前端兼容
    'TypeScript': ['.ts', '.tsx'], # 前端兼容
    'CSS': ['.css', '.less'],   # 前端兼容
    'HTML': ['.html'],          # 前端兼容
    'C/C++': ['.c', '.cpp', '.h'], # 鸿蒙NDK开发
    'json': ['.json'],          # 鸿蒙配置文件（string.json）
    'json5': ['.json5'],        # 鸿蒙配置文件（build-profile.json5）
    'xml': ['.xml'],            # 鸿蒙资源配置
    'Dart': ['.dart'],          # Flutter兼容
}

# 鸿蒙项目默认排除的目录
HARMONY_DEFAULT_EXCLUDE = [
    'node_modules', '.git', 'build', 'oh_modules',
    'dist', 'output', 'logs', 'test', 'tests', '_tests',
    '.idea', '.vscode', '.gradle', '.hvigor'
]

# 反向映射：后缀 -> 鸿蒙语言/文件类型
HARMONY_EXT_TO_LANG = {}
for lang, exts in HARMONY_EXTENSIONS.items():
    for ext in exts:
        HARMONY_EXT_TO_LANG[ext.lower()] = lang

# ===================== 全局变量 =====================
# 格式：{文件路径: (语言, 行数)} - 仅--show-detail时填充
file_detail = {}
# 统计扫描的文件总数（无论是否--show-detail都统计）
file_count = 0

# ===================== 核心方法 =====================
def count_file_lines(file_path: str) -> int:
    """统计单个文件的非空行数（容错编码问题）"""
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            lines = [line for line in f.readlines() if line.strip()]
            return len(lines)
    except Exception as e:
        print(f"⚠️ 读取文件失败 {file_path}: {str(e)}")
        return 0

def count_harmony_project(project_path: str,
                          exclude_dirs: list = None,
                          include_langs: list = None,
                          show_detail: bool = False) -> tuple[dict, int, int]:
    """
    统计鸿蒙项目代码行数
    :param show_detail: 是否展示文件明细
    :return: (各语言行数字典, 总行数, 总文件数)
    """
    global file_detail, file_count
    file_detail.clear()  # 清空历史明细
    file_count = 0       # 重置文件数
    lang_lines = defaultdict(int)
    total_lines = 0

    # 合并排除目录
    final_exclude = HARMONY_DEFAULT_EXCLUDE.copy()
    if exclude_dirs:
        final_exclude.extend(exclude_dirs)
    exclude_abs = [os.path.abspath(os.path.join(project_path, d)) for d in final_exclude]

    # 仅在--show-detail时打印扫描提示
    if show_detail:
        print("\n开始扫描文件（鸿蒙项目）：")
        print("-" * 80)

    for root, dirs, files in os.walk(project_path):
        # 过滤排除目录
        dirs[:] = [d for d in dirs if os.path.abspath(os.path.join(root, d)) not in exclude_abs]

        for file in files:
            file_ext = os.path.splitext(file)[1].lower()
            lang = HARMONY_EXT_TO_LANG.get(file_ext)

            # 过滤非鸿蒙文件/指定语言
            if not lang or (include_langs and lang not in include_langs):
                continue

            # 统计文件行数
            file_path = os.path.abspath(os.path.join(root, file))
            lines = count_file_lines(file_path)

            # 累加文件数（核心：无论是否show_detail都统计）
            file_count += 1

            # 仅在--show-detail时记录明细并实时打印
            if show_detail:
                # 记录文件明细：路径 -> (语言, 行数)
                file_detail[file_path] = (lang, lines)
                # 实时打印扫描到的文件+行数（相对路径更易读）
                rel_path = os.path.relpath(file_path, project_path)
                print(f"✅ {rel_path:<60} | {lang:<8} | {lines:>4} 行")

            # 累加语言行数和总行数（始终执行）
            lang_lines[lang] += lines
            total_lines += lines

    # 仅在--show-detail时打印扫描结束分隔线
    if show_detail:
        print("-" * 80)

    return dict(lang_lines), total_lines, file_count

def print_file_detail_summary():
    """打印文件明细汇总（可选：按语言分组）"""
    if not file_detail:
        return
    print("\n文件明细汇总（按语言分组）：")
    print("-" * 80)
    # 按语言分组文件
    lang_files = defaultdict(list)
    for file_path, (lang, lines) in file_detail.items():
        lang_files[lang].append((file_path, lines))

    for lang, files in lang_files.items():
        print(f"\n【{lang}】共 {len(files)} 个文件：")
        for file_path, lines in files:
            rel_path = os.path.relpath(file_path, os.getcwd())
            print(f"  {rel_path:<60} | {lines:>4} 行")

def print_harmony_stats(lang_lines: dict, total_lines: int, file_count: int):
    """打印鸿蒙项目统计汇总（含占比+文件数）"""
    if total_lines == 0:
        print("\n未统计到鸿蒙项目相关代码")
        return

    print("\n" + "="*80)
    print("鸿蒙（HarmonyOS）项目代码行数汇总")
    print("="*80)
    # 按行数降序，ArkTS优先
    sorted_langs = sorted(lang_lines.items(),
                          key=lambda x: (x[0] != 'ArkTS', x[1]),
                          reverse=True)

    for lang, lines in sorted_langs:
        ratio = (lines / total_lines) * 100
        prefix = "⭐ " if lang == 'ArkTS' else "  "
        print(f"{prefix}{lang:<10}: {lines:>8,} 行 ({ratio:>5.1f}%)")

    print("-"*80)
    # 始终显示扫描文件数（核心修改点）
    print(f"总计:          {total_lines:>8,} 行 | 扫描文件数: {file_count} 个")
    print("="*80)

# ===================== 命令行入口 =====================
def main():
    parser = argparse.ArgumentParser(description='📱 鸿蒙项目代码行数统计工具（含文件明细）')
    parser.add_argument('project_path', help='鸿蒙项目根目录（如 ./my_harmony_app）')
    parser.add_argument('--exclude', nargs='*', default=[],
                        help='额外排除的目录（如 --exclude temp docs）')
    parser.add_argument('--include', nargs='*', default=[],
                        help='仅统计的鸿蒙语言（如 --include ArkTS Java）')
    parser.add_argument('--show-detail', action='store_true',
                        help='是否打印每个文件的详细行数（默认不打印）')

    args = parser.parse_args()

    # 验证路径
    if not os.path.isdir(args.project_path):
        print(f"错误：鸿蒙项目路径 {args.project_path} 不存在")
        return

    # 执行统计
    print(f"项目路径：{args.project_path}")
    print(f"排除目录：{HARMONY_DEFAULT_EXCLUDE + args.exclude}")
    print(f"统计语言：{args.include if args.include else '所有鸿蒙核心语言'}")

    # 接收返回的文件数（核心修改点）
    lang_lines, total_lines, file_count = count_harmony_project(
        project_path=args.project_path,
        exclude_dirs=args.exclude,
        include_langs=args.include,
        show_detail=args.show_detail
    )

    # 打印按语言分组的明细（仅在--show-detail时执行）
    if args.show_detail:
        print_file_detail_summary()

    # 传递文件数到汇总打印函数
    print_harmony_stats(lang_lines, total_lines, file_count)

if __name__ == '__main__':
    main()