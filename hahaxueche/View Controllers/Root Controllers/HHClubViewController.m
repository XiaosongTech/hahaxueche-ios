//
//  HHClubViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/20/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHClubViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHClubItemView.h"
#import "HHEventsViewController.h"
#import "HHTestStartViewController.h"

@interface HHClubViewController ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HHClubItemView *eventView;
@property (nonatomic, strong) HHClubItemView *testView;
@property (nonatomic, strong) HHClubItemView *carTrialView;
@property (nonatomic, strong) HHClubItemView *trainingskillView;

@end

@implementation HHClubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小哈俱乐部";
    self.view.backgroundColor = [UIColor HHBackgroundGary];

    [self initSubviews];
}

- (void)initSubviews {
    __weak HHClubViewController *weakSelf = self;
    
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor whiteColor];
    self.topView.layer.masksToBounds = YES;
    self.topView.layer.cornerRadius = 10.0f;
    [self.view addSubview:self.topView];
    
    self.eventView = [[HHClubItemView alloc] initWithIcon:[UIImage imageNamed:@"clock"] title:@"限时团购" subTitle:@"学车团购底价" showRightLine:YES showBotLine:YES];
    self.eventView.actionBlock = ^() {
        HHEventsViewController *vc = [[HHEventsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [self.topView addSubview:self.eventView];
    
    self.testView = [[HHClubItemView alloc] initWithIcon:[UIImage imageNamed:@"exercise"] title:@"在线题库" subTitle:@"题库想练就练" showRightLine:NO showBotLine:YES];
    self.testView.actionBlock = ^() {
        HHTestStartViewController *vc = [[HHTestStartViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [self.topView addSubview:self.testView];
    
    self.carTrialView = [[HHClubItemView alloc] initWithIcon:[UIImage imageNamed:@"car"] title:@"豪车试驾" subTitle:@"豪车免费试驾" showRightLine:YES showBotLine:NO];
    self.carTrialView.actionBlock = ^() {
        
    };
    [self.topView addSubview:self.carTrialView];
    
    self.trainingskillView = [[HHClubItemView alloc] initWithIcon:[UIImage imageNamed:@"skills"] title:@"学车技巧" subTitle:@"学车秘籍揭秘" showRightLine:NO showBotLine:NO];
    self.trainingskillView.actionBlock = ^() {
        
    };
    [self.topView addSubview:self.trainingskillView];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(10.0f);
        make.left.equalTo(self.view.left).offset(10.0f);
        make.width.equalTo(self.view.width).offset(-20.0f);
        make.height.mas_equalTo(160.0f);
    }];
    
    [self.eventView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.top);
        make.left.equalTo(self.topView.left);
        make.width.equalTo(self.topView.width).multipliedBy(0.5f);
        make.height.mas_equalTo(80.0f);
    }];
    
    [self.testView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.top);
        make.left.equalTo(self.eventView.right);
        make.width.equalTo(self.topView.width).multipliedBy(0.5f);
        make.height.mas_equalTo(80.0f);
    }];
    
    [self.carTrialView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.eventView.bottom);
        make.left.equalTo(self.topView.left);
        make.width.equalTo(self.topView.width).multipliedBy(0.5f);
        make.height.mas_equalTo(80.0f);
    }];
    
    [self.trainingskillView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.testView.bottom);
        make.left.equalTo(self.carTrialView.right);
        make.width.equalTo(self.topView.width).multipliedBy(0.5f);
        make.height.mas_equalTo(80.0f);
    }];
}



@end
