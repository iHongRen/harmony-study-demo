/**
 * @fileName : BaseDataSource.ets
 * @author : @cxy
 * @date : 2025/12/19
 * @description : 文件描述
 */

export abstract class BaseDataSource<T> implements IDataSource {
  private listeners: DataChangeListener[] = []

  public abstract totalCount(): number

  public abstract getData(index: number): T

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener)
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataChangeAll(): void {
    const total = this.totalCount()
    for (let i = 0; i < total; i++) {
      this.notifyDataChange(i)
    }
  }

  notifyDataAdd(index: number, count: number = 1): void {
    this.notifyDatasetChange([{ type: DataOperationType.ADD, index: index, count: count }])
  }

  notifyDataChange(index: number, key?: string): void {
    this.notifyDatasetChange([{ type: DataOperationType.CHANGE, index: index, key: key }])
  }

  notifyDataDelete(index: number, count: number = 1): void {
    this.notifyDatasetChange([{ type: DataOperationType.DELETE, index: index, count: count }])
  }

  notifyDataMove(from: number, to: number): void {
    this.notifyDatasetChange([{ type: DataOperationType.MOVE, index: { from: from, to: to } }])
  }

  notifyDatasetChange(operations: DataOperation[]): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange(operations);
    })
  }

  notifyDataReload() {
    this.notifyDatasetChange([{ type: DataOperationType.RELOAD }])
  }
}