//
//  HomeVC.swift
//  Automatic Backup WiFi Camera
//
//  Created by Shivang Dave on 7/6/18.
//  Copyright © 2018 Shivang Dave. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialBottomNavigation
import Alamofire
import NetworkExtension

class HomeVC: UIViewController, MDCBottomNavigationBarDelegate
{
    //MARK:- Outlets
    @IBOutlet weak var navBar : tabbar!
    @IBOutlet weak var videoButton : roundButtonHome!
    @IBOutlet weak var containerView : UIView!
    
    var currentVC : UIViewController?

    //MARK:- UIView methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navBar.delegate = self
        changeBar("HOME")
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        AppUtility.lockOrientation(.all, andRotateTo: .portrait)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        setupView()
        if nLaunch
        {
            streamSetup()
        }
        checkToken()
    }
    
    func setupView()
    {
        self.navigationItem.backBarButtonItem?.tintColor = .white
        currentVC = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewVC")
        setVC(currentVC!,0)
        NotificationCenter.default.addObserver(self, selector: #selector(startStream(_:)), name: .startStream, object: nil)
    }
    
    func addTestProp()
    {
        self.videoButton.isAccessibilityElement = true
        self.videoButton.accessibilityLabel = "btn3"
    }
    
    //MARK:- Start stream function call via notification
    @objc func startStream(_ notification:Notification)
    {
        showAlert()
    }
    
    //MARK:- send token if its not on the server
    func sendReq()
    {
        let data = ["token":appDelegate.token!]
        
        Alamofire.request(API_URL.token, method: .post, parameters: data, encoding: JSONEncoding.default, headers: nil).responseJSON(queue: DispatchQueue.main, options: []) { (res) in
            switch res.result
            {
                case .success(let json):
                    let dic = json as! NSDictionary
                    print(dic)
                
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    //MARK:- check for stored token on the server
    func checkToken()
    {
        Alamofire.request(API_URL.checkToken)
            .responseJSON { response in
                guard response.result.error == nil else {
                    print(response.result.error!)
                    return
                }
                guard let json = response.result.value as? [String: Any] else {
                    if let error = response.result.error {
                        print("Error: \(error)")
                    }
                    return
                }
                guard let todoTitle = json["token"] as? Bool else
                {
                    print("Could not get todo title from JSON")
                    return
                }
                if !todoTitle
                {
                    self.sendReq()
                }
            }
    }
    
    //MARK:- check for last received notification type
    func streamSetup()
    {
        if let noti = lastNote
        {
            let cat = noti["category"] as! Int
            
            switch cat
            {
                case 0:
                    showAlert()
                    break
                case 1:
                    showSnack("No active stream found!")
                    break
                default:
                    break
            }
        }
    }
    
    //MARK:- Ask for user permission to launch the stream
    func showAlert()
    {
        let alert = UIAlertController(title: "Confirm", message: "Do you want to start the video?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default) { (action) in
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "StreamVC") as! StreamVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let no = UIAlertAction(title: "No", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: {
                self.showSnack("Stream cancelled!")
            })
        }
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Launch camera stream manually
    @IBAction func cameraClicked(_ sender : Any)
    {
        if self.currentSSIDs().first == "Automatic Backup WiFi Camera"
        {
            pushIt("StreamVC")
        }
        else
        {
            #if arch(i386) || arch(x86_64)
            pushIt("StreamVC")
            #endif
            _ = connectWifi()
        }
    }
    
    //MARK:- Tabbar delegate
    func bottomNavigationBar(_ bottomNavigationBar: MDCBottomNavigationBar, didSelect item: UITabBarItem)
    {
        switch item.tag
        {
        case 0:
            setVC(mainStoryboard.instantiateViewController(withIdentifier: "HomeViewVC"),1)
            changeBar("HOME")
            break
            
        case 1:
            setVC(mainStoryboard.instantiateViewController(withIdentifier: "SettingsVC"),1)
            changeBar("SETTINGS")
            break
        case 2:
            showTips(navBar, videoButton, Theme.accentColor, "MENU OPTIONS", "Tap on the menu buttons to switch between Home, Settings & Tips.", "VIDEO FEED", "Tap on this button to trigger video feed manually.")
            break
        default:
            break
        }
    }
    
    //MARK:- Add / remove child VC from container view
    func setVC(_ vc : UIViewController, _ run : Int)
    {
        switch run
        {
            case 0:
                currentVC = vc
                self.addChild(vc)
                setViewSize(vc)
                break
            case 1:
                if currentVC!.restorationIdentifier != vc.restorationIdentifier
                {
                    removeVC(currentVC!)
                    currentVC = vc
                    self.addChild(vc)
                    setViewSize(vc)
                }
                break
            default:
                break
        }
    }
    
    //MARK:- Connect to WiFi
    func connectWifi()->Bool
    {
        var bool = false
        let ssid = "Automatic Backup WiFi Camera"
        let password = "ChangeMe"
        
        //MARK:- Only run this code if its not a simulator
        #if !arch(i386) && !arch(x86_64)
        let config = NEHotspotConfiguration(ssid: ssid, passphrase: password, isWEP: false)
        
        startAnimating(activityIndicator)
        
        NEHotspotConfigurationManager.shared.apply(config) { (error) in
            if error != nil
            {
                let desc = error?.localizedDescription.capitalized
                self.showSnack(desc ?? "")
                if desc == "Already Associated."
                {
                    bool = true
                    self.pushIt("StreamVC")
                }
                else
                {
                    bool = false
                    self.showSnack("Cannot find WiFi network!")
                }
                self.stopAnimating(activityIndicator)
            }
            else
            {
                if self.currentSSIDs().first == ssid
                {
                    bool = true
                    self.pushIt("StreamVC")
                }
                else
                {
                    self.showSnack("Couldn't find WiFi Network")
                    bool = false
                }
                self.stopAnimating(activityIndicator)
            }
            
        }
        #endif
        return bool
    }
    
    //MARK:- set view size inside container view
    func setViewSize(_ vc: UIViewController)
    {
        containerView.addSubview(vc.view)
        vc.view.frame = containerView.bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc.didMove(toParent: self)
    }
    
    //MARK:- navigate through VC on option selection
    func removeVC(_ vc : UIViewController)
    {
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
}
