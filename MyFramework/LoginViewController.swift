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
    var isFirstApear: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        printLog(message: log_SystemStart)
        setupUI()
        setRememberedUserAndPass()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isFirstApear){
            autoLogin()
            isFirstApear = false
        }
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
        self.activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        let urlRequest = getLoginRequest(para: para)
        
        loginAsyncConnect(urlRequest: urlRequest, user: user, pass: pass)
    }
    
    fileprivate func loginAsyncConnect(urlRequest : URLRequest, user: String?, pass: String?){
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: OperationQueue.main, completionHandler: {(response : URLResponse?, data : Data?, error : Error?) -> Void in
            if let urlResponse = response{
                let httpResponse = urlResponse as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                if(statusCode != 200){
                    self.alertAndLog(msg: String(statusCode) + msg_HttpError, showTime: 0.5, log: String(statusCode) + msg_HttpError + url_Login)
                    return
                }
                if(error != nil){
                    self.alertAndLog(msg: msg_ConnectTimeout, showTime: 0.5, log: String(describing: error) + log_Login_LoginTimeout + url_Login)
                    return
                }
                if(data?.isEmpty)!{
                    self.alertAndLog(msg: msg_ServerNoResponse, showTime: 0.5, log: log_Login_ServerNoResponse + url_Login)
                    return
                }
                
                let json = JSON(data : data!)
                let nStatus = json["status"].int
                let nMsg = json["msg"].string
                let data = json["data"]
                
                if let status = nStatus{
                    if(status != 0){
                        if let msg = nMsg{
                            AlertWithNoButton(view: self, title: msg, message: nil, preferredStyle: .alert, showTime: 1)
                        }
                        
                        self.activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        
                        self.saveDefaultUsernamePassword(username: user!, password: "")
                        return
                    }
                    if data != JSON.null {
                        let id = data["id"].int
                        let realname = data["realname"].string
                        let username = data["username"].string
                        let portraiturl = data["portraiturl"].string
                        
                        loginUser = LoginUser()
                        loginUser?.id = id
                        loginUser?.realname = realname
                        loginUser?.username = username
                        loginUser?.protraiurl = portraiturl

                        self.activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        
                        self.saveDefaultUsernamePassword(username: user!, password: pass!)
                        self.present(MainViewController(), animated: true, completion: nil)
                    }else{
                        // running there must be webapi error
                    }
                }else{
                    // running there must be webapi error
                }
            }else{
                self.alertAndLog(msg: msg_ServerNoResponse, showTime: 0.5, log: log_Login_ServerNoResponse + url_Login)
                return
            }
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
    
    fileprivate func autoLogin(){
        let name = self.username.text
        let pass = self.password.text
        if(!(name?.isEmpty)! && !(pass?.isEmpty)!){
            loginClick(self)
        }
    }
    
    fileprivate func getLoginRequest(para: String) -> URLRequest{
        var urlRequest = URLRequest(url: URL(string: url_Login)!)
        urlRequest.timeoutInterval = TimeInterval(kShortTimeoutInterval)
        urlRequest.httpMethod = HttpMethod.Post.rawValue
        urlRequest.httpBody = para.data(using: String.Encoding.utf8)
        urlRequest.httpShouldHandleCookies = true
        return urlRequest
    }
    
    fileprivate func alertAndLog(msg: String, showTime: TimeInterval, log: String){
        AlertWithNoButton(view: self, title: msg, message: nil, preferredStyle: .alert, showTime: showTime)
        printLog(message: log)
        
        self.activity.stopAnimating()
        self.view.isUserInteractionEnabled = true
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
    }
    
    fileprivate func saveDefaultUsernamePassword(username : String, password : String){
        let sql = getInsertOrReplaceSql(username: username, password: password)
        if(!SQLiteManager.instance.executeSQL(sql: sql)){
            printLog(message: log_Login_InsertOrReplaceUsernamePasswordError)
            exit(0)
        }
    }
}
