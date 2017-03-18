//
//  ForgetpasswordViewController.swift
//  Ajo App
//
//  Created by mindcrewtechnologies on 23/02/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class ForgetpasswordViewController: UIViewController {
    var phoneNumber: NSString = NSString()
    var CCode: NSString = NSString()
    
    @IBOutlet weak var MobNOlbl: UILabel!
    var isurl1: NSString = NSString()
    var key = "ajoapp17mindcrew"
    var iv = "mindcrewajoapp17"
    @IBOutlet weak var Pass_txt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isurl1 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/updatepassword"
        phoneNumber = (UserDefaults.standard.object(forKey: "phoneNumber")as? NSString)!
        CCode = (UserDefaults.standard.object(forKey: "CCode")as? NSString)!
        self.MobNOlbl.text = (UserDefaults.standard.object(forKey: "MOBNO")as? NSString)! as String
        addDoneButtonOnKeyboard()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        self.Pass_txt.attributedPlaceholder = NSAttributedString(string:"Password",attributes:[NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12)])
        
        
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
        Pass_txt.inputAccessoryView = doneToolbar
        
        
    }
    //CHECK EMAIL ID VLAIDATION
    
    func isValidEmail(_ email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    func doneButtonAction()
    {
        
        Pass_txt.resignFirstResponder();
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ActionOnBack(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }

    @IBAction func ActionOnsubmit(_ sender: Any) {
        if self.Pass_txt.text==""{
            let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Password field can't be empty", delegate: self, cancelButtonTitle: "Ok")
            Alert.show()
            
        }
        else if  Pass_txt.text!.characters.count < 8 {
            let alertView = UIAlertView(
                title: "Alert",
                message: "password should be 8 digit long",
                delegate: self,
                cancelButtonTitle: "OK"
            )
            alertView.show()
        }else{
            if  let isValid : Bool = self.containsValidPassword(Pass_txt.text!) {
                if isValid {
                    //[self gotoActivityController];
                    print("valid")
                   CahngePasswordService()
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
    func CahngePasswordService(){
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
            let mobno = phoneNumber as String
            let Mobile_no = try! mobno.aesEncrypt(key: key, iv: iv)

       print(Mobile_no)
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.labelText = "Please wait"
        let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
        
        let Dictonary: NSMutableDictionary = NSMutableDictionary()
        let parameters = ["mobile_no": Mobile_no as String,"new_password": self.Pass_txt.text!,"auth_token": token] as Dictionary<String, String>
        Dictonary.setObject(parameters, forKey : "updatepassword" as NSCopying)
        
        
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
                                
                                let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let LoginView:LoginViewController = (story.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController)!
                                self.navigationController?.pushViewController(LoginView, animated: true)
                                
                                
                            }else{
                                let Alert:UIAlertView = UIAlertView(title: "Alert", message: "NO date Found", delegate: self, cancelButtonTitle: "Ok")
                                //Alert.show()
                                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                            }
                            
                            
                        }
                        
                        
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    })
                    // handle json...
                }else{
                    DispatchQueue.main.async(execute: {
                        let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Login failed. Incorrect password", delegate: self, cancelButtonTitle: "Ok")
                        //Alert.show()
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    })
                    
                }
                
            } catch let error {
                self.isurl1 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/updatepassword"
                self.CahngePasswordService()
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        self.Pass_txt.resignFirstResponder()
        return true
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
