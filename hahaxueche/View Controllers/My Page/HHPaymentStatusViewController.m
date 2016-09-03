//
//  HHPaymentStatusViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/19/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPaymentStatusViewController.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHPaymentStatusTopView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "UIView+HHRect.h"
#import "HHPaymentStatusCell.h"
#import "HHPopupUtility.h"
#import "HHPaymentStageInfoView.h"
#import "NSNumber+HHNumber.h"
#import "HHPayCoachExplanationView.h"
#import "HHMakeReviewView.h"
#import "HHStudentService.h"
#import "HHToastManager.h"
#import "HHCoachService.h"
#import "HHStudentStore.h"
#import "HHReferralShareView.h"
#import "HHReferFriendsViewController.h"


static NSString *const kExplanationText = @"注：学员支付的学费将由平台保管，每个阶段结束后，学员可以根据情况，点击确认打款按钮。点击后，平台将阶段对应金额打给教练，然后进入下个阶段。每个阶段的金额会在点击付款后的第一个周二转到教练账户。";
static NSString *const kCellId = @"CellId";

@interface HHPaymentStatusViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) HHPurchasedService *purchasedService;
@property (nonatomic, strong) HHPaymentStatusTopView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *confirmPayButton;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) HHPaymentStageInfoView *infoView;
@property (nonatomic, strong) HHCoach *coach;
@property (nonatomic, strong) HHPaymentStage *currentPaymentStage;
@property (nonatomic, strong) UILabel *congratulationLabel;

@end

@implementation HHPaymentStatusViewController

- (instancetype)initWithPurchasedService:(HHPurchasedService *)purchasedService coach:(HHCoach *)coach {
    self = [super init];
    if (self) {
        self.purchasedService = purchasedService;
        self.coach = coach;
        self.currentPaymentStage = [self.purchasedService getCurrentPaymentStage];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"打款状态";
    self.view.backgroundColor = [UIColor HHBackgroundGary];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    [self initSubviews];
}

- (void)initSubviews {
    self.topView = [[HHPaymentStatusTopView alloc] initWithPurchasedService:self.purchasedService coach:self.coach];
    [self.view addSubview:self.topView];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor HHBackgroundGary];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[HHPaymentStatusCell class] forCellReuseIdentifier:kCellId];
    
    
    UILabel *explanationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.view.bounds)-20.0f, 80)];
    explanationLabel.text = kExplanationText;
    explanationLabel.textColor = [UIColor HHLightTextGray];
    explanationLabel.font =[UIFont systemFontOfSize:12.0f];
    explanationLabel.numberOfLines = 0;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 80.0f)];
    footerView.backgroundColor = [UIColor HHBackgroundGary];
    [footerView addSubview:explanationLabel];
    
    self.tableView.tableFooterView = footerView;
    
    self.confirmPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmPayButton setTitle:@"确认打款" forState:UIControlStateNormal];
    [self.confirmPayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmPayButton.backgroundColor = [UIColor colorWithRed:0.99 green:0.45 blue:0.13 alpha:1];
    self.confirmPayButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.confirmPayButton addTarget:self action:@selector(confirmPayButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmPayButton];
    
    self.congratulationLabel = [[UILabel alloc] init];
    self.congratulationLabel.textColor = [UIColor HHOrange];
    self.congratulationLabel.text = @"恭喜您拿到驾照!";
    self.congratulationLabel.backgroundColor = [UIColor whiteColor];
    self.congratulationLabel.textAlignment = NSTextAlignmentCenter;
    self.congratulationLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:self.congratulationLabel];
    
    self.bottomLabel = [[UILabel alloc] init];
    self.bottomLabel.backgroundColor = [UIColor whiteColor];
    self.bottomLabel.attributedText = [self buildBotString];
    [self.view addSubview:self.bottomLabel];
    
    if ([self.purchasedService.currentStage integerValue] > [self.currentPaymentStage.stageNumber integerValue]) {
        self.congratulationLabel.hidden = NO;
        self.confirmPayButton.hidden = YES;
        self.bottomLabel.hidden = YES;
    } else {
        self.congratulationLabel.hidden = YES;
        self.confirmPayButton.hidden = NO;
        self.bottomLabel.hidden = NO;
    }
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [UIColor HHLightLineGray];
    [self.view addSubview:self.bottomLine];
    
    [self makeContraints];
}

- (void)makeContraints {
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.width.equalTo(self.view.width);
        make.left.equalTo(self.view.left);
        make.height.mas_equalTo(170.0f);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.bottom);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(self.view.bottom).offset(-50.0f);
    }];
    
    [self.confirmPayButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
        make.width.mas_equalTo(140.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.bottomLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.bottom.equalTo(self.view.bottom);
        make.right.equalTo(self.confirmPayButton.left);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.congratulationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.bottom.equalTo(self.view.bottom);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.top.equalTo(self.tableView.bottom);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
}

#pragma mark - TableView Delegate & Datasource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak HHPaymentStatusViewController *weakSelf = self;
    HHPaymentStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    HHPaymentStage *stage = self.purchasedService.paymentStages[indexPath.row];
    cell.rightButtonBlock = ^() {
        if ([stage.reviewable boolValue]) {
            if (![stage.reviewed boolValue]) {
                if ([stage.readyForReview boolValue]) {
                    [weakSelf makeReviewWithPaymentStage:stage showReferPopup:YES];
                } else {
                    weakSelf.infoView = [self buildInfoViewWithStage:self.purchasedService.paymentStages[indexPath.row]];
                    weakSelf.popup = [HHPopupUtility createPopupWithContentView:weakSelf.infoView];
                    [HHPopupUtility showPopup:weakSelf.popup];
                }
            } 
        } else {
            weakSelf.infoView = [self buildInfoViewWithStage:self.purchasedService.paymentStages[indexPath.row]];
            weakSelf.popup = [HHPopupUtility createPopupWithContentView:weakSelf.infoView];
            [HHPopupUtility showPopup:weakSelf.popup];
        }
    };
    
    [cell setupCellWithPaymentStage:stage currentStatge:self.purchasedService.currentStage];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}


#pragma mark Button Actions

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Others
- (NSMutableAttributedString *)buildBotString {
    if ([self.purchasedService isFinished]) {
        return nil;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"本期待打款金额：" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor HHTextDarkGray], NSParagraphStyleAttributeName:paragraphStyle}];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:[self.currentPaymentStage.stageAmount generateMoneyString] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName:[UIColor HHOrange],NSParagraphStyleAttributeName:paragraphStyle}];
    
    [string appendAttributedString:string2];
    
    return string;
}

- (HHPaymentStageInfoView *)buildInfoViewWithStage:(HHPaymentStage *)paymentStage {
    __weak HHPaymentStatusViewController *weakSelf = self;
    UIImage *image;
    NSString *titleString;
    UIColor *textColor;
    
    if ([paymentStage.stageNumber integerValue] < [self.currentPaymentStage.stageNumber integerValue] || [self.purchasedService isFinished]) {
        textColor = [UIColor HHGreen];
        image = [UIImage imageNamed:@"ic_assess_paysuccess"];
        titleString = [NSString stringWithFormat:@"%@ 已打款", paymentStage.stageName];
    } else {
        textColor = [UIColor HHOrange];
        image = [UIImage imageNamed:@"ic_havenotpay"];
        titleString = [NSString stringWithFormat:@"%@ 待打款", paymentStage.stageName];
    }
    
   HHPaymentStageInfoView *infoView = [[HHPaymentStageInfoView alloc] initWithImage:image title:titleString text:paymentStage.explanationText textColor:textColor];
    infoView.frame = CGRectMake(0, 0, CGRectGetWidth(weakSelf.view.bounds) - 80.0f, 160.0f);
    infoView.okAction = ^(){
        [HHPopupUtility dismissPopup:weakSelf.popup];
    };
    return infoView;
}

- (void)makeReviewWithPaymentStage:(HHPaymentStage *)paymentStage showReferPopup:(BOOL)showReferPopup {
    
    __weak HHPaymentStatusViewController *weakSelf = self;
    HHMakeReviewView *reviewView = [[HHMakeReviewView alloc] initWithFrame:CGRectMake(0, 0, 300.0f, 230.0f)];
    reviewView.makeReviewBlock = ^(NSNumber *rating, NSString *comment){
        if ([comment isEqualToString:@""]) {
            [[HHToastManager sharedManager] showErrorToastWithText:@"评论为空，写点什么给教练吧！"];
            return ;
        }
        
        [[HHCoachService sharedInstance] makeReviewWithCoachUserId:paymentStage.coachUserId paymentStage:paymentStage.stageNumber rating:rating comment:comment completion:^(HHReview *review, NSError *error) {
            if (!error) {
                [HHPopupUtility dismissPopup:self.popup];
                [[HHToastManager sharedManager] showSuccessToastWithText:@"成功评价教练！"];
                [self updateReviewed:paymentStage];
                [weakSelf.tableView reloadData];
                if (showReferPopup) {
                    [weakSelf showReferPopup];
                }
            } else {
                [[HHToastManager sharedManager] showErrorToastWithText:@"评价教练失败,请重试!"];
            }
        }];
    };
    
    reviewView.cancelBlock = ^(){
        [HHPopupUtility dismissPopup:self.popup];
        if (showReferPopup) {
            [weakSelf showReferPopup];
        }
    };
    self.popup = [HHPopupUtility createPopupWithContentView:reviewView];
    self.popup.shouldDismissOnBackgroundTouch = NO;
    [HHPopupUtility showPopup:self.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutAboveCenter)];

}

- (void)confirmPayButtonTapped {
    HHPayCoachExplanationView *view = [[HHPayCoachExplanationView alloc] initWithFrame:CGRectMake(0, 0, 300, 200.0f) amount:self.currentPaymentStage.stageAmount];
    [view.buttonsView.leftButton addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
    [view.buttonsView.rightButton addTarget:self action:@selector(payCoach) forControlEvents:UIControlEventTouchUpInside];
    self.popup = [HHPopupUtility createPopupWithContentView:view];
    [HHPopupUtility showPopup:self.popup];
    
}

- (void)payCoach {
    [[HHStudentService sharedInstance] payStage:self.currentPaymentStage completion:^(HHPurchasedService *purchasedService, NSError *error) {
        if (!error) {
            [HHPopupUtility dismissPopup:self.popup];
            
            if ([self.currentPaymentStage.reviewable boolValue]) {
                [self makeReviewWithPaymentStage:self.currentPaymentStage showReferPopup:YES];
            } else {
                [self showReferPopup];
            }
            
            if (self.updatePSBlock) {
                self.updatePSBlock(purchasedService);
            }
            self.purchasedService = purchasedService;
            self.currentPaymentStage = [self.purchasedService getCurrentPaymentStage];
            self.bottomLabel.attributedText = [self buildBotString];

            [self.topView updatePaidAndUnpaidAmount:purchasedService];
            [self.tableView reloadData];
            [[HHToastManager sharedManager] showSuccessToastWithText:@"打款成功！"];
            
            if ([self.purchasedService isFinished]) {
                self.bottomLabel.hidden = YES;
                self.confirmPayButton.hidden = YES;
                self.congratulationLabel.hidden = NO;
            }
        } else {
           [[HHToastManager sharedManager] showErrorToastWithText:@"打款失败，请重试！"];
        }
    }];
}

- (void)dismissPopup {
    [HHPopupUtility dismissPopup:self.popup];
}

- (void)updateReviewed:(HHPaymentStage *)paymentStage {
    for (HHPaymentStage *stage in self.purchasedService.paymentStages) {
        if ([stage.paymentStageId isEqualToString:paymentStage.paymentStageId]) {
            stage.reviewed = @(1);
            break;
        }
    }
}

- (void)showReferPopup {
    __weak HHPaymentStatusViewController *weakSelf = self;
    HHReferralShareView *shareView = [[HHReferralShareView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 40.0f, 300.0f)];
    shareView.cancelBlock = ^(){
        [weakSelf.popup dismiss:YES];
    };
    
    shareView.shareBlock = ^(){
        [weakSelf.popup dismiss:YES];
        
        HHReferFriendsViewController *vc = [[HHReferFriendsViewController alloc] init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
        [weakSelf presentViewController:navVC animated:YES completion:nil];
    };
    self.popup = [HHPopupUtility createPopupWithContentView:shareView];
    self.popup.shouldDismissOnBackgroundTouch = NO;
    [HHPopupUtility showPopup:self.popup];
}

@end
