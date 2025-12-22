/**
 * @fileName : SearchDemo.ets
 * @author : @cxy
 * @date : 2025/12/22
 * @description : 关键字搜索高亮demo
 */
import { SearchBar } from "./SearchBar";


interface ResultNode {
  text: string
  highlight: boolean // 该text是否需要高亮
}

interface ResultItem {
  nodes: ResultNode[]
}

@Component
export struct SearchDemo {
  @State results: ResultItem[] = []
  // 模拟源数据
  private sources: string[] = [
    "鸿蒙 ArkTS 开发实战",
    "HarmonyOS 搜索功能实现",
    "ArkTS 组件化开发教程",
    "搜索关键字高亮显示方案",
    "鸿蒙应用性能优化指南",
    "ArkUI 组件使用手册",
    "TypeScript 与 ArkTS 对比",
    "鸿蒙系统的搜索框组件封装",
    "如何实现高效的文本匹配",
    "ArkTS 状态管理最佳实践",
    "搜索结果的高亮渲染技巧"
  ];

  aboutToAppear(): void {
    // 默认显示全部
    this.onSearch('')
  }

  build() {
    Column() {
      SearchBar({
        onChanged: (text: string) => {
          this.onSearch(text.trim());
        }
      })

      List() {
        ForEach(
          this.results,
          (item: ResultItem) => {
            ListItem() {
              Text() {
                // 循环生成Span节点
                ForEach(item.nodes, (node: ResultNode) => {
                  Span(node.text)
                    .fontColor(node.highlight ? '#0073ff' : '#333')
                })
              }
              .fontSize(16)
            }
            .padding(10)
          },
          (items: ResultItem[], index: number) => JSON.stringify(items) + index
        )
      }
      .layoutWeight(1)
    }
    .padding(15)
    .width('100%')
    .height('100%')
  }

  onSearch(keyword: string) {
    this.results = [];

    // 筛选搜索，忽略大小写
    const lowerKeyword = keyword.toLowerCase();
    const matchedItems = lowerKeyword ? this.sources.filter((e) => {
      return e.toLowerCase().includes(lowerKeyword);
    }) : this.sources;

    // 处理匹配结果：拆分文本为高亮节点
    this.results = matchedItems.map((e) => {
      return {
        nodes: this.splitTextToNodes(e, keyword)
      } as ResultItem
    });
  }

  /**
   * 拆分文本为普通/高亮节点
   * @param text 文本
   * @param keyword 关键词
   * @returns 节点数组
   */
  private splitTextToNodes(text: string, keyword: string): ResultNode[] {
    const nodes: ResultNode[] = [];
    if (!keyword) {
      nodes.push({
        text: text,
        highlight: false
      });
      return nodes;
    }

    const lowerText = text.toLowerCase();
    const lowerKeyword = keyword.toLowerCase();
    let currentIndex = 0;
    let matchIndex = lowerText.indexOf(lowerKeyword);
    const keywordLength = keyword.length;

    // 循环查找所有匹配的关键字位置，拆分文本
    while (matchIndex !== -1) {
      // 1. 添加匹配位置前的文本
      if (matchIndex > currentIndex) {
        nodes.push({
          text: text.substring(currentIndex, matchIndex),
          highlight: false
        });
      }

      // 2. 添加匹配到的关键词
      nodes.push({
        text: text.substring(matchIndex, matchIndex + keywordLength),
        highlight: true
      });

      // 更新索引，继续查找下一个匹配
      currentIndex = matchIndex + keywordLength;
      matchIndex = lowerText.indexOf(lowerKeyword, currentIndex);
    }

    // 3. 添加最后文本
    if (currentIndex < text.length) {
      nodes.push({
        text: text.substring(currentIndex),
        highlight: false
      });
    }

    return nodes;
  }
}