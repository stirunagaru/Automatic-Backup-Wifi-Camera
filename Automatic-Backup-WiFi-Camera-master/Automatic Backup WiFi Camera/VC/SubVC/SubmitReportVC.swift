//
//  SubmitReportVC.swift
//  Automatic Backup WiFi Camera
//
//  Created by Shivang Dave on 7/13/18.
//  Copyright © 2018 Shivang Dave. All rights reserved.
//

import UIKit
import MaterialComponents.MDCMultilineTextField

class SubmitReportVC: UIViewController, UITextViewDelegate
{
    //MARK:- Outlets
    @IBOutlet weak var fullName : floatText!
    @IBOutlet weak var email : floatText!
    @IBOutlet weak var Message : floatText!
    @IBOutlet weak var btnSubmit : roundButtonHome!
    
    var controller : MDCTextInputControllerUnderline?
    var topTitle = ""
    
    //MARK:- Show message and Move to parent VC
    @IBAction func btnSuccessClicked(_ sender: roundButtonHome)
    {
        if validation()
        {
            showSnack("Message sent successfully.")
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            showSnack("Please make sure fields aren't empty!")
        }
    }
    
    //MARK:- Validate textfields & check if they are empty or not
    func validation()->Bool
    {
        var success = false
        if fullName.textView?.text != "" && email.textView?.text != "" && Message.textView?.text != ""
        {
            success = true
        }
        return success
    }
    
    //MARK:- UIView methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.title = topTitle
        
        hideKeyboardWhenTappedAround()
        
        fullName.textView?.tag = 1
        email.textView?.tag = 2
        Message.textView?.tag = 3
        
        fullName.textView?.delegate = self
        email.textView?.delegate = self
        Message.textView?.delegate = self
    }
    
    //MARK:- UITextView Delegate method
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        switch textView.tag
        {
            case 1:
                controller = MDCTextInputControllerUnderline(textInput:fullName)
                break
            case 2:
                controller = MDCTextInputControllerUnderline(textInput:email)
                break
            case 3:
                controller = MDCTextInputControllerUnderline(textInput:Message)
            default:
                break
        }
    }
    
}
