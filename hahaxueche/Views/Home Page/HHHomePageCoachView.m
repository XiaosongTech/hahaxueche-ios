//
//  HHHomePageCoachView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 14/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHHomePageCoachView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSNumber+HHNumber.h"
#import "HHConstantsStore.h"
#import "HHFormatUtility.h"

@implementation HHHomePageCoachView

- (instancetype)initWithCoach:(HHCoach *)coach {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0f;
        self.layer.borderColor = [UIColor HHLightLineGray].CGColor;
        self.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
        
        UIImageView * avatarView = [[UIImageView alloc] init];
        avatarView.contentMode = UIViewContentModeScaleAspectFill;
        [avatarView sd_setImageWithURL:[NSURL URLWithString:coach.avatarUrl]];
        [self addSubview:avatarView];
        [avatarView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.width.equalTo(self.width).offset(-10.0f);
            make.height.equalTo(self.height).multipliedBy(3.0f/5.0f);
            make.top.equalTo(self.top).offset(5.0f);
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7f];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = coach.name;
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:nameLabel];
        [nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(avatarView.bottom);
            make.width.equalTo(avatarView.width);
            make.height.mas_equalTo(20.0f);
            make.left.equalTo(avatarView.left);
        }];
        
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.text = [coach.price generateMoneyString];;
        priceLabel.textColor = [UIColor HHOrange];
        priceLabel.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:priceLabel];
        [priceLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(avatarView.bottom).offset(5.0f);
            make.centerX.equalTo(self.centerX);
        }];
        
        UILabel *distanceLabel = [[UILabel alloc] init];
        distanceLabel.textAlignment = NSTextAlignmentCenter;
        distanceLabel.attributedText = [self generateAttrStringWithCoach:coach];
        [self addSubview:distanceLabel];
        [distanceLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(priceLabel.bottom);
            make.centerX.equalTo(self.centerX);
        }];

        
        
    }
    return self;
}

- (NSAttributedString *)generateAttrStringWithCoach:(HHCoach *)coach {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    if ([coach.distance floatValue] > 0) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"距您 " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f], NSForegroundColorAttributeName:[UIColor HHLightestTextGray], NSParagraphStyleAttributeName:paragraphStyle}];
        
        NSString *dis = [[HHFormatUtility floatFormatter] stringFromNumber:coach.distance];
        if ([coach.distance floatValue] > 50.0f) {
            dis = @"50+";
        }
        NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:dis attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHOrange], NSParagraphStyleAttributeName:paragraphStyle}];
        
        NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc] initWithString:@" km" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f], NSForegroundColorAttributeName:[UIColor HHLightestTextGray], NSParagraphStyleAttributeName:paragraphStyle}];
        
        [attributedString appendAttributedString:attributedString2];
        [attributedString appendAttributedString:attributedString3];
        return attributedString;
    } else {
        HHField *field = [[HHConstantsStore sharedInstance] getFieldWithId:coach.fieldId];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:field.district attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f], NSForegroundColorAttributeName:[UIColor HHLightestTextGray], NSParagraphStyleAttributeName:paragraphStyle}];
        
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:@"ic_list_local_btn"];
        textAttachment.bounds = CGRectMake(-2.0f, -2.0f, textAttachment.image.size.width, textAttachment.image.size.height);
        
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        
        [attributedString insertAttributedString:attrStringWithImage atIndex:0];
        return attributedString;
        
    }
    
    
}

@end
