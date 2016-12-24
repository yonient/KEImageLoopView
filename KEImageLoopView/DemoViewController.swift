//
//  ViewController.swift
//  KEImageLoopView
//
//  Created by Kenneth Zhang on 2016/12/24.
//  Copyright © 2016年 Kenneth Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var scrollView: KEImageLoopView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let images = ["https://pic2.zhimg.com/0ee1402a2f68d18d9a56fae84694d681.jpg", "https://pic2.zhimg.com/ec8ab8e38c19ab413e2994c9add0c891.jpg", "https://pic1.zhimg.com/efcf9cb0f0c2f2a2c199d99028ac0ab0.jpg", "https://pic3.zhimg.com/b653d9f7145e4044520146b965d840ea.jpg", "https://pic1.zhimg.com/d08ab4fe12871da9f064e4534a398edc.jpg"]
        
        self.automaticallyAdjustsScrollViewInsets = false
        let imageViewFrame = CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: 150)
        self.scrollView = KEImageLoopView(frame: imageViewFrame)
        self.scrollView.images = images
        self.view.addSubview(self.scrollView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

