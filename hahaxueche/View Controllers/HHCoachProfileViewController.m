//
//  HHCoachProfileViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/21/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHCoachProfileViewController.h"
#import "HHAutoLayoutUtility.h"
#import "SDCycleScrollView.h"
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

@interface HHCoachProfileViewController ()<UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *imageGalleryView;
@property (nonatomic)         CGFloat desCellHeight;
@property (nonatomic, strong) UIActionSheet *phoneSheet;
@property (nonatomic, strong) UIActionSheet *addressSheet;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) UIButton *bookTrialButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) NSMutableAttributedString *coachDes;
@property (nonatomic, strong) NSArray *reviews;

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
        
        self.coachDes = [[NSMutableAttributedString alloc] initWithString:self.coach.des];
        NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
        [paragrahStyle setLineSpacing:5.0f];
        [self.coachDes addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, [self.coach.des length])];
        self.desCellHeight = CGRectGetHeight([self.coachDes boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds)-40.0f, 99999.0)
                                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                                            context:nil]) + 65.0f;
        
        __weak HHCoachProfileViewController *weakSelf = self;
        [[HHCoachService sharedInstance] fetchReviewsForCoach:self.coach.coachId skip:0 completion:^(NSArray *objects, NSInteger totalCount, NSError *error) {
            if (!error) {
                weakSelf.reviews = objects;
            }
        }];
    }
    return self;
}

- (void)setReviews:(NSArray *)reviews {
    _reviews = reviews;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:CoachProfileCellReview inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)setField:(HHTrainingField *)field {
    _field = field;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:CoachProfileCellDashBoard inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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

    self.imageGalleryView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 150.0f) imageURLStringsGroup:self.coach.images];
    self.imageGalleryView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    self.imageGalleryView.backgroundColor = [UIColor clearColor];
    self.imageGalleryView.autoScroll = NO;;
    self.imageGalleryView.delegate = self;
    self.imageGalleryView.placeholderImage = [UIImage imageNamed:@"loading"];
    self.tableView.tableHeaderView = self.imageGalleryView;
    
    
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
    
    if (![self.coach.coachId isEqualToString:[HHUserAuthenticator sharedInstance].currentStudent.myCoachId]) {
        self.payButton = [self createButtonWithTitle:NSLocalizedString(@"确认教练并付款", nil) backgroundColor:[UIColor HHOrange] font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:18.0f] action:@selector(payCoach)];
        
        self.bookTrialButton = [self createButtonWithTitle:NSLocalizedString(@"预约试训", nil) backgroundColor:[UIColor HHLightOrange] font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:18.0f] action:@selector(callCoach)];
        
    } else {
        self.commentButton = [self createButtonWithTitle:NSLocalizedString(@"评价教练", nil) backgroundColor:[UIColor HHOrange] font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:18.0f] action:@selector(commentCoach)];
    }
    
     [self autolayoutSubview];
    
}

- (void)payCoach {
    
}

- (void)callCoach {
    NSString *phoneURLString = [NSString stringWithFormat:@"telprompt://%@", self.coach.phoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    [[UIApplication sharedApplication] openURL:phoneURL];
}

- (void)commentCoach {
    
}

- (void)autolayoutSubview {
    NSArray *constraints = nil;
    
    if (![self.coach.coachId isEqualToString:[HHUserAuthenticator sharedInstance].currentStudent.myCoachId]) {
        constraints = @[
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
                        ];

    } else {
        constraints = @[
                        [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.tableView constant:0],
                        [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.tableView constant:0],
                        [HHAutoLayoutUtility setViewWidth:self.tableView multiplier:1.0f constant:0],
                        [HHAutoLayoutUtility setViewHeight:self.tableView multiplier:1.0f constant:-50.0f],
                        
                        
                        [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.commentButton constant:0],
                        [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.commentButton constant:0],
                        [HHAutoLayoutUtility setViewWidth:self.commentButton multiplier:1.0f constant:0],
                        [HHAutoLayoutUtility setViewHeight:self.commentButton multiplier:0 constant:50.0f],
                        ];

    }
    
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
    [self.view addSubview:button];
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
                HHFullScreenImageViewController *imageViewer = [[HHFullScreenImageViewController alloc] initWithImageURL:[NSURL URLWithString:weakSelf.coach.avatarURL] title:weakSelf.coach.fullName];
                [weakSelf presentViewController:imageViewer animated:YES completion:nil];
            };
            return cell;
        }
        case CoachProfileCellDashBoard: {
            HHCoachDashBoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDashBoardCellId forIndexPath:indexPath];
            [cell setupViewsWithCoach:self.coach trainingFielf:self.field];
            cell.phoneTappedCompletion = ^() {
                [weakSelf.phoneSheet showInView:weakSelf.view];
            };
            
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
                reviewVC.modalPresentationStyle = UIModalPresentationCurrentContext;
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
            return 50.0f + reviewCount * 120.0f;
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

#pragma mark SDCycleScrollViewDelegate Methods

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {    
    HHFullScreenImageViewController *imageVC = [[HHFullScreenImageViewController alloc] initWithImageURL:[NSURL URLWithString:self.coach.images[index]] title:nil];
    [self presentViewController:imageVC animated:YES completion:nil];
}

#pragma mark Hide TabBar

- (BOOL)hidesBottomBarWhenPushed {
    return (self.navigationController.topViewController == self);
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

@end
