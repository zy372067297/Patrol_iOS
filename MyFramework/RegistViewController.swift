//
//  RegistViewController.swift
//  MyFramework
//
//  Created by JT on 2017/6/22.
//  Copyright © 2017年 JT. All rights reserved.
//
import UIKit

class RegistViewController: UIViewController , UITextFieldDelegate , UITextViewDelegate  {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passconfirm: UITextField!
    @IBOutlet weak var realname: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var organization: UITextField!
    @IBOutlet weak var department: UITextField!
    @IBOutlet weak var remark: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func viewClick(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func regist(_ sender: Any) {
        print("Regist button clicked")
    }

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
