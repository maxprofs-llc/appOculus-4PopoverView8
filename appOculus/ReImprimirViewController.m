//
//  ReImprimirViewController.m
//  appOculus
//
//  Created by Jorge I. Garcia Reyes on 20/02/17.
//  Copyright © 2017 Javier Cortes. All rights reserved.
//

#import "ReImprimirViewController.h"

@interface ReImprimirViewController ()

@end

@implementation ReImprimirViewController

@synthesize btnReImprimir;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PortAddressField = @"bluetooth";
    escp = [[ESCPOSPrinter alloc] init];
//    [self setUIConnected:FALSE];
    
    NSLog(@"Connect call\r\n");
    int errCode = 0;
    
    if((errCode = [escp openPort:PortAddressField withPortParam:9100]) >= 0)
    {
        [self setUIConnected:TRUE];
        NSLog(@"Connection Established\r\n");
    }
    else if(errCode == -3)
    {
        NSLog(@"ERROR: Invalid device\r\n");
    }
    else
    {
        NSLog(@"ERROR: Connection error\r\n");
    }

}

- (void) uiToggle:(UIButton*) uiObj mode:(BOOL) mode
{
    if(mode)
    {
        [uiObj setEnabled:TRUE];
        [uiObj setTitleColor:RGB(50,79,133) forState:UIControlStateNormal];
    }
    else
    {
        [uiObj setEnabled:FALSE];
        [uiObj setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

- (void) setUIConnected:(BOOL) isConnected
{
    // if connected.
    if(isConnected)
    {
        [self uiToggle:btnReImprimir mode:TRUE];
    }
    else
    {
        [self uiToggle:btnReImprimir mode:FALSE];
    }
}

- (void) messageBox:(NSString *) message withTitle:(NSString *) title
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    [alert show];
}

- (IBAction) ReImprimirMulta:(id) sender
{
    int errCode = 0;
    BOOL puedeImprimir = NO;
    
    if((errCode = [escp openPort:PortAddressField withPortParam:9100]) >= 0)
    {
        [self setUIConnected:TRUE];
        puedeImprimir = YES;
        NSLog(@"Connection Established\r\n");
    }
    else if(errCode == -3)
    {
        [self messageBox:@"El dispositivo al que intenta conectar es invalido" withTitle:@"Printer Status"];
        NSLog(@"ERROR: Invalid device\r\n");
    }
    else
    {
        [self messageBox:@"No está conectado a la impresora por favor encienda la impresora e intente de nuevo" withTitle:@"Printer Status"];
        NSLog(@"ERROR: Connection error\r\n");
    }
    
    if(puedeImprimir)
    {
        unsigned char centerAlign[3] = {0x1B,0x61,0x01};
        
        // read the reference manual enclosed the compressed file.
        
        NSString * imglogo = [[NSBundle mainBundle] pathForResource:@"logo_zapopan_contorno.jpg" ofType:nil];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        // getting an NSString
        
        NSString *imp_Folio = [prefs stringForKey:@"imp_Folio"];
        NSString *imp_Placa = [prefs stringForKey:@"imp_Placa"];
        NSString *imp_Entidad = [prefs stringForKey:@"imp_Entidad"];
        NSString *imp_Marca = [prefs stringForKey:@"imp_Marca"];
        NSString *imp_Vehiculo = [prefs stringForKey:@"imp_Vehiculo"];
        NSString *imp_Color = [prefs stringForKey:@"imp_Color"];
        NSString *imp_Concepto = [prefs stringForKey:@"imp_Concepto"];
        NSString *imp_Sancion = [prefs stringForKey:@"imp_Sancion"];
        NSString *imp_Direccion = [prefs stringForKey:@"imp_Direccion"];
        NSString *imp_Parquimetro = [prefs stringForKey:@"imp_Parquimetro"];
        NSString *imp_Espacio = [prefs stringForKey:@"imp_Espacio"];
        NSString *nombreUsuario = [prefs stringForKey:@"nombreUsuario"];
        NSString *usuario = [prefs stringForKey:@"usuario"];
        NSString *fecha = [prefs stringForKey:@"fecha"];
        
        
        NSString *myString = imp_Direccion;
        
        NSData *stringData = [myString dataUsingEncoding: NSASCIIStringEncoding allowLossyConversion: YES];
        
        NSString *cleanString = [[NSString alloc] initWithData: stringData encoding: NSASCIIStringEncoding];
        
        
        //Proceso para obtener el nombre de la foto a imprimir en el ticket
        NSString *nameFoto = [NSString stringWithFormat:@"%@-%@Min.jpg",imp_Folio, idFotoImprimir];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *ImagePath = [documentsDirectory stringByAppendingPathComponent:nameFoto];
        NSString * barCodeData = imp_Folio;
        barCodeData = [barCodeData
                       stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        NSString  *strLineToImpr = @"";
        
        NSString  *fullText = imp_Concepto;
        
        NSArray *fullTextArr = [fullText componentsSeparatedByString:@" "];
        
        
        // Proceso de impresion
        
        [escp printBitmap:imglogo withAlignment:ALIGNMENT_CENTER withSize:BITMAP_QUADRUPLE withBrightness:0];
        
        [escp printText:@"MUNICIPIO DE ZAPOPAN \r\n\r\n" withAlignment:ALIGNMENT_CENTER withOption:FNT_BOLD withSize:(TXT_2WIDTH|TXT_2HEIGHT)];
        
        [escp printText:@"ACTA DE NOTIFICACION DE INFRACCION\r\n" withAlignment:ALIGNMENT_CENTER withOption:FNT_BOLD withSize:TXT_1WIDTH];
        
        [escp printText:@"DE DIRECCION DE MOVILIDAD\r\n" withAlignment:ALIGNMENT_CENTER withOption:FNT_BOLD withSize:TXT_1WIDTH];
        
        [escp printText:@"Y TRANSPORTE DE ZAPOPAN \r\n" withAlignment:ALIGNMENT_CENTER withOption:FNT_BOLD withSize:TXT_1WIDTH];
        [escp lineFeed:1];
        
        [escp printText:@" FOLIO: " withAlignment:ALIGNMENT_LEFT withOption:FNT_DEFAULT withSize:TXT_1WIDTH];
        [escp printText:[NSString stringWithFormat:@"%@\r\n", imp_Folio] withAlignment:ALIGNMENT_LEFT withOption:FNT_BOLD withSize:TXT_1WIDTH];
        [escp lineFeed:1];
        [escp printText:@" FECHA: " withAlignment:ALIGNMENT_LEFT withOption:FNT_DEFAULT withSize:TXT_1WIDTH];
        [escp printText:[NSString stringWithFormat:@"%@\r\n", fecha] withAlignment:ALIGNMENT_LEFT withOption:FNT_BOLD withSize:TXT_1WIDTH	];
        [escp lineFeed:1];
        [escp printText:@" PLACAS: " withAlignment:ALIGNMENT_LEFT withOption:FNT_DEFAULT withSize:TXT_1WIDTH];
        [escp printText:[NSString stringWithFormat:@"%@\r\n", imp_Placa] withAlignment:ALIGNMENT_LEFT withOption:FNT_BOLD withSize:TXT_1WIDTH	];
        [escp lineFeed:1];
        [escp printText:@" ENTIDAD: " withAlignment:ALIGNMENT_LEFT withOption:FNT_DEFAULT withSize:TXT_1WIDTH];
        [escp printText:[NSString stringWithFormat:@"%@\r\n", imp_Entidad] withAlignment:ALIGNMENT_LEFT withOption:FNT_BOLD withSize:TXT_1WIDTH	];
        [escp lineFeed:1];
        [escp printText:@" MARCA: " withAlignment:ALIGNMENT_LEFT withOption:FNT_DEFAULT withSize:TXT_1WIDTH];
        [escp printText:[NSString stringWithFormat:@"%@\r\n", imp_Marca] withAlignment:ALIGNMENT_LEFT withOption:FNT_BOLD withSize:TXT_1WIDTH	];
        [escp lineFeed:1];
        [escp printText:@" DIRECCION: " withAlignment:ALIGNMENT_LEFT withOption:FNT_DEFAULT withSize:TXT_1WIDTH];
        [escp printText:[NSString stringWithFormat:@"%@\r\n", cleanString] withAlignment:ALIGNMENT_LEFT withOption:FNT_BOLD withSize:TXT_1WIDTH	];
        [escp lineFeed:1];
        if ([imp_Espacio  isEqual: @""])
        {
            //            [escp lineFeed:1];
        }
        else
        {
            [escp printText:@" ESPACIO: " withAlignment:ALIGNMENT_LEFT withOption:FNT_DEFAULT withSize:TXT_1WIDTH];
            [escp printText:[NSString stringWithFormat:@"%@", imp_Espacio] withAlignment:ALIGNMENT_LEFT withOption:FNT_BOLD withSize:TXT_1WIDTH	];
            //            [escp lineFeed:1];
        }
        
        if ([imp_Parquimetro  isEqual: @""])
        {
            //            [escp lineFeed:1];
        }
        else
        {
            [escp printText:@" APARATO: " withAlignment:ALIGNMENT_LEFT withOption:FNT_DEFAULT withSize:TXT_1WIDTH];
            [escp printText:[NSString stringWithFormat:@"%@", imp_Parquimetro] withAlignment:ALIGNMENT_LEFT withOption:FNT_BOLD withSize:TXT_1WIDTH	];
            [escp lineFeed:2];
        }
        [escp printText:@" VIGILANTE: " withAlignment:ALIGNMENT_LEFT withOption:FNT_DEFAULT withSize:TXT_1WIDTH];
        [escp printText:[NSString stringWithFormat:@"%@\r\n", usuario] withAlignment:ALIGNMENT_LEFT withOption:FNT_BOLD withSize:TXT_1WIDTH	];
        [escp lineFeed:1];
        
        
        [escp printText:@" SANCION: \r\n" withAlignment:ALIGNMENT_LEFT withOption:FNT_DEFAULT withSize:TXT_1WIDTH];
        
        for (int x=0; x < fullTextArr.count; x++) {
            
            strLineToImpr = [strLineToImpr stringByAppendingString: fullTextArr[x]];
            strLineToImpr = [strLineToImpr stringByAppendingString: @" "];
            if (x != 0 && (x % 5) == 0) {
                
                NSLog(@"Linea %d: %@", x, strLineToImpr);
                [escp printString:[NSString stringWithFormat:@"   %@\n\r", strLineToImpr]];
                strLineToImpr = @"";
            }
            else if (x == fullTextArr.count-1)
            {
                [escp printString:[NSString stringWithFormat:@"   %@\n\r", strLineToImpr]];
                NSLog(@"Linea %d: %@", x, strLineToImpr);
            }
        }
        
        [escp lineFeed:1];
        
        [escp printText:@" MONTO: " withAlignment:ALIGNMENT_LEFT withOption:FNT_DEFAULT withSize:TXT_1WIDTH];
        [escp printText:[NSString stringWithFormat:@"$%@\r\n", imp_Sancion] withAlignment:ALIGNMENT_LEFT withOption:FNT_BOLD withSize:TXT_1WIDTH	];
        
        
        [escp lineFeed:6];
        
        [escp printText:[NSString stringWithFormat:@"%@\r\n", nombreUsuario] withAlignment:ALIGNMENT_CENTER withOption:FNT_BOLD withSize:TXT_1WIDTH	];
        
        [escp lineFeed:2];
        
        [escp printBarCode:barCodeData withSymbology:BCS_CODE93 withHeight:70 withWidth:BCS_3WIDTH withAlignment:ALIGNMENT_CENTER withHRI:HRI_TEXT_NONE];
        
        [escp lineFeed:4];
        
        [escp printBitmap:ImagePath withAlignment:ALIGNMENT_CENTER withSize:BITMAP_NORMAL withBrightness:5];
        [escp lineFeed:4];
      
    }
    else{
        
//        AppDelegate *appDelegate = (AppDelegate *)[[[UIApplication sharedApplication] delegate];
//        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        AppDelegate *appdelegate = (AppDelegate<UIApplicationDelegate>*)[[UIApplication sharedApplication] delegate];
        
        NSManagedObjectContext *context = [appdelegate managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"MUL_Multas" inManagedObjectContext:context];
        
        [fetchRequest setEntity:entity];
        
        NSError *error;
        
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        NSManagedObject *ultimoRegistro = [fetchedObjects objectAtIndex:fetchedObjects.count-1];
        
        NSLog(@"\n");
        NSLog(@"inf_Id: %@", [ultimoRegistro valueForKey:@"inf_Id"]);
        NSLog(@"mul_Color: %@", [ultimoRegistro valueForKey:@"mul_Color"]);
        NSLog(@"mul_Concepto: %@", [ultimoRegistro valueForKey:@"mul_Concepto"]);
        NSLog(@"mul_Direccion: %@", [ultimoRegistro valueForKey:@"mul_Direccion"]);
        NSLog(@"mul_Espacio: %@", [ultimoRegistro valueForKey:@"mul_Espacio"]);
        NSLog(@"mul_Estado: %@", [ultimoRegistro valueForKey:@"mul_Estado"]);
        NSLog(@"mul_Folio: %@", [ultimoRegistro valueForKey:@"mul_Folio"]);
        NSLog(@"mul_Id: %@", [ultimoRegistro valueForKey:@"mul_Id"]);
        NSLog(@"mul_Latitud: %@", [ultimoRegistro valueForKey:@"mul_Latitud"]);
        NSLog(@"mul_Longitud: %@", [ultimoRegistro valueForKey:@"mul_Longitud"]);
        NSLog(@"mul_Marca: %@", [ultimoRegistro valueForKey:@"mul_Marca"]);
        NSLog(@"mul_Placa: %@", [ultimoRegistro valueForKey:@"mul_Placa"]);
        NSLog(@"mul_Sancion: %@", [ultimoRegistro valueForKey:@"mul_Sancion"]);
        NSLog(@"par_Id: %@", [ultimoRegistro valueForKey:@"par_Id"]);

        
//        for (NSManagedObject *info in fetchedObjects) {
//
//            NSLog(@"\n");
//            NSLog(@"inf_Id: %@", [info valueForKey:@"inf_Id"]);
//            NSLog(@"mul_Color: %@", [info valueForKey:@"mul_Color"]);
//            NSLog(@"mul_Concepto: %@", [info valueForKey:@"mul_Concepto"]);
//            NSLog(@"mul_Direccion: %@", [info valueForKey:@"mul_Direccion"]);
//            NSLog(@"mul_Espacio: %@", [info valueForKey:@"mul_Espacio"]);
//            NSLog(@"mul_Estado: %@", [info valueForKey:@"mul_Estado"]);
//            NSLog(@"mul_Folio: %@", [info valueForKey:@"mul_Folio"]);
//            NSLog(@"mul_Id: %@", [info valueForKey:@"mul_Id"]);
//            NSLog(@"mul_Latitud: %@", [info valueForKey:@"mul_Latitud"]);
//            NSLog(@"mul_Longitud: %@", [info valueForKey:@"mul_Longitud"]);
//            NSLog(@"mul_Marca: %@", [info valueForKey:@"mul_Marca"]);
//            NSLog(@"mul_Placa: %@", [info valueForKey:@"mul_Placa"]);
//            NSLog(@"mul_Sancion: %@", [info valueForKey:@"mul_Sancion"]);
//            NSLog(@"par_Id: %@", [info valueForKey:@"par_Id"]);
//        }

    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [escp closePort];
    NSLog(@"Disconnect call\r\n");
    [self setUIConnected:FALSE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
