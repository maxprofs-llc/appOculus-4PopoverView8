//
//  CPLC_PrintViewController.h
//  appOculus
//
//  Created by Isai Garcia Reyes on 04/03/17.
//  Copyright © 2017 Javier Cortes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EABluetoothPort.h"
#import "CoreData/CoreData.h"
#import "GlobalMembers.h"
#import "CPCLPrinter.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface CPLC_PrintViewController : UIViewController
{
    CPCLPrinter * cpclPrinter;
    NSString *PortAddressField;
}

@property (strong, nonatomic) IBOutlet UIButton *btnImprimir;
@property (nonatomic, retain) IBOutlet UIButton *btnRegresar;
@property (nonatomic, retain) IBOutlet UIButton *btnIrMenu;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)initializeCoreDataCPLC;
- (IBAction) imprimirMultaCPLC:(id) sender;

@end
