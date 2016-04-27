//
//  HHReferFriendsCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/27/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHReferFriendsCell.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "NSNumber+HHNumber.h"

@implementation HHReferFriendsCell

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
    self.avaView = [[UIImageView alloc] init];
    self.avaView.layer.masksToBounds = YES;
    self.avaView.layer.cornerRadius = 30.0f;
    [self.contentView addSubview:self.avaView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor HHTextDarkGray];
    self.nameLabel.font = [UIFont systemFontOfSize:22.0f];
    [self.contentView addSubview:self.nameLabel];
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.textColor = [UIColor HHLightTextGray];
    self.statusLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:self.statusLabel];
    
    self.moneyLabel = [[UILabel alloc] init];
    self.moneyLabel.textColor = [UIColor HHOrange];
    self.moneyLabel.font = [UIFont systemFontOfSize:24.0f];
    [self.contentView addSubview:self.moneyLabel];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.avaView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.left.equalTo(self.left).offset(20.0f);
        make.width.mas_equalTo(60.0f);
        make.height.mas_equalTo(60.0f);
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY).offset(-12.0f);
        make.left.equalTo(self.avaView.right).offset(12.0f);
    }];
    [self.statusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY).offset(15.0f);
        make.left.equalTo(self.avaView.right).offset(12.0f);
    }];
    
    [self.moneyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.right.equalTo(self.contentView.right).offset(-15.0f);
    }];
}

- (void)setupCellWithReferral:(HHReferral *)referral {
    self.avaView.image = [UIImage imageNamed:@"ic_share"];
    self.nameLabel.text = @"王子潇";
    self.statusLabel.text = @"已经报名教练并付款";
    self.moneyLabel.text = [@(5000) generateMoneyString];
}


@end
