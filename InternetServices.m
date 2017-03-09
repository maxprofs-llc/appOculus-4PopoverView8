//
//  InternetServices.m
//  IsaíApp
//
//  Created by Isaí G. on 11/02/14.
//  Copyright (c) 2014 Isai Garcia Reyes. All rights reserved.
//

#import "InternetServices.h"
#import "GlobalMembers.h"

// network Include libs

#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>


@implementation InternetServices
@synthesize reachability;
@synthesize toogleInfo;


-(id)init{
   
    if (self = [super init]){
        [self setToogleInfo:true];
        lastNotifSend=NoNotified;
        reachability = [Reachability reachabilityForInternetConnection];
        [reachability startNotifier];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showInetStatus:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
    }
    
    return self;

}

-(id)initAndnotify:(BOOL )value
{
    if (self = [super init])
    {
        [self setToogleInfo:value];
        lastNotifSend=NoNotified;
        reachability = [Reachability reachabilityForInternetConnection];
        [reachability startNotifier];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showInetStatus:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        
        
    }
    
    return self;
    
}



-(void)showInetStatus:(NSNotification *)notification{
    
    [self reachabilityChangedSelector:[self toogleInfo]];
    
}

- (void)reachabilityChangedSelector:(BOOL )notify{
    
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSString *medium;

    int notifToSend=0;
    
    switch (internetStatus)
    {
        case ReachableViaWWAN:
        {
            [dict setObject:[NSString localizedStringWithFormat:@"%d",1] forKey:@"Status"];
            //medium = @"ReachableViaWWAN";
            medium = @"Reachable by 3G or 4G";
            [dict setObject:medium forKey:@"medium"];
            //[dict setObject:[NSNumber numberWithInt:2] forKey:@"Signal"];
            GInternetStatus = ReachableViaWWAN;
            GisInternetAvaliable = YES;
            notifToSend=ReachableViaWWANNotif;
            
        }
            break;
        case ReachableViaWiFi:
        {
            [dict setObject:[NSString localizedStringWithFormat:@"%d",1] forKey:@"Status"];
            //medium = @"ReachableViaWiFi";
            medium = @"Reachable by WiFi";
            [dict setObject:medium forKey:@"medium"];
            //[dict setObject:[NSNumber numberWithInt:1] forKey:@"Signal"];
            GInternetStatus = ReachableViaWiFi;
            GisInternetAvaliable = YES;
            notifToSend=ReachableViaWiFiNotif;
        }
            break;
        case NotReachable:
        {
            [dict setObject:[NSString localizedStringWithFormat:@"%d",0] forKey:@"Status"];
            //medium = @"NotReachable";
            medium = @"Red de datos no está disponible";
            [dict setObject:medium forKey:@"medium"];
            //[dict setObject:[NSNumber numberWithInt:0] forKey:@"Signal"];
            GInternetStatus = NotReachable;
            GisInternetAvaliable = NO;
            notifToSend=NoReachableNotif;
            
        }
            break;
            default:
            break;
            
    }
    if (internetStatus != NotReachable) {
        GisInternetAvaliable = TRUE;
    }else{
        GisInternetAvaliable = NO;
    }
    //if (internetStatus != NotReachable  && notify) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"InternetConnectionStatus"
         object:dict];
    
}






+ (void)isInternetAvailable{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    //reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        GisInternetAvaliable = YES;
    }else{
        GisInternetAvaliable = NO;
    }
    
}


-(int)notifyNetworkStatus{
    
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    switch (netStatus){
        case ReachableViaWWAN:
            GInternetStatus = ReachableViaWWAN;
            break;
        case ReachableViaWiFi:
            GInternetStatus = ReachableViaWiFi;
            break;
        case NotReachable:
            GInternetStatus = NotReachable;
            break;
        default:
            break;
    }
    
    return GInternetStatus;
}

#pragma mark  Host Is Reachable at URL

+(void)isHostReachable:(NSString *)host
{
    Reachability *localReachability =[Reachability reachabilityWithHostName:host];

    if(localReachability)
    {
        // Put alternative content is rechable /message here
    } else {
        // Put Internet Required Code here To identify that Host isn't reachable
        
    }
    
}

#pragma mark -


#pragma mark -  Network mesuring Function


- (NSArray *)getDataCounters
{
    BOOL   success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    
    int WiFiSent = 0;
    int WiFiReceived = 0;
    int WWANSent = 0;
    int WWANReceived = 0;
    
    NSString *name=[[NSString alloc]init];
    
    success = getifaddrs(&addrs) == 0;
    if (success)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
            if (DEBUGGIN_FLAG) {
                NSLog(@"ifa_name %s == %@\n", cursor->ifa_name,name);}
            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
            
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                if ([name hasPrefix:@"en"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent+=networkStatisc->ifi_obytes;
                    WiFiReceived+=networkStatisc->ifi_ibytes;
                    if (DEBUGGIN_FLAG) {
                        NSLog(@"WiFiSent %d ==%d",WiFiSent,networkStatisc->ifi_obytes);
                        NSLog(@"WiFiReceived %d ==%d",WiFiReceived,networkStatisc->ifi_ibytes);}
                }
                
                if ([name hasPrefix:@"pdp_ip"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent+=networkStatisc->ifi_obytes;
                    WWANReceived+=networkStatisc->ifi_ibytes;
                    if (DEBUGGIN_FLAG) {
                        NSLog(@"WWANSent %d ==%d",WWANSent,networkStatisc->ifi_obytes);
                        NSLog(@"WWANReceived %d ==%d",WWANReceived,networkStatisc->ifi_ibytes);}
                }
            }
            
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    
    return [NSArray arrayWithObjects:[NSNumber numberWithInt:WiFiSent], [NSNumber numberWithInt:WiFiReceived],[NSNumber numberWithInt:WWANSent],[NSNumber numberWithInt:WWANReceived], nil];
}

#pragma mark -



+(void)isServiceAvaliableAtHost:(NSString *)hostName Notify:(BOOL *)notify
{
    Reachability *localReachability =[Reachability reachabilityWithHostName:hostName];
    
    NetworkStatus internetStatus = [localReachability currentReachabilityStatus];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSString *medium;
    
    [dict setObject:[NSString localizedStringWithFormat:@"%d",1] forKey:@"Status"];
    [dict setObject:hostName forKey:[NSString localizedStringWithFormat:@"%@",@"host"]];
    switch (internetStatus)
    {
        case ReachableViaWWAN:
        {
            
            medium = @"ReachableViaWWAN";
            [dict setObject:[NSString localizedStringWithFormat:@"%d",1] forKey:@"Status"];
            [dict setObject:medium forKey:@"medium"];
            GInternetStatus = ReachableViaWWAN;
            
            break;
        }
        case ReachableViaWiFi:
        {
            medium = @"ReachableViaWiFi";
            [dict setObject:[NSString localizedStringWithFormat:@"%d",1] forKey:@"Status"];
            [dict setObject:medium forKey:@"medium"];
            GInternetStatus = ReachableViaWiFi;
            break;
        }
        case NotReachable:
        {
            [dict setObject:[NSString localizedStringWithFormat:@"%d",0] forKey:@"Status"];
            medium = @"NotReachable";
            [dict setObject:medium forKey:@"medium"];
            GInternetStatus = NotReachable;
            break;
        }
            
    }
    if (internetStatus != NotReachable  && notify) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"InternetConnectionStatus" object:dict];
        
        
    }else if (internetStatus == NotReachable && notify){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"InternetConnectionStatus" object:dict];
        
    }else if (internetStatus == NotReachable && !notify){
        
        
        
    }

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
