//
//  AppDelegate.swift
//  Automatic Backup WiFi Camera
//
//  Created by Shivang Dave on 7/4/18.
//  Copyright © 2018 Shivang Dave. All rights reserved.
//

import UIKit
import UserNotifications

var lastNote : [String : AnyObject]?
var nLaunch = false
let defaults = UserDefaults.standard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var token : String?
    var orientationLock = UIInterfaceOrientationMask.all
    var lastDate : String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        //MARK:- Store and access token
        token = defaults.object(forKey:"token") as? String
        lastDate = defaults.string(forKey: "lastDate")
        
        //MARK:- Reset badge count on launch
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        //MARK:- Check for launch options
        if launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil
        {
            if let remoteNotification = launchOptions?[.remoteNotification] as?  [AnyHashable : Any]
            {
                lastNote = remoteNotification["aps"] as? [String:AnyObject]
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "navigationController")
                self.window?.rootViewController = vc
                nLaunch = true
            }
        }
        else
        {
            if token != nil
            {
                nLaunch = false
                print(token ?? "")
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "navigationController")
                self.window?.rootViewController = vc
            }
            else
            {
                nLaunch = false
                UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
                application.registerForRemoteNotifications()
            }
        }
        
        return true
    }
    
    //MARK:- Change supported Orientations throughout the app
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        return self.orientationLock
    }
    
    //MARK:- Register for remote notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        token = deviceToken.hexString
        defaults.set(token, forKey: "token")
        print(token!)
    }

    //MARK:- Receive remote notifications and post local notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        let aps = userInfo["aps"] as! [String : AnyObject]
        if let cat = aps["category"] as? Int
        {
            switch cat
            {
                case 0:
                    NotificationCenter.default.post(name: .startStream, object: nil)
                    break
                case 1:
                    NotificationCenter.default.post(name: .stopStream, object: nil)
                    break
                default:
                    break
            }
        }
    }
    
    //MARK:- Unused App States
    func applicationWillResignActive(_ application: UIApplication)
    {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication)
    {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication)
    {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication)
    {
        
    }

    func applicationWillTerminate(_ application: UIApplication)
    {
        
    }
}

