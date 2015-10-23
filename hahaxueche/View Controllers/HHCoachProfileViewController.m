//
//  HHCoachProfileViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/21/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHCoachProfileViewController.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "UIColor+HHColor.h"
#import "HHCoachDesTableViewCell.h"
#import "HHCoachDashBoardTableViewCell.h"
#import "HHUserAuthenticator.h"
#import "HHToastUtility.h"
#import "HHCoachService.h"
#import "HHScheduleTableViewCell.h"
#import "HHScheduleService.h"
#import "HHRootViewController.h"
#import "HHReviewTableViewCell.h"
#import "HHReviewViewController.h"
#import "HHFullScreenImageViewController.h"
#import "HHTimeSlotsViewController.h"
#import "HHNavigationController.h"
#import "ParallaxHeaderView.h"
#import "HHTrainingFieldService.h"
#import "HHScrollImageGallery.h"
#import "KLCPopup.h"
#import "HHReviewService.h"
#import "HHLoadingView.h"
#import "HHAlipayOrder.h"
#import "HHAlipayService.h"
#import "HHTransaction.h"
#import "HHPaymentStatus.h"
#import "HHTransfer.h"
#import "KLCPopup.h"


typedef enum : NSUInteger {
    CoachProfileCellDes,
    CoachProfileCellDashBoard,
    CoachProfileCellCalendar,
    CoachProfileCellReview,
    CoachProfileCellTotal
} CoachProfileCell;

#define kDesCellId @"kDesCellId"
#define kDashBoardCellId @"kDashBoardCellId"
#define kScheduleCellId @"kScheduleCellId"
#define kReviewCellId @"kReviewCellId"

@interface HHCoachProfileViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIScrollViewDelegate, HHScrollImageGalleryDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HHScrollImageGallery *imageGalleryView;
@property (nonatomic)         CGFloat desCellHeight;
@property (nonatomic, strong) UIActionSheet *phoneSheet;
@property (nonatomic, strong) UIActionSheet *addressSheet;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) UIButton *bookTrialButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) NSMutableAttributedString *coachDes;
@property (nonatomic, strong) NSArray *reviews;
@property (nonatomic, strong) KLCPopup *reviewPopupView;
@property (nonatomic, strong) HHStarRatingView *ratingView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UITextView *reviewTextView;


@end

@implementation HHCoachProfileViewController

- (void)dealloc {
    self.phoneSheet.delegate = nil;
    self.addressSheet.delegate = nil;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.imageGalleryView.delegate = nil;
}

- (instancetype)initWithCoach:(HHCoach *)coach {
    self = [super init];
    if (self) {
        self.coach = coach;
        self.title = self.coach.fullName;
        self.view.backgroundColor = [UIColor HHLightGrayBackgroundColor];
        UIBarButtonItem *backButton = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"left_arrow"] action:@selector(backButtonPressed) target:self];
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -8.0f;//
        [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
        
        
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        [paragraph setLineSpacing:3.0f];
        self.coachDes = [[NSMutableAttributedString alloc] initWithString:self.coach.des attributes:@{NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Light" size:13.0f], NSParagraphStyleAttributeName:paragraph}];

        
        CGRect rect = [self.coachDes boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds) - 40.0f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)context:nil];
        
        self.desCellHeight = CGRectGetHeight(rect) + 65.0f;
        __weak HHCoachProfileViewController *weakSelf = self;
        [[HHReviewService sharedInstance] fetchReviewsForCoach:self.coach.coachId skip:0 completion:^(NSArray *objects, NSInteger totalCount, NSError *error) {
            if (!error) {
                weakSelf.reviews = objects;
            }
        }];
        
        NSArray *filteredarray = [[HHTrainingFieldService sharedInstance].supportedFields filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(objectId == %@)", self.coach.trainingFieldId]];
        self.field = [filteredarray firstObject];
    }
    return self;
}

- (void)setReviews:(NSArray *)reviews {
    _reviews = reviews;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:CoachProfileCellReview inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}

- (void)initSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[HHCoachDesTableViewCell class] forCellReuseIdentifier:kDesCellId];
    [self.tableView registerClass:[HHCoachDashBoardTableViewCell class] forCellReuseIdentifier:kDashBoardCellId];
    [self.tableView registerClass:[HHScheduleTableViewCell class] forCellReuseIdentifier:kScheduleCellId];
    [self.tableView registerClass:[HHReviewTableViewCell class] forCellReuseIdentifier:kReviewCellId];

    self.imageGalleryView = [[HHScrollImageGallery alloc] initWithURLStrings:self.coach.images];
    self.imageGalleryView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 200.0f);
    self.imageGalleryView.delegate = self;
    ParallaxHeaderView *headerView = [ParallaxHeaderView parallaxHeaderViewWithSubView:self.imageGalleryView];
    self.tableView.tableHeaderView = headerView;
    
    
    self.phoneSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:NSLocalizedString(@"复制手机号", nil), NSLocalizedString(@"拨打号码", nil), nil];
    
    self.addressSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:NSLocalizedString(@"复制地址", nil),nil];
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]) {
        [self.addressSheet addButtonWithTitle:NSLocalizedString(@"在百度地图中打开", nil)];
    }
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        [self.addressSheet addButtonWithTitle:NSLocalizedString(@"在高德地图中打开", nil)];
    }
    
    self.payButton = [self createButtonWithTitle:NSLocalizedString(@"确认教练并付款", nil) backgroundColor:[UIColor HHOrange] font:[UIFont fontWithName:@"STHeitiSC-Medium" size:18.0f] action:@selector(payCoach)];
    [self.view addSubview:self.payButton];
    
    self.bookTrialButton = [self createButtonWithTitle:NSLocalizedString(@"预约试学", nil) backgroundColor:[UIColor HHLightOrange] font:[UIFont fontWithName:@"STHeitiSC-Medium" size:18.0f] action:@selector(callCoach)];
    [self.view addSubview:self.bookTrialButton];
    
    self.commentButton = [self createButtonWithTitle:NSLocalizedString(@"评价教练", nil) backgroundColor:[UIColor HHOrange] font:[UIFont fontWithName:@"STHeitiSC-Medium" size:18.0f] action:@selector(commentCoach)];
    [self.view addSubview:self.commentButton];


    if (![self.coach.coachId isEqualToString:[HHUserAuthenticator sharedInstance].currentStudent.myCoachId]) {
        self.payButton.hidden = NO;
        self.bookTrialButton.hidden = NO;
        self.commentButton.hidden = YES;
    }
    else {
        self.payButton.hidden = YES;
        self.bookTrialButton.hidden = YES;
        self.commentButton.hidden = NO;
    }
    
     [self autolayoutSubview];
    
}

- (void)payCoach {
    if ([[HHUserAuthenticator sharedInstance].currentStudent.myCoachId length]) {
        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"您已经有教练，无需再购买其他教练服务。", nil) isError:YES];
        return;
    }
    HHTransaction *transaction = [HHTransaction objectWithClassName:[HHTransaction parseClassName]];
    transaction.studentId = [HHUserAuthenticator sharedInstance].currentStudent.studentId;
    transaction.coachId = self.coach.coachId;
    transaction.paidPrice = self.coach.actualPrice;
    transaction.paymentMethod = NSLocalizedString(@"支付宝", nil);
    
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:NSLocalizedString(@"加载中", nil)];
    
    [transaction save];
    HHAlipayOrder *order = [[HHAlipayOrder alloc] initWithOrderNumber:transaction.objectId amount:self.coach.actualPrice];
    [[HHAlipayService sharedInstance] payByAlipayWith:order completion:^(NSDictionary *dictionary) {
        [[HHLoadingView sharedInstance] hideLoadingView];
        if ([dictionary[@"resultStatus"] isEqualToString:@"9000"]) {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"支付成功！", nil) isError:NO];
            [self transactionSucceed:transaction];
        } else {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"支付失败！", nil) isError:YES];
            [transaction delete];
        }
    }];
}

- (void)transactionSucceed:(HHTransaction *)transaction {
    __weak HHCoachProfileViewController *weakSelf = self;
    NSInteger newAmount = [self.coach.currentStudentAmount integerValue] + 1;
    self.coach.currentStudentAmount = [NSNumber numberWithInteger:newAmount];
    [self.tableView reloadData];
    [self.coach saveInBackground];
    
    [HHUserAuthenticator sharedInstance].currentStudent.myCoachId = self.coach.coachId;
    [[HHUserAuthenticator sharedInstance].currentStudent saveInBackground];
    [HHUserAuthenticator sharedInstance].myCoach = self.coach;

    
    HHPaymentStatus *paymentStatus = [HHPaymentStatus objectWithClassName:[HHPaymentStatus parseClassName]];
    paymentStatus.transactionId = transaction.objectId;
    paymentStatus.stageOneAmount = @(350);
    paymentStatus.stageTwoAmount = @(550);
    paymentStatus.stageThreeAmount = @(([transaction.paidPrice floatValue] - 900) * 0.6);
    paymentStatus.stageFourAmount = @(([transaction.paidPrice floatValue] - 900) * 0.3);
    paymentStatus.stageFiveAmount = @(([transaction.paidPrice floatValue] - 900) * 0.1);
    paymentStatus.currentStage = @(2);
    
    HHTransfer *firstTransfer = [HHTransfer objectWithClassName:[HHTransfer parseClassName]];
    firstTransfer.studentId = [HHUserAuthenticator sharedInstance].currentStudent.studentId;
    firstTransfer.coachId = self.coach.coachId;
    firstTransfer.transactionId = transaction.objectId;
    firstTransfer.stage = @(1);
    firstTransfer.amount = paymentStatus.stageOneAmount;
    firstTransfer.payeeAccount = self.coach.alipayAccount;
    firstTransfer.payeeAccountType = NSLocalizedString(@"支付宝", nil);
    firstTransfer.transferStatus = @"pending";
    [firstTransfer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [paymentStatus saveInBackground];
            weakSelf.payButton.hidden = YES;
            weakSelf.bookTrialButton.hidden = YES;
            weakSelf.commentButton.hidden = NO;
        }
    }];
    

}

- (void)callCoach {
    if ([[HHUserAuthenticator sharedInstance].currentStudent.myCoachId length]) {
        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"您已经有教练，无需再试学。", nil) isError:YES];
        return;
    }
    NSString *phoneURLString = [NSString stringWithFormat:@"telprompt://%@", @"4000016006"];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    [[UIApplication sharedApplication] openURL:phoneURL];
}

- (void)commentCoach {
    [self showReviewPopupView];
}

- (void)showReviewPopupView {
    
    UIView *reviewView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 40.0f, CGRectGetHeight(self.view.bounds) * 3.0f/7.0f)];
    reviewView.backgroundColor = [UIColor whiteColor];
    self.reviewPopupView = [KLCPopup popupWithContentView:reviewView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = NSLocalizedString(@"给教练打分", nil);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel sizeToFit];
    [reviewView addSubview:titleLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = [UIColor HHGrayLineColor];
    [reviewView addSubview:line];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectZero];
    line2.translatesAutoresizingMaskIntoConstraints = NO;
    line2.backgroundColor = [UIColor HHGrayLineColor];
    [reviewView addSubview:line2];
    
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
    verticalLine.translatesAutoresizingMaskIntoConstraints = NO;
    verticalLine.backgroundColor = [UIColor HHGrayLineColor];
    [reviewView addSubview:verticalLine];
    
    self.reviewTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    self.reviewTextView.translatesAutoresizingMaskIntoConstraints = NO;
    self.reviewTextView.font = [UIFont fontWithName:@"STHeitiSC-Light" size:13.0f];
    self.reviewTextView.showsHorizontalScrollIndicator = NO;
    self.reviewTextView.delegate = self;
    [reviewView addSubview:self.reviewTextView];
    
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.placeholderLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:13.0f];
    self.placeholderLabel.textColor = [UIColor lightGrayColor];
    self.placeholderLabel.text = NSLocalizedString(@"牢骚或表扬，大胆说出来吧！", nil);
    self.placeholderLabel.textAlignment = NSTextAlignmentLeft;
    [self.placeholderLabel sizeToFit];
    [self.reviewTextView addSubview:self.placeholderLabel];

    
    UIButton *dismissButton = [self createButtonWithTitle:NSLocalizedString(@"取消返回", nil) backgroundColor:[UIColor whiteColor] font:[UIFont fontWithName:@"STHeitiSC-Light" size:15.0f] action:@selector(dismissCommentPopupView)];
    [dismissButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
    [reviewView addSubview:dismissButton];
    
    UIButton *confirmButton = [self createButtonWithTitle:NSLocalizedString(@"确认评价", nil) backgroundColor:[UIColor whiteColor] font:[UIFont fontWithName:@"STHeitiSC-Light" size:15.0f] action:@selector(confirmButtonTapped)];
    [confirmButton setTitleColor:[UIColor HHBlueButtonColor] forState:UIControlStateNormal];
    [reviewView addSubview:confirmButton];
    
    self.ratingView = [[HHStarRatingView alloc] initWithFrame:CGRectZero rating:0];
    self.ratingView.userInteractionEnabled = YES;
    self.ratingView.translatesAutoresizingMaskIntoConstraints = NO;
    [reviewView addSubview:self.ratingView];
    
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:titleLabel constant:15.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:titleLabel constant:15.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.ratingView toView:titleLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.ratingView constant:-10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.ratingView multiplier:0 constant:45.0f],
                             [HHAutoLayoutUtility setViewWidth:self.ratingView multiplier:0 constant:110.0f],

                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:line constant:45.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:line constant:0],
                             [HHAutoLayoutUtility setViewWidth:line multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:line multiplier:0 constant:1.0f],
                             
                             
                             [HHAutoLayoutUtility verticalNext:self.reviewTextView toView:line constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.reviewTextView constant:10.0f],
                             [HHAutoLayoutUtility setViewWidth:self.reviewTextView multiplier:1.0f constant:-30.0f],
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.reviewTextView constant:-46.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:line2 constant:-45.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:line2 constant:0],
                             [HHAutoLayoutUtility setViewWidth:line2 multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:line2 multiplier:0 constant:1.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:dismissButton constant:0],
                             [HHAutoLayoutUtility setCenterX:dismissButton multiplier:0.5f constant:0],
                             [HHAutoLayoutUtility setViewWidth:dismissButton multiplier:0.5f constant:-1.0f],
                             [HHAutoLayoutUtility setViewHeight:dismissButton multiplier:0 constant:45.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:confirmButton constant:0],
                             [HHAutoLayoutUtility setCenterX:confirmButton multiplier:1.5f constant:0],
                             [HHAutoLayoutUtility setViewWidth:confirmButton multiplier:0.5f constant:-1.0f],
                             [HHAutoLayoutUtility setViewHeight:confirmButton multiplier:0 constant:45.0f],

                             
                             
                             [HHAutoLayoutUtility setCenterY:verticalLine multiplier:2.0f constant:-45.0f/2.0f],
                             [HHAutoLayoutUtility setCenterX:verticalLine multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:verticalLine multiplier:0 constant:1.0f],
                             [HHAutoLayoutUtility setViewHeight:verticalLine multiplier:0 constant:30.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.placeholderLabel constant:10.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.placeholderLabel constant:6.0f],
                            
                             ];
        
    
    [reviewView addConstraints:constraints];
    [self.reviewTextView becomeFirstResponder];
    self.reviewPopupView.shouldDismissOnBackgroundTouch = NO;
    [self.reviewPopupView showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutAboveCenter)];
}

- (void)dismissCommentPopupView {
    [self.reviewPopupView dismiss:YES];
}

- (void)confirmButtonTapped {
    __weak HHCoachProfileViewController *weakSelf = self;
    HHReview *newReview = [[HHReview alloc] initWithClassName:@"Review"];
    newReview.studentId = [HHUserAuthenticator sharedInstance].currentStudent.studentId;
    newReview.coachId = self.coach.coachId;
    newReview.rating = [NSNumber numberWithFloat:self.ratingView.value];
    newReview.comment = self.reviewTextView.text;
    if([newReview.comment isEqualToString:@""]) {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:NSLocalizedString(@"请输入评语，谢谢", nil)
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"我知道了", nil)
                                               otherButtonTitles: nil];
        [alert show];
        return;
    }
    if([newReview.rating floatValue] <= 0) {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:NSLocalizedString(@"您还没有打分哦", nil)
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"我知道了", nil)
                                               otherButtonTitles: nil];
        [alert show];
        return;
    }
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:NSLocalizedString(@"提交中", nil)];
    [[HHReviewService sharedInstance] submitReview:newReview completion:^(HHCoach *coach, NSError *error) {
        [[HHLoadingView sharedInstance] hideLoadingView];
        if (!error) {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"评价成功！", nil) isError:NO];
            weakSelf.coach = coach;
            [weakSelf.tableView reloadData];
            NSMutableArray *updatedReviews = [NSMutableArray arrayWithArray:weakSelf.reviews];
            [updatedReviews insertObject:newReview atIndex:0];
            weakSelf.reviews = updatedReviews;
        } else {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"提交数据出错！", nil) isError:YES];
        }
    }];
    [self.reviewPopupView dismiss:YES];
}

- (void)autolayoutSubview {
   
    NSArray *constraints = @[
                        [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.tableView constant:0],
                        [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.tableView constant:0],
                        [HHAutoLayoutUtility setViewWidth:self.tableView multiplier:1.0f constant:0],
                        [HHAutoLayoutUtility setViewHeight:self.tableView multiplier:1.0f constant:-50.0f],
                        
                        [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.bookTrialButton constant:0],
                        [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.bookTrialButton constant:0],
                        [HHAutoLayoutUtility setViewWidth:self.bookTrialButton multiplier:0.4f constant:0],
                        [HHAutoLayoutUtility setViewHeight:self.bookTrialButton multiplier:0 constant:50.0f],
                        
                        [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.payButton constant:0],
                        [HHAutoLayoutUtility horizontalNext:self.payButton toView:self.bookTrialButton constant:0],
                        [HHAutoLayoutUtility setViewWidth:self.payButton multiplier:0.6f constant:0],
                        [HHAutoLayoutUtility setViewHeight:self.payButton multiplier:0 constant:50.0f],
                        
                        [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.commentButton constant:0],
                        [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.commentButton constant:0],
                        [HHAutoLayoutUtility setViewWidth:self.commentButton multiplier:1.0f constant:0],
                        [HHAutoLayoutUtility setViewHeight:self.commentButton multiplier:0 constant:50.0f],

                        ];

    
    
    [self.view addConstraints:constraints];
    
    
}

- (UIButton *)createButtonWithTitle:(NSString *)title backgroundColor:(UIColor *)bgColor font:(UIFont *)font action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setBackgroundColor:bgColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


#pragma mark Tableview Delagate & Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return CoachProfileCellTotal;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak HHCoachProfileViewController *weakSelf = self;
    switch (indexPath.row) {
        case CoachProfileCellDes:{
            HHCoachDesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDesCellId forIndexPath:indexPath];
            AVFile *file = [AVFile fileWithURL:self.coach.avatarURL];
            NSString *thumbnailString = [file getThumbnailURLWithScaleToFit:YES width:80.0f height:80.0f quality:100 format:@"png"];
            [cell setupViewWithURL:thumbnailString name:self.coach.fullName des:self.coachDes];
            cell.block = ^() {
                HHFullScreenImageViewController *imageViewer = [[HHFullScreenImageViewController alloc] initWithImageURLArray:@[weakSelf.coach.avatarURL] titleArray:@[weakSelf.coach.fullName] initalIndex:0];
                [weakSelf presentViewController:imageViewer animated:YES completion:nil];
            };
            return cell;
        }
        case CoachProfileCellDashBoard: {
            HHCoachDashBoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDashBoardCellId forIndexPath:indexPath];
            [cell setupViewsWithCoach:self.coach trainingFielf:self.field];
            cell.priceTappedCompletion = ^() {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 40.0f, 350.0f)];
                
                imageView.image = [UIImage imageNamed:@"fees"];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                KLCPopup *feesPopup= [KLCPopup popupWithContentView:imageView];
                feesPopup.shouldDismissOnContentTouch = YES;
                [feesPopup showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter)];

            };
            
            if ([[HHUserAuthenticator sharedInstance].currentStudent.myCoachId isEqualToString:self.coach.coachId]) {
                cell.phoneTappedCompletion = ^() {
                    [weakSelf.phoneSheet showInView:weakSelf.view];
                };
            }
            
            
            cell.addressTappedCompletion = ^() {
                [weakSelf.addressSheet showInView:weakSelf.view];
            };
            return cell;
        }
        case CoachProfileCellCalendar: {
            HHScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kScheduleCellId forIndexPath:indexPath];
            return cell;
        }
        case CoachProfileCellReview: {
            HHReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReviewCellId forIndexPath:indexPath];
            [cell setupRatingView:self.coach.averageRating];
            [cell setupReviewViews:self.reviews];
            cell.reviewTappedBlock = ^(NSInteger index) {
                HHReviewViewController *reviewVC = [[HHReviewViewController alloc] init];
                reviewVC.reviews = [NSMutableArray arrayWithArray:weakSelf.reviews];
                reviewVC.initialIndex = index;
                reviewVC.coach = weakSelf.coach;
                reviewVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [weakSelf presentViewController:reviewVC animated:YES completion:nil];
            };
            return cell;
        }
            
        default: {
            return nil;
        }
            
    }   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case CoachProfileCellDes:{
            return self.desCellHeight;
        }
        case CoachProfileCellDashBoard: {
            return 220.0f;
        }
        case CoachProfileCellCalendar: {
            return 50.0f;
        }
        case CoachProfileCellReview: {
            NSInteger reviewCount =  MIN(3, self.reviews.count);
            CGFloat totalHeight = 0;
            for (int i = 0; i < reviewCount; i++) {
                HHReview *review = self.reviews[i];
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:review.comment];
                [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiSC-Medium" size:13] range:NSMakeRange(0, review.comment.length)];
                CGFloat viewHeight = CGRectGetHeight([attrString boundingRectWithSize:CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds])-75.0f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil]) + 70.0f;
                totalHeight = totalHeight + viewHeight;
            }
            return 50.0f + totalHeight;
        }
            
        default: {
            return 44.0f;
        }
            
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == CoachProfileCellCalendar) {
        HHTimeSlotsViewController *vc = [[HHTimeSlotsViewController alloc] init];
        vc.coach = self.coach;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet isEqual:self.phoneSheet]) {
        if (buttonIndex == 0) {
            UIPasteboard *pb = [UIPasteboard generalPasteboard];
            [pb setString:self.coach.phoneNumber];
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"复制成功！", nil) isError:NO];
        } else if (buttonIndex == 1) {
            NSString *callString =[ NSString stringWithFormat:@"telprompt://%@", self.coach.phoneNumber];
            NSURL *url = [NSURL URLWithString:callString];
            [[UIApplication sharedApplication] openURL:url];
        }
    } else if ([actionSheet isEqual:self.addressSheet]) {
        if(buttonIndex == 0) {
            UIPasteboard *pb = [UIPasteboard generalPasteboard];
            [pb setString:self.field.address];
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"复制成功！", nil) isError:NO];
            return;
        }
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        NSString *urlString = nil;
        if([title isEqualToString:NSLocalizedString(@"在百度地图中打开", nil)]) {
            urlString = [[NSString stringWithFormat:@"baidumap://map/geocoder?location=%f,%f&title=训练场", [self.field.latitude floatValue], [self.field.longitude floatValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        } else if ([title isEqualToString:NSLocalizedString(@"在高德地图中打开", nil)]) {
            urlString = [[NSString stringWithFormat:@"iosamap://viewMap?sourceApplication=hahaxueche&poiname=训练场&lat=%f&lon=%f&dev=1", [self.field.latitude floatValue], [self.field.longitude floatValue]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    }
}

#pragma -mark UISCrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [(ParallaxHeaderView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}

#pragma -mark HHScrollImageGallery Delegate

- (void)showFullImageView:(NSInteger)index {
    HHFullScreenImageViewController *fullImageVC = [[HHFullScreenImageViewController alloc] initWithImageURLArray:self.coach.images titleArray:nil initalIndex:index];
    [self presentViewController:fullImageVC animated:YES completion:nil];
}

#pragma -mark TextView Delegate

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        self.placeholderLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = YES;
    }
}

@end
