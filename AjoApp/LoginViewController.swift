//
//  LoginViewController.swift
//  Ajo App
//
//  Created by mindcrewtechnologies on 23/02/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit
import RNCryptor
import CryptoSwift
extension Data {
    var hexDescription: String {
        return reduce("") {$0 + String(format: "%02x", $1)}
    }
}
extension String{
    func aesEncrypt(key: String, iv: String) throws -> String {
        let data = self.data(using: .utf8)!
        let encrypted = try! AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).encrypt([UInt8](data))
        let encryptedData = Data(encrypted)
        
        return encryptedData.base64EncodedString()
    }
    
    
    
    func aesDecrypt(key: String, iv: String) throws -> String {
        let data = Data(base64Encoded: self)!
        
        let decrypted = try! AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).decrypt([UInt8](data))
        let decryptedData = Data(decrypted)
        return String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
        
    }
}

class LoginViewController: UIViewController {
    @IBOutlet weak var BagroundView: UIView!
    
    @IBOutlet weak var termsview: UIView!
    
    @IBAction func ActionOnCancel(_ sender: Any) {
        self.termsview.isHidden = true
        self.BagroundView.isHidden = true
    }
    @IBOutlet weak var WebView: UIWebView!
    @IBOutlet weak var ScrollView: UIScrollView!
    var key = "ajoapp17mindcrew"
    var iv = "mindcrewajoapp17"
    var isurl1: NSString = NSString()
    var LoginId: NSString = NSString()
    var isurl: NSString = NSString()

    @IBOutlet weak var Password_txt: UITextField!
    @IBOutlet weak var Mobile_no_txt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.isurl1 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/webservices/login"
        self.isurl = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/webservices/insertdevicetoken"
        self.addDoneButtonOnKeyboard()
        
        // Do any additional setup after loading the view.
    }


   
    override func viewDidAppear(_ animated: Bool) {
        self.termsview.layer.shadowColor = UIColor.black.cgColor
        self.termsview.layer.shadowOpacity = 1
        self.termsview.layer.shadowOffset = CGSize.zero
        self.termsview.layer.shadowRadius = 10
        self.termsview.layer.cornerRadius = 4.0
        self.termsview.clipsToBounds = true
        let localfilePath = Bundle.main.url(forResource: "termsandcondition", withExtension: "html");
        let myRequest = NSURLRequest(url: localfilePath!);
        WebView.loadRequest(myRequest as URLRequest);

        self.navigationController?.isNavigationBarHidden = true
        
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
        Mobile_no_txt.inputAccessoryView = doneToolbar
        Password_txt.inputAccessoryView = doneToolbar
       
    }
    
    func doneButtonAction()
    {
       
            Mobile_no_txt.resignFirstResponder();
            Password_txt.resignFirstResponder();
        
    }

    

    @IBAction func ActiononForgetpassword(_ sender: Any) {
        
        let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginView:ForgetVarificationViewController = (story.instantiateViewController(withIdentifier: "ForgetVarificationViewController") as? ForgetVarificationViewController)!
        self.navigationController?.pushViewController(LoginView, animated: true)
    }
    
    @IBAction func ActionOntermsAndcondition(_ sender: Any) {
        self.termsview.isHidden = false
        self.BagroundView.isHidden = false
    }
    
    @IBAction func ActionOnLogin(_ sender: Any) {
        if self.Mobile_no_txt.text==""{
            let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Mobile field can't be empty", delegate: self, cancelButtonTitle: "Ok")
            Alert.show()
            
        }
        else if self.Password_txt.text==""{
            let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Password field can't be empty", delegate: self, cancelButtonTitle: "Ok")
            Alert.show()
            
        }
        else if self.Mobile_no_txt.text?.characters.count != 10  {
            let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Mobile  No field contain only ten digit", delegate: self, cancelButtonTitle: "Ok")
            Alert.show()
            
        }else{
        self.LoginRequst()
        }

    }
    @IBAction func ActionOnsignUp(_ sender: Any) {
        let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginView:SignupVerifyViewController = (story.instantiateViewController(withIdentifier: "SignupVerifyViewController") as? SignupVerifyViewController)!
        self.navigationController?.pushViewController(LoginView, animated: true)
    }
    
    
        func LoginRequst(){
            if Reachability.shared().internetConnectionStatus() == NotReachable {
                var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }else{
                let mob = self.Mobile_no_txt.text! as String
                let Mobile_no = try! mob.aesEncrypt(key: key, iv: iv)

            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification?.labelText = "Please wait"
            let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
            
            let Dictonary: NSMutableDictionary = NSMutableDictionary()
            let parameters = ["mobile_no": Mobile_no as String, "password": self.Password_txt.text!,"auth_token": token] as Dictionary<String, String>
            Dictonary.setObject(parameters, forKey : "login" as NSCopying)
                

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
                            if (status?.isEqual(to: "success"))! {
                                let loginid = json["loginid"] as? NSString
                                let email = json["email"] as? NSString
                                
                                let fname = json["fname"] as? NSString
                                let country_code = json["country_code"] as? NSString
                                let mobile_only = json["mobile_only"] as? NSString
                                let message = json["message"] as? NSString
                                let mobile_no = json["mobile_no"] as? NSString
                                let fnam = fname as! String
                                let desfname = try! fnam.aesDecrypt(key: self.key, iv: self.iv)
                                print(desfname) // foo

                                
                                let femail = email as! String
                                let desfemail = try! femail.aesDecrypt(key: self.key, iv: self.iv)
                                print(desfemail) // foo
                                
                               
                                
                                self.LoginId = (json["loginid"] as? NSString)!
                                UserDefaults.standard.set(loginid, forKey: "loginid")
                                UserDefaults.standard.set(email, forKey: "email")
                                UserDefaults.standard.set(status, forKey: "status")
                                UserDefaults.standard.set(fname, forKey: "fname")
                                UserDefaults.standard.set(country_code, forKey: "country_code")
                                UserDefaults.standard.set(mobile_only, forKey: "mobile_no")
                                UserDefaults.standard.set(message, forKey: "message")
                                UserDefaults.standard.set(mobile_only, forKey: "mobile_no")
                                UserDefaults.standard.set("YES", forKey: "LOGIN");
                                
                                 UserDefaults.standard.set(self.Password_txt.text, forKey: "PasswordSave")
                                 self.NotificatinService()
                                
                                
                                
                             }else{
                                let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Login failed. Incorrect password", delegate: self, cancelButtonTitle: "Ok")
                                Alert.show()
                                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                            }
                            
                            
                        }
                        
                       
                            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        })
                        // handle json...
                    }else{
                        DispatchQueue.main.async(execute: {
                            let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Login failed. Incorrect password", delegate: self, cancelButtonTitle: "Ok")
                            Alert.show()
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    })
                    
                    }
                    
                } catch let error {
                    self.isurl1 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/webservices/login"
                    self.LoginRequst()
                    print(error.localizedDescription)
                }
            })
            task.resume()
        }
    }
    func NotificatinService(){
        //deviceToken
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
            if Reachability.shared().internetConnectionStatus() == NotReachable {
                var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }else{
                
                let  deviceToken = (UserDefaults.standard.object(forKey: "deviceToken")as? NSString)!
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





    //Mark:- Web service Methods
    //Mark:- Web service Methods

    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }

    func createBodyWithParameters(_ parameters: [String: String]?, filePathKey: String?, boundary: String) -> Data {
        let body = NSMutableData();
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        body.appendString("--\(boundary)--\r\n")
        return body as Data
    }
    func createBodyWithParameters2(_ parameters: [String: String]?, filePathKey: String?, boundary: String) -> Data {
        let body = NSMutableData();
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        body.appendString("--\(boundary)--\r\n")
        return body as Data
    }
 

}
extension NSMutableData {
    
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

    

    
   
    
    

