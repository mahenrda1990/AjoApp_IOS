//
//  ChatViewController.swift
//  AjoApp
//
//  Created by manisha panse on 3/4/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextViewDelegate,ContentViewDelegate  {
    var groupid: NSString = NSString()
    var user_id: NSString = NSString()
    var groupname: NSString = NSString()
    var ChatnotfictYes: NSString = NSString()
    var ImageBool: Bool = Bool()
    var imageData:Data?;
    let picker = UIImagePickerController()
    var isimageSelected : Bool = true
    var pickedImage : UIImage = UIImage()
    var isurl1: NSString = NSString()
    var isurl2: NSString = NSString()
    var key = "ajoapp17mindcrew"
    var iv = "mindcrewajoapp17"
    var timer = Timer()
    @IBOutlet weak var Sendbtnout: UIButton!
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var contentView: ContentView!
    @IBOutlet weak var chatTextView: UITextView!
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var chatTextViewHeightConstraint: NSLayoutConstraint!
    
    var handler : ContentView!
    var chatCell : ChatTableViewCellXIB!
    var chatSellSetting : ChatCellSettings!
    var currentMessages : NSMutableArray!
    
    @IBOutlet weak var placeholderLab: UILabel!
    @IBOutlet weak var Namelbl: UILabel!

   
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function **Countdown** with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    func updateCounting(){
        NSLog("counting..")
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            self.gethistoryService()
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
            }
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isurl1 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/webservices/getgroupchathistory"
        self.isurl2 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/webservices/insertgroupchat"
        ChatnotfictYes = "yes"
        picker.delegate = self
        user_id = (UserDefaults.standard.object(forKey: "loginid")as? NSString)!
        let gname = groupname as String
        let desgroup_Name = try! gname.aesDecrypt(key: key, iv: iv)
        self.Namelbl.text = desgroup_Name as String

        self.chatTable.estimatedRowHeight = 95
        self.chatTable.rowHeight = UITableViewAutomaticDimension
        currentMessages = NSMutableArray()
        chatSellSetting = ChatCellSettings.getInstance()
        chatSellSetting.setSenderBubbleColorHex("007AFF")
        chatSellSetting.setReceiverBubbleColorHex("DFDEE5")
        chatSellSetting.setSenderBubbleNameTextColorHex("FFFFFF")
        chatSellSetting.setReceiverBubbleNameTextColorHex("000000")
        chatSellSetting.setSenderBubbleTimeTextColorHex("FFFFFF")
        chatSellSetting.setReceiverBubbleTimeTextColorHex("000000")
        chatSellSetting.setSenderBubbleFontWithSizeForName(UIFont.boldSystemFont(ofSize: 11))
        chatSellSetting.setReceiverBubbleFontWithSizeForName(UIFont.boldSystemFont(ofSize: 11))
        chatSellSetting.setSenderBubbleFontWithSizeForMessage(UIFont.boldSystemFont(ofSize: 14))
        chatSellSetting.setReceiverBubbleFontWithSizeForMessage(UIFont.boldSystemFont(ofSize: 14))
        chatSellSetting.setSenderBubbleFontWithSizeForTime(UIFont.boldSystemFont(ofSize: 11))
        chatSellSetting.setReceiverBubbleFontWithSizeForTime(UIFont.boldSystemFont(ofSize: 11))
        chatSellSetting.senderBubbleTailRequired(true)
        chatSellSetting.receiverBubbleTailRequired(true)
        
        let nib = UINib.init(nibName: "ChatSendCell", bundle: nil)
        self.chatTable.register(nib, forCellReuseIdentifier: "chatSend")
        
        let nib2 = UINib.init(nibName: "ChatReceiveCell", bundle: nil)
        self.chatTable.register(nib2, forCellReuseIdentifier: "chatReceive")
        
        let nib3 = UINib.init(nibName: "chatReciverImage", bundle: nil)
        self.chatTable.register(nib3, forCellReuseIdentifier: "chatReceiveImage")
        contentView.delegate = self
        self.handler = ContentView.init(textView: self.chatTextView, chatTextViewHeightConstraint: self.chatTextViewHeightConstraint, contentView: self.contentView, contentViewHeightConstraint: self.contentViewHeight, andContentViewBottomConstraint: self.contentViewBottomConstraint)
        self.handler.delegate = self
        self.handler.updateMinimumNumber(ofLines: 1, andMaximumNumberOfLine: 5)
        let dismissTap = UITapGestureRecognizer.init(target: self, action: #selector(ChatViewController.dismissKeyboard))
    
        self.chatTable.addGestureRecognizer(dismissTap)
        
        self.chatTextView.layer.borderWidth = 1
        self.chatTextView.layer.borderColor = UIColor.init(white: 0.5, alpha: 0.5).cgColor
        self.chatTextView.layer.masksToBounds = true
        self.gethistoryService()
        scheduledTimerWithTimeInterval()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
           }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard(){
        self.chatTextView.resignFirstResponder()
    }

    //MARK: - TableView datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let messages = (currentMessages.object(at: section) as! NSDictionary).object(forKey: "messages") as! NSMutableArray
        
        return messages.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentMessages.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messages = (currentMessages.object(at: indexPath.section) as! NSDictionary).object(forKey: "messages") as! NSMutableArray
        
       // if indexPath.row < messages.count {
            let messageDic = messages.object(at: indexPath.row) as! NSDictionary
            
            if (messageDic.object(forKey: "user_id") as! NSString == user_id) {
                chatCell = tableView.dequeueReusableCell(withIdentifier: "chatSend") as! ChatTableViewCellXIB
            }else{
                chatCell = tableView.dequeueReusableCell(withIdentifier: "chatReceive") as! ChatTableViewCellXIB
            }
            let dateTimeFormatter = DateFormatter()
            dateTimeFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            let TimeFormatter = DateFormatter()
            TimeFormatter.dateFormat = "hh:mm:ss"
            let dateTime = dateTimeFormatter.date(from: (messageDic.object(forKey: "datetime") as! String?)!)
            
            let  name = messageDic.object(forKey: "fname") as! String?
            let desgname = try! name?.aesDecrypt(key: key, iv: iv)
            chatCell.chatNameLabel.text = desgname! as String

        
            let  message = messageDic.object(forKey: "message") as! String?
           let desgmessage = try! message?.aesDecrypt(key: key, iv: iv)
           chatCell.chatMessageLabel.text = desgmessage! as String
        
            //chatCell.chatNameLabel.text = messageDic.object(forKey: "fname") as! String?
            // chatCell.chatMessageLabel.text = messageDic.object(forKey: "message") as! String?
            chatCell.chatTimeLabel.text = TimeFormatter.string(from: dateTime!)
            

//        }else{
//            chatCell = tableView.dequeueReusableCell(withIdentifier: "chatReceiveImage") as! ChatTableViewCellXIB
//
//        }
               return chatCell
    }
     func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        let chatCell2 = tableView.cellForRow(at: indexPath) as! ChatTableViewCellXIB
        return (chatCell2.chatMessageLabel.text) != nil
    }
    
     func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return action == #selector(copy(_:))
    }
    
     func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        if action == #selector(copy(_:)) {
            let chatCell2 = tableView.cellForRow(at: indexPath) as! ChatTableViewCellXIB
            let pasteboard = UIPasteboard.general
            pasteboard.string = chatCell2.chatMessageLabel.text
        }
    }
    //MARK: - TableView Delegates
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var dateStr = (currentMessages.object(at: section) as! NSDictionary).object(forKey: "date") as! NSString
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "yyyy-MM-dd"
        let TimeFormatter = DateFormatter()
        TimeFormatter.dateFormat = "EEE dd MMM"
        let datess = dateTimeFormatter.date(from: dateStr as String)
        let today = Calendar.current.date(byAdding: .day, value: 0, to: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let newDateStr = TimeFormatter.string(from: datess!)
        let todayDateStr = TimeFormatter.string(from: today!)
        let yeasterdayDateStr = TimeFormatter.string(from: yesterday!)
        
        if todayDateStr == newDateStr {
            dateStr = " Today " as NSString
        }else if yeasterdayDateStr == newDateStr {
            dateStr = " Yeasterday " as NSString
        }else{
            dateStr = newDateStr as NSString
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        headerView.backgroundColor = UIColor.white
        let lab = UILabel(frame: CGRect(x: 0, y: 5, width: self.view.frame.size.width, height: 30))
        var newFrame = lab.frame
       // lab.sizeToFit()
        let widthIs: CGFloat = (dateStr.boundingRect(with: lab.frame.size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:lab.font], context: nil).size.width)
        newFrame.size.width = widthIs
        newFrame.origin.x = (self.view.frame.size.width - widthIs)/2
        lab.frame = newFrame
        lab.text = dateStr as String;
        lab.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        lab.layer.cornerRadius = lab.frame.size.height/2
        lab.layer.masksToBounds = true
        lab.textColor = UIColor.white
        lab.font = UIFont.systemFont(ofSize: 13)
        lab.textAlignment = NSTextAlignment.center
        headerView.addSubview(lab)
        return headerView;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40;
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let messages = (currentMessages.object(at: indexPath.section) as! NSDictionary).object(forKey: "messages") as! NSMutableArray
//        let messageDic = messages.object(at: indexPath.row) as! NSDictionary
//        let dateTimeFormatter = DateFormatter()
//        dateTimeFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
//        let TimeFormatter = DateFormatter()
//        TimeFormatter.dateFormat = "hh:mm:ss"
//        let dateTime = dateTimeFormatter.date(from: (messageDic.object(forKey: "datetime") as! String?)!)
//        let message = messageDic.object(forKey: "message") as! String
//        let fname = messageDic.object(forKey: "fname") as! NSString
//
//        var fontArr = NSArray()
//        
//        if (messageDic.object(forKey: "user_id") as! NSString == user_id) {
//            fontArr = chatSellSetting.getSenderBubbleFontWithSize() as NSArray
//        }else{
//            fontArr = chatSellSetting.getReceiverBubbleFontWithSize() as NSArray
//        }
//        let size = CGSize(width: 220, height: CGFloat.greatestFiniteMagnitude)
//        //let nameSize = fname.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: {NSFontAttributeName:fontArr[0]}, context: nil)
//        return 70;
//    }
    
   //MARK: - ContentView delegates
    
    func hideTextViewPlaceHolder(_ hide: Bool) {
        if hide == true{
            self.placeholderLab.isHidden = true;
        }else{
            self.placeholderLab.isHidden = false;
        }
    }
    
    func gethistoryService(){
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            //alert.show()
        }else{
            if Reachability.shared().internetConnectionStatus() == NotReachable {
                var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
                //alert.show()
            }else{
               // let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
               // loadingNotification?.labelText = "Please wait"
                let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
                let Dictonary: NSMutableDictionary = NSMutableDictionary()
                let parameters = ["group_id": groupid as String,"customer_id": user_id as String,"auth_token": token] as Dictionary<String, String>
                Dictonary.setObject(parameters, forKey : "getgroupchathistory" as NSCopying)
                
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
                        
                        //change by manisha
                        var lastChat : NSDictionary!
                        let lastCount = self.currentMessages.count
                        if lastCount > 0{
                            lastChat = self.currentMessages[lastCount-1] as! NSDictionary
                        }
                        //ended by manisha
                        //create json object from data
                        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                            print(json)
                            DispatchQueue.main.async(execute: {
                                if (json as? NSDictionary) != nil{
                                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                                    var status = json["status"] as? NSString
                                    if (status?.isEqual(to: "success"))! {
                                        self.currentMessages .removeAllObjects()
                                        var history  = (json as NSDictionary).object(forKey: "groupchathistorydata") as! NSArray
                                          history = (history as NSArray).sortedArray(using: [NSSortDescriptor.init(key: "chatcount", ascending: true) ]) as NSArray
                                        var dateStr = NSString()
                                        dateStr = ""
                                        
                                        var ArrAsPerDate = NSMutableArray()
                                        ArrAsPerDate .removeAllObjects()
                                        var dictAsPerDate = NSMutableDictionary()
                                        let dateTimeFormatter = DateFormatter()
                                        dateTimeFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                                        let TimeFormatter = DateFormatter()
                                        TimeFormatter.dateFormat = "yyyy-MM-dd"
                                        for i in 0  ..< history.count  {
                                            let historyDic = history[i] as! NSDictionary
                                            let messageDate = dateTimeFormatter.date(from: historyDic.object(forKey: "datetime") as! String)
                                            let datestring = TimeFormatter.string(from: messageDate!) as NSString
                                            if dateStr != datestring {
                                                ArrAsPerDate = NSMutableArray()
                                                dictAsPerDate = NSMutableDictionary()
                                                ArrAsPerDate.add(historyDic)
                                                dictAsPerDate .setObject(ArrAsPerDate, forKey: "messages" as NSCopying)
                                                dictAsPerDate.setObject(datestring, forKey: "date" as NSCopying)
                                                self.currentMessages .add(dictAsPerDate)
                                                //let dateDictionary = NSDictionary.init(objects: [ArrAsPerDate,datestring], forKeys: ["messages" as NSCopying,"date" as NSCopying])
                                                
                                            }else{
                                                ArrAsPerDate.add(historyDic)

                                                dictAsPerDate .setObject(ArrAsPerDate, forKey: "messages" as NSCopying)
                                                dictAsPerDate.setObject(datestring, forKey: "date" as NSCopying)
                                                self.currentMessages.removeLastObject()
                                                self.currentMessages .add(dictAsPerDate)
                                            }
                                            dateStr = datestring
                                        }
                                        
                                       // self.currentMessages = (json as NSDictionary).object(forKey: "groupchathistorydata") as! NSMutableArray
                                        self.chatTable.reloadData()
                                        if (self.currentMessages.count > 0) {
                                            let messages = (self.currentMessages.lastObject as! NSDictionary).object(forKey: "messages") as! NSMutableArray

                                            let indexpath = IndexPath(row: messages.count-1, section: self.currentMessages.count-1)
                                            self.chatTable.scrollToRow(at: indexpath, at: UITableViewScrollPosition.bottom, animated: true)
                                        }
                                       
                                        //change by manisha
                                        
                                        if lastCount < self.currentMessages.count{
                                            self.chatTable.reloadData()
                                        }else if lastChat != nil{
                                            
                                            let oldArr = lastChat["messages"] as! NSArray
                                            
                                            let NewArr = (self.currentMessages[lastCount-1] as! NSDictionary) ["messages"] as! NSArray
                                            if oldArr.count != NewArr.count {
                                                self.chatTable.reloadData()
                                            }
                                            
                                        }
                                        
                                        //ended by manisha
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
                        self.isurl1 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/webservices/getgroupchathistory"
                        self.gethistoryService()
                        print(error.localizedDescription)
                    }
                })
                task.resume()
            }
        }
    }
    func SendmessageService(){
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
            if Reachability.shared().internetConnectionStatus() == NotReachable {
                var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }else{
                let Chatm = self.chatTextView.text! as String
                 let Messagetxt = try! Chatm.aesEncrypt(key: key, iv: iv)

               // let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                //loadingNotification?.labelText = "Please wait"
                let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
                let Dictonary: NSMutableDictionary = NSMutableDictionary()
                let parameters = ["group_id": groupid as String,"user_id": user_id as String,"message": Messagetxt as String,"group_name": groupname as String,"issendnotification": ChatnotfictYes as String,"auth_token": token] as Dictionary<String, String>
                Dictonary.setObject(parameters, forKey : "newmessagedata" as NSCopying)
                //create the url with URL
                let url = URL(string: self.isurl2 as String)! //
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
                                        self.chatTextView.text = ""
                                        self.ChatnotfictYes = "no"
                                        self.Sendbtnout.isUserInteractionEnabled = true
                                        self.Sendbtnout.isEnabled = true
                                        self.handler.updateMinimumNumber(ofLines: 1, andMaximumNumberOfLine: 5)
                                        self.placeholderLab.isHidden = false;

                                        self.gethistoryService()
                                    }else{
                                        self.Sendbtnout.isUserInteractionEnabled = true
                                        self.Sendbtnout.isEnabled = true
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
                        
                        self.isurl2 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/webservices/insertgroupchat"
                        self.SendmessageService()
                        print(error.localizedDescription)
                    }
                })
                task.resume()
            }
        }
    }

    @IBAction func ActionOnback(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true);
    }
    
    
    @IBAction func ActiononHeader(_ sender: Any) {
        let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginView:MuteViewController = (story.instantiateViewController(withIdentifier: "MuteViewController") as? MuteViewController)!
        
        LoginView.groupid = (groupid ) as NSString
        LoginView.groupname = (groupname ) as NSString
        self.navigationController?.pushViewController(LoginView, animated: true)
        

    }
    
    @IBAction func ActionOnSend(_ sender: Any) {
        if chatTextView.text != "" {
            self.Sendbtnout.isUserInteractionEnabled = false
            self.Sendbtnout.isEnabled = false
            self.SendmessageService()
            
        }else{
        
        }
    }
    @IBAction func Actiononcamer(_ sender: Any) {
        self.view.endEditing(true)
       
        UIActionSheetDelegate.self
        let actionSheet = UIActionSheet(title: "Choose Option", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Open Camera", "From Gallery")
        
        actionSheet.show(in: self.view)
    }
    func openGallary()
    {    picker.delegate = self
        self.picker.allowsEditing = false
        self.picker.sourceType = .photoLibrary
        self.present(self.picker, animated: true, completion: nil)
    }
    func funforopenCamera()
    {     picker.delegate = self
        self.picker.allowsEditing = false
        self.picker.sourceType = .camera
        self.present(self.picker, animated: true, completion: nil)
        
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        print("\(buttonIndex)")
        switch (buttonIndex){
            
        case 0:
            print("Cancel")
        case 1:
            
            funforopenCamera()
            break
            
            
        case 2:
            
            openGallary()
            print("open Gallery")
            break
            
        default:
            print("Default")
            
        }
        //Some code here..
    }
    //    MARK: Image Picker Delegate:
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        pickedImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        //self.EventimageView.image = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        print(pickedImage)
        isimageSelected = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //isimageSelected = false
        dismiss(animated: true, completion: nil)
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
