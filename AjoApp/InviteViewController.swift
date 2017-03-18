//
//  InviteViewController.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 24/02/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController {
    @IBOutlet weak var MembertableView: UITableView!
    var Arr_Membergroup = NSMutableArray()
    var LoginId: NSString = NSString()
    var group_id: NSString = NSString()
    var group_name: NSString = NSString()
    var group_nameencrapted: NSString = NSString()
    var isurl1: NSString = NSString()
    var key = "ajoapp17mindcrew"
    var iv = "mindcrewajoapp17"
    @IBOutlet weak var NoDataLbl: UILabel!
    @IBOutlet weak var GroupNameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.isurl1 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/webservices/invitedMembers"
        LoginId = (UserDefaults.standard.object(forKey: "loginid")as? NSString)!
        self.GroupNameLbl.text = group_name as String
        self.navigationController?.isNavigationBarHidden = true

        MembertableView.layer.borderColor = UIColor.white.cgColor;
        MembertableView.layer.borderWidth = 1.0;
        MembertableView.layer.cornerRadius = 8.0;
        self.InviteListService()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Arr_Membergroup.count
      
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "inviteCell", for: indexPath) as! InviteTableViewCell
        let GroupDic = self.Arr_Membergroup[indexPath.row] as! NSDictionary
        let  group_name = GroupDic .object(forKey: "name") as! NSString as String
         let desgroup_nameinvite = try! group_name.aesDecrypt(key: key, iv: iv)
        cell.NameLbl.text = desgroup_nameinvite as String
        
        let  isaccepted = GroupDic .object(forKey: "isaccepted") as! NSString as String
        if isaccepted == "accepted"{
            let imageName = "invite_accepted"
            let image = UIImage(named: imageName)
            cell.SetImage?.image = image

        
        }else if isaccepted == "cancel" {
            let imageName = "invite_denied"
            let image = UIImage(named: imageName)
            cell.SetImage?.image = image
        }else {
            let imageName = "invite_not_accepted"
            let image = UIImage(named: imageName)
            cell.SetImage?.image = image

        }
       
        
        
        
        return cell;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func InviteListService(){
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
        
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.labelText = "Please wait"
        let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
        
        let Dictonary: NSMutableDictionary = NSMutableDictionary()
        let parameters = ["group_id": group_id as String,"auth_token": token] as Dictionary<String, String>
        Dictonary.setObject(parameters, forKey : "invitedMembers" as NSCopying)
        
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
                                
                                 self.NoDataLbl.isHidden = true
                                self.Arr_Membergroup = (json["invitedmembers"] as? NSMutableArray)!;
                                
                                
                                self.MembertableView .reloadData()
                                
                            }else{
                                let Alert:UIAlertView = UIAlertView(title: "Alert", message: "NO date Found", delegate: self, cancelButtonTitle: "Ok")
                                self.NoDataLbl.isHidden = false
                               // Alert.show()
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
                self.isurl1 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/webservices/invitedMembers"
                self.InviteListService()
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    }
    


    @IBAction func ActionOnInvileContect(_ sender: Any) {
        let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginView:ContectListViewController = (story.instantiateViewController(withIdentifier: "ContectListViewController") as? ContectListViewController)!
        
        LoginView.group_id = group_id as String as NSString
        LoginView.group_nameencrapted = group_nameencrapted as! String as NSString
        LoginView.group_name = self.group_name as String as NSString
        self.navigationController?.pushViewController(LoginView, animated: true)
       // ContectListViewController
    }
    
    
    @IBAction func ActionOnHome(_ sender: Any) {
        let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginView:KYDrawerController = (story.instantiateViewController(withIdentifier: "KYDrawerController") as? KYDrawerController)!
        self.navigationController?.pushViewController(LoginView, animated: true)
        
    }
    @IBAction func ActionONBack(_ sender: Any) {
        
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
