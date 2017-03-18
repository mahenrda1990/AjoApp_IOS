//
//  SwapOutViewController.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 03/03/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class SwapOutViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{
    var LoginId: NSString = NSString()
    var items : NSMutableArray!
    var isurl1: NSString = NSString()
    var isurl2: NSString = NSString()
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var GroupNamelbl: UILabel!
    var key = "ajoapp17mindcrew"
    var iv = "mindcrewajoapp17"
    
    
    @IBOutlet weak var Donebtnout: UIButton!
    @IBOutlet weak var ScrollView: UIScrollView!
    
    var totalCount = 0
    let reuseIdentifier = "SwapCell"
    var group_id: NSString = NSString()
    var group_Name: NSString = NSString()
    var startdate: NSString = NSString()
    var payout_turnavilabel: NSString = NSString()
    var avilabelcheck: NSString = NSString()
    
    var swap_customer_id: NSString = NSString()
    var isavailable: NSString = NSString()
    var selectedCellIndexPath : IndexPath!
    

    @IBOutlet weak var SwapOutCollectionview: UICollectionView!
    
    
    @IBAction func ActionONDone(_ sender: Any) {
        if avilabelcheck == "CheckAvilable"{
            
            if  LoginId == swap_customer_id{
                var alert = UIAlertView(title: "You can't swap payout turn with your current payout.", message: nil, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }else{
                SwapOutWebservice()
            }
            
        }else{
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isurl1 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/webservices/getswappayoutdetails"
        self.isurl2 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/webservices/updateswappayout"
         items = NSMutableArray ()
        // Do any additional setup after loading the view.
    }
  
    override func viewDidAppear(_ animated: Bool) {
        LoginId = (UserDefaults.standard.object(forKey: "loginid")as? NSString)!
        self.navigationController?.isNavigationBarHidden = true
        self.ScrollView.layer.borderColor = UIColor.purple.cgColor;
        self.ScrollView.layer.borderWidth = 1.0;
        self.ScrollView.layer.cornerRadius = 8.0;
        
        self.Donebtnout.layer.borderColor = UIColor.white.cgColor;
        self.Donebtnout.layer.borderWidth = 1.0;
        self.Donebtnout.layer.cornerRadius = 8.0;
        let payout_start_date = startdate
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy"
        let date: Date? = dateFormatterGet.date(from: payout_start_date as String)
       
        print(dateFormatterPrint.string(from: date!))
        let created = (dateFormatterPrint.string(from: date!)) as String
        let gnamee = group_Name as String
        let group_namee = try! gnamee.aesDecrypt(key: self.key, iv: self.iv)
        var Gname = "Group : "
        self.GroupNamelbl.text =  Gname + (group_namee as String) as String
        self.DateLabel.text = created
        SwapOutDetilsWebservice()
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
        
     

    }
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwapCell", for: indexPath) as! SwapOutCollectionViewCell
        let  dic = self.items[indexPath.row] as! NSDictionary
        var plan_start_date = ""
        let DateString = dic .object(forKey: "payout_date") as! NSString as String
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy"
        let date: Date? = dateFormatterGet.date(from: DateString)
        print(dateFormatterPrint.string(from: date!))
        let created = (dateFormatterPrint.string(from: date!)) as String
        plan_start_date = plan_start_date + " \(created)"
        cell.DateLbl .text = plan_start_date
        var  isalreadypayout = dic .object(forKey: "isalreadypayout") as! NSString as String
        var  isswapbusy = dic .object(forKey: "isswapbusy") as! NSString as String
        
        var  isswappayout = dic .object(forKey: "isswappayout") as! NSString as String
        
        var  payout_turn = dic .object(forKey: "payout_turn") as! NSString as String
        
        
        if isalreadypayout == "true"{
            let  group_name = dic .object(forKey: "payout_member") as! NSString as String
            let group_namee = try! group_name.aesDecrypt(key: self.key, iv: self.iv)
            cell.NameLbel.text = group_namee as String
            cell.CounntLabel.layer.cornerRadius = cell.CounntLabel.bounds.size.width/2;
            cell.CounntLabel.layer.masksToBounds = true;
            cell.CounntLabel.backgroundColor = UIColor .red
            cell.DateLbl.textColor = UIColor .brown
            cell.NameLbel.textColor = UIColor .brown
            cell.CounntLabel.textColor = UIColor .white
            cell.CounntLabel.text = payout_turn as String

        
        }else{
            if isswappayout == "true"{
                if isswapbusy == "false"{
                    let  group_name = dic .object(forKey: "payout_member") as! NSString as String
                    
                   if  group_name  == "Available"{
                    
                    if ((selectedCellIndexPath != nil) && (selectedCellIndexPath == indexPath)) {
                        
                        cell.NameLbel.text = group_name as String
                        cell.CounntLabel.layer.cornerRadius = cell.CounntLabel.bounds.size.width/2;
                        cell.CounntLabel.layer.masksToBounds = true;
                        cell.CounntLabel.backgroundColor = UIColor .green
                        cell.DateLbl.textColor = UIColor .brown
                        cell.NameLbel.textColor = UIColor .brown
                        cell.CounntLabel.textColor = UIColor .white
                    }else {
                    cell.NameLbel.text = group_name as String
                    cell.CounntLabel.layer.cornerRadius = cell.CounntLabel.bounds.size.width/2;
                    cell.CounntLabel.layer.masksToBounds = true;
                    cell.CounntLabel.backgroundColor = UIColor .lightGray
                    cell.DateLbl.textColor = UIColor .green
                    cell.NameLbel.textColor = UIColor .green
                    cell.CounntLabel.textColor = UIColor .white
                    cell.CounntLabel.text = payout_turn as String
                    }
                    //click

                   }else{
                     let  group_name = dic .object(forKey: "payout_member") as! NSString as String
                        if ((selectedCellIndexPath != nil) && (selectedCellIndexPath == indexPath)) {
                            
                           // cell.NameLbel.text = group_name as String
                            cell.CounntLabel.layer.cornerRadius = cell.CounntLabel.bounds.size.width/2;
                            cell.CounntLabel.layer.masksToBounds = true;
                            cell.CounntLabel.backgroundColor = UIColor .green
                            cell.DateLbl.textColor = UIColor .brown
                            cell.NameLbel.textColor = UIColor .brown
                            cell.CounntLabel.textColor = UIColor .white
                        }else{
                            let group_namee = try! group_name.aesDecrypt(key: self.key, iv: self.iv)
                            cell.NameLbel.text = group_namee as String
                            cell.CounntLabel.layer.cornerRadius = cell.CounntLabel.bounds.size.width/2;
                            cell.CounntLabel.layer.masksToBounds = true;
                            cell.CounntLabel.backgroundColor = UIColor .lightGray
                            cell.DateLbl.textColor = UIColor .green
                            cell.NameLbel.textColor = UIColor .green
                            cell.CounntLabel.textColor = UIColor .white
                            cell.CounntLabel.text = payout_turn as String
                                                   //click
                        

                    }
                }
                    
                }else{
                     var  group_name = dic .object(forKey: "payout_member") as! NSString as String
                    let group_namee = try! group_name.aesDecrypt(key: self.key, iv: self.iv)
                    cell.NameLbel.text = group_namee as String
                    cell.CounntLabel.layer.cornerRadius = cell.CounntLabel.bounds.size.width/2;
                    cell.CounntLabel.layer.masksToBounds = true;
                    cell.CounntLabel.backgroundColor = UIColor .green
                    cell.DateLbl.textColor = UIColor .brown
                    cell.NameLbel.textColor = UIColor .brown
                    cell.CounntLabel.textColor = UIColor .white
                    cell.CounntLabel.text = payout_turn as String
                   
                
                }
            }else{
                
                var  group_name = dic .object(forKey: "payout_member") as! NSString as String
                if group_name == "Available"{
                    
                    if ((selectedCellIndexPath != nil) && (selectedCellIndexPath == indexPath)) {
                        cell.NameLbel.text = group_name as String
                        cell.CounntLabel.layer.cornerRadius = cell.CounntLabel.bounds.size.width/2;
                        cell.CounntLabel.layer.masksToBounds = true;
                        cell.CounntLabel.backgroundColor = UIColor .green
                        cell.DateLbl.textColor = UIColor .brown
                        cell.NameLbel.textColor = UIColor .brown
                        cell.CounntLabel.textColor = UIColor .white
                    }else{
                        cell.NameLbel.text = group_name as String
                        cell.CounntLabel.layer.cornerRadius = cell.CounntLabel.bounds.size.width/2;
                        cell.CounntLabel.layer.masksToBounds = true;
                        cell.CounntLabel.backgroundColor = UIColor .lightGray
                        cell.DateLbl.textColor = UIColor .green
                        cell.NameLbel.textColor = UIColor .green
                        cell.CounntLabel.textColor = UIColor .white
                    
                    }

                }else{
                    let group_namee = try! group_name.aesDecrypt(key: self.key, iv: self.iv)
                    print(group_namee) // foo
                    cell.NameLbel.text = group_namee as String
                    cell.CounntLabel.layer.cornerRadius = cell.CounntLabel.bounds.size.width/2;
                    cell.CounntLabel.layer.masksToBounds = true;
                    cell.CounntLabel.backgroundColor = UIColor .green
                    cell.DateLbl.textColor = UIColor .brown
                    cell.NameLbel.textColor = UIColor .brown
                    cell.CounntLabel.textColor = UIColor .white
                    
                }
               
              
            }
       
        }
        
       

        return cell
        
    }
   
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
        var cell = collectionView.cellForItem(at: indexPath) as! SwapOutCollectionViewCell
        let  dic = self.items[indexPath.row] as! NSDictionary

        var  isalreadypayout = dic .object(forKey: "isalreadypayout") as! NSString as String
        var  isswapbusy = dic .object(forKey: "isswapbusy") as! NSString as String
        
        var  isswappayout = dic .object(forKey: "isswappayout") as! NSString as String
        
        var  payout_turn = dic .object(forKey: "payout_turn") as! NSString as String
        
        
        if isalreadypayout == "true"{
            let  group_name = dic .object(forKey: "payout_member") as! NSString as String
             avilabelcheck = "UNAvilable"
            //Not click
            
        }else{
            if isswappayout == "true"{
                if isswapbusy == "false"{
                    var  group_name = dic .object(forKey: "payout_member") as! NSString as String
                    
                    if  group_name  == "Available"{
                        selectedCellIndexPath = indexPath;
                        collectionView.reloadData()
                        let selectedDic = self.items[selectedCellIndexPath.row] as! NSDictionary
                                print(selectedDic)
                        payout_turnavilabel = (selectedDic .object(forKey: "payout_turn") as! NSString) as String as String as NSString
                        avilabelcheck = "CheckAvilable"
                        swap_customer_id =  (selectedDic .object(forKey: "customer_id") as! NSString) as String as String as NSString
                        
                      
                        //click
                        
                    }else{
                        selectedCellIndexPath = indexPath;
                        collectionView.reloadData()
                        let selectedDic = self.items[selectedCellIndexPath.row] as! NSDictionary
                        print(selectedDic)
                        payout_turnavilabel = (selectedDic .object(forKey: "payout_turn") as! NSString) as String as String as NSString
                        avilabelcheck = "CheckAvilable"
                        swap_customer_id =  (selectedDic .object(forKey: "customer_id") as! NSString) as String as String as NSString                        //click

                    }
                    
                }else{
                    avilabelcheck = "UNAvilable"

                    // Not click
                    
                }
            }else{
                
                var  group_name = dic .object(forKey: "payout_member") as! NSString as String
                if group_name == "Available"{
                    selectedCellIndexPath = indexPath;
                    collectionView.reloadData()
                    let selectedDic = self.items[selectedCellIndexPath.row] as! NSDictionary
                    print(selectedDic)
                    payout_turnavilabel = (selectedDic .object(forKey: "payout_turn") as! NSString) as String as String as NSString
                    avilabelcheck = "CheckAvilable"
                    swap_customer_id =  (selectedDic .object(forKey: "customer_id") as! NSString) as String as String as NSString

                    //click
                    
                }else{
                    avilabelcheck = "UNAvilable"

                        //Not click
                    
                }
                
                
            }
            
        }
        
    }

        func SwapOutDetilsWebservice(){
            if Reachability.shared().internetConnectionStatus() == NotReachable {
                var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }else{
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification?.labelText = "Please wait"
            let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
    
    
            let Dictonary: NSMutableDictionary = NSMutableDictionary()
            let parameters = ["group_id": group_id as String,"customer_id": LoginId as String,"auth_token": token] as Dictionary<String, String>
            Dictonary.setObject(parameters, forKey : "swappayoutdetails" as NSCopying)
    
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
    
                              self.items = json["members"] as? NSMutableArray
    
                            self.SwapOutCollectionview .reloadData()
    
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
                    self.isurl1 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/webservices/getswappayoutdetails"
                    self.SwapOutDetilsWebservice()
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
    
    
    

    @IBAction func ActionONback(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func SwapOutWebservice(){
        
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
            
            let Name = group_Name as String
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification?.labelText = "Please wait"
            let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
            
            let Dictonary: NSMutableDictionary = NSMutableDictionary()
            let parameters = ["group_id": group_id as String,"customer_id": LoginId as String,"swap_customer_id": swap_customer_id as String,"swap_request_notification": "false",isavailable as String: "false","group_name": Name as String,"auth_token": token] as Dictionary<String, String>
            Dictonary.setObject(parameters, forKey : "updateswappayout" as NSCopying)
            

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
                                    let Alert:UIAlertView = UIAlertView(title: "Alert", message: "This payout turn is already requested by someone, please try another!", delegate: self, cancelButtonTitle: "Ok")
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
                            //Alert.show()
                            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        })
                        
                    }
                    
                } catch let error {
                    self.isurl2 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/webservices/updateswappayout"
                    self.SwapOutWebservice()
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
