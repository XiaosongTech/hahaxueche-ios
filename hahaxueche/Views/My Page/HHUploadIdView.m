//
//  HHUploadIdView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 23/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHUploadIdView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHUploadIdView

- (instancetype)initWithText:(NSString *)text image:(UIImage *)image {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0f;
        self.leftView = [[UIView alloc] init];
        self.leftView.backgroundColor = [UIColor HHBackgroundGary];
        [self addSubview:self.leftView];
        [self.leftView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.top.equalTo(self.top);
            make.height.equalTo(self.height);
            make.width.mas_equalTo(90.0f);
        }];
        
        self.leftLabel = [[UILabel alloc] init];
        self.leftLabel.textAlignment = NSTextAlignmentCenter;
        self.leftLabel.numberOfLines = 0;
        self.leftLabel.text = text;
        self.leftLabel.textColor = [UIColor HHLightTextGray];
        self.leftLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.leftView addSubview:self.leftLabel];
        [self.leftLabel makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.leftView);
        }];
        
        self.imgView = [[UIImageView alloc] initWithImage:image];
        self.imgView.contentMode = UIViewContentModeCenter;
        [self addSubview:self.imgView];
        [self.imgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftView.right);
            make.top.equalTo(self.top);
            make.height.equalTo(self.height);
            make.width.equalTo(self.width).offset(-90.0f);
        }];
        
        
    }
    return self;
}

@end
