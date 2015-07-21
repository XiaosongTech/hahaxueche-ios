//
//  HHNumberFormatUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/20/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHNumberFormatUtility.h"

@implementation HHNumberFormatUtility


+ (NSNumberFormatter *)floatFormatter {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:1];
    [formatter setMinimumFractionDigits:1];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    return formatter;
}

+ (NSNumberFormatter *)moneyFormatter {
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:locale];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setMaximumFractionDigits:0];
    formatter.usesGroupingSeparator = NO;
    return formatter;
}

@end
