//
//  AppDelegate.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 23/02/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit
import Fabric
import DigitsKit
var strDeviceToken = ""
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var token: String = ""
    var mCustomerId: String = ""
    var type: String = ""
    var groupID: String = ""
    var groupName: String = ""
    var message: String = ""
    var LoginId: NSString = NSString()
    var isurl: NSString = NSString()
    
    var window: UIWindow?
  //  let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //let strCountryCode = appDelegate.someVariable


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
      

        
    // Override point for customization after application launch.
         Fabric.with([Digits.self])
        if UserDefaults.standard.string(forKey: "LOGIN") == "YES"{
            LoginId = (UserDefaults.standard.object(forKey: "loginid")as? NSString)!
            self.isurl = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/webservices/insertdevicetoken"
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "KYDrawerController") as! KYDrawerController
            let navController = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            window!.rootViewController = navController;
            window!.makeKeyAndVisible()
        }
        
        return true
    }
    func Gotorequest(){
        if UserDefaults.standard.string(forKey: "LOGIN") == "YES"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "KYDrawerControllerreruest") as! KYDrawerController
            let navController = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            window!.rootViewController = navController;
            window!.makeKeyAndVisible()
        }

    }
    func GotoChat(){
        if UserDefaults.standard.string(forKey: "LOGIN") == "YES"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "KYDrawerControllerChatview") as! KYDrawerController
            let navController = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            window!.rootViewController = navController;
            window!.makeKeyAndVisible()
        }
        
    }
   
    func GotoMytransction(){
        if UserDefaults.standard.string(forKey: "LOGIN") == "YES"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "KYDrawerControllerMytransction") as! KYDrawerController
            let navController = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            window!.rootViewController = navController;
            window!.makeKeyAndVisible()
        }
        
    }
    func GotoAcknowlag(){
        if UserDefaults.standard.string(forKey: "LOGIN") == "YES"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "KYDrawerControllerAcknowlage") as! KYDrawerController
            let navController = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            window!.rootViewController = navController;
            window!.makeKeyAndVisible()
        }
        
    }
    
    //
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var token: String = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
                let alertView2 = UIAlertView(
                    title: "Notification",
                    message: token,
                    delegate: self,
                    cancelButtonTitle: "OK"
                )
            //alertView2.show()
         print(token)
         UserDefaults.standard.set(token, forKey: "deviceToken")
    }
    //MARK: - Notification Method
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
       // print(error.description)
    }
    fileprivate func convertDeviceTokenToString(_ deviceToken:Data) -> String {
        //  Convert binary Device Token to a String (and remove the <,> and white space charaters).stringByReplacingOccurrencesOfString(">", withString: "", options:nil , range: nil)
        var deviceTokenStr = deviceToken.description.replacingOccurrences(of: ">", with: "")
        deviceTokenStr = deviceTokenStr.replacingOccurrences(of: "<", with: "")
        deviceTokenStr = deviceTokenStr.replacingOccurrences(of: " ", with: "")
        
        // Our API returns token in all uppercase, regardless how it was originally sent.
        // To make the two consistent, I am uppercasing the token string here.
        deviceTokenStr = deviceTokenStr.uppercased()
        return deviceTokenStr
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
        
        let aps = data["aps" as NSString] as? [String:AnyObject]
       
        
        let alert = aps?["alert"] as! String
        let data = aps?["data"] as! NSDictionary
        switch application.applicationState {
        case .active:
            //app is currently active, can update badges count here
            break
        case .inactive:
        
            type = data["type"] as! String
            
            //alertView2.show()
            if type == "invitation_request"{
                // requst grouplist
                Gotorequest()
                
            }else if type == "swap_request"{
                // requst grouplist
                Gotorequest()
                
            }else if type == "receive_payout"{
                GotoMytransction()
                //mytransction list
                
            }else if type == "payout_start_date"{
                groupID = data["group_id"] as! String
                groupName = data["group_name"] as! String
                UserDefaults.standard.set(groupName, forKey: "groupName_notfiction")
                UserDefaults.standard.set(groupID, forKey: "groupID_notfiction")
                UserDefaults.standard.set("YES", forKey: "Isnotifcation");
                
                GotoAcknowlag()
                //Acknolagemetn details
                //id and name
            }else if type == "accept_payment"{
                //Acknolagemetn details
                //id and name
                groupID = data["type"] as! String
                groupName = data["type"] as! String
                UserDefaults.standard.set(groupName, forKey: "groupName_notfiction")
                UserDefaults.standard.set(groupID, forKey: "groupID_notfiction")
                UserDefaults.standard.set("YES", forKey: "Isnotifcation");
                GotoAcknowlag()
                
            }else if type == "yes_payment"{
                groupID = data["group_id"] as! String
                groupName = data["group_name"] as! String
                UserDefaults.standard.set(groupName, forKey: "groupName_notfiction")
                UserDefaults.standard.set(groupID, forKey: "groupID_notfiction")
                UserDefaults.standard.set("YES", forKey: "Isnotifcation");
                GotoAcknowlag()
                //Acknolagemetn details
                //id and name
                
            }else if type == "no_payment"{
                groupID = data["group_id"] as! String
                groupName = data["group_name"] as! String
                UserDefaults.standard.set(groupName, forKey: "groupName_notfiction")
                UserDefaults.standard.set(groupID, forKey: "groupID_notfiction")
                UserDefaults.standard.set("YES", forKey: "Isnotifcation");
                GotoAcknowlag()
                //Acknolagemetn details
                //id and name
                
            }else if type == "chat_message"{
                //"group_id" = 995;
                // "group_name" = "New pn";
                
                GotoChat()
            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "KYDrawerController") as! KYDrawerController
                let navController = UINavigationController(rootViewController: vc)
                navController.isNavigationBarHidden = true
                window!.rootViewController = navController;
                window!.makeKeyAndVisible()
            }
            print("Push alert: \(alert)")
            break
        case .background:
    
                type = data["type"] as! String
            
            //alertView2.show()
            if type == "invitation_request"{
                // requst grouplist
                Gotorequest()
                
            }else if type == "swap_request"{
                // requst grouplist
                Gotorequest()
                
            }else if type == "receive_payout"{
                GotoMytransction()
                //mytransction list
                
            }else if type == "payout_start_date"{
                groupID = data["group_id"] as! String
                groupName = data["group_name"] as! String
                UserDefaults.standard.set(groupName, forKey: "groupName_notfiction")
                UserDefaults.standard.set(groupID, forKey: "groupID_notfiction")
                UserDefaults.standard.set("YES", forKey: "Isnotifcation");
                
                GotoAcknowlag()
                //Acknolagemetn details
                //id and name
            }else if type == "accept_payment"{
                //Acknolagemetn details
                //id and name
                groupID = data["type"] as! String
                groupName = data["type"] as! String
                UserDefaults.standard.set(groupName, forKey: "groupName_notfiction")
                UserDefaults.standard.set(groupID, forKey: "groupID_notfiction")
                UserDefaults.standard.set("YES", forKey: "Isnotifcation");
                GotoAcknowlag()
                
            }else if type == "yes_payment"{
                groupID = data["group_id"] as! String
                groupName = data["group_name"] as! String
                UserDefaults.standard.set(groupName, forKey: "groupName_notfiction")
                UserDefaults.standard.set(groupID, forKey: "groupID_notfiction")
                UserDefaults.standard.set("YES", forKey: "Isnotifcation");
                GotoAcknowlag()
                //Acknolagemetn details
                //id and name
                
            }else if type == "no_payment"{
                groupID = data["group_id"] as! String
                groupName = data["group_name"] as! String
                UserDefaults.standard.set(groupName, forKey: "groupName_notfiction")
                UserDefaults.standard.set(groupID, forKey: "groupID_notfiction")
                UserDefaults.standard.set("YES", forKey: "Isnotifcation");
                GotoAcknowlag()
                //Acknolagemetn details
                //id and name
                
            }else if type == "chat_message"{
                //"group_id" = 995;
                // "group_name" = "New pn";
                
                GotoChat()
            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "KYDrawerController") as! KYDrawerController
                let navController = UINavigationController(rootViewController: vc)
                navController.isNavigationBarHidden = true
                window!.rootViewController = navController;
                window!.makeKeyAndVisible()
            }
            print("Push alert: \(alert)")
            break
        default:
            break
        }

        
       
        
    }
    private func getAlert(notification: [NSObject:AnyObject]) -> (String, String) {
        let aps = notification["aps" as NSString] as? [String:AnyObject]
        let alert = aps?["alert"] as? [String:AnyObject]
        let title = alert?["title"] as? String
        let body = alert?["body"] as? String
        return (title ?? "-", body ?? "-")
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        if UserDefaults.standard.string(forKey: "LOGIN") == "YES"{
            NotificatinService()
            
        }
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func NotificatinService(){
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
            if Reachability.shared().internetConnectionStatus() == NotReachable {
                var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }else{
                //let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
               // loadingNotification?.labelText = "Please wait"
                let  deviceToken = (UserDefaults.standard.object(forKey: "deviceToken")as? NSString)!
                let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
                
                let Dictonary: NSMutableDictionary = NSMutableDictionary()
                let parameters = ["customer_id": LoginId as String,"device_token": deviceToken as String,"device_type":"ios","auth_token": token] as Dictionary<String, String>
                Dictonary.setObject(parameters, forKey : "pushnotifydata" as NSCopying)
                
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
                                  
                                    var status = json["status"] as? NSString
                                    if (status?.isEqual(to: "success"))! {
                                       
                                        
                                    }else{
                                        let Alert:UIAlertView = UIAlertView(title: "Alert", message: "NO date Found", delegate: self, cancelButtonTitle: "Ok")
                                        
                                        
                                        
                                    }
                                    
                                    
                                }
                                
                            
                            })
                            // handle json...
                        }else{
                            DispatchQueue.main.async(execute: {
                                
                            })
                            
                        }
                        
                    } catch let error {
                        self.isurl = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/webservices/insertdevicetoken"
                        
                        self.NotificatinService()
                                print(error.localizedDescription)
                    }
                })
                task.resume()
            }
        }
    }



}

