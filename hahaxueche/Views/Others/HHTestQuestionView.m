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
#import <TTTAttributedLabel.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>


@interface HHTestQuestionView () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) HHQuestion *question;

@property (nonatomic, strong) UIView *questionTitleContainerView;
@property (nonatomic, strong) UILabel *questionTypeLabel;
@property (nonatomic, strong) UILabel *questionTitleLabel;
@property (nonatomic, strong) UIButton *starView;
@property (nonatomic, strong) UIImageView *imgView;;
@property (nonatomic, strong) UILabel *favoriteLabel;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *optionViews;
@property (nonatomic, strong) NSMutableArray *userAnswers;
@property (nonatomic, strong) UIImageView *seporatorView;
@property (nonatomic, strong) TTTAttributedLabel *explanationLabel;

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIView *videoContainerView;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@end

@implementation HHTestQuestionView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor HHBackgroundGary];
        self.optionViews = [NSMutableArray array];
        self.userAnswers = [NSMutableArray array];
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
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.questionTitleContainerView addSubview:self.imgView];
    
    self.videoContainerView = [[UIView alloc] init];
    self.videoContainerView.backgroundColor = [UIColor whiteColor];
    [self.questionTitleContainerView addSubview:self.videoContainerView];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = YES;
    [self addSubview:self.scrollView];
    
}

- (void)makeConstraints {
    
    [self.questionTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.questionTypeLabel.right).offset(10.0f);
        make.right.equalTo(self.questionTitleContainerView.right).offset(-50.0f);
        make.top.equalTo(self.questionTitleContainerView.top).offset(20.0f);
    }];
    
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
    
    if ([self.question.mediaType isEqualToString:@"1"]) {
        [self.imgView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.questionTitleContainerView.centerX);
            make.top.equalTo(self.questionTitleLabel.bottom).offset(20.0f);
            make.width.lessThanOrEqualTo(self.questionTitleContainerView.width);
            make.height.mas_lessThanOrEqualTo(100.0f);
        }];
        [self.questionTitleContainerView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.left.equalTo(self.left);
            make.bottom.equalTo(self.imgView.bottom).offset(20.0f);
            make.width.equalTo(self.width);
        }];
        self.imgView.hidden = NO;
    } else if ([self.question.mediaType isEqualToString:@"2"]) {
        [self.videoContainerView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.questionTitleContainerView.centerX);
            make.top.equalTo(self.questionTitleLabel.bottom).offset(20.0f);
            make.width.equalTo(self.questionTitleContainerView.width).offset(-60.0f);
            make.height.equalTo(self.videoContainerView.width).multipliedBy(9.0f/16.0f);
        }];
        [self.questionTitleContainerView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.left.equalTo(self.left);
            make.bottom.equalTo(self.videoContainerView.bottom).offset(20.0f);
            make.width.equalTo(self.width);
        }];
        self.imgView.hidden = YES;
    } else {
        [self.questionTitleContainerView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.left.equalTo(self.left);
            make.height.equalTo(self.questionTitleLabel.height).offset(50.0f);
            make.width.equalTo(self.width);
        }];
        
    }
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.top.equalTo(self.questionTitleContainerView.bottom);
        make.bottom.equalTo(self.bottom);
    }];
}

- (void)fillUpViewWithQuestion:(HHQuestion *)question favorated:(BOOL)favorated testMode:(TestMode)testMode {
    self.question = question;
    self.questionTitleLabel.text = self.question.questionDes;
    self.questionTypeLabel.text = [self.question getQuestionTypeString];
    [self.userAnswers removeAllObjects];
    
    [self setupFavViews:favorated testMode:testMode];
    
    if ([self.question.mediaType isEqualToString:@"1"]) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.question.mediaURL]];
    } else if ([self.question.mediaType isEqualToString:@"2"]) {
        if (self.playerLayer) {
            [self.playerLayer removeFromSuperlayer];
        }
        self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.question.mediaURL]];
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;

        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.frame = self.videoContainerView.bounds;
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[self.player currentItem]];
        
        [self.videoContainerView.layer addSublayer:self.playerLayer];
        [self.player play];
    } else {
        self.imgView.image = nil;
    }
    
    if ([self.question.mediaType isEqualToString:@"1"]) {
        [self.imgView remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.questionTitleContainerView.centerX);
            make.top.equalTo(self.questionTitleLabel.bottom).offset(20.0f);
            make.width.lessThanOrEqualTo(self.questionTitleContainerView.width);
        }];
        [self.questionTitleContainerView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.left.equalTo(self.left);
            make.bottom.equalTo(self.imgView.bottom).offset(20.0f);
            make.width.equalTo(self.width);
        }];
        
        self.imgView.hidden = NO;
    } else if ([self.question.mediaType isEqualToString:@"2"]) {
        [self.videoContainerView remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.questionTitleContainerView.centerX);
            make.top.equalTo(self.questionTitleLabel.bottom).offset(20.0f);
            make.width.equalTo(self.questionTitleContainerView.width).offset(-60.0f);
            make.height.equalTo(self.videoContainerView.width).multipliedBy(9.0f/16.0f);
        }];
        [self.questionTitleContainerView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.left.equalTo(self.left);
            make.bottom.equalTo(self.videoContainerView.bottom).offset(20.0f);
            make.width.equalTo(self.width);
        }];
        self.imgView.hidden = YES;
    } else {
        [self.questionTitleContainerView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.left.equalTo(self.left);
            make.height.equalTo(self.questionTitleLabel.height).offset(50.0f);
            make.width.equalTo(self.width);
        }];
        self.imgView.hidden = YES;
    }
    
    [self layoutIfNeeded];
    
    [self buildOptionViews];
    [self buildExplanationView];
    [self makeConstraints];
}

- (void)buildExplanationView {
    if (self.explanationLabel) {
        self.seporatorView.hidden = ![self.question.answered boolValue];
        self.explanationLabel.hidden = ![self.question.answered boolValue];
        self.explanationLabel.text = self.question.explains;

    } else {
        self.seporatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_question_msg"]];
        [self.scrollView addSubview:self.seporatorView];
        
        self.explanationLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        self.explanationLabel.textColor = [UIColor HHLightTextGray];
        self.explanationLabel.font = [UIFont systemFontOfSize:18.0f];
        self.explanationLabel.numberOfLines = 0;
        self.explanationLabel.delegate = self;
        self.explanationLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        self.explanationLabel.text = self.question.explains;
        [self.scrollView addSubview:self.explanationLabel];
    }
    
    HHOptionView *lastOptionView = [self.optionViews lastObject];
    [self.seporatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.top.equalTo(lastOptionView.bottom).offset(40.0f);
    }];
    
    
    [self.explanationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(20.0f);
        make.width.equalTo(self.scrollView.width).offset(-40.0f);
        make.top.equalTo(self.seporatorView.bottom).offset(30.0f);
    }];
    
    self.seporatorView.hidden = ![self.question.answered boolValue];
    self.explanationLabel.hidden = ![self.question.answered boolValue];
    
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.explanationLabel
                                                           attribute:NSLayoutAttributeBottom
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.scrollView
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.0
                                                            constant:-20.0f]];
    

    
}

- (void)setupFavViews:(BOOL)favorated testMode:(TestMode)testMode {
    if (testMode == TestModeFavQuestions) {
        [self.starView setBackgroundImage:[UIImage imageNamed:@"ic_question_delete"] forState:UIControlStateNormal];
        self.favoriteLabel.text = @"移除";
        return;
    }
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
    
    int i = 0;
    NSString *titleText;
    for (NSString *option in self.question.options) {
        switch (i) {
            case 0: {
                titleText = @"A";
            } break;
            case 1: {
                titleText = @"B";
            } break;
            case 2: {
                titleText = @"C";
            } break;
            case 3: {
                titleText = @"D";
            } break;
                
            default:
                break;
        }
        HHOptionView *view = [self buildOptionViewWithTitle:titleText text:option];
        if (i == 0) {
            [view makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.scrollView.top).offset(20.0f);
                make.left.equalTo(self.scrollView.left).offset(40.0f);
                make.width.equalTo(self.scrollView.width).offset(-60.0f);
                make.height.equalTo(view.textLabel.height);
            }];
        } else {
            HHOptionView *prevView = self.optionViews[i-1];
            [view makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(prevView.bottom).offset(15.0f);
                make.left.equalTo(self.scrollView.left).offset(40.0f);
                make.width.equalTo(self.scrollView.width).offset(-60.0f);
                make.height.equalTo(view.textLabel.height);
            }];
        }
        i++;
    }
    
    HHOptionView *lastView = [self.optionViews lastObject];
    if ([self.questionTypeLabel.text isEqualToString:@"多选题"]) {
        [self.confirmButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.bottom);
            make.centerX.equalTo(self.scrollView.centerX);
            make.width.equalTo(self.scrollView.width).offset(-60.0f);
            make.height.mas_equalTo(60.0f);
        }];
    }
    
    if ([[self.question getQuestionTypeString] isEqualToString:@"多选题"]) {
        [self.confirmButton removeFromSuperview];
        self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.confirmButton.backgroundColor = [UIColor HHOrange];
        self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
        self.confirmButton.layer.masksToBounds = YES;
        self.confirmButton.layer.cornerRadius = 5.0f;
        [self.confirmButton addTarget:self action:@selector(confirmSelection) forControlEvents:UIControlEventTouchUpInside];
        [self.confirmButton setTitle:@"提交答案" forState:UIControlStateNormal];
        [self.scrollView addSubview:self.confirmButton];
        [self.confirmButton remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.bottom).offset(30.0f);
            make.centerX.equalTo(self.scrollView.centerX);
            make.width.equalTo(self.scrollView.width).offset(-60.0f);
            make.height.mas_equalTo(60.0f);
        }];
        if ([self.question.answered boolValue]) {
            [self updateOptionViewsForMultiAnswerQuestion];
        }
    }
    
    if ([self.question.userAnswers count]) {
        if ([self.questionTypeLabel.text isEqualToString:@"多选题"]) {
            
        } else {
            [self updateOptionViewsForSingleAnswerQuestion:self.question.userAnswers];
        }
    }
}

- (HHOptionView *)buildOptionViewWithTitle:(NSString *)title text:(NSString *)text {
    HHOptionView *view = [[HHOptionView alloc] initWithOptionTilte:title text:text];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(optionSelected:)];
    tapGes.cancelsTouchesInView = NO;
    [view addGestureRecognizer:tapGes];
    [self.scrollView addSubview:view];
    [self.optionViews addObject:view];
    view.tag = [self.optionViews indexOfObject:view];
    return view;
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
    if ([[self.question getQuestionTypeString] isEqualToString:@"多选题"]) {
        if ([self.userAnswers containsObject:[@(view.tag + 1) stringValue]]) {
            [self.userAnswers removeObject:[@(view.tag + 1) stringValue]];
            [view.titleButton setTitleColor:[UIColor HHLightestTextGray] forState:UIControlStateNormal];
            view.titleButton.layer.borderColor = [UIColor HHLightestTextGray].CGColor;
            view.titleButton.backgroundColor = [UIColor whiteColor];
        } else {
            [self.userAnswers addObject:[@(view.tag + 1) stringValue]];
            [view.titleButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
            view.titleButton.layer.borderColor = [UIColor HHOrange].CGColor;
            view.titleButton.backgroundColor = [UIColor HHLightOrange];
        }
        
    } else {
        [self.userAnswers removeAllObjects];
        [self.userAnswers addObject:[@(view.tag + 1) stringValue]];
        self.question.userAnswers = self.userAnswers;
        [self updateOptionViewsForSingleAnswerQuestion:self.userAnswers];
        [self buildExplanationView];
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
        NSString *indexString = [self.question.correctAnswers firstObject];
        HHOptionView *correctOption = self.optionViews[[indexString integerValue]-1];
        correctOption.titleButton.layer.borderWidth = 0;
        [correctOption.titleButton setImage:[UIImage imageNamed:@"ic_right"] forState:UIControlStateNormal];
    }
    if (self.answeredBlock) {
        self.answeredBlock(self.question);
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if (self.explaBlock) {
        self.explaBlock(url);
    }
}

- (void)confirmSelection {
    self.question.userAnswers = self.userAnswers;
    [self updateOptionViewsForMultiAnswerQuestion];
    [self buildExplanationView];
}

- (void)updateOptionViewsForMultiAnswerQuestion {
    for (HHOptionView *view in self.optionViews) {
        if ([self.question.correctAnswers containsObject:[@(view.tag + 1) stringValue]]) {
            [view.titleButton setImage:[UIImage imageNamed:@"ic_right"] forState:UIControlStateNormal];
        } else {
            [view.titleButton setImage:[UIImage imageNamed:@"ic_wrong"] forState:UIControlStateNormal];
        }
        view.titleButton.layer.borderWidth = 0;
    }
    self.question.userAnswers = self.userAnswers;
    self.confirmButton.hidden = YES;
    
    if (self.answeredBlock) {
        self.answeredBlock(self.question);
    }
    
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *item = [notification object];
    [item seekToTime:kCMTimeZero];
}


@end
