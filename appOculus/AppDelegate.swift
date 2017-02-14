//
//  AppDelegate.swift
//  appOculus
//
//  Created by Javier Cortes on 15/01/17.
//  Copyright © 2017 Javier Cortes. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static let Host = "http://cryxodeveloper-001-site6.btempurl.com/"
    
    var DbObject = [NSManagedObject]()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        netValidator = InternetServices.init()
        
//        let reach = Reachability()
//        let conectionBool = reach.connectionRequired()
//        print(conectionBool)
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch. ISAI")
        } else {
            print("First launch, setting UserDefault. ISAI")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            
            /***CODIGO PARA PEDIR DATOS DE ALGUNA TABLA***/
//            //1
//            let managedContext = self.managedObjectContext
//            
//            //2
//            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "INF_Infracciones")
//            
//            //3
//            do {
//                let results = try managedContext.fetch(fetchRequest)
//                DbObject = results as! [NSManagedObject]
//            } catch let error as NSError {
//                print("Could not fetch \(error), \(error.userInfo)")
//            }

            saveInfraccion(id: 1, clave: "1", concepto: "1.- POR OMITIR EL PAGO DE LA TARIFA POR EL USO DE ESPACIOS REGULADOS POR APARATOS ESTACIONOMETROS", sancion: 366.0)
            saveInfraccion(id: 2, clave: "2", concepto: "2.- POR ESTACIONAR VEHICULOS INVADIENDO PARETE DE DOS O MAS LUGARES CUBIERTOS POR ESTACIONOMETROS", sancion: 606.0)
            saveInfraccion(id: 3, clave: "3", concepto: "3.- POR ESTACIONAR VEHICULOS INVADIENDO PARTES DE ENTRADA A COCHERA, DIFICULTANDO LA ENTRADA A OTRO VEHICULO", sancion: 1741.0)
            saveInfraccion(id: 4, clave: "4", concepto: "4.- POR ESTACIONARSE SIN DERECHO EN ESPACIOS AUTORIZADOS COMO EXCLUSIVOS O EN LUGARES PROHIBIDOS POR LA AUTORIDAD", sancion: 1393.0)
            saveInfraccion(id: 5, clave: "5", concepto: "5.- POR INTODUCIR OBJETOS DIFERENTES A LA MONEDA CORRESPONDIENTE EN LOS ESTACIONOMETROS, POR PINTAR EL APARATO", sancion: 1864.0)
            saveInfraccion(id: 6, clave: "6", concepto: "28.- POR INSULTAR AL PERSONAL DE INSPECCION, SUPERVISION O VIGILANCIA, ADEMAS DEL PAGO DE LOS DAÑOS FISICOS JURIDICOS", sancion: 4660.0)
            saveInfraccion(id: 7, clave: "7", concepto: "9.- SI ALGUN VEHICULO SE ENCUENTRA ARRIBA DE LA ACERA OBSTRUYENDO EL LIBRE PSO PEATONAL", sancion: 1821.0)
            saveInfraccion(id: 8, clave: "8", concepto: "6.- COLOCAR FOLIO CON FECHAS PASADAS EN EL PARABRISAS CON LA INTENCION DE ENGAÑAR AL VIGILANTE", sancion: 423.0)
            saveInfraccion(id: 9, clave: "9", concepto: "7.- FALSIFICAR, ALTERAR O HACER MAL USO DE LAS TARJETAS, CALCOMANIAS O PERMISOS QUE SE OTORGUEN PARA EL USO DE ESTACIONAMIENTOS", sancion: 425.0)
            saveInfraccion(id: 10, clave: "10", concepto: "8.- CAMBIAR EL FOLIO DE UN AUTOMOVIL A OTRO DE DIFERENTE PLACA", sancion: 637.0)
            saveInfraccion(id: 11, clave: "11", concepto: "35.- POR OCUPAR ESPACIOS PARA PERSONAS CON DISCAPACIDAD, DE LA TERCERA EDAD O MUJERES EMBARAZADAS SIN CONTAR", sancion: 7933.0)
            
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.razeware.HitList" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        
        let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    func saveInfraccion(id: Int, clave: String, concepto: String, sancion: Float) {
        //1
        let managedContext = self.managedObjectContext
        
        //2
        let entityInf =  NSEntityDescription.entity(forEntityName: "INF_Infracciones",
                                                 in:managedContext)
        
        let infraccion = NSManagedObject(entity: entityInf!,
                                    insertInto: managedContext)
        
        //3
        infraccion.setValue(id, forKey: "inf_Id")
        infraccion.setValue(clave, forKey: "inf_Clave")
        infraccion.setValue(concepto, forKey: "inf_Concepto")
        infraccion.setValue(sancion, forKey: "inf_Sancion")
        
        //4
        do {
            try managedContext.save()
            //5
            DbObject.append(infraccion)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }


}

