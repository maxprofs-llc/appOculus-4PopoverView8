//
//  TablaViewController.swift
//  appOculus
//
//  Created by Jorge I. Garcia Reyes on 24/02/17.
//  Copyright © 2017 Javier Cortes. All rights reserved.
//

import UIKit
import CoreData

class TablaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tagTxtField: Int = 0
    var idCalle: Int = 0
    var colonia: String = ""
    var calle: String = ""
    
    // Data model: These strings will be the data for the table view cells
    var dbObjectMarcas = [NSManagedObject]()
    var dbObjectColores = [NSManagedObject]()
    var dbObjectVehiculos = [NSManagedObject]()
    var dbObjectEstados = [NSManagedObject]()
    var dbObjectCalles = [NSManagedObject]()
    var dbObjectColonias = [NSManagedObject]()
    var dbObjectInfracciones = [NSManagedObject]()
    var dbObjectParquimetros = [NSManagedObject]()
    let parquimetroNum: [String] = ["1", "2"]
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    
    // don't forget to hook this up from the storyboard
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //1
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2//Para obtener las marcas de los autos
        var fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MAR_Marcas")
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            dbObjectMarcas = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        //Para obtener los colores
        fetchRequest = NSFetchRequest(entityName: "COL_Colores")
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            dbObjectColores = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        //Para obtener los vehiculos
        fetchRequest = NSFetchRequest(entityName: "TIV_TipoVehiculo")
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            dbObjectVehiculos = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        //2//Para obtener las claves de las infracciones
        fetchRequest = NSFetchRequest(entityName: "INF_Infracciones")
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            dbObjectInfracciones = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        //Para obtener los datos del combo de Entidad o Estado
        fetchRequest = NSFetchRequest(entityName: "EDO_Estados")
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            dbObjectEstados = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        //Para obtener las Calles

        //getCalles(strCalle: "DICIEMBRE")
        getCalles(strCalle: calle)

        //Para obtener las colonias
        getColonias(strColonia: colonia)
        
        //Para obtener los parquimetros
        getParquimetros(idCalle: idCalle)

    }
    
    func getParquimetros(idCalle: Int)
    {
        //1
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PAR_Parquimetros")
        //Para que muestre solo los parquimetros con ese id de calle
        if idCalle != 0 {
            fetchRequest.predicate = NSPredicate(format: "calle_Id == %d", idCalle)
        }
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            dbObjectParquimetros = results as! [NSManagedObject]
            
            if dbObjectParquimetros.count == 0
            {
                let fetchRequestAll:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PAR_Parquimetros")
                
                do {
                    let results =
                        try managedContext.fetch(fetchRequestAll)
                    dbObjectParquimetros = results as! [NSManagedObject]
                } catch let error as NSError {
                    print("Could not fetch \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    func getCalles(strCalle: String)
    {
        //1
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CAL_Calles")
        //Para que muestre solo los parquimetros con ese id de calle
        if strCalle != "" {
            fetchRequest.predicate = NSPredicate(format: "calle_Nombre CONTAINS[cd] %@", strCalle)
        }
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            dbObjectCalles = results as! [NSManagedObject]
            
            if dbObjectCalles.count == 0
            {
                let fetchRequestAll:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CAL_Calles")
                
                do {
                    let results =
                        try managedContext.fetch(fetchRequestAll)
                    dbObjectCalles = results as! [NSManagedObject]
                } catch let error as NSError {
                    print("Could not fetch \(error), \(error.userInfo)")
                }
            }

        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    func getColonias(strColonia: String)
    {
        //1
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "COL_Colonias")
        //Para que muestre solo los parquimetros con ese id de calle
        if strColonia != "" {
            fetchRequest.predicate = NSPredicate(format: "colonia_Nombre CONTAINS[cd] %@", strColonia)
        }
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            dbObjectColonias = results as! [NSManagedObject]
            
            if dbObjectColonias.count == 0
            {
                let fetchRequestAll:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "COL_Colonias")
                
                do {
                    let results =
                        try managedContext.fetch(fetchRequestAll)
                    dbObjectColonias = results as! [NSManagedObject]
                } catch let error as NSError {
                    print("Could not fetch \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }



    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tagTxtField == 1 {
            if dbObjectMarcas.count != 0 {
                return dbObjectMarcas.count
            }
        }
        else if tagTxtField == 2 {
            if dbObjectEstados.count != 0 {
                return dbObjectEstados.count
            }
        }
        else if tagTxtField == 3 {
            if dbObjectInfracciones.count != 0 {
                return dbObjectInfracciones.count
            }
        }
        else if tagTxtField == 4 {
            return self.parquimetroNum.count
        }
        else if tagTxtField == 5 {
            if dbObjectCalles.count != 0 {
                return dbObjectCalles.count
            }
        }
        else if tagTxtField == 6 {
            if dbObjectColonias.count != 0 {
                return dbObjectColonias.count
            }
        }
        else if tagTxtField == 7 {
            if dbObjectParquimetros.count != 0 {
                return dbObjectParquimetros.count
            }
        }
        else if tagTxtField == 8 {
            if dbObjectColores.count != 0 {
                return dbObjectColores.count
            }
        }
        else if tagTxtField == 9 {
            if dbObjectVehiculos.count != 0 {
                return dbObjectVehiculos.count
            }
        }



        
        return 0

    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        if tagTxtField == 1 {
            if dbObjectMarcas.count != 0
            {
                cell.textLabel?.text = dbObjectMarcas[indexPath.row].value(forKey:"mar_Nombre") as? String
            }
        }
        else if tagTxtField == 2 {
            if dbObjectEstados.count != 0
            {
                cell.textLabel?.text = dbObjectEstados[indexPath.row].value(forKey:"edo_Nombre") as? String
            }
        }
        else if tagTxtField == 3 {
            if dbObjectInfracciones.count != 0
            {
                cell.textLabel?.text = dbObjectInfracciones[indexPath.row].value(forKey:"inf_Clave") as? String
            }
        }
        else if tagTxtField == 4 {
            cell.textLabel?.text = self.parquimetroNum[indexPath.row]
        }
        else if tagTxtField == 5 {
            if dbObjectCalles.count != 0
            {
                cell.textLabel?.text = dbObjectCalles[indexPath.row].value(forKey:"calle_Nombre") as? String
            }
        }
        else if tagTxtField == 6 {
            if dbObjectColonias.count != 0
            {
                cell.textLabel?.text = dbObjectColonias[indexPath.row].value(forKey:"colonia_Nombre") as? String
            }
        }
        else if tagTxtField == 7 {
            if dbObjectParquimetros.count != 0
            {
                cell.textLabel?.text = String(dbObjectParquimetros[indexPath.row].value(forKey:"poste") as! Int)
            }
        }
        else if tagTxtField == 8 {
            if dbObjectColores.count != 0
            {
                cell.textLabel?.text = String(dbObjectColores[indexPath.row].value(forKey:"color_nombre") as! String)
            }
        }
        else if tagTxtField == 9 {
            if dbObjectVehiculos.count != 0
            {
                cell.textLabel?.text = String(dbObjectVehiculos[indexPath.row].value(forKey:"tipo_Nombre") as! String)
            }
        }




        
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!) as UITableViewCell!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "multaView") as! MultaViewController
        viewController.passedValue = (currentCell?.textLabel?.text)!
//      self.present(viewController, animated: true , completion: nil)
        
        let stridCell: Int = (indexPath?.row)!
        
        let txtSelected = (currentCell?.textLabel?.text)!
        let dictionary = ["txtSelected": txtSelected, "textFieldTag": String(tagTxtField), "cellSelected": stridCell] as [String : Any]
        
        NotificationCenter.default.post(name: Notification.Name("setValueForPopOver"), object: dictionary)
        
//        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    
    // this method handles row deletion
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        
//        if editingStyle == .delete {
//            
//            // remove the item from the data model
//            parquimetroNum.remove(at: indexPath.row)
//            
//            // delete the table view row
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            
//        } else if editingStyle == .insert {
//            // Not used in our example, but if you were adding a new row, this is where you would do it.
//        }
//    }
//    
//    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        
//        // action one
//        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
//            print("Edit tapped")
//        })
//        editAction.backgroundColor = UIColor.blue
//        
//        // action two
//        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
//            print("Delete tapped")
//        })
//        deleteAction.backgroundColor = UIColor.red
//        
//        return [editAction, deleteAction]
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
