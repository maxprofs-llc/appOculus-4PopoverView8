//
//  CustomObject.m
//  appOculus
//
//  Created by Jorge I. Garcia Reyes on 21/02/17.
//  Copyright © 2017 Javier Cortes. All rights reserved.
//

#import "CustomObject.h"
#import "GlobalMembers.h"

@implementation CustomObject

- (void) someMethod: (int)intValue {
    NSLog(@"SomeMethod Ran");
    idFotoImprimir = [NSString stringWithFormat:@"%d", intValue];
}

@end
