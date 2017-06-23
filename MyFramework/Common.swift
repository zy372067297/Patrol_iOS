//
//  Common.swift
//  MyFramework
//
//  Created by JT on 2017/6/10.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

let kStatusBarHeight = 20
let kScreenWidth = UIScreen.main.bounds.width
let kScrennHeight = UIScreen.main.bounds.height
let kMainBottomTabBarHeight : CGFloat = 40

extension UIColor{
    convenience init(red : CGFloat, green : CGFloat, blue : CGFloat){
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}


