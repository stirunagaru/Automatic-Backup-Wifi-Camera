//
//  ViewController.swift
//  Automatic Backup WiFi Camera
//
//  Created by Shivang Dave on 7/4/18.
//  Copyright © 2018 Shivang Dave. All rights reserved.
//

import UIKit
import AnimatedScrollView
import MaterialComponents.MaterialMaskedTransition

class WelcomeVC: UIViewController
{
    //MARK:- Outlets
    @IBOutlet weak var animatedScroll: AnimatedScrollView!
    @IBOutlet weak var cardBackView : cardView!
    @IBOutlet weak var cardView : cardView!
    @IBOutlet weak var btnSuccess : roundButton!
    
    //MARK:- UIView methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        AppUtility.lockOrientation(.portrait)
        prepareViews()
        addTestProp()
    }
    
    func prepareViews()
    {
        self.animatedScroll.animate(self.view, imageName: "background", animated: true)
        self.animatedScroll.alpha = 0.3
        self.cardView.addTarget(self, action: #selector(self.nextVC(_:)), for: .touchUpInside)
    }
    
    func addTestProp()
    {
        self.btnSuccess.isAccessibilityElement = true
        self.btnSuccess.accessibilityLabel = "btn"
//        if(ProcessInfo.processInfo.environment["UITEST_DISABLE_ANIMATIONS"]=="YES")
//        {
//        }
    }
    
    //MARK:- Move to next view
    @IBAction func btnSuccessClicked(_ sender: Any)
    {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "navigationController0")
        let transitionController = MDCMaskedTransitionController(sourceView: btnSuccess)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = transitionController
        present(vc, animated: true)
    }
    
    //MARK:- Optional method for cardview interaction
    @objc func nextVC(_ sender: Any)
    {
    }
}

