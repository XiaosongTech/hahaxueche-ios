//
//  HHCoachListViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachListViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIView+HHRect.h"
#import "HHFormatUtility.h"
#import "NSNumber+HHNumber.h"
#import <UIImageView+WebCache.h>
#import "HHSupportUtility.h"

static CGFloat const kAvatarRadius = 30.0f;

@implementation HHCoachListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
    }
    return  self;
}

- (void)initSubviews {
    __weak HHCoachListViewCell *weakSelf = self;
    self.avatarView = [[UIImageView alloc] init];
    self.avatarView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarView.layer.cornerRadius = kAvatarRadius;
    self.avatarView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.avatarView];
    
    self.nameLabel = [self createLabelWithFont:[UIFont systemFontOfSize:20.0f] textColor:[UIColor HHTextDarkGray]];
    [self.nameLabel sizeToFit];
    [self.contentView addSubview:self.nameLabel];
    
    self.starRatingView = [[HHStarRatingView alloc] initWithInteraction:NO];
    self.starRatingView.value = 5.0;
    [self.contentView addSubview:self.starRatingView];
    
    self.ratingLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.ratingLabel];
    
    self.fieldLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.fieldLabel];
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [UIColor HHLightLineGray];
    [self.contentView addSubview:self.bottomLine];
    
    self.jiaxiaoView = [[HHCoachTagView alloc] init];
    self.jiaxiaoView.tapAction = ^(HHDrivingSchool *school) {
        if (weakSelf.drivingSchoolBlock) {
            weakSelf.drivingSchoolBlock(school);
        }
    };
    [self.contentView addSubview:self.jiaxiaoView];
    
    self.mapArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_homepage_knowmore_arrow"]];
    [self.contentView addSubview:self.mapArrow];
    
    self.callButton = [[HHGradientButton alloc] initWithType:0];
    [self.callButton setAttributedTitle:[self generateCallButtonText] forState:UIControlStateNormal];
    self.callButton.layer.masksToBounds = YES;
    self.callButton.layer.borderColor = [UIColor HHLightLineGray].CGColor;
    self.callButton.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
    self.callButton.layer.cornerRadius = 3.0f;
    [self.callButton addTarget:self action:@selector(callCoach) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.callButton];
    
    
    self.consultNumLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.consultNumLabel];
    
    [self makeConstraints];
    
}

- (void)makeConstraints {
    [self.avatarView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(15.0f);
        make.left.equalTo(self.contentView.left).offset(15.0f);
        make.width.mas_equalTo(kAvatarRadius * 2.0f);
        make.height.mas_equalTo(kAvatarRadius * 2.0f);
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.right).offset(20.0f);
        make.top.equalTo(self.contentView.top).offset(15.0f);
    }];
    
    [self.starRatingView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.top.equalTo(self.nameLabel.bottom).offset(3.0f);
        make.height.mas_equalTo(20.0f);
        make.width.mas_equalTo(80.0f);
    }];
    
    [self.ratingLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starRatingView.right).offset(3.0f);
        make.centerY.equalTo(self.starRatingView.centerY);
    }];
    
    [self.fieldLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.top.equalTo(self.starRatingView.bottom).offset(8.0f);
        make.right.lessThanOrEqualTo(self.contentView.right).offset(-25.0f);
    }];
    
    [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.bottom);
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.mapArrow makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fieldLabel.centerY);
        make.right.equalTo(self.contentView.right).offset(-15.0f);
    }];
    
    [self.callButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.avatarView.centerX);
        make.width.equalTo(self.avatarView.width).offset(5.0f);
        make.height.mas_equalTo(18.0f);
        make.top.equalTo(self.avatarView.bottom).offset(8.0f);
    }];
    
    [self.consultNumLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.avatarView.centerX);
        make.top.equalTo(self.callButton.bottom).offset(3.0f);
        make.width.lessThanOrEqualTo(self.avatarView.width).offset(20.0f);
    }];
    
}


- (UILabel *)createLabelWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
- (void)setupCellWithCoach:(HHCoach *)coach field:(HHField *)field {
    self.field = field;
    self.coach = coach;
    self.ratingLabel.attributedText = [self generateRatingTextWithCoach:coach];
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:coach.avatarUrl] placeholderImage:[UIImage imageNamed:@"ic_coach_ava"]];
    self.nameLabel.text = coach.name;
    
    self.starRatingView.value = [coach.averageRating floatValue];
    self.consultNumLabel.attributedText = [self generatateCallNumText];
    
    self.fieldLabel.attributedText = [self generateDistanceWithCoach:coach];
    
    if (coach.drivingSchool && ![coach.drivingSchool isEqualToString:@""]) {
        [self.jiaxiaoView setupWithDrivingSchool:[coach getCoachDrivingSchool]];
        self.jiaxiaoView.hidden = NO;
    } else {
        self.jiaxiaoView.hidden = YES;
    }
    
    if ([coach isGoldenCoach] || [coach.hasDeposit boolValue]) {
        if (self.badgeView) {
            [self.badgeView removeFromSuperview];
        }
        self.badgeView = [[HHCoachBadgeView alloc] initWithCoach:coach];
        [self.contentView addSubview:self.badgeView];
        [self.badgeView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.right).offset(3.0f);
            make.centerY.equalTo(self.nameLabel.centerY);
            make.right.equalTo(self.badgeView.preView.right);
        }];
    }
    
    [self.jiaxiaoView remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-15.0f);
        make.centerY.equalTo(self.nameLabel.centerY);
        make.width.equalTo(self.jiaxiaoView.label.width).offset(20.0f);
        make.height.mas_equalTo(16.0f);
    }];
    
    
    if (self.priceView) {
        [self.priceView removeFromSuperview];
        self.priceView = nil;
    }
    self.priceView = [[HHPriceView alloc] initWithTitle:@"超值" subTitle:@"快速拿证, 性价比高" price:coach.price];
    [self.contentView addSubview:self.priceView];
    [self.priceView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fieldLabel.bottom).offset(10.0f);
        make.left.equalTo(self.nameLabel.left);
        make.right.equalTo(self.contentView.right);
        make.bottom.equalTo(self.contentView.bottom);
    }];
}

#pragma mark - MapView Delegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    } else {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"ic_map_local_choseon"];
        annotationView.canShowCallout = YES;
        return annotationView;
        
    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for (MKAnnotationView *view in views) {
        if ([view.annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        [mapView selectAnnotation:view.annotation animated:NO];
    }
}

- (NSMutableAttributedString *)generateDistanceWithCoach:(HHCoach *)coach {
    HHField *field = [coach getCoachField];
    if (!field.district || !field.name) {
        return nil;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingMiddle;
    NSMutableAttributedString *baseString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ | %@", field.district, field.name] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:paragraphStyle}];
    
   
    if ([coach.distance doubleValue] > 50.0f) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"  距您" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
        
        NSMutableAttributedString *attString2 = [[NSMutableAttributedString alloc] initWithString:@"50+" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
        
        NSMutableAttributedString *attString3 = [[NSMutableAttributedString alloc] initWithString:@"km" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
        [baseString appendAttributedString:attString];
        [baseString appendAttributedString:attString2];
        [baseString appendAttributedString:attString3];
    } else if ([coach.distance doubleValue] <= 50.0f && [coach.distance doubleValue] > 0) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"  距您" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
        
        NSMutableAttributedString *attString2 = [[NSMutableAttributedString alloc] initWithString:[[HHFormatUtility floatFormatter] stringFromNumber:coach.distance] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
        
        NSMutableAttributedString *attString3 = [[NSMutableAttributedString alloc] initWithString:@"km" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
        [baseString appendAttributedString:attString];
        [baseString appendAttributedString:attString2];
        [baseString appendAttributedString:attString3];
    }
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"ic_list_local_btn"];
    textAttachment.bounds = CGRectMake(-2, -2, textAttachment.image.size.width, textAttachment.image.size.height);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [baseString insertAttributedString:attrStringWithImage atIndex:0];
    
    return baseString;
   
}

- (NSMutableAttributedString *)generateRatingTextWithCoach:(HHCoach *)coach {
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f",[coach.averageRating floatValue]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
    
    NSMutableAttributedString *attString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" (%@)", [coach.reviewCount stringValue]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor HHLightestTextGray]}];
    [attString appendAttributedString:attString2];
    return attString;
}

- (NSMutableAttributedString *)generateCallButtonText {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentNatural;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"联系教练" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f], NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"list_ic_phone"];
    textAttachment.bounds = CGRectMake(-2.0f, -2.0f, textAttachment.image.size.width, textAttachment.image.size.height);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedString insertAttributedString:attrStringWithImage atIndex:0];
    return attributedString;
}

- (NSMutableAttributedString *)generatateCallNumText {
    if (!self.coach.consultCount) {
        return nil;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentNatural;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[self.coach.consultCount generateLargeNumberString] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f], NSForegroundColorAttributeName:[UIColor HHOrange], NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:@"人已咨询" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:paragraphStyle}];
    [attributedString appendAttributedString:attributedString2];
    
    return attributedString ;
}

- (void)callCoach {
    [[HHSupportUtility sharedManager] callSupportWithNumber:self.coach.consultPhone];
}



@end
