//
//  PayoutViewController.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 28/02/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class PayoutViewController: UIViewController,CAPSPageMenuDelegate {
    var DetailsDictionary = [String: AnyObject]()
    var pageMenu : CAPSPageMenu?
    var controller1 : CompletedPayoutViewController!
    var controller2 : UpcommingPayoutViewController!
    var key = "ajoapp17mindcrew"
    var iv = "mindcrewajoapp17"
    @IBAction func ActionOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    @IBOutlet weak var HeaderLbl: UILabel!
    var isHome : Bool!
    var isDisApear : Bool = false
    var isupdateevent : Bool = false
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let group_name = DetailsDictionary["group_name"] as! String
        
        let group_namee = try! group_name.aesDecrypt(key: self.key, iv: self.iv)
        self.HeaderLbl.text = group_namee as String
        
        //self.HeaderLbl.text = DetailsDictionary["group_id"] as! UIColor!
        self.navigationController?.isNavigationBarHidden = true

            var newBool : Bool!
            if isHome != nil{
                newBool = isHome
            }else{
                newBool = UserDefaults.standard.bool(forKey: "IsHome")
            }
            if newBool == false {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                // let vc = storyboard.instantiateViewControllerWithIdentifier("someViewController") as! UIViewController
                var controllerArray : [UIViewController] = []
                
                controller1 = storyboard.instantiateViewController(withIdentifier: "CompletedPayoutViewController") as! CompletedPayoutViewController
                //controller1.delegate = self
                controller1.title = "Completed Payout"
                controllerArray.append(controller1)
                controller1 .DetailsDictionary = DetailsDictionary
                
                print(DetailsDictionary)
                
                controller2 = storyboard.instantiateViewController(withIdentifier: "UpcommingPayoutViewController") as! UpcommingPayoutViewController
                // controller2.delegate = self
                controller2.title = "Upcoming Payout"
                controller2 .DetailsDictionary = DetailsDictionary
                controllerArray.append(controller2)
                
                
                
                // Initialize scroll menu
                var parameters: [CAPSPageMenuOption] = [
                    .menuItemSeparatorWidth(4.3),
                    .useMenuLikeSegmentedControl(true),
                    .menuItemSeparatorPercentageHeight(0.1),
                    .menuItemWidth(100)
                ]
                pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 69.0, width: self.view.frame.width, height: self.view.frame.height-69), pageMenuOptions: nil)
                pageMenu?.delegate = self
                self.view.addSubview(pageMenu!.view)
                controller1.ComplitedListService()
                
            }
      //  }

        // Do any additional setup after loading the view.
    }
    func didMoveToPage(_ controller: UIViewController, index: Int){
        switch pageMenu?.currentPageIndex {
        case 0?:
            //controller1.getguestList()
            break
        case 1?:
            //controller2.getInviteList()
            break
            
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
