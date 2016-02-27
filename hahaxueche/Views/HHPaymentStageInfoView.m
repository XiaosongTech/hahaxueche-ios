//
//  HHPaymentStageInfoView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPaymentStageInfoView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"

@implementation HHPaymentStageInfoView

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title text:(NSString *)text textColor:(UIColor *)textColor {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.attributedText = [self buildTitle:title image:image textColor:textColor];
        [self addSubview:self.titleLabel];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.textColor = [UIColor HHLightTextGray];
        self.textLabel.text = text;
        self.textLabel.numberOfLines = 0;
        self.textLabel.font = [UIFont systemFontOfSize:14.0f];
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.textLabel];
        
        self.okButton = [[HHOkButtonView alloc] init];
        [self addSubview:self.okButton];
        
        [self makeConstraints];
    }
    return self;
}

- (void)makeConstraints {
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(15.0f);
        make.centerX.equalTo(self.centerX);
    }];
    [self.textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(10.0f);
        make.centerX.equalTo(self.centerX);
        make.width.equalTo(self.width).offset(-30.0f);
    }];
    
    [self.okButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom);
        make.centerX.equalTo(self.centerX);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(50.0f);
    }];
}

- (void)setOkAction:(HHOKButtonActionBlock)okAction {
    _okAction = okAction;
    self.okButton.okAction = self.okAction;
}

- (NSMutableAttributedString *)buildTitle:(NSString *)title image:(UIImage *)image textColor:(UIColor *)textColor {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentNatural;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", title] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = image;
    textAttachment.bounds = CGRectMake(0, -2.0f, textAttachment.image.size.width, textAttachment.image.size.height);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedString insertAttributedString:attrStringWithImage atIndex:0];
    return attributedString;

}

@end
