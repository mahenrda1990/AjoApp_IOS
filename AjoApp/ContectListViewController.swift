//
//  ContectListViewController.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 24/02/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit
import AddressBook
import Contacts
import MessageUI
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}
class ContectListViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate, UINavigationControllerDelegate,UITableViewDelegate, UITableViewDataSource,MFMessageComposeViewControllerDelegate{
    var CountryCodeArr = ["+93", "+355", "+213",
                          "+376", "+244", "+672", "+54", "+374", "+297", "+61", "+43", "+994", "+973",
                          "+880", "+375", "+32", "+501", "+229", "+975", "+591", "+387", "+267", "+55",
                          "+673", "+359", "+226", "+95", "+257", "+855", "+237", "+1", "+238", "+236",
                          "+235", "+56", "+86", "+57", "+269", "+242", "+682", "+506",
                          "+385", "+53", "+357", "+420", "+45", "+253", "+670", "+593", "+20", "+503",
                          "+240", "+291", "+372", "+251", "+500", "+298", "+679", "+358", "+33",
                          "+689", "+241", "+220", "+995", "+49", "+233", "+350", "+30", "+299", "+502",
                          "+224", "+245", "+592", "+509", "+504", "+852", "+36", "+91", "+62", "+98",
                          "+964", "+353", "+44", "+972", "+225", "+1876", "+81", "+962", "+7",
                          "+254", "+686", "+965", "+996", "+856", "+371", "+961", "+266", "+231",
                          "+218", "+423", "+370", "+352", "+853", "+389", "+261", "+265", "+60",
                          "+960", "+223", "+356", "+692", "+222", "+230", "+262", "+52", "+691",
                          "+373", "+377", "+976", "+382", "+212", "+258", "+264", "+674", "+977",
                          "+31", "+687", "+64", "+505", "+227", "+234", "+683", "+850", "+47", "+968",
                          "+92", "+680", "+507", "+675", "+595", "+51", "+63", "+870", "+48", "+351",
                          "+974", "+40", "+250", "+590", "+685", "+378", "+239", "+966",
                          "+221", "+381", "+248", "+232", "+65", "+421", "+386", "+677", "+252", "+27",
                          "+82", "+34", "+94", "+290", "+508", "+249", "+597", "+268", "+46", "+41",
                          "+963", "+886", "+992", "+255", "+66", "+228", "+690", "+676", "+216", "+90",
                          "+993", "+688", "+971", "+256", "+380", "+598", "+998", "+678",
                          "+39", "+58", "+84", "+681", "+967", "+260", "+263"]
    @IBOutlet weak var ContecttableView: UITableView!
    var ContactList : NSMutableArray!
    var ContactListnumbers : NSMutableArray!

    @IBOutlet weak var Sendbtnout: UIButton!
    var LoginId: NSString = NSString()
    var group_id: NSString = NSString()
    var group_name: NSString = NSString()
    var group_nameencrapted: NSString = NSString()
    var search:String=""
     var isurl1: NSString = NSString()
    //var AllData:Array<Dictionary<String,String>> = []
    var AllData = [ContactEntry]()
    @IBOutlet weak var SearchTxt: UITextField!
    var key = "ajoapp17mindcrew"
    var iv = "mindcrewajoapp17"
    var NameList : NSMutableArray!
    var contacts = [ContactEntry]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //Sendbtnout.layer.borderColor = UIColor.white.cgColor;
        //Sendbtnout.layer.borderWidth = 1.0;
        Sendbtnout.layer.cornerRadius = 8.0;
        self.isurl1 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/webservices/sentInvite"
        ContactList = NSMutableArray()
        ContactListnumbers = NSMutableArray()
       // AllData = NSMutableArray()
        NameList = NSMutableArray()
         self.ContecttableView.allowsMultipleSelection = true
        self.navigationController?.isNavigationBarHidden = true
        self.SearchTxt.attributedPlaceholder = NSAttributedString(string:"Search..",attributes:[NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12)])
        addDoneButtonOnKeyboard()

        // Do any additional setup after loading the view.
    }
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(LoginViewController.doneButtonAction))
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.SearchTxt.inputAccessoryView = doneToolbar
       
        
    }
    
    func doneButtonAction()
    {
        
        self.SearchTxt.resignFirstResponder();
       
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveAddressBookContacts { (success, contacts) in
            if success && contacts?.count > 0 {
                self.contacts = contacts!
                self.AllData = contacts!
                self.ContecttableView.reloadData()
            } else {
               
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        LoginId = (UserDefaults.standard.object(forKey: "loginid")as? NSString)!
        
            
            self.navigationController?.isNavigationBarHidden = true
            
            
        
        
    }
    // AddressBook methods
    func retrieveAddressBookContacts(_ completion: @escaping (_ success: Bool, _ contacts: [ContactEntry]?) -> Void) {
        let abAuthStatus = ABAddressBookGetAuthorizationStatus()
        if abAuthStatus == .denied || abAuthStatus == .restricted {
            completion(false, nil)
            return
        }
        
        let addressBookRef = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        ABAddressBookRequestAccessWithCompletion(addressBookRef) {
            (granted: Bool, error: CFError?) in
            DispatchQueue.main.async {
                if !granted {
                    //self.showAlertMessage("Sorry, you have no permission for accessing the address book contacts.")
                } else {
                    var contacts = [ContactEntry]()
                    let abPeople = ABAddressBookCopyArrayOfAllPeople(addressBookRef).takeRetainedValue() as Array
                    for abPerson in abPeople {
                        if let contact = ContactEntry(addressBookEntry: abPerson) { contacts.append(contact) }
                    }
                    completion(true, contacts)
                }
            }
        }
    }
    
    
    @IBAction func ActionOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if string.isEmpty
        {
            search = String(search.characters.dropLast())
        }
        else
        {
            search=SearchTxt.text!+string
        }
        
        print(search)
        let predicate=NSPredicate(format: "SELF.name CONTAINS[cd] %@ OR SELF.phone CONTAINS[cd] %@", search,search)
        let arr=(contacts as NSArray).filtered(using: predicate)
        if arr.count > 0
        {
           // AllData.removeAllObjects()
            AllData = arr as! [ContactEntry]
        }
        else
        {
            AllData = contacts 
        }
        self.ContecttableView.reloadData()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return AllData.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("menuCell");
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContectList", for: indexPath) as! ContectListTableViewCell
        let entry = AllData[(indexPath as NSIndexPath).row]
        cell.SmsName.text = entry.name
        cell.SmsNumber.text = entry.phone ?? ""
        cell.accessoryType = cell.isSelected ? .checkmark : .none
        cell.selectionStyle = .none
        cell.tintColor = UIColor.white
        return cell;
    }
   
    // MARK: - UITableView delegates
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        let entry = AllData[(indexPath as NSIndexPath).row]
    
        var contectStrNew : NSString = (entry.phone as NSString?)!
        contectStrNew = CheckNumber(number: contectStrNew)
        let mobile = (UserDefaults.standard.object(forKey: "mobile_no")as? NSString)! as String
        let desmobile = try! mobile.aesDecrypt(key: key, iv: iv)
        if desmobile == contectStrNew as String {
        
        }else{
            ContactListnumbers .add(contectStrNew)
            
            let contect = contectStrNew as String
            let contectStr = try! contect.aesEncrypt(key: key, iv: iv)
            ContactList .add(contectStr)
            var Namestr = entry.name as String
            let NamestrNew = try! Namestr.aesEncrypt(key: key, iv: iv)
            
            print(NamestrNew)
            
            NameList .add(NamestrNew)
            print(ContactList.count)
            print(ContactList)

        }
        

    }
    
     func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none

        let entry = AllData[(indexPath as NSIndexPath).row]
        
        var contectStrNew : NSString = (entry.phone as NSString?)!
        contectStrNew = CheckNumber(number: contectStrNew)
        let mobile = (UserDefaults.standard.object(forKey: "mobile_no")as? NSString)! as String
        let desmobile = try! mobile.aesDecrypt(key: key, iv: iv)
        if desmobile == contectStrNew as String {
            
        }else{
            ContactListnumbers .remove(contectStrNew)
            
            let cnstr = contectStrNew as String
            let contectSt = try! cnstr.aesEncrypt(key: key, iv: iv)
            
            ContactList .remove(contectSt)
            var NamestrNew = entry.name as String
            let NamestrNewSt = try! NamestrNew.aesEncrypt(key: key, iv: iv)
            
            
            NameList .remove(NamestrNewSt)
            print(ContactList.count)
            print(ContactList)
        }
        
        
        

    }
    
    
    
   
    func AddInvitaionService(){
        
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.labelText = "Please wait"
        let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
        
        let Dictonary: NSMutableDictionary = NSMutableDictionary()
            let gname = self.group_name as String
        let group_name = try! gname.aesEncrypt(key: key, iv: iv)
        print(group_name)

//        guard let plainData = (group_name as String ).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) else {
//            fatalError()
//        }
//        group_name = (plainData as NSData).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) as NSString
        print(group_name)
        
        var contectStr = ""
    
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: ContactList, options: .prettyPrinted) as NSData
            let jsonstring = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)
            contectStr = jsonstring as! String
            contectStr = String(contectStr.characters.filter { !"\\\n\t\r".characters.contains($0) })
            print(contectStr)
            
            
            // use jsonData
        } catch {
            // report error
        }
        
        var NameStr = ""
        
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: NameList, options: .prettyPrinted) as NSData
            let jsonstring = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)
            NameStr = jsonstring as! String
            NameStr = String(NameStr.characters.filter { !"\\\n\t\r".characters.contains($0) })
           print(NameStr)
            // use jsonData
        } catch {
            // report error
        }
        
        let parameters = ["customer_id": LoginId as NSObject,"group_id": group_id  as NSObject,"group_name": group_nameencrapted as NSObject,"sent_invitation_request": "false" as NSObject,"invitedmembersname": NameList as NSObject,"invitedmembersnumber": ContactList as NSObject,"auth_token": token as NSObject] as Dictionary<String, NSObject>
        
        Dictonary.setObject(parameters, forKey : "sentInvite" as NSCopying)
        

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
                                if (MFMessageComposeViewController.canSendText()) {
                                    let controller = MFMessageComposeViewController()
                                    //controller.body = "https://itunes.apple.com/us/app/ajoapp/id1216975001?ls=1&mt=8"
                                     controller.body = "Hello Downlode Ajo App https://itunes.apple.com/us/app/ajoapp/id1216975001?ls=1&mt=8 here to go to Ajo App! "
                
                                    controller.recipients = self.ContactListnumbers as NSArray as? [String]
                                    controller.messageComposeDelegate = self
                                    self.present(controller, animated: true, completion: nil)
                                }
                        
                                
                            }else{
                                let Alert:UIAlertView = UIAlertView(title: "Alert", message: "NO Added", delegate: self, cancelButtonTitle: "Ok")
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
                        Alert.show()
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    })
                    
                }
                
            } catch let error {
                self.isurl1 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/webservices/sentInvite"
                self.AddInvitaionService()
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    }

    
    @IBAction func ActionOnSend(_ sender: Any) {
        if ContactList.count > 0{
             AddInvitaionService()
            
        } else {
        
        }
       
        
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        self.SearchTxt.resignFirstResponder()
        return true
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func CheckNumber(number : NSString) -> NSString {
        var returnStr : NSString = number;
        for  code in self.CountryCodeArr{
            if (number.contains(code)){
                returnStr = (returnStr as NSString).replacingOccurrences(of: code, with: "") as NSString;
                break;
            }
        }
        returnStr = returnStr.replacingOccurrences(of: "(", with: "") as NSString
        returnStr = returnStr.replacingOccurrences(of: ")", with: "") as NSString
        returnStr = returnStr.replacingOccurrences(of: " ", with: "") as NSString
        returnStr = returnStr.replacingOccurrences(of: "-", with: "") as NSString
        returnStr = returnStr.replacingOccurrences(of: "*", with: "") as NSString
        returnStr = (returnStr as NSString).substring(from: max(returnStr.length-10,0)) as NSString
        return returnStr
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


