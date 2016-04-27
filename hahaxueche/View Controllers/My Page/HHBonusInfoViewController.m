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

static NSString *const kCellId = @"cellID";

@interface HHBonusInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *pendingAmountView;
@property (nonatomic, strong) UIView *availableAmountView;
@property (nonatomic, strong) UIView *cashedAmountView;

@property (nonatomic, strong) UIButton *withdrawButton;

@end

@implementation HHBonusInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"以赚取";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    [self initSubviews];
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
    
    self.pendingAmountView = [self buildMoneyViewWithNumber:@(50000) title:@"即将到账" boldNumber:NO showArror:NO];
    [self.topView addSubview:self.pendingAmountView];
    
    self.availableAmountView = [self buildMoneyViewWithNumber:@(80000) title:@"可提现" boldNumber:YES showArror:NO];
    [self.topView addSubview:self.availableAmountView];
    
    self.cashedAmountView = [self buildMoneyViewWithNumber:@(60000) title:@"已提现" boldNumber:NO showArror:YES];
    self.cashedAmountView.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToWithdrawHistoryVC)];
    [self.cashedAmountView addGestureRecognizer:recognizer];
    [self.topView addSubview:self.cashedAmountView];


    self.withdrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.withdrawButton.layer.masksToBounds = YES;
    self.withdrawButton.layer.cornerRadius = 5.0f;
    self.withdrawButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.withdrawButton setTitle:@"我要提现" forState:UIControlStateNormal];
    self.withdrawButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.withdrawButton.layer.borderWidth = 2.0f/[UIScreen mainScreen].scale;
    [self.withdrawButton addTarget:self action:@selector(cashBonus) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.withdrawButton];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(150.0f);
    }];
    
    
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
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.bottom);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    [self.withdrawButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topView.bottom).offset(-15.0f);
        make.centerX.equalTo(self.topView.centerX);
        make.width.mas_equalTo(200.0);
        make.height.mas_equalTo(35.0f);
    }];
    
}

- (UIView *)buildMoneyViewWithNumber:(NSNumber *)number title:(NSString *)title boldNumber:(BOOL)boldNumber showArror:(BOOL)showArror {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor HHOrange];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    if (boldNumber) {
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
    } else {
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    
    [view addSubview:titleLabel];
    
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.top);
        make.centerX.equalTo(view.centerX);
    }];
    
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.textColor = [UIColor whiteColor];
    
    if (showArror) {
        valueLabel.text = [NSString stringWithFormat:@"%@ >", [number generateMoneyString]];
    } else {
        valueLabel.text = [number generateMoneyString];
    }
    
    if (boldNumber) {
        valueLabel.font = [UIFont boldSystemFontOfSize:30.0f];
    } else {
        valueLabel.font = [UIFont systemFontOfSize:20.0f];
    }
    
    [view addSubview:valueLabel];
    
    [valueLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.bottom);
        make.centerX.equalTo(view.centerX);
    }];
    
    return view;
    
}

#pragma mark - TableView Delegate & Datasource Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHReferFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    [cell setupCellWithReferral:nil];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f;
}



- (void)cashBonus {
    HHWithdrawViewController *vc = [[HHWithdrawViewController alloc] init];
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

@end
