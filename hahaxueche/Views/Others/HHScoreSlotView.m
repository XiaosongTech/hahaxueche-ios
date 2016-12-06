//
//  HHScoreSlotView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 30/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHScoreSlotView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHScoreSlotView

- (instancetype)initWithCount:(NSNumber *)count {
    self = [super init];
    if (self) {
        for (int i = 0; i < 9; i++) {
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.image = [self getCorrectImgWithIndex:i totalCount:count];
            [self addSubview:imgView];
            [imgView makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.centerY);
                make.centerX.equalTo(self.centerX).multipliedBy((i*2 + 1)/9.0f);
            }];
        }
    }
    return self;
}

- (UIImage *)getCorrectImgWithIndex:(NSInteger)index totalCount:(NSNumber *)totalCount {
    
    switch (index) {
        case 0: {
            if ((index/2) + 1 <= [totalCount integerValue]) {
                return [UIImage imageNamed:@"ic_hahapass1"];
            } else {
                return [UIImage imageNamed:@"ic_nopass1"];
            }
        };
            
        case 2: {
            if ((index/2) + 1 <= [totalCount integerValue]) {
                return [UIImage imageNamed:@"ic_hahapass2"];
            } else {
                return [UIImage imageNamed:@"ic_nopass2"];
            }
        };
            
        case 4: {
            if ((index/2) + 1 <= [totalCount integerValue]) {
                return [UIImage imageNamed:@"ic_hahapass3"];
            } else {
                return [UIImage imageNamed:@"ic_nopass3"];
            }
        };
            
        case 6: {
            if ((index/2) + 1 <= [totalCount integerValue]) {
                return [UIImage imageNamed:@"ic_hahapass4"];
            } else {
                return [UIImage imageNamed:@"ic_nopass4"];
            }
        };
            
        case 8: {
            if ((index/2) + 1 <= [totalCount integerValue]) {
                return [UIImage imageNamed:@"ic_hahapass5"];
            } else {
                return [UIImage imageNamed:@"ic_nopass5"];
            }
        };
            
        default: {
            
        } break;
    }
    return [UIImage imageNamed:@"ic_loading"];
}

@end
