//
//  HHCommentView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/22/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCommentView.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:[UIColor HHLightestTextGray] forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.cancelButton addTarget:self action:@selector(cancelTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
        [self.cancelButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(15.0f);
            make.centerY.equalTo(self.top).offset(21.0f);
        }];
        
        self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.confirmButton setTitle:@"发布" forState:UIControlStateNormal];
        [self.confirmButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
        self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.confirmButton addTarget:self action:@selector(confirmTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.confirmButton];
        [self.confirmButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(-15.0f);
            make.centerY.equalTo(self.cancelButton.centerY);
        }];
        
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor HHTextDarkGray];
        self.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        self.titleLabel.text = @"评论";
        [self addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.centerY.equalTo(self.cancelButton.centerY);
        }];
        
        self.textView = [[UITextView alloc] init];
        self.textView.font = [UIFont systemFontOfSize:15.0f];
        self.textView.placeholder = @"发表伟大言论...";
        self.textView.placeholderColor = [UIColor HHLightestTextGray];
        self.textView.backgroundColor = [UIColor HHBackgroundGary];
        self.textView.textColor = [UIColor darkTextColor];
        self.textView.tintColor = [UIColor HHOrange];
        self.textView.layer.masksToBounds = YES;
        self.textView.layer.cornerRadius = 5.0f;
        [self addSubview:self.textView];
        [self.textView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(15.0f);
            make.width.equalTo(self.width).offset(-30.0f);
            make.bottom.equalTo(self.bottom).offset(-15.0f);
            make.top.equalTo(self.top).offset(42.0f);
        }];
        self.textView.inputAccessoryView = self;
        [self.textView becomeFirstResponder];
        
    }
    return self;
}

- (void)cancelTapped {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)confirmTapped {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}

@end
