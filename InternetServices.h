//
//  InternetServices.h
//  IsaíApp
//
//  Created by Isaí G. on 11/02/14.
//  Copyright (c) 2014 Isai Garcia Reyes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>


typedef enum : NSInteger {
    NoNotified=0,
    NoReachableNotif,
    ReachableViaWiFiNotif,
    ReachableViaWWANNotif
} LastChangeNotified;


@interface InternetServices : NSObject

@property (strong,nonatomic) Reachability *reachability;
@property (nonatomic) BOOL toogleInfo;


+(void)isInternetAvailable;
+(void)isServiceAvaliableAtHost:(NSString *)hostName Notify:(BOOL *)notify;

-(int)notifyNetworkStatus;


@end

