//
//  NSString+HHURL.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "NSString+HHURL.h"

@implementation NSString (HHURL)

- (NSString *)urlEncode {
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


@end
