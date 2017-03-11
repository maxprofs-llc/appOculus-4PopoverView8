//
//  ESCPOS_ViewController.m
//  iOS
//
//  Created by Isai Garcia Reyes on 02/02/17.
//  Copyright © 2017 Isai Garcia Reyes. All rights reserved.
//

#import "ESCPOS_ViewController.h"

@implementation ESCPOS_ViewController

@synthesize btnImprimir;
@synthesize btnRegresar;
@synthesize btnIrMenu;

int idImpresion;
 
/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

/////////////////////////////////
// run once at App start.
- (void) viewDidLoad
{
    idImpresion = 0;
    PortAddressField = @"bluetooth";
    escp = [[ESCPOSPrinter alloc] init];
    [self setUIConnected:FALSE];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusCheckReceived:) name:EADSessionDataReceivedNotification object:nil];
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
    
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
        [self messageBox:@"El dispositivo al que intenta conectar es invalido" withTitle:@"Printer Status"];

    }
    else
    {
        NSLog(@"ERROR: Connection error\r\n");
         [self messageBox:@"No está conectado a la impresora por favor encienda la impresora e intente de nuevo" withTitle:@"Printer Status"];
    }
    
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
////////////////////////////////


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
		[self uiToggle:openButton mode:FALSE ];
		[self uiToggle:closeButton mode:TRUE];
		[self uiToggle:btnImprimir mode:TRUE];
		
	}
	else
	{
		[self uiToggle:openButton mode:TRUE];
		[self uiToggle:closeButton mode:FALSE];
        [self uiToggle:btnImprimir mode:FALSE];
    }
}

- (void) messageBox:(NSString *) message withTitle:(NSString *) title
{
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
	[alert show];
}

// Receipt
- (IBAction) sample01Proc:(id) sender;
{
	// Command -- Font Size, Alignment
	unsigned char normalSize[3] = {0x1D,0x21,0x00};
	unsigned char dWidthSize[3] = {0x1D,0x21,0x10};
	unsigned char centerAlign[3] = {0x1B,0x61,0x01};
	unsigned char rightAlign[3] = {0x1B,0x61,0x02};
	
	// read the reference manual enclosed the compressed file.
	NSString* barCodeData = @"2132132132131";
	unsigned char barCode128[4] = {0x1D,0x6B,0x73,[barCodeData length]};
	unsigned char barCodeWidth[3] = {0x1D,0x77,0x03};
	unsigned char barCodeHeight[3] = {0x1D,0x68,0x85};
	unsigned char barCodeHRI[3] = {0x1D,0x48,0x02};

	[escp printNVBitmap:1 withAlignment:ALIGNMENT_RIGHT withSize:BITMAP_NORMAL];
	[escp printData:dWidthSize withLength:sizeof(dWidthSize)];				   
	[escp printData:centerAlign withLength:sizeof(centerAlign)];				   
	[escp printString:@"Receipt\r\n\r\n"];
	
	[escp printData:normalSize withLength:sizeof(normalSize)];				   
	[escp printData:rightAlign withLength:sizeof(rightAlign)];				   
	[escp printString:@"TEL (123)-456-7890\r\n"];
	
	[escp printData:centerAlign withLength:sizeof(centerAlign)];				   
	[escp printString:@"Thank you for coming to our shop!\r\n\r\n"];
	
	[escp printString:@"Chicken                   $10.00\r\n"];
	[escp printString:@"Hamburger                 $20.00\r\n"];
	[escp printString:@"Pizza                     $30.00\r\n"];
	[escp printString:@"Lemons                    $40.00\r\n"];
	[escp printString:@"Drink                     $50.00\r\n"];
	[escp printString:@"Excluded tax             $150.00\r\n\r\n"];
	
	[escp printData:rightAlign withLength:sizeof(rightAlign)];				   
	[escp printString:@"Tax(5%)                    $7.50\r\n"];
	[escp printString:@"Total                    $157.50\r\n"];
	[escp printString:@"Payment                  $200.00\r\n"];
	[escp printString:@"Change                    $42.50\r\n\r\n\r\n"];
	
	[escp printData:centerAlign withLength:sizeof(centerAlign)];				   
	[escp printData:barCodeWidth withLength:sizeof(barCodeWidth)];
	[escp printData:barCodeHeight withLength:sizeof(barCodeHeight)];
	[escp printData:barCodeHRI withLength:sizeof(barCodeHRI)];
	[escp printData:barCode128 withLength:sizeof(barCode128)];
	[escp printString:barCodeData];
	// 4 Line Feed
	[escp lineFeed:4];
}

// Receipt -- printText() 
- (IBAction) imprimirMulta:(id) sender
{
    idImpresion += 1;
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
        unsigned char centerAlign[3] = {0x1B,0x61,0x01};
        
        [escp setDithering: ERROR_DIFFUSION_DITHERING];
        
        
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
//        [escp printString:@"12345678901234567890123456789012345678901234567890"];
        [escp setDithering: THRESHOLDING_DITHERING];
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
       
        NSString *LineaSig = @"";
        
        for (int x=0; x < fullTextArr.count; x++) {
            
            strLineToImpr = [strLineToImpr stringByAppendingString: fullTextArr[x]];
            strLineToImpr = [strLineToImpr stringByAppendingString: @" "];
            if (x != 0 && x < fullTextArr.count-1) {
                LineaSig = [strLineToImpr stringByAppendingString: fullTextArr[x + 1]];
                if (LineaSig.length < 40){
                    strLineToImpr = LineaSig;
                    strLineToImpr = [strLineToImpr stringByAppendingString: @" "];
                    x += 1;
                }
                else {
                    if (LineaSig.length > 40){
                        LineaSig = strLineToImpr;
                    }
                    NSLog(@"Linea %d: %@", x, strLineToImpr);
                    [escp printString:[NSString stringWithFormat:@" %@\n\r", strLineToImpr]];
                    strLineToImpr = @"";
                    
                }
            }

            if (x == fullTextArr.count-1){
                [escp printString:[NSString stringWithFormat:@" %@\n\r", strLineToImpr]];
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
        [escp setDithering: ERROR_DIFFUSION_DITHERING];
        [escp printBitmap:ImagePath withAlignment:ALIGNMENT_CENTER withSize:BITMAP_NORMAL withBrightness:5];
        [escp lineFeed:4];
        
        if(idImpresion == 1)
        {
            [self.btnImprimir setTitle:@"Imprimir Copia" forState:UIControlStateNormal];
            [self uiToggle:btnRegresar mode:FALSE];
            [self uiToggle:btnIrMenu mode:FALSE];
        }
        if(idImpresion == 2)
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


- (IBAction) barcode1DTestProc:(id) sender
{
	NSString * barCodeData = @"123456789012";
	
	[escp printString:@"UPCA\r\n"];
	[escp printBarCode:barCodeData withSymbology:BCS_UPCA withHeight:70 withWidth:BCS_3WIDTH withAlignment:ALIGNMENT_CENTER withHRI:HRI_TEXT_BELOW];
	[escp printString:@"UPCE\r\n"];
	[escp printBarCode:barCodeData withSymbology:BCS_UPCE withHeight:70 withWidth:BCS_3WIDTH withAlignment:ALIGNMENT_CENTER withHRI:HRI_TEXT_BELOW];
	[escp printString:@"EAN8\r\n"];
	[escp printBarCode:@"1234567" withSymbology:BCS_EAN8 withHeight:70 withWidth:BCS_3WIDTH withAlignment:ALIGNMENT_CENTER withHRI:HRI_TEXT_BELOW];
	[escp printString:@"EAN13\r\n"];
	[escp printBarCode:barCodeData withSymbology:BCS_EAN13 withHeight:70 withWidth:BCS_3WIDTH withAlignment:ALIGNMENT_CENTER withHRI:HRI_TEXT_BELOW];
	[escp printString:@"CODE39\r\n"];
	[escp printBarCode:@"ABCDEFGHI" withSymbology:BCS_CODE39 withHeight:70 withWidth:BCS_3WIDTH withAlignment:ALIGNMENT_CENTER withHRI:HRI_TEXT_BELOW];
	[escp printString:@"ITF\r\n"];
	[escp printBarCode:barCodeData withSymbology:BCS_ITF withHeight:70 withWidth:BCS_3WIDTH withAlignment:ALIGNMENT_CENTER withHRI:HRI_TEXT_BELOW];
	[escp printString:@"CODABAR\r\n"];
	[escp printBarCode:barCodeData withSymbology:BCS_CODABAR withHeight:70 withWidth:BCS_3WIDTH withAlignment:ALIGNMENT_CENTER withHRI:HRI_TEXT_BELOW];
	[escp printString:@"\r\n"];
	[escp printBarCode:barCodeData withSymbology:BCS_CODE93 withHeight:70 withWidth:BCS_3WIDTH withAlignment:ALIGNMENT_CENTER withHRI:HRI_TEXT_BELOW];
	[escp printString:@"CODE128\r\n"];
	[escp printBarCode:@"{BNo.{C4567890120" withSymbology:BCS_CODE128 withHeight:70 withWidth:BCS_3WIDTH withAlignment:ALIGNMENT_CENTER withHRI:HRI_TEXT_BELOW];
	[escp lineFeed:3];
}

- (IBAction) BitmapTestProc:(id) sender
{
	
	NSString * imgfile1 = [[NSBundle mainBundle] pathForResource:@"sample_1.jpg" ofType:nil];
	NSString * imgfile2 = [[NSBundle mainBundle] pathForResource:@"sample_2.jpg" ofType:nil];
	NSString * imgfile3 = [[NSBundle mainBundle] pathForResource:@"sample_3.jpg" ofType:nil];
	NSString * imgfile4 = [[NSBundle mainBundle] pathForResource:@"sample_4.jpg" ofType:nil];

	[escp printBitmap:imgfile1 withAlignment:ALIGNMENT_CENTER withSize:BITMAP_NORMAL withBrightness:5];
	[escp printBitmap:imgfile2 withAlignment:ALIGNMENT_LEFT withSize:BITMAP_NORMAL withBrightness:5];
	[escp printBitmap:imgfile3 withAlignment:ALIGNMENT_RIGHT withSize:BITMAP_NORMAL withBrightness:5];
	
	[escp printBitmap:imgfile4 withAlignment:ALIGNMENT_LEFT withSize:BITMAP_QUADRUPLE withBrightness:0];
	[escp printBitmap:imgfile4 withAlignment:ALIGNMENT_LEFT withSize:BITMAP_DOUBLE_WIDTH withBrightness:10];
	
	[escp lineFeed:5];
}

- (IBAction) LogoTestProc:(id) sender
{
	// pre-saved image data : 1-255
	[escp printNVBitmap:1 withAlignment:ALIGNMENT_CENTER withSize:BITMAP_NORMAL];
	[escp lineFeed:3];
}

- (IBAction) pdf417TestProc:(id) sender
{
	NSString * barCodeData = @"ABCDEFGHIJKLMN";
	int length = [barCodeData length];

	
	[escp printString:@"PDF417 Column=3 , Cell Width = 2\r\n"];
	[escp printPDF417:barCodeData withLength:length withColumns:3 withCellWidth:2 withAlignment:ALIGNMENT_CENTER];
	[escp printString:@"PDF417 Column=4 , Cell Width = 2\r\n"];
	[escp printPDF417:barCodeData withLength:length withColumns:4 withCellWidth:2 withAlignment:ALIGNMENT_CENTER];
	[escp printString:@"PDF417 Column=5 , Cell Width = 2\r\n"];
	[escp printPDF417:barCodeData withLength:length withColumns:5 withCellWidth:2 withAlignment:ALIGNMENT_CENTER];
	[escp printString:@"PDF417 Column=6 , Cell Width = 2\r\n"];
	[escp printPDF417:barCodeData withLength:length withColumns:6 withCellWidth:2 withAlignment:ALIGNMENT_CENTER];
	[escp printString:@"PDF417 Column=7 , Cell Width = 2\r\n"];
	[escp printPDF417:barCodeData withLength:length withColumns:7 withCellWidth:2 withAlignment:ALIGNMENT_CENTER];
	[escp printString:@"PDF417 Column=8 , Cell Width = 2\r\n"];
	[escp printPDF417:barCodeData withLength:length withColumns:8 withCellWidth:2 withAlignment:ALIGNMENT_CENTER];


	[escp printString:@"PDF417 Column=4 , Cell Width = 1\r\n"];
	[escp printPDF417:barCodeData withLength:length withColumns:4 withCellWidth:1 withAlignment:ALIGNMENT_LEFT];
	[escp printString:@"PDF417 Column=4 , Cell Width = 5\r\n"];
	[escp printPDF417:barCodeData withLength:length withColumns:4 withCellWidth:5 withAlignment:ALIGNMENT_CENTER];
	[escp printString:@"PDF417 Column=1 , Cell Width = 6\r\n"];
	[escp printPDF417:barCodeData withLength:length withColumns:1 withCellWidth:6 withAlignment:ALIGNMENT_RIGHT];
	[escp lineFeed:3];
}

- (IBAction) qrcodeTestProc:(id) sender
{
	NSString * barCodeData = @"ABCDEFGHIJKLMN";
	int length = [barCodeData length];

	[escp printString:@"QR Left Alignment\r\n"];
	[escp printQRCode:barCodeData withLength:length withModuleSize:3 withECLevel:0 withAlignment:ALIGNMENT_LEFT];
	[escp printString:@"QR Center Alignment\r\n"];
	[escp printQRCode:barCodeData withLength:length withModuleSize:3 withECLevel:0 withAlignment:ALIGNMENT_CENTER];
	[escp printString:@"QR Right Alignment\r\n"];
	[escp printQRCode:barCodeData withLength:length withModuleSize:3 withECLevel:0 withAlignment:ALIGNMENT_RIGHT];
	[escp lineFeed:3];
}


- (IBAction) printerCheckProc:(id) sender
{
	[escp printerCheck];
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
    if(sts == STS_NORMAL)
    {
        [self messageBox:@"Normal" withTitle:@"Printer Status"];
    }
    else
    {
        if((sts & STS_COVEROPEN) > 0)
        {
            result = [result stringByAppendingString:@"Cover Open\r\n"];
        }
        if((sts & STS_PAPEREMPTY) > 0)
        {
            result = [result stringByAppendingString:@"Paper Empty\r\n"];
        }
        [self messageBox:result withTitle:@"Printer Status"];
    }
#ifdef DEBUG
    NSLog(@"===== Status Check EXIT =====");
#endif
}

- (void)viewDidDisappear:(BOOL)animated {
    [escp closePort];
    NSLog(@"Disconnect call\r\n");
    [self setUIConnected:FALSE];
}


- (void)didReceiveMemoryWarning
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


//*******************************************
- (void)initializeCoreData
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
@end
