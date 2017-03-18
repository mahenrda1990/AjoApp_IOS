//
//  MyprofileViewController.swift
//  Ajo App
//
//  Created by mindcrewtechnologies on 23/02/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class MyprofileViewController: UIViewController {

    @IBOutlet weak var Updatebtnout: UIButton!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var ratinglbl: UILabel!
    var key = "ajoapp17mindcrew"
    var iv = "mindcrewajoapp17"
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var BagroundView: UIView!
    @IBOutlet weak var Label3: UILabel!
    @IBOutlet weak var Conf_pass_txt: UITextField!
    @IBOutlet weak var Label2: UILabel!
    @IBOutlet weak var New_pass_txt: UITextField!
    @IBOutlet weak var Old_txt: UITextField!
    var LoginId: NSString = NSString()
    var swappayout: NSString = NSString()
    var oldtxt: NSString = NSString()
    var isurl1: NSString = NSString()
    var isurl2: NSString = NSString()
    var isurl3: NSString = NSString()
    @IBOutlet weak var mySwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isurl1 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/myprofile"
        self.isurl2 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/updateprofile"
        self.isurl3 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/updateswapswitch"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        self.BagroundView.addGestureRecognizer(tapGesture)
        self.addDoneButtonOnKeyboard()
       // self.Old_txt.isEditing = false
        // Do any additional setup after loading the view.
    }
   
    @IBAction func ActionOnUpdate(_ sender: Any) {
        if Old_txt.text==""{
            let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Password field can't be empty", delegate: self, cancelButtonTitle: "Ok")
            Alert.show()
            
        }else if New_pass_txt.text==""{
                let Alert:UIAlertView = UIAlertView(title: "Alert", message: " Password field can't be empty", delegate: self, cancelButtonTitle: "Ok")
                Alert.show()
                
        }else if Conf_pass_txt.text==""{
            let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Confirm Password field can't be empty", delegate: self, cancelButtonTitle: "Ok")
            Alert.show()
            
        }else if (New_pass_txt.text != Conf_pass_txt.text)  {
                let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Password Not Match", delegate: self, cancelButtonTitle: "Ok")
                Alert.show()
        }else if (Old_txt.text != oldtxt as String)  {
            let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Old Password Not Match", delegate: self, cancelButtonTitle: "Ok")
            Alert.show()
        }else if  New_pass_txt.text!.characters.count < 8 {
            let alertView = UIAlertView(
                title: "Alert",
                message: "password should be 8 digit long",
                delegate: self,
                cancelButtonTitle: "OK"
            )
            alertView.show()
        }else{
            if  let isValid : Bool = self.containsValidPassword(New_pass_txt.text!) {
                if isValid {
                    //[self gotoActivityController];
                    print("valid")
                     Updatepassword()
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
    
    override func viewDidAppear(_ animated: Bool) {
          self.navigationController?.isNavigationBarHidden = true
        LoginId = (UserDefaults.standard.object(forKey: "loginid")as? NSString)!
        self.Old_txt.attributedPlaceholder = NSAttributedString(string:"Old Password",attributes:[NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12)])
        
        self.New_pass_txt.attributedPlaceholder = NSAttributedString(string:"Password",attributes:[NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12)])
        self.Conf_pass_txt.attributedPlaceholder = NSAttributedString(string:"Confirm Password",attributes:[NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12)])
         self.Old_txt.text = (UserDefaults.standard.object(forKey: "PasswordSave")as? NSString)! as String
         oldtxt = (UserDefaults.standard.object(forKey: "PasswordSave")as? NSString)! as String as String as NSString
        self.Old_txt.isUserInteractionEnabled = false
        self.Updatebtnout.isUserInteractionEnabled = false
        self.MyProfile()
    }
    func tapBlurButton(_ sender: UITapGestureRecognizer) {
        self.ContentView.isHidden = true
        self.BagroundView.isHidden = true
    }
    
    
    @IBAction func ActionOnOk(_ sender: Any) {
        self.ContentView.isHidden = true
        self.BagroundView.isHidden = true
    }
    @IBAction func ActionOnEdit(_ sender: Any) {
         self.Conf_pass_txt.isHidden = false
         self.New_pass_txt.isHidden = false
         self.Old_txt.isUserInteractionEnabled = true
         self.Updatebtnout.isUserInteractionEnabled = true
        //Updatebtnout
        
         self.Old_txt.text = ""
         self.Label2.isHidden = false
         self.Label3.isHidden = false
    }
    @IBAction func ActionOnswitch(_ sender: Any) {
        if mySwitch.isOn == true{
            self.swappayout = "true"
            SwtchWebservice()
           //onCall()
        }
        if mySwitch.isOn == false{
            self.swappayout = "false"
            SwtchWebservice()
          //  offCall()
        }
    }
    
        @IBAction func ActionOnTotorial(_ sender: Any) {
        self.ContentView.isHidden = false
        self.BagroundView.isHidden = false
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
        Conf_pass_txt.inputAccessoryView = doneToolbar
        New_pass_txt.inputAccessoryView = doneToolbar
        Old_txt.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        
        Conf_pass_txt.resignFirstResponder();
        New_pass_txt.resignFirstResponder();
        Old_txt.resignFirstResponder();
        
    }

    @IBAction func ActionOnclose(_ sender: Any) {
        let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginView:KYDrawerController = (story.instantiateViewController(withIdentifier: "KYDrawerController") as? KYDrawerController)!
        self.navigationController?.pushViewController(LoginView, animated: true)
    }
    func MyProfile(){
        
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.labelText = "Please wait"
        let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
        
        let Dictonary: NSMutableDictionary = NSMutableDictionary()
        let parameters = ["customer_id": LoginId as String,"auth_token": token] as Dictionary<String, String>
        Dictonary.setObject(parameters, forKey : "myprofile" as NSCopying)
        
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
                            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                            var status = json["status"] as? NSString
                            if (status?.isEqual(to: "success"))! {
                                
                                
                               let email = json["email"] as? String
                               self.swappayout = (json["swapallow"] as? NSString)!
                                if self.swappayout == "true"{
                                 
                                    self.mySwitch.isOn = true
                                }else{
                                   self.mySwitch.isOn = false
                                }
                               
                                let addrating = "Credit Score: "
                                //let ratings = json["ratings"] as? NSString
                                let ratingsid = (json["ratings"] as AnyObject).int32Value;
                                let int: Int = Int(ratingsid!)
                                let isratingsid = String(int)
                                let addratingPoint = "points"
                                
                                
                                 self.ratinglbl.text = addrating + " \(isratingsid)" + " \(addratingPoint)"
                                //self.ratinglbl.text = addrating + ratings
                                let desmeemail = try! email?.aesDecrypt(key: self.key, iv: self.iv)
                                self.EmailLabel.text = desmeemail! as String
                                let Name = json["name"] as? String
                                let Name_New = try! Name?.aesDecrypt(key: self.key, iv: self.iv)
                                print(Name_New)
                                

                                
                            }else{
                                let Alert:UIAlertView = UIAlertView(title: "Alert", message: "NO date Found", delegate: self, cancelButtonTitle: "Ok")
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
                self.isurl1 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/myprofile"
                self.MyProfile()
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    }
    func containsValidPassword(_ strText: String) -> Bool? {
        let pattern: String = "^.*(?=.*[A-Z]).*$"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: (strText.characters.count ))
        return (regex?.numberOfMatches(in: strText, options: [], range: range))! > 0
    }
    func Updatepassword(){
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.labelText = "Please wait"
        let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
        
        let Dictonary: NSMutableDictionary = NSMutableDictionary()
        let parameters = ["customer_id": LoginId as String,"new_password": self.New_pass_txt.text!,"auth_token": token] as Dictionary<String, String>
        Dictonary.setObject(parameters, forKey : "updateprofile" as NSCopying)
        
        //create the url with URL
        let url = URL(string: self.isurl2 as String)! //change the url
        
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
                            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                            var status = json["status"] as? NSString
                            if (status?.isEqual(to: "success"))! {
                                UserDefaults.standard.set(self.New_pass_txt.text, forKey: "PasswordSave")
                                let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let LoginView:KYDrawerController = (story.instantiateViewController(withIdentifier: "KYDrawerController") as? KYDrawerController)!
                                self.navigationController?.pushViewController(LoginView, animated: true)
                                
                                
                            }else{
                                let Alert:UIAlertView = UIAlertView(title: "Alert", message: "NO date Found", delegate: self, cancelButtonTitle: "Ok")
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
                self.isurl2 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/updateprofile"
                self.Updatepassword()
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    }
    func SwtchWebservice(){
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.labelText = "Please wait"
        let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
        
        let Dictonary: NSMutableDictionary = NSMutableDictionary()
        let parameters = ["customer_id": LoginId as String,"swappayout": swappayout as String,"auth_token": token] as Dictionary<String, String>
        Dictonary.setObject(parameters, forKey : "updateswapswitch" as NSCopying)
        
        //create the url with URL
        let url = URL(string: self.isurl3 as String)! //change the url
        
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
                            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                            var status = json["status"] as? NSString
                            if (status?.isEqual(to: "success"))! {
                                
                                
                                
                                
                            }else{
                                let Alert:UIAlertView = UIAlertView(title: "Alert", message: "NO date Found", delegate: self, cancelButtonTitle: "Ok")
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
                self.isurl3 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/updateswapswitch"
                self.SwtchWebservice()
                print(error.localizedDescription)
            }
        })
        task.resume()
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
