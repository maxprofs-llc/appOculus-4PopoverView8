//
//  ApiHelper.swift
//  appCargaCombo
//
//  Created by Javier Cortes on 24/01/17.
//  Copyright © 2017 Javier Cortes. All rights reserved.
//

import Foundation
import UIKit


class ApiHelper {
    
    // MARK: - Comunes -
    class func getDataSucursales(_ tipoCon: Int, idPlaza: String = "") -> [(Value: String, Titulo: String)] {
        
        var jsonString = ""
        var json = NSArray()
        var index = 0
        var dataSucursales: [(Value: String, Titulo: String)] = []
        
        // Cargamos las sucursales
        //json = "http://desarrollo.dnsalias.net/website4/Default.aspx?par=10&par1=\(tipoCon)&par2=\(idPlaza)".getJson()
        jsonString = AppDelegate.Host + "?par1=7&par2=0"
        json = jsonString.getJson()
        
        
        if json.count > 0 {
            repeat {
                let datosJson = json.object(at: index) as! NSDictionary
                if let codeError = datosJson["NoError"] as? Int {
                    if codeError == 0 {
                        dataSucursales.append((Value: (datosJson["ID_ESTACIONAMIENTO"]! as AnyObject).description, Titulo: (datosJson["DESC_ESTACIONAMIENTO"]! as AnyObject).description))
                    }
                }
                index += 1
            } while (index < json.count)
        }
        
        return dataSucursales
    }
}
