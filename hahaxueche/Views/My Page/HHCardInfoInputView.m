//
//  HHCardInfoInputView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCardInfoInputView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHCardInfoInputView

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
        [self addGestureRecognizer:tapRec];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        self.titleLabel.textColor = [UIColor darkTextColor];
        [self addSubview:self.titleLabel];
        
        
        self.textField = [[UITextField alloc] init];
        self.textField.placeholder = placeholder;
        self.textField.textColor = [UIColor blackColor];
        self.textField.font = [UIFont systemFontOfSize:15.0f];
        self.textField.textAlignment = NSTextAlignmentLeft;
        self.textField.tintColor = [UIColor HHOrange];
        [self addSubview:self.textField];
        
        UIToolbar* toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 50)];
        toolBar.barStyle = UIBarStyleDefault;
        
        toolBar.items = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(hideKeyboard)]];
        [toolBar sizeToFit];
        self.textField.inputAccessoryView = toolBar;
        
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.left.equalTo(self.left).offset(20.0f);
        }];
        
        [self.textField makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.left.equalTo(self.left).offset(80.0f);
            make.width.equalTo(self.width).offset(-70.0f);
            make.height.equalTo(self.height);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:line];
        
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom);
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
    }
    
    return self;
}

- (void)hideKeyboard {
    [self.textField resignFirstResponder];
}

- (void)viewTapped {
    if (self.block) {
        self.block();
    }
}

@end
