//
//  ReImprimirViewController.h
//  appOculus
//
//  Created by Jorge I. Garcia Reyes on 20/02/17.
//  Copyright © 2017 Javier Cortes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESCPOSPrinter.h"
#import "EABluetoothPort.h"
#import "CoreData/CoreData.h"
#import "appOculus-Bridging-Header.h"
#import "appOculus-Swift.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface ReImprimirViewController : UIViewController
{
    ESCPOSPrinter *escp;
    NSString *PortAddressField;
}

@property (nonatomic, retain) IBOutlet UIButton *btnReImprimir;
@property (weak) NSManagedObjectContext *mContext;

- (IBAction) ReImprimirMulta:(id) sender;

@end
