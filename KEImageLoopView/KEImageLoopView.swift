//
//  KEImageLoopView.swift
//  Carve
//
//  Created by Kenneth Zhang on 2016/12/22.
//  Copyright © 2016年 Kenneth Zhang. All rights reserved.
//

import UIKit
import WebImage

class KEImageLoopView: UIView {
    var collectionView: UICollectionView!
    var images = [String]()
    var pageControl: UIPageControl!
    var flowLayout = UICollectionViewFlowLayout()
    var interval: Int = 3
    var timer: Timer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews(frame: frame)
    }
    
    convenience init() {
        let frame = CGRect.zero
        self.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createViews(frame: CGRect) {
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: self.bounds,
                                          collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.register(KECollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
        self.addSubview(collectionView)
        
        pageControl = UIPageControl()
        self.addSubview(pageControl)
        
        self.setTimer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        flowLayout.itemSize = self.bounds.size
        collectionView.frame = self.bounds
        let newIndexPath = IndexPath(item: 1, section: 0)
        self.collectionView.scrollToItem(at: newIndexPath, at: .left, animated: false)
        let pageControlFrame = CGRect(x: 0, y: 0, width: self.bounds.width / 2, height: 30)
        pageControl.frame = pageControlFrame
        pageControl.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height - 20)
        pageControl.numberOfPages = images.count - 2
    }
    
    func setData() {
        let first = images.first
        let last = images.last
        images.insert(last!, at: 0)
        images.append(first!)
    }
    
    func setTimer() {
        timer = Timer(timeInterval: TimeInterval(interval), target: self, selector: #selector(KEImageLoopView.nextPage), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .commonModes)
    }
    
    func removeTimer() {
        self.timer.invalidate()
    }
    
    func getCurrentIndexPath() -> Int? {
        let currentCell = self.collectionView.indexPathsForVisibleItems.last
        let currentRow = currentCell?.row
        return currentRow
    }
    
    func nextPage() {
        var nextIndexPath: IndexPath
        if getCurrentIndexPath() == images.count - 2 {
            nextIndexPath = IndexPath(row: 1, section: 0)
        } else {
            nextIndexPath = IndexPath(row: getCurrentIndexPath()! + 1, section: 0)
        }
        self.collectionView.scrollToItem(at: nextIndexPath, at: .left, animated: true)
        self.pageControl.currentPage = nextIndexPath.row - 1
    }
}

extension KEImageLoopView: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetRight = self.collectionView.frame.width * CGFloat(images.count - 1)
        if scrollView.contentOffset.x >= contentOffsetRight {
            let newIndexPath = IndexPath(item: 1, section: 0)
            self.collectionView.scrollToItem(at: newIndexPath, at: .left, animated: false)
        } else if scrollView.contentOffset.x <= 0 {
            let newIndexPath = IndexPath(item: images.count-2, section: 0)
            self.collectionView.scrollToItem(at: newIndexPath, at: .left, animated: false)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.removeTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.setTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentX = self.collectionView.contentOffset.x
        var page: Int!
        if contentX >= self.bounds.width && contentX <= self.bounds.width * CGFloat(images.count - 2) {
            page = Int(contentX) / Int(self.bounds.width)
        } else if contentX < self.bounds.width {
            page = images.count - 2
        } else if contentX > self.bounds.width {
            page = 1
        }
        pageControl.currentPage = page - 1
    }
}

extension KEImageLoopView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath) as! KECollectionViewCell
        let url = images[indexPath.row]
        cell.imageView.sd_setImage(with: URL(string: url))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        setData()
        return images.count
    }
}
