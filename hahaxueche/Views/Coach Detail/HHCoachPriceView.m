//
//  HHCoachPriceView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 08/03/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHCoachPriceView.h"

@implementation HHCoachPriceView

- (instancetype)initWithCoach:(HHCoach *)coach {
    self = [super init];
    if (self) {
        self.coach = coach;
        
        [self buildLicenseTypeView];
    }
    return self;
}

- (void)buildLicenseTypeView {
    
    
    if (self.coach.c2Price || self.coach.c2VIPPrice) {
        
    } else {
        
    }
}


@end
