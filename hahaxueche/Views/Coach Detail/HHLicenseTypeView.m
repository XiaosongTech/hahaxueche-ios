//
//  HHLicenseTypeView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 08/03/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHLicenseTypeView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHLicenseTypeView

- (instancetype)initWithType:(NSInteger)type selected:(BOOL)selected alignLeft:(BOOL)alignLeft {
    self = [super init];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        
        if (type == 1) {
            self.titleLabel.text = @"C1手动挡";
        } else {
            self.titleLabel.text = @"C2自动挡";
        }
        
        if (selected) {
            self.titleLabel.textColor = [UIColor HHDarkOrange];
        } else {
            self.titleLabel.textColor = [UIColor HHLightTextGray];
        }
        [self addSubview:self.titleLabel];
        
        if (alignLeft) {
            [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.centerY);
                make.left.equalTo(self.left).offset(20.0f);
            }];
        } else {
            [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.centerY);
                make.centerX.equalTo(self.centerX).offset(-10.0f);
            }];
        }
       
        
        self.questionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.questionButton.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        [self.questionButton setTitle:@"?" forState:UIControlStateNormal];
        [self.questionButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
        [self.questionButton setBackgroundColor:[UIColor HHBackgroundGary]];
        self.questionButton.layer.masksToBounds = YES;
        self.questionButton.layer.borderColor = [UIColor HHLightLineGray].CGColor;
        self.questionButton.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
        self.questionButton.layer.cornerRadius = 3.0f;
        [self.questionButton addTarget:self action:@selector(questionButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.questionButton];
        [self.questionButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.right).offset(5.0f);
            make.centerY.equalTo(self.titleLabel.centerY);
            make.width.mas_equalTo(15.0f);
            make.height.mas_equalTo(15.0f);
        }];
        
        UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
        [self addGestureRecognizer:tapRec];
        
    }
    return self;
}

- (void)questionButtonTapped {
    if (self.questionMarkBlock) {
        self.questionMarkBlock();
    }
}

- (void)viewTapped {
    if (self.selectedBlock) {
        self.selectedBlock();
    }
}

@end
