//
//  UpcommingPayoutViewController.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 28/02/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class UpcommingPayoutViewController: UIViewController {
    var Arr_Upcoming = NSMutableArray()
    var LoginId: NSString = NSString()
    var DetailsDictionary = [String: AnyObject]()
    var isurl1: NSString = NSString()
    var key = "ajoapp17mindcrew"
    var iv = "mindcrewajoapp17"
    @IBOutlet weak var NODataFound: UILabel!
    @IBOutlet weak var UpcomingTableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isurl1 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/mytransactions/upcomingpayouts"
         print(DetailsDictionary)
        LoginId = (UserDefaults.standard.object(forKey: "loginid")as? NSString)!
        self.UpcomingListService()
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
        
        return Arr_Upcoming.count
       
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("menuCell");
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdcomingCell", for: indexPath) as! UpcomingTableViewCell
        let GroupDic = self.Arr_Upcoming[indexPath.row] as! NSDictionary
        var plan_start_date = ""
        let DateString = GroupDic .object(forKey: "payout_date") as! NSString as String
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy"
        let date: Date? = dateFormatterGet.date(from: DateString)
        print(dateFormatterPrint.string(from: date!))
        let created = (dateFormatterPrint.string(from: date!)) as String
        plan_start_date = plan_start_date + " \(created)"
        let  group_name = GroupDic .object(forKey: "member_name") as! NSString as String
        
        if group_name == "Not Decided"{
        
          cell.GroupNamelbl.text = group_name as String
        }else {
            let group_namee = try! group_name.aesDecrypt(key: self.key, iv: self.iv)
            cell.GroupNamelbl.text = group_namee as String
           
        
        }
        let  payout_turn = GroupDic .object(forKey: "payout_turn") as! NSString as String
        cell.Satuslbl.text = payout_turn as String
        //@IBOutlet weak var MonyLbl: UILabel!
        //@IBOutlet weak var statuslbl: UILabel!
        cell.DateLbl.text = plan_start_date as NSString as String
        cell.ShadowView.layer.borderColor = UIColor.purple.cgColor;
        cell.ShadowView.layer.borderWidth = 1.0;
        cell.ShadowView.layer.cornerRadius = 8.0;
        
        return cell;
    }
    func UpcomingListService(){
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
        let group_id = DetailsDictionary["group_id"]
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.labelText = "Please wait"
        let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
        //let group_id = "429"
        //let group_id = "374"
        let Dictonary: NSMutableDictionary = NSMutableDictionary()
        let parameters = ["group_id": group_id as! String,"auth_token": token] as Dictionary<String, String>
        Dictonary.setObject(parameters, forKey : "upcomingpayouts" as NSCopying)
      
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
                                
                                
                            self.NODataFound.isHidden = true;    self.Arr_Upcoming = (json["groups"] as? NSMutableArray)!;
                                
                                
                                self.UpcomingTableview .reloadData()
                                
                            }else{
                                let Alert:UIAlertView = UIAlertView(title: "Alert", message: "NO date Found", delegate: self, cancelButtonTitle: "Ok")
                                self.NODataFound.isHidden = false
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
                  self.isurl1 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/mytransactions/upcomingpayouts"
                self.UpcomingListService()
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
