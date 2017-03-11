//
//  MultaViewController.swift
//  appOculus
//
//  Created by Desarrollo Cryxo on 16/01/17.
//  Copyright © 2017 Javier Cortes. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import MobileCoreServices

class MultaViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var txtFolio: UITextField!
    @IBOutlet weak var txtPlaca: UITextField!
    @IBOutlet weak var txtMarca: UITextField!
    @IBOutlet weak var txtVehiculo: UITextField!
    @IBOutlet weak var txtColor: UITextField!
    @IBOutlet weak var txtEntidad: UITextField!
    @IBOutlet weak var txtDireccion: UITextField!
    @IBOutlet weak var txtCalle: UITextField!
    @IBOutlet weak var txtColonia: UITextField!
    @IBOutlet weak var txtClave: UITextField!
    @IBOutlet weak var txtConcepto: UITextView!
    @IBOutlet weak var txtSancion: UITextField!
    @IBOutlet weak var txtParquimetro: UITextField!
    @IBOutlet weak var txtEspacio: UITextField!
    
    @IBOutlet weak var lblParquimetro: UILabel!
    @IBOutlet weak var fotoView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var btnRegresar: UIButton!
    @IBOutlet weak var ObtenerUbic: UIButton!
    @IBOutlet weak var btnEnviar: UIButton!
    @IBOutlet weak var btnImprimir: UIButton!
    
//    @IBOutlet weak var pickerViewMarca: UIPickerView!
//    @IBOutlet weak var pickerViewEstado: UIPickerView!
//    @IBOutlet weak var pickerViewClave: UIPickerView!
    
    @IBOutlet weak var scrollViewFotos: UIScrollView!
    
    var tablaViewController = TablaViewController()
//    var popover:UIPopoverController?    = nil
    
    let manager = CLLocationManager()
    var newMedia: Bool?
    var calle: String = ""
    var colonia: String = ""
    var UltimoFolio: String = ""
    
    var dbObjectInfracciones = [NSManagedObject]()
    var dbObjectMarcas = [NSManagedObject]()
    var dbObjectEstados = [NSManagedObject]()
    var dbObjectMultas = [NSManagedObject]()
    var dbObjectCalles = [NSManagedObject]()
    var dbObjectColonias = [NSManagedObject]()
    var dbObjectColores = [NSManagedObject]()
    
    var imageView1: UIImageView!
    var imageView2: UIImageView!
    var imageView3: UIImageView!
    
    var passedValue: String = ""
    var idCalle: Int = 0
    
    var tengoCalle: Bool = false
    var tengoColonia: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFolio.text = NuevoFolio()
        
        UserDefaults.standard.setValue(txtFolio.text, forKey: "imp_Folio")
    
        self.lblParquimetro.isHidden = true
        self.txtParquimetro.isHidden = true
        self.txtEspacio.isHidden = true
        
//        self.pickerViewMarca.isHidden = true
//        self.pickerViewEstado.isHidden = true
//        self.pickerViewClave.isHidden = true
        
        self.btnEnviar.isEnabled = false
        self.btnEnviar.alpha = 0.5;
        
        self.btnImprimir.isEnabled = false
        self.btnImprimir.alpha = 0.5;
        
        self.btnRegresar.isEnabled = false
        self.btnRegresar.alpha = 0.5;
        
        self.ObtenerUbic.isEnabled = true
        self.ObtenerUbic.alpha = 1.0
        
        btnEnviar.layer.cornerRadius = 5
        btnEnviar.layer.borderWidth = 1
        btnEnviar.layer.borderColor = UIColor.gray.cgColor
        
        btnImprimir.layer.cornerRadius = 5
        btnImprimir.layer.borderWidth = 1
        btnImprimir.layer.borderColor = UIColor.gray.cgColor
        
        btnRegresar.layer.cornerRadius = 5
        btnRegresar.layer.borderWidth = 1
        btnRegresar.layer.borderColor = UIColor.gray.cgColor

        ObtenerUbic.layer.cornerRadius = 5
        ObtenerUbic.layer.borderWidth = 1
        ObtenerUbic.layer.borderColor = UIColor.gray.cgColor
    
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MultaViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        //Metodos para agregar las fotos al scrollview
        //***************************************************************************
        self.view.layoutIfNeeded()
        
        let scrollWidth =  self.scrollViewFotos.frame.size.width
        let scrollHeight =  self.scrollViewFotos.frame.size.height
        
        imageView1 = UIImageView(image: UIImage(named: "imagenVacia.png"))
        imageView1.frame = CGRect(x: 0, y: 0, width: scrollWidth, height: scrollHeight)
        
        imageView2 = UIImageView(image: UIImage(named: "imagenVacia.png"))
        imageView2.frame = CGRect(x: 300, y: 0, width: scrollWidth, height: scrollHeight)
        
        imageView3 = UIImageView(image: UIImage(named: "imagenVacia.png"))
        imageView3.frame = CGRect(x: 600, y: 0, width: scrollWidth, height: scrollHeight)
        
        let contentSize = CGSize(width: scrollWidth * 3, height: scrollHeight)
        
//        // INICIAMOS GEOLOCALIZACION
//        manager.delegate = self
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//        manager.requestAlwaysAuthorization()
//        manager.startUpdatingLocation()
        
//        scrollView = UIScrollView(frame: frame)
//        scrollViewFotos.delegate = self
//        scrollViewFotos.backgroundColor = UIColor.clear
        scrollViewFotos.contentSize = contentSize
        scrollViewFotos.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        scrollViewFotos.addSubview(imageView1)
        scrollViewFotos.addSubview(imageView2)
        scrollViewFotos.addSubview(imageView3)
//        view.addSubview(scrollViewFotos)
        
        //Para poner la foto por default en el indice 1
        let instanceOfCustomObject: CustomObject = CustomObject()
        instanceOfCustomObject.someMethod(Int32(1))
        
        //***************************************************************************
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.addFotoNotification),
            name: Notification.Name("addFotoNotification"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.setValueForPopOver),
            name: Notification.Name("setValueForPopOver"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.UpdateFotos),
            name: Notification.Name("UpdateFotos"),
            object: nil)



    }
    
    func isInternetAvalible()-> Bool
    {
        let reachability = Reachability.self .forInternetConnection()
        let internetStatus = reachability?.currentReachabilityStatus()
        if internetStatus != NotReachable {
            GisInternetAvaliable = true
            return true
        }
        GisInternetAvaliable = false
        return false
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.isInternetAvalible()
        
        //Para mover el scrollview a la primera foto
        let offset = CGPoint(x: scrollViewFotos.bounds.size.width * 0, y: 0)
        scrollViewFotos.setContentOffset(offset, animated: true)
        
        //1
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "INF_Infracciones")
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            dbObjectInfracciones = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
//        self.pickerViewMarca.reloadAllComponents()
//        self.pickerViewEstado.reloadAllComponents()
//        self.pickerViewClave.reloadAllComponents()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
      
    }
    
    func addFotoToScrollView(nameFoto: String, idFoto: Int){
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        
        let getImagePath = paths.appendingPathComponent(nameFoto)
        
        if  (UIImage(contentsOfFile: getImagePath) != nil)
        {
            switch idFoto {
            case 1:
                fotoView.image = UIImage(contentsOfFile: getImagePath)
                imageView1.image = UIImage(contentsOfFile: getImagePath)
            case 2:
                imageView2.image = UIImage(contentsOfFile: getImagePath)
            case 3:
                imageView3.image = UIImage(contentsOfFile: getImagePath)
            default:
                print("El id no existe")
            }
            
        }

    }
    
    @objc func addFotoNotification(notification: NSNotification) {
        let dic = notification.object as! NSDictionary
        let idTag = dic["idFoto"] as! Int
//        let strId: String = idTag as! String
        let strId = String(idTag)
        
        let nameImageAdded = txtFolio.text! + "-\(strId).jpg"
        
        print(nameImageAdded)

//        self.addFotoToScrollView(nameFoto: nameImageAdded, idFoto: dic["idFoto"] as! Int)

    }
    
    @objc func setValueForPopOver(notification: NSNotification) {
        let dic = notification.object as! NSDictionary
        let idTag = dic["textFieldTag"] as! String
        let cellSelected = dic["cellSelected"] as! Int
        passedValue = dic["txtSelected"] as! String
        
        if idTag == "1"
        {
            txtMarca.text = passedValue
        }
        else if idTag == "2"
        {
            txtEntidad.text = passedValue
        }
        else if idTag == "3"
        {
            txtClave.text = passedValue
            
            let rowSelected: Int = Int(passedValue)!-1
            
            self.txtConcepto.text = dbObjectInfracciones[rowSelected].value(forKey:"inf_Concepto") as? String
            
            let myFloat: Float = (dbObjectInfracciones[rowSelected].value(forKey:"inf_Sancion") as? Float)!
            let myStringToTwoDecimals = String(format:"%.2f", myFloat)
            self.txtSancion.text = myStringToTwoDecimals
            self.txtSancion.backgroundColor = UIColor(red: 194/255.0, green: 255/255.0, blue: 183/255.0, alpha: 1.0)
            
            if self.txtClave.text == "1" {
                self.lblParquimetro.isHidden = false
                self.txtParquimetro.isHidden = false
                self.txtEspacio.isHidden = false
            }
            else {
                self.lblParquimetro.isHidden = true
                self.txtParquimetro.isHidden = true
                self.txtEspacio.isHidden = true
                
                self.txtParquimetro.text = ""
            }
        }
        else if idTag == "4"
        {
            txtEspacio.text = passedValue
        }
        else if idTag == "5"
        {
            txtCalle.text = passedValue
            txtDireccion.text = passedValue + ", " + txtColonia.text!
            tengoCalle = true
            
            
            if getIdCalle(calleSelected: passedValue) != idCalle
            {
                idCalle = getIdCalle(calleSelected: passedValue)
                txtParquimetro.text = ""
            }
        }
        else if idTag == "6"
        {
            txtColonia.text = passedValue
            txtDireccion.text = txtCalle.text! + ", " + passedValue
            tengoColonia = true

            idcolonia = getIdColonia(coloniaSelected: passedValue)
        }
        else if idTag == "7"
        {
            txtParquimetro.text = passedValue
            
        }
        else if idTag == "8"
        {
            txtColor.text = passedValue
            idcolor = getIdColor(colorSelected: passedValue)
        }
        else if idTag == "9"
        {
            txtVehiculo.text = passedValue
            idtipo = getIdTipo(TipoSelected: passedValue)
        }


        print(passedValue)
    }
    
    @objc func UpdateFotos(notification: NSNotification) {
        let nameImage1 = txtFolio.text! + "-1.jpg"
        let nameImage2 = txtFolio.text! + "-2.jpg"
        let nameImage3 = txtFolio.text! + "-3.jpg"
        
        self.addFotoToScrollView(nameFoto: nameImage1, idFoto: 1)
        self.addFotoToScrollView(nameFoto: nameImage2, idFoto: 2)
        self.addFotoToScrollView(nameFoto: nameImage3, idFoto: 3)

    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        for view in self.view.subviews {
            if view is UIPickerView {
                view.resignFirstResponder()
            }
            if view is UITextField {
                view.resignFirstResponder()
            }
        }
        view.endEditing(true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        targetContentOffset.pointee = scrollView.contentOffset
        
//        let pageWidth = Float(100)
//        let currentOffset = Float(scrollView.contentOffset.x)
//        let targetOffset = Float(targetContentOffset.pointee.x)
//        var newTargetOffset = Float(0)
//        var scrollViewWidth = Float(scrollView.contentSize.width)
//        
//        if targetOffset > currentOffset {
//            newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth
//        } else {
//            newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth
//        }
//        
//        if newTargetOffset < 0 {
//            newTargetOffset = 0
//        } else if newTargetOffset > currentOffset {
//            newTargetOffset = currentOffset
//        }
//        
//        targetContentOffset.pointee.x = CGFloat(currentOffset)
//        
//        let point = CGPoint(x: Int(newTargetOffset), y: 0)
//        
//        scrollView.setContentOffset(point, animated: true)
        
        
        //This is the index of the "page" that we will be landing at
        let nearestIndex = Int(CGFloat(targetContentOffset.pointee.x) / scrollView.bounds.size.width + 0.5)
        
        //Just to make sure we don't scroll past your content
        let clampedIndex = max( min( nearestIndex, 3 - 1 ), 0 )
        
        //This is the actual x position in the scroll view
        var xOffset = CGFloat(clampedIndex) * scrollView.bounds.size.width
        
        //I've found that scroll views will "stick" unless this is done
        xOffset = xOffset == 0.0 ? 1.0 : xOffset
        
        //Tell the scroll view to land on our page
        targetContentOffset.pointee.x = xOffset
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if !decelerate
        {
            
            let currentIndex = floor(scrollView.contentOffset.x / scrollView.bounds.size.width)
            
            print(currentIndex)
            
            let offset = CGPoint(x: scrollView.bounds.size.width * currentIndex, y: 0)
            
            scrollView.setContentOffset(offset, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = floor(scrollView.contentOffset.x / scrollView.bounds.size.width)
        
        let instanceOfCustomObject: CustomObject = CustomObject()
        instanceOfCustomObject.someProperty = "Hola"
        instanceOfCustomObject.someMethod(Int32(currentIndex+1))
        
        print(currentIndex)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            
            // Primero obtenemos las coordenadas que se guardaran en el servidor
            latitud = location.coordinate.latitude
            longitud = location.coordinate.longitude
            print("Found user's location: \(location)")
            manager.stopUpdatingLocation()
            
//            var isoCountryCode: String = ""
//            var country: String = ""
//            var postalCode: String = ""
//            var administrativeArea: String = ""
//            var locality: String = ""
//            var subLocality: String = ""
//            var thoroughfare: String = ""
//            var subThoroughfare: String = ""

            let json = "\(AppDelegate.Host)?par1=12&par2=\(latitud)&par3=\(longitud)".getJson()
            
            if json.count == 0 {
//                "No se pudo obtener ubicacion".showAlert(self)
                return
            }
            
            
            let datojson1 = json.object(at: 0) as! NSDictionary
            
            let ErrorNo = (datojson1["NoError"]! as AnyObject).description
            
            if ErrorNo == "1"
            {
 //               "Latitud/Longitur erroneas".showAlert(self)
                return
            }
            
            calle = ((datojson1["Calle"]! as AnyObject).description).replacingOccurrences(of: "Calle ", with: "").uppercased()
            
            colonia = (datojson1["Colonia"]! as AnyObject).description.uppercased()
            
            direccion = calle + ", " + colonia
            print(direccion)
            
            self.txtDireccion.text = direccion
            
            if self.calle != ""
            {
                self.tengoCalle = true;
            }
            if self.colonia != ""
            {
                self.tengoColonia = true;
            }
            
            txtCalle.text = ""
            txtColonia.text = ""
//            self.ObtenerUbic.isEnabled = false
//            self.ObtenerUbic.alpha = 0.5
//            
            return
            
            // DETENEMOS LA GEOLOCALIZACION


//            // Ahora obtenermos la dirección por geolocalizacion inversa
//            CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler:
//                {(placemarks, error) in
//                    if (error != nil)
//                    {
//                        print("reverse geodcode fail: \(error?.localizedDescription)")
//                    }
//                    if (placemarks?.count)! > 0 {
//                        let pm = (placemarks?[0])! as CLPlacemark
//                        
//                        // Codigo pais
//                        isoCountryCode = pm.isoCountryCode!
//                        // Pais
//                        country = pm.country!
//                        // Codigo postal
//                        postalCode = pm.postalCode!
//                        // Estado abreviado
//                        administrativeArea = pm.administrativeArea!
//                        // En teoria municipio
//                        locality = pm.locality!
//                        // Colonia
//                        subLocality = pm.subLocality!
//                        // Calle
//                        thoroughfare = pm.thoroughfare!
//                        // Numero
//                        subThoroughfare = pm.subThoroughfare!
//                        
//                        direccion = thoroughfare.replacingOccurrences(of: "Calle ", with: "").uppercased()
////                        direccion += ", " + subLocality.uppercased()
//                        
//                        print(direccion)
//                        self.txtDireccion.text = direccion
//                        self.calle = thoroughfare.replacingOccurrences(of: "Calle ", with: "").uppercased()
//                        self.colonia = subLocality.uppercased()
//                        self.colonia = "ZAPOPAN"
//                        
//                        if self.calle != "" && self.colonia != ""
//                        {
//                            self.tengoCalleColonia = true;
//                        }
//                        print(self.calle)
//                        print(self.colonia)
//                        
//                        self.ObtenerUbic.isEnabled = false
//                        self.ObtenerUbic.alpha = 0.5
//                       
//                    }
//            })
//        
        }
    }
    
    @IBAction func Ubicar(_ sender: Any) {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            manager.distanceFilter = 5
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    @IBAction func OpenImprimir(_ sender: UIButton)
    {
        //Se tendria que validar que los datos esten correctos.
        
        // Actualizamos la ubicacion
        if GisInternetAvaliable.boolValue
        {
            ActualizaUbicacion()
        }
        
        if txtPlaca.text == "" {
            "Favor de capturar la Placa del Auto".showAlert(self)
            return
        }
        if txtMarca.text == "" || txtColor.text == "" {
            "Favor de capturar marca y color del Auto".showAlert(self)
            return
        }
        if txtClave.text == "" {
            "Favor de seleccionar una clave de infracción".showAlert(self)
            return
        }
        if txtClave.text == "1" {
            if txtParquimetro.text == "" || txtEspacio.text == "" {
                "Favor de capturar todos los datos del parquimetro".showAlert(self)
                return
            }
        }
  
        imp_Folio = txtFolio.text!.uppercased()
        imp_Placa = txtPlaca.text!.uppercased()
        imp_Entidad = txtEntidad.text!.uppercased()
        imp_Marca = txtMarca.text!.uppercased()
        imp_Vehiculo = txtVehiculo.text!.uppercased()
        imp_Color = txtColor.text!.uppercased()
        imp_Concepto = txtConcepto.text!.uppercased()
        imp_Sancion = txtSancion.text!.uppercased()
        imp_Direccion = txtDireccion.text!.uppercased()
        imp_Parquimetro = txtParquimetro.text!.uppercased()
        imp_Espacio = txtEspacio.text!.uppercased()
        
        UserDefaults.standard.setValue(imp_Folio, forKey: "imp_Folio")
        UserDefaults.standard.setValue(imp_Placa, forKey: "imp_Placa")
        UserDefaults.standard.setValue(imp_Entidad, forKey: "imp_Entidad")
        UserDefaults.standard.setValue(imp_Marca, forKey: "imp_Marca")
        UserDefaults.standard.setValue(imp_Vehiculo, forKey: "imp_Vehiculo")
        UserDefaults.standard.setValue(imp_Color, forKey: "imp_Color")
        UserDefaults.standard.setValue(imp_Concepto, forKey: "imp_Concepto")
        UserDefaults.standard.setValue(imp_Sancion, forKey: "imp_Sancion")
        UserDefaults.standard.setValue(imp_Direccion, forKey: "imp_Direccion")
        UserDefaults.standard.setValue(imp_Parquimetro, forKey: "imp_Parquimetro")
        UserDefaults.standard.setValue(imp_Espacio, forKey: "imp_Espacio")
        UserDefaults.standard.setValue(noombreUsuario, forKey: "nombreUsuario")
        UserDefaults.standard.setValue(fecha, forKey: "fecha")
        UserDefaults.standard.setValue(usuario, forKey: "usuario")
        print(fecha)
        
        if (imageIsNullOrNot(imageName: fotoView.image!))
        {
            self.btnRegresar.isEnabled = true
            self.btnRegresar.alpha = 1.0;
            
            contentView.isHidden = false
            
            let controller = storyboard?.instantiateViewController(withIdentifier: "imprimirView")
//            let controller = storyboard?.instantiateViewController(withIdentifier: "CPLC_PrintView")
            addChildViewController(controller!)
            controller?.view.frame = contentView.bounds
            view.addSubview((controller?.view)!)
            controller?.didMove(toParentViewController: self)

        }
        else{
            "Favor de capturar una fotografia como evidencia".showAlert(self)
            return
        }
        
    }
    
    @IBAction func OpenTomarFoto(_ sender: UIButton)
    {
//        clearTempFolder()
        
        // Actualizamos la ubicacion
        if GisInternetAvaliable.boolValue
        {
            ActualizaUbicacion()
        }


        self.btnEnviar.isEnabled = true
        self.btnEnviar.alpha = 1.0;
        
        if false
        {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
                
                newMedia = true
            }
        }
        else
        {
            contentView.isHidden = false
            
            let controller = storyboard?.instantiateViewController(withIdentifier: "tomarFotoView")
            addChildViewController(controller!)
            controller?.view.frame = contentView.bounds
            view.addSubview((controller?.view)!)
            controller?.didMove(toParentViewController: self)
            
            
//            self.view.bringSubview(toFront: contentView)
//            let fotosVC = (self.storyboard?.instantiateViewController(withIdentifier: "tomarFotoView"))! as! TomarFotoViewController
//            self.present(fotosVC, animated: true, completion: nil)
//            fotosVC.view.frame = CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: 500)
            
//            fotosVC.view.frame = contentView.bounds
//            contentView.addSubview(fotosVC.view)

        }
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if pickerView.tag == 0 {
            if dbObjectInfracciones.count != 0 {
                return dbObjectInfracciones.count
            }
        }
        else if pickerView.tag == 1 {
            if dbObjectMarcas.count != 0 {
                return dbObjectMarcas.count
            }
        }
        else if pickerView.tag == 2 {
            if dbObjectEstados.count != 0 {
                return dbObjectEstados.count
            }
        }

        return 0
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        
        if pickerView.tag == 0 {
            if dbObjectInfracciones.count != 0
            {
                return dbObjectInfracciones[row].value(forKey:"inf_Clave") as? String
            }
        }

        else if pickerView.tag == 1 {
                if dbObjectMarcas.count != 0
                {
                    return dbObjectMarcas[row].value(forKey:"mar_Nombre") as? String
                }
        }
        else if pickerView.tag == 2 {
            if dbObjectEstados.count != 0
            {
                return dbObjectEstados[row].value(forKey:"edo_Nombre") as? String
            }
        }

        return "No hay Datos en la tabla"
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.txtMarca {

            addPopover(sender: self.txtMarca)
            return false
        }
        else if textField == self.txtColor {
            
            addPopover(sender: self.txtColor)
            return false
        }

        else if textField == self.txtEntidad {
            
            addPopover(sender: self.txtEntidad)
            return false
        }
        else if textField == self.txtCalle {
            
            addPopover(sender: self.txtCalle)
            tengoCalle = false
            return false
        }
        else if textField == self.txtColonia {
            
            addPopover(sender: self.txtColonia)
            tengoColonia = false
            return false
        }
        else if textField == self.txtClave {
            
            addPopover(sender: self.txtClave)
            return false
        }
        else if textField == self.txtEspacio {
            
            addPopover(sender: self.txtEspacio)
            return false
        }
        else if textField == self.txtParquimetro {
            
            addPopover(sender: self.txtParquimetro)
            return false
        }
        else if textField == self.txtDireccion {
            
            tengoCalle = false
            tengoColonia = false
        }
        else if textField == self.txtVehiculo {
            
            addPopover(sender: self.txtVehiculo)
            return false
        }



        else{
//            self.pickerViewMarca.isHidden = true
//            self.pickerViewEstado.isHidden = true
//            self.pickerViewClave.isHidden = true
        }

        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.txtClave {
            //Con el POPOVERVIEW aqui ya jamas va a entrar
//            self.pickerViewClave.isHidden = false
//            self.pickerViewMarca.isHidden = true
//            self.pickerViewEstado.isHidden = true
//            
//            self.pickerViewClave.resignFirstResponder()
            
            //if you dont want the users to se the keyboard type:
            textField.endEditing(true)
            textField.resignFirstResponder()
        }
        else{
//            self.pickerViewMarca.isHidden = true
//            self.pickerViewEstado.isHidden = true
//            self.pickerViewClave.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        txtPlaca.resignFirstResponder()
        print("Puede Terminar")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("Termino")
        
        if textField == self.txtDireccion && tengoCalle == false && tengoColonia == false{
            calle = self.txtDireccion.text!
            colonia = self.txtDireccion.text!
        }
        
        resignFirstResponder()
        self.dismissKeyboard()
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("Limpio")
        return true
    }
    
    
    @IBAction func btnEnviarClic(_ sender: UIButton) {
        
        //Se tendria que validar que los datos esten correctos.
        
        // Actualizamos la ubicacion
        if GisInternetAvaliable.boolValue
        {
            ActualizaUbicacion()
        }

        if txtPlaca.text == "" {
            "Favor de capturar la Placa del vehiculo".showAlert(self)
            return
        }
        if txtMarca.text == "" {
            "Favor de capturar marca del vehiculo".showAlert(self)
            return
        }
        if txtColor.text == "" {
            "Favor de capturar el color del vehiculo".showAlert(self)
            return
        }
        if txtClave.text == "" {
            "Favor de seleccionar una clave de infracción".showAlert(self)
            return
        }
        if txtClave.text == "1" {
            if txtParquimetro.text == "" || txtEspacio.text == "" {
                "Favor de capturar todos los datos del parquimetro".showAlert(self)
                return
            }
        }
        
        if (imageIsNullOrNot(imageName: fotoView.image!))
        {
            //image is not null
            
            //Aqui se optiene inf_Id
            let inf_id = obtenerIdInfraccion(clave: txtClave.text!) as Int
            
            
            let infraccion = obtenerInfraccion(clave: txtClave.text!) as NSManagedObject
            
            let sancionValue : Float = infraccion.value(forKey: "inf_Sancion") as! Float
            
            
            //Guardar en la bd todos los campos
            
            //verifica si hay alguna multa guardada si si guardarla con el siguiente id
            if self.getLastMulta()
            {
                print("Ultima multaMulta: \(dbObjectMultas[dbObjectMultas.count-1].self), \(dbObjectMultas[dbObjectMultas.count-1].value(forKey:"mul_Placa") as? String)")
                
           
                let ultimaMultaid = dbObjectMultas.count+1
                
                
                 saveMulta(inf_Id: Int(inf_id) , concepto: txtConcepto.text!, sancion: sancionValue, mul_Id: ultimaMultaid, mul_Folio: txtFolio.text!, mul_Estado: txtEntidad.text!, mul_Direccion: txtDireccion.text!, mul_Placa: txtPlaca.text!, mul_Marca: txtMarca.text!, mul_Color: txtColor.text!, par_Id: 0, mul_Espacio: 0, mul_Fecha: Date())
            }
            else{
                //Como no hay multas se guarda la primera multa en la tabla con mul_Id = 1
                saveMulta(inf_Id: Int(inf_id) , concepto: txtConcepto.text!, sancion: sancionValue, mul_Id: 1, mul_Folio: txtFolio.text!, mul_Estado: txtEntidad.text!, mul_Direccion: txtDireccion.text!, mul_Placa: txtPlaca.text!, mul_Marca: txtMarca.text!, mul_Color: txtColor.text!, par_Id: 0, mul_Espacio: 0, mul_Fecha: Date())
            }
            
            imp_Folio = txtFolio.text!.uppercased()            
            imp_Placa = txtPlaca.text!.uppercased()
            imp_Entidad = txtEntidad.text!.uppercased()
            imp_Marca = txtMarca.text!.uppercased()
            imp_Vehiculo = txtVehiculo.text!.uppercased()
            imp_Color = txtColor.text!.uppercased()
            imp_Concepto = txtConcepto.text!.uppercased()
            imp_Sancion = txtSancion.text!.uppercased()
            imp_Direccion = txtDireccion.text!.uppercased()
            imp_Parquimetro = txtParquimetro.text!.uppercased()
            imp_Espacio = txtEspacio.text!.uppercased()
            
            UserDefaults.standard.setValue(imp_Folio, forKey: "imp_Folio")
            UserDefaults.standard.setValue(imp_Placa, forKey: "imp_Placa")
            UserDefaults.standard.setValue(imp_Entidad, forKey: "imp_Entidad")
            UserDefaults.standard.setValue(imp_Marca, forKey: "imp_Marca")
            UserDefaults.standard.setValue(imp_Vehiculo, forKey: "imp_Vehiculo")
            UserDefaults.standard.setValue(imp_Color, forKey: "imp_Color")
            UserDefaults.standard.setValue(imp_Concepto, forKey: "imp_Concepto")
            UserDefaults.standard.setValue(imp_Sancion, forKey: "imp_Sancion")
            UserDefaults.standard.setValue(imp_Direccion, forKey: "imp_Direccion")
            UserDefaults.standard.setValue(imp_Parquimetro, forKey: "imp_Parquimetro")
            UserDefaults.standard.setValue(imp_Espacio, forKey: "imp_Espacio")
            UserDefaults.standard.setValue(noombreUsuario, forKey: "nombreUsuario")
            UserDefaults.standard.setValue(fecha, forKey: "fecha")
            UserDefaults.standard.setValue(usuario, forKey: "usuario")
            

            //            print("\(UserDefaults.standard.value(forKey: "imp_Folio")!)")

        }
        else
        {
            //image is null
            "Favor de capturar una fotografia como evidencia".showAlert(self)
            return

        }
    }
    
    func obtenerIdInfraccion(clave: String) -> Int {
        for infraccion in dbObjectInfracciones {
            let infClave = infraccion.value(forKey: "inf_Clave") as! String
            if infClave == clave {
                idmulta = infraccion.value(forKey: "inf_Id") as! Int
                return infraccion.value(forKey: "inf_Id") as! Int
            }
        }
        return 0
    }
    
    func obtenerInfraccion(clave: String) -> NSManagedObject {
        for infraccion in dbObjectInfracciones {
            let infClave = infraccion.value(forKey: "inf_Clave") as! String
            if infClave == clave {
                return infraccion as NSManagedObject
            }
        }
        return NSManagedObject()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        self.dismiss(animated: true, completion: nil)
        
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            fotoView.image = image
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                                               #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
            } else if mediaType.isEqual(to: kUTTypeMovie as String) {
                // Code to support video here
            }
            
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                                          message: "Failed to save image",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true,
                         completion: nil)
        }
    }

    func updateMulta(mul_Folio: String) {
        
        //1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        
        //2
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MUL_Multas")
        fetchRequest.predicate = NSPredicate(format: "mul_Folio == %@", mul_Folio)
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            dbObjectMultas = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        if dbObjectMultas.count > 0
        {
            let multa = dbObjectMultas[0]
            multa.setValue("ENVIADA", forKey: "mul_Estatus")
            
            //4
            do {
                try managedContext.save()
                //5
                dbObjectMultas.append(multa)
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
                "No fue posible guardar la multa".showAlert(self)
            }

        }


    }
    
    func saveMulta(inf_Id: Int, concepto: String, sancion: Float, mul_Id: Int, mul_Folio: String, mul_Estado: String, mul_Direccion: String,  mul_Placa: String, mul_Marca: String, mul_Color: String, par_Id: Int, mul_Espacio: Int, mul_Fecha: Date) {
        
        // Actualizamos la ubicacion
        if GisInternetAvaliable.boolValue
        {
            ActualizaUbicacion()
        }

        
        var dbObjectMulta = [NSManagedObject]()
        
        //1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entityMulta =  NSEntityDescription.entity(forEntityName: "MUL_Multas",
                                                    in:managedContext)
        
        let multa = NSManagedObject(entity: entityMulta!,
                                         insertInto: managedContext)
        
        //3
        multa.setValue(inf_Id, forKey: "inf_Id")
        multa.setValue(concepto, forKey: "mul_Concepto")
        multa.setValue(sancion, forKey: "mul_Sancion")
        
        multa.setValue(mul_Id, forKey: "mul_Id")
        multa.setValue(mul_Folio, forKey: "mul_Folio")
        multa.setValue(mul_Estado, forKey: "mul_Estado")
        multa.setValue(mul_Direccion, forKey: "mul_Direccion")
        
        multa.setValue(mul_Placa, forKey: "mul_Placa")
        multa.setValue(mul_Marca, forKey: "mul_Marca")
        multa.setValue(mul_Color, forKey: "mul_Color")
        
        multa.setValue(par_Id, forKey: "par_Id")
        multa.setValue(mul_Espacio, forKey: "mul_Espacio")
        multa.setValue(mul_Fecha, forKey: "mul_Fecha")
        multa.setValue(usuario, forKey: "usu_Id")
        
        multa.setValue("GUARDADA", forKey: "mul_Estatus")
        
        //4
        do {
            try managedContext.save()
            //5
            dbObjectMulta.append(multa)
            
            self.btnEnviar.isEnabled = false
            self.btnEnviar.alpha = 0.5;
            
            self.btnImprimir.isEnabled = true
            self.btnImprimir.alpha = 1.0;
            
            // Create the alert controller
//            let alertController = UIAlertController(title: "Cryxo App🍁", message: "Se genero una nueva multa", preferredStyle: .alert)
//            // Create the actions
//            let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
//                UIAlertAction in
//                self.sendMultaToWS()
//                NSLog("OK Pressed")
//            }
//            // Add the actions
//            alertController.addAction(okAction)
//            // Present the controller
//            self.present(alertController, animated: true, completion: nil)
//            
//            "La multa se guardo correctamente".showAlert(self)
            
            if GisInternetAvaliable.boolValue{
                     sendMultaToWS()
            }
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            "No fue posible guardar la multa".showAlert(self)
        }
    }
    
    func sendMultaToWS() {
        
        // Actualizamos la ubicacion
        if GisInternetAvaliable.boolValue
        {
            ActualizaUbicacion()
        }

        var cadena: String = AppDelegate.Host
        cadena += "?Par1=4"
        cadena += "&par2=\(txtFolio.text!)"
        cadena += "&par3=\(txtPlaca.text!)"
        cadena += "&par4=\(txtMarca.text!)"
        cadena += "&par5=\(idcolor)"
        cadena += "&par6=\(txtEntidad.text!)"
        cadena += "&par7=\(txtDireccion.text!)"
        cadena += "&par8=\(txtConcepto.text!)"
        cadena += "&par9=\(txtSancion.text!)"
        cadena += "&par10=\(txtParquimetro.text!)"
        cadena += "&par11=\(txtEspacio.text!)"
        cadena += "&par12=\(latitud)"
        cadena += "&par13=\(longitud)"
        cadena += "&par14=\(usuario)"
        cadena += "&par15=\(dispositivo)"
        cadena += "&par16=\(FechaWS)"
        cadena += "&par17=\(idcalle)"
        cadena += "&par18=\(idcolonia)"
        cadena += "&par19=\(idmulta)"
        cadena += "&par20=\(idlinea)"
        cadena += "&par21=\(idtipo)"
        cadena += "&par22=0"
        
        cadena = cadena.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!
        
        let jsonArr = cadena.getJson()
        
        if jsonArr.count == 0
        {
//            let alert = UIAlertController(title: "Alert", message: "No hay respuesta servicio", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
            
            "Imposible enviar, NO hay Respuesta del servicio".showAlert(self)
            self.updateMulta(mul_Folio: txtFolio.text!)
        
            //******CODIGO QUE FUNCIONA SI NO SE QUIERE CREAR EL SEGUE DE PRESENT MODAL
//            let homeVC = (self.storyboard?.instantiateViewController(withIdentifier: "homeView"))! as! MenuViewController
////            homeVC.delegate = self
//            self.present(homeVC, animated: true, completion: nil)
            
            //*********ESTE CODIGO HACE QUE TRUENE HAY QUE REVISAR
//            let parent = self.parent!
//            parent.dismiss(animated: true, completion: {
//                  let homeVC = (self.storyboard?.instantiateViewController(withIdentifier: "homeView"))! as! MenuViewController
//                parent.present(homeVC, animated: true, completion: nil)
//            })
            
            return
        }
        else
        {
            let datojson1 = jsonArr.object(at: 0) as! NSDictionary
            
            let ErrorNo = (datojson1["NoError"]! as AnyObject).description
            
            if ErrorNo == "1"
            {
                "Error al enviar la multa".showAlert(self)
                return
            }
            else{
//                "La multa se envio correctamente".showAlert(self)
                // Create the alert controller
                
                let alertController = UIAlertController(title: "Cryxo App🍁", message: "Se generó una multa y se envio al servidor. Para continuar imprima el comprobante", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    //self.sendFotoToWS()
                    self.sendAllFotosOfScrollToWS()
                    NSLog("OK Pressed")
                }
                // Add the actions
                alertController.addAction(okAction)
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                
                self.updateMulta(mul_Folio: txtFolio.text!)

                return
            }
        }
    }
    
    func sendFotoToWS() {
        //*************
        
        // Actualizamos la ubicacion
        if GisInternetAvaliable.boolValue
        {
            ActualizaUbicacion()
        }


        let url = AppDelegate.Host as String
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //var imageData = UIImageJPEGRepresentation(myImageView.image!, 0.0)
        let image = fotoView.image?.resizeWith(percentage: 0.5)
        let imageData = UIImageJPEGRepresentation(image!, 0.2)
        
        let base64String = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
        
        var nameFoto: String = UserDefaults.standard.string(forKey: "imp_Folio")!
        nameFoto += "-1"
        
//        let err: NSError? = nil
        let params = ["image":[ "content_type": "image/jpeg", "filename":nameFoto, "file_data": base64String]]
        //print(base64String)
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("JSON serialization failed:  \(error)")
        }
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
        let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            let err: NSError?
            
            // process the response
            print(strData as! String)
        })
        
        task.resume() // this is needed to start the task
        //********************

    }
    
    
    func sendAllFotosOfScrollToWS() {
        
        // Actualizamos la ubicacion
        if GisInternetAvaliable.boolValue
        {
            ActualizaUbicacion()
        }
        
        
        for index in 1...3 {
            print("\(index) imagen")
            
            let url = AppDelegate.Host as String
            let request = NSMutableURLRequest(url: URL(string: url)!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            //var imageData = UIImageJPEGRepresentation(myImageView.image!, 0.0)
            
            var image: UIImage
            
            if index == 1
            {
                image = (imageView1.image?.resizeWith(percentage: 0.5))!
            }
            else if index == 2
            {
                image = (imageView2.image?.resizeWith(percentage: 0.5))!
            }
            else
            {
                image = (imageView3.image?.resizeWith(percentage: 0.5))!
            }
            
//            let image = fotoView.image?.resizeWith(percentage: 0.5)
            let imageData = UIImageJPEGRepresentation(image, 0.2)
            
            let base64String = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
            
            var nameFoto: String = UserDefaults.standard.string(forKey: "imp_Folio")!
            nameFoto += "-\(index)"
            
//            let err: NSError? = nil
            let params = ["image":[ "content_type": "image/jpeg", "filename":nameFoto, "file_data": base64String]]
            //print(base64String)
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            } catch {
                print("JSON serialization failed:  \(error)")
            }
            
            //*************POSIBLEMENTE ESTE BLOQUE DE CODIGO SE TENGA QUE COMENTAR************
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                let err: NSError?
                
                // process the response
                print(strData)
            })
            
            task.resume() // this is needed to start the task
            //*********************************************************************************
        }
        
    }
    
    func getIdCalle(calleSelected: String) -> Int
    {
        //1
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CAL_Calles")
        fetchRequest.predicate = NSPredicate(format: "calle_Nombre == %@", calleSelected)
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            dbObjectCalles = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        if dbObjectCalles.count > 0
        {
            idcalle = dbObjectCalles[0].value(forKey: "calle_Id") as! Int
            return dbObjectCalles[0].value(forKey: "calle_Id") as! Int
        }
        
        return 0;

    }
 
    func getIdColonia(coloniaSelected: String) -> Int
    {
        //1
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "COL_Colonias")
        fetchRequest.predicate = NSPredicate(format: "colonia_Nombre == %@", coloniaSelected)
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            dbObjectColonias = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        if dbObjectColonias.count > 0
        {
            idcolonia = dbObjectColonias[0].value(forKey: "colonia_Id") as! Int
            return dbObjectColonias[0].value(forKey: "colonia_Id") as! Int
        }
        
        return 0;
        
    }
    
    func getIdColor(colorSelected: String) -> Int
    {
        //1
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "COL_Colores")
        fetchRequest.predicate = NSPredicate(format: "color_nombre == %@", colorSelected)
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            dbObjectColores = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        if dbObjectColores.count > 0
        {
            idcolor = dbObjectColores[0].value(forKey: "color_id") as! Int
            return dbObjectColores[0].value(forKey: "color_id") as! Int
        }
        
        return 0;
        
    }

    func getIdTipo(TipoSelected: String) -> Int
    {
        //1
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TIV_TipoVehiculo")
        fetchRequest.predicate = NSPredicate(format: "tipo_Nombre == %@", TipoSelected)
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            dbObjectColores = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        if dbObjectColores.count > 0
        {
            idtipo = dbObjectColores[0].value(forKey: "tipo_Id") as! Int
            return dbObjectColores[0].value(forKey: "tipo_Id") as! Int
        }
        
        return 0;
        
    }
    
    func getLastMulta() -> Bool{
        
        //1
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MUL_Multas")
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            dbObjectMultas = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        if dbObjectMultas.count > 0
        {
            return true;
        }
        return false;
    }
    
    @IBAction func addPopover(sender: UITextField){
        
        //        let contentSizePopUp = CGSize(width: 300, height: 300)
        //
        //    tablaViewController.storyboard?.instantiateViewController(withIdentifier: "popoverTableView")
        //        popover?.contentViewController = tablaViewController
        //        popover?.contentSize = contentSizePopUp
        //        popover?.delegate = self
        
//        self.performSegue(withIdentifier: "segueId", sender: self)
        
        var contentSizePopUp = CGSize(width: sender.frame.size.width, height: 200)
        
        if sender.tag == 1 || sender.tag == 9{
            contentSizePopUp = CGSize(width: 200, height: 200)
        }
        if sender.tag == 5{//Popover de calles
            contentSizePopUp = CGSize(width: 300, height: 200)
        }
        if sender.tag == 3 || sender.tag == 8{
            contentSizePopUp = CGSize(width: 150, height: 200)
        }
        if sender.tag == 4 {
            contentSizePopUp = CGSize(width: sender.frame.size.width, height: 90)
        }
        if sender.tag == 6 {
            contentSizePopUp = CGSize(width: 300, height: 200)
        }
        
        let popoverViewController = self.storyboard?.instantiateViewController(withIdentifier: "popoverTableView") as! TablaViewController
        popoverViewController.modalPresentationStyle = .popover
        popoverViewController.preferredContentSize   = contentSizePopUp
        popoverViewController.tagTxtField = sender.tag
        popoverViewController.idCalle = idCalle
        popoverViewController.calle = calle
        popoverViewController.colonia = colonia
        
        let popoverPresentationViewController = popoverViewController.popoverPresentationController
        
        popoverPresentationViewController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popoverPresentationViewController?.delegate = self
        popoverPresentationViewController?.sourceView = sender

        let sourceReck = CGRect(x: sender.frame.width / 2, y: sender.frame.height, width: 0, height: 0)

        popoverPresentationViewController?.sourceRect = sourceReck
        present(popoverViewController, animated: true, completion: nil)
        
//        let contentSizePopUp = CGSize(width: 300, height: 300)
//
//        tablaViewController.storyboard?.instantiateViewController(withIdentifier: "popoverTableView")
//        popover?.contentViewController = tablaViewController
//        popover?.contentSize = contentSizePopUp
//        popover?.delegate = self
        
//        let tablaInformationViewController =  tablaViewController
//        tablaInformationViewController.modalPresentationStyle = .popover
//        tablaInformationViewController.preferredContentSize = contentSizePopUp
//        
//        let popoverPresentationViewController = tablaViewController.popoverPresentationController
//        popoverPresentationViewController?.permittedArrowDirections = .any
//        popoverPresentationViewController?.delegate = self
//        popoverPresentationController?.barButtonItem = sender
//        present(tablaViewController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueId"
        {
            let vc = segue.destination 
            
            let controller = vc.popoverPresentationController
            
            if controller != nil
            {
                controller?.delegate = self
            }
        }
    }
    
//    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle{
//        return .none
//    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        // return UIModalPresentationStyle.FullScreen
        return UIModalPresentationStyle.none
    }

    func NuevoFolio()-> String
    {
//        idtelefono = UIDevice.current.name.description
        
        var UltimaFecha: Date = Date()
        var Numero: Int = 0
        var foliofor: String = ""
        
//        let last4 = idtelefono.substring(from:idtelefono.index(idtelefono.endIndex, offsetBy: -4))
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        let result = formatter.string(from: date)
        formatter.dateFormat = "dd/MM/yyyy H:mm"
        fecha = formatter.string(from: date)
        formatter.dateFormat = "yyyyMMdd H:mm"
        FechaWS = formatter.string(from: date)
        formatter.dateFormat = "ddMMyyyy"
        var strUltimaFecha: String = ""
//        let strFechaHoy: String = formatter.string(from: date)
        
        // ************ ULTIMA MULTA **************
        
        // Obtenemos la ultima multa guardada
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MUL_Multas")
        fetchRequest.predicate = NSPredicate(format: "usu_Id == %@", usuario)
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            dbObjectMultas = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
        if dbObjectMultas.count > 0
        {
            //  Si ya hay multas leemos el ultimo registro y guardamos el ultimo folio y la ultima fecha
            let UltimaMulta = dbObjectMultas.count-1
            let Folio = dbObjectMultas[UltimaMulta].value(forKey: "mul_Folio") as! String
            UltimoFolio = Folio.substring(from:Folio.index(Folio.endIndex, offsetBy: -2))
            UltimaFecha = dbObjectMultas[UltimaMulta].value(forKey: "mul_Fecha") as! Date
        }
        else
        {
            //  Si no hay multas inicializamos los valores
            UltimoFolio = "0"
            UltimaFecha = Date()
        }
        strUltimaFecha = formatter.string(from: UltimaFecha)
        
        if strUltimaFecha == result {
            // Si la ultima fecha es la de hoy sumamos 1 al contador
            Numero = Int(UltimoFolio)!
        }
        else {
            // Si no entonces iniciamos la cuenta
            Numero = 0
        }
        if Numero < 0 {
            Numero = Numero * (-1)
        }
        
        Numero += 1
        

        foliofor = "00" + String(Numero)
        
        UltimoFolio = foliofor.substring(from:foliofor.index(foliofor.endIndex, offsetBy: -3))

    
        
//        UltimoFolio = String(Numero)
        
        //************ FIN DE ULTIMA MULTA **************
        
        let NuevoFolio = usuario + result + UltimoFolio
               
        return NuevoFolio
        
    }
    
    @IBAction func regresar(_ sender: UIButton)
    {
        imageView1.image = UIImage(named: "imagenVacia.png")
        imageView2.image = UIImage(named: "imagenVacia.png")
        imageView3.image = UIImage(named: "imagenVacia.png")
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UpdateFotos"), object: nil)
        
        let homeVC = (self.storyboard?.instantiateViewController(withIdentifier: "homeView"))! as! MenuViewController
        //            homeVC.delegate = self
        self.present(homeVC, animated: true, completion: nil)
    }
    
    func ActualizaUbicacion() {
        
        // Actualiza la ubicacion del dispositivo
        
        var cadena: String = AppDelegate.Host
        cadena += "?Par1=2"
        cadena += "&par2=\(idtelefono)"
        cadena += "&par3=\(latitud)"
        cadena += "&par4=\(longitud)"
        print(cadena)
        
        cadena = cadena.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!
        
        let json = cadena.getJson()
        
        let datojson1 = json.object(at: 0) as! NSDictionary
        
        let ErrorNo = (datojson1["NoError"]! as AnyObject).description
        
        if ErrorNo == "1"
        {
            print("Error al enviar ubicacion")
        }
        else{
            print("Ubicacion enviada con exito")
        }
    }

}

func imageIsNullOrNot(imageName : UIImage)-> Bool
{
    
    let size = CGSize(width: 0, height: 0)
    if (imageName.size.width == size.width)
    {
        return false
    }
    else
    {
        return true
    }
}



// MARK: Funciones Externas
func clearTempFolder() {
    let fileManager = FileManager.default
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
    
//    let tempFolderPath = NSTemporaryDirectory()
    
    do {
        let filePaths = try fileManager.contentsOfDirectory(atPath: paths as String)
        for filePath in filePaths {
            var elements = filePath .components(separatedBy: ".")
            let str = elements[1] as String
            if str == "png"
            {
                 try fileManager.removeItem(atPath: (paths as String) + "/" + filePath)
            }
            
        }
    } catch {
        print("Could not clear temp folder: \(error)")
    }
    
}



func randomString(length: Int) -> String {
    
    let letters : NSString = "0123456789"
    let len = UInt32(letters.length)
    
    var randomString = ""
    
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    
    return randomString
}

extension UIImage {
    func resizeWith(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWith(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}

