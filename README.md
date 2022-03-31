# CollectionView-PageControl

CollectionView+PageControl 实现 UICollectionView 横向整页滑动，并实现 Cell 从左至右、从上向下的顺序排列。并使用 UIPageControl 配合显示当前页所处位置。
   
   
## 效果预览：
![image](https://github.com/once-liu/CollectionView-PageControl/blob/main/Source/preview.gif)
   
   
## 功能实现：
- 横向\
  设置 `scrollDirection` 为 `horizontal` 即可。
- 整页\
  设置 `isPagingEnabled` 为 `true` 即可。
- 从左至右、从上向下顺序排列\
  当 UICollectionView 横向滑动时，其 Cell 的排列为从上向下、从左至右，如下图所示：\
  ![image](https://github.com/once-liu/CollectionView-PageControl/blob/main/Source/normal.jpg)
     
  此时，通过调整数据源中元素的位置，实现 Cell 的排列为从左至右、从上向下，如下图所示：\
  ![image](https://github.com/once-liu/CollectionView-PageControl/blob/main/Source/correct.jpg)
   
   
## 说明
- UI 不是重点，使用 StoryBoard 快速搭建
- Demo 中调整下标的 `map` 只支持`两行四列`的布局，使用其他布局样式，请调整 `map` 数据
   
   
## 主要实现
Demo 实现功能的主要实现是以下两个方法。主要思路是：
1. 计算出数据可以展示几页
2. 把这几页数据全部填充，比如填充 0，填充的数据可不展示\
   不填充数据，`Paging Enabled` 效果无法实现。
3. 调整数据源中元素的位置，使其在从上向下、从左至右布局下，实现从左至右、从上向下效果
     
```
    func transformArray() {
        var pageCount = dataSource.count / countOfPerPage
        if (dataSource.count % countOfPerPage) > 0 {
            pageCount += 1
        }
        pageControl?.numberOfPages = pageCount
        
        let subCount = pageCount * countOfPerPage - dataSource.count
        let tempArray = NSMutableArray.init(array: dataSource)
        for _ in 0...subCount {
            tempArray.add(0)
        }
        dataSource = tempArray.copy() as! [Int]
        tempArray.removeAllObjects()
        
        for page in 0..<pageCount {
            for index in 0..<countOfPerPage {
               let newIndex = transformIndex(index) + page * countOfPerPage
                tempArray.add(dataSource[newIndex])
            }
        }
        dataSource = tempArray.copy() as! [Int]
        tempArray.removeAllObjects()
    }
    
    // 调整 index。key 为 indexPath.item，value 为调整后 index
    func transformIndex(_ index: Int) -> Int {
        let map = [
            0: 0,
            1: 4,
            2: 1,
            3: 5,
            4: 2,
            5: 6,
            6: 3,
            7: 7
        ]
        
        return map[index] ?? 0
    }
```

