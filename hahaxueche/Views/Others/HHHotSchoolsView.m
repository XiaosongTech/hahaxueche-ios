//
//  HHHotSchoolsView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 09/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHHotSchoolsView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHConstantsStore.h"

@implementation HHHotSchoolsView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.titleContainerView = [[UIView alloc] init];
    self.titleContainerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleContainerView];
    
    self.botContainerView = [[UIView alloc] init];
    self.botContainerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.botContainerView];
    
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
    
    self.botLine = [[UIView alloc] init];
    self.botLine.backgroundColor = [UIColor HHLightLineGray];
    [self addSubview:self.botLine];
    
    [self buildSchoolViews];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.titleContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(45.0f);
        make.top.equalTo(self.top);
    }];
    
    [self.botContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.bottom.equalTo(self.bottom);
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
    
    [self.botLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleContainerView.left);
        make.bottom.equalTo(self.bottom);
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
        
        [schoolButton addTarget:self action:@selector(schoolTapped:) forControlEvents:UIControlEventTouchUpInside];
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


- (void)schoolTapped:(UIButton *)button {
    if (self.schoolBlock) {
        self.schoolBlock([[HHConstantsStore sharedInstance] getDrivingSchools][button.tag]);
    }
}

@end
