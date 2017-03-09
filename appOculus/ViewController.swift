//
//  ViewController.swift
//  appCargaCombo
//
//  Created by Javier Cortes on 24/01/17.
//  Copyright © 2017 Javier Cortes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var lblCveEstacionamiento: UILabel!
    @IBOutlet weak var viewFiltros: UIView!
    @IBOutlet weak var PVSucursales: UITextField!
    @IBOutlet weak var lblEstacionamiento: UILabel!
    @IBOutlet weak var lblUbicacion: UILabel!
    @IBOutlet weak var lblUbiLon: UILabel!
    
    
    // MARK: - Variables -
    //let pg = ExtProgressBar()
    let docCellIdentifier = "cellDocumento"
    let datosCellIdentifier = "cellDatos"
    let checkCellIdentifier = "cellCheck"
    var dataPickerSuc: [(Value: String, Titulo: String)] = []
    var selectRowSuc: Int = 0
    
    @IBAction func btnBuscar(_ sender: Any) {
        //buscamos los
        lblEstacionamiento.text = PVSucursales.text
        
        //Buscamos el detalle de un estacionamiento
        let json = "\(AppDelegate.Host)?par1=7&par2=\(lblCveEstacionamiento.text!)".getJson()
        
        if json.count == 0 {
            "No se conecto a la base de datos".showAlert(self)
            return
        }
        
        
        let datojson1 = json.object(at: 0) as! NSDictionary
        let ErrorNo = (datojson1["NoError"]! as AnyObject).description
        
        if ErrorNo == "1"
        {
            "Ocurrio el siguiente error: \(datojson1["MensajeError"]!)".showAlert(self)
            return
        }
        
        lblEstacionamiento.text = "DIRECCIÓN: " + (datojson1["DIR_ESTACIONAMIENTO"]! as AnyObject).description
        lblUbicacion.text = "UBICACIÓN LAT.: " + (datojson1["UBI_LAT_ESTACIONAMIENTO"]! as AnyObject).description
        lblUbiLon.text = "UBICACIÓN LON.: " + (datojson1["UBI_LON_ESTACIONAMIENTO"]! as AnyObject).description
    
    }
    
    @IBAction func registraEncuestaButton(_ sender: Any) {
        if (PVSucursales.text?.isEmpty)! {
            "Favor de seleccionar el estacionamiento".showAlert(self)
            return
        }
        
        
        let preguntas = self.storyboard?.instantiateViewController(withIdentifier: "preguntasVC") as? PreguntasVC
        preguntas?.idEstacionamiento = lblCveEstacionamiento.text!  //self.dataPickerSuc[self.selectRowSuc].Value
        self.navigationController?.show(preguntas!, sender: nil)
    }
    
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.viewFiltros.layer.cornerRadius = 6
        self.cargaPickerView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // MARK: - Functions -
    func cargaPickerView() {
        let pickerViewSuc = UIPickerView()
        let donePicker = #selector(self.donePicker)
        let cancelPicker = #selector(self.cancelPicker)
        
        dataPickerSuc = ApiHelper.getDataSucursales(2)
        
        pickerViewSuc.delegate = self
        pickerViewSuc.reloadAllComponents()
        PVSucursales.inputView = pickerViewSuc
        PVSucursales.inputAccessoryView = UIToolbar().ToolBar("ESTACIONAMIENTOS", donePicker: donePicker, cancelPicker: cancelPicker)
    }
    
    func donePicker() {
        if self.dataPickerSuc.count == 0 {
            self.cancelPicker()
            return
        }
        
        let titulo = self.PVSucursales.text
        let tituloSel = self.dataPickerSuc[selectRowSuc].Titulo
        let claveSel = self.dataPickerSuc[selectRowSuc].Value
        
        self.lblCveEstacionamiento.text = claveSel
        self.PVSucursales.text = tituloSel
        if titulo != "" && titulo != tituloSel { self.limpiaDatos(false) }
        self.cancelPicker()
    }
    
    func cancelPicker() {
        self.PVSucursales.resignFirstResponder()
    }
    
    func limpiaDatos(_ Nuevo: Bool) {
        if Nuevo { self.PVSucursales.text = "" }
        //self.Documentos.removeAll()
        //self.collectionViewDatos.reloadData()
    }
    
}





// MARK: - PickerView Delegate (PROTOCOLO)
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataPickerSuc.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataPickerSuc[row].Titulo
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectRowSuc = row
    }
    
}

