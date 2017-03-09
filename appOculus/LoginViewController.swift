//
//  LoginViewController.swift
//  appOculus
//
//  Created by Javier Cortes on 15/01/17.
//  Copyright © 2017 Javier Cortes. All rights reserved.
//

import UIKit
import CoreLocation


var usuario: String = ""
var idtelefono: String = ""
var folio: String = ""
var fecha: String = ""
var noombreUsuario: String = ""
var FechaWS: String = ""
var idcalle: Int = 0
var idcolonia: Int = 0
var idmulta: Int = 0
var idmarca: Int = 0
var latitud: Double = 0.0
var longitud: Double = 0.0
var direccion: String = ""
var idtipo: Int = 0
var idlinea: Int = 0
var idcolor: Int = 0

public var imp_Folio: String = ""
public var imp_Placa: String = ""
public var imp_Entidad: String = ""
public var imp_Marca: String = ""
public var imp_Vehiculo: String = ""
public var imp_Color: String = ""
public var imp_Concepto: String = ""
public var imp_Sancion: String = ""
public var imp_Direccion: String = ""
public var imp_Parquimetro: String = ""
public var imp_Espacio: String = ""


var dispositivo: String = ""

class LoginViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnIngresar: UIButton!
    
    @IBOutlet weak var topConstraintTxtUsuario: NSLayoutConstraint!
//    @IBOutlet weak var topConstraintTxtPassword: NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        idtelefono = UIDevice.current.name.description
        

        

        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.NetMessage),
            name: Notification.Name("InternetConnectionStatus"),
            object: nil)
        
        self.txtUsuario.delegate = self;
        self.txtPassword.delegate = self;
        
//        btnIngresar.backgroundColor = .clear
        btnIngresar.layer.cornerRadius = 5
        btnIngresar.layer.borderWidth = 1
        btnIngresar.layer.borderColor = UIColor.black.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func NetMessage(notification: NSNotification) {
        let dic = notification.object as! NSDictionary
        let mensaje = dic["medium"] as! String
        mensaje.showAlert(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.topConstraintTxtUsuario.constant -= 90;
//        self.txtUsuario.frame.origin.y = self.view.frame.origin.y-130;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.topConstraintTxtUsuario.constant = 149;
//        self.txtUsuario.frame.origin.y = 0;
    }

    @IBAction func btnIngresarClic(_ sender: Any) {
        
        //Se tendria que validar que los datos esten correctos.
        
        var foliofor: String = ""
        
        if txtUsuario.text == ""{
            "Favor de capturar el usuario".showAlert(self)
            return
        }
        if txtPassword.text == "" {
            "Favor de capturar la contraseña".showAlert(self)
            return
        }
        
        
        idtelefono = UIDevice.current.name.description
        
        let json = "\(AppDelegate.Host)?par1=1&par2=\(txtUsuario.text!)&par3=\(txtPassword.text!)&par4=\(idtelefono)".getJson()
        
        if json.count == 0 {
            "No se conecto a la base de datos".showAlert(self)
            return
        }
        
        
        let datojson1 = json.object(at: 0) as! NSDictionary
        
        let ErrorNo = (datojson1["NoError"]! as AnyObject).description
        
        if ErrorNo == "1"
        {
            "Usuario o contraseña erroneos".showAlert(self)
            return
        }
        
        let user = (datojson1["Id_Usu"]! as AnyObject).description
        let disp = (datojson1["Id_Disp"]! as AnyObject).description
        let unombre = (datojson1["Nombre"]! as AnyObject).description        

        foliofor = "00" + user!

        usuario = foliofor.substring(from:foliofor.index(foliofor.endIndex, offsetBy: -3))
        
//        usuario = user!
        dispositivo = disp!
        noombreUsuario = unombre!
        
    }
        
}


