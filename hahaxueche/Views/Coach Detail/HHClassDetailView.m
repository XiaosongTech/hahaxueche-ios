//
//  HHClassDetailView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 24/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHClassDetailView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@interface HHClassDetailView ()

@property (nonatomic, strong) UIView *stickView;
@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation HHClassDetailView

- (instancetype)initWithTitle:(NSString *)title items:(NSArray *)items {
    self = [super init];
    if (self) {
        self.stickView = [[UIView alloc] init];
        self.stickView.backgroundColor = [UIColor HHOrange];
        [self addSubview:self.stickView];
        [self.stickView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.top.equalTo(self.top);
            make.width.mas_equalTo(5.0f);
            make.height.mas_equalTo(20.0f);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.titleLabel.textColor = [UIColor HHLightTextGray];
        self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.stickView.right).offset(8.0f);
            make.centerY.equalTo(self.stickView.centerY);
        }];
        
        for (int i = 0; i < items.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor HHLightBackgroudGray];
            label.layer.masksToBounds = YES;
            label.layer.cornerRadius = 5.0f;
            label.text = items[i];
            label.layer.masksToBounds = YES;
            label.layer.borderColor = [UIColor HHLightLineGray].CGColor;
            label.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:13.0f];
            label.textColor = [UIColor HHOrange];
            [self addSubview:label];
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self.width).multipliedBy(1/3.0f).offset(-40.0f/3.0f);
                make.height.mas_equalTo(25.0f);
                make.top.equalTo(self.stickView.bottom).offset(10.0f + (40) * floor(i/3));
                if (i%3 == 0) {
                    make.left.equalTo(self.left);
                } else if (i%3 == 1) {
                    make.centerX.equalTo(self.centerX);
                } else {
                    make.right.equalTo(self.right);
                }
                
            }];
        }
    }
    return self;
}

@end
