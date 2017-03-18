//
//  ViewController.swift
//  Ajo App
//
//  Created by mindcrewtechnologies on 23/02/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate  {
    @IBOutlet weak var pageControll: UIPageControl!
    
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var GoToButton: UIButton!
    
    @IBOutlet weak var scroll: UIScrollView!
    var images : NSArray = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        images = ["mmmm.png","m12.png","m13.png"]
        //Show all images
        for index in 0..<images.count {
            let xOrigin: CGFloat = (CGFloat)(index) * self.view.frame.size.width
            let img = UIImageView(frame: CGRect(x: xOrigin, y: -20.0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            img.isUserInteractionEnabled = true
            img.image = UIImage(named: images[index] as! String)
            img.contentMode = .scaleAspectFill
            self.scroll.addSubview(img)
        }
        
        let size = images.count;
        self.scroll.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(size), height: self.view.frame.size.height-100)
        skipButton.setTitle("SKIP",for: .normal)
        GoToButton.setTitle("NEXT",for: .normal)
        pageControll.currentPage=0
        pageControll.numberOfPages = images.count
        // Do any additional setup after loading the view, typically from a nib.
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControll.currentPage = Int(pageNumber)
        if pageNumber == 0 {
            print("0")
            skipButton.setTitle("SKIP",for: .normal)
            GoToButton.setTitle("NEXT",for: .normal)
            skipButton.isHidden = false
       
        }else if pageNumber == 1 {
            print("1")
            skipButton.setTitle("SKIP",for: .normal)
            GoToButton.setTitle("NEXT",for: .normal)
            skipButton.isHidden = false
            
        }else if pageNumber == 2 {
            print("2")
            skipButton.setTitle("SKIP",for: .normal)
            GoToButton.setTitle("GOT IT",for: .normal)
            skipButton.isHidden = true
            
        }
    }
    @IBAction func ActionOnPageControll(_ sender: Any) {
        let width = self.view.frame.size.width
        let rect = CGRect(x: width * CGFloat(pageControll.currentPage), y: -20, width: width, height: self.view.frame.size.height)
        self.scroll .scrollRectToVisible(rect, animated: true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    @IBAction func ActionOnGoto(_ sender: Any) {
        if pageControll.currentPage == 2 {
            let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let LoginView:LoginViewController = (story.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController)!
            self.navigationController?.pushViewController(LoginView, animated: true)
        }else{
            pageControll.currentPage = pageControll.currentPage+1

            let width = self.view.frame.size.width
            let rect = CGRect(x: width * CGFloat(pageControll.currentPage), y: 0, width: width, height: self.view.frame.size.height)
            self.scroll.scrollRectToVisible(rect, animated: true)
        
            if pageControll.currentPage == 2 {
                skipButton.setTitle("SKIP",for: .normal)
                GoToButton.setTitle("GOT IT",for: .normal)
                skipButton.isHidden = true
            }
        }
        
        
    }

    @IBAction func ActionOnSkip(_ sender: Any) {
        let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginView:LoginViewController = (story.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController)!
        self.navigationController?.pushViewController(LoginView, animated: true)
    }


}

