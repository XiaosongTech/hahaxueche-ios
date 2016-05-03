//
//  HHBonusInfoViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHBonusInfoViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "NSNumber+HHNumber.h"
#import "HHButton.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHWithdrawViewController.h"
#import "HHReferFriendsCell.h"
#import "HHWithdrawHistoryViewController.h"
#import "HHStudentService.h"
#import "HHLoadingViewUtility.h"
#import "HHToastManager.h"
#import "HHStudentService.h"
#import "HHReferrals.h"
#import <MJRefresh/MJRefresh.h>
#import "HHBonusAmountView.h"
#import "HHReferFriendsViewController.h"

typedef void (^HHReferralsUpdateCompletion)();

static NSString *const kCellId = @"cellID";

@interface HHBonusInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HHBonusAmountView *pendingAmountView;
@property (nonatomic, strong) HHBonusAmountView *availableAmountView;
@property (nonatomic, strong) HHBonusAmountView *cashedAmountView;

@property (nonatomic, strong) UIButton *withdrawButton;

@property (nonatomic, strong) NSNumber *pendingAmount;
@property (nonatomic, strong) NSNumber *availableAmount;
@property (nonatomic, strong) NSNumber *redeemedAmount;

@property (nonatomic, strong) HHReferrals *referralsObject;
@property (nonatomic, strong) NSMutableArray *referrals;

@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *loadMoreFooter;

@property (nonatomic, strong) UIImageView *noDataImageView;
@property (nonatomic, strong) UILabel *noDataLabel;
@property (nonatomic, strong) UIView *noDataView;


@end

@implementation HHBonusInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"以赚取";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    self.referrals = [NSMutableArray array];
    
    [[HHStudentService sharedInstance] fetchBonusSummaryWithCompletion:^(HHBonusSummary *bonusSummary, NSError *error) {
        if (!error) {
            self.availableAmount = bonusSummary.availableAmount;
            self.pendingAmount = bonusSummary.pendingAmount;
            self.redeemedAmount = bonusSummary.redeemedAmount;
            
            [self initTopViewsWithBobusSummary:bonusSummary];
        } else {
            [[HHToastManager sharedManager] showErrorToastWithText:@"出错了, 请重试!"];
        }
    }];
    
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [self refreshReferralsWithCompletion:^{
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
    }];
    
    [self initSubviews];
}

- (void)refreshReferralsWithCompletion:(HHReferralsUpdateCompletion)completion {
    [[HHStudentService sharedInstance] fetchReferralsWithCompletion:^(HHReferrals *referralsObject, NSError *error) {
        if (completion) {
            completion();
        }
        if (!error) {
            self.referralsObject = referralsObject;
            self.referrals = [NSMutableArray arrayWithArray:self.referralsObject.referrals];
            if ([self.referrals count] > 0) {
                self.tableView.hidden = NO;
                self.noDataView.hidden = YES;
                [self.tableView reloadData];
            } else {
                self.tableView.hidden = YES;
                self.noDataView.hidden = NO;
            }
            
        } else {
            [[HHToastManager sharedManager] showErrorToastWithText:@"出错了, 请重试!"];
        }
    }];
}

- (void)loadMoreReferralsWithCompletion:(HHReferralsUpdateCompletion)completion {
    [[HHStudentService sharedInstance] fetchMoreReferralsWithURL:self.referralsObject.nextPage completion:^(HHReferrals *referralsObject, NSError *error) {
        if (completion) {
            completion();
        }
        if (!error) {
            self.referralsObject = referralsObject;
            [self.referrals addObjectsFromArray:self.referralsObject.referrals];
            [self.tableView reloadData];
        } else {
            [[HHToastManager sharedManager] showErrorToastWithText:@"出错了, 请重试!"];
        }
    }];
}

- (void)initTopViewsWithBobusSummary:(HHBonusSummary *)bonusSummary {
    self.pendingAmountView = [[HHBonusAmountView alloc] initWithNumber:bonusSummary.pendingAmount title:@"即将到账" boldNumber:NO showArror:NO];
    [self.topView addSubview:self.pendingAmountView];
    
    self.availableAmountView = [[HHBonusAmountView alloc] initWithNumber:bonusSummary.availableAmount title:@"可提现" boldNumber:YES showArror:NO];
    [self.topView addSubview:self.availableAmountView];
    
    self.cashedAmountView = [[HHBonusAmountView alloc] initWithNumber:bonusSummary.redeemedAmount title:@"已提现" boldNumber:NO showArror:YES];
    self.cashedAmountView.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToWithdrawHistoryVC)];
    [self.cashedAmountView addGestureRecognizer:recognizer];
    [self.topView addSubview:self.cashedAmountView];
    
    [self.pendingAmountView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.top).offset(20.0f);
        make.centerX.equalTo(self.topView.centerX).multipliedBy(0.5f).offset(-30.0f);
        make.width.mas_equalTo(80.0f);
        make.height.mas_equalTo(45.0f);
    }];
    
    [self.availableAmountView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.top).offset(15.0f);
        make.centerX.equalTo(self.topView.centerX);
        make.width.mas_equalTo(100.0f);
        make.height.mas_equalTo(60.0f);
    }];
    
    [self.cashedAmountView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.top).offset(20.0f);
        make.centerX.equalTo(self.topView.centerX).multipliedBy(1.5f).offset(30.0f);
        make.width.mas_equalTo(80.0f);
        make.height.mas_equalTo(45.0f);
    }];
}


- (void)initSubviews {
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor HHOrange];
    [self.view addSubview:self.topView];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[HHReferFriendsCell class] forCellReuseIdentifier:kCellId];


    self.withdrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.withdrawButton.layer.masksToBounds = YES;
    self.withdrawButton.layer.cornerRadius = 5.0f;
    self.withdrawButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.withdrawButton setTitle:@"我要提现" forState:UIControlStateNormal];
    self.withdrawButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.withdrawButton.layer.borderWidth = 2.0f/[UIScreen mainScreen].scale;
    [self.withdrawButton addTarget:self action:@selector(cashBonus) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.withdrawButton];
    
    self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.refreshHeader.stateLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.refreshHeader setTitle:@"正在刷新列表" forState:MJRefreshStateRefreshing];
    self.refreshHeader.stateLabel.textColor = [UIColor HHLightTextGray];
    self.refreshHeader.automaticallyChangeAlpha = YES;
    self.refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = self.refreshHeader;
    
    self.loadMoreFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.loadMoreFooter setTitle:@"加载更多" forState:MJRefreshStateIdle];
    [self.loadMoreFooter setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [self.loadMoreFooter setTitle:@"没有更多" forState:MJRefreshStateNoMoreData];
    self.loadMoreFooter.automaticallyRefresh = NO;
    self.loadMoreFooter.stateLabel.font = [UIFont systemFontOfSize:14.0f];
    self.loadMoreFooter.stateLabel.textColor = [UIColor HHLightTextGray];
    self.tableView.mj_footer = self.loadMoreFooter;
    
    self.noDataView = [[UIView alloc] init];
    self.noDataView.backgroundColor = [UIColor whiteColor];
    self.noDataView.hidden = YES;
    self.noDataView.userInteractionEnabled = YES;
    [self.view addSubview:self.noDataView];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToInviteVC)];
    [self.noDataView addGestureRecognizer:recognizer];
    
    self.noDataImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_cash_havenot"]];
    [self.noDataView addSubview:self.noDataImageView];
    
    self.noDataLabel = [[UILabel alloc] init];
    self.noDataLabel.text = @"您还没有报名学车的小伙伴\n可以继续推荐其他好友来报名";
    self.noDataLabel.textAlignment = NSTextAlignmentCenter;
    self.noDataLabel.numberOfLines = 0;
    self.noDataLabel.textColor = [UIColor HHLightTextGray];
    self.noDataLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.noDataView addSubview:self.noDataLabel];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(150.0f);
    }];
    
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.bottom);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    [self.noDataView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.bottom);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    [self.noDataImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.noDataView.centerX);
        make.centerY.equalTo(self.noDataView.centerY).offset(-70.0f);

    }];
    
    [self.noDataLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.noDataView.centerX);
        make.centerY.equalTo(self.noDataView.centerY).offset(40.0f);
        
    }];
    
    [self.withdrawButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topView.bottom).offset(-15.0f);
        make.centerX.equalTo(self.topView.centerX);
        make.width.mas_equalTo(200.0);
        make.height.mas_equalTo(35.0f);
    }];
    
}

#pragma mark - TableView Delegate & Datasource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHReferFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    HHReferral *referral = self.referrals[indexPath.row];
    [cell setupCellWithReferral:referral];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.referrals.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f;
}



- (void)cashBonus {
    __weak HHBonusInfoViewController *weakSelf = self;
    HHWithdrawViewController *vc = [[HHWithdrawViewController alloc] initWithAvailableAmount:self.availableAmount];
    vc.updateAmountsBlock = ^(NSNumber *redeemedAmount) {
        weakSelf.availableAmount = @([weakSelf.availableAmount floatValue] - [redeemedAmount floatValue]);
        weakSelf.redeemedAmount = @([weakSelf.redeemedAmount floatValue] + [redeemedAmount floatValue]);
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)jumpToWithdrawHistoryVC {
    HHWithdrawHistoryViewController *vc = [[HHWithdrawHistoryViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshData {
    __weak HHBonusInfoViewController *weakSelf = self;
    [self refreshReferralsWithCompletion:^{
        [weakSelf.refreshHeader endRefreshing];
    }];
}

- (void)loadMoreData {
    __weak HHBonusInfoViewController *weakSelf = self;
    [self loadMoreReferralsWithCompletion:^{
        [weakSelf.loadMoreFooter endRefreshing];
    }];
}

- (void)setReferralsObject:(HHReferrals *)referralsObject {
    _referralsObject = referralsObject;
    if (!self.referralsObject.nextPage) {
        [self.loadMoreFooter setState:MJRefreshStateNoMoreData];
    } else {
        [self.loadMoreFooter setState:MJRefreshStateIdle];
    }
}

- (void)setAvailableAmount:(NSNumber *)availableAmount {
    _availableAmount = availableAmount;
    self.availableAmountView.valueLabel.text = [availableAmount generateMoneyString];
}

- (void)setRedeemedAmount:(NSNumber *)redeemedAmount {
    _redeemedAmount = redeemedAmount;
    self.cashedAmountView.titleLabel.text = [redeemedAmount generateMoneyString];
}

- (void)jumpToInviteVC {
    HHReferFriendsViewController *vc = [[HHReferFriendsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
