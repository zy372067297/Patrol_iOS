//
//  LoginViewController.swift
//  MyFramework
//
//  Created by JT on 2017/6/14.
//  Copyright © 2017年 JT. All rights reserved.
//
import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        printLog(message: "System start")
        
        username.delegate = self
        password.delegate = self
        
        username.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let identifier = textField.accessibilityIdentifier
        if(identifier == "usernameIdentifier"){
            password.becomeFirstResponder()
        }else if(identifier == "passwordIdentifier"){
            loginClick(self)
        }
        return true
    }
    
    @IBAction func loginClick(_ sender: Any) {
        let user = username.text
        let pass = password.text
        
        if(!CheckInput(user: user!, pass: pass!)){
            return
        }

        let para = "username="+user!+"&password="+pass!
        
        login.isEnabled = false
        
        /*
        var urlRequest = URLRequest(url: URL(string: kLogin)!)
        urlRequest.timeoutInterval = TimeInterval(kTimeoutInterval)
        urlRequest.httpMethod = HttpMethod.Get.rawValue
        urlRequest.httpBody = para.data(using: String.Encoding.utf8)
       
        do{
             let autoreleasingunsafemutablepoint : AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
            _ = try NSURLConnection.sendSynchronousRequest(urlRequest, returning: autoreleasingunsafemutablepoint)
        }catch let er {
            print(er)
        }
         */
        
        self.present(MainViewController(), animated: true, completion: nil)
    }
    
    private func CheckInput(user : String, pass : String) -> Bool {
        if(user.isEmpty){
            AlertWithNoButton(view: self, title: "请输入账号", message: nil, preferredStyle: .alert, showTime: 0.5)
            return false
        }
        if(pass.isEmpty){
            AlertWithNoButton(view: self, title: "请输入密码", message: nil, preferredStyle: .alert, showTime: 0.5)
            return false
        }
        return true
    }

    
    @IBAction func settingClick(_ sender: Any) {
        printLog(message: "Setting")
    }
    
    @IBAction func registeClick(_ sender: Any) {

        let sb = UIStoryboard(name: "Regist", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "RegistViewController") 
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func forgetClick(_ sender: Any) {
        printLog(message: "Forget")
    }
}
