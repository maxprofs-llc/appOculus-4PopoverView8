//
//  TomarFotoViewController.h
//  appOculus
//
//  Created by Isai Garcia Reyes on 02/02/17.
//  Copyright © 2017 Isai Garcia Reyes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appOculus-Bridging-Header.h"

@interface TomarFotoViewController : UIViewController <UIImagePickerControllerDelegate>
{
    int tag;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView2;
@property (nonatomic, retain) IBOutlet UIImageView *imageView3;


@end
