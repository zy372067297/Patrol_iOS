//
//  LoginViewController.swift
//  MyFramework
//
//  Created by JT on 2017/6/14.
//  Copyright © 2017年 JT. All rights reserved.
//
import UIKit
import SwiftyJSON

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    
    var activity : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        printLog(message: log_SystemStart)
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setRememberedUserAndPass()
    }
    
    @IBAction func loginClick(_ sender: Any) {
        loginButtonClick()
    }
    
    @IBAction func settingClick(_ sender: Any) {
        printLog(message: "Setting")
    }
    
    @IBAction func registeClick(_ sender: Any) {
        registeButtonClick()
    }
    
    @IBAction func forgetClick(_ sender: Any) {
        printLog(message: "Forget")
    }
}

//ui
extension LoginViewController{
    
    fileprivate func setupUI(){
        username.delegate = self
        password.delegate = self
        
        activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activity.center = login.center
        self.view.addSubview(activity)
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
}

//event
extension LoginViewController{
    
    fileprivate func loginButtonClick(){
        let user = username.text
        let pass = password.text
        
        if(!checkInput(user: user!, pass: pass!)){
            return
        }
        
        let para = "username="+user!+"&password="+pass!
        
        login.isEnabled = false
        
        var urlRequest = URLRequest(url: URL(string: kLogin)!)
        urlRequest.timeoutInterval = TimeInterval(kShortTimeoutInterval)
        urlRequest.httpMethod = HttpMethod.Post.rawValue
        urlRequest.httpBody = para.data(using: String.Encoding.utf8)
        urlRequest.httpShouldHandleCookies = true
        
        activity.startAnimating()
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: OperationQueue.main, completionHandler: {(response : URLResponse?, data : Data?, error : Error?) -> Void in
            if(error != nil){
                AlertWithNoButton(view: self, title: msg_ConnectTimeout, message: nil, preferredStyle: .alert, showTime: 0.5)
                printLog(message: String(describing: error) + log_Login_LoginTimeout + kLogin)
                self.activity.stopAnimating()
                self.login.isEnabled = true
                return
            }
            if(data?.isEmpty)!{
                AlertWithNoButton(view: self, title: msg_ServerNoResponse, message: nil, preferredStyle: .alert, showTime: 0.5)
                printLog(message: log_Login_ServerNoResponse + kLogin)
                self.activity.stopAnimating()
                self.login.isEnabled = true
                return
            }
            let json = JSON(data : data!)
            let status = json["status"].int32Value
            let msg = json["msg"].string
            let _ = json["data"]
            
            if(status != 0){
                AlertWithNoButton(view: self, title: msg, message: nil, preferredStyle: .alert, showTime: 1)
                self.activity.stopAnimating()
                self.login.isEnabled = true
                self.saveDefaultUsernamePassword(username: user!, password: "")
                return
            }
            
            self.activity.stopAnimating()
            self.login.isEnabled = true
            
            self.saveDefaultUsernamePassword(username: user!, password: pass!)
            
            self.present(MainViewController(), animated: true, completion: nil)
        })
    }
    
    fileprivate func registeButtonClick(){
        let sb = UIStoryboard(name: "Regist", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "RegistViewController")
        self.present(vc, animated: true, completion: nil)
    }
}

//func
extension LoginViewController{
    
    fileprivate func checkInput(user : String, pass : String) -> Bool {
        if(user.isEmpty){
            AlertWithNoButton(view: self, title: msg_PleaseEnterUsername, message: nil, preferredStyle: .alert, showTime: 0.5)
            username.becomeFirstResponder()
            return false
        }
        if(pass.isEmpty){
            AlertWithNoButton(view: self, title: msg_PleaseEnterPassword, message: nil, preferredStyle: .alert, showTime: 0.5)
            password.becomeFirstResponder()
            return false
        }
        return true
    }
}

//db
extension LoginViewController{
    
    fileprivate func setRememberedUserAndPass(){
        let user = SQLiteManager.instance.queryUser(sql: kSql_SelectUserTableLast)
        if(user.isEmpty){
            self.username.becomeFirstResponder()
            return
        }
        let name = user[0].username
        let pass = user[0].password
        
        self.username.text = name
        self.password.text = pass
        if(!(name?.isEmpty)! && !(pass?.isEmpty)!){
            loginClick(self)
        }
    }
    
    fileprivate func saveDefaultUsernamePassword(username : String, password : String){
        let sql = getInsertOrReplaceSql(username: username, password: password)
        if(!SQLiteManager.instance.executeSQL(sql: sql)){
            printLog(message: log_Login_InsertOrReplaceUsernamePasswordError)
            exit(0)
        }
    }
}
