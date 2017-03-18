//
//  SwapRequstViewController.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 06/03/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class SwapRequstViewController: UIViewController {
    
    @IBOutlet weak var HeaderLbl: UILabel!
    var key = "ajoapp17mindcrew"
    var iv = "mindcrewajoapp17"
    @IBOutlet weak var Afterswapdatelbl: UILabel!
    @IBOutlet weak var Currentdatelbl: UILabel!
    
    @IBOutlet weak var Paymentterms: UILabel!
    @IBOutlet weak var AmountLbl: UILabel!
    @IBOutlet weak var NameLble: UILabel!
    
    @IBOutlet weak var Shadowview: UIView!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var BagroundView: UIView!
    
    var isurl1: NSString = NSString()
    var isurl2: NSString = NSString()
    var isurl3: NSString = NSString()
   
    
    
    var ReqDic = NSMutableDictionary()
    var LoginId: NSString = NSString()
    var group_id: NSString = NSString()
    
    var groupNameencrapted  = String()
    var groupidsend  = String()
    func tapBlurButton(_ sender: UITapGestureRecognizer) {
        self.ContentView.isHidden = true
        self.BagroundView.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isurl1 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/webservices/invitedgroupdetail"
        self.isurl2 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/webservices/acceptswaprequest"
        self.isurl3 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/webservices/denyswaprequest"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        self.BagroundView.addGestureRecognizer(tapGesture)
        Shadowview.layer.borderColor = UIColor.purple.cgColor;
        Shadowview.layer.borderWidth = 1.0;
        Shadowview.layer.cornerRadius = 8.0;
        print(ReqDic)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        LoginId = (UserDefaults.standard.object(forKey: "loginid")as? NSString)!
        group_id =  (ReqDic .object(forKey: "group_id") as! NSString) as String as String as NSString
        
        let group_name = (ReqDic .object(forKey: "group_name") as! NSString) as String as String as NSString
        let gname = group_name as String
        let group_namee = try! gname.aesDecrypt(key: self.key, iv: self.iv)
        self.HeaderLbl.text = group_namee as String
       
        
        self.GetdetailsService()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func GetdetailsService(){
        
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification?.labelText = "Please wait"
            let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
            
            let Dictonary: NSMutableDictionary = NSMutableDictionary()
            let parameters = ["customer_id": LoginId as String,"group_id": group_id as String,"request_type": "swap_request","auth_token": token] as Dictionary<String, String>
            Dictonary.setObject(parameters, forKey : "invitedgroupdetail" as NSCopying)
            // http://mindcrewgis.com/ajoapp/api/v1/webservices/invitedgroupdetail
            
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
                                    
                                    
                                    
                                    var plan_start_date = "Current payout :"
                                    var plan_start_date2 = "After swap :"
                                    
                                    let DateString = json["after_swap_payout_date"] as? NSString as String?
                                    let DateString2 = json["current_payout_date"] as? NSString as String?
                                    
                                    let dateFormatterGet = DateFormatter()
                                    dateFormatterGet.dateFormat = "yyyy-MM-dd"
                                    let dateFormatterPrint = DateFormatter()
                                    dateFormatterPrint.dateFormat = "dd/MM/yyyy"
                                    let date: Date? = dateFormatterGet.date(from: DateString!)
                                     let date2: Date? = dateFormatterGet.date(from: DateString2!)
                                    print(dateFormatterPrint.string(from: date!))
                                    print(dateFormatterPrint.string(from: date2!))
                                    let created = (dateFormatterPrint.string(from: date!)) as String
                                     let created2 = (dateFormatterPrint.string(from: date2!)) as String
                                    
                
                                let after_swap_payout_turnloginid = (json["after_swap_payout_turn"] as AnyObject).int32Value;
                                    let intin: Int = Int(after_swap_payout_turnloginid!)
                                    let after_swap_payout_turn = String(intin)
                                    
                                    
                                    let current_payout_turnloginid = (json["current_payout_turn"] as AnyObject).int32Value;
                                    let int: Int = Int(current_payout_turnloginid!)
                                    let current_payout_turn = String(int)
                                    let rigbrasees = "("
                                    let leftrasees = ")"
                                    
                        plan_start_date = plan_start_date + " \(current_payout_turn)" + " \(rigbrasees)" + " \(created2)" + " \(leftrasees)"

                                    
                    plan_start_date2 = plan_start_date2 + " \(after_swap_payout_turn)" + " \(rigbrasees)"  + " \(created)"  + " \(leftrasees)"

                                    
//
                                    self.Currentdatelbl .text = plan_start_date
                                    self.Afterswapdatelbl .text = plan_start_date2
                                    
                                    
                                    
                                    
                                    
                                    
                                    let  group_name = json["group_admin_name"] as? NSString as String?
                                     let group_namee = try! group_name?.aesDecrypt(key: self.key, iv: self.iv)
                                    self.NameLble.text = group_namee! as String
                                    
                                    var payment_termaddstr = ""
                                    let payment_termadd = json["payment_term"] as? NSString as String?
                                    payment_termaddstr = payment_termaddstr + payment_termadd!;                                self.Paymentterms.text = payment_termaddstr
                                    let currency = json["currency"] as? NSString as String?
                                    
                                    let Gamount = (json["group_amount"] as AnyObject).int32Value;
                                    let intga: Int = Int(Gamount!)
                                    let group_amountnew = String(intga)
                                    
                                    
                                    if currency == "GBP"{
                                        let signOfCurrency = "£"
                                        var final_amountheding = ""
                                        final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(group_amountnew)"
                                        self.AmountLbl.text! = final_amountheding as String
                                    }else if currency == "INR" {
                                        let signOfCurrency = "Rs."
                                        var final_amountheding = ""
                                        final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(group_amountnew)"
                                        self.AmountLbl.text! = final_amountheding as String
                                    }else if currency == "USD" {
                                        let signOfCurrency = "$"
                                        
                                        var final_amountheding = ""
                                        final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(group_amountnew)"
                                        self.AmountLbl.text! = final_amountheding as String
                                    }else if currency == "NGN" {
                                        let signOfCurrency = "₦"
                                        
                                        var final_amountheding = ""
                                        final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(group_amountnew)"
                                        self.AmountLbl.text! = final_amountheding as String
                                    }else if currency == "EU" {
                                        let signOfCurrency = "€"
                                        var final_amountheding = ""
                                        final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(group_amountnew)"
                                        self.AmountLbl.text! = final_amountheding as String
                                    }else if currency == "GHS" {
                                        let signOfCurrency = "GH₵"
                                        var final_amountheding = ""
                                        final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(group_amountnew)"
                                        self.AmountLbl.text! = final_amountheding as String
                                    }else if currency == "ZAR" {
                                        let signOfCurrency = "ZAR"
                                        var final_amountheding = ""
                                        final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(group_amountnew)"
                                        self.AmountLbl.text! = final_amountheding as String
                                    }else if currency == "KES" {
                                        
                                        
                                        let signOfCurrency = "KSh"
                                        var final_amountheding = ""
                                        final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(group_amountnew)"
                                        self.AmountLbl.text! = final_amountheding as String
                                    }
                                    
                                    
                                    
                                    
                                    
                                    
                                    self.groupNameencrapted = (json["group_admin_name"] as? NSString as String?)!
                                    self.groupidsend = (json["group_id"] as? NSString as String?)!
                                    
                                    
                                    
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
                    self.isurl1 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/webservices/invitedgroupdetail"
                    self.GetdetailsService()
                    print(error.localizedDescription)
                }
            })
            task.resume()
        }
    }

    
    func AcceptService(){
        
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification?.labelText = "Please wait"
            let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
            
            let Dictonary: NSMutableDictionary = NSMutableDictionary()
            let parameters = ["customer_id": LoginId as String,"group_id": groupidsend as String,"group_name": groupNameencrapted as String,"accept_swap_notification": "false","auth_token": token] as Dictionary<String, String>
            Dictonary.setObject(parameters, forKey : "acceptswaprequest" as NSCopying)
            
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
                    self.isurl2 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/webservices/acceptswaprequest"
                    self.AcceptService()
                    print(error.localizedDescription)
                }
            })
            task.resume()
        }
    }
    
    func DenyService(){
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
            
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification?.labelText = "Please wait"
            let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
            
            let Dictonary: NSMutableDictionary = NSMutableDictionary()
            let parameters = ["customer_id": LoginId as String,"group_id": groupidsend as String,"group_name": groupNameencrapted as String,"deny_swap_notification": "false","auth_token": token] as Dictionary<String, String>
            Dictonary.setObject(parameters, forKey : "denyswaprequest" as NSCopying)
        
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
                                    let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    let LoginView:KYDrawerController = (story.instantiateViewController(withIdentifier: "KYDrawerController") as? KYDrawerController)!
                                    self.navigationController?.pushViewController(LoginView, animated: true)
                                    
                                }else{
                                    let Alert:UIAlertView = UIAlertView(title: "Alert", message: "NO date Found", delegate: self, cancelButtonTitle: "Ok")
                                   // Alert.show()
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
                     self.isurl3 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/webservices/denyswaprequest"
                    self.DenyService()
                    print(error.localizedDescription)
                }
            })
            task.resume()
        }
    }
    

    
    @IBAction func ActionOnback(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }

    @IBAction func ActionONShowTotorial(_ sender: Any) {
        self.ContentView.isHidden = false
        self.BagroundView.isHidden = false

    }
    
    @IBAction func ActionOnAcept(_ sender: Any) {
        AcceptService()
    }
    
    
    @IBAction func ActionOnDeny(_ sender: Any) {
        DenyService()
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
