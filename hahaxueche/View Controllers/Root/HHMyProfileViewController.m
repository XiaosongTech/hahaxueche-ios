//
//  HHMyProfileViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/15/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHMyProfileViewController.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import "HHTimeSlotSectionTitleView.h"
#import "UIView+HHRect.h"
#import "HHReceiptTableViewCell.h"
#import "HHCoachProfileViewController.h"
#import "HHUserAuthenticator.h"
#import "HHTransaction.h"
#import "HHPaymentTransactionService.h"
#import "HHLoadingView.h"
#import "HHToastUtility.h"
#import "HHPaymentStatus.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHLoginSignupViewController.h"
#import "HHProfileSetupViewController.h"
#import "HHTransfer.h"

#define kCellId @"HHReceiptTableViewCellId"

@interface HHMyProfileViewController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *explanationLabel;
@property (nonatomic, strong) NSArray *transactionArray;
@property (nonatomic, strong) HHPaymentStatus *paymentStatus;
@property (nonatomic, strong) UIBarButtonItem *settings;
@property (nonatomic, strong) UIActionSheet *settingsActionSheet;

@end

@implementation HHMyProfileViewController

-(void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.settingsActionSheet.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"我的页面", nil);
    [self initSubviews];
    
    
}

- (void)initSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    [self.tableView registerClass:[HHReceiptTableViewCell class] forCellReuseIdentifier:kCellId];
    [self.view addSubview:self.tableView];
    
    self.settings = [UIBarButtonItem buttonItemWithTitle:NSLocalizedString(@"设置", nil) action:@selector(settingsTapped) target:self isLeft:NO];
    self.navigationItem.rightBarButtonItem = self.settings;
    
    self.explanationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-20.0f, 60.0f)];
    self.explanationLabel.backgroundColor = [UIColor clearColor];
    self.explanationLabel.text = NSLocalizedString(@"注：学员支付的学费将由平台保管，每个阶段结束后，学员可以根据情况，点此阶段的付款按钮，点击后，平台将该阶段对应的金额转给教练，然后进入下一阶段。每个阶段到金额会在点击付款后的第一个周二转到教练账户", nil);
    self.explanationLabel.textColor = [UIColor HHGrayTextColor];
    self.explanationLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12.0f];
    self.explanationLabel.numberOfLines = 0;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, CGRectGetWidth(self.view.bounds)-20.0f, 60.0f)];
    footerView.backgroundColor = [UIColor clearColor];
    [footerView addSubview:self.explanationLabel];
    
    self.tableView.tableFooterView = footerView;
    __weak HHMyProfileViewController *weakSelf = self;
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:NSLocalizedString(@"加载中", nil)];
    [[HHPaymentTransactionService sharedInstance] fetchTransactionWithCompletion:^(NSArray *objects, NSError *error) {
        if (!error) {
            weakSelf.transactionArray = objects;
            if ([weakSelf.transactionArray count]) {
                HHTransaction *transaction = [weakSelf.transactionArray firstObject];
                [[HHPaymentTransactionService sharedInstance] fetchPaymentStatusWithTransactionId:transaction.objectId completion:^(HHPaymentStatus *paymentStatus, NSError *error) {
                    [[HHLoadingView sharedInstance] hideLoadingView];
                    if (!error) {
                        weakSelf.paymentStatus = paymentStatus;
                        [weakSelf.tableView reloadData];
                    }
                }];
            }
            
            
        } else {
            [[HHLoadingView sharedInstance] hideLoadingView];
            [HHToastUtility showToastWitiTitle:@"加载时出错！" isError:YES];
        }
    }];
    
    [self autolayoutSubview];
    
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

#pragma mark Tableview Delagate & Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HHTimeSlotSectionTitleView *view = [[HHTimeSlotSectionTitleView alloc] initWithTitle:NSLocalizedString(@"教练纪录", ni)];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.transactionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak HHMyProfileViewController *weakSelf = self;
    HHReceiptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    HHTransaction *transaction = self.transactionArray[indexPath.row];
    cell.transaction = transaction;
    cell.nameButtonActionBlock = ^(){
        HHCoachProfileViewController *coachProfileVC = [[HHCoachProfileViewController alloc] initWithCoach:[HHUserAuthenticator sharedInstance].myCoach];
        [weakSelf.navigationController pushViewController:coachProfileVC animated:YES];
    };
    cell.payBlock = ^(){
       
        HHTransfer *transfer = [HHTransfer objectWithClassName:[HHTransfer parseClassName]];
        transfer.coachId = [HHUserAuthenticator sharedInstance].myCoach.coachId;
        transfer.studentId = [HHUserAuthenticator sharedInstance].currentStudent.studentId;
        transfer.transactionId = transaction.objectId;
        transfer.stage = weakSelf.paymentStatus.currentStage;
        switch ([weakSelf.paymentStatus.currentStage integerValue]) {
            case 1:{
                transfer.amount = weakSelf.paymentStatus.stageOneAmount;
            } break;
            case 2:{
                transfer.amount = weakSelf.paymentStatus.stageTwoAmount;
            } break;
            case 3:{
                transfer.amount = weakSelf.paymentStatus.stageThreeAmount;
            } break;
            case 4:{
                transfer.amount = weakSelf.paymentStatus.stageFourAmount;
            } break;
            case 5:{
                transfer.amount = weakSelf.paymentStatus.stageFiveAmount;
            } break;
                
            default:{
                transfer.amount = weakSelf.paymentStatus.stageOneAmount;
            } break;
        }
        transfer.payeeAccount = [HHUserAuthenticator sharedInstance].myCoach.alipayAccount;
        transfer.payeeAccountType = NSLocalizedString(@"支付宝", nil);
        transfer.transferStatus = @"pending";
        [transfer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                weakSelf.paymentStatus.currentStage = @([weakSelf.paymentStatus.currentStage integerValue] + 1);
                [weakSelf.paymentStatus saveInBackground];
                [weakSelf.tableView reloadData];
                [HHToastUtility showToastWitiTitle:NSLocalizedString(@"付款成功！", nil) isError:NO];
            }
        }];
        
    };
    
    cell.paymentStatus = self.paymentStatus;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 380.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (void)settingsTapped {
    self.settingsActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"返回", nil)
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"更改个人信息", nil), NSLocalizedString(@"查看条款和协议", nil), NSLocalizedString(@"退出当前账号", nil), nil];
    [self.settingsActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet isEqual:self.settingsActionSheet]) {
        if (buttonIndex == 0) {
            HHProfileSetupViewController *setupVC = [[HHProfileSetupViewController alloc] init];
            UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:setupVC];
            [self presentViewController:navVC animated:YES completion:nil];
        } else if (buttonIndex == 1) {
            
        } else if (buttonIndex == 2) {
            [HHUser logOut];
            HHLoginSignupViewController *loginSignupVC = [[HHLoginSignupViewController alloc] init];
            [self presentViewController:loginSignupVC animated:YES completion:nil];
        }
    }
}




@end
