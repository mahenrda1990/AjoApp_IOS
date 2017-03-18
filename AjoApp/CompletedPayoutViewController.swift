//
//  CompletedPayoutViewController.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 28/02/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class CompletedPayoutViewController: UIViewController {
    var Arr_complited = NSMutableArray()
    var Arr_complitedDetils = NSMutableArray()
    var key = "ajoapp17mindcrew"
    var iv = "mindcrewajoapp17"
    @IBOutlet weak var DetailsNODataLbl: UILabel!
    @IBOutlet weak var NodataFound: UILabel!
    @IBOutlet weak var DetailsView: UIView!
    @IBOutlet weak var DeatilsTableView: UITableView!
    var DetailsDictionary = [String: AnyObject]()
    var LoginId: NSString = NSString()
    var member_id: NSString = NSString()
    var payout_turn: NSString = NSString()
    var isurl1: NSString = NSString()
    var isurl2: NSString = NSString()
   
    @IBOutlet weak var ComplieteTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isurl1 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/mytransactions/completedpayouts"
        self.isurl2 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/mytransactions/completedpayoutsmembers"
        Arr_complited = NSMutableArray()
        Arr_complitedDetils = NSMutableArray()
        self.DetailsView.layer.borderColor = UIColor.purple.cgColor;
        self.DetailsView.layer.borderWidth = 1.0;
        self.DetailsView.layer.cornerRadius = 8.0;
       print(DetailsDictionary)
       LoginId = (UserDefaults.standard.object(forKey: "loginid")as? NSString)!
        self.ComplitedListService()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        
                   self.navigationController?.isNavigationBarHidden = true
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if(tableView == self.DeatilsTableView){
            return self.Arr_complitedDetils.count;
        }else if(tableView == self.ComplieteTableView){
            return self.Arr_complited.count;
        }
        //return self.SupplierimagesEarr.count
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        if tableView == self.DeatilsTableView {
            let cell = DeatilsTableView.dequeueReusableCell(withIdentifier: "DetilsCell", for: indexPath) as! CompliteDetilsTableViewCell
            let dict = self.Arr_complitedDetils[indexPath.row] as! NSDictionary
            var amount = dict .object(forKey: "amount") as! NSString as String
            let member_name = dict .object(forKey: "member_name") as! NSString as String
            let currency = dict .object(forKey: "currency") as! NSString as String
            var Membername = "Member name : "
            let desmember_name = try! member_name.aesDecrypt(key: key, iv: iv)
            Membername = Membername + " \(desmember_name)"
            cell.MemberNamelbl.text = Membername as String
            if currency == "GBP"{
                let signOfCurrency = "£"
                var final_amountheding = "Payment Received : "
                final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(amount)"
                if amount == "0"{
                cell.paymenyLbl.text = final_amountheding as String
                cell.paymenyLbl.textColor = UIColor.red
                }else{
                cell.paymenyLbl.text = final_amountheding as String
                    cell.paymenyLbl.textColor = UIColor.green
                }
                
            }else if currency == "INR" {
                let signOfCurrency = "Rs."
                
                var final_amountheding = "Payment Received : "
                final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(amount)"
                if amount == "0"{
                    cell.paymenyLbl.text = final_amountheding as String
                    cell.paymenyLbl.textColor = UIColor.red
                }else{
                    cell.paymenyLbl.text = final_amountheding as String
                    cell.paymenyLbl.textColor = UIColor.green
                }
            }else if currency == "USD" {
                let signOfCurrency = "$"
                
                var final_amountheding = "Payment Received : "
                final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(amount)"
                
                if amount == "0"{
                    cell.paymenyLbl.text = final_amountheding as String
                    cell.paymenyLbl.textColor = UIColor.red
                }else{
                    cell.paymenyLbl.text = final_amountheding as String
                    cell.paymenyLbl.textColor = UIColor.green
                }
            }else if currency == "NGN" {
                let signOfCurrency = "₦"
                
                var final_amountheding = "Payment Received : "
                final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(amount)"
                if amount == "0"{
                    cell.paymenyLbl.text = final_amountheding as String
                    cell.paymenyLbl.textColor = UIColor.red
                }else{
                    cell.paymenyLbl.text = final_amountheding as String
                    cell.paymenyLbl.textColor = UIColor.green
                }
            }else if currency == "EU" {
                let signOfCurrency = "€"
                
                var final_amountheding = "Payment Received : "
                final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(amount)"
                if amount == "0"{
                    cell.paymenyLbl.text = final_amountheding as String
                    cell.paymenyLbl.textColor = UIColor.red
                }else{
                    cell.paymenyLbl.text = final_amountheding as String
                    cell.paymenyLbl.textColor = UIColor.green
                }
            }else if currency == "GHS" {
                let signOfCurrency = "GH₵"
                var final_amountheding = "Payment Received : "
                final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(amount)"
                if amount == "0"{
                    cell.paymenyLbl.text = final_amountheding as String
                    cell.paymenyLbl.textColor = UIColor.red
                }else{
                    cell.paymenyLbl.text = final_amountheding as String
                    cell.paymenyLbl.textColor = UIColor.green
                }
            }else if currency == "ZAR" {
                let signOfCurrency = "ZAR"
                var final_amountheding = "Payment Received : "
                final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(amount)"
                if amount == "0"{
                    cell.paymenyLbl.text = final_amountheding as String
                    cell.paymenyLbl.textColor = UIColor.red
                }else{
                    cell.paymenyLbl.text = final_amountheding as String
                    cell.paymenyLbl.textColor = UIColor.green
                }
            }else if currency == "KES" {
                let signOfCurrency = "KSh"
                var final_amountheding = "Payment Received : "
                final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(amount)"
                if amount == "0"{
                    cell.paymenyLbl.text = final_amountheding as String
                    cell.paymenyLbl.textColor = UIColor.red
                }else{
                    cell.paymenyLbl.text = final_amountheding as String
                    cell.paymenyLbl.textColor = UIColor.green
                }
            }


//            cell.paymenyLbl.text = dict .object(forKey: "currency") as! NSString as String
            return cell;
            
        }else if tableView == self.ComplieteTableView {
            let cell = ComplieteTableView.dequeueReusableCell(withIdentifier: "ComplitedCell", for: indexPath) as! CompliteTableViewCell
            let GroupDic = self.Arr_complited[indexPath.row] as! NSDictionary
            var plan_start_date = "Paid On : "
            let DateString = GroupDic .object(forKey: "payout_date") as! NSString as String
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd/MM/yyyy"
            let date: Date? = dateFormatterGet.date(from: DateString)
            print(dateFormatterPrint.string(from: date!))
            let created = (dateFormatterPrint.string(from: date!)) as String
            plan_start_date = plan_start_date + " \(created)"
            let  group_name = GroupDic .object(forKey: "payout_member") as! NSString as String
            let desgroup_name = try! group_name.aesDecrypt(key: key, iv: iv)
            cell.GroupNamelbl.text = desgroup_name as String
            let group_currency = GroupDic .object(forKey: "group_currency") as! NSString as String
            
            if group_currency == "GBP"{
                let signOfCurrency = "£"
                let group_amount = (GroupDic["group_amount"] as AnyObject).int32Value;
                let int: Int = Int(group_amount!)
                let isgroup_amount = String(int)
                cell.MonyLbl.text = signOfCurrency + isgroup_amount
            }else if group_currency == "INR" {
                let signOfCurrency = "Rs."
                let group_amount = (GroupDic["group_amount"] as AnyObject).int32Value;
                let int: Int = Int(group_amount!)
                let isgroup_amount = String(int)
                cell.MonyLbl.text = signOfCurrency + isgroup_amount
            }else if group_currency == "USD" {
                let signOfCurrency = "$"
                
                let group_amount = (GroupDic["group_amount"] as AnyObject).int32Value;
                let int: Int = Int(group_amount!)
                let isgroup_amount = String(int)
                cell.MonyLbl.text = signOfCurrency + isgroup_amount
            }else if group_currency == "NGN" {
                let signOfCurrency = "₦"
                
                let group_amount = (GroupDic["group_amount"] as AnyObject).int32Value;
                let int: Int = Int(group_amount!)
                let isgroup_amount = String(int)
                cell.MonyLbl.text = signOfCurrency + isgroup_amount
            }else if group_currency == "EU" {
                let signOfCurrency = "€"
                
                let group_amount = (GroupDic["group_amount"] as AnyObject).int32Value;
                let int: Int = Int(group_amount!)
                let isgroup_amount = String(int)
                cell.MonyLbl.text = signOfCurrency + isgroup_amount
            }else if group_currency == "GHS" {
                let signOfCurrency = "GH₵"
                let group_amount = (GroupDic["group_amount"] as AnyObject).int32Value;
                let int: Int = Int(group_amount!)
                let isgroup_amount = String(int)
                cell.MonyLbl.text = signOfCurrency + isgroup_amount
            }else if group_currency == "ZAR" {
                let signOfCurrency = "ZAR"
                let group_amount = (GroupDic["group_amount"] as AnyObject).int32Value;
                let int: Int = Int(group_amount!)
                let isgroup_amount = String(int)
                cell.MonyLbl.text = signOfCurrency + isgroup_amount
            }else if group_currency == "KES" {
                let signOfCurrency = "KSh"
                let group_amount = (GroupDic["group_amount"] as AnyObject).int32Value;
                let int: Int = Int(group_amount!)
                let isgroup_amount = String(int)
                cell.MonyLbl.text = signOfCurrency + isgroup_amount
            }

            
            
            
            cell.DateLbl.text = plan_start_date as NSString as String
            cell.ShadowView.layer.borderColor = UIColor.purple.cgColor;
            cell.ShadowView.layer.borderWidth = 1.0;
            cell.ShadowView.layer.cornerRadius = 8.0;
            return cell;
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        
        if tableView == self.DeatilsTableView {
            let detailDict: NSDictionary = self.Arr_complitedDetils[indexPath.row] as! NSDictionary
        
        }else if tableView == self.ComplieteTableView {
            let detai: NSDictionary = self.Arr_complited[indexPath.row] as! NSDictionary
           
            self.member_id =  (detai .object(forKey: "payout_member_id") as! NSString) as String as String as NSString
            self.payout_turn =  (detai .object(forKey: "payout_turn") as! NSString) as String as String as NSString
             getdetils()
        }
        //
        
    }
       func ComplitedListService(){
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
        let group_id = DetailsDictionary["group_id"]
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.labelText = "Please wait"
        let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
        
        //let group_id = "374"
        let Dictonary: NSMutableDictionary = NSMutableDictionary()
        let parameters = ["group_id": group_id as! String,"auth_token": token] as Dictionary<String, String>
        Dictonary.setObject(parameters, forKey : "completedpayouts" as NSCopying)
        

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
                                
                                self.NodataFound.isHidden = true
                                self.Arr_complited = (json["groups"] as? NSMutableArray)!;
                                
                                
                                self.ComplieteTableView .reloadData()
                                
                            }else{
                                
                                self.NodataFound.isHidden = false
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
                 self.isurl1 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/mytransactions/completedpayouts"
                self.ComplitedListService()
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    }

   
    
    @IBAction func ActionOnBack(_ sender: Any) {
        
        self.NodataFound.isHidden = true
        self.DetailsView.isHidden = true
        self.DetailsNODataLbl.isHidden = true
       
    }

    func getdetils(){
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
        let group_id = DetailsDictionary["group_id"]
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.labelText = "Please wait"
        let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
       

        let Dictonary: NSMutableDictionary = NSMutableDictionary()
        let parameters = ["groupId": group_id as! String,"payout_turn": payout_turn as String,"member_id": member_id as String,"auth_token": token] as Dictionary<String, String>
        Dictonary.setObject(parameters, forKey : "completedpayoutsmembers" as NSCopying)
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
                                
                                self.NodataFound.isHidden = true
                                self.Arr_complitedDetils = (json["payout_detail"] as? NSMutableArray)!;
                                
                                self.DetailsView.isHidden = false
                                self.DeatilsTableView .reloadData()
                                
                            }else{
                                let Alert:UIAlertView = UIAlertView(title: "Alert", message: "NO date Found", delegate: self, cancelButtonTitle: "Ok")
                                self.DetailsNODataLbl.isHidden = false
                                self.DetailsView.isHidden = false
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
                         self.DetailsNODataLbl.isHidden = false
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    })
                    
                }
                
            } catch let error {
                self.isurl2 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/mytransactions/completedpayoutsmembers"
                self.getdetils()
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
