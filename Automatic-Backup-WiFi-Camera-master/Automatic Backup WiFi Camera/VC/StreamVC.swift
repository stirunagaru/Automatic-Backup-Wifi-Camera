//
//  TempVC.swift
//  Automatic Backup WiFi Camera
//
//  Created by Shivang Dave on 7/7/18.
//  Copyright © 2018 Shivang Dave. All rights reserved.
//

import UIKit

class StreamVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var alertView : UIView!
    @IBOutlet weak var alertLabel : UILabel!
    @IBOutlet weak var btnRotate : UIButton!

    let url = NSURL(string: API_URL.start)
    var streamingController : MjpegStreamingController?
    var fullScreen = false
    var oldFrame: CGRect?
    
    //MARK:- UIView methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        AppUtility.lockOrientation(.all, andRotateTo: .landscapeRight)
        self.navigationItem.title = "STREAM"
        setAlert()
        play(imgView)
        setDate()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        nLaunch = false
        streamingController!.stop()
    }
    
    func setDate()
    {
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .long
        let str = dateFormatter.string(from: date)
        
        DispatchQueue.main.async{
            appDelegate.lastDate = str
            defaults.set(appDelegate.lastDate, forKey: "lastDate")
            defaults.synchronize()
        }
    }
    
    //MARK:- stop stream via remote notification
    @objc func stopStream(_ notification:Notification)
    {
        streamingController!.stop()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.popToRootViewController(animated: true)
        self.showSnack("Stream Finished!")
    }
    
    //MARK:- Show alert if device is in not in landscape orientation
    func setAlert()
    {
        if !UIDevice.current.orientation.isLandscape
        {
            btnRotate.isHidden = false
            alertLabel.isHidden = false
            alertView.isHidden = false
            
            alertLabel.font = Theme.smallFont
            alertLabel.textColor = Theme.primaryColor
            alertLabel.lineBreakMode = .byWordWrapping
            alertLabel.numberOfLines = 0
            alertLabel.text = "Switch to landscape mode to continue."
            
            self.btnRotate.isUserInteractionEnabled = false
            self.btnRotate.setBackgroundImage(UIImage(named: "ic_rotation_24_filled"), for: .normal)
            self.btnRotate.tintColor = Theme.accentColor
            self.btnRotate.rotate()
        }
        else
        {
            hideAlert()
        }
    }
    
    //MARK:- Hide alert
    func hideAlert()
    {
        alertView.isHidden = true
        alertLabel.isHidden = true
        btnRotate.isHidden = true
    }
    
    //MARK:- Check for change in orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape
        {
            hideAlert()
        }
        else
        {
            setAlert()
        }
    }
    
    //MARK:- Play function
    func play(_ imgView : UIImageView)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(stopStream(_:)), name: .stopStream, object: nil)
        streamingController = MjpegStreamingController(imageView: imgView)
        streamingController!.play(url: url! as URL)
    }
    
    //MARK:- Gesture recognizer for UIImageView Full screen
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer)
    {
        if !fullScreen
        {
            self.fullScreen = true
            
            let imageView = sender.view as! UIImageView
            oldFrame = imageView.frame
            imageView.frame = UIScreen.main.bounds
            imageView.backgroundColor = .black
            imageView.contentMode = .scaleToFill
            imageView.isUserInteractionEnabled = true
            self.navigationController?.isNavigationBarHidden = true
        }
        else
        {
            self.fullScreen = false
            let imageView = sender.view as! UIImageView
            imageView.frame = oldFrame!
            self.navigationController?.isNavigationBarHidden = false
        }
    }
}
