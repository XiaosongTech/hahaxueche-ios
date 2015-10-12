//
//  HHTrainingFieldService.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/25/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "HHTrainingField.h"

@interface HHTrainingFieldService : NSObject

typedef void (^HHFieldCompletionBlock)(HHTrainingField *field, NSError *error);
typedef void (^HHFieldArrayCompletionBlock)(NSArray *fields, NSError *error);

@property (nonatomic, strong) NSArray *supportedFields;
@property (nonatomic, strong) NSMutableArray *selectedFields;
@property (nonatomic, strong) NSArray *nearestFields;

+ (instancetype)sharedInstance;

- (void)fetchTrainingFieldWithId:(NSString *)fieldId completion:(HHFieldCompletionBlock)completion;

- (void)fetchTrainingFieldsForCity:(NSString *)city completion:(HHFieldArrayCompletionBlock)competion ;

@end
