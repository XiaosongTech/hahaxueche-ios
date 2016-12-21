//
//  HHAddressBookUtility.h
//  hahaxueche
//
//  Created by Zixiao Wang on 21/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <APAddressBook/APAddressBook.h>
#import <CloudPushSDK/CloudPushSDK.h>

@interface HHAddressBookUtility : NSObject

+ (HHAddressBookUtility *)sharedManager;
- (void)uploadContacts;

@end
