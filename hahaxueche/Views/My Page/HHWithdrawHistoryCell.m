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
    
    
    self.mainLabel = [[UILabel alloc] init];
    self.mainLabel.textColor = [UIColor HHLightTextGray];
    self.mainLabel.font = [UIFont systemFontOfSize:18.0f];
    [self.contentView addSubview:self.mainLabel];
    
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
    
    [self.mainLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY).offset(-8.0f);
        make.left.equalTo(self.contentView.left).offset(20.0f);
    }];
    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY).offset(12.0f);
        make.left.equalTo(self.contentView.left).offset(20.0f);
    }];
    
    [self.moneyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.right.equalTo(self.contentView.right).offset(-15.0f);
    }];
}

- (void)setupCellWithWithdraw:(HHWithdraw *)withdraw {
    self.mainLabel.text = @"推荐有奖提现";
    self.timeLabel.text = @"2016-04-08";
    self.moneyLabel.text = [@(5000) generateMoneyString];
}

@end
