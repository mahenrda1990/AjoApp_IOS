//
//  ContectUsViewController.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 23/02/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class ContectUsViewController: UIViewController,UITextViewDelegate  {
    
    @IBOutlet weak var YourNametxt: UITextField!
    var key = "ajoapp17mindcrew"
    var iv = "mindcrewajoapp17"
    var mob_no: NSString = NSString()
    var emilid: NSString = NSString()
    @IBOutlet weak var NoteText: UITextView!
    @IBOutlet weak var PlasceHolderLbl: UILabel!
    var isurl1: NSString = NSString()
 //var delegate: ContectUsDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isurl1 = "http://ajoapp.co.uk/send_mail.php"
        let borderColor = UIColor.white
        NoteText.layer.borderColor = borderColor.cgColor;
        NoteText.layer.borderWidth = 1.0;
        NoteText.layer.cornerRadius = 5.0;
        self.YourNametxt.attributedPlaceholder = NSAttributedString(string:"Your Name",attributes:[NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12)])
        self.addDoneButtonOnKeyboard()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        
        
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
        YourNametxt.inputAccessoryView = doneToolbar
        NoteText.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        
        YourNametxt.resignFirstResponder();
        NoteText.resignFirstResponder();
        
    }
    @IBAction func ActionOnSend(_ sender: Any) {
        
        if self.YourNametxt.text==""{
            let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Name field can't be empty", delegate: self, cancelButtonTitle: "Ok")
            Alert.show()
            
        }
        else if self.NoteText.text==""{
            let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Message field can't be empty", delegate: self, cancelButtonTitle: "Ok")
            Alert.show()
            
        }
        else{
            self.SendContectService()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        var newString : NSMutableString = NSMutableString(string: textView.text)
        
        if text == ""
        {
            
            if newString.length == 0 {
                
            }else{
                
                let ran : NSRange = NSRange(location: 0, length: newString.length-1)
                
                let str : String = newString.replacingCharacters(in: ran, with: "")
                
                let NewRan = newString.range(of: str)
                
                newString = NSMutableString( string: newString.replacingCharacters(in: NewRan, with: ""))
                
                
            }
        }else{
            newString.append(text)
            
        }
        
        if newString == "" {
            self.PlasceHolderLbl.isHidden = false
        }else{
            self.PlasceHolderLbl.isHidden = true
        }
        
        
        return true
    }
    func SendContectService(){
        
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
        let mobile = (UserDefaults.standard.object(forKey: "mobile_no")as? NSString)! as String
        let mob_no = try! mobile.aesDecrypt(key: key, iv: iv)
            
        let emil = (UserDefaults.standard.object(forKey: "email")as? NSString)! as String
            
        let emilid = try! emil.aesDecrypt(key: key, iv: iv)
        
        

        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.labelText = "Please wait"
        let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
        let Dictonary: NSMutableDictionary = NSMutableDictionary()
        let parameters = ["mobile_no": mob_no as String,"name": self.YourNametxt.text!,"email": emilid as String,"message": self.NoteText.text!,"auth_token": token] as Dictionary<String, String>
        Dictonary.setObject(parameters, forKey : "contactus" as NSCopying)
        

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
                                self.YourNametxt.text = ""
                                self.NoteText.text = ""
                                
                                let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Thanks for contacting Ajoapp support. We've received your message and will respond as soon as we can.", delegate: self, cancelButtonTitle: "Ok")
                                Alert.show()
                                
                               
                                
                            }else{
                                let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Mail Can't be sent try again", delegate: self, cancelButtonTitle: "Ok")
                                Alert.show()
                                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                            }
                            
                            
                        }
                        
                        
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    })
                    // handle json...
                }else{
                    DispatchQueue.main.async(execute: {
                        
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    })
                    
                }
                
            } catch let error {
                self.isurl1 = "http://ajoapp.co.uk/send_mail.php"
               self.SendContectService()
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
