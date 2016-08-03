//
//  HHWithdrawHistoryCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/27/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHWithdrawHistoryCell.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "NSNumber+HHNumber.h"
#import "HHFormatUtility.h"

@implementation HHWithdrawHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.textColor = [UIColor HHLightTextGray];
    self.statusLabel.font = [UIFont systemFontOfSize:18.0f];
    [self.contentView addSubview:self.statusLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor HHLightestTextGray];
    self.timeLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:self.timeLabel];
    
    self.moneyLabel = [[UILabel alloc] init];
    self.moneyLabel.textColor = [UIColor HHOrange];
    self.moneyLabel.font = [UIFont systemFontOfSize:30.0f];
    [self.contentView addSubview:self.moneyLabel];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    
    [self.statusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.centerY);
        make.right.equalTo(self.contentView.right).offset(-20.0f);
    }];
    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.centerY).offset(5.0f);
        make.right.equalTo(self.contentView.right).offset(-20.0f);
    }];
    
    [self.moneyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.left.equalTo(self.contentView.left).offset(20.0f);
    }];
}

- (void)setupCellWithWithdraw:(HHWithdraw *)withdraw {
    self.statusLabel.text = @"成功";
    self.timeLabel.text = [[HHFormatUtility fullDateWithoutSecFormatter] stringFromDate:withdraw.redeemedDate];
    self.moneyLabel.text = [withdraw.amount generateMoneyString];
}

@end
