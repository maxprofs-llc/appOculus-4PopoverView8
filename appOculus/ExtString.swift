//
//  ExtString.swift
//  appCargaCombo
//
//  Created by Javier Cortes on 08/03/17.
//  Copyright © 2017 Javier Cortes. All rights reserved.
//

import UIKit

extension String {
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    var twoFractionDigits: String {
        let styler = NumberFormatter()
        styler.minimumFractionDigits = 2
        styler.maximumFractionDigits = 2
        styler.numberStyle = .currency
        
        let converter = NumberFormatter()
        converter.decimalSeparator = "."
        
        if let result = converter.number(from: self) {
            return styler.string(from: result)!
        }
        return ""
    }
    
    func formatNumber(_ Digits: Int? = 0, Style: NumberFormatter.Style? = NumberFormatter.Style.none) -> String {
        let styler = NumberFormatter()
        styler.minimumFractionDigits = Digits!
        styler.maximumFractionDigits = Digits!
        styler.numberStyle = Style!
        
        let converter = NumberFormatter()
        converter.decimalSeparator = "."
        //converter.groupingSeparator = ","
        
        if let result = converter.number(from: self) {
            return styler.string(from: result)!
        }
        return ""
    }
    
    func ToDateMediumString() -> Date? {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        if let date = formatter.date(from: self) {
            return date
        }
        
        return nil
    }
    
    func formatDate(_ formato: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = formato
        let dateString = dateFormatter.date(from: self)
        
        return dateString
    }
    
    func stringByEncodingCharacters() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!
    }
    
    
    
}
