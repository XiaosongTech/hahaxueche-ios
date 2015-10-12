//
//  HHPointAnnotation.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/25/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHPointAnnotation.h"

@implementation HHPointAnnotation

- (instancetype)initWithTag:(NSInteger)tag {
    self = [super init];
    if (self) {
        self.tag = tag;
    }
    return self;
}

@end
