//
//  ExtShowAlert.swift
//  appOculus
//
//  Created by Javier Cortes on 15/01/17.
//  Copyright © 2017 Javier Cortes. All rights reserved.
//

import UIKit

extension String {
    func showAlert(_ view: UIViewController, title: String = "Cryxo App🍁", handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: self, preferredStyle: UIAlertControllerStyle.alert)
        
        //let action = UIAlertAction(title: "aceptar", style: UIAlertActionStyle.Default)
        let action = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(action)
        
        view.present(alert, animated: true, completion: nil)
    }
}

