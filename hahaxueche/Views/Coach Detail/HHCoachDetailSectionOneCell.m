//
//  HHCoachDetailSectionOneCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachDetailSectionOneCell.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "NSNumber+HHNumber.h"

@implementation HHCoachDetailSectionOneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.priceCell = [[HHCoachDetailSingleInfoView alloc] init];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(priceCellTapped)];
    [self.priceCell addGestureRecognizer:tapRecognizer];
    [self.contentView addSubview:self.priceCell];
    
    self.courseTypeCell = [[HHCoachDetailSingleInfoView alloc] init];
    self.courseTypeCell.valueLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.contentView addSubview:self.courseTypeCell];
    
    self.fieldAddressCell= [[HHCoachDetailSingleInfoView alloc] init];
    self.fieldAddressCell.valueLabel.font = [UIFont systemFontOfSize:16.0f];
    UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fieldAddressCellTapped)];
    [self.fieldAddressCell addGestureRecognizer:tapRecognizer2];
    [self.contentView addSubview:self.fieldAddressCell];
    
    self.verticalLine = [[UIView alloc] init];
    self.verticalLine.backgroundColor = [UIColor HHLightLineGray];
    [self.contentView addSubview:self.verticalLine];
    
    self.horizontalLine = [[UIView alloc] init];
    self.horizontalLine.backgroundColor = [UIColor HHLightLineGray];
    [self.contentView addSubview:self.horizontalLine];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.priceCell makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(15.0f);
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width).multipliedBy(0.5f);
        make.height.mas_equalTo(90.0f);
    }];
    
    [self.verticalLine makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceCell.centerY);
        make.centerX.equalTo(self.contentView.centerX);
        make.height.mas_equalTo(60.0f);
        make.width.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.courseTypeCell makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(15.0f);
        make.left.equalTo(self.priceCell.right);
        make.width.equalTo(self.contentView.width).multipliedBy(0.5f);
        make.height.mas_equalTo(90.0f);
    }];
    
    [self.horizontalLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceCell.bottom);
        make.centerX.equalTo(self.contentView.centerX);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        make.width.equalTo(self.contentView.width);
    }];
    
    [self.fieldAddressCell makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.horizontalLine.bottom);
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width);
        make.height.mas_equalTo(90.0f);
    }];
}


- (void)setupWithCoach:(HHCoach *)coach field:(HHField *)field {
    [self.priceCell setupViewWithTitle:@"拿证价格" image:[UIImage imageNamed:@"ic_coachmsg_charge"] value:[coach.price generateMoneyString] showArrowImage:YES actionBlock:nil];
    
    [self.courseTypeCell setupViewWithTitle:@"课程类型" image:[UIImage imageNamed:@"ic_coachmsg_classtype"] value:[coach licenseTypesName] showArrowImage:NO actionBlock:nil];
    
    [self.fieldAddressCell setupViewWithTitle:@"训练场地址" image:[UIImage imageNamed:@"ic_coachmsg_localtion"] value:[field fullAddress] showArrowImage:YES actionBlock:nil];

}

- (void)priceCellTapped {
    if (self.priceCellAction) {
        self.priceCellAction();
    }
}

- (void)fieldAddressCellTapped {
    if (self.addressCellAction) {
        self.addressCellAction();
    }
}

@end
