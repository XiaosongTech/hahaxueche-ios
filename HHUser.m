//
//  HHUser.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/8/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHUser.h"

@implementation HHUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}


- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (!self) {
        return nil;
    } else {
        return self;
    }
}

@end
