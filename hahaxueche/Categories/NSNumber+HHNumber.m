//
//  NSNumber+HHNumber.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/13/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "NSNumber+HHNumber.h"

@implementation NSNumber (HHNumber)

- (NSString *)generateMoneyString {
    NSNumber *number = @([self floatValue] / 100);
    return [NSString stringWithFormat:@"￥%@", [number stringValue]];
}

@end
