//
//  HHSchoolDetailSingleFieldView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 07/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHSchoolDetailSingleFieldView.h"
#import <UIImageView+WebCache.h>
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHSchoolDetailSingleFieldView

- (instancetype)initWithField:(HHField *)field {
    self = [super init];
    if (self) {
        self.field = field;
        
        self.imgView = [[UIImageView alloc] init];
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.field.img]];
        [self addSubview:self.imgView];
        [self.imgView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.left.equalTo(self.left).offset(15.0f);
            make.height.mas_equalTo(60.0f);
            make.width.mas_equalTo(60.0f);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor HHTextDarkGray];
        self.titleLabel.text = field.name;
        self.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [self addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.centerY).offset(-5.0f);
            make.left.equalTo(self.imgView.right).offset(5.0f);
            make.right.lessThanOrEqualTo(self.right).offset(-90.0f);
        }];
        
        self.subTitleLabel = [[UILabel alloc] init];
        self.subTitleLabel.attributedText = [self generateAddressString];
        [self addSubview:self.subTitleLabel];
        [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.centerY).offset(5.0f);
            make.left.equalTo(self.titleLabel.left);
            make.right.lessThanOrEqualTo(self.right).offset(-15.0f);
        }];
        
        self.checkFieldButton = [[HHGradientButton alloc] initWithType:0];
        [self.checkFieldButton setAttributedTitle:[self generateButtonString] forState:UIControlStateNormal];
        [self.checkFieldButton addTarget:self action:@selector(checkButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        self.checkFieldButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        self.checkFieldButton.layer.masksToBounds = YES;
        self.checkFieldButton.layer.cornerRadius = 3.0f;
        [self addSubview:self.checkFieldButton];
        [self.checkFieldButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel.centerY);
            make.width.mas_equalTo(70.0f);
            make.height.mas_equalTo(25.0f);
            make.right.lessThanOrEqualTo(self.right).offset(-15.0f);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgView.left);
            make.right.equalTo(self.right);
            make.bottom.equalTo(self.bottom);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
        
        
    }
    return self;
}

- (NSMutableAttributedString *)generateAddressString {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ | %@", self.field.district, self.field.displayAddress] attributes:@{NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"ic_list_local_btn"];
    textAttachment.bounds = CGRectMake(0, 0, textAttachment.image.size.width, textAttachment.image.size.height);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [attrString insertAttributedString:attrStringWithImage atIndex:0];
    return attrString;
}


- (NSMutableAttributedString *)generateButtonString {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"去现场看看" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"schoollist_ic_arrow"];
    textAttachment.bounds = CGRectMake(0, 0, textAttachment.image.size.width, textAttachment.image.size.height);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [attrString appendAttributedString:attrStringWithImage];
    return attrString;
}


- (void)checkButtonTapped {
    if (self.checkFieldBlock) {
        self.checkFieldBlock(self.field);
    }
}

@end
