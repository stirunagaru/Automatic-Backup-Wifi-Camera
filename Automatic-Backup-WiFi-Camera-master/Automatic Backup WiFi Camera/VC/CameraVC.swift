//
//  CameraVC.swift
//  Automatic Backup WiFi Camera
//
//  Created by Shivang Dave on 7/5/18.
//  Copyright © 2018 Shivang Dave. All rights reserved.
//

import UIKit
import AnimatedScrollView
import MaterialComponents

class CameraVC: UIViewController
{
    //MARK:- Outlets
    @IBOutlet weak var animatedScroll: AnimatedScrollView!
    @IBOutlet weak var cardBackView : cardView!
    @IBOutlet weak var cardView : cardView!
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var btnNext : roundButton!
    
    
    let url = NSURL(string: API_URL.start)
    var streamingController : MjpegStreamingController?
    
    //MARK:- UIView methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        AppUtility.lockOrientation(.portrait)
        setupView()
        addTestProp()
        streamingController = MjpegStreamingController(imageView: imgView)
        streamingController!.play(url: url! as URL)
    }
    
    func setupView()
    {
        animatedScroll.animate(self.view, imageName: "background", animated: true)
        animatedScroll.alpha = 0.3
        cardView.addTarget(self, action: #selector(nextVC(_:)), for: .touchUpInside)
        changeBar("CAMERA TEST")
    }
    
    func addTestProp()
    {
        self.btnNext.isAccessibilityElement = true
        self.btnNext.accessibilityLabel = "btn2"
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        streamingController!.stop()
    }
    
    //MARK:- Move to next VC
    @IBAction func btnSuccessClicked(_ sender: Any)
    {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "navigationController") as! navigationController
        let transitionController = MDCMaskedTransitionController(sourceView: sender as! roundButton)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = transitionController
        present(vc, animated: true)
    }
    
    //MARK:- Optional cardView tap method
    @objc func nextVC(_ sender: Any)
    {
    }
}
