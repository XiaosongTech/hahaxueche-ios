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
#define kAvatarRadius 50.0f

@interface HHCoachStudentProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *explanationLabel;
@property (nonatomic, strong) HHPaymentStatus *paymentStatus;
@property (nonatomic, strong) UIView *noTransactionView;
@property (nonatomic, strong) HHAvatarView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *numberButton;
@property (nonatomic, strong) UILabel *desLabel;

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
    
    self.noTransactionView = [[UIView alloc] initWithFrame:CGRectZero];
    self.noTransactionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.view.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    [self.view addSubview:self.noTransactionView];
    
    self.avatarView = [[HHAvatarView alloc] initWithImageURL:self.student.avatarURL radius:kAvatarRadius borderColor:[UIColor whiteColor]];
    self.avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.noTransactionView addSubview:self.avatarView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.text = self.student.fullName;
    self.nameLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:25.0f];
    self.nameLabel.textColor = [UIColor HHDarkGrayTextColor];
    [self.nameLabel sizeToFit];
    [self.noTransactionView addSubview:self.nameLabel];
    
    self.numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.numberButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.numberButton setTitle:self.student.phoneNumber forState:UIControlStateNormal];
    self.numberButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20.0f];
    [self.numberButton setTitleColor:[UIColor HHClickableBlue] forState:UIControlStateNormal];
    [self.numberButton addTarget:self action:@selector(callUser) forControlEvents:UIControlEventTouchUpInside];
    [self.numberButton sizeToFit];
    [self.noTransactionView addSubview:self.numberButton];
    
    self.desLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.desLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.desLabel.text = NSLocalizedString(@"该学员并未在哈哈学车平台上付款，可能是您之前已有的学员在使用哈哈学车的预约练车系统。所以无法查看该学员的付款情况！", nil);
    self.desLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15.0f];
    self.desLabel.textColor = [UIColor HHOrange];
    self.desLabel.numberOfLines = 0;
    [self.desLabel sizeToFit];
    [self.noTransactionView addSubview:self.desLabel];
    
    
    self.tableView.hidden = YES;
    self.noTransactionView.hidden = YES;

    [self fetchPaymentData];
    [self autolayoutSubview];
    
}

- (void)fetchPaymentData {
    if ([self.transactionArray count] && ![[self.transactionArray firstObject] isKindOfClass:[NSString class]]) {
        [[HHLoadingView sharedInstance] showLoadingViewWithTilte:nil];
        HHTransaction *transaction = [self.transactionArray firstObject];
        [[HHPaymentTransactionService sharedInstance] fetchPaymentStatusWithTransactionId:transaction.objectId completion:^(HHPaymentStatus *paymentStatus, NSError *error) {
            [[HHLoadingView sharedInstance] hideLoadingView];
            if (!error) {
                self.paymentStatus = paymentStatus;
                [self.tableView reloadData];
            }
            if (self.paymentStatus) {
                self.tableView.hidden = NO;
                self.noTransactionView.hidden = YES;
            } else {
                self.tableView.hidden = YES;
                self.noTransactionView.hidden = NO;
            }

        }];
    } else {
        self.tableView.hidden = YES;
        self.noTransactionView.hidden = NO;
    }
}

- (void)setStudent:(HHStudent *)student {
    _student = student;
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
                             
                             [HHAutoLayoutUtility setCenterX:self.avatarView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.avatarView constant:30.0f],
                             [HHAutoLayoutUtility setViewHeight:self.avatarView multiplier:0 constant:kAvatarRadius * 2.0f],
                             [HHAutoLayoutUtility setViewWidth:self.avatarView multiplier:0 constant:kAvatarRadius * 2.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.nameLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.nameLabel toView:self.avatarView constant:10.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.numberButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.numberButton toView:self.nameLabel constant:5.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.desLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.desLabel toView:self.numberButton constant:20.0f],
                             [HHAutoLayoutUtility setViewWidth:self.desLabel multiplier:1.0f constant:-80.0f],
                             //[HHAutoLayoutUtility setViewHeight:self.desLabel multiplier:0 constant:200],

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
    if ([self.transactionArray count] && ![[self.transactionArray firstObject] isKindOfClass:[NSString class]]) {
         cell.transaction = self.transactionArray[indexPath.row];
        cell.paymentStatus = self.paymentStatus;
    }
    cell.callStudentBlock = ^(){
        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",self.student.phoneNumber]];
       [[UIApplication sharedApplication] openURL:phoneUrl];
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 380.0f;
}

- (void)callUser {
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:self.student.phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}


@end
