//
//  AboutusViewController.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 23/02/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class AboutusViewController: UIViewController,CAPSPageMenuDelegate,UIPopoverPresentationControllerDelegate{
    var pageMenu : CAPSPageMenu?
    var controller1 : ContectUsViewController!
    var controller2 : AboutNewViewController!
    
    var isHome : Bool!
    var isDisApear : Bool = false
    var isupdateevent : Bool = false
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        
        
    }
    
    
    @IBAction func ActionOnShare(_ sender: Any) {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
        let message = "Downlode Ajo App"
        let link = NSURL(string: "http://yoururl.com")
        let objectsToShare = [message,link!] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.title = "Share One"
        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.popoverPresentationController?.sourceRect = (sender as AnyObject).frame
        
        self.present(activityVC, animated: true, completion: nil)
        }else{
            let message = "Downlode Ajo App"
            //Set the link to share.
            if let link = NSURL(string: "http://yoururl.com")
            {
                let objectsToShare = [message,link] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
                self.present(activityVC, animated: true, completion: nil)
            }
        
        
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        UserDefaults.standard.removeObject(forKey: "isMenus")
        //menuButton.setImage(UIImage(named: "MenuImage.png"), forState: .Normal)
        // menuButton.setImage(UIImage(named: "5.png"), forState: .Selected)
        
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
       
        if isupdateevent == true {
            
            isupdateevent = false
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
                
                controller1 = storyboard.instantiateViewController(withIdentifier: "ContectUsViewController") as! ContectUsViewController
                //controller1.delegate = self
                controller1.title = "Contact Us"
                controllerArray.append(controller1)
                
                controller2 = storyboard.instantiateViewController(withIdentifier: "AboutNewViewController") as! AboutNewViewController
                //controller2.delegate = self
                controller2.title = "About Us"
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
                pageMenu?.moveToPage(2)
                
                self.view.addSubview(pageMenu!.view)
                //self.view.bringSubviewToFront(ibAddBtn)
            }
            
        }else{
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
                
                controller1 = storyboard.instantiateViewController(withIdentifier: "ContectUsViewController") as! ContectUsViewController
                //controller1.delegate = self
                controller1.title = "Contact Us"
                controllerArray.append(controller1)
                
                controller2 = storyboard.instantiateViewController(withIdentifier: "AboutNewViewController") as! AboutNewViewController
               // controller2.delegate = self
                controller2.title = "About Us"
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
                //self.view.bringSubviewToFront(ibAddBtn)
            }
        }
       // self.view.bringSubview(toFront: MenuView);
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
    
    @IBAction func ActionOnback(_ sender: Any) {
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
