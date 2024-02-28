//
//  KeychainWrapper.h
//  Apple's Keychain Services Programming Guide
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright (c) 2014 Apple. All rights reserved.
//

@import Foundation;
@import Security;

@interface KeychainWrapper : NSObject

- (void)mySetObject:(id)inObject forKey:(id)key;
- (id)myObjectForKey:(id)key;
- (void)writeToKeychain;

@end
