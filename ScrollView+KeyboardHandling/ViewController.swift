//
//  ViewController.swift
//  ScrollView+KeyboardHandling
//
//  Created by Meenal Kewat on 4/8/19.
//  Copyright © 2019 Meenal. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var constraintsContentHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fieldOne: UITextField!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var fieldTwo: UITextField!
    @IBOutlet weak var fieldThree: UITextField!
    
    var activeField: UITextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //set textfield delegate
        fieldOne.delegate = self
        fieldTwo.delegate = self
        fieldThree.delegate = self
        
        //Observe Keyboard changes
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //Add touch gesture for contentView
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
    }
    
    
    @objc func returnTextView(gesture: UIGestureRecognizer){
        guard activeField != nil else{
            return
        }
        activeField?.resignFirstResponder()
        activeField = nil
    }
    
    
    
    @objc func keyboardWillShow(notification: NSNotification){
        if keyboardHeight != nil{
            return
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            
            keyboardHeight = keyboardSize.height
            
            // So increase the content view height by keyboard height
            UIView.animate(withDuration: 0.3, animations: {
                self.constraintsContentHeight.constant += self.keyboardHeight
                })
            
            //move if keyboard hide input field
            let  distanceToBottom = self.scrollView.frame.size.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
                
                let collaspeSpace = keyboardHeight - distanceToBottom
            
            if collaspeSpace < 0 {
                //no collaspe
                return
            }
            
            //set new offset from scroll view
            UIView.animate(withDuration: 0.3, animations: {
                 // scroll to the position above keyboard 10 points
                self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collaspeSpace + 10)
            })
            
            
        }
    }
    
    @objc func keyBoardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.3) {
            self.constraintsContentHeight.constant -= self.keyboardHeight
            self.scrollView.contentOffset = self.lastOffset
        }
        keyboardHeight = nil
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }


}

