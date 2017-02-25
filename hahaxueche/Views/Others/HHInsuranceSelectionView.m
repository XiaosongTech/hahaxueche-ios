//
//  HHInsuranceSelectionView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 24/02/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHInsuranceSelectionView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"

@implementation HHInsuranceSelectionView

- (instancetype)initWithFrame:(CGRect)frame selected:(BOOL)selected {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.checked = selected;
        
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = @"赔付宝";
        self.titleLabel.textColor = [UIColor HHTextDarkGray];
        self.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [self addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.top.equalTo(self.top).offset(15.0f);
        }];
        
        self.topLine = [[UIView alloc] init];
        self.topLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.topLine];
        [self.topLine makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.top.equalTo(self.titleLabel.bottom).offset(15.0f);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(1.0f);
        }];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.numberOfLines = 0;
        self.textLabel.text = @"赔付宝是一款由中国平安承保量身为哈哈学车定制的一份学车保险。提供了一站式驾考报名、选购保险、保险理赔申诉的平台，全面保障你的学车利益，赔付宝在购买后的次日生效，保期最长为一年";
        self.textLabel.textColor = [UIColor HHTextDarkGray];
        self.textLabel.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:self.textLabel];
        [self.textLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(15.0f);
            make.top.equalTo(self.topLine.bottom).offset(10.0f);
            make.width.equalTo(self.width).offset(-65.0f);
        }];
        
        self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.checkButton addTarget:self action:@selector(checkButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        if (selected) {
            [self.checkButton setImage:[UIImage imageNamed:@"icon_selected_press"] forState:UIControlStateNormal];
        } else {
            [self.checkButton setImage:[UIImage imageNamed:@"icon_selected_normal"] forState:UIControlStateNormal];
        }
        [self addSubview:self.checkButton];
        
        [self.checkButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.right).offset(-25.0f);
            make.centerY.equalTo(self.textLabel.centerY);
        }];
        
        self.cancelButton = [self buildButtonWithTitle:@"取消" bgColor:[UIColor HHOrange]];
        [self addSubview:self.cancelButton];
        [self.cancelButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.width.equalTo(self.width).multipliedBy(0.5f);
            make.height.mas_equalTo(50.0f);
            make.bottom.equalTo(self.bottom);
        }];
        
        self.confirmButton = [self buildButtonWithTitle:@"确认" bgColor:[UIColor HHDarkOrange]];
        [self addSubview:self.confirmButton];
        [self.confirmButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cancelButton.right);
            make.width.equalTo(self.width).multipliedBy(0.5f);
            make.height.mas_equalTo(50.0f);
            make.bottom.equalTo(self.bottom);
        }];
        
    }
    
    return self;
}

- (UIButton *)buildButtonWithTitle:(NSString *)title bgColor:(UIColor *)color {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = color;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)checkButtonTapped {
    if (self.checked) {
        [self.checkButton setImage:[UIImage imageNamed:@"icon_selected_normal"] forState:UIControlStateNormal];
    } else {
        [self.checkButton setImage:[UIImage imageNamed:@"icon_selected_press"] forState:UIControlStateNormal];
    }
    self.checked = !self.checked;
}

- (void)buttonTapped:(UIButton *)button {
    if ([button isEqual:self.confirmButton]) {
        if (self.buttonAction) {
            self.buttonAction(YES, self.checked);
        }
    } else {
        if (self.buttonAction) {
            self.buttonAction(NO, self.checked);
        }
    }
}
    


@end
