//
//  MemberDetilsViewController.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 06/03/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class MemberDetilsViewController: UIViewController {
    @IBOutlet weak var MobileNolbl: UILabel!

    @IBOutlet weak var Namelbl: UILabel!
    @IBOutlet weak var Groupcount: UILabel!
    @IBOutlet weak var pointlabl: UILabel!
    @IBOutlet weak var Datelabel: UILabel!
    var key = "ajoapp17mindcrew"
    var iv = "mindcrewajoapp17"
    var isurl1: NSString = NSString()
     var Userid: NSString = NSString()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isurl1 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/webservices/getmemberdetails"
        MemberdetilsService()
        // Do any additional setup after loading the view.
    }

    @IBAction func ActionOnback(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func MemberdetilsService(){
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
            if Reachability.shared().internetConnectionStatus() == NotReachable {
                var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }else{
                let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                loadingNotification?.labelText = "Please wait"
                let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
                
                let Dictonary: NSMutableDictionary = NSMutableDictionary()
                let parameters = ["user_id": Userid as String,"auth_token": token] as Dictionary<String, String>
                Dictonary.setObject(parameters, forKey : "getmemberdetails" as NSCopying)
            
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
                let meberdeailsArr = json["memberdetails"] as? NSMutableArray
                                        
                let memberdic = meberdeailsArr?.firstObject as! NSDictionary
               print(memberdic)
                var plan_start_date = ""
                let DateString = memberdic .object(forKey: "membersince") as! NSString as String
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd"
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd/MM/yyyy"
                let date: Date? = dateFormatterGet.date(from: DateString)
                print(dateFormatterPrint.string(from: date!))
                                        
                let created = (dateFormatterPrint.string(from: date!)) as String
                                        
                plan_start_date = plan_start_date + " \(created)"
                let  group_name = memberdic .object(forKey: "fname") as! NSString as String
                let desgroup_namemember = try! group_name.aesDecrypt(key: self.key, iv: self.iv)
                self.Namelbl.text = desgroup_namemember as String
                
                let  Nofogroup = memberdic .object(forKey: "activegroups") as! NSString as String
                self.Groupcount.text = Nofogroup
               self.Datelabel.text = plan_start_date as NSString as String
                let Ratings = " points"
                let  GetRating = memberdic .object(forKey: "ratings") as! NSString as String
               self.pointlabl.text = GetRating + Ratings
                                        
                let  mobile_no = memberdic .object(forKey: "mobile_no") as! NSString as String
                let desmobile_no = try! mobile_no.aesDecrypt(key: self.key, iv: self.iv)
               let  country_code = memberdic .object(forKey: "country_code") as! NSString as String
                    
               self.MobileNolbl.text = country_code + (desmobile_no as String) as String
            
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
                               // Alert.show()
                                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                            })
                            
                        }
                        
                    } catch let error {
                        self.isurl1 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/webservices/getmemberdetails"
                        self.MemberdetilsService()
                        print(error.localizedDescription)
                    }
                })
                task.resume()
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
