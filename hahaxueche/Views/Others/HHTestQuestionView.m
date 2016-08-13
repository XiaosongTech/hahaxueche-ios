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
#import "HHOptionView.h"
#import "HHTestQuestionManager.h"

@interface HHTestQuestionView ()

@property (nonatomic, strong) HHQuestion *question;

@property (nonatomic, strong) UIView *questionTitleContainerView;
@property (nonatomic, strong) UILabel *questionTypeLabel;
@property (nonatomic, strong) UILabel *questionTitleLabel;
@property (nonatomic, strong) UIButton *starView;
@property (nonatomic, strong) UIImageView *imgView;;
@property (nonatomic, strong) UILabel *favoriteLabel;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *optionViews;

@end

@implementation HHTestQuestionView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor HHBackgroundGary];
        self.optionViews = [NSMutableArray array];
        
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
    [self.questionTitleContainerView addSubview:self.questionTypeLabel];
    
    self.questionTitleLabel = [[UILabel alloc] init];
    self.questionTitleLabel.textColor = [UIColor HHLightTextGray];
    self.questionTitleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.questionTitleLabel.numberOfLines = 0;
    [self.questionTitleContainerView addSubview:self.questionTitleLabel];
    
    self.starView = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.starView addTarget:self action:@selector(starTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.questionTitleContainerView addSubview:self.starView];
    
    self.favoriteLabel = [[UILabel alloc] init];
    self.favoriteLabel.textColor = [UIColor HHOrange];
    self.favoriteLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.questionTitleContainerView addSubview:self.favoriteLabel];
    
    self.imgView = [[UIImageView alloc] init];
    [self.questionTitleContainerView addSubview:self.imgView];
   
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    
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
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.top.equalTo(self.questionTitleContainerView.bottom);
        make.height.equalTo(self.height).offset(CGRectGetHeight(self.questionTitleContainerView.bounds));
    }];
}

- (void)fillUpViewWithQuestion:(HHQuestion *)question favorated:(BOOL)favorated {
    self.question = question;
    self.questionTitleLabel.text = self.question.questionDes;
    self.questionTypeLabel.text = [self.question getQuestionTypeString];
    
    [self setupFavViews:favorated];
    
    if ([self.question hasImage]) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.question.imgURL]];
    }
    
    [self buildOptionViews];
    [self makeConstraints];
}

- (void)setupFavViews:(BOOL)favorated {
    if (favorated) {
        [self.starView setBackgroundImage:[UIImage imageNamed:@"ic_question_alcollect"] forState:UIControlStateNormal];
        self.favoriteLabel.text = @"已收藏";
    } else {
        [self.starView setBackgroundImage:[UIImage imageNamed:@"ic_question_collect"] forState:UIControlStateNormal];
        self.favoriteLabel.text = @"收藏";
    }
}

- (void)buildOptionViews {
    for (HHOptionView *optionView in self.optionViews) {
        [optionView removeFromSuperview];
    }
    [self.optionViews removeAllObjects];
    
    [self initOptionViewWithTitle:@"A" text:self.question.item1];
    [self initOptionViewWithTitle:@"B" text:self.question.item2];
    
    if (![self.question.item3 isEqualToString:@""] && self.question.item3) {
        [self initOptionViewWithTitle:@"C" text:self.question.item3];
    }
    
    if (![self.question.item4 isEqualToString:@""] && self.question.item4) {
        [self initOptionViewWithTitle:@"D" text:self.question.item4];
    }
    
    int i = 0;
    for (HHOptionView *view in self.optionViews) {
        if (i == 0) {
            [view makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.scrollView.top).offset(20.0f);
                make.left.equalTo(self.scrollView.left).offset(40.0f);
                make.right.equalTo(self.scrollView.right).offset(-20.0f);
                make.height.equalTo(view.textLabel.height);
            }];
        } else {
            HHOptionView *prevView = self.optionViews[i-1];
            [view makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(prevView.bottom).offset(15.0f);
                make.left.equalTo(self.scrollView.left).offset(40.0f);
                make.right.equalTo(self.scrollView.right).offset(-20.0f);
                make.height.equalTo(view.textLabel.height);
            }];
        }
        i++;
    }
    
    if ([self.question.userAnswers count]) {
        if ([self.questionTypeLabel.text isEqualToString:@"多选题"]) {
            
        } else {
            [self updateOptionViewsForSingleAnswerQuestion:self.question.userAnswers];
        }
    }
}

- (void)initOptionViewWithTitle:(NSString *)title text:(NSString *)text {
    HHOptionView *view = [[HHOptionView alloc] initWithOptionTilte:title text:text];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(optionSelected:)];
    [view addGestureRecognizer:tapGes];
    [self.scrollView addSubview:view];
    [self.optionViews addObject:view];
    view.tag = [self.optionViews indexOfObject:view];

}

- (void)starTapped {
    if (self.favBlock) {
        self.favBlock(self.question);
    }
}

- (void)optionSelected:(UITapGestureRecognizer *)recognizer {
    if ([self.question.answered boolValue]) {
        return;
    }
    HHOptionView *view  = (HHOptionView *)recognizer.view;
    NSMutableArray *userAnswers = [NSMutableArray array];
    if ([[self.question getQuestionTypeString] isEqualToString:@"多选题"]) {
        
    } else {
        [userAnswers addObject:@(view.tag + 1)];
        [self updateOptionViewsForSingleAnswerQuestion:userAnswers];
        self.question.answered = @(1);
        self.question.userAnswers = userAnswers;
        
    }
    
}

- (void)updateOptionViewsForSingleAnswerQuestion:(NSMutableArray *)ansewers {
    HHOptionView *view = self.optionViews[[[ansewers firstObject] integerValue] - 1];
    if ([self.question isAnswerCorrect:ansewers]) {
        [view.titleButton setImage:[UIImage imageNamed:@"ic_right"] forState:UIControlStateNormal];
        view.titleButton.layer.borderWidth = 0;
    } else {
        [view.titleButton setImage:[UIImage imageNamed:@"ic_wrong"] forState:UIControlStateNormal];
        view.titleButton.layer.borderWidth = 0;
        HHOptionView *correctOption = self.optionViews[[self.question.answer integerValue] - 1];
        correctOption.titleButton.layer.borderWidth = 0;
        [correctOption.titleButton setImage:[UIImage imageNamed:@"ic_right"] forState:UIControlStateNormal];
    }
}


@end
