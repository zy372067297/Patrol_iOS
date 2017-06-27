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

let kDateTimeFormate = "yyyy-MM-dd HH:mm:ss"

extension UIColor{
    convenience init(red : CGFloat, green : CGFloat, blue : CGFloat){
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}


let kDBName = "appDB.sqlite"

let kTableName_User = "T_User"
let kSql_CreateUserTable = "CREATE TABLE IF NOT EXISTS '" + kTableName_User + "' ( 'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'user' TEXT,'pass' TEXT);"
let kSql_SelectUserTableLast = "select * from '" + kTableName_User + "' order by id desc limit 1"



