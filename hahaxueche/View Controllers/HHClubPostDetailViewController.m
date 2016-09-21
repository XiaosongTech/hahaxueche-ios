//
//  HHClubPostDetailViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHClubPostDetailViewController.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "HHClubPostStatView.h"

@interface HHClubPostDetailViewController ()

@property (nonatomic, strong) HHClubPost *clubPost;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *botToolBar;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) HHClubPostStatView *statView;

@end

@implementation HHClubPostDetailViewController

- (instancetype)initWithClubPost:(HHClubPost *)clubPost {
    self = [super init];
    if (self) {
        self.clubPost = clubPost;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"icon_share"] action:@selector(sharePost) target:self];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initSubviews];
    
}

- (void)initSubviews {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    [self buildBotToolBarView];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height).offset(-50.0f);
        make.left.equalTo(self.view.left);
    }];
    
    [self.botToolBar makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(50.0f);
        make.left.equalTo(self.view.left);
    }];
    
    [self.commentButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botToolBar.centerY);
        make.width.equalTo(self.botToolBar.width).multipliedBy(1.0f/2.0f);
        make.height.mas_equalTo(30.0f);
        make.left.equalTo(self.botToolBar.left).offset(15.0f);

    }];
    
    [self.statView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botToolBar.centerY);
        make.right.equalTo(self.botToolBar.right);
        make.height.equalTo(self.botToolBar.height);
        make.left.equalTo(self.commentButton.right);
        
    }];
}


- (void)buildBotToolBarView {
    self.botToolBar = [[UIView alloc] init];
    self.botToolBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.botToolBar];
    
    self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    self.commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.commentButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);;
    [self.commentButton setTitle:@"发表伟大言论..." forState:UIControlStateNormal];
    [self.commentButton setTitleColor:[UIColor HHLightestTextGray] forState:UIControlStateNormal];
    self.commentButton.backgroundColor = [UIColor HHLightBackgroudGray];
    self.commentButton.layer.masksToBounds = YES;
    self.commentButton.layer.cornerRadius = 15.0f;
    [self.commentButton addTarget:self action:@selector(showCommentTextView) forControlEvents:UIControlEventTouchUpInside];
    [self.botToolBar addSubview:self.commentButton];
    
    self.statView = [[HHClubPostStatView alloc] initWithInteraction:YES];
    [self.statView setupViewWithClubPost:self.clubPost];
    [self.botToolBar addSubview:self.statView];

}

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sharePost {
    
}

- (void)showCommentTextView {
    
}


@end
