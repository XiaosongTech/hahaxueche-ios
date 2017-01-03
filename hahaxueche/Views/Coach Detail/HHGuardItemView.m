//
//  HHGuardItemView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 03/01/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHGuardItemView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHGuardItemView

- (instancetype)initWithImg:(UIImage *)img title:(NSString *)title {
    self = [super init];
    if (self) {
        self.imgView = [[UIImageView alloc] initWithImage:img];
        [self addSubview:self.imgView];
        [self.imgView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.centerY).offset(3.0f);
            make.centerX.equalTo(self.centerX);
        }];
        
        self.label = [[UILabel alloc] init];
        self.label.text = title;
        self.label.textColor = [UIColor HHLightTextGray];
        self.label.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.label];
        [self.label makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.bottom).offset(5.0f);
            make.centerX.equalTo(self.centerX);
        }];
    }
    return self;
}

@end
