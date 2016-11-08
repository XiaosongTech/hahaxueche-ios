//
//  NSNumber+HHNumber.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/13/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "NSNumber+HHNumber.h"
#import "HHFormatUtility.h"

@implementation NSNumber (HHNumber)

- (NSString *)generateMoneyString {
    NSNumber *number = @([self floatValue] / 100);
    return [[HHFormatUtility moneyFormatter] stringFromNumber:number];
}

- (NSString *)generateMoneyStringWithoutOriginalNumber {
    NSNumber *number = @([self floatValue]);
    return [[HHFormatUtility moneyFormatter] stringFromNumber:number];;
}

- (NSString *)generateLargeNumberString {
    if ([self floatValue] >= 10000) {
        return [NSString stringWithFormat:@"%@万", [[HHFormatUtility floatFormatter] stringFromNumber:@([self floatValue]/10000)]];
    } else {
        return [self stringValue];
    }
}

@end
