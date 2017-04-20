//
//  HHCalloutView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 18/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHCalloutView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation HHCalloutView

- (instancetype)initWithField:(HHField *)field {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, 250.0f, 70.0f);
        self.field = field;

        
        self.imgView = [[UIImageView alloc] init];
        [self addSubview:self.imgView];
        [self.imgView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.left.equalTo(self.left).offset(10.0f);
            make.height.equalTo(self.height).offset(-20.0f);
            make.width.mas_equalTo(60.0f);
        }];
        
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor HHTextDarkGray];
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [self addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgView.right).offset(5.0f);
            make.bottom.equalTo(self.centerY).offset(-2.0f);
            make.right.equalTo(self.right).offset(-60.0f);
        }];
        
        self.subTitleLabel = [[UILabel alloc] init];
        self.subTitleLabel.textColor = [UIColor HHLightTextGray];
        self.subTitleLabel.numberOfLines = 1;
        self.subTitleLabel.adjustsFontSizeToFitWidth = YES;
        self.subTitleLabel.minimumScaleFactor = 0.5;
        [self addSubview:self.subTitleLabel];
        [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.left);
            make.top.equalTo(self.centerY).offset(3.0f);
            make.right.equalTo(self.right).offset(-10.0f);
        }];
        
        self.sendButton = [[HHGradientButton alloc] initWithType:0];
        [self.sendButton setTitle:@"发送定位" forState:UIControlStateNormal];
        [self.sendButton addTarget:self action:@selector(sendTapped) forControlEvents:UIControlEventTouchUpInside];
        self.sendButton.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        self.sendButton.layer.masksToBounds = YES;
        self.sendButton.layer.cornerRadius = 5.0f;
        [self addSubview:self.sendButton];
        [self.sendButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(-10.0f);
            make.centerY.equalTo(self.titleLabel.centerY);
            make.width.mas_equalTo(45.0f);
            make.height.mas_equalTo(20.0f);
        }];
        
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:field.img]];
        self.titleLabel.text = field.name;
        self.subTitleLabel.text = [NSString stringWithFormat:@"%@ (%@名教练)", field.displayAddress, [field.coachCount stringValue]];

    }
    return self;
}

- (void)sendTapped {
    if (self.sendAction) {
        self.sendAction(self.field);
    }
}

@end
