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
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "HHCoachDesTableViewCell.h"
#import "HHCoachDashBoardTableViewCell.h"
#import "HHUserAuthenticator.h"
#import "HHToastUtility.h"
#import "HHCoachService.h"
#import "HHScheduleTableViewCell.h"

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

@interface HHCoachProfileViewController ()<UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *imageGalleryView;
@property (nonatomic)         CGFloat desCellHeight;
@property (nonatomic, strong) UIActionSheet *phoneSheet;
@property (nonatomic, strong) UIActionSheet *addressSheet;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) UIButton *bookTrialButton;
@property (nonatomic, strong) NSMutableAttributedString *coachDes;

@end

@implementation HHCoachProfileViewController

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
    }
    return self;
}

- (void)setField:(HHTrainingField *)field {
    _field = field;
    [self.tableView reloadData];
}

- (void)backButtonPressed {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
                                         otherButtonTitles:NSLocalizedString(@"复制地址", nil), NSLocalizedString(@"查看地图", nil), nil];
    
    if (![self.coach.coachId isEqualToString:[HHUserAuthenticator sharedInstance].currentStudent.myCoachId]) {
        self.payButton = [self createButtonWithTitle:NSLocalizedString(@"确认教练并付款", nil) backgroundColor:[UIColor HHOrange] font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:18.0f]];
        self.bookTrialButton = [self createButtonWithTitle:NSLocalizedString(@"预约试训", nil) backgroundColor:[UIColor HHLightOrange] font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:18.0f]];
    }
    
     [self autolayoutSubview];
    
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
                        ];

    }
    
    [self.view addConstraints:constraints];
    
}

- (UIButton *)createButtonWithTitle:(NSString *)title backgroundColor:(UIColor *)bgColor font:(UIFont *)font {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setBackgroundColor:bgColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    return button;
}


#pragma mark Tableview Delagate & Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case CoachProfileCellDes:{
            HHCoachDesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDesCellId forIndexPath:indexPath];
            [cell setupViewWithURL:self.coach.avatarURL name:self.coach.fullName des:self.coachDes];
            return cell;
        }
        case CoachProfileCellDashBoard: {
            HHCoachDashBoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDashBoardCellId forIndexPath:indexPath];
            [cell setupViewsWithCoach:self.coach trainingFielf:self.field];
            cell.phoneTappedCompletion = ^() {
                [self.phoneSheet showInView:self.view];
            };
            
            cell.addressTappedCompletion = ^() {
                [self.addressSheet showInView:self.view];
            };
            return cell;
        }
        case CoachProfileCellCalendar: {
            HHScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kScheduleCellId forIndexPath:indexPath];
            [cell.scheduleView setupViewsWithSchedules:nil];
            return cell;
        }
        case CoachProfileCellReview: {
            
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
            return 250.0f;
        }
        case CoachProfileCellReview: {
            
        }
            
        default: {
            return 44.0f;
        }
            
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case CoachProfileCellDes:{
        
        }
            break;
        case CoachProfileCellDashBoard: {
            
        }
            break;
        case CoachProfileCellCalendar: {
            
        }
            break;
        case CoachProfileCellReview: {
            
        }
            break;
            
        default: {
        }
            break;
            
    }
}

#pragma mark SDCycleScrollViewDelegate Methods

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.imageURL = [NSURL URLWithString:self.coach.images[index]];
    imageInfo.referenceRect = self.imageGalleryView.frame;
    imageInfo.referenceView = self.imageGalleryView;
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
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
        if (buttonIndex == 0) {
            UIPasteboard *pb = [UIPasteboard generalPasteboard];
            NSString *fullAddress = [NSString stringWithFormat:@"%@%@%@%@", self.field.province, self.field.city, self.field.district, self.field.address];
            [pb setString:fullAddress];
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"复制成功！",nil) isError:NO];
        } else if (buttonIndex == 1) {
            
        }
    }
}

@end
