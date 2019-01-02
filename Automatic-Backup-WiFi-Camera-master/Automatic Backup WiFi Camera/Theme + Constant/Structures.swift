//
//  Structures.swift
//  Automatic Backup WiFi Camera
//
//  Created by Shivang Dave on 7/6/18.
//  Copyright © 2018 Shivang Dave. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents

//MARK:- Structure for Device Orientations
struct AppUtility
{
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask)
    {
        if let delegate = UIApplication.shared.delegate as? AppDelegate
        {
            delegate.orientationLock = orientation
        }
    }
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation: UIInterfaceOrientation)
    {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
}

//MARK:- Structure for API URL(s)
struct API_URL
{
    static let baseurl = "http://10.3.141.1:3000/"
    static let token = baseurl + "connect"
    static let start = baseurl + "start"
    static let stop = baseurl + "stop"
    static let getTotalClients = baseurl + "totalClients"
    static let checkToken = baseurl + "checkToken"
}

//MARK:- Flip the theme, changes primary color to accent
struct FlipTheme
{
    static var primaryColor: UIColor  { return UIColor(red: 226.0/255, green: 46.0/255, blue: 106.0/255, alpha: 1.0) }
    static var accentColor: UIColor  { return UIColor(red: 59.0/255, green: 77.0/255, blue: 159.0/255, alpha: 1.0) }
}

//MARK:- Primary theme engine
struct Theme
{
    static var primaryColor: UIColor  { return UIColor(red: 59.0/255, green: 77.0/255, blue: 159.0/255, alpha: 1.0) }
    static var accentColor: UIColor  { return UIColor(red: 226.0/255, green: 46.0/255, blue: 106.0/255, alpha: 1.0) }
    
    static var primaryFont: UIFont {return UIFont(name: "Rubik-Medium", size: 20.0)!}
    static var primaryFontAlert: UIFont {return UIFont(name: "Rubik-Medium", size: 12.0)!}
    static var smallFont: UIFont {return UIFont(name: "Rubik-Regular", size: 17.0)!}
    static var buttonFont: UIFont {return UIFont(name: "Rubik-Regular", size: 20.0)!}
    static var menuFont: UIFont {return UIFont(name: "Rubik-Medium", size: 14.0)!}
    static var italicFont: UIFont {return UIFont.italicSystemFont(ofSize: 12.0)}
}

//MARK:- Tabbar items
struct tabItem
{
    static var item1: UITabBarItem {return UITabBarItem(title: "Home", image: UIImage(named: "ic_home_24_filled"), tag: 0)}
    static var item2: UITabBarItem {return UITabBarItem(title: "Settings", image: UIImage(named: "ic_settings_24_filled"), tag: 1)}
    static var item3: UITabBarItem {return UITabBarItem(title: "About", image: UIImage(named: "ic_about_24_filled"), tag: 2)}
}
