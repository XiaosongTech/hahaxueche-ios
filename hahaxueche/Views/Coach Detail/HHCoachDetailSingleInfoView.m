//
//  HHCoachDetailSingleInfoView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachDetailSingleInfoView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHCoachDetailSingleInfoView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubviews];
        self.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)initSubviews {
    self.titleLabel = [[UILabel alloc] init];
    [self addSubview:self.titleLabel];
    
    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.textColor = [UIColor HHLightTextGray];
    self.valueLabel.textAlignment = NSTextAlignmentCenter;
    self.valueLabel.font = [UIFont systemFontOfSize:18.0f];
    [self addSubview:self.valueLabel];
    
    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_coachmsg_more_arrow"]];
    [self addSubview:self.arrowImageView];
    
    self.iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_auth_golden"]];
    self.iconView.hidden = YES;
    [self addSubview:self.iconView];

    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(self.top).offset(18.0f);
    }];
    
    [self.valueLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(14.0f);
        make.centerX.equalTo(self.centerX);
        make.width.lessThanOrEqualTo(self.width).offset(-40.0f);
    }];
    
    [self.arrowImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.right.equalTo(self.right).offset(-12.0f);
    }];
    
    [self.iconView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.valueLabel.right).offset(5.0f);
        make.centerY.equalTo(self.valueLabel.centerY);
    }];
}

- (void)setupViewWithTitle:(NSString *)title image:(UIImage *)image value:(NSString *)value showArrowImage:(BOOL)showArrowImage actionBlock:(HHCoachDetailCellActionBlock)actionBlock {
    self.valueLabel.text = value;
    if (showArrowImage) {
        self.arrowImageView.hidden = NO;
    } else {
        self.arrowImageView.hidden = YES;
    }
    self.actionBlock = actionBlock;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentNatural;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", title] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHOrange], NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = image;
    textAttachment.bounds = CGRectMake(0, -2.0f, textAttachment.image.size.width, textAttachment.image.size.height);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedString insertAttributedString:attrStringWithImage atIndex:0];
    self.titleLabel.attributedText = attributedString;
}

- (void)viewTapped {
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
