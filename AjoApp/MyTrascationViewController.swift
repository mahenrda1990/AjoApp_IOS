//
//  MyTrascationViewController.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 27/02/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class MyTrascationViewController: UIViewController {
    var MyTranscation_Arr = NSMutableArray()
    var LoginId: NSString = NSString()
    var isurl1: NSString = NSString()
    var key = "ajoapp17mindcrew"
    var iv = "mindcrewajoapp17"
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var BagroundView: UIView!
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var MyTranscationTableView: UITableView!
    
    @IBOutlet weak var NOdataLabel: UILabel!
    @IBAction func ActionTotorial(_ sender: Any) {
        self.ContentView.isHidden = false
        self.BagroundView.isHidden = false
    }
    @IBAction func ActionOnOk(_ sender: Any) {
        self.ContentView.isHidden = true
        self.BagroundView.isHidden = true
    }
    func tapBlurButton(_ sender: UITapGestureRecognizer) {
        self.ContentView.isHidden = true
        self.BagroundView.isHidden = true
    }
    func refresh(_ sender:AnyObject) {
        //self.GroupListService()
        self.MyTranscationTableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isurl1 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/mytransactions/grouplist"
        self.MyTranscation_Arr = NSMutableArray()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        self.BagroundView.addGestureRecognizer(tapGesture)
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red: 161/255.0, green: 73/255.0, blue: 221/255.0, alpha: 1.0)
        refreshControl.addTarget(self, action: #selector(MyTrascationViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        self.MyTranscationTableView.addSubview(refreshControl) //
        // Do any additional setup after loading the view.
        LoginId = (UserDefaults.standard.object(forKey: "loginid")as? NSString)!
        self.navigationController?.isNavigationBarHidden = true
        
        self.MyTranscationService()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LoginId = (UserDefaults.standard.object(forKey: "loginid")as? NSString)!
        self.navigationController?.isNavigationBarHidden = true

        
    }
    func MyTranscationService(){
        
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.labelText = "Please wait"
        let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
        
        let Dictonary: NSMutableDictionary = NSMutableDictionary()
        let parameters = ["customer_id": LoginId as String,"auth_token": token] as Dictionary<String, String>
        Dictonary.setObject(parameters, forKey : "grouplist" as NSCopying)
        
       

        
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
                                
                                self.NOdataLabel.isHidden = true
                                var newarr = NSMutableArray()
                                newarr = (json["groups"] as? NSMutableArray)!;
                                self.MyTranscation_Arr .removeAllObjects()
                                for item in newarr.reversed() {
                                                                    print("Found \(item)")
                                                                    self.MyTranscation_Arr.add(item)
                                    }
                                
                                
                                self.MyTranscationTableView .reloadData()
                                
                            }else{
                                self.MyTranscation_Arr .removeAllObjects()
                                self.NOdataLabel.isHidden = false
                                self.MyTranscationTableView .reloadData()
                                
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
                self.isurl1 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/mytransactions/grouplist"
                self.MyTranscationService()
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MyTranscation_Arr.count
        //return 10;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("menuCell");
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTranCell", for: indexPath) as! MyTransactionTableViewCell
        cell.ShadowView.layer.borderColor = UIColor.purple.cgColor;
        cell.ShadowView.layer.borderWidth = 1.0;
        cell.ShadowView.layer.cornerRadius = 8.0;
        let GroupDic = self.MyTranscation_Arr[indexPath.row] as! NSDictionary
        var plan_start_date = "members"
        let members = GroupDic .object(forKey: "members") as! NSString as String
        plan_start_date = members + " \(plan_start_date)"
        cell.Menberlbl.text = plan_start_date
        let  group_name = GroupDic .object(forKey: "group_name") as! NSString as String
         let Namegroup_name = try! group_name.aesDecrypt(key: self.key, iv: self.iv)
        cell.HeadingLbl.text = Namegroup_name as String
    
        return cell;
    }
    
    // MARK: - UITableView delegates
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let dict = self.MyTranscation_Arr[indexPath.row] as! NSDictionary
        let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginView:PayoutViewController = (story.instantiateViewController(withIdentifier: "PayoutViewController") as? PayoutViewController)!
        LoginView.DetailsDictionary = (dict ) as! [String : AnyObject]
        self.navigationController?.pushViewController(LoginView, animated: true)

       // PayoutViewController
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
