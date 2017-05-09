//
//  HHSchoolGrouponTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 07/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHSchoolGrouponTableViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHSchoolGrouponTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor HHLightBackgroudGray];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.mainView = [[UIView alloc] init];
    self.mainView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.mainView];

    self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_schooldetails_tg_hui"]];
    [self.mainView addSubview:self.imgView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor HHDarkOrange];
    self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.titleLabel.text = @"本月组团优惠火热报名中~";
    [self.mainView addSubview:self.titleLabel];
    
    self.subTitleLabel = [[UILabel alloc] init];
    [self.mainView addSubview:self.subTitleLabel];
    
    self.arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_coachmsg_more_arrow"]];
    [self.mainView addSubview:self.arrowView];
    
    [self makeConstraints];

}

- (void)makeConstraints {
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width);
        make.top.equalTo(self.contentView.top).offset(10.0f);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    [self.imgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mainView.centerY);
        make.left.equalTo(self.contentView.left).offset(15.0f);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mainView.centerY);
        make.left.equalTo(self.imgView.right).offset(3.0f);
    }];
    
    [self.arrowView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-15.0f);
        make.centerY.equalTo(self.mainView.centerY);
    }];
    
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowView.left).offset(-3.0f);
        make.centerY.equalTo(self.mainView.centerY);
    }];
}

- (void)setupCellWithSchool:(HHDrivingSchool *)school {
    self.subTitleLabel.attributedText = [self generateCountStringWithSchool:school];
}

- (NSMutableAttributedString *)generateCountStringWithSchool:(HHDrivingSchool *)school {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[school.grouponCount stringValue] attributes:@{NSForegroundColorAttributeName:[UIColor HHOrange], NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}];
    
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:@"人已参与" attributes:@{NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}];
    
    [attrString appendAttributedString:attrString2];
    return attrString;
}

@end
