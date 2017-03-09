//
//  TomarFotoViewController.m
//  appOculus
//
//  Created by Isai Garcia Reyes on 02/02/17.
//  Copyright © 2017 Isai Garcia Reyes. All rights reserved.
//

#import "TomarFotoViewController.h"

@interface TomarFotoViewController ()

@end

@implementation TomarFotoViewController

@synthesize imageView;
@synthesize imageView2;
@synthesize imageView3;

UIButton *button;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NetMessage:)
                                                 name:@"InternetConnectionStatus"
                                               object:nil];
}

-(void)NetMessage:(NSNotification *)notification
{
    NSDictionary *messageDict = [notification object];
    NSString * messageString = [messageDict objectForKey:@"medium"];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oculus App 🍁"
                                                   message:messageString
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil, nil];
    [alert show];
    alert = nil;

}

- (BOOL)isInternetAvailable {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        return YES;
    }
    return NO;
}
- (void) reachabilityChanged: (NSNotification* )note{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            //NSLog(@"Network available via 3G or 4G.");
            break;
        }
        case ReachableViaWiFi:
        {
            //NSLog(@"Network available via WIFI.");
            break;
        }
        case NotReachable:
        {
            
            //NSLog(@"Network unavailable.");
            break;
        }
    }
}

- (IBAction)selectPhotos:(id)sender
{
    tag = [sender tag];
    
    button = (UIButton *)sender;
    
    [self actionLaunchAppCamera];
}

-(void)actionLaunchAppCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        
        [self presentModalViewController:imagePicker animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera Unavailable"
                                                       message:@"Unable to find a camera on your device."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    if(!img) img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    switch (tag) {
        case 1:
            self.imageView.image = img;
            break;
        case 2:
            self.imageView2.image = img;
            break;
        case 3:
            self.imageView3.image = img;
            break;
            
        default:
            break;
    }
    
    CGRect rect = CGRectMake(0,0,100,100);
    UIImage *imgMinumunSize = [self imageResize:img andResizeTo:rect.size];
    
    [self saveImageInDirectory:img idImage:[NSString stringWithFormat:@"%d",tag]];
    [self saveImageInDirectory:imgMinumunSize idImage:[NSString stringWithFormat:@"%dMin",tag]];
    
    //*****************
    
    NSNumber *idFoto = [NSNumber numberWithInt:tag];
    
    NSMutableDictionary *dictFoto = [[NSMutableDictionary alloc]init];
    [dictFoto setObject:idFoto forKey:@"idFoto"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addFotoNotification" object:dictFoto];
    //****************
    
    [button setEnabled:NO];
    [button setAlpha:0.5];
    
    //Para guardar la imagen en la galeria
//    [self saveImageInPhotosAlbum: img];

    [self dismissModalViewControllerAnimated:YES];

}

- (void)saveImageInDirectory:(UIImage*)img idImage:(NSString*)strId{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *imp_Folio = [prefs stringForKey:@"imp_Folio"];
    NSString *nameFoto = [NSString stringWithFormat:@"%@-%@",imp_Folio,strId];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",nameFoto]];
//    NSData *imageDataPNG = UIImagePNGRepresentation(img);
    NSData *imageDataJPG = UIImageJPEGRepresentation(img, 0.0);
    [imageDataJPG writeToFile:savedImagePath atomically:YES];
}

-(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen]scale];
    /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)saveImageInPhotosAlbum:(UIImage*)img{
    if(img) {
        //        [self showProgressIndicator:@"Saving"];
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:finishedSavingWithError:contextInfo:),nil);
    }
}

//Se muestra una alerta si ocurrio un erro al guardar la imagen en la galeria
-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
    }
    else {
    // .... do anything you want here to handle
    // .... when the image has been saved in the photo album
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera"
                                                   message:@"Guardo"
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil, nil];
    [alert show];
    }

}



-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) viewDidDisappear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addFotoNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation
*/

-(IBAction)Regresar:(id)sender{
    
//    if(imageView.image != nil && imageView2.image != nil && imageView3.image != nil )
//    [self.view removeFromSuperview];
    if(imageView.image != nil)
    {
        NSLog(@"Se presento la vista multas");
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateFotos" object:nil];
        
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
        self.view = nil;
    }
    else
    {
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alerta"
                                                       message:@"Debes de tomar al menos 1 fotografia para poder regresar"
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        [alert show];

    }
    
}

@end
