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


- (HHTextFieldView *)initWithPlaceHolder:(NSString *)placeHolder {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.attributedPlaceholder = [self buildAttributedPlaceholderWithString:placeHolder];
        self.textField.textColor = [UIColor HHOrange];
        self.textField.font = [UIFont systemFontOfSize:15.0f];
        self.textField.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.textField];
        
        [self makeConstraints];
    }
    return self;
}

- (NSAttributedString *)buildAttributedPlaceholderWithString:(NSString *)string {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    return [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:1 green:0.88 blue:0.73 alpha:1], NSFontAttributeName:[UIFont systemFontOfSize:13.0f], NSParagraphStyleAttributeName:paragraphStyle}];
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

@end
