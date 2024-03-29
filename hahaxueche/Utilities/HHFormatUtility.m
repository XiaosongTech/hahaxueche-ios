//
//  HHNumberFormatUtility.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/20/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHFormatUtility.h"

@implementation HHFormatUtility


+ (NSNumberFormatter *)floatFormatter {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:1];
    [formatter setMinimumFractionDigits:1];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    return formatter;
}

+ (NSNumberFormatter *)numberFormatter {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:0];
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

+ (NSDateFormatter *)dateFormatter {
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = locale;
    [formatter setDateFormat:@"MM-dd"];
    return formatter;
}

+ (NSDateFormatter *)weekDayFormatter {
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = locale;
    [formatter setDateFormat:@"EEEE"];
    return formatter;
}

+ (NSDateFormatter *)timeFormatter {
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = locale;
    [formatter setDateFormat:@"HH:mm"];
    return formatter;

}

+ (NSDateFormatter *)fullDateFormatter {
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = locale;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return formatter;
}

+ (NSDateFormatter *)backendDateFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return formatter;

}

+ (NSDateFormatter *)chineseFullDateFormatter {
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = locale;
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    return formatter;
}

+ (NSDateFormatter *)onlyDateFormatter {
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = locale;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return formatter;
}

+ (NSDateFormatter *)fullDateWithoutSecFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return formatter;
    
}

+ (NSDateFormatter *)fullDateSlashFormatter {
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = locale;
    [formatter setDateFormat:@"yyyy/MM/dd"];
    return formatter;
}

@end
