//
//  InboxViewController.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 23/02/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController {
    @IBOutlet weak var Inboxtableview: UITableView!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var BagroundView: UIView!
    var refreshControl: UIRefreshControl!
    var isurl1: NSString = NSString()
    var key = "ajoapp17mindcrew"
    var iv = "mindcrewajoapp17"
    @IBOutlet weak var NODataFound: UILabel!
    @IBAction func ActionOnOk(_ sender: Any) {
        self.ContentView.isHidden = true
        self.BagroundView.isHidden = true
    }
    
    @IBAction func ActionOnTotoria(_ sender: Any) {
        
        self.ContentView.isHidden = false
        self.BagroundView.isHidden = false
    }
    func refresh(_ sender:AnyObject) {
        //self.GroupListService()
        self.Inboxtableview.reloadData()
        self.refreshControl?.endRefreshing()
    }

    var Inbox_Arr = NSMutableArray()
    var LoginId: NSString = NSString()
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginId = (UserDefaults.standard.object(forKey: "loginid")as? NSString)!
        self.Inbox_Arr = NSMutableArray()
        self.navigationController?.isNavigationBarHidden = true
    }
    func tapBlurButton(_ sender: UITapGestureRecognizer) {
        self.ContentView.isHidden = true
        self.BagroundView.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        LoginId = (UserDefaults.standard.object(forKey: "loginid")as? NSString)!
        self.isurl1 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/groupchat/inboxlist"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        self.BagroundView.addGestureRecognizer(tapGesture)
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red: 161/255.0, green: 73/255.0, blue: 221/255.0, alpha: 1.0)
        refreshControl.addTarget(self, action: #selector(InboxViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        self.Inboxtableview.addSubview(refreshControl) // not
        // Do any additional setup after loading the view.
        LoginId = (UserDefaults.standard.object(forKey: "loginid")as? NSString)!
        self.Inbox_Arr = NSMutableArray()
        self.navigationController?.isNavigationBarHidden = true
        
        self.InboxListService()
        //self.InboxListService()
    }
    func InboxListService(){
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
        
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.labelText = "Please wait"
        let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
        
        let Dictonary: NSMutableDictionary = NSMutableDictionary()
        let parameters = ["customer_id": LoginId as String,"auth_token": token] as Dictionary<String, String>
        Dictonary.setObject(parameters, forKey : "inboxlist" as NSCopying)
        

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
                                self.NODataFound.isHidden = true
                                self.Inbox_Arr .removeAllObjects()
                                let newarr = (json["groups"] as? NSMutableArray)!;
                                
                               // self.Inbox_Arr.reversed()
                                for item in newarr.reversed() {
                                    print("Found \(item)")
                                  self.Inbox_Arr.add(item)
                                }
                               // self.Inbox_Arr = (self.Inbox_Arr as NSArray).sortedArray(using: [NSSortDescriptor(key: "chatcount", ascending: true)]) as! [[String:AnyObject]]

                                self.Inbox_Arr = (self.Inbox_Arr as NSArray).sortedArray(using: [NSSortDescriptor.init(key: "chatcount", ascending: false) ]) as! NSMutableArray
                                
                                print(self.Inbox_Arr);
                                self.Inboxtableview .reloadData()
                                
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
                 self.isurl1 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/groupchat/inboxlist"
                self.InboxListService()
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
        
        return Inbox_Arr.count
        //return 10;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("menuCell");
        let cell = tableView.dequeueReusableCell(withIdentifier: "Inbox", for: indexPath) as! InboxTableViewCell
        cell.ShadowView.layer.borderColor = UIColor.purple.cgColor;
        cell.ShadowView.layer.borderWidth = 1.0;
        cell.ShadowView.layer.cornerRadius = 8.0;
        let GroupDic = self.Inbox_Arr[indexPath.row] as! NSDictionary
        var plan_start_date = "members"
        let members = GroupDic .object(forKey: "members") as! NSString as String
        plan_start_date = members + " \(plan_start_date)"
        cell.Menberlbl.text = plan_start_date
        let  group_name = GroupDic .object(forKey: "group_name") as! NSString as String
        let desgroup_nameinbox = try! group_name.aesDecrypt(key: key, iv: iv)
        cell.HeadingLbl.text = desgroup_nameinbox as String
        
        let chatcount = GroupDic .object(forKey: "chatcount") as! NSString as String
        if chatcount == "0"{
            cell.CountLable.text = chatcount
            cell.CountLable.layer.cornerRadius = cell.CountLable.frame.size.height/2
            cell.CountLable.layer.masksToBounds = true
            cell.CountLable.layer.borderWidth = 0
            cell.CountLable.isHidden =  true
        }else{
            cell.CountLable.text = chatcount
            cell.CountLable.layer.cornerRadius = cell.CountLable.frame.size.height/2
            cell.CountLable.layer.masksToBounds = true
            cell.CountLable.layer.borderWidth = 0
            cell.CountLable.isHidden =  false

        }
       

//        chatcount = 0;
//        "group_id" = 379;
//        "group_name" = "TmV3IGludml0ZQ==";
//        members = 2;
        return cell;
    }
    
    // MARK: - UITableView delegates
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let GroupDic = self.Inbox_Arr[indexPath.row] as! NSDictionary
        let  group_id = GroupDic .object(forKey: "group_id") as! NSString as String
       
        let  group_Name = GroupDic .object(forKey: "group_name") as! NSString as String
        let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginView:ChatViewController = (story.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController)!

        LoginView.groupid = (group_id ) as NSString
        LoginView.groupname = (group_Name ) as NSString
        self.navigationController?.pushViewController(LoginView, animated: true)
        
        
    }
    @IBAction func ActionOnmenu(_ sender: Any) {
        let elDrawer = (self.navigationController!.parent! as! KYDrawerController)
        elDrawer.setDrawerState(.opened, animated: true)
        
    }

    @IBAction func ActionOnback(_ sender: Any) {
        let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginView:KYDrawerController = (story.instantiateViewController(withIdentifier: "KYDrawerController") as? KYDrawerController)!
        self.navigationController?.pushViewController(LoginView, animated: true)
        
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
