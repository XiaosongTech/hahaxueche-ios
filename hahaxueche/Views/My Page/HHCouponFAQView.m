//
//  HHCouponFAQView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCouponFAQView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHCouponFAQView

- (instancetype)initWithTitle:(NSString *)title text:(NSString *)text linkText:(NSString *)linkText linkURL:(NSString *)linkURL {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.linkText = linkText;
        self.linkURL = linkURL;
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        self.titleLabel.textColor = [UIColor HHTextDarkGray];
        [self addSubview:self.titleLabel];
        [self.titleLabel sizeToFit];
        
        self.line = [[UIView alloc] init];
        self.line.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.line];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5.0f;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
        
        
        self.textLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        self.textLabel.delegate = self;
        self.textLabel.numberOfLines = 0;
        self.textLabel.attributedText = attributedString;
        self.textLabel.linkAttributes = @{NSForegroundColorAttributeName:[UIColor HHLinkBlue]};
        self.textLabel.activeLinkAttributes = @{NSForegroundColorAttributeName:[UIColor HHLinkBlue]};
        [self addSubview:self.textLabel];
        [self.textLabel sizeToFit];
        
        if (self.linkText) {
            NSRange range = [text rangeOfString:self.linkText];
            [self.textLabel addLinkToURL:[NSURL URLWithString:self.linkURL] withRange:range];
        }
        
        
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top).offset(14.0f);
            make.left.equalTo(self.left).offset(14.0f);
            make.width.equalTo(self.width).offset(-28.0f);
        }];
        
        [self.line makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.bottom).offset(8.0f);
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
        
        [self.textLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.line.bottom).offset(15.0f);
            make.left.equalTo(self.left).offset(14.0f);
            make.width.equalTo(self.width).offset(-28.0f);
        }];
    }
    return self;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if (self.linkBlock) {
        self.linkBlock(url);
    }
}



@end
