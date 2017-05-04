//
//  HHHotSchoolsTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 03/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHHotSchoolsTableViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHConstantsStore.h"

@implementation HHHotSchoolsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor HHLightBackgroudGray];
        [self initSubviews];
    }
    return  self;
}

- (void)initSubviews {
    
    self.titleContainerView = [[UIView alloc] init];
    self.titleContainerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleContainerView];
    
    self.botContainerView = [[UIView alloc] init];
    self.botContainerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.botContainerView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor HHTextDarkGray];
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    self.titleLabel.text = @"大家都在搜";
    [self.titleContainerView addSubview:self.titleLabel];
    
    self.hotView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_hot"]];
    [self.titleContainerView addSubview:self.hotView];
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = [UIColor HHLightLineGray];
    [self.titleContainerView addSubview:self.line];
    
    [self buildSchoolViews];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.titleContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width);
        make.height.mas_equalTo(45.0f);
        make.top.equalTo(self.contentView.top).offset(10.0f);
    }];
    
    [self.botContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(self.contentView.width);
        make.bottom.equalTo(self.contentView.bottom).offset(-10.0f);
        make.top.equalTo(self.titleContainerView.bottom);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleContainerView.left).offset(15.0f);
        make.centerY.equalTo(self.titleContainerView.centerY);
    }];
    
    [self.hotView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.right).offset(3.0f);
        make.centerY.equalTo(self.titleLabel.top);
    }];
    
    [self.line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleContainerView.left);
        make.bottom.equalTo(self.titleContainerView.bottom);
        make.width.equalTo(self.titleContainerView.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
}

- (void)buildSchoolViews {
    NSArray *schools = [[HHConstantsStore sharedInstance] getDrivingSchools];
    for (int i = 0; i < 8; i++) {
        HHDrivingSchool *school = schools[i];
        UIButton *schoolButton = [UIButton buttonWithType:UIButtonTypeCustom];
        schoolButton.backgroundColor = [UIColor HHLightBackgroudGray];
        [schoolButton setTitle:school.schoolName forState:UIControlStateNormal];
        [schoolButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
        schoolButton.layer.masksToBounds = YES;
        schoolButton.layer.cornerRadius = 10.0f;
        schoolButton.tag = i;
        schoolButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        schoolButton.titleLabel.minimumScaleFactor = 0.5f;
        schoolButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.botContainerView addSubview:schoolButton];
        [schoolButton makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20.0f);
            make.width.mas_equalTo(70.0f);
            if (i/4 == 0) {
                make.bottom.equalTo(self.botContainerView.centerY).offset(-5.0f);
            } else {
                make.top.equalTo(self.botContainerView.centerY).offset(5.0f);
            }
            
            NSInteger indexX = i % 4;
            make.centerX.equalTo(self.botContainerView.centerX).multipliedBy((1 + 2 * indexX)/4.0f);
            
        }];
    }
}

@end
