//
//  LeftMenuViewController.swift
//  MedicalRepill
//
//  Created by iPhones on 10/27/16.
//  Copyright © 2016 PS.com. All rights reserved.
//

import UIKit
import CoreData

class LeftMenuViewController: UIViewController {
    

    @IBOutlet weak var ratinglabel: UILabel!
    @IBOutlet weak var Mobileno_lbl: UILabel!
    var LoginId: NSString = NSString()
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var lefttableView: UITableView!
    var isurl1: NSString = NSString()
    var arrayofMenu:NSArray = [] ;
    var key = "ajoapp17mindcrew"
    var iv = "mindcrewajoapp17"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isurl1 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/logout"
        arrayofMenu = [
            ["menuPicture": "inbox_chat.png", "menuName": "Inbox"],
            ["menuPicture": "add_new_group.png", "menuName": "Add New Group"],
            ["menuPicture": "requests.png", "menuName": "Requests"],
            ["menuPicture": "acknowledgement.png", "menuName": "Acknowledgement"],
            ["menuPicture": "my_transactions.png", "menuName": "My Transactions"],
            ["menuPicture": "contact_us.png", "menuName": "About"],
            ["menuPicture": "logout.png", "menuName": "Log Out"]
        ]
       
        //user_rating

    }
  
    override func viewDidAppear(_ animated: Bool) {
        LoginId = (UserDefaults.standard.object(forKey: "loginid")as? NSString)!
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isNavigationBarHidden = true
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        let mobile = (UserDefaults.standard.object(forKey: "mobile_no")as? NSString)! as String
        let desmobile = try! mobile.aesDecrypt(key: key, iv: iv)
        let country_code = (UserDefaults.standard.object(forKey: "country_code")as? NSString)!
        self.Mobileno_lbl.text =  (country_code as String) + desmobile as String
        //print(desmobile)
        let Name = (UserDefaults.standard.object(forKey: "fname")as? NSString)! as String
        let desName = try! Name.aesDecrypt(key: key, iv: iv)
        self.NameLbl.text = desName as String
        if UserDefaults.standard.string(forKey: "Isuser_rating") == "YES"{
        let Ratings = "Credit Score : "
        let  GetRating = (UserDefaults.standard.object(forKey: "user_rating")as? NSString)!
        let point = " Points"
        self.ratinglabel.text = Ratings + ((GetRating as String) + point as String)
        } else {
            let Ratings = "Credit Score : "
            let  GetRating = "0"
            let point = " Points"
            self.ratinglabel.text = Ratings + ((GetRating as String) + point as String)
        }
        
       
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayofMenu.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("menuCell");
        let cell = tableView.dequeueReusableCell(withIdentifier: "menucell", for: indexPath) as! LeftTableViewCell
        let dict:NSDictionary = arrayofMenu[indexPath.row] as! NSDictionary
        cell.menuIcon.image = UIImage(named: dict.object(forKey: "menuPicture") as! String)
        cell.menuName.text = dict.object(forKey: "menuName") as! NSString as String
        return cell;
    }
    
    // MARK: - UITableView delegates
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        switch(indexPath.row)
        {
        case 0:
            
            let elDrawer = (self.navigationController!.parent! as! KYDrawerController)
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InboxViewController")
            let navController = UINavigationController(rootViewController: viewController)
            navController.isNavigationBarHidden = true
            elDrawer.mainViewController = navController
            elDrawer.setDrawerState(.closed, animated: true)
            break
        case 1:
            let elDrawer = (self.navigationController!.parent! as! KYDrawerController)
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNewGroupController")
            let navController = UINavigationController(rootViewController: viewController)
            navController.isNavigationBarHidden = true
            elDrawer.mainViewController = navController
            elDrawer.setDrawerState(.closed, animated: true)
            
            break
            
        case 2:
    
            let elDrawer = (self.navigationController!.parent! as! KYDrawerController)
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestViewController")
            let navController = UINavigationController(rootViewController: viewController)
            navController.isNavigationBarHidden = true
            elDrawer.mainViewController = navController
            elDrawer.setDrawerState(.closed, animated: true)
            break
        
        case 3:
            let elDrawer = (self.navigationController!.parent! as! KYDrawerController)
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AcknowledgmentViewController")
            let navController = UINavigationController(rootViewController: viewController)
            navController.isNavigationBarHidden = true
            elDrawer.mainViewController = navController
            elDrawer.setDrawerState(.closed, animated: true)
            break
        case 4:
            let elDrawer = (self.navigationController!.parent! as! KYDrawerController)
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyTrascationViewController")
            let navController = UINavigationController(rootViewController: viewController)
            navController.isNavigationBarHidden = true
            elDrawer.mainViewController = navController
            elDrawer.setDrawerState(.closed, animated: true)
            break
        case 5:
            let elDrawer = (self.navigationController!.parent! as! KYDrawerController)
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutusViewController")
            let navController = UINavigationController(rootViewController: viewController)
            navController.isNavigationBarHidden = true
            elDrawer.mainViewController = navController
            elDrawer.setDrawerState(.closed, animated: true)
            break

            
        case 6:
            
            let actionSheetController: UIAlertController = UIAlertController(title: "Are you sure you want to Logout?", message: "", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "NO", style: .cancel) { action -> Void in
                //Do your task
            }
            actionSheetController.addAction(cancelAction)
            let nextAction: UIAlertAction = UIAlertAction(title: "YES", style: .default) { action -> Void in
            self.LogoutService()
                
            }
            actionSheetController.addAction(nextAction)
            self.present(actionSheetController, animated: true, completion: nil)
        break
            
        default:
            break
        }
        
    }
    // MARK: - UITableView delegates
    func tableView(_ tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
        //declaring the cell variable again
        
    }

    @IBAction func ActionOnprofile(_ sender: Any) {
        let elDrawer = (self.navigationController!.parent! as! KYDrawerController)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyProfileViewController")
        let navController = UINavigationController(rootViewController: viewController)
        navController.isNavigationBarHidden = true
        elDrawer.mainViewController = navController
        elDrawer.setDrawerState(.closed, animated: true)
        //MyProfileViewController
    }
    func LogoutService(){
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
                Dictonary.setObject(parameters, forKey : "logout" as NSCopying)
                

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
                                UserDefaults.standard.set("NO", forKey: "LOGIN");
                                let defaults = UserDefaults.standard
                                defaults.removeObject(forKey: "selectedIndex")
                                defaults.removeObject(forKey: "IsHome")
                                defaults.removeObject(forKey: "loginid")
                                defaults.removeObject(forKey: "fname")
                                defaults.removeObject(forKey: "mobile_no")
                                defaults.removeObject(forKey: "mobile_only")
                                defaults.removeObject(forKey: "email")
                                defaults.removeObject(forKey: "phoneNumber")
                                defaults.removeObject(forKey: "MOBNO")
                                defaults.removeObject(forKey: "CCode")
                                defaults.removeObject(forKey: "status")
                                defaults.removeObject(forKey: "country_code")
                                defaults.removeObject(forKey: "message")
                                defaults.removeObject(forKey: "PasswordSave")
                                defaults.removeObject(forKey: "Ishidenshow2")
                                defaults.removeObject(forKey: "Ishidenshow1")
                                defaults.removeObject(forKey: "user_rating")
                                defaults.removeObject(forKey: "swappayout")
                                defaults.removeObject(forKey: "Isuser_rating")
                                       
                                        
                                defaults.removeObject(forKey: "Isnotifcation")
                                defaults.removeObject(forKey: "groupID_notfiction")
                                defaults.removeObject(forKey: "groupName_notfiction")
                                defaults.synchronize()
                                let elDrawer = (self.navigationController!.parent! as! KYDrawerController)
                                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
                                let navController = UINavigationController(rootViewController: viewController)
                                navController.isNavigationBarHidden = true
                                elDrawer.mainViewController = navController
                                elDrawer.setDrawerState(.closed, animated: true)
                                        
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
                        self.isurl1 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/logout"
                        self.LogoutService()
                        print(error.localizedDescription)
                    }
                })
                task.resume()
            }
        }
    }
}
