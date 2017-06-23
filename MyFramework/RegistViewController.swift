//
//  RegistViewController.swift
//  MyFramework
//
//  Created by JT on 2017/6/22.
//  Copyright © 2017年 JT. All rights reserved.
//
import UIKit

class RegistViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passconfirm: UITextField!
    @IBOutlet weak var realname: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var organization: UITextField!
    @IBOutlet weak var department: UITextField!
    @IBOutlet weak var remark: UITextView!
    @IBOutlet weak var remarkPlaceholder: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.username.delegate = self
        self.password.delegate = self
        self.passconfirm.delegate = self
        self.realname.delegate = self
        self.phone.delegate = self
        self.organization.delegate = self
        self.department.delegate = self
        self.remark.delegate = self
    }
    
    @IBAction func viewClick(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func regist(_ sender: Any) {
        
        let user = self.username.text
        let pass = self.password.text
        let passConfirm = self.passconfirm.text
        let realName = self.realname.text
        let phoneNum = self.phone.text
        let organi = self.organization.text
        let depart = self.department.text
        let rema = self.remark.text
        
        if(!CheckInput(username: user!, password: pass!, passConfirm: passConfirm!, realname: realName!)){
            return
        }
        
        
        printLog(message: "Regist")
    }
    
    private func CheckInput(username : String, password : String, passConfirm : String, realname : String) -> Bool {
        if(username.isEmpty){
            AlertWithNoButton(view: self, title: "请输入新账号", message: nil, preferredStyle: .alert, showTime: 0.5)
            return false
        }
        if(password.isEmpty){
            AlertWithNoButton(view: self, title: "请输入密码", message: nil, preferredStyle: .alert, showTime: 0.5)
            return false
        }
        if(passConfirm.isEmpty){
            AlertWithNoButton(view: self, title: "请输入确认密码", message: nil, preferredStyle: .alert, showTime: 0.5)
            return false
        }
        if(password != passConfirm){
            AlertWithNoButton(view: self, title: "两次输入的密码不同", message: nil, preferredStyle: .alert, showTime: 0.5)
            return false
        }
        if(realname.isEmpty){
            AlertWithNoButton(view: self, title: "请输入姓名", message: nil, preferredStyle: .alert, showTime: 0.5)
            return false
        }
        return true
    }

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
        
}

extension RegistViewController : UITextViewDelegate , UITextFieldDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.remarkPlaceholder.isHidden = true
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(remark.text.isEmpty){
            self.remarkPlaceholder.isHidden = false
        } else {
            self.remarkPlaceholder.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let identifier = textField.accessibilityIdentifier
        if(identifier == "newuserIdentifier"){
            self.password.becomeFirstResponder()
        }else if(identifier == "passIdentifier"){
            self.passconfirm.becomeFirstResponder()
        }else if(identifier == "confirmPassIdentifier"){
            self.realname.becomeFirstResponder()
        }else if(identifier == "realnameIdentifier"){
            self.phone.becomeFirstResponder()
        }else if(identifier == "phoneIdentifier"){
            self.organization.becomeFirstResponder()
        }else if(identifier == "organizationIdentifier"){
            self.department.becomeFirstResponder()
        }else if(identifier == "departmentIdentifier"){
            self.department.resignFirstResponder()
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n"){
            self.view.endEditing(true)
            return false
        }
        return true
    }

    
    
    
}
