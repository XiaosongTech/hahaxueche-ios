//
//  HHHomePageDrivingSchoolView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 14/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHHomePageDrivingSchoolView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSNumber+HHNumber.h"

@implementation HHHomePageDrivingSchoolView

- (instancetype)initWithDrivingSchool:(HHDrivingSchool *)school {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0f;
        self.layer.borderColor = [UIColor HHLightLineGray].CGColor;
        self.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
        
        UIImageView * avatarView = [[UIImageView alloc] init];
        avatarView.contentMode = UIViewContentModeScaleAspectFit;
        [avatarView sd_setImageWithURL:[NSURL URLWithString:school.avatar]];
        [self addSubview:avatarView];
        [avatarView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(70.0f);
            make.left.equalTo(self.left);
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7f];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = school.schoolName;
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.numberOfLines = 1;
        nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.minimumScaleFactor = 0.5;
        nameLabel.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:nameLabel];
        [nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(avatarView.bottom);
            make.width.equalTo(avatarView.width);
            make.height.mas_equalTo(20.0f);
            make.left.equalTo(avatarView.left);
        }];
        
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.attributedText = [self generateAttrStringWithPrice:school.lowestPrice];
        [self addSubview:priceLabel];
        [priceLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.bottom);
            make.width.equalTo(self.width);
            make.bottom.equalTo(self.bottom);
            make.left.equalTo(self.left);
        }];
    }
    return self;
}

- (NSAttributedString *)generateAttrStringWithPrice:(NSNumber *)price {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[price generateMoneyString] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor HHOrange], NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:@"起" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f], NSForegroundColorAttributeName:[UIColor HHLightestTextGray], NSParagraphStyleAttributeName:paragraphStyle}];

    [attributedString appendAttributedString:attributedString2];
    return attributedString;
    
    
}

@end
