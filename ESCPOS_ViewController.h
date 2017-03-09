//
//  ESCPOS_ViewController.h
//  iOS
//
//  Created by Isai Garcia Reyes on 02/02/17.
//  Copyright © 2017 Isai Garcia Reyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESCPOSPrinter.h"
#import "CallbackData.h"
#import "EABluetoothPort.h"
#import "CoreData/CoreData.h"
#import "GlobalMembers.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface ESCPOS_ViewController : UIViewController
{
	UIButton *openButton;
	UIButton *closeButton;
 
	ESCPOSPrinter *escp;
    NSString *PortAddressField;
}

@property (strong, nonatomic) IBOutlet UIButton *btnImprimir;
@property (nonatomic, retain) IBOutlet UIButton *btnRegresar;
@property (nonatomic, retain) IBOutlet UIButton *btnIrMenu;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSString *someProperty;

- (void)initializeCoreData;

- (IBAction) sample01Proc:(id) sender;
- (IBAction) imprimirMulta:(id) sender;

@end

