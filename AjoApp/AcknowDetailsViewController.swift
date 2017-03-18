//
//  AcknowDetailsViewController.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 01/03/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class AcknowDetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var AckrableView: UITableView!
    @IBOutlet weak var HeaderLbal: UILabel!
    var AqunolgemntDetils_Arr = NSMutableArray()
    var LoginId: NSString = NSString()
    var group_id: NSString = NSString()
    var group_Name: NSString = NSString()
    var customer_name: NSString = NSString()
    var refreshControl: UIRefreshControl!
     var payout_turn: NSString = NSString()
     var member_id: NSString = NSString()
     var type: NSString = NSString()
     var acknowledgement_id: NSString = NSString()
     var payer_id: NSString = NSString()
     var receiver_id: NSString = NSString()
     var isurl1: NSString = NSString()
     var isurl2: NSString = NSString()
     var isurl3: NSString = NSString()
     var isurl4: NSString = NSString()
     var key = "ajoapp17mindcrew"
     var iv = "mindcrewajoapp17"
    @IBOutlet weak var NodataFound: UILabel!
    
    func refresh(_ sender:AnyObject) {
        //self.GroupListService()
        self.AckrableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        isurl1 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/acknowledgement/groupackdetail"
        isurl2 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/acknowledgement/payerconfirmation"
        isurl3 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/acknowledgement/payerconfirmation"
        isurl4 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/acknowledgement/payerconfirmation"
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red: 161/255.0, green: 73/255.0, blue: 221/255.0, alpha: 1.0)
        refreshControl.addTarget(self, action: #selector(AcknowDetailsViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        self.AckrableView.addSubview(refreshControl) //
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.string(forKey: "Isnotifcation") == "YES"{
            LoginId = (UserDefaults.standard.object(forKey: "loginid")as? NSString)!
            customer_name = (UserDefaults.standard.object(forKey: "fname")as? NSString)!
            group_id = (UserDefaults.standard.object(forKey: "groupID_notfiction")as? NSString)!
            group_Name = (UserDefaults.standard.object(forKey: "groupName_notfiction")as? NSString)!
            
            
        }else{
            LoginId = (UserDefaults.standard.object(forKey: "loginid")as? NSString)!
            customer_name = (UserDefaults.standard.object(forKey: "fname")as? NSString)!
            let gname = group_Name as String
            let desgroup_Name = try! gname.aesDecrypt(key: key, iv: iv)
            self.HeaderLbal.text = desgroup_Name as String
            self.navigationController?.isNavigationBarHidden = true
            
        
        }
        
        
        self.AquknowlagementService()
    }
    func AquknowlagementService(){
        
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.labelText = "Please wait"
        let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
        
        let Dictonary: NSMutableDictionary = NSMutableDictionary()
        let parameters = ["customer_id": LoginId as String,"customer_name": customer_name as String, "group_id": group_id as String,"auth_token": token] as Dictionary<String, String>
        Dictonary.setObject(parameters, forKey : "groupackdetail" as NSCopying)
        
        
        
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
                
                                self.AqunolgemntDetils_Arr = (json["groups"] as? NSMutableArray)!;
                                if self.AqunolgemntDetils_Arr.count > 0{
                                self.NodataFound.isHidden = true;
                                }else{
                                self.NodataFound.isHidden = false;
                                }
                                self.AckrableView .reloadData()
                                
                            }else{
                                let Alert:UIAlertView = UIAlertView(title: "Alert", message: "NO date Found", delegate: self, cancelButtonTitle: "Ok")
                                self.NodataFound.isHidden = false;
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
                        Alert.show()
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    })
                    
                }
                
            } catch let error {
                self.isurl1 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/acknowledgement/groupackdetail"
                self.AquknowlagementService()
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return AqunolgemntDetils_Arr.count
        //return 10;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AckCell", for: indexPath) as! AckDetilsTableViewCell
        cell.ShadowView.layer.borderColor = UIColor.purple.cgColor;
        cell.ShadowView.layer.borderWidth = 1.0;
        cell.ShadowView.layer.cornerRadius = 8.0;
        let GroupDic = self.AqunolgemntDetils_Arr[indexPath.row] as! NSDictionary
        let  message = GroupDic .object(forKey: "message") as! NSString as String
        cell.HeadingLbl.text = message as String
        cell.IdidItBtn.addTarget(self, action: #selector(self.IdiditOPTION), for: .touchUpInside)
        cell.IdidItBtn.tag = indexPath.row
        

        cell.Yesbtn.addTarget(self, action: #selector(self.YesOPTION), for: .touchUpInside)
        cell.Yesbtn.tag = indexPath.row
        
        cell.NOBtn.addTarget(self, action: #selector(self.NoOPTION), for: .touchUpInside)
        cell.NOBtn.tag = indexPath.row
       let typecheck = GroupDic .object(forKey: "type") as! NSString as String
        if  typecheck == "pending" {
            cell.IdidItBtn.isHidden = false
            cell.NOBtn.isHidden = true
            cell.Yesbtn.isHidden = true
            cell.Chackbtn.isHidden = true
            
        }else if  typecheck == "waiting" {
            cell.IdidItBtn.isHidden = true
            cell.NOBtn.isHidden = true
            cell.Yesbtn.isHidden = true
            cell.Chackbtn.isHidden = false
            cell.Chackbtn.setImage(UIImage(named: "waiting.png"), for: .normal)
            
        }
        else if  typecheck == "done" {
            
            cell.IdidItBtn.isHidden = true
            cell.NOBtn.isHidden = true
            cell.Yesbtn.isHidden = true
            cell.Chackbtn.isHidden = false
            cell.Chackbtn.setImage(UIImage(named: "acknowledgement.png"), for: .normal)
            //Change image Right
        }else{
            cell.IdidItBtn.isHidden = true
            cell.NOBtn.isHidden = false
            cell.Yesbtn.isHidden = false
            cell.Chackbtn.isHidden = true
           
            //change  wating
        
        }
        
       
      
    
        
        return cell;
    }
    func IdiditOPTION(sender: AnyObject) {
        var btn = (sender as! UIButton)
        var Groupdata = self.AqunolgemntDetils_Arr[btn.tag] as! NSDictionary
        payout_turn = (Groupdata .object(forKey: "payout_turn") as! NSString) as String as String as NSString
        member_id = (Groupdata .object(forKey: "member_id") as! NSString) as String as String as NSString
        group_Name = (Groupdata .object(forKey: "group_name") as! NSString) as String as String as NSString
        payerconfirmationService()
    
    }
    
    func YesOPTION(sender: AnyObject) {
        var btn = (sender as! UIButton)
        var Groupdata = self.AqunolgemntDetils_Arr[btn.tag] as! NSDictionary
        payer_id = (Groupdata .object(forKey: "payer_id") as! NSString) as String as String as NSString
        receiver_id = (Groupdata .object(forKey: "receiver_id") as! NSString) as String as String as NSString
        acknowledgement_id = (Groupdata .object(forKey: "acknowledgement_id") as! NSString) as String as String as NSString
        group_Name = (Groupdata .object(forKey: "group_name") as! NSString) as String as String as NSString
         YesService()
    }
    func NoOPTION(sender: AnyObject) {
        var btn = (sender as! UIButton)
        
        var Groupdata = self.AqunolgemntDetils_Arr[btn.tag] as! NSDictionary
        payer_id = (Groupdata .object(forKey: "payer_id") as! NSString) as String as String as NSString
        receiver_id = (Groupdata .object(forKey: "receiver_id") as! NSString) as String as String as NSString
        acknowledgement_id = (Groupdata .object(forKey: "acknowledgement_id") as! NSString) as String as String as NSString
        group_Name = (Groupdata .object(forKey: "group_name") as! NSString) as String as String as NSString
        
         NoService()
    }
    // MARK: - UITableView delegates
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var cellHeight : CGFloat = 95
        let GroupDic = self.AqunolgemntDetils_Arr[indexPath.row] as! NSDictionary
        
        cellHeight = returnHeightForCell(GroupDic: GroupDic, for: indexPath)
       
        return cellHeight
    }

    func returnHeightForCell(GroupDic : NSDictionary ,for indexPath: IndexPath) -> CGFloat {
        let  message = GroupDic .object(forKey: "message") as! NSString as String
        let height:CGFloat = self.calculateHeightForString(message)
        
        var cellHeight = height+95;
        if cellHeight < 110 {
            cellHeight = 110
        }
        return cellHeight
    }
    
    func calculateHeightForString(_ inString:String) -> CGFloat
    {
        let messageString = inString
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 15.0)]
        let attrString:NSAttributedString? = NSAttributedString(string: messageString, attributes: attributes)
        let rect:CGRect = attrString!.boundingRect(with: CGSize(width: self.view.frame.size.width-(40),height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, context:nil )//hear u will get nearer height not the exact value
        let requredSize:CGRect = rect
        return requredSize.height  //to include button's in your tableview
        
    }
    
    @IBAction func Actiononback(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "Isnotifcation")
        defaults.removeObject(forKey: "groupID_notfiction")
        defaults.removeObject(forKey: "groupName_notfiction")
        defaults.synchronize()
        let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginView: AcknowledgmentViewController = (story.instantiateViewController(withIdentifier: "AcknowledgmentViewController") as? AcknowledgmentViewController)!
        self.navigationController?.pushViewController(LoginView, animated: true)
    }
    func payerconfirmationService(){
        
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification?.labelText = "Please wait"
            let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
           // group_name
            let Dictonary: NSMutableDictionary = NSMutableDictionary()
            let parameters = ["customer_id": LoginId as String,"customer_name": customer_name as String, "group_id": group_id as String,"payout_turn": payout_turn as String,"member_id": member_id as String,"group_name": group_Name as String,"type": "waiting","acknowledgement_id": "","accept_payment_notification": "false","auth_token": token] as Dictionary<String, String>
            Dictonary.setObject(parameters, forKey : "payerconfirmation" as NSCopying)
            
            

//

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
                                    self.AquknowlagementService()
                                    
                                    
                                }else{
                                    let Alert:UIAlertView = UIAlertView(title: "Alert", message: "NO date Found", delegate: self, cancelButtonTitle: "Ok")
                                    self.NodataFound.isHidden = false;
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
                            Alert.show()
                            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        })
                        
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                     self.isurl2 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/acknowledgement/payerconfirmation"
                    self.payerconfirmationService()
                }
            })
            task.resume()
        }
    }

    
    func YesService(){
        
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification?.labelText = "Please wait"
            let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
            
            
            let Dictonary: NSMutableDictionary = NSMutableDictionary()
            let parameters = ["acknowledgement_type": "Yes", "group_id": group_id as String,"receiver_id": receiver_id as String,"payer_id": payer_id as String,"acknowledgement_id": acknowledgement_id as String,"group_name": group_Name as String,"yes_payment_notification": "false","auth_token": token] as Dictionary<String, String>
            Dictonary.setObject(parameters, forKey : "payerconfirmation" as NSCopying)
    
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
                                    self.AquknowlagementService()
                                    
                                }else{
                                    let Alert:UIAlertView = UIAlertView(title: "Alert", message: "NO date Found", delegate: self, cancelButtonTitle: "Ok")
                                    
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
                    print(error.localizedDescription)
                    self.isurl3 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/acknowledgement/payerconfirmation"
                    self.YesService()
                }
            })
            task.resume()
        }
    }

    
    func NoService(){
        
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification?.labelText = "Please wait"
            let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
            
            let Dictonary: NSMutableDictionary = NSMutableDictionary()
             let parameters = ["acknowledgement_type": "No", "group_id": group_id as String,"receiver_id": receiver_id as String,"payer_id": payer_id as String,"acknowledgement_id": acknowledgement_id as String,"group_name": group_Name as String,"no_payment_notification": "false","auth_token": token] as Dictionary<String, String>
            Dictonary.setObject(parameters, forKey : "payerconfirmation" as NSCopying)
            
    
            
            //create the url with URL
            let url = URL(string: self.isurl4 as String)! //change the url
            
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
                                    self.AquknowlagementService()
                                    
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
                            Alert.show()
                            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        })
                        
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                    self.isurl4 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/acknowledgement/payerconfirmation"
                    self.NoService()
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
