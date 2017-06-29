//
//  Alert.swift
//  MyFramework
//
//  Created by JT on 2017/6/22.
//  Copyright © 2017年 JT. All rights reserved.
//

import Foundation
import UIKit

let msg_PleaseEnterNewUsername = "输入新账号"
let msg_PleaseEnterUsername = "请输入账号"
let msg_PleaseEnterPassword = "请输入密码"
let msg_PleaseEnterConfirmPassword = "请输入确认密码"
let msg_PasswordDifferentBetweenInputs = "两次输入的密码不同"
let msg_PleastEnterRealname = "请输入姓名"
let msg_ConnectTimeout = "连接超时"
let msg_PleaseCheckNetworkSetting = "请检查网络设置"
let msg_ServerNoResponse = "服务器未响应"


public func AlertWithNoButton(view : UIViewController, title : String? , message : String? , preferredStyle : UIAlertControllerStyle , showTime : TimeInterval){
    let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
    view.present(alert, animated: true, completion: nil)
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + showTime){
        view.presentedViewController?.dismiss(animated: false, completion: nil)
    }
}
