//
//  HHTestQuestionViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHTestQuestionViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"

@interface HHTestQuestionViewController ()

@property (nonatomic) TestMode currentMode;
@property (nonatomic, strong) NSMutableArray *questions;
@property (nonatomic) NSInteger startIndex;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *questionTitleView;
@property (nonatomic, strong) UIImageView *questionTypeView;
@property (nonatomic, strong) UILabel *questionTitleLabel;
@property (nonatomic, strong) UIImageView *starView;
@property (nonatomic, strong) UILabel *saveQuestionLabel;

@end

@implementation HHTestQuestionViewController

- (instancetype)initWithTestMode:(TestMode)testMode questions:(NSMutableArray *)questions startIndex:(NSInteger)startIndex {
    self = [super init];
    if (self) {
        self.currentMode = testMode;
        self.startIndex = startIndex;
        self.questions = self.questions;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.currentMode) {
        case TestModeOrder:{
            self.title = @"顺序练题";
        } break;
            
        case TestModeRandom: {
            self.title = @"随机练题";
        } break;
            
        case TestModeSimu: {
            self.title = @"模拟考试";
        } break;
            
        default:
            break;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    
    [self initSubviews];
}

- (void)initSubviews {
    self.questionTitleView = [[UIView alloc] init];
    self.questionTitleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.questionTitleView];
    
    self.questionTypeView = [[UIImageView alloc] init];
    
}

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
