//
//  HHTestQuestionView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/11/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHTestQuestionView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import <UIImageView+WebCache.h>

@interface HHTestQuestionView ()

@property (nonatomic, strong) HHQuestion *question;

@property (nonatomic, strong) UIView *questionTitleContainerView;
@property (nonatomic, strong) UILabel *questionTypeLabel;
@property (nonatomic, strong) UILabel *questionTitleLabel;
@property (nonatomic, strong) UIButton *starView;
@property (nonatomic, strong) UIImageView *imgView;;
@property (nonatomic, strong) UILabel *favoriteLabel;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation HHTestQuestionView

- (instancetype)initWithQuestion:(HHQuestion *)question {
    self = [super init];
    if (self) {
        self.question = question;
        self.backgroundColor = [UIColor HHBackgroundGary];
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.questionTitleContainerView = [[UIView alloc] init];
    self.questionTitleContainerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.questionTitleContainerView];
    
    self.questionTypeLabel = [[UILabel alloc] init];
    self.questionTypeLabel.textColor = [UIColor HHOrange];
    self.questionTypeLabel.font = [UIFont systemFontOfSize:12.0f];
    self.questionTypeLabel.layer.masksToBounds = YES;
    self.questionTypeLabel.textAlignment = NSTextAlignmentCenter;
    self.questionTypeLabel.layer.cornerRadius = 9.0f;
    self.questionTypeLabel.layer.borderColor = [UIColor HHOrange].CGColor;
    self.questionTypeLabel.layer.borderWidth = 2.0f/[UIScreen mainScreen].scale;
    if ([self.question isSingleAnswer]) {
        self.questionTypeLabel.text = @"单选题";
    } else {
        self.questionTypeLabel.text = @"多选题";
    }
    [self.questionTitleContainerView addSubview:self.questionTypeLabel];
    
    self.questionTitleLabel = [[UILabel alloc] init];
    self.questionTitleLabel.textColor = [UIColor HHLightTextGray];
    self.questionTitleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.questionTitleLabel.numberOfLines = 0;
    self.questionTitleLabel.text = self.question.questionDes;
    [self.questionTitleContainerView addSubview:self.questionTitleLabel];
    
    self.starView = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.starView addTarget:self action:@selector(starTapped) forControlEvents:UIControlEventTouchUpInside];
    if ([self.question isFavorated]) {
        [self.starView setBackgroundImage:[UIImage imageNamed:@"ic_question_alcollect"] forState:UIControlStateNormal];
    } else {
        [self.starView setBackgroundImage:[UIImage imageNamed:@"ic_question_collect"] forState:UIControlStateNormal];
    }
    [self.questionTitleContainerView addSubview:self.starView];
    
    self.favoriteLabel = [[UILabel alloc] init];
    if ([self.question isFavorated]) {
        self.favoriteLabel.text = @"已收藏";

    } else {
        self.favoriteLabel.text = @"收藏";

    }
    self.favoriteLabel.textColor = [UIColor HHOrange];
    self.favoriteLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.questionTitleContainerView addSubview:self.favoriteLabel];

    if ([self.question hasImage]) {
        self.imgView = [[UIImageView alloc] init];
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.question.imgURL]];
        [self.questionTitleContainerView addSubview:self.imgView];
    }
   
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    [self makeConstraints];
    
}

- (void)makeConstraints {
    
    [self.questionTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.questionTypeLabel.right).offset(10.0f);
        make.right.equalTo(self.questionTitleContainerView.right).offset(-50.0f);
        make.top.equalTo(self.questionTitleContainerView.top).offset(20.0f);
    }];
    
    if ([self.question hasImage]) {
        [self.imgView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.questionTitleContainerView.centerX);
            make.top.equalTo(self.questionTitleLabel.bottom).offset(20.0f);
            make.width.lessThanOrEqualTo(self.questionTitleContainerView.width);
        }];
        [self.questionTitleContainerView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.left.equalTo(self.left);
            make.bottom.equalTo(self.imgView.bottom).offset(20.0f);
            make.width.equalTo(self.width);
        }];

    } else {
        [self.questionTitleContainerView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.left.equalTo(self.left);
            make.height.equalTo(self.questionTitleLabel.height).offset(50.0f);
            make.width.equalTo(self.width);
        }];

    }
    
    
    [self.questionTypeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.questionTitleLabel.top);
        make.left.equalTo(self.questionTitleContainerView.left).offset(20.0f);
        make.height.mas_equalTo(18.0f);
        make.width.mas_equalTo(50.0f);
    }];
    
    [self.starView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.questionTitleLabel.top);
        make.right.equalTo(self.questionTitleContainerView.right).offset(-20.0f);
    }];
    
    [self.favoriteLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starView.bottom).offset(2.0f);
        make.centerX.equalTo(self.starView.centerX);
    }];
}

- (void)starTapped {
    
}

@end
