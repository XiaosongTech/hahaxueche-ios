//
//  HHCoachBadgeView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 07/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachBadgeView.h"
#import "Masonry.h"

@implementation HHCoachBadgeView

- (instancetype)initWithCoach:(HHCoach *)coach {
    self = [super init];
    if (self) {
        if ([coach isGoldenCoach]) {
            [self buildBadgeImageViewWithImage:[UIImage imageNamed:@"ic_auth_golden"]];
        }
        //[self buildBadgeImageViewWithImage:[UIImage imageNamed:@"ic_bao"]];
        if ([coach.hasDeposit boolValue]) {
            [self buildBadgeImageViewWithImage:[UIImage imageNamed:@"ic_bao"]];
        }
    }
    return self;
}

- (void)buildBadgeImageViewWithImage:(UIImage *)image {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:imgView];
    if (self.preView) {
        [imgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.preView.right).offset(5.0f);
            make.centerY.equalTo(self.centerY);
        }];
    } else {
        [imgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.centerY.equalTo(self.centerY);
        }];
    }
    self.preView = imgView;
}

@end
