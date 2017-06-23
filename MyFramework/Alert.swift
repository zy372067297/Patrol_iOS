//
//  Alert.swift
//  MyFramework
//
//  Created by JT on 2017/6/22.
//  Copyright © 2017年 JT. All rights reserved.
//

import Foundation
import UIKit

public func AlertWithNoButton(view : UIViewController, title : String? , message : String? , preferredStyle : UIAlertControllerStyle , showTime : TimeInterval){
    let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
    view.present(alert, animated: true, completion: nil)
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + showTime){
        view.presentedViewController?.dismiss(animated: false, completion: nil)
    }
}
