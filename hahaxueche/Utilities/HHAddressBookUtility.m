//
//  HHAddressBookUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 21/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHAddressBookUtility.h"
#import "HHStudentService.h"
#import "APContact.h"
#import "APPhone.h"
#import "APName.h"
#import "HHStudentStore.h"

@implementation HHAddressBookUtility

+ (HHAddressBookUtility *)sharedManager {
    static HHAddressBookUtility *manager = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        manager = [[HHAddressBookUtility alloc] init];
    });
    
    return manager;
}

- (void)uploadContacts {
    APAddressBook *addressBook = [[APAddressBook alloc] init];
    [addressBook loadContacts:^(NSArray <APContact *> *contacts, NSError *error) {
        if (!error) {
            NSMutableArray *contactArray = [NSMutableArray array];
            for (APContact *contact in contacts) {
                if ([[self buildDicWithContact:contact] count] > 0) {
                    [contactArray addObjectsFromArray:[self buildDicWithContact:contact]];
                }
            }
            if (contactArray.count > 0) {
                [[HHStudentService sharedInstance] uploadContactWithDeviceId:[CloudPushSDK getDeviceId] deviceNumber:[HHStudentStore sharedInstance].currentStudent.cellPhone contacts:contactArray];
            }
            
        }
    }];
}

- (NSArray *)buildDicWithContact:(APContact *)contact {
    NSMutableArray *array = [NSMutableArray array];
    NSString *name = [self contactName:contact];
    for (APPhone *phone in contact.phones) {
        if (name && phone.number) {
            NSDictionary *dic = @{@"name":name, @"number":phone.number};
            [array addObject:dic];
        }
    }
    return array;
}

- (NSString *)contactName:(APContact *)contact {
    if (contact.name.compositeName) {
        return contact.name.compositeName;
    }
    else if (contact.name.firstName && contact.name.lastName) {
        return [NSString stringWithFormat:@"%@ %@", contact.name.lastName, contact.name.firstName];
    }
    else if (contact.name.firstName || contact.name.lastName) {
        return contact.name.firstName ?: contact.name.lastName;
    }
    else {
        return nil;
    }
}


@end
