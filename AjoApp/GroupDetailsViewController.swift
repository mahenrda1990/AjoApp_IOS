//
//  GroupDetailsViewController.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 25/02/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class GroupDetailsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var pickerContainer = UIView()
    var picker = UIDatePicker()
    var key = "ajoapp17mindcrew"
    var iv = "mindcrewajoapp17"
    @IBOutlet weak var HidenLabel: UILabel!
    @IBOutlet weak var EditBtn: UIButton!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var swapButton: UIButton!
    @IBOutlet weak var collectionButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var AnimationView2: UIView!
    @IBOutlet weak var Animationview: UIView!
    @IBOutlet weak var DoneBtn: UIButton!
    @IBOutlet weak var MemberTableView: UITableView!
    var DetailsDictionary = [String: AnyObject]()
    @IBOutlet weak var HeadingLbl: UILabel!
    @IBOutlet weak var Admin_Namelbl: UILabel!
    @IBOutlet weak var StatusLbl: UILabel!
    @IBOutlet weak var PaymentAmountlbl: UILabel!
    @IBOutlet weak var PaymentTermslbl: UILabel!
    @IBOutlet weak var SatrtaOutdateLbl: UILabel!
    @IBOutlet weak var FinalAmountLbl: UILabel!
    
    @IBOutlet weak var PayoutLbl: UILabel!
    
    @IBOutlet weak var DeductionDateLbl: UILabel!
    var selectedCellIndexPath : IndexPath!
    @IBOutlet weak var tableHeightCons : NSLayoutConstraint?
    @IBOutlet weak var GroupCollectionView: UICollectionView!
    
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var collectionHeightCons: NSLayoutConstraint!
    let reuseIdentifier = "GroupCell"
    var group_id: NSString = NSString()
    var payout_turnavilabel: NSString = NSString()
    var avilabelcheck: NSString = NSString()
    var payout_turn_accepted: NSString = NSString()
    
    
    var isalreadypayout: NSString = NSString()
    var selecteddate: NSString = NSString()
    var checksetstaus: NSString = NSString()
    var isurl1: NSString = NSString()
    var isurl2: NSString = NSString()
    var isurl3: NSString = NSString()
    var isurl4: NSString = NSString()
    
    @IBOutlet weak var DeleteBtn: UIButton!
    @IBAction func ActionOnDelete(_ sender: Any) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Are you sure? Want to Delete", message: "", preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "NO", style: .cancel) { action -> Void in
            //Do your task
        }
        actionSheetController.addAction(cancelAction)
        let nextAction: UIAlertAction = UIAlertAction(title: "YES", style: .default) { action -> Void in
            //Do your task
           self.DeleteGropWebservice()
        }
        actionSheetController.addAction(nextAction)
        self.present(actionSheetController, animated: true, completion: nil)

        
    }
    
    
    @IBAction func ActionOnOkeditdate(_ sender: Any) {
        
        self.Animationview.isHidden = true
        UserDefaults.standard.set("YES", forKey: "Ishidenshow1");
    }
    
    
    @IBAction func ActionOnOkMenber(_ sender: Any) {
        self.AnimationView2.isHidden = true
         UserDefaults.standard.set("YES", forKey: "Ishidenshow2");

    }
    
    @IBAction func ActionOnEditDate(_ sender: Any) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Are you sure? Want to Edit Start Date", message: "", preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "NO", style: .cancel) { action -> Void in
            //Do your task
        }
        actionSheetController.addAction(cancelAction)
        let nextAction: UIAlertAction = UIAlertAction(title: "YES", style: .default) { action -> Void in
            //Do your task
            self.configurePicker()
        }
        actionSheetController.addAction(nextAction)
        self.present(actionSheetController, animated: true, completion: nil)
       
    }

    
    @IBAction func ActionOnDone(_ sender: Any) {
            if avilabelcheck == "CheckAvilable"{
                    SwapOutWebservice()
                }else{
            
                        
            }
    }
    
    var LoginId: NSString = NSString()
    var items : NSMutableArray!
     var memberarr : NSMutableArray!
    var totalCount = 0
    override func viewDidAppear(_ animated: Bool) {
        LoginId = (UserDefaults.standard.object(forKey: "loginid")as? NSString)!
        self.navigationController?.isNavigationBarHidden = true
        self.DoneBtn.layer.borderColor = UIColor.white.cgColor;
        self.DoneBtn.layer.borderWidth = 1.0;
        self.DoneBtn.layer.cornerRadius = 8.0;
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isurl1 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/webservices/groupMembersList"
        self.isurl2 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/deletegroup"
        self.isurl3 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/webservices/updategroupstartdate"
        self.isurl4 = "https://ajoapp1.eu-gb.mybluemix.net/api/v1/selectpayoutturn"
         Animation()
        items = NSMutableArray()
        memberarr = NSMutableArray()
        self.ScrollView.layer.borderColor = UIColor.purple.cgColor;
        self.ScrollView.layer.borderWidth = 1.0;
        self.ScrollView.layer.cornerRadius = 8.0;
        if checksetstaus == "Gone" {
            self.DeleteBtn.isHidden = true
            self.EditBtn.isHidden = true
            self.Animationview.isHidden = true
            self.AnimationView2.isHidden = true
        }else{
            if UserDefaults.standard.string(forKey: "Ishidenshow1") == "YES"{
                self.Animationview.isHidden = true
                
            }else{
             self.Animation()
            }
            
            if UserDefaults.standard.string(forKey: "Ishidenshow2") == "YES"{
            self.AnimationView2.isHidden = true
            
            }else{
            self.Animation2()
            }
        
        }
        
        items = DetailsDictionary["members"] as! NSMutableArray!
        let Name = DetailsDictionary["admin_name"] as! String
        var Adname = "Admin : "
        let emil = (UserDefaults.standard.object(forKey: "email")as? NSString)! as String
        
        let desName = try! Name.aesDecrypt(key: key, iv: iv)
        Adname = Adname + " \(desName)"
        self.Admin_Namelbl.text = Adname as String

        group_id = DetailsDictionary["id"] as! NSString
        final_amount()
        daiily_amount()
        payoutdone()
        DailySatus()
        print(DetailsDictionary)
        var plan_start_date = "Started On : "
        var plan_start_date2 = "Select payout turn from : "
        var plan_start_date3 = "Next deduction planned on : "
        let DateString = DetailsDictionary["plan_start_date"]
        let payout_start_date = DetailsDictionary["payout_start_date"]
        let next_deduction_planned = DetailsDictionary["next_deduction_planned"]
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy"
        let date: Date? = dateFormatterGet.date(from: DateString as! String)
        let date2: Date? = dateFormatterGet.date(from: payout_start_date as! String)
        let date3: Date? = dateFormatterGet.date(from: next_deduction_planned as! String)
        print(dateFormatterPrint.string(from: date!))
        let created = (dateFormatterPrint.string(from: date!)) as String
        let created2 = (dateFormatterPrint.string(from: date2!)) as String
        let created3 = (dateFormatterPrint.string(from: date3!)) as String
        plan_start_date = plan_start_date + " \(created)"
        plan_start_date2 = plan_start_date2 + " \(created2)"
        plan_start_date3 = plan_start_date3 + " \(created3)"
        self.SatrtaOutdateLbl.text = plan_start_date;
        self.PayoutLbl.text = plan_start_date2;
        self.DeductionDateLbl.text = plan_start_date3;
        
        let  group_name = DetailsDictionary["group_name"] as! String
        let desg_name = try! group_name.aesDecrypt(key: key, iv: iv)
        HeadingLbl.text = desg_name as String
        
        let Todaydate : NSDate = NSDate()
        
        if date! < Todaydate as Date {
            print("earlier")
            self.StatusLbl.text = "Already Started";
            self.StatusLbl.textColor =  UIColor.green;
        }else{
            print("not earlier")
            self.StatusLbl.text = "Not started yet"
            self.StatusLbl.textColor =  UIColor.red;
        }

        totalCount = items.count/3;
        if (totalCount*3) < items.count {
            totalCount += 1;
        }
        collectionHeightCons.constant = CGFloat(Float(totalCount * 88))+10;
        // Do any additional setup after loading the view.
    }
    
    func payoutdone() {
        
        let DateString = DetailsDictionary["payout_start_date"] as! String
        let DateString2 = DetailsDictionary["plan_start_date"] as! String
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy"
        let datePayOut: Date? = dateFormatterGet.date(from: DateString)
        let dateStart: Date? = dateFormatterGet.date(from: DateString2)
        print(dateFormatterPrint.string(from: datePayOut!))

        let calendar = NSCalendar.current
        let Todaydate : NSDate = calendar.startOfDay(for: NSDate() as Date) as NSDate
        
        payout_turn_accepted = DetailsDictionary["payout_turn_accepted"] as! String as NSString
        if payout_turn_accepted == "true" {
            
            if isalreadypayout == "false" {
                swapButton.isHidden = true
            }else{
                swapButton.isHidden = false
            }
            
        }else{
         swapButton.isHidden = true
        }
        
        

        
       
            
            if dateStart! > Todaydate as Date  {
                
                
                if payout_turn_accepted == "false" {
                    
                    self.DoneBtn.isHidden = false
                }else{
                    self.DoneBtn.isHidden = true
                }
                
                
                self.HidenLabel.isHidden = false

                viewHeight.constant = 441
                
            }else{
                self.DoneBtn.isHidden = true
                self.HidenLabel.isHidden = true
                
                viewHeight.constant = 340;
            }
            
       
        
        
        
        

    }
   
    func final_amount(){
        
   // let  final_amount = DetailsDictionary["final_amount"]
        
        let final_amount = (DetailsDictionary["final_amount"] as AnyObject).int32Value;
        let int: Int = Int(final_amount! as NSNumber)
        let isfinal_amount = String(int)
        let  currency = DetailsDictionary["currency"] as! String
        if currency == "GBP"{
            let signOfCurrency = "£"
            var final_amountheding = "Final Payout : "
            final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(isfinal_amount)"
            self.FinalAmountLbl.text = final_amountheding as String
        }else if currency == "INR" {
            let signOfCurrency = "Rs."
            
            var final_amountheding = "Final Payout : "
            final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(isfinal_amount)"
            self.FinalAmountLbl.text = final_amountheding as String
        }else if currency == "USD" {
            let signOfCurrency = "$"
            
            var final_amountheding = "Final Payout : "
            final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(isfinal_amount)"
            self.FinalAmountLbl.text = final_amountheding as String
        }else if currency == "NGN" {
            let signOfCurrency = "₦"
           
            var final_amountheding = "Final Payout : "
            final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(isfinal_amount)"
            self.FinalAmountLbl.text = final_amountheding as String
        }else if currency == "EU" {
            let signOfCurrency = "€"
           
            var final_amountheding = "Final Payout : "
            final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(isfinal_amount)"
            self.FinalAmountLbl.text = final_amountheding as String
        }else if currency == "GHS" {
            let signOfCurrency = "GH₵"
            var final_amountheding = "Final Payout : "
            final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(isfinal_amount)"
            self.FinalAmountLbl.text = final_amountheding as String
        }else if currency == "ZAR" {
            let signOfCurrency = "ZAR"
            var final_amountheding = "Final Payout : "
            final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(isfinal_amount)"
            self.FinalAmountLbl.text = final_amountheding as String
        }else if currency == "KES" {
            let signOfCurrency = "KSh"
            var final_amountheding = "Final Payout : "
            final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(isfinal_amount)"
            self.FinalAmountLbl.text = final_amountheding as String
        }
        
    }
    func DailySatus(){
        
        // let  final_amount = DetailsDictionary["final_amount"]
       
        let  payment_term = DetailsDictionary["payment_term"] as! String
        var final_amountheding = "Payment term : "
        final_amountheding = final_amountheding + " \(payment_term)"
        self.PaymentTermslbl.text = final_amountheding as String
        
        
    }
    
    func daiily_amount(){
        
        // let  final_amount = DetailsDictionary["final_amount"]
        let final_amount = (DetailsDictionary["amount"] as AnyObject).int32Value;
        let int: Int = Int(final_amount! as NSNumber)
        let isfinal_amount = String(int)
        let  currency = DetailsDictionary["currency"] as! String
        if currency == "GBP"{
            let signOfCurrency = "£"
            var final_amountheding = "Daily Payment : "
            final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(isfinal_amount)"
            self.PaymentAmountlbl.text = final_amountheding as String
        }else if currency == "INR" {
            let signOfCurrency = "Rs."
            
            var final_amountheding = "Daily Payment : "
            final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(isfinal_amount)"
            self.PaymentAmountlbl.text = final_amountheding as String
        }else if currency == "USD" {
            let signOfCurrency = "$"
            
            var final_amountheding = "Daily Payment : "
            final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(isfinal_amount)"
            self.PaymentAmountlbl.text = final_amountheding as String
        }else if currency == "NGN" {
            let signOfCurrency = "₦"
            
            var final_amountheding = "Daily Payment : "
            final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(isfinal_amount)"
            self.PaymentAmountlbl.text = final_amountheding as String
        }else if currency == "EU" {
            let signOfCurrency = "€"
            
            var final_amountheding = "Daily Payment : "
            final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(isfinal_amount)"
            self.PaymentAmountlbl.text = final_amountheding as String
        }else if currency == "GHS" {
            let signOfCurrency = "GH₵"
            var final_amountheding = "Daily Payment : "
            final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(isfinal_amount)"
            self.PaymentAmountlbl.text = final_amountheding as String
        }else if currency == "ZAR" {
            let signOfCurrency = "ZAR"
            var final_amountheding = "Daily Payment : "
            final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(isfinal_amount)"
            self.PaymentAmountlbl.text = final_amountheding as String
        }else if currency == "KES" {
            let signOfCurrency = "KSh"
            var final_amountheding = "Daily Payment : "
            final_amountheding = final_amountheding + " \(signOfCurrency)" + " \(isfinal_amount)"
            self.PaymentAmountlbl.text = final_amountheding as String
        }

        
        
  
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
        }
    // make a cell for each cell index path
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCell", for: indexPath) as! GroupCollectionViewCell
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
        let  group_name = dic .object(forKey: "payout_member") as! NSString as String
        if group_name == "Available" {
             if ((selectedCellIndexPath != nil) && (selectedCellIndexPath == indexPath)) {
               // cell.Namelabel.text = group_name as String
                cell.myLabel.backgroundColor = UIColor .green
                cell.myLabel.layer.cornerRadius = cell.myLabel.bounds.size.width/2;
                cell.myLabel.layer.masksToBounds = true;
                cell.dateLabel.textColor = UIColor .brown
                cell.Namelabel.textColor = UIColor .brown

             }else{
                cell.Namelabel.text = group_name as String
                cell.myLabel.backgroundColor = UIColor .lightGray
                cell.myLabel.layer.cornerRadius = cell.myLabel.bounds.size.width/2;
                cell.myLabel.layer.masksToBounds = true;
                cell.dateLabel.textColor = UIColor .green
                cell.Namelabel.textColor = UIColor .green

            }
            
        }else{
            
            let desg_namess = try! group_name.aesDecrypt(key: key, iv: iv)
            cell.Namelabel.text = desg_namess as String
            cell.myLabel.layer.cornerRadius = cell.myLabel.bounds.size.width/2;
            cell.myLabel.layer.masksToBounds = true;
            
            cell.dateLabel.textColor = UIColor .brown
            cell.Namelabel.textColor = UIColor .brown
            let calendar = NSCalendar.current
            let Todaydate : NSDate = calendar.startOfDay(for: NSDate() as Date) as NSDate
            
            if date! <= Todaydate as Date  {
            
            cell.myLabel.backgroundColor = UIColor .red
                
            }else{
            cell.myLabel.backgroundColor = UIColor .green
            }
            
        
        }
       
        let  payout_turn = dic .object(forKey: "payout_turn") as! NSString as String
        cell.myLabel.text = payout_turn as NSString as String
        cell.dateLabel.text = plan_start_date as NSString as String
    return cell
            
        }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        print("You selected cell #\(indexPath.item)!")
         var cell = collectionView.cellForItem(at: indexPath) as! GroupCollectionViewCell
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
        let  group_name = dic .object(forKey: "payout_member") as! NSString as String
        if group_name == "Available" {
           //cell.myLabel.backgroundColor = UIColor .green
            selectedCellIndexPath = indexPath;
            collectionView.reloadData()
            let selectedDic = self.items[selectedCellIndexPath.row] as! NSDictionary
            print(selectedDic)
            payout_turnavilabel = (selectedDic .object(forKey: "payout_turn") as! NSString) as String as String as NSString
            avilabelcheck = "CheckAvilable"
            
            //click
        }else{
            let group_name = try! group_name.aesDecrypt(key: key, iv: iv)
            print(group_name) // foo
//            if let decodedData = NSData(base64Encoded: group_name , options: NSData.Base64DecodingOptions(rawValue: 0)),
//                let group_name = NSString(data: decodedData as Data, encoding: String.Encoding.utf8.rawValue) {
//                print(group_name) // foo
//                
//            }
            let calendar = NSCalendar.current
            let Todaydate : NSDate = calendar.startOfDay(for: NSDate() as Date) as NSDate
            
            if date! <= Todaydate as Date  {
                
                
            }else{
               
            }
          
          avilabelcheck = "UNAvilable"
        }
        let  payout_turn = dic .object(forKey: "payout_turn") as! NSString as String
    
        ////
       
        

    }
  
    
    @IBAction func ActionOnContact(_ sender: Any) {
        contactButton.isSelected = !contactButton.isSelected;
        if contactButton.isSelected {
            MemberListService()
            //tableHeightCons?.constant = 70;
            tableHeightCons?.constant = CGFloat(Float(memberarr.count * 60)) + 40;
            GroupCollectionView.isHidden = true;
            swapButton.isHidden = true
            collectionHeightCons.constant = 0;
            collectionButtonHeight.constant = 0;
        }else{
            
//            MemberListService()
//            tableHeightCons?.constant = 0;
//            GroupCollectionView.isHidden = false;
//            swapButton.isHidden = false
//            collectionHeightCons.constant = CGFloat(Float(totalCount * 88));
//            collectionButtonHeight.constant = 50;
        }
    }
    @IBAction func Actionback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let LoginView:KYDrawerController = (story.instantiateViewController(withIdentifier: "KYDrawerController") as? KYDrawerController)!
//        self.navigationController?.pushViewController(LoginView, animated: true)
    }
    @IBAction func ActionOnback(_ sender: Any) {
        let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginView:KYDrawerController = (story.instantiateViewController(withIdentifier: "KYDrawerController") as? KYDrawerController)!
        self.navigationController?.pushViewController(LoginView, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memberarr.count
        //return 10;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("menuCell");
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberTableViewCell
        
        if let GroupDic = self.memberarr[indexPath.row] as? NSDictionary{
            let  group_name = GroupDic .object(forKey: "member_name") as! NSString as String
            let group_member_name = try! group_name.aesDecrypt(key: key, iv: iv)
            cell.NameLble.text = group_member_name as String
            let image = UIImage(named: "info.png")! as UIImage
            cell.InfoBtn .setImage(image, for: UIControlState.normal)
            cell.InfoBtn.addTarget(self, action: #selector(self.infoOPTION), for: .touchUpInside)
            cell.InfoBtn.tag = indexPath.row

            
        }else{
            cell.NameLble.text = self.memberarr[indexPath.row] as? String
            let image = UIImage(named: "phone_book.png")! as UIImage
            cell.InfoBtn .setImage(image, for: UIControlState.normal)
        }
        
        return cell;
    }
    func infoOPTION(sender: AnyObject) {
        var btn = (sender as! UIButton)
        var Groupdata = self.self.memberarr[btn.tag] as! NSDictionary
       let loginid = Groupdata["loginid"] as! String
      let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginView:MemberDetilsViewController = (story.instantiateViewController(withIdentifier: "MemberDetilsViewController") as? MemberDetilsViewController)!
        LoginView.Userid = loginid as String as NSString
        self.navigationController?.pushViewController(LoginView, animated: true)
        //MemberDetilsViewController
    }
    // MARK: - UITableView delegates
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        if let GroupDic = self.memberarr[indexPath.row] as? NSDictionary{
            //arr data code
        }else{
            let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let LoginView:InviteViewController = (story.instantiateViewController(withIdentifier: "InviteViewController") as? InviteViewController)!
            LoginView.group_id = group_id as String as NSString
            LoginView.group_nameencrapted = DetailsDictionary["group_name"] as! String as NSString
            LoginView.group_name = HeadingLbl.text! as String as NSString
            self.navigationController?.pushViewController(LoginView, animated: true)
        }

    }
    func MemberListService(){
        
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{

        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.labelText = "Please wait"
        let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
        
        let Dictonary: NSMutableDictionary = NSMutableDictionary()
        let parameters = ["group_id": group_id as String,"auth_token": token] as Dictionary<String, String>
        Dictonary.setObject(parameters, forKey : "groupMembersList" as NSCopying)
            
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
                                self.memberarr .removeAllObjects()
                                if self.checksetstaus == "Gone" {
                                    self.DeleteBtn.isHidden = true
                                    self.EditBtn.isHidden = true
                                }else{
                                    self.memberarr.add("Send Invite")
                                }
                                let arr = (json["acceptedMembersDetail"] as! NSArray);
                                
                                for i in 0  ..< arr.count  {
                                    let dict = arr[i] as! NSDictionary
                                    self.memberarr.add(dict)
                                }
                               // self.memberarr = (json["acceptedMembersDetail"] as? NSMutableArray)!;
                                self.tableHeightCons?.constant = CGFloat(Float(self.memberarr.count * 60)) + 40;

                                
                                self.MemberTableView .reloadData()
                                
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
                self.isurl1 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/webservices/groupMembersList"
                self.MemberListService()
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    }

    
    func DeleteGropWebservice(){
        
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
        let  group_nameencrapted = DetailsDictionary["group_name"] as! String
        
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.labelText = "Please wait"
        let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
        
        let Dictonary: NSMutableDictionary = NSMutableDictionary()
        let parameters = ["group_id": group_id as String,"group_name": group_nameencrapted as String,"auth_token": token] as Dictionary<String, String>
        Dictonary.setObject(parameters, forKey : "deletegroup" as NSCopying)
        
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
                self.isurl2 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/deletegroup"
                self.DeleteGropWebservice()
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    }
    
    func EditdateWEbservice(){
        
      
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.labelText = "Please wait"
        let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
        
        let Dictonary: NSMutableDictionary = NSMutableDictionary()
        let parameters = ["group_id": group_id as String,"start_date": self.selecteddate as String,"auth_token": token] as Dictionary<String, String>
        Dictonary.setObject(parameters, forKey : "updategroupstartdate" as NSCopying)
        

        //create the url with URL
        let url = URL(string: self.isurl3 as String)! //change the url
        
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
                self.isurl3 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/webservices/updategroupstartdate"
                self.EditdateWEbservice()
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    }
    
    func dismissPicker ()
    {
        UIView.animate(withDuration: 0.4, animations: {
            self.pickerContainer.frame = CGRect(x: 0.0, y: self.view.frame.size.height+50, width: self.view.frame.size.width, height: 300)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            //self.selectedDate.setTitle(dateFormatter.string(from: self.picker.date), for: UIControlState.normal)
            self.selecteddate = dateFormatter.string(from: self.picker.date) as NSString
            self.EditdateWEbservice()
        })
    }
    func CancelAction(_ sender: AnyObject)
    {
        UIView.animate(withDuration: 0.4, animations: {
            self.pickerContainer.frame = CGRect(x: 0.0, y: self.view.frame.size.height+50, width: self.view.frame.size.width, height: 300)
            
        })
    }
    func configurePicker()
    {
        pickerContainer.frame = CGRect(x: 0.0, y: self.view.frame.size.height-300, width: self.view.frame.size.width, height: 300.0)
        pickerContainer.backgroundColor = UIColor.purple
        
        picker.frame    = CGRect(x: 0.0, y: 50.0, width: self.view.frame.size.width, height: 280.0)
        picker.backgroundColor = UIColor.white
        let DateStringstrnew = DetailsDictionary["plan_start_date"]
        let dateFormatterGetstr = DateFormatter()
        dateFormatterGetstr.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy"
        let datesterrnew: Date? = dateFormatterGetstr.date(from: DateStringstrnew as! String)
        print(datesterrnew)

        //let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: datesterrnew!)
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

    
     @IBAction func ActionOnmaberancel(_ sender: Any) {
        tableHeightCons?.constant = 0;
        GroupCollectionView.isHidden = false;
        tableHeightCons?.constant = 0;
        GroupCollectionView.isHidden = false;
        //swapButton.isHidden = false
        collectionHeightCons.constant = CGFloat(Float(totalCount * 88));
        collectionButtonHeight.constant = 50;
        if payout_turn_accepted == "true" {
            if isalreadypayout == "false" {
                swapButton.isHidden = true
            }else{
                swapButton.isHidden = false
            }
        }else{
        swapButton.isHidden = true
        }
        
        
 
     }
    func Animation(){
    UIView.animate(withDuration: 2.0, delay: 0.0,
    usingSpringWithDamping: 0.25,
    initialSpringVelocity: 0.0,
    options: [],
    animations: {
    self.Animationview.layer.position.x += 200.0
    //self.Animationview.layer.cornerRadius = 50.0
    self.Animationview.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.0)
    }, completion: nil)
    }
    func Animation2(){
        UIView.animate(withDuration: 2.0, delay: 0.0,
                       usingSpringWithDamping: 0.25,
                       initialSpringVelocity: 0.0,
                       options: [],
                       animations: {
                        self.AnimationView2.layer.position.x += 200.0
                        //self.Animationview.layer.cornerRadius = 50.0
                        self.AnimationView2.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.0)
        }, completion: nil)
    }
    func SwapOutWebservice(){
        
        if Reachability.shared().internetConnectionStatus() == NotReachable {
            var alert = UIAlertView(title: "Please check network connection.", message: nil, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
       let Name = (UserDefaults.standard.object(forKey: "fname")as? NSString)! as String
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification?.labelText = "Please wait"
        let token = "Mind$17QWpvYXBwOk1pbmRDcmV3OkFuZHJvaWQ6TWFyb29m"
        

        let Dictonary: NSMutableDictionary = NSMutableDictionary()
        let parameters = ["group_id": group_id as String,"customer_id": LoginId as String,"payout_turn": payout_turnavilabel as String,"select_payout_notification": "false","customer_name": Name as String,"auth_token": token] as Dictionary<String, String>
        Dictonary.setObject(parameters, forKey : "selectpayoutturn" as NSCopying)
        
        //create the url with URL
        let url = URL(string: self.isurl4 as String)! //change the url
        
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
                                let Alert:UIAlertView = UIAlertView(title: "Alert", message: "Payout turn already selected!! try another", delegate: self, cancelButtonTitle: "Ok")
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
                self.isurl4 = "https://ajoapp2.eu-gb.mybluemix.net/api/v1/selectpayoutturn"
                self.SwapOutWebservice()
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    }
    

    @IBAction func ActionOnSwapOut(_ sender: Any) {
        
        let swappayout = (UserDefaults.standard.object(forKey: "swappayout")as? NSString)!
        if swappayout == "true"{
        
        let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginView:SwapOutViewController = (story.instantiateViewController(withIdentifier: "SwapOutViewController") as? SwapOutViewController)!
        LoginView.group_id = group_id
        LoginView.group_Name =  DetailsDictionary["group_name"] as! String as NSString

        LoginView.startdate = DetailsDictionary["plan_start_date"] as! NSString
        
        self.navigationController?.pushViewController(LoginView, animated: true)
        }else {
            let actionSheetController: UIAlertController = UIAlertController(title: "To use this feature, please enable allow swap request", message: "", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Yes", style: .cancel) { action -> Void in
                //Do your task
                let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let LoginView: MyprofileViewController = (story.instantiateViewController(withIdentifier: "MyProfileViewController") as? MyprofileViewController)!
                self.navigationController?.pushViewController(LoginView, animated: true)
            }
            actionSheetController.addAction(cancelAction)
            let nextAction: UIAlertAction = UIAlertAction(title: "No", style: .default) { action -> Void in
                
                
            }
            actionSheetController.addAction(nextAction)
            self.present(actionSheetController, animated: true, completion: nil)
            
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
