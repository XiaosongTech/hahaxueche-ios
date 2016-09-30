//
//  HHCoachDetailSectionTwoCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/11/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachDetailSectionTwoCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHCoachDetailSectionTwoCell

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
    self.satisfactionCell = [[HHCoachDetailSingleInfoView alloc] init];
    [self.contentView addSubview:self.satisfactionCell];
    
    self.coachLevelCell = [[HHCoachDetailSingleInfoView alloc] init];
    [self.contentView addSubview:self.coachLevelCell];
    
    self.coachTimeCell= [[HHCoachDetailSingleInfoView alloc] init];
    self.coachTimeCell.valueLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.contentView addSubview:self.coachTimeCell];
    
    self.verticalLine = [[UIView alloc] init];
    self.verticalLine.backgroundColor = [UIColor HHLightLineGray];
    [self.contentView addSubview:self.verticalLine];
    
    self.horizontalLine = [[UIView alloc] init];
    self.horizontalLine.backgroundColor = [UIColor HHLightLineGray];
    [self.contentView addSubview:self.horizontalLine];
    
    self.secHorizontalLine = [[UIView alloc] init];
    self.secHorizontalLine.backgroundColor = [UIColor HHLightLineGray];
    [self.contentView addSubview:self.secHorizontalLine];
    
    self.coachesListCell = [[HHCollaborateCoachesView alloc] init];
    [self.contentView addSubview:self.coachesListCell];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.satisfactionCell makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(15.0f);
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width).multipliedBy(0.5f);
        make.height.mas_equalTo(90.0f);
    }];
    
    [self.verticalLine makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.satisfactionCell.centerY);
        make.centerX.equalTo(self.contentView.centerX);
        make.height.mas_equalTo(60.0f);
        make.width.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.coachLevelCell makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(15.0f);
        make.left.equalTo(self.satisfactionCell.right);
        make.width.equalTo(self.contentView.width).multipliedBy(0.5f);
        make.height.mas_equalTo(90.0f);
    }];
    
    [self.horizontalLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.satisfactionCell.bottom);
        make.centerX.equalTo(self.contentView.centerX);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        make.width.equalTo(self.contentView.width);
    }];
    
    [self.coachTimeCell makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.horizontalLine.bottom);
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width);
        make.height.mas_equalTo(90.0f);
    }];
    
    [self.secHorizontalLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coachTimeCell.bottom);
        make.centerX.equalTo(self.contentView.centerX);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        make.width.equalTo(self.contentView.width);
    }];
    
    [self.coachesListCell makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secHorizontalLine.bottom);
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width);
        make.bottom.equalTo(self.contentView.bottom);
    }];
}


- (void)setupWithCoach:(HHCoach *)coach {
    [self.satisfactionCell setupViewWithTitle:@"学员满意度" image:[UIImage imageNamed:@"ic_coachmsg_manyidu"] value:[coach satistactionString] showArrowImage:NO actionBlock:nil];
    
    [self.coachLevelCell setupViewWithTitle:@"教练等级认证" image:[UIImage imageNamed:@"ic_coachmsg_coachlevel"] value:[coach skillLevelString] showArrowImage:NO actionBlock:nil];
    if ([coach isGoldenCoach]) {
        self.coachLevelCell.iconView.hidden = NO;
    } else {
        self.coachLevelCell.iconView.hidden = YES;
    }
    
    [self.coachTimeCell setupViewWithTitle:@"教练练车时间" image:[UIImage imageNamed:@"ic_coachmsg_time"] value:@"周一至周日全天可选，具体情况以实际发布为准" showArrowImage:NO actionBlock:nil];
    self.coachTimeCell.valueLabel.numberOfLines = 1;
    self.coachTimeCell.valueLabel.adjustsFontSizeToFitWidth = YES;
    self.coachTimeCell.valueLabel.minimumScaleFactor = 0.1f;
    
    if ([coach.peerCoaches count]) {
         self.coachesListCell.hidden = NO;
        [self.coachesListCell setupCellWithCoaches:coach.peerCoaches];
    } else {
        self.coachesListCell.hidden = YES;
    }
    
    
}

@end
