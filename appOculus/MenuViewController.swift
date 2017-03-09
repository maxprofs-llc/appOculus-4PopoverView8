//
//  MenuViewController.swift
//  appOculus
//
//  Created by Javier Cortes on 16/01/17.
//  Copyright © 2017 Javier Cortes. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class MenuViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var btnReImprimirMulta: UIButton!
    @IBOutlet weak var btnNuevaMulta: UIButton!
    
    var dbObjectMultas = [NSManagedObject]()
    
    
    @IBAction func btnNuevaMultaClic(_ sender: Any) {
    }
    
    @IBAction func btnReimpresionClick(_ sender: UIButton) {
        
        //Aqui tengo que mandar la sentencia para que imprima la ultima multa desde objective C.
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Do any additional setup after loading the view, typically from a nib.
        
        self.btnReImprimirMulta.isEnabled = false;
        self.btnReImprimirMulta.alpha = 0.5;
        
        btnReImprimirMulta.layer.cornerRadius = 5
        btnReImprimirMulta.layer.borderWidth = 1
        btnReImprimirMulta.layer.borderColor = UIColor.gray.cgColor
        
        btnNuevaMulta.layer.cornerRadius = 5
        btnNuevaMulta.layer.borderWidth = 1
        btnNuevaMulta.layer.borderColor = UIColor.gray.cgColor
        
        if self.getLastMulta()
        {
            self.btnReImprimirMulta.isEnabled = true;
            self.btnReImprimirMulta.alpha = 1.0;
            
            print("Ultima multaMulta: \(dbObjectMultas[dbObjectMultas.count-1].self), \(dbObjectMultas[dbObjectMultas.count-1].value(forKey:"mul_Placa") as? String)")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


}
