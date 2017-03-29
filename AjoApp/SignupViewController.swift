//
//  SignupViewController.swift
//  Ajo App
//
//  Created by mindcrewtechnologies on 23/02/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var Webview: UIWebView!
    @IBOutlet weak var Mobile_no_lbl: UILabel!
    @IBOutlet weak var Password_Txt: UITextField!
    @IBOutlet weak var Firstname_txt: UITextField!
    @IBOutlet weak var Email_txt: UITextField!
    var key = "ajoapp17mindcrew"
    var iv = "mindcrewajoapp17"
    var phoneNumber: NSString = NSString()
    var CCode: NSString = NSString()
    var isurl1: NSString = NSString()
    var isurl: NSString = NSString()
    var LoginId: NSString = NSString()
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.TermsView.layer.shadowColor = UIColor.black.cgColor
        self.TermsView.layer.shadowOpacity = 1
        self.TermsView.layer.shadowOffset = CGSize.zero
        self.TermsView.layer.shadowRadius = 10
        self.TermsView.layer.cornerRadius = 4.0
        self.TermsView.clipsToBounds = true
        let localfilePath = Bundle.main.url(forResource: "termsandcondition", withExtension: "html");
        let myRequest = NSURLRequest(url: localfilePath!);
        Webview.loadRequest(myRequest as URLRequest);
        
        self.isurl = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/webservices/insertdevicetoken"
        self.Email_txt.attributedPlaceholder = NSAttributedString(string:"Email",attributes:[NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12)])
        self.Password_Txt.attributedPlaceholder = NSAttributedString(string:"Password",attributes:[NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12)])
        self.Firstname_txt.attributedPlaceholder = NSAttributedString(string:"Full Name",attributes:[NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12)])
        phoneNumber = (UserDefaults.standard.object(forKey: "phoneNumber")as? NSString)!
        CCode = (UserDefaults.standard.object(forKey: "CCode")as? NSString)!
        self.Mobile_no_lbl.text = (UserDefaults.standard.object(forKey: "MOBNO")as? NSString)! as String
        self.addDoneButtonOnKeyboard()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isurl1 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/webservices/signup"

        self.addDoneButtonOnKeyboard()
        // Do any additional setup after loading the view.
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(LoginViewController.doneButtonAction))
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        Firstname_txt.inputAccessoryView = doneToolbar
        Password_Txt.inputAccessoryView = doneToolbar
        Email_txt.inputAccessoryView = doneToolbar
        
    }
    //CHECK EMAIL ID VLAIDATION
    
    func isValidEmail(_ email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    
    @IBAction func ActionOnterms(_ sender: Any) {
        Firstname_txt.resignFirstResponder();
        Password_Txt.resignFirstResponder();
        Email_txt.resignFirstResponder();
        self.TermsView.isHidden = false
        self.BacgroundView.isHidden = false
    }
    @IBOutlet weak var BacgroundView: UIView!
    @IBOutlet weak var TermsView: UIView!
    @IBAction func ActionOnCancel(_ sender: Any) {
        self.TermsView.isHidden = true
        self.BacgroundView.isHidden = true
    }
    
    func doneButtonAction()
    {
        
        Firstname_txt.resignFirstResponder();
        Password_Txt.resignFirstResponder();
        Email_txt.resignFirstResponder();
        
    }

    @IBAction func ActionOnsignUp(_ sender: Any) {
        
        Firstname_txt.resignFirstResponder();
        Password_Txt.resignFirstResponder();
        Email_txt.resignFirstResponder();
        if Firstname_txt.text!.isEmpty {
            
            let alertView = UIAlertView(
                title: "Alert",
                message: "please enter name",
                delegate: self,
                cancelButtonTitle: "OK"
            )
            alertView.show()
        }else if Email_txt.text!.isEmpty {
            let alertView = UIAlertView(
                title: "Alert",
                message: "please enter email id",
                delegate: self,
                cancelButtonTitle: "OK"
            )
            alertView.show()
        }else if !self.isValidEmail(Email_txt.text!) {
            let alertView = UIAlertView(
                title: "Alert",
                message: "please enter valid email id",
                delegate: self,
                cancelButtonTitle: "OK"
            )
            alertView.show()
        }else if Password_Txt.text!.isEmpty {
            let alertView = UIAlertView(
                title: "Alert",
                message: "please enter password",
                delegate: self,
                cancelButtonTitle: "OK"
            )
            alertView.show()
        }else if  Password_Txt.text!.characters.count < 8 {
            let alertView = UIAlertView(
                title: "Alert",
                message: "password should be 8 digit long",
                delegate: self,
                cancelButtonTitle: "OK"
            )
            alertView.show()
        }else {
            if  let isValid : Bool = self.containsValidPassword(Password_Txt.text!) {
                if isValid {
                    //[self gotoActivityController];
                    print("valid")
                    self.SignupRequst()
                }
                else {
                    let alertView = UIAlertView(
                        title: "Alert",
                        message: "Password must contain atleast one upper case character",
                        delegate: self,
                        cancelButtonTitle: "OK"
                    )
                    alertView.show()
                }
                
            }
        }
        
        
    }
    func containsValidPassword(_ strText: String) -> Bool? {
        let pattern: String = "^.*(?=.*[A-Z]).*$"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: (strText.characters.count ))
        return (regex?.numberOfMatches(in: strText, options: [], range: range))! > 0
    }
    func SignupRequst(){
        
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
            
            let fnamestr = self.Firstname_txt.text! as String
            let fname = try! fnamestr.aesEncrypt(key: key, iv: iv)
            print(fname)
            
            
            let strphone = self.phoneNumber as String
            let mobile_no = try! strphone.aesEncrypt(key: key, iv: iv)
            print(mobile_no)
            
            let stremail = self.self.Email_txt.text! as String
            let email = try! stremail.aesEncrypt(key: key, iv: iv)
            print(email)

        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.labelText = "Please wait"
        let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
    
        let Dictonary: NSMutableDictionary = NSMutableDictionary()
        let parameters = ["fname": fname as String, "email": email as String,"password": self.Password_Txt.text!,"country_code": CCode as String,"mobile_no": mobile_no as String,"auth_token": token] as Dictionary<String, String>
        Dictonary.setObject(parameters, forKey : "signup" as NSCopying)
        
        //create the url with URL
        let url = URL(string: self.isurl1 as String)! //change the url
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: Dictonary, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            
        } catch let error {
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    DispatchQueue.main.async(execute: {
                        if (json as? NSDictionary) != nil{
                            var status = json["status"] as? NSString
                            var message = json["message"] as? NSString
                            if (status?.isEqual(to: "success"))! {
                                
                                let loginid = (json["loginid"] as AnyObject).int32Value;
                                let int: Int = Int(loginid!)
                                let isloginid = String(int)
                                UserDefaults.standard.set(isloginid, forKey: "loginid")
                                let email = json["email"] as? NSString
                                
                                let fname = json["fname"] as? NSString
                                let country_code = json["country_code"] as? NSString
                                //let mobile_only = json["mobile_only"] as? NSString
                                let message = json["message"] as? NSString
                                let mobile_no = json["mobile_no"] as? NSString
                                
                    
                                print(loginid)
                                self.LoginId = isloginid as String as NSString
                                
                                UserDefaults.standard.set(email, forKey: "email")
                                UserDefaults.standard.set(status, forKey: "status")
                                UserDefaults.standard.set(fname, forKey: "fname")
                                UserDefaults.standard.set(country_code, forKey: "country_code")
                                //UserDefaults.standard.set(mobile_only, forKey: "mobile_only")
                                UserDefaults.standard.set(message, forKey: "message")
                                
                               // mobile_no
                                UserDefaults.standard.set(mobile_no, forKey: "mobile_no")
                                UserDefaults.standard.set("YES", forKey: "LOGIN");
                                UserDefaults.standard.set(self.Password_Txt.text, forKey: "PasswordSave")
                               self.NotificatinService()
                                
                            }else{
                                
                                let Alert:UIAlertView = UIAlertView(title: "Alert", message: message as String?, delegate: self, cancelButtonTitle: "Ok")
                                Alert.show()
                                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                            }
                            
                            
                        }
                        
                        
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    })
                    // handle json...
                }else{
                    DispatchQueue.main.async(execute: {
                        //var status = json["status"] as? NSString

                        let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Email Id already registered!", delegate: self, cancelButtonTitle: "Ok")
                        Alert.show()
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    })
                    
                }
                
            } catch let error {
                 self.isurl1 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/webservices/signup"
                 self.SignupRequst()
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    }

    
    
    @IBAction func Actiononback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func NotificatinService(){
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
            if Reachability.shared().internetConnectionStatus() == NotReachable {
                var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }else{
                //let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                // loadingNotification?.labelText = "Please wait"
                var  deviceToken = ""
                if (UserDefaults.standard.object(forKey: "deviceToken") != nil) {
                    deviceToken = (UserDefaults.standard.object(forKey: "deviceToken")as? NSString)! as String
                }
                let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
                
                let Dictonary: NSMutableDictionary = NSMutableDictionary()
                let parameters = ["customer_id": LoginId as String,"device_token": deviceToken as String,"device_type":"ios","auth_token": token] as Dictionary<String, String>
                Dictonary.setObject(parameters, forKey : "pushnotifydata" as NSCopying)
                
                //create the url with URL
                let url = URL(string:self.isurl as String)! //change the url
                
                //create the session object
                let session = URLSession.shared
                
                //now create the URLRequest object using the url object
                var request = URLRequest(url: url)
                request.httpMethod = "POST" //set http method as POST
                
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: Dictonary, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
                    
                } catch let error {
                    print(error.localizedDescription)
                }
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                //create dataTask using the session object to send data to the server
                let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                    
                    guard error == nil else {
                        return
                    }
                    
                    guard let data = data else {
                        return
                    }
                    
                    do {
                        //create json object from data
                        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                            print(json)
                            DispatchQueue.main.async(execute: {
                                if (json as? NSDictionary) != nil{
                                    
                                    var status = json["status"] as? NSString
                                    if (status?.isEqual(to: "success"))! {
                                        let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                        let LoginView:KYDrawerController = (story.instantiateViewController(withIdentifier: "KYDrawerController") as? KYDrawerController)!
                                        self.navigationController?.pushViewController(LoginView, animated: true)
                                    }else{
                                        let Alert:UIAlertView = UIAlertView(title: "Alert", message: "NO date Found", delegate: self, cancelButtonTitle: "Ok")
                                        
                                        
                                        
                                    }
                                    
                                    
                                }
                                
                                
                            })
                            // handle json...
                        }else{
                            DispatchQueue.main.async(execute: {
                                
                            })
                            
                        }
                        
                    } catch let error {
                        self.isurl = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/webservices/insertdevicetoken"
                        
                        self.NotificatinService()
                        print(error.localizedDescription)
                    }
                })
                task.resume()
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
