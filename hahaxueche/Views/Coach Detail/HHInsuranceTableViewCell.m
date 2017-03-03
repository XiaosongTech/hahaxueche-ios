//
//  HHInsuranceTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 24/02/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHInsuranceTableViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHInsuranceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.mainView = [[UIView alloc] init];
    self.mainView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width);
        make.height.equalTo(self.contentView.height).offset(-15.0f);
    }];
    
    self.topView = [[UIView alloc] init];
    [self.mainView addSubview:self.topView];
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView.top);
        make.left.equalTo(self.mainView.left);
        make.width.equalTo(self.mainView.width);
        make.height.mas_equalTo(56.0f);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.attributedText = [self generateAttrStringWithText:@"赔付宝" image:[UIImage imageNamed:@"ic_coachmsg_peifu"]];
    [self.topView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.centerY);
        make.left.equalTo(self.topView.left).offset(20.0f);
    }];
    
    self.topLine = [[UIView alloc] init];
    self.topLine.backgroundColor = [UIColor HHLightLineGray];
    [self.topView addSubview:self.topLine];
    [self.topLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topView.bottom);
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
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
    
    self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_lipeifanwei"]];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.mainView addSubview:self.imgView];
    
    [self.imgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLine.bottom).offset(15.0f);
        make.centerX.equalTo(self.mainView.centerX);
        make.width.equalTo(self.mainView.width).offset(-40.0f);
        make.height.mas_equalTo(210.0f);
    }];
}

- (NSAttributedString *)generateAttrStringWithText:(NSString *)text image:(UIImage *)image {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentNatural;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", text] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHOrange], NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = image;
    textAttachment.bounds = CGRectMake(0, -2.0f, textAttachment.image.size.width, textAttachment.image.size.height);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedString insertAttributedString:attrStringWithImage atIndex:0];
    return attributedString;
}

- (void)questionButtonTapped {
    if (self.questionAction) {
        self.questionAction();
    }
}

@end
