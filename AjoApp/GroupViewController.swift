//
//  GroupViewController.swift
//  Ajo App
//
//  Created by mindcrewtechnologies on 23/02/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
     var Arr_group = NSMutableArray()
     var LoginId: NSString = NSString()
    var key = "ajoapp17mindcrew"
    var iv = "mindcrewajoapp17"
    var isurl: NSString = NSString()
    @IBOutlet weak var GroupTableView: UITableView!
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var NODataLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        isurl = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/webservices/retrievegroups"
        LoginId = (UserDefaults.standard.object(forKey: "loginid")as? NSString)!
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red: 161/255.0, green: 73/255.0, blue: 221/255.0, alpha: 1.0)
        refreshControl.addTarget(self, action: #selector(GroupViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        self.GroupTableView.addSubview(refreshControl) // not required
        // Do any additional setup after loading the view.
        self.GroupListService()

    }
    func refresh(_ sender:AnyObject) {
         self.GroupListService()
        self.GroupTableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    override func viewDidAppear(_ animated: Bool) {
        LoginId = (UserDefaults.standard.object(forKey: "loginid")as? NSString)!
        
            self.navigationController?.isNavigationBarHidden = true
     
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Arr_group.count
        //return 10;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("menuCell");
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupTableViewCell
        let GroupDic = self.Arr_group[indexPath.row] as! NSDictionary
        var plan_start_date = "Started On : "
        let DateString = GroupDic .object(forKey: "plan_start_date") as! NSString as String
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy"
        let date: Date? = dateFormatterGet.date(from: DateString)
        print(dateFormatterPrint.string(from: date!))
        let created = (dateFormatterPrint.string(from: date!)) as String
        plan_start_date = plan_start_date + " \(created)"
        let  group_name = GroupDic .object(forKey: "group_name") as! NSString as String
        let desgroup_name = try! group_name.aesDecrypt(key: key, iv: iv)
        cell.GroupNamelbl.text = desgroup_name as String

        let Todaydate : NSDate = NSDate()
        
        if date! < Todaydate as Date {
            print("earlier")
            cell.statuslbl.text = "Already Started";
            cell.statuslbl.textColor =  UIColor.green;
        }else{
            print("not earlier")
            cell.statuslbl.text = "Not started yet"
            cell.statuslbl.textColor =  UIColor.red;
        }
        cell.DateLbl.text = plan_start_date as NSString as String
        cell.ShadowView.layer.borderColor = UIColor.purple.cgColor;
        cell.ShadowView.layer.borderWidth = 1.0;
        cell.ShadowView.layer.cornerRadius = 8.0;
        
        
        
        
       
        return cell;
    }
    
    // MARK: - UITableView delegates
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
         let dict = self.Arr_group[indexPath.row] as! NSDictionary
         let  admin_id = dict .object(forKey: "admin_id") as! NSString as String
        var checksetstaus = ""
        if admin_id == LoginId as String {
            let DateString = dict .object(forKey: "plan_start_date") as! NSString as String
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd/MM/yyyy"
            let date: Date? = dateFormatterGet.date(from: DateString)
            print(dateFormatterPrint.string(from: date!))
             var isrecurring = dict .object(forKey: "isrecurring") as! NSString as String
             let calendar = NSCalendar.current
             let Todaydate : NSDate = calendar.startOfDay(for: NSDate() as Date) as NSDate
            
            if date! <= Todaydate as Date  {
                 checksetstaus = "Gone"
               
            }else{
                if isrecurring == "false" {
                    checksetstaus = "visable"
                }else{
                    checksetstaus = "Gone"
                }
                
            }
        }else{
        checksetstaus = "Gone"
        
        }
         //if LoginId ==
        print(checksetstaus)
        let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginView:GroupDetailsViewController = (story.instantiateViewController(withIdentifier: "DetailgroupViewController") as? GroupDetailsViewController)!
        LoginView.DetailsDictionary = (dict ) as! [String : AnyObject]
         LoginView.checksetstaus =  checksetstaus as NSString
        self.navigationController?.pushViewController(LoginView, animated: true)
    }
    @IBAction func ActionOnmenu(_ sender: Any) {
        let elDrawer = (self.navigationController!.parent! as! KYDrawerController)
        elDrawer.setDrawerState(.opened, animated: true)

    }
    func GroupListService(){
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
        let parameters = ["customer_id": LoginId as String,"auth_token": token] as Dictionary<String, String>
        Dictonary.setObject(parameters, forKey : "retrievegroups" as NSCopying)
        
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
                            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                            var status = json["status"] as? NSString
                            if (status?.isEqual(to: "success"))! {
                                 self.NODataLabel.isHidden = true
                            let swappayout = json["swappayout"] as? NSString
                            let user_rating = json["user_rating"] as? NSString
                             UserDefaults.standard.set(user_rating, forKey: "user_rating")
                            UserDefaults.standard.set(swappayout, forKey: "swappayout")
                                
                            UserDefaults.standard.set("YES", forKey: "Isuser_rating");
                            self.Arr_group = (json["groups"] as? NSMutableArray)!;
                                
            
                                self.GroupTableView .reloadData()
                                
                            }else{
                                let Alert:UIAlertView = UIAlertView(title: "Alert", message: "NO date Found", delegate: self, cancelButtonTitle: "Ok")
                                self.NODataLabel.isHidden = false
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
                self.isurl = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/webservices/retrievegroups"
                self.GroupListService()
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
