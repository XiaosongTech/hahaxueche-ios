//
//  HHNumberFormatUtility.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/20/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHFormatUtility : NSObject

+ (NSNumberFormatter *)floatFormatter;

+ (NSNumberFormatter *)moneyFormatter;

+ (NSDateFormatter *)dateFormatter;

+ (NSDateFormatter *)weekDayFormatter;

+ (NSDateFormatter *)timeFormatter;

+ (NSDateFormatter *)fullDateFormatter;

+ (NSDateFormatter *)backendDateFormatter;

+ (NSNumberFormatter *)numberFormatter;

+ (NSDateFormatter *)chineseFullDateFormatter;

+ (NSDateFormatter *)onlyDateFormatter;

@end
