//
//  HomeViewVC.swift
//  Automatic Backup WiFi Camera
//
//  Created by Shivang Dave on 7/13/18.
//  Copyright © 2018 Shivang Dave. All rights reserved.
//

import UIKit
import AnimatedScrollView

class HomeViewVC: UIViewController
{
    //MARK:- Outlets
    @IBOutlet weak var animatedScroll: AnimatedScrollView!
    @IBOutlet weak var cardBackView : cardView!
    @IBOutlet weak var cardView : cardView!
    @IBOutlet weak var lblDate : middleLabel!

    //MARK:- UIView methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setDate()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        animatedScroll.animate(self.view, imageName: "background", animated: true)
        animatedScroll.alpha = 0.3
        cardView.addTarget(self, action: #selector(nextVC(_:)), for: .touchUpInside)
    }
    
    func setDate()
    {   
        if appDelegate.lastDate != nil
        {
            lblDate.text = "Last accessed at: " + appDelegate.lastDate!
        }
        else
        {
            lblDate.text = "Analytics not available!"
        }
    }
    
    //MARK:- Reload background animator
    @objc func nextVC(_ sender: Any)
    {
    }
}
