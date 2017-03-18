//
//  MuteViewController.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 08/03/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class MuteViewController: UIViewController {
    var groupid: NSString = NSString()
    var user_id: NSString = NSString()
    var groupname: NSString = NSString()
    var isgroupmute: NSString = NSString()
    var isurl1: NSString = NSString()
    var isurl2: NSString = NSString()
    var key = "ajoapp17mindcrew"
    var iv = "mindcrewajoapp17"
    @IBOutlet weak var muteimage: UIImageView!
    @IBOutlet weak var Muttbtnout: UIButton!
    @IBOutlet weak var HeaderLabel: UILabel!
    @IBOutlet weak var MemnberTableview: UITableView!
    var Member_Arr = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isurl1 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/webservices/getgroupchatinfo"
        self.isurl2 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/webservices/setmuteinfo"
     
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func ActionOnbak(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func ActionOnMute(_ sender: Any) {
        if self.isgroupmute == "no"{
        self.isgroupmute = "yes"
        SendMuteService()
        }else {
        self.isgroupmute = "no"
        SendMuteService()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        Member_Arr = NSMutableArray()
        self.MemnberTableview.separatorInset = UIEdgeInsets.zero
        self.MemnberTableview.tableFooterView = UIView(frame: CGRect.zero)
        user_id = (UserDefaults.standard.object(forKey: "loginid")as? NSString)!
        let gstr = groupname as String
        let desgroupname = try! gstr.aesDecrypt(key: self.key, iv: self.iv)
        self.HeaderLabel.text = desgroupname as String
       
        getMuteService()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Member_Arr.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Mutecell", for: indexPath) as! muteTableViewCell
        let memberDic = self.Member_Arr[indexPath.row] as! NSDictionary
        let members = memberDic .object(forKey: "fname") as! NSString as String
         let desmembersnew = try! members.aesDecrypt(key: self.key, iv: self.iv)
         cell.Membernamelbl.text = desmembersnew as String
        
        
        return cell;
    }
    
    // MARK: - UITableView delegates
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let GroupDic = self.Member_Arr[indexPath.row] as! NSDictionary
        let  group_id = GroupDic .object(forKey: "customer_id") as! NSString as String
        let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginView:MemberDetilsViewController = (story.instantiateViewController(withIdentifier: "MemberDetilsViewController") as? MemberDetilsViewController)!
        LoginView.Userid = (group_id ) as NSString
        self.navigationController?.pushViewController(LoginView, animated: true)
        
        
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
    
    
    func getMuteService(){
    if Reachability.shared().internetConnectionStatus() == NotReachable {
    var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
    alert.show()
    }else
    {
    let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
    loadingNotification?.labelText = "Please wait"
    let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
    let Dictonary: NSMutableDictionary = NSMutableDictionary()
    let parameters = ["group_id": groupid as String,"user_id": user_id as String,"auth_token": token] as Dictionary<String, String>
    Dictonary.setObject(parameters, forKey : "getgroupchatinfo" as NSCopying)
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
        self.Member_Arr = (json["groupchatinfodata"] as? NSMutableArray)!;
        
        self.isgroupmute = (json["isgroupmute"] as? NSString)!
        if self.isgroupmute == "no"{
            self.muteimage.image = UIImage(named: "unmute.png")!
       
        }else{
            self.muteimage.image = UIImage(named: "mute.png")!
        
        }
        
        
        self.MemnberTableview .reloadData()

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
    let Alert:UIAlertView = UIAlertView(title: "Alert", message: "", delegate: self, cancelButtonTitle: "Ok")
    Alert.show()
    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    })
    
    }
    
    } catch let error {
        self.isurl1 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/webservices/getgroupchatinfo"
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
    func SendMuteService(){
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else
        {
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification?.labelText = "Please wait"
            let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
            let Dictonary: NSMutableDictionary = NSMutableDictionary()
            let parameters = ["group_id": groupid as String,"user_id": user_id as String,"isgroupmute": isgroupmute as String,"auth_token": token] as Dictionary<String, String>
            Dictonary.setObject(parameters, forKey : "setmuteinfodata" as NSCopying)
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
                                   self.getMuteService()
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
                            let Alert:UIAlertView = UIAlertView(title: "Alert", message: "", delegate: self, cancelButtonTitle: "Ok")
                            Alert.show()
                            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        })
                        
                    }
                    
                } catch let error {
                    self.isurl2 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/webservices/setmuteinfo"
                    self.SendMuteService()
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
