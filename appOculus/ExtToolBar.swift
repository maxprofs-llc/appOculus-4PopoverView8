//
//  ExtToolBar.swift
//  appCargaCombo
//
//  Created by Javier Cortes on 01/02/17.
//  Copyright © 2017 Javier Cortes. All rights reserved.
//

import UIKit

extension UIToolbar {
    
    func ToolBar(_ Title: String, donePicker: Selector, cancelPicker: Selector) -> UIToolbar {
        let toolBar = UIToolbar()
        var buttonStyle = UIBarButtonItemStyle(rawValue: 0)
        let lblTitle = UILabel()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.backgroundColor = UIColor.white
        toolBar.barTintColor = UIColor.gray
        toolBar.tintColor = UIColor.init(white: 1, alpha: 50)
        toolBar.sizeToFit()
        
        buttonStyle = UIBarButtonItemStyle.done
        
        lblTitle.frame = CGRect(x: 0, y: 0, width: toolBar.frame.width - 200, height: 15)
        lblTitle.text = Title
        lblTitle.textAlignment = NSTextAlignment.center
        lblTitle.backgroundColor = UIColor.clear
        lblTitle.textColor = UIColor.white
        lblTitle.font = UIFont.boldSystemFont(ofSize: lblTitle.font.pointSize-1)
        
        
        let doneButton = UIBarButtonItem(title: "Aceptar", style: buttonStyle!, target: nil, action: donePicker)
        let spaceLeft = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let title = UIBarButtonItem(customView: lblTitle)
        let spaceRigth = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: buttonStyle!, target: nil, action: cancelPicker)
        
        
        toolBar.setItems([cancelButton, spaceLeft, title, spaceRigth, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}
