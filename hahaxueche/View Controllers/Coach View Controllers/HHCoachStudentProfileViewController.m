//
//  HHCoachStudentProfileViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/7/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHCoachStudentProfileViewController.h"
#import "HHPaymentStatus.h"
#import "HHPaymentStatusView.h"
#import "UIColor+HHColor.h"
#import "HHAutoLayoutUtility.h"
#import "HHLoadingView.h"
#import "HHToastUtility.h"
#import "HHCoachStudentProfileCell.h"
#import "HHPaymentTransactionService.h"
#import "UIBarButtonItem+HHCustomButton.h"

#define kCellId @"cellId"

@interface HHCoachStudentProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *explanationLabel;
@property (nonatomic, strong) HHPaymentStatus *paymentStatus;

@end

@implementation HHCoachStudentProfileViewController

-(void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *backButton = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"left_arrow"] action:@selector(backButtonPressed) target:self];
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8.0f;//
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
}

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    [self.tableView registerClass:[HHCoachStudentProfileCell class] forCellReuseIdentifier:kCellId];
    [self.view addSubview:self.tableView];
    
    self.explanationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-20.0f, 60.0f)];
    self.explanationLabel.backgroundColor = [UIColor clearColor];
    self.explanationLabel.text = NSLocalizedString(@"注：学员支付的学费将由平台保管，每个阶段结束后，学员可以根据情况，点此阶段的付款按钮，点击后，平台将该阶段对应的金额转给教练，然后进入下一阶段。每个阶段到金额会在点击付款后的第一个周二转到教练账户。", nil);
    self.explanationLabel.textColor = [UIColor HHGrayTextColor];
    self.explanationLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12.0f];
    self.explanationLabel.numberOfLines = 0;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, CGRectGetWidth(self.view.bounds)-20.0f, 60.0f)];
    footerView.backgroundColor = [UIColor clearColor];
    [footerView addSubview:self.explanationLabel];
    
    self.tableView.tableFooterView = footerView;

    [self autolayoutSubview];
    
}

- (void)setStudent:(HHStudent *)student {
    _student = student;
    [self.tableView reloadData];
}

- (void)setTransactionArray:(NSArray *)transactionArray {
    _transactionArray = transactionArray;
    if ([self.transactionArray count]) {
        [[HHLoadingView sharedInstance] showLoadingViewWithTilte:nil];
        HHTransaction *transaction = [self.transactionArray firstObject];
        [[HHPaymentTransactionService sharedInstance] fetchPaymentStatusWithTransactionId:transaction.objectId completion:^(HHPaymentStatus *paymentStatus, NSError *error) {
            [[HHLoadingView sharedInstance] hideLoadingView];
            if (!error) {
                self.paymentStatus = paymentStatus;
                [self.tableView reloadData];
            }
        }];
    }  else {
        [[HHPaymentTransactionService sharedInstance] fetchTransactionWithStudentId:self.student.studentId completion:^(NSArray *objects, NSError *error) {
            if (!error) {
                self.transactionArray = objects;
                if ([self.transactionArray count]) {
                    HHTransaction *transaction = [self.transactionArray firstObject];
                    [[HHPaymentTransactionService sharedInstance] fetchPaymentStatusWithTransactionId:transaction.objectId completion:^(HHPaymentStatus *paymentStatus, NSError *error) {
                        [[HHLoadingView sharedInstance] hideLoadingView];
                        if (!error) {
                            self.paymentStatus = paymentStatus;
                            [self.tableView reloadData];
                        }
                    }];
                } else {
                    [[HHLoadingView sharedInstance] hideLoadingView];
                }
                
                
            } else {
                [[HHLoadingView sharedInstance] hideLoadingView];
                [HHToastUtility showToastWitiTitle:@"加载时出错！" isError:YES];
            }
        }];

    }

}

- (void)autolayoutSubview {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility setCenterX:self.tableView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterY:self.tableView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.tableView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.tableView multiplier:1.0f constant:0],
                             
                             ];
    [self.view addConstraints:constraints];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.transactionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHCoachStudentProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    cell.student = self.student;
    if ([self.transactionArray count]) {
         cell.transaction = self.transactionArray[indexPath.row];
    } 
    cell.paymentStatus = self.paymentStatus;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 380.0f;
}


#pragma -mark Hide TabBar
- (BOOL)hidesBottomBarWhenPushed {
    return (self.navigationController.topViewController == self);
}


@end
