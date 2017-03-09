//
//  PreguntasVC.swift
//  appCargaCombo
//
//  Created by Nestor Guzman on 06/02/17.
//  Copyright © 2017 Javier Cortes. All rights reserved.
//

import UIKit

class PreguntasVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
        
    @IBOutlet weak var tableView: UITableView!

    var idEstacionamiento = ""
    var data: [(idPregunta: String, Pregunta: String, Sugerencia: String, Respuesta: String)] = []
    var keyboardHeight: CGFloat = 0
    var textEditing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.register(UINib(nibName: "cellPregunta", bundle: nil),  forCellReuseIdentifier: "cellPregunta")
        
        //Desde aqui hacemos la carga
        var json = NSArray()
        var index = 0
        
        json = "\(AppDelegate.Host)?par=8".getJson()
        
        if json.count == 0 {
            "No se tienen datos".showAlert(self)
            return
        } else if json.count == 1 && ((json.object(at: 0) as! NSDictionary)["Code"] as? Int)! > 0 {
            let datosJson = json.object(at: 0) as! NSDictionary
            var mensaje = ((datosJson["Mensaje"] as AnyObject).description)!
            
            if (datosJson["Code"] as? Int)! > 1 { mensaje = "❌ " + mensaje }
            mensaje.showAlert(self)
            return
        }
        
        repeat {
            let datosJson = json.object(at: index) as! NSDictionary
            data.append(((datosJson["IdPregunta"]! as AnyObject).description.trim(),(datosJson["Descripcion"]! as AnyObject).description.trim(), (datosJson["EjemploRespuesta"]! as AnyObject).description.trim(), ""))
            index += 1
        } while (index < json.count)

        
        
        tableView.estimatedRowHeight = 79
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        let touch = UITapGestureRecognizer(target: self, action: #selector(self.touches))
        self.tableView.addGestureRecognizer(touch)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        self.tableView.endEditing(true)
    }
    
    
    
    @IBAction func guardarButton(_ sender: Any) {
        var iConError = 0
        
        touches()
        
        //hacemos un primer recorrido para validar que esten todas las preguntas con captura de algo.
        for index1 in 0...data.count - 1 {
            if (data[index1].Respuesta == ""){
                "falta de completar todas las respuestas".showAlert(self)
                return
            }
        }
        
        for index in 0...data.count - 1 {
            
            //Aqui validamos si la respuesta no viene en blanco
            if (data[index].Respuesta != ""){
                //Registramos
                var jsonString = ""
                var json = NSArray()
                jsonString = AppDelegate.Host + "?par=9&par1=2&par2=\(idEstacionamiento)&par3=\(data[index].idPregunta)&par4=\(data[index].Respuesta)"
                jsonString = jsonString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!
                json = jsonString.getJson()
                
                if json.count > 0 {
                    let datosJson = json.object(at: 0) as! NSDictionary
                    if let codeError = datosJson["NoRegistros"] as? Int {
                        if codeError == 0 { iConError += 1 }
                    }
                }
                else {
                    iConError += 1
                }
            }
            
        }
        
        if iConError > 0 {
            "Ocurrieron algunos errores al registrar los datos".showAlert(self)
        } else {
            "Se registraron correctamente los datos".showAlert(self)
            //*****IMPORTANTE, AQUI TENDRIAMOS QUE MANDAR LA IMPRESION
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cellPregunta", for: indexPath) as! cellPregunta
        cell.preguntaLabel.text = data[indexPath.row].Pregunta + "    \(indexPath.row)"
        cell.preguntaLabel.numberOfLines = 0
        //cell.preguntaLabel.sizeToFit()
        
        if indexPath.row == 3 {
            cell.ejemploLabel.text = data[indexPath.row].Sugerencia //"Ej. Responder: jas jkkjas hdiuas uhdiua isahdoias hdiuas iuasus kasus ashudak kas kjsdu kjhdau"
            cell.ejemploLabel.numberOfLines = 0
        }
        
        cell.respuestaTextView.text = data[indexPath.row].Respuesta
        cell.respuestaTextView.tag = indexPath.row
        cell.respuestaTextView.delegate = self
        
        return cell
    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textEditing = true
        if self.keyboardHeight > 0 {
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.keyboardHeight, 0)
                let indexPath = IndexPath(row: textView.tag, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            })
        }
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let row = textView.tag
        let text = textView.text!
        
        self.data[row].Respuesta = text
        textEditing = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        })
        
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textEditing {
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
    
    
    
    func touches() {
        self.tableView.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            self.keyboardHeight = (keyboardHeight - 50)
            tableView.contentInset = UIEdgeInsetsMake(0, 0, self.keyboardHeight, 0)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
