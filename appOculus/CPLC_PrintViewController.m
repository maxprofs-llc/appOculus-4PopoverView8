//
//  CPLC_PrintViewController.m
//  appOculus
//
//  Created by Isai Garcia Reyes on 04/03/17.
//  Copyright © 2017 Javier Cortes. All rights reserved.
//

#import "CPLC_PrintViewController.h"

@interface CPLC_PrintViewController ()

@end

@implementation CPLC_PrintViewController

@synthesize btnImprimir;
@synthesize btnRegresar;
@synthesize btnIrMenu;

int idImpresionCPLC;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    idImpresionCPLC = 0;
    PortAddressField = @"bluetooth";
    cpclPrinter = [[CPCLPrinter alloc] init];
    [self setUIConnected:FALSE];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusCheckReceived:) name:EADSessionDataReceivedNotification object:nil];
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
    
    int errCode = 0;

    if((errCode = [cpclPrinter openPort:PortAddressField withPortParam:9100]) >= 0) {
        [self setUIConnected:TRUE];
        NSLog(@"Connection Established.");
    }
    else if(errCode == -3) {
        NSLog(@"err Conn -3");
        [self messageBox:@"El dispositivo al que intenta conectar es invalido" withTitle:@"Printer Status"];
        [self messageBox:@"No está conectado a la impresora por favor encienda la impresora e intente de nuevo" withTitle:@"Printer Status"];
    }
    else {
        NSLog(@"err Conn else");
    }
    
    NSLog(@"sizeof(int) = %ld", sizeof(int));
    NSLog(@"sizeof(long) = %ld", sizeof(long));
    
    btnImprimir.layer.cornerRadius = 7;
    btnImprimir.layer.borderWidth = 1;
    btnImprimir.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor grayColor]);
    btnImprimir.clipsToBounds = YES;
    
    btnRegresar.layer.cornerRadius = 7;
    btnRegresar.layer.borderWidth = 1;
    btnRegresar.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor grayColor]);
    btnRegresar.clipsToBounds = YES;
    
    btnIrMenu.layer.cornerRadius = 7;
    btnIrMenu.layer.borderWidth = 1;
    btnIrMenu.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor grayColor]);
    btnIrMenu.clipsToBounds = YES;

}

- (IBAction) imprimirMultaCPLC:(id) sender
{
    idImpresionCPLC += 1;
    int errCode = 0;
    BOOL puedeImprimir = NO;
    
    puedeImprimir = YES;
    
    //    if((errCode = [escp openPort:PortAddressField withPortParam:9100]) >= 0)
    //    {
    //        [self setUIConnected:TRUE];
    //        puedeImprimir = YES;
    //        NSLog(@"Connection Established\r\n");
    //    }
    //    else if(errCode == -3)
    //    {
    //        [self messageBox:@"El dispositivo al que intenta conectar es invalido" withTitle:@"Printer Status"];
    //        NSLog(@"ERROR: Invalid device\r\n");
    //    }
    //    else
    //    {
    //        [self messageBox:@"No está conectado a la impresora por favor encienda la impresora e intente de nuevo" withTitle:@"Printer Status"];
    //        NSLog(@"ERROR: Connection error\r\n");
    //    }
    
    if(puedeImprimir)
    {
        
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
        
        [cpclPrinter setForm:0 withResX:200 withResY:200 withLabelHeight:406 withQuantity:1];
        [cpclPrinter setMedia:CPCL_CONTINUOUS];
        
        [cpclPrinter printBitmap:imglogo withPrintX:1 withPrintY:200 withBrightness:5];
        
        [cpclPrinter printCPCLText:0 withFontType:0 withFontSize:0 withPrintX:1 withPrintY:1 withData:@"MUNICIPIO DE ZAPOPAN \r\n\r\n" withCount:0];
        [cpclPrinter printCPCLText:0 withFontType:1 withFontSize:0 withPrintX:1 withPrintY:20 withData:@"ACTA DE NOTIFICACION DE INFRACCION\r\n" withCount:0];
        [cpclPrinter printCPCLText:0 withFontType:2 withFontSize:0 withPrintX:1 withPrintY:70 withData:@"ACTA DE NOTIFICACION DE INFRACCION\r\n" withCount:0];
        [cpclPrinter printCPCLText:0 withFontType:4 withFontSize:0 withPrintX:1 withPrintY:100 withData:@"DE DIRECCION DE MOVILIDAD\r\n" withCount:0];
        [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:150 withData:@"Y TRANSPORTE DE ZAPOPAN \r\n" withCount:0];
        
       	[cpclPrinter setMultiLine:1];
        
        [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:180 withData:@" FOLIO: " withCount:0];
        [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:210 withData:[NSString stringWithFormat:@"%@\r\n", imp_Folio] withCount:0];

       	[cpclPrinter setMultiLine:2];
        
        [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:240 withData:@" FECHA: " withCount:0];
        [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:270 withData:[NSString stringWithFormat:@"%@\r\n", fecha] withCount:0];
        
        [cpclPrinter setMultiLine:3];
        
        [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:300 withData:@" PLACAS: " withCount:0];
        [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:330 withData:[NSString stringWithFormat:@"%@\r\n", imp_Placa] withCount:0];
        
        [cpclPrinter setMultiLine:4];
        
        [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:300 withData:@" ENTIDAD: " withCount:0];
        [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:330 withData:[NSString stringWithFormat:@"%@\r\n", imp_Entidad] withCount:0];
        
        [cpclPrinter setMultiLine:5];
        
        [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:360 withData:@" MARCA: " withCount:0];
        [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:390 withData:[NSString stringWithFormat:@"%@\r\n", imp_Marca] withCount:0];
        
        [cpclPrinter setMultiLine:6];
        
        [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:410 withData:@" DIRECCION: "  withCount:0];
        [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:440 withData:[NSString stringWithFormat:@"%@\r\n", cleanString] withCount:0];
        
        [cpclPrinter setMultiLine:7];
        
        if ([imp_Espacio  isEqual: @""]) {
            //            [escp lineFeed:1];
        }
        else {
            [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:470 withData:@" ESPACIO: "  withCount:0];
            [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:500 withData:[NSString stringWithFormat:@"%@\r\n", imp_Espacio] withCount:0];
        }
        
        if ([imp_Parquimetro  isEqual: @""])
        {
            //            [escp lineFeed:1];
        }
        else
        {
            [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:530 withData:@" APARATO: "  withCount:0];
            [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:560 withData:[NSString stringWithFormat:@"%@\r\n", imp_Parquimetro] withCount:0];
            
          [cpclPrinter setMultiLine:6];
        }
        
        [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:530 withData:@" VIGILANTE: "  withCount:0];
        [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:560 withData:[NSString stringWithFormat:@"%@\r\n", usuario] withCount:0];
        
        [cpclPrinter setMultiLine:5];
        
        [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:590 withData:@" SANCION: \r\n"  withCount:0];

        
        for (int x=0; x < fullTextArr.count; x++) {
            
            strLineToImpr = [strLineToImpr stringByAppendingString: fullTextArr[x]];
            strLineToImpr = [strLineToImpr stringByAppendingString: @" "];
            if (x != 0 && (x % 5) == 0) {
                
                NSLog(@"Linea %d: %@", x, strLineToImpr);
                [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:610+(x*30) withData:[NSString stringWithFormat:@"   %@\n\r", strLineToImpr]  withCount:0];
                strLineToImpr = @"";
            }
            else if (x == fullTextArr.count-1)
            {
                [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:900 withData:[NSString stringWithFormat:@"   %@\n\r", strLineToImpr]  withCount:0];
                NSLog(@"Linea %d: %@", x, strLineToImpr);
            }
        }
        
        [cpclPrinter setMultiLine:4];
        
        [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:930 withData:@" MONTO: "  withCount:0];
        [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:960 withData:[NSString stringWithFormat:@"%@\r\n", imp_Sancion] withCount:0];

        [cpclPrinter setMultiLine:3];
        
        [cpclPrinter printCPCLText:0 withFontType:5 withFontSize:0 withPrintX:1 withPrintY:990 withData:[NSString stringWithFormat:@"%@\r\n", nombreUsuario] withCount:0];
        
        [cpclPrinter setMultiLine:2];
        [cpclPrinter printCPCLText:CPCL_0_ROTATION withFontType:7 withFontSize:0 withPrintX:19 withPrintY:18 withData:barCodeData withCount:0];
        [cpclPrinter setCPCLBarcode:0 withFontSize:0 withOffset:0];
        
        [cpclPrinter setMultiLine:1];
        
         [cpclPrinter printBitmap:ImagePath withPrintX:150 withPrintY:150 withBrightness:5];
        
        [cpclPrinter setMultiLine:1];
        
        [cpclPrinter printForm];
        
        if(idImpresionCPLC == 1)
        {
            [self.btnImprimir setTitle:@"Imprimir Copia" forState:UIControlStateNormal];
            [self uiToggle:btnRegresar mode:FALSE];
            [self uiToggle:btnIrMenu mode:FALSE];
        }
        if(idImpresionCPLC == 2)
        {
            [self.btnImprimir setTitle:@"Imprimir Multa" forState:UIControlStateNormal];
            [self uiToggle:btnRegresar mode:TRUE];
            [self uiToggle:btnIrMenu mode:TRUE];
            [self uiToggle:btnImprimir mode:FALSE];
        }
    }

}

-(IBAction)Regresar:(id)sender{
    
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    self.view = nil;
    
}

-(IBAction)IrAlMenu:(id)sender{
    
    UIStoryboard *storyboard = self.storyboard;
    
    UIViewController *menuViewController = [storyboard instantiateViewControllerWithIdentifier:@"homeView"];
    menuViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:menuViewController animated:YES completion:^{
        NSLog(@"Se presento la vista multas");
    }];
}

- (void) setUIConnected:(BOOL) isConnected
{
    // if connected.
    if(isConnected)
    {
        [self uiToggle:btnImprimir mode:TRUE];
    }
    else
    {
        [self uiToggle:btnImprimir mode:FALSE];
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

- (void) messageBox:(NSString *) message withTitle:(NSString *) title
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    [alert show];
}

- (void) statusCheckReceived:(NSNotification *) notification
{
    uint32_t bytesAvailable = 0;
    uint32_t readLength = 0;
    unsigned char buf[8] = {0,};
    EABluetoothPort * sessionController = (EABluetoothPort *)[notification object];
    NSString * result = [[NSString alloc] init];
#ifdef DEBUG
    NSLog(@"===== Status Check START =====");
#endif
    NSMutableData * readData = [[NSMutableData alloc] init];
    while((bytesAvailable = [sessionController readBytesAvailable]) > 0)
    {
        NSData * data = [sessionController readData:bytesAvailable];
        if(data)
        {
            [readData appendData:data];
            readLength = readLength + bytesAvailable;
        }
    }
    if(readLength > sizeof(buf))
        readLength = sizeof(buf);
    [readData getBytes:buf length:readLength];
    
    int sts = buf[readLength - 1];
//    if(sts == STS_NORMAL)
//    {
//        [self messageBox:@"Normal" withTitle:@"Printer Status"];
//    }
//    else
//    {
//        if((sts & STS_COVEROPEN) > 0)
//        {
//            result = [result stringByAppendingString:@"Cover Open\r\n"];
//        }
//        if((sts & STS_PAPEREMPTY) > 0)
//        {
//            result = [result stringByAppendingString:@"Paper Empty\r\n"];
//        }
        [self messageBox:result withTitle:@"Printer Status"];
//    }
#ifdef DEBUG
    NSLog(@"===== Status Check EXIT =====");
#endif
}

//*******************************************
- (void)initializeCoreDataCPLC
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(mom != nil, @"Error initializing Managed Object Model");
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [moc setPersistentStoreCoordinator:psc];
    [self setManagedObjectContext:moc];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"DataModel.sqlite"];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSError *error = nil;
        NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        NSAssert(store != nil, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
