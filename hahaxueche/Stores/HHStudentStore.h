//
//  HHStudentStore.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/11/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHStudent.h"
#import "HHUser.h"
#import <MapKit/MapKit.h>

@interface HHStudentStore : NSObject

@property (nonatomic, strong) HHStudent *currentStudent;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) NSNumber *selectedCityId;
@property (nonatomic, strong) NSMutableDictionary *fieldCoachesDic;

+ (instancetype)sharedInstance;

- (void)createGuestStudent;




@end
