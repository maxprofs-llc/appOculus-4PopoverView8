//
//  cellPregunta.swift
//  appCargaCombo
//
//  Created by Nestor Guzman on 06/02/17.
//  Copyright © 2017 Javier Cortes. All rights reserved.
//

import UIKit

class cellPregunta: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var preguntaLabel: UILabel!
    @IBOutlet weak var ejemploLabel: UILabel!
    @IBOutlet weak var respuestaTextView: UITextView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.respuestaTextView.delegate = self
        self.respuestaTextView.layer.cornerRadius = 5
        self.respuestaTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.respuestaTextView.layer.borderWidth = 0.4
        self.respuestaTextView.clipsToBounds = true
        
        //self.preguntaLabel.sizeToFit()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
