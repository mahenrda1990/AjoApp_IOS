//
//  AddNewGroupViewController.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 24/02/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class AddNewGroupViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    var pickerContainer = UIView()
    var picker = UIDatePicker()
    @IBOutlet weak var selectedDate: UIButton!
    var muteForPicker: UIPickerView?
    @IBOutlet weak var Currency_Txt: UITextField!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var BagroundView: UIView!
    @IBOutlet weak var Weekbtnout: UIButton!
   
    @IBOutlet weak var BiweekBtnout: UIButton!
    @IBOutlet weak var Monthbtnout: UIButton!
    @IBOutlet weak var GroupName_Txt: UITextField!
    @IBOutlet weak var Amount_txt: UITextField!
    var isurl1: NSString = NSString()
    var completeDate  = NSString()
    var Username  = NSString()
    var MobileNo  = NSString()
    var UserId  = NSString()
    var CurrencyStr  = NSString()
    var payment_term  = NSString()
    var group_name  = NSString()
    var key = "ajoapp17mindcrew"
    var iv = "mindcrewajoapp17"
    
    @IBOutlet weak var dailyimage: UIImageView!
    @IBOutlet weak var Date_Txt: UITextField!
    var Currency = ["£","Rs.","$","₦","€","GH₵","ZAR","KSh"]
    var Currencycode = ["GBP","INR","USD","NGN","EU","GHS","ZAR","KES"]
    var actionSheetPicker: AbstractActionSheetPicker!
    @IBAction func ActionOnback(_ sender: Any) {
        let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginView:KYDrawerController = (story.instantiateViewController(withIdentifier: "KYDrawerController") as? KYDrawerController)!
        self.navigationController?.pushViewController(LoginView, animated: true)
    }
    func tapBlurButton(_ sender: UITapGestureRecognizer) {
        self.ContentView.isHidden = true
        self.BagroundView.isHidden = true
        UserDefaults.standard.set("YES", forKey: "IsAdd");
    }
    
    @IBAction func ActionDaily(_ sender: Any) {
        
        payment_term = "daily"
        Weekbtnout.setImage(UIImage(named: "outline-blank.png"), for: UIControlState.normal)
        BiweekBtnout.setImage(UIImage(named: "outline-blank.png"), for: UIControlState.normal)
        Monthbtnout.setImage(UIImage(named: "outline-blank.png"), for: UIControlState.normal)
        self.dailyimage.image = UIImage(named: "radio-on-button-2.png")
    }
    @IBAction func ActionOnOk(_ sender: Any) {
        self.ContentView.isHidden = true
        self.BagroundView.isHidden = true
        UserDefaults.standard.set("YES", forKey: "IsAdd");
    }
    @IBAction func ActionOnTotorial(_ sender: Any) {
        self.ContentView.isHidden = false
        self.BagroundView.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isurl1 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/webservices/creategroup"
        self.navigationController?.isNavigationBarHidden = true
        if UserDefaults.standard.string(forKey: "IsAdd") == "YES"{
            self.ContentView.isHidden = true
            self.BagroundView.isHidden = true
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        self.BagroundView.addGestureRecognizer(tapGesture)
        muteForPicker?.delegate = self
        muteForPicker?.dataSource = self
        payment_term = "weekly"
       self.Currency_Txt.attributedPlaceholder = NSAttributedString(string:"Currency",attributes:[NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)])
        
        self.GroupName_Txt.attributedPlaceholder = NSAttributedString(string:"Group name",attributes:[NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)])
        self.Date_Txt.attributedPlaceholder = NSAttributedString(string:"Select Start Date",attributes:[NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)])
        self.Amount_txt.attributedPlaceholder = NSAttributedString(string:"Money",attributes:[NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)])
        self.Username = (UserDefaults.standard.object(forKey: "fname")as? NSString)! as String as String as NSString
        self.MobileNo = (UserDefaults.standard.object(forKey: "mobile_no")as? NSString)! as String as String as NSString
        self.UserId = (UserDefaults.standard.object(forKey: "loginid")as? NSString)! as String as String as NSString
        Weekbtnout.setImage(UIImage(named: "radio-on-button-2.png"), for: UIControlState.normal)
        BiweekBtnout.setImage(UIImage(named: "outline-blank.png"), for: UIControlState.normal)
        Monthbtnout.setImage(UIImage(named: "outline-blank.png"), for: UIControlState.normal)
        self.dailyimage.image = UIImage(named: "outline-blank.png")
        
        self.addDoneButtonOnKeyboard()
        self.PikerButtonOnKeyboard()

        // Do any additional setup after loading the view.
    }
    func configurePicker()
    {
        pickerContainer.frame = CGRect(x: 0.0, y: self.view.frame.size.height-300, width: self.view.frame.size.width, height: 300.0)
        pickerContainer.backgroundColor = UIColor.purple
        
        picker.frame    = CGRect(x: 0.0, y: 50.0, width: self.view.frame.size.width, height: 280.0)
        picker.backgroundColor = UIColor.white
        
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
        picker.setDate(tomorrow! as Date, animated: true)
        picker.minimumDate = tomorrow! as Date
        picker.datePickerMode = UIDatePickerMode.date
        pickerContainer.addSubview(picker)
        let doneButton = UIButton()
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        doneButton.addTarget(self, action: #selector(AddNewGroupViewController.dismissPicker), for: UIControlEvents.touchUpInside)
        doneButton.frame    = CGRect(x: self.view.frame.size.width - 80.0, y: 5.0, width: 70.0, height: 37.0)
        pickerContainer.addSubview(doneButton)
        
        let button2 = UIButton()
        
        button2.setTitle("Cancel", for: UIControlState.normal)
        button2.setTitleColor(UIColor.white, for: UIControlState.normal)
        button2.addTarget(self, action: #selector(AddNewGroupViewController.CancelAction(_:)), for: .touchUpInside)
        button2.frame = CGRect(x: 10.0, y: 5.0, width: 70.0, height: 37.0)

        //button2.backgroundColor = UIColor(white: 0.1, alpha: 1)
        
        pickerContainer.addSubview(button2)
        
        self.view.addSubview(pickerContainer)
    }
    @IBAction func SetDAte(_ sender: Any) {
        UIView.animate(withDuration: 0.4, animations: {
            var frame:CGRect = CGRect(x: 0.0, y: self.view.frame.size.height-300, width: 320.0, height: 300.0)
            self.pickerContainer.frame = frame
            
        })

    }
       
    func dismissPicker ()
    {
        UIView.animate(withDuration: 0.4, animations: {
            self.pickerContainer.frame = CGRect(x: 0.0, y: self.view.frame.size.height+50, width: self.view.frame.size.width, height: 300)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.selectedDate.setTitle(dateFormatter.string(from: self.picker.date), for: UIControlState.normal)
            self.Date_Txt.text = dateFormatter.string(from: self.picker.date)
        })
    }
    func PikerButtonOnKeyboard()
    {
        let countryPickerView = UIPickerView()
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
        countryPickerView.showsSelectionIndicator = true
        countryPickerView.backgroundColor = UIColor.gray
        countryPickerView.selectRow(256, inComponent: 0, animated: true)
        //set  default country in textfiled
        self.Currency_Txt.inputView = countryPickerView
        /* Creating custom done button on top of keyboard*/
        let button = UIButton(type: .custom)
        button.setTitle("Done", for: UIControlState())
        button.addTarget(self, action: #selector(AddNewGroupViewController.buttonAction(_:)), for: .touchUpInside)
        button.frame = CGRect(x: 0, y:0, width: self.view.bounds.size.width, height: 40)
        button.backgroundColor = UIColor(white: 0.1, alpha: 1)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 40))
        view.addSubview(button)
        self.Currency_Txt.inputAccessoryView = view
        
        
    }

    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddNewGroupViewController.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.Date_Txt.inputAccessoryView = doneToolbar
        self.Amount_txt.inputAccessoryView = doneToolbar
        self.GroupName_Txt.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
       
         Date_Txt.resignFirstResponder();
         Amount_txt.resignFirstResponder();
         GroupName_Txt.resignFirstResponder();
       
    }
    func buttonAction(_ sender: AnyObject)
    {
        self.Currency_Txt.resignFirstResponder()
        if self.Currency_Txt.text == ""{
            self.Currency_Txt.text = Currency[0]
            CurrencyStr = Currencycode[0] as String as NSString

        }
            }
    func CancelAction(_ sender: AnyObject)
    {
        UIView.animate(withDuration: 0.4, animations: {
            self.pickerContainer.frame = CGRect(x: 0.0, y: self.view.frame.size.height+50, width: self.view.frame.size.width, height: 300)
           
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return Currency.count
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        return NSAttributedString(string: Currency[row] , attributes: [NSForegroundColorAttributeName : UIColor.white])
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Currency[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.Currency_Txt.text = Currency[row]
        CurrencyStr = Currencycode[row] as String as NSString
        //.hidden = true;
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.Amount_txt {
        let currentCharacterCount = Amount_txt.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 10
        }else if textField == self.GroupName_Txt {
            let currentCharacterCount = GroupName_Txt.text?.characters.count ?? 0
            
            let characters = ["#", "$", "!", "&","@"]
            for character in characters{
                if string == character{
                    print("This characters are not allowed")
                    return false
                }
            }
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            return newLength <= 25
        
        }
        return true;
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.Date_Txt {
           
            Amount_txt.resignFirstResponder();
            GroupName_Txt.resignFirstResponder();

            configurePicker()
            return false
        }else{
            UIView.animate(withDuration: 0.4, animations: {
                self.pickerContainer.frame = CGRect(x: 0.0, y: self.view.frame.size.height+50, width: self.view.frame.size.width, height: 300)
            })
        }
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
      /*  ActionSheetDatePicker (title: "Select Date", datePickerMode: .date, selectedDate: NSDate() as Date!, target: self, action:Selector(("dateWasSelected:selectedDate:element:")) , origin: self.Date_Txt)*/
    }
    
    func dateWasSelected(selectedDate: NSDate, element: AnyObject) {
       // self!.selectedDate = selectedDate
        //may have originated from textField or barButtonItem, use an IBOutlet instead of element
        self.Date_Txt.text = selectedDate.description
    }
    func AddGroupService(){
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
        
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.labelText = "Please wait"
        let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
        
        let Dictonary: NSMutableDictionary = NSMutableDictionary()
            let gname = self.GroupName_Txt.text! as String
            let group_name = try! gname.aesEncrypt(key: key, iv: iv)



        let parameters = ["group_name": group_name as String,"start_date": self.Date_Txt.text!,"amount": (self.Amount_txt.text! as String),"currency": CurrencyStr as String,"payment_term": payment_term as String,"customer_id": UserId as String,"auth_token": token] as Dictionary<String, String>
        Dictonary.setObject(parameters, forKey : "creategroup" as NSCopying)
        
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
                                let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let LoginView:InviteViewController = (story.instantiateViewController(withIdentifier: "InviteViewController") as? InviteViewController)!
                                let group_nameencrapted = json["group_name"] as? NSString
                                //let group_id = json["group_id"] as? NSNumber
                                let group_id = (json["group_id"] as AnyObject).int32Value;
                                let int: Int = Int(group_id!)
                                let isgroupid = String(int)
                                LoginView.group_id = isgroupid as String as NSString
                                LoginView.group_nameencrapted = group_nameencrapted as! String as NSString
                                LoginView.group_name = self.GroupName_Txt.text! as String as NSString
                                self.navigationController?.pushViewController(LoginView, animated: true)
                                
                            }else{
                                  MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                                let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Group Name Already Exists!", delegate: self, cancelButtonTitle: "Ok")
                                Alert.show()
                              
                            }
                            
                            
                        }
                        
                        
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    })
                    // handle json...
                }else{
                    DispatchQueue.main.async(execute: {
                         MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Group Name Already Exists!", delegate: self, cancelButtonTitle: "Ok")
                        Alert.show()
                       
                    })
                    
                }
                
            } catch let error {
                self.isurl1 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/webservices/creategroup"
                self.AddGroupService()
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    }

    @IBAction func ActionOnMonthlye(_ sender: Any) {
        payment_term = "monthly"
        Weekbtnout.setImage(UIImage(named: "outline-blank.png"), for: UIControlState.normal)
        BiweekBtnout.setImage(UIImage(named: "outline-blank.png"), for: UIControlState.normal)
        Monthbtnout.setImage(UIImage(named: "radio-on-button-2.png"), for: UIControlState.normal)
        self.dailyimage.image = UIImage(named: "outline-blank.png")
    }
    @IBAction func ActionOnbiWeeklye(_ sender: Any) {
        payment_term = "bi-weekly"
        Weekbtnout.setImage(UIImage(named: "outline-blank.png"), for: UIControlState.normal)
        BiweekBtnout.setImage(UIImage(named: "radio-on-button-2.png"), for: UIControlState.normal)
        Monthbtnout.setImage(UIImage(named: "outline-blank.png"), for: UIControlState.normal)
        self.dailyimage.image = UIImage(named: "outline-blank.png")
    }
    @IBAction func ActionOnWeekly(_ sender: Any) {
        payment_term = "weekly"
        Weekbtnout.setImage(UIImage(named: "radio-on-button-2.png"), for: UIControlState.normal)
        BiweekBtnout.setImage(UIImage(named: "outline-blank.png"), for: UIControlState.normal)
        Monthbtnout.setImage(UIImage(named: "outline-blank.png"), for: UIControlState.normal)
        self.dailyimage.image = UIImage(named: "outline-blank.png")
    }
    @IBAction func ActionOnNext(_ sender: Any) {
       
        if self.GroupName_Txt.text==""{
            let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Group Name field can't be empty", delegate: self, cancelButtonTitle: "Ok")
            Alert.show()
            
        }
        else if self.Date_Txt.text==""{
            let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Date field can't be empty", delegate: self, cancelButtonTitle: "Ok")
            Alert.show()
            
        }
        else if self.Amount_txt.text==""{
            let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Money field can't be empty", delegate: self, cancelButtonTitle: "Ok")
            Alert.show()
            //CountName.text = String(self.NameTextFiled.text!.characters.count) + "/50"
            
        }else if self.Currency_Txt.text==""{
            let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Please select Currency", delegate: self, cancelButtonTitle: "Ok")
            Alert.show()
            
        }else{
            let Amount: Int = Int(self.Amount_txt.text!)!
            if Amount == 0{
                let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Amount should be greater than Zero", delegate: self, cancelButtonTitle: "Ok")
                Alert.show()
                
            }else{
            self.AddGroupService()
            }
            
        }

    }
}
