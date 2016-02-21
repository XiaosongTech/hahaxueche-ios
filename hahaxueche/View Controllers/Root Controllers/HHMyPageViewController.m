//
//  HHMyPageViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMyPageViewController.h"
#import "ParallaxHeaderView.h"
#import "HHMyPageUserInfoCell.h"
#import "UIColor+HHColor.h"
#import "HHMyPageCoachCell.h"
#import "HHMyPageSupportCell.h"
#import "HHMyPageHelpCell.h"
#import "HHMyPageLogoutCell.h"
#import "HHMyCoachDetailViewController.h"
#import "HHStudentStore.h"
#import "Masonry.h"
#import "HHIntroViewController.h"
#import "HHSocialMediaShareUtility.h"
#import "HHUserAuthService.h"
#import "HHPaymentStatusViewController.h"

static NSString *const kUserInfoCell = @"userInfoCell";
static NSString *const kCoachCell = @"coachCell";
static NSString *const kSupportCell = @"supportCell";
static NSString *const kHelpCell = @"helpCell";
static NSString *const kLogoutCell = @"logoutCell";

typedef NS_ENUM(NSInteger, MyPageCell) {
    MyPageCellUserInfo,
    MyPageCellCoach,
    MyPageCellSupport,
    MyPageCellHelp,
    MyPageCellLogout,
    MyPageCellCount,
};

@interface HHMyPageViewController() <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextView *guestLoginSignupTextView;

@end

@implementation HHMyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的页面";
    self.view.backgroundColor = [UIColor HHBackgroundGary];
    
    [self initSubviews];
}

- (void)initSubviews {
    // Guest
    if (![HHStudentStore sharedInstance].currentStudent.studentId) {
        self.guestLoginSignupTextView = [[UITextView alloc] init];
        self.guestLoginSignupTextView.delegate = self;
        self.guestLoginSignupTextView.editable = NO;
        self.guestLoginSignupTextView.textAlignment = NSTextAlignmentCenter;
        self.guestLoginSignupTextView.attributedText = [self buildGuestString];
        self.guestLoginSignupTextView.tintColor = [UIColor HHOrange];
        self.guestLoginSignupTextView.backgroundColor = [UIColor clearColor];
        [self.guestLoginSignupTextView sizeToFit];
        [self.view addSubview:self.guestLoginSignupTextView];
        
        [self.guestLoginSignupTextView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.centerX);
            make.centerY.equalTo(self.view.centerY);
            make.width.equalTo(self.view).offset(-40.0f);
            make.height.mas_equalTo(50.0f);
        }];
        
    } else {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)- CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds))];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor HHBackgroundGary];
        [self.view addSubview:self.tableView];
        
        [self.tableView registerClass:[HHMyPageUserInfoCell class] forCellReuseIdentifier:kUserInfoCell];
        [self.tableView registerClass:[HHMyPageCoachCell class] forCellReuseIdentifier:kCoachCell];
        [self.tableView registerClass:[HHMyPageSupportCell class] forCellReuseIdentifier:kSupportCell];
        [self.tableView registerClass:[HHMyPageHelpCell class] forCellReuseIdentifier:kHelpCell];
        [self.tableView registerClass:[HHMyPageLogoutCell class] forCellReuseIdentifier:kLogoutCell];
        
        UIImageView *topBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 150.0f)];
        topBackgroundView.backgroundColor = [UIColor blackColor];
        //topBackgroundView.image = [UIImage imageNamed:@"pic_local"];
        
        ParallaxHeaderView *headerView = [ParallaxHeaderView parallaxHeaderViewWithImage:[UIImage imageNamed:@"pic_local"] forSize:CGSizeMake(CGRectGetWidth(self.view.bounds), 150.0f)];
        [self.tableView setTableHeaderView:headerView];
        [self.tableView sendSubviewToBack:self.tableView.tableHeaderView];
    }
    
}

#pragma mark - TableView Delegate & Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MyPageCellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak HHMyPageViewController *weakSelf = self;
    switch (indexPath.row) {
        case MyPageCellUserInfo: {
            HHMyPageUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoCell];
            cell.paymentViewActionBlock = ^(){
                HHPaymentStatusViewController *vc = [[HHPaymentStatusViewController alloc] initWithPurchasedService:nil];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            [cell setupCellWithStudent:[HHStudentStore sharedInstance].currentStudent];
            return cell;
            
        } break;
            
        case MyPageCellCoach: {
            HHMyPageCoachCell *cell = [tableView dequeueReusableCellWithIdentifier:kCoachCell];
            cell.myCoachView.actionBlock = ^(){
                HHMyCoachDetailViewController *myCoachVC = [[HHMyCoachDetailViewController alloc] initWithCoachId:nil];
                myCoachVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:myCoachVC animated:YES];
            };
            cell.followedCoachView.actionBlock = ^(){
                
            };
            [cell setupCellWithCoach:nil coachList:nil];
            return cell;
        } break;
            
        case MyPageCellSupport: {
            HHMyPageSupportCell *cell = [tableView dequeueReusableCellWithIdentifier:kSupportCell];
            cell.supportQQView.actionBlock = ^() {
                [HHSocialMediaShareUtility talkToSupportThroughQQ];
            };
            cell.supportNumberView.actionBlock = ^() {
                NSString *phNo = @"4000016006";
                NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
                if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
                    [[UIApplication sharedApplication] openURL:phoneUrl];
                }
            };
            return cell;
        } break;
            
        case MyPageCellHelp: {
            HHMyPageHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:kHelpCell];
            return cell;
        } break;
          
        case MyPageCellLogout: {
            HHMyPageLogoutCell *cell = [tableView dequeueReusableCellWithIdentifier:kLogoutCell];
            [cell.button addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        } break;
            
        default: {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            return cell;
        } break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case MyPageCellUserInfo:
            return 150.0f;
            
        case MyPageCellCoach:
            return kTopPadding + kTitleViewHeight + kItemViewHeight * 2.0f;
            
        case MyPageCellSupport:
            return kTopPadding + kTitleViewHeight + kItemViewHeight * 2.0f;
            
        case MyPageCellHelp:
            return kTopPadding + kTitleViewHeight + kItemViewHeight * 2.0f;
            
        case MyPageCellLogout:
            return 50 + kTopPadding * 2.0f;
            
        default:
            return 50;
    }
    
}


#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.tableView]) {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:self.tableView.contentOffset];
    }
}

#pragma mark - Others

- (NSMutableAttributedString *)buildGuestString {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"您还没有登陆, 请先" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:@"登陆或注册" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName:[UIColor HHOrange], NSParagraphStyleAttributeName:paragraphStyle, NSLinkAttributeName:@"fakeString"}];
    
    [attributedString appendAttributedString:attributedString2];
    
    return attributedString;
}

- (void)logout {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您确认要退出？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[HHUserAuthService sharedInstance] logOutWithCompletion:^(NSError *error) {
            if (!error) {
                HHIntroViewController *introVC = [[HHIntroViewController alloc] init];
                UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:introVC];
                [self presentViewController:navVC animated:YES completion:nil];
            }
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消返回" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark UITextView Delegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([URL.absoluteString isEqualToString:@"fakeString"]) {
        HHIntroViewController *introVC = [[HHIntroViewController alloc] init];
        introVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:introVC animated:YES];
    }
    return NO;
}

@end
