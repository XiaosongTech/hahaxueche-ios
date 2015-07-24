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

typedef enum : NSUInteger {
    CoachProfileCellDes,
    CoachProfileCellDashBoard,
    CoachProfileCellCalendar,
    CoachProfileCellReview,
    CoachProfileCellTotal
} CoachProfileCell;

#define kDesCellId @"kDesCellId"
#define kDashBoardCellId @"kDashBoardCellId"

@interface HHCoachProfileViewController ()<UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *imageGalleryView;
@property (nonatomic)         CGFloat desCellHeight;
@property (nonatomic, strong) UIActionSheet *phoneSheet;
@property (nonatomic, strong) UIActionSheet *addressSheet;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) UIButton *bookTrialButton;

@end

@implementation HHCoachProfileViewController

- (instancetype)initWithCoach:(HHCoach *)coach {
    self = [super init];
    if (self) {
        self.coach = coach;
        self.coach.des = @"欧文（克里斯·帕拉特 Chris Pratt 饰）是一名退役军人以及动物行为专家，在主园区的外围的迅猛龙研究基地进行隐密的工作。欧文多年来训练了一批具侵略性的迅猛龙，和它们建立起主从关系，勉勉强强让它们得以压抑住掠食者的天性、不情愿的听从指示。久而久之。建立起主从关系建立起主从关系建立起主从关系建立起主从关系";
        self.title = self.coach.fullName;
        self.view.backgroundColor = [UIColor HHLightGrayBackgroundColor];
        UIBarButtonItem *backButton = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"left_arrow"] action:@selector(backButtonPressed) target:self];
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -8.0f;//
        [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
        
        self.desCellHeight = CGRectGetHeight([self.coach.des boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds)-40.0f, 99999.0)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{
                                                                 NSFontAttributeName: [UIFont fontWithName:@"SourceHanSansSC-Normal" size:13.0f],
                                                                 }
                                                       context:nil]) + 60.0f;
    }
    return self;
}

- (void)backButtonPressed {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
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
    

    self.imageGalleryView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 150.0f) imageURLStringsGroup:self.coach.images];
    self.imageGalleryView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    self.imageGalleryView.backgroundColor = [UIColor clearColor];
    self.imageGalleryView.autoScroll = NO;;
    self.imageGalleryView.delegate = self;
    self.imageGalleryView.placeholderImage = [UIImage imageNamed:@"loading"];
    self.tableView.tableHeaderView = self.imageGalleryView;
    
    
    self.phoneSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"复制手机号", @"拨打号码", nil];
    
    self.addressSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"复制地址", @"查看地图", nil];
    
    if (![self.coach.coachId isEqualToString:[HHUserAuthenticator sharedInstance].currentStudent.myCoachId]) {
        self.payButton = [self createButtonWithTitle:@"确认教练并付款" backgroundColor:[UIColor HHOrange] font:[UIFont fontWithName:@"SourceHanSansSC-Medium" size:18.0f]];
        self.bookTrialButton = [self createButtonWithTitle:@"预约试训" backgroundColor:[UIColor HHLightOrange] font:[UIFont fontWithName:@"SourceHanSansSC-Medium" size:18.0f]];
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case CoachProfileCellDes:{
            HHCoachDesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDesCellId forIndexPath:indexPath];
            [cell setupViewWithURL:self.coach.avatarURL name:self.coach.fullName des:self.coach.des];
            return cell;
        }
        case CoachProfileCellDashBoard: {
            HHCoachDashBoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDashBoardCellId forIndexPath:indexPath];
            [cell setupViewsWithCoach:self.coach];
            cell.phoneTappedCompletion = ^() {
                [self.phoneSheet showInView:self.view];
            };
            
            cell.addressTappedCompletion = ^() {
                [self.addressSheet showInView:self.view];
            };
            return cell;
        }
        case CoachProfileCellCalendar: {
            
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
            return 260.0f;
        }
        case CoachProfileCellCalendar: {
            
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
            [HHToastUtility showToastWitiTitle:@"复制成功！" isError:NO];
        } else if (buttonIndex == 1) {
            NSString *callString =[ NSString stringWithFormat:@"telprompt://%@", self.coach.phoneNumber];
            NSURL *url = [NSURL URLWithString:callString];
            [[UIApplication sharedApplication] openURL:url];
        }
    } else if ([actionSheet isEqual:self.addressSheet]) {
        if (buttonIndex == 0) {
            UIPasteboard *pb = [UIPasteboard generalPasteboard];
            [pb setString:self.coach.fullAddress];
            [HHToastUtility showToastWitiTitle:@"复制成功！" isError:NO];
        } else if (buttonIndex == 1) {
            
        }
    }
}

@end
