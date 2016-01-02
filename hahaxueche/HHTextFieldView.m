//
//  HHTextFieldView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/1/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHTextFieldView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHTextFieldView

- (HHTextFieldView *)initWithPlaceHolder:(NSString *)placeHolder leftView:(UIView *)leftView {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        
        [self initTextFieldWithPlaceHolder:placeHolder];
        self.verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
        self.verticalLine.backgroundColor = [UIColor HHOrange];
        [self addSubview:self.verticalLine];
        
        [self addSubview:leftView];
        [self makeConstraintsWithLeftView:leftView];
    }
    return self;
}

- (HHTextFieldView *)initWithPlaceHolder:(NSString *)placeHolder {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        [self initTextFieldWithPlaceHolder:placeHolder];
        [self makeConstraints];
    }
    return self;
}

- (void)initTextFieldWithPlaceHolder:(NSString *)placeHolder{
    self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.attributedPlaceholder = [self buildAttributedPlaceholderWithString:placeHolder];
    self.textField.textColor = [UIColor HHOrange];
    self.textField.font = [UIFont systemFontOfSize:15.0f];
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.tintColor = [UIColor HHOrange];
    [self addSubview:self.textField];
}

- (NSAttributedString *)buildAttributedPlaceholderWithString:(NSString *)string {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    return [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName:[UIColor HHLightOrange], NSFontAttributeName:[UIFont systemFontOfSize:13.0f], NSParagraphStyleAttributeName:paragraphStyle}];
}

- (void)makeConstraints {
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.width.equalTo(self.width);
        make.height.equalTo(self.height);
        make.centerX.equalTo(self.centerX);
        make.centerY.equalTo(self.centerY);
    }];
}

- (void)makeConstraintsWithLeftView:(UIView *)leftView {
    
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.left.equalTo(self.left);
        make.height.equalTo(self.height);
        make.width.equalTo(self.width).offset(-60.0f);
        make.centerY.equalTo(self.centerY);
    }];
    
    [self.verticalLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(7.0f);
        make.left.equalTo(self.textField.right);
        make.width.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        make.height.equalTo(self.height).offset(-14.0f);
        make.centerY.equalTo(self.centerY);
    }];
    [leftView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.left.equalTo(self.verticalLine.right);
        make.width.mas_equalTo(59.0f);
        make.centerY.equalTo(self.centerY);
    }];
}

@end
