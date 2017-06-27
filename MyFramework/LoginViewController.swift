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
        
        printLog(message: log_SystemStart)
        
        username.delegate = self
        password.delegate = self
        
        //username.becomeFirstResponder()
        setup()
    }
    
    func setup(){
        setRememberedUserAndPass()
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
        
        HTTPCookieStorage.shared.cookieAcceptPolicy = .always
        //let cookies = HTTPCookieStorage.shared.cookies
        //let str = HTTPCookie.requestHeaderFields(with: cookies!)
        
        var urlRequest = URLRequest(url: URL(string: kLogin)!)
        urlRequest.timeoutInterval = TimeInterval(kTimeoutInterval)
        urlRequest.httpMethod = HttpMethod.Post.rawValue
        urlRequest.httpBody = para.data(using: String.Encoding.utf8)
        urlRequest.httpShouldHandleCookies = true
        //urlRequest.allHTTPHeaderFields = str
       
        do{
            let autoreleasingunsafemutablepoint : AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
            let _ = try NSURLConnection.sendSynchronousRequest(urlRequest, returning: autoreleasingunsafemutablepoint)
            //let cookies = HTTPCookieStorage.shared.cookies

            
            var x = URLRequest(url: URL(string: "http://192.168.1.122/test/api/user/logout")!)
            x.timeoutInterval = TimeInterval(kTimeoutInterval)
            x.httpMethod = HttpMethod.Post.rawValue
            x.httpBody = "id=1".data(using: String.Encoding.utf8)
            x.httpShouldHandleCookies = true
            let test : AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
            let _ = try NSURLConnection.sendSynchronousRequest(x, returning: test)
            let t = HTTPCookieStorage.shared.cookies
            
  
        }catch let er {
            login.isEnabled = true
            printLog(message: er)
        }
        
        login.isEnabled = true
        self.present(MainViewController(), animated: true, completion: nil)
    }
    
    private func CheckInput(user : String, pass : String) -> Bool {
        if(user.isEmpty){
            AlertWithNoButton(view: self, title: msg_PleaseEnterUsername, message: nil, preferredStyle: .alert, showTime: 0.5)
            return false
        }
        if(pass.isEmpty){
            AlertWithNoButton(view: self, title: msg_PleaseEnterPassword, message: nil, preferredStyle: .alert, showTime: 0.5)
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

extension LoginViewController{
    
    func setRememberedUserAndPass(){
        let user = SQLiteManager.instance.query(sql: kSql_SelectUserTableLast)
        if(user.isEmpty){
            return
        }
        let name = user[0].username
        let pass = user[0].password
        
        self.username.text = name
        self.password.text = pass
    }
    
}
