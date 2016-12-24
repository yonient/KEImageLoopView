//
//  KECollectionViewCell.swift
//  Carve
//
//  Created by Kenneth Zhang on 2016/12/22.
//  Copyright © 2016年 Kenneth Zhang. All rights reserved.
//

import UIKit

class KECollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createViews(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implementecd")
    }
    
    func createViews(frame: CGRect) {
        let imageViewFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        imageView = UIImageView(frame: imageViewFrame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        self.contentView.addSubview(imageView)
    }
}
