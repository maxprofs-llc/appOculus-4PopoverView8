 //
//  ExtGetJson.swift
//  appOculus
//
//  Created by Javier Cortes on 15/01/17.
//  Copyright © 2017 Javier Cortes. All rights reserved.
//

import Foundation

extension String {
    func getJson() -> NSArray {
        var json = NSArray()
        if let url = URL(string: self) {
            if let data = try? Data(contentsOf: url) {
                
                do {
                    
                    try json = JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                }
                catch{
                    print("No se puede deserializar el json")
                }
                //IMPORTANTE: Verificar el manejo de errores.
            }
        }
        return json
    }
}
