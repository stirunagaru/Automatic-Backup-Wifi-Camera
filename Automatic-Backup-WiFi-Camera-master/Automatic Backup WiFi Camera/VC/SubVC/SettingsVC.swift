//
//  SettingsVC.swift
//  Automatic Backup WiFi Camera
//
//  Created by Shivang Dave on 7/13/18.
//  Copyright © 2018 Shivang Dave. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    //MARK:- Outlets
    @IBOutlet weak var tblView : UITableView!
    let options = ["HELP","CONTACT US"]
    
    //MARK:- UIView methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    //MARK:- TableView Delegate and Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = options[indexPath.row]
        cell?.textLabel?.textColor = Theme.primaryColor
        cell?.textLabel?.font = Theme.menuFont
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //showSnack("\(indexPath.row)")
        
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "SubmitReportVC") as! SubmitReportVC
        vc.topTitle = options[indexPath.row]
        tblView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
