//
//  HHDrivingSchoolListViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 02/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHDrivingSchoolListViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHFormatUtility.h"
#import "NSNumber+HHNumber.h"
#import <UIImageView+WebCache.h>
#import "HHSupportUtility.h"

@implementation HHDrivingSchoolListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
    }
    return  self;
}

- (void)initSubviews {
    self.avatarView = [[UIImageView alloc] init];
    self.avatarView.contentMode = UIViewContentModeScaleAspectFill;

    [self.contentView addSubview:self.avatarView];
    
    self.nameLabel = [self createLabelWithFont:[UIFont systemFontOfSize:20.0f] textColor:[UIColor HHTextDarkGray]];
    [self.nameLabel sizeToFit];
    [self.contentView addSubview:self.nameLabel];
    
    self.starRatingView = [[HHStarRatingView alloc] initWithInteraction:NO];
    self.starRatingView.value = 5.0;
    [self.contentView addSubview:self.starRatingView];
    
    self.ratingLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.ratingLabel];
    
    self.priceTitleLabel = [self createLabelWithFont:[UIFont systemFontOfSize:11.0f] textColor:[UIColor whiteColor]];
    self.priceTitleLabel.backgroundColor = [UIColor HHOrange];
    self.priceTitleLabel.layer.masksToBounds = YES;
    self.priceTitleLabel.layer.cornerRadius = 3.0f;
    self.priceTitleLabel.text = @"超值";
    [self.priceTitleLabel sizeToFit];
    [self.contentView addSubview:self.priceTitleLabel];
    
    self.priceLabel = [self createLabelWithFont:[UIFont boldSystemFontOfSize:18.0f] textColor:[UIColor HHOrange]];
    [self.contentView addSubview:self.priceLabel];
    
    self.priceArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_homepage_knowmore_arrow"]];
    [self.contentView addSubview:self.priceArrow];
    
    self.callButton = [[HHGradientButton alloc] initWithType:0];
    [self.callButton setAttributedTitle:[self generateCallButtonText] forState:UIControlStateNormal];
    self.callButton.layer.masksToBounds = YES;
    self.callButton.layer.borderColor = [UIColor HHLightLineGray].CGColor;
    self.callButton.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
    self.callButton.layer.cornerRadius = 3.0f;
    [self.callButton addTarget:self action:@selector(callSchool) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.callButton];
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [UIColor HHLightLineGray];
    [self.contentView addSubview:self.bottomLine];
    
    
    self.consultNumLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.consultNumLabel];
    
    self.fieldContainerView = [[UIView alloc] init];
    [self.contentView addSubview:self.fieldContainerView];
    
    self.fieldContainerLine = [[UIView alloc] init];
    self.fieldContainerLine.backgroundColor = [UIColor HHLightLineGray];
    [self.contentView addSubview:self.fieldContainerLine];
    
    self.fieldLeftLabel = [[UILabel alloc] init];
    [self.fieldContainerView addSubview:self.fieldLeftLabel];
    
    self.fieldRightLabel = [[UILabel alloc] init];
    [self.fieldContainerView addSubview:self.fieldRightLabel];
    
    self.grouponView = [self buildGrouponView];
    [self.contentView addSubview:self.grouponView];
    
    [self makeConstraints];
}


- (UILabel *)createLabelWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)makeConstraints {
    [self.avatarView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(15.0f);
        make.left.equalTo(self.left).offset(15.0f);
        make.width.mas_equalTo(80.0f);
        make.height.mas_equalTo(60.0f);
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.right).offset(15.0f);
        make.top.equalTo(self.top).offset(16.0f);
    }];
    
    [self.starRatingView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.top.equalTo(self.nameLabel.bottom).offset(5.0f);
        make.height.mas_equalTo(20.0f);
        make.width.mas_equalTo(80.0f);
    }];
    
    [self.ratingLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starRatingView.right).offset(3.0f);
        make.centerY.equalTo(self.starRatingView.centerY);
    }];
    
    [self.fieldContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.top.equalTo(self.starRatingView.bottom);
        make.right.equalTo(self.contentView.right);
        make.height.mas_equalTo(30.0f);
    }];
    
    [self.fieldLeftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fieldContainerView.left);
        make.centerY.equalTo(self.fieldContainerView.centerY);
    }];
    
    [self.fieldRightLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fieldContainerView.right).offset(-15.0f);
        make.centerY.equalTo(self.fieldContainerView.centerY);
    }];
    
    [self.fieldContainerLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fieldContainerView.left);
        make.bottom.equalTo(self.fieldContainerView.bottom);
        make.width.equalTo(self.fieldContainerView.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.priceArrow makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-15.0f);
        make.centerY.equalTo(self.nameLabel.centerY);
    }];
    
    [self.priceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceArrow.left).offset(-5.0f);
        make.centerY.equalTo(self.priceArrow.centerY);
    }];
    
    [self.priceTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLabel.left).offset(-5.0f);
        make.centerY.equalTo(self.priceArrow.centerY);
        make.width.mas_equalTo(CGRectGetWidth(self.priceTitleLabel.frame) + 6.0f);
        make.height.mas_equalTo(CGRectGetHeight(self.priceTitleLabel.frame) + 2.0f);
    }];
    
    [self.callButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.avatarView.centerX);
        make.width.equalTo(self.avatarView.width).offset(-10.0f);
        make.height.mas_equalTo(18.0f);
        make.top.equalTo(self.avatarView.bottom).offset(8.0f);
    }];
    
    [self.consultNumLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.avatarView.centerX);
        make.top.equalTo(self.callButton.bottom).offset(3.0f);
        make.width.lessThanOrEqualTo(self.avatarView.width).offset(20.0f);
    }];
    
    [self.grouponView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fieldContainerView.left);
        make.top.equalTo(self.fieldContainerView.bottom);
        make.width.equalTo(self.fieldContainerView.width);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    
    [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom);
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.right);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];

    
}


- (void)setupCellWithSchool:(HHDrivingSchool *)school {
    
    self.school = school;
    self.ratingLabel.attributedText = [self generateRatingTextWithSchool:school];
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:school.avatar] placeholderImage:[UIImage imageNamed:@"ic_coach_ava"]];
    self.nameLabel.text = school.schoolName;
    
    self.starRatingView.value = [school.rating floatValue];
    self.consultNumLabel.attributedText = [self generatateCallNumTextWithSchool:school];
    
    self.priceLabel.text = [school.lowestPrice generateMoneyString];
    self.fieldLeftLabel.attributedText = [self generateDistanceWithSchool:school isLeftText:YES];
    self.fieldRightLabel.attributedText = [self generateDistanceWithSchool:school isLeftText:NO];
}

- (NSMutableAttributedString *)generatateCallNumTextWithSchool:(HHDrivingSchool *)school {
    if (!school.consultCount) {
        return nil;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentNatural;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[school.consultCount generateLargeNumberString] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f], NSForegroundColorAttributeName:[UIColor HHOrange], NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:@"人已咨询" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:paragraphStyle}];
    [attributedString appendAttributedString:attributedString2];
    
    return attributedString ;
}

- (NSMutableAttributedString *)generateRatingTextWithSchool:(HHDrivingSchool *)school {
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f",[school.rating floatValue]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
    
    NSMutableAttributedString *attString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" (%@)", [school.reviewCount stringValue]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor HHLightestTextGray]}];
    [attString appendAttributedString:attString2];
    return attString;
}

- (NSMutableAttributedString *)generateCallButtonText {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentNatural;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"联系驾校" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f], NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"list_ic_phone"];
    textAttachment.bounds = CGRectMake(-2.0f, -2.0f, textAttachment.image.size.width, textAttachment.image.size.height);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedString insertAttributedString:attrStringWithImage atIndex:0];
    return attributedString;
}

- (NSMutableAttributedString *)generateDistanceWithSchool:(HHDrivingSchool *)school isLeftText:(BOOL)isLeftText {
    if (!school) {
        return nil;
    }
    
    if (isLeftText) {
        if ([school.distance floatValue] > 0) {
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"最近训练场距您" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
            NSMutableAttributedString *attString2;
            if ([school.distance floatValue] > 50.0f) {
                attString2 = [[NSMutableAttributedString alloc] initWithString:@"50+" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
            } else {
                attString2 = [[NSMutableAttributedString alloc] initWithString:[school.distance stringValue] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
            }
            [attString appendAttributedString:attString2];
            
            NSMutableAttributedString *attString3 = [[NSMutableAttributedString alloc] initWithString:@"km" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
            [attString appendAttributedString:attString3];
            return attString;
        } else {
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"共有" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
            NSMutableAttributedString *attString2 = [[NSMutableAttributedString alloc] initWithString:[school.fieldCount stringValue] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
            [attString appendAttributedString:attString2];
            
            NSMutableAttributedString *attString3 = [[NSMutableAttributedString alloc] initWithString:@"个训练场" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
            [attString appendAttributedString:attString3];
            return attString;
        }
        
    } else {
        if ([school.distance floatValue] > 0) {
            if (!school.nearestFieldZone) {
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                textAttachment.image = [UIImage imageNamed:@"ic_homepage_knowmore_arrow"];
                textAttachment.bounds = CGRectMake(0, -2, textAttachment.image.size.width, textAttachment.image.size.height);
    
                return [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
            }
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ", school.nearestFieldZone] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
            
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
            textAttachment.image = [UIImage imageNamed:@"ic_list_local_btn"];
            textAttachment.bounds = CGRectMake(0, -2, textAttachment.image.size.width, textAttachment.image.size.height);
            
            NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [attString insertAttributedString:attrStringWithImage atIndex:0];
            
            textAttachment = [[NSTextAttachment alloc] init];
            textAttachment.image = [UIImage imageNamed:@"ic_homepage_knowmore_arrow"];
            textAttachment.bounds = CGRectMake(0, -2, textAttachment.image.size.width, textAttachment.image.size.height);
            attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [attString appendAttributedString:attrStringWithImage];
            return attString;
        } else {
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"点击查看最近" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
            textAttachment.image = [UIImage imageNamed:@"ic_homepage_knowmore_arrow"];
            textAttachment.bounds = CGRectMake(0, -2, textAttachment.image.size.width, textAttachment.image.size.height);
            NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [attString appendAttributedString:attrStringWithImage];
            return attString;
        }
    }
}

- (UIView *)buildGrouponView {
    UIView *view = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] init];
    [view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left);
        make.centerY.equalTo(view.centerY);
    }];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"schoollist_ic_tuan"];
    textAttachment.bounds = CGRectMake(0, -3, textAttachment.image.size.width, textAttachment.image.size.height);
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@" 八校联名降价 组团立减¥200" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
    [attString insertAttributedString:attrStringWithImage atIndex:0];
    label.attributedText = attString;
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_homepage_knowmore_arrow"]];
    [view addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.right).offset(-15.0f);
        make.centerY.equalTo(view.centerY);
    }];
    
    
    return view;
}

- (void)callSchool {
    [[HHSupportUtility sharedManager] callSupportWithNumber:self.school.consultPhone];
}

@end
