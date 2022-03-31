//
//  CollectionView.swift
//  PageCollection
//
//  Created by macmini on 2022/3/25.
//

import UIKit

// MARK: - Layout

class CollectionViewLayout: UICollectionViewFlowLayout {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    override init() {
        super.init()
        self.setup()
    }
    
    func setup() {
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = 4
        self.minimumInteritemSpacing = 4
        
        let itemWidth = (UIScreen.main.bounds.size.width - 3 * 4) / 4.0
        self.itemSize = CGSize(width: itemWidth, height: 100)
    }
}


// MARK: - View

class CollectionView: UIView {
    
    @IBOutlet weak var collectionV: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private let countOfPerPage = 8
    
    var dataSource: [Int] = [
        101, 102, 103, 104,
        105, 106, 107, 108,
        109, 110, 111, 112,
        113, 114, 115, 116,
        117, 118, 119
    ]
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup() {
        transformArray()
    }
    
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
}

extension CollectionView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(collectionV.contentOffset.x / UIScreen.main.bounds.width)
        let pages = dataSource.count / countOfPerPage
        let index = pageIndex % pages
        
        pageControl.currentPage = index
    }
}

extension CollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath)
        
        let label = cell.viewWithTag(2022) as! UILabel
        label.text = dataSource[indexPath.item] > 0 ? "\(dataSource[indexPath.item])" : nil
        
        return cell
    }
}





