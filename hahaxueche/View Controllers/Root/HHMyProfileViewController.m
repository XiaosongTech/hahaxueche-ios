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
#import <SDWebImage/UIImageView+WebCache.h>
#import "QRCodeReaderViewController.h"
#import "HHCoachService.h"
#import "Appirater.h"

#define kCellId @"HHReceiptTableViewCellId"

static NSString *const TOUURL = @"http://www.hahaxueche.net/index/mz/";

@interface HHMyProfileViewController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIAlertViewDelegate, QRCodeReaderDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *explanationLabel;
@property (nonatomic, strong) NSArray *transactionArray;
@property (nonatomic, strong) HHPaymentStatus *paymentStatus;
@property (nonatomic, strong) UIBarButtonItem *settings;
@property (nonatomic, strong) UIActionSheet *settingsActionSheet;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) UIView *noTransactionView;
@property (nonatomic, strong) UIImageView *qrCodeImageView;
@property (nonatomic, strong) UILabel *scanCodeLabel;
@property (nonatomic, strong) HHAvatarView *coachImageView;
@property (nonatomic, strong) UIButton *coachNameButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic)         BOOL isFetching;

@end

@implementation HHMyProfileViewController

-(void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.settingsActionSheet.delegate = nil;
    self.alertView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"我的页面", nil);
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.paymentStatus) {
        [self fetchData];
    }
}

- (void)fetchData {
    if (self.isFetching) {
        return;
    }
    self.isFetching = YES;
    __weak HHMyProfileViewController *weakSelf = self;
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:NSLocalizedString(@"加载中", nil)];
    [[HHPaymentTransactionService sharedInstance] fetchTransactionWithStudentId:[HHUserAuthenticator sharedInstance].currentStudent.studentId completion:^(NSArray *objects, NSError *error) {
        if (!error) {
            weakSelf.transactionArray = objects;
            if ([weakSelf.transactionArray count]) {
                HHTransaction *transaction = [weakSelf.transactionArray firstObject];
                [[HHPaymentTransactionService sharedInstance] fetchPaymentStatusWithTransactionId:transaction.objectId completion:^(HHPaymentStatus *paymentStatus, NSError *error) {
                    self.isFetching = NO;
                    if (!error) {
                        weakSelf.paymentStatus = paymentStatus;
                        [weakSelf.tableView reloadData];
                    }
                    [weakSelf showHideSubviews];
                }];
            } else {
                weakSelf.isFetching = NO;
                [weakSelf showHideSubviews];
            }
            
            
        } else {
            weakSelf.isFetching = NO;
            [HHToastUtility showToastWitiTitle:@"加载时出错！" isError:YES];
            [weakSelf showHideSubviews];
        }
        [[HHLoadingView sharedInstance] hideLoadingView];

    }];

}

- (void)showHideSubviews {
    if (self.paymentStatus) {
        self.tableView.hidden = NO;
        self.noTransactionView.hidden = YES;
    } else {
        self.tableView.hidden = YES;
        self.noTransactionView.hidden = NO;
        if ([HHUserAuthenticator sharedInstance].myCoach) {
            self.qrCodeImageView.hidden = YES;
            self.titleLabel.hidden = YES;
            self.scanCodeLabel.hidden = YES;
            self.coachNameButton.hidden = NO;
            self.coachImageView.hidden = NO;
        } else {
            self.qrCodeImageView.hidden = NO;
            self.scanCodeLabel.hidden = NO;
            self.titleLabel.hidden = NO;
            self.coachNameButton.hidden = YES;
            self.coachImageView.hidden = YES;
        }
    }

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
    
    self.explanationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-20.0f, 70.0f)];
    self.explanationLabel.backgroundColor = [UIColor clearColor];
    self.explanationLabel.text = NSLocalizedString(@"注：学员支付的学费将由平台保管，每个阶段结束后，学员可以根据情况，点此阶段的付款按钮，点击后，平台将该阶段对应的金额转给教练，然后进入下一阶段。每个阶段的金额会在点击付款后的第一个周二转到教练账户。", nil);
    self.explanationLabel.textColor = [UIColor HHGrayTextColor];
    self.explanationLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12.0f];
    self.explanationLabel.numberOfLines = 0;
    [self.explanationLabel sizeToFit];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, CGRectGetWidth(self.view.bounds)-20.0f, CGRectGetHeight(self.explanationLabel.bounds))];
    footerView.backgroundColor = [UIColor clearColor];
    [footerView addSubview:self.explanationLabel];
    
    self.tableView.tableFooterView = footerView;
    self.tableView.hidden = YES;
    
    self.noTransactionView = [[UIView alloc] initWithFrame:CGRectZero];
    self.noTransactionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.view.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    [self.view addSubview:self.noTransactionView];
    self.noTransactionView.hidden = YES;
    
    self.qrCodeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_qrcode_orange_btn@1x"]];
    self.qrCodeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.qrCodeImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showScanView)];
    [self.qrCodeImageView addGestureRecognizer:tapRecognizer];
    [self.noTransactionView addSubview:self.qrCodeImageView];
    
    self.scanCodeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.scanCodeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.scanCodeLabel.numberOfLines = 0;
    self.scanCodeLabel.text = NSLocalizedString(@"如果你已经是我们教练的学员，可以点击下面方块，扫描该教练二维码(教练处获取)，之后便可以使用哈哈学车的预约练车系统了。", nil);
    self.scanCodeLabel.textColor = [UIColor HHOrange];
    self.scanCodeLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15.0f];
    [self.scanCodeLabel sizeToFit];
    [self.noTransactionView addSubview:self.scanCodeLabel];
    
    self.coachImageView = [[HHAvatarView alloc] initWithImageURL:nil radius:50.0f borderColor:[UIColor whiteColor]];
    self.coachImageView.translatesAutoresizingMaskIntoConstraints = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToCoachView)];
    [self.coachImageView addGestureRecognizer:tap];
    [self.coachImageView.imageView sd_setImageWithURL:[NSURL URLWithString:[HHUserAuthenticator sharedInstance].myCoach.avatarURL]];
    [self.noTransactionView addSubview:self.coachImageView];
    
    self.coachNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.coachNameButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.coachNameButton setTitleColor:[UIColor HHClickableBlue] forState:UIControlStateNormal];
    [self.coachNameButton setTitle:[HHUserAuthenticator sharedInstance].myCoach.fullName forState:UIControlStateNormal];
    self.coachNameButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:18.0f];
    [self.coachNameButton addTarget:self action:@selector(jumpToCoachView) forControlEvents:UIControlEventTouchUpInside];
    [self.coachNameButton sizeToFit];
    [self.noTransactionView addSubview:self.coachNameButton];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.text = NSLocalizedString(@"扫一扫", nil);
    self.titleLabel.textColor = [UIColor HHOrange];
    self.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:25.0f];
    [self.titleLabel sizeToFit];
    [self.noTransactionView addSubview:self.titleLabel];
    
    [self fetchData];
    [self autolayoutSubview];
    
}

- (void)jumpToCoachView {
    HHCoachProfileViewController *coachVC = [[HHCoachProfileViewController alloc] initWithCoach:[HHUserAuthenticator sharedInstance].myCoach];
    coachVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:coachVC animated:YES];
}

- (void)showScanView {
    QRCodeReaderViewController *scanVC = [[QRCodeReaderViewController alloc] init];
    scanVC.delegate = self;
    scanVC.view.backgroundColor = [UIColor HHOrange];
    [self presentViewController:scanVC animated:YES completion:nil];

}

- (void)autolayoutSubview {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility setCenterX:self.tableView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterY:self.tableView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.tableView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.tableView multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility setCenterX:self.noTransactionView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterY:self.noTransactionView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.noTransactionView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.noTransactionView multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.titleLabel constant:30.0f],
                             [HHAutoLayoutUtility setCenterX:self.titleLabel multiplier:1.0f constant:0],
    
                             [HHAutoLayoutUtility verticalNext:self.scanCodeLabel toView:self.titleLabel constant:10.0f],
                             [HHAutoLayoutUtility setCenterX:self.scanCodeLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.scanCodeLabel multiplier:1.0f constant:-80.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.qrCodeImageView toView:self.scanCodeLabel constant:20.0f],
                             [HHAutoLayoutUtility setCenterX:self.qrCodeImageView multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility setCenterX:self.coachImageView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.coachImageView constant:40.0f],
                             [HHAutoLayoutUtility setViewWidth:self.coachImageView multiplier:0 constant:100.0f],
                             [HHAutoLayoutUtility setViewHeight:self.coachImageView multiplier:0 constant:100.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.coachNameButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.coachNameButton toView:self.coachImageView constant:10.0f],
                             
                             
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
        coachProfileVC.hidesBottomBarWhenPushed = YES;
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
                if ([weakSelf.paymentStatus.currentStage integerValue] == 6) {
                    NSNumber *newCurrentStudentAmount = @([[HHUserAuthenticator sharedInstance].myCoach.currentStudentAmount integerValue] - 1);
                    NSNumber *newPassedStudentAmount = @([[HHUserAuthenticator sharedInstance].myCoach.passedStudentAmount integerValue] + 1);
                    [HHUserAuthenticator sharedInstance].myCoach.currentStudentAmount = newCurrentStudentAmount;
                    [HHUserAuthenticator sharedInstance].myCoach.passedStudentAmount = newPassedStudentAmount;
                    [[HHUserAuthenticator sharedInstance].myCoach saveInBackground];
                    
                    [HHUserAuthenticator sharedInstance].currentStudent.isFinished = @(1);
                    [[HHUserAuthenticator sharedInstance].currentStudent saveInBackground];
                }
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
                                                  otherButtonTitles:NSLocalizedString(@"给哈哈学车评价", nil), NSLocalizedString(@"更改个人信息", nil), NSLocalizedString(@"查看条款和协议", nil), NSLocalizedString(@"联系客服", nil),NSLocalizedString(@"退出当前账号", nil), nil];
    self.settingsActionSheet.destructiveButtonIndex = 4;
    [self.settingsActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet isEqual:self.settingsActionSheet]) {
        if (buttonIndex == 0) {
            [Appirater rateApp];
            
        } else if (buttonIndex == 1) {
            HHProfileSetupViewController *setupVC = [[HHProfileSetupViewController alloc] init];
            UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:setupVC];
            [self presentViewController:navVC animated:YES completion:nil];
            
        } else if (buttonIndex == 2) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TOUURL]];
            
        } else if (buttonIndex == 3) {
            NSString *phNo = @"4000016006";
            NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
            
            if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
                [[UIApplication sharedApplication] openURL:phoneUrl];
            }
            
            
        } else if (buttonIndex == 4) {
            self.alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"确定要退出？", nil) message:NSLocalizedString(@"退出后，可以通过手机号再次登陆！", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消退出", nil) otherButtonTitles:NSLocalizedString(@"确定退出", nil), nil];
            [self.alertView show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView isEqual:self.alertView]) {
        if (buttonIndex == 1) {
            [[HHUserAuthenticator sharedInstance] logout];
            HHLoginSignupViewController *loginSignupVC = [[HHLoginSignupViewController alloc] init];
            [self presentViewController:loginSignupVC animated:YES completion:nil];
        }
    }
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result {
    __weak HHMyProfileViewController *weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if (result) {
            [[HHLoadingView sharedInstance] showLoadingViewWithTilte:nil];
            [[HHLoadingView sharedInstance] hideLoadingView];
            [[HHCoachService sharedInstance] fetchCoachWithId:result completion:^(HHCoach *coach, NSError *error) {
                if (!error) {
                    [HHUserAuthenticator sharedInstance].myCoach = coach;
                    [HHUserAuthenticator sharedInstance].currentStudent.myCoachId = coach.coachId;
                    [HHUserAuthenticator sharedInstance].myCoach.currentStudentAmount = @([[HHUserAuthenticator sharedInstance].myCoach.currentStudentAmount integerValue] + 1);
                    [[HHUserAuthenticator sharedInstance].currentStudent saveInBackground];
                    [[HHUserAuthenticator sharedInstance].myCoach saveInBackground];
                    [weakSelf.coachImageView.imageView sd_setImageWithURL:[NSURL URLWithString:coach.avatarURL] placeholderImage:nil];
                    [weakSelf.coachNameButton setTitle:coach.fullName forState:UIControlStateNormal];
                    weakSelf.qrCodeImageView.hidden = YES;
                    weakSelf.scanCodeLabel.hidden = YES;
                    weakSelf.titleLabel.hidden = YES;
                    weakSelf.coachNameButton.hidden = NO;
                    weakSelf.coachImageView.hidden = NO;
                    
                } else {
                    [[HHLoadingView sharedInstance] hideLoadingView];
                    [HHToastUtility showToastWitiTitle:NSLocalizedString(@"扫描出错！", nil) isError:YES];
                }
            }];
        } else {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"扫描出错！", nil) isError:YES];
        }
        
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
