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
#import "HHClubPostTableViewCell.h"
#import "HHClubPostDetailViewController.h"

static NSString *const kCellID = @"kCellId";

@interface HHClubViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HHClubItemView *eventView;
@property (nonatomic, strong) HHClubItemView *testView;

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
    
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[HHClubPostTableViewCell class] forCellReuseIdentifier:kCellID];
    [self.view addSubview:self.tableView];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(10.0f);
        make.left.equalTo(self.view.left).offset(10.0f);
        make.width.equalTo(self.view.width).offset(-20.0f);
        make.height.mas_equalTo(80.0f);
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
    
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.testView.bottom).offset(10.0f);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(self.view.bottom).offset(-1 * CGRectGetHeight(self.tabBarController.tabBar.frame));

    }];
}

#pragma mark - UITableView Delegate & Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHClubPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    [cell setupCellWithClubPost:nil];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 333.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HHClubPostDetailViewController *vc = [[HHClubPostDetailViewController alloc] initWithClubPost:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}




@end
