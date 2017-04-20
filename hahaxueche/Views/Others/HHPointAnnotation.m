//
//  HHPointAnnotation.m
//  hahaxueche
//
//  Created by Zixiao Wang on 17/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHPointAnnotation.h"

@implementation HHPointAnnotation

- (instancetype)initWithField:(HHField *)field {
    self = [super init];
    if (self) {
        self.field = field;
    }
    return self;
}

@end
