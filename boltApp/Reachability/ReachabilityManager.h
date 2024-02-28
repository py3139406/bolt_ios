//
//  ReachabilityManager.h
//  Created By Anshul Jain on 25-March-2019


#import <Foundation/Foundation.h>

@interface ReachabilityManager : NSObject

/**
 Network connectivity singleton

 @return instance variable for RCReachabilityManager
 */
+ (instancetype)sharedManager;


/**
 Gives the device reachablity status for the host

 @return Boolean indicating device reachablity status for the host
 */
+ (BOOL)isInternetAvailable;

@end
