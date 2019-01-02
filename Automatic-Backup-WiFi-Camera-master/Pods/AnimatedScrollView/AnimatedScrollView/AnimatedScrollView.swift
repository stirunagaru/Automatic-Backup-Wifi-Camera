//
//  AnimatedScroll.swift
//  SampleUI
//
//  Created by Shivang Dave on 6/23/18.
//  Copyright © 2018 Shivang Dave. All rights reserved.
//

import Foundation
import UIKit

public class AnimatedScrollView : UIScrollView
{
    var execute = true
    var max_w = CGFloat(0.0)
    
    var max_width_i: CGFloat?
    var max_height_i: CGFloat?
    var max_width_slider_i: CGFloat?
    
    public func animate(_ view: UIView, imageName: String, animated: Bool)
    {
        max_width_i = view.frame.width*2.0
        max_width_slider_i = view.frame.width*3.0
        max_height_i = view.frame.height
        
        //print(UIImage(named: imageName)!)
        _ = self.setView(UIImage(named: imageName+".jpg")!)
        
        if animated
        {
            self.animateChange(0.0,max_width_i!)
        }
    }
    
    public func setView(_ image: UIImage)->UIImageView
    {
        self.contentSize.width = max_width_slider_i!
        self.contentSize.height = max_height_i!
        
        let view1 = UIImageView(image: image)
        view1.frame = CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height)
        view1.alpha = 0.2
        view1.contentMode = .scaleAspectFill
        self.addSubview(view1)
        
        return view1
        
    }
    
    public func animateChange(_ x : CGFloat,_ max_width : CGFloat)
    {
        var current_x = x
        max_w = max_width
        
        if execute
        {
            if current_x != CGFloat(0.0)
            {
                while current_x > CGFloat(0.0)
                {
                    current_x -= CGFloat(10.0)
                    animate(current_x)
                }
                execute = false
            }
            else
            {
                while max_width > current_x
                {
                    current_x += CGFloat(10.0)
                    animate(current_x)
                }
            }
        }
    }
    
    public func animate(_ x: CGFloat)
    {
        UIView.animate(withDuration: 25, animations: {
            self.setContentOffset(CGPoint(x: x, y: 0.0), animated: false)
        })
        {(_) in
            self.animateChange(self.contentOffset.x,self.max_w)
        }
    }
}

