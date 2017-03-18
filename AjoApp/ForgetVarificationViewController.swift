//
//  ForgetVarificationViewController.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 01/03/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit
import Fabric
import DigitsKit
class ForgetVarificationViewController: UIViewController {
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
    var CCode : String!
    var phoneNumber : String!
    var isurl1: NSString = NSString()
    var key = "ajoapp17mindcrew"
    var iv = "mindcrewajoapp17"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isurl1 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/checkmobilenumber"
        Digits.sharedInstance().logOut()
        let digitsButton = DGTAuthenticateButton(authenticationCompletion: { (session, error) in
            // Inspect session/error objects
            if (session != nil) {
                // TODO: associate the session userID with your user model
                let message = "Phone number: \(session!.phoneNumber)"
                
                for  number in self.CountryCodeArr{
                    if (session?.phoneNumber.contains(number))!{
                        self.CCode = number as String;
                        self.phoneNumber = session?.phoneNumber
                        
                        
                        self.phoneNumber = (self.phoneNumber as NSString).replacingOccurrences(of: number, with: "");
                        UserDefaults.standard.set(session!.phoneNumber, forKey: "MOBNO")
                        UserDefaults.standard.set(self.phoneNumber, forKey: "phoneNumber")
                        UserDefaults.standard.set(self.CCode, forKey: "CCode")
                        self.CheckPhoneService()
                        break;
                    }
                }
                
                
                
                
            } else {
                NSLog("Authentication error: %@", error!.localizedDescription)
            }
            
            
        })
        digitsButton?.center = self.view.center;
        self.view.addSubview(digitsButton!)
        // Do any additional setup after loading the view.
    }
    func CheckPhoneService(){
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
            let mobno = phoneNumber as String
            let Mobile_no = try! mobno.aesEncrypt(key: key, iv: iv)
//        guard let plainData = (phoneNumber )?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) else {
//            fatalError()
//        }
//        let Mobile_no = (plainData as NSData).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        print(Mobile_no)
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.labelText = "Please wait"
        let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
        
        let Dictonary: NSMutableDictionary = NSMutableDictionary()
        let parameters = ["mobile_no": Mobile_no as String,"auth_token": token] as Dictionary<String, String>
        Dictonary.setObject(parameters, forKey : "checkmobilenumber" as NSCopying)
        

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
                                
                                
                        self.GotoForgetpass()
                                
                            }else{
                                let Alert:UIAlertView = UIAlertView(title: "Alert", message: "NO date Found", delegate: self, cancelButtonTitle: "Ok")
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
                 self.isurl1 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/checkmobilenumber"
                self.CheckPhoneService()
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    }
    func GotoForgetpass()
    {
        let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginView:ForgetpasswordViewController = (story.instantiateViewController(withIdentifier: "ForgetpasswordController") as? ForgetpasswordViewController)!
        self.navigationController?.pushViewController(LoginView, animated: true)
        
        
    }
    func didTapButton(sender: AnyObject) {
        let digits = Digits.sharedInstance()
        let configuration = DGTAuthenticationConfiguration(accountFields: .defaultOptionMask)
        configuration?.phoneNumber = "+345555555555"
        digits.authenticate(with: nil, configuration: configuration!) { session, error in
            // Country selector will be set to Spain and phone number field will be set to 5555555555
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func ActionOnback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
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
