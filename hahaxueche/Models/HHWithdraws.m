//
//  HHWithdraws.m
//  hahaxueche
//
//  Created by Zixiao Wang on 5/3/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHWithdraws.h"

@implementation HHWithdraws

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"prePage":@"links.previous",
             @"nextPage":@"links.next",
             @"withdraws":@"data"
             };
}

+ (NSValueTransformer *)withdrawsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHWithdraw class]];
}

@end
