//
//  CustomObject.h
//  appOculus
//
//  Created by Jorge I. Garcia Reyes on 21/02/17.
//  Copyright © 2017 Javier Cortes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomObject : NSObject

@property (strong, nonatomic) NSString *someProperty;

- (void) someMethod: (int)intValue;

@end
