//
//  HHPersonalCoachDetailViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 20/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPersonalCoachDetailViewController.h"
#import "SDCycleScrollView.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "ParallaxHeaderView.h"
#import "HHCoachDetailDescriptionCell.h"
#import "HHCoachPriceCell.h"
#import "HHImageGalleryViewController.h"
#import "HHStudentStore.h"
#import "HHGenericTwoButtonsPopupView.h"
#import "HHIntroViewController.h"
#import "UIColor+HHColor.h"
#import "HHPopupUtility.h"
#import "HHStudentService.h"
#import "HHSupportUtility.h"
#import "Masonry.h"
#import <pop/POP.h>
#import "HHShareView.h"
#import "HHSocialMediaShareUtility.h"
#import "HHCoachService.h"

typedef NS_ENUM(NSInteger, CoachCell) {
    CoachCellDescription,
    CoachCellPrice,
    CoachCellCount,
};

static NSString *const kDescriptionCellID = @"kDescriptionCellID";
static NSString *const kPriceCellID = @"kPriceCellID";

@interface HHPersonalCoachDetailViewController () <UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *callButton;
@property (nonatomic, strong) SDCycleScrollView *coachImagesView;
@property (nonatomic, strong) HHPersonalCoach *coach;
@property (nonatomic, strong) NSString *coachId;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic) BOOL liking;


@end

@implementation HHPersonalCoachDetailViewController

- (instancetype)initWithCoach:(HHPersonalCoach *)coach {
    self = [super init];
    if (self) {
        self.coach = coach;
    }
    return self;
}

- (instancetype)initWithCoachId:(NSString *)coachId {
    self = [super init];
    if (self) {
        self.coachId = coachId;
        [[HHCoachService sharedInstance] fetchPersoanlCoachWithId:self.coachId completion:^(HHPersonalCoach *coach, NSError *error) {
            if (!error) {
                self.coach = coach;
                self.coachImagesView.imageURLStringsGroup = coach.images;
            }
        }];
    }

    return self;
}

- (void)setCoach:(HHPersonalCoach *)coach {
    _coach = coach;
    [self.tableView reloadData];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"教练详情";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(popupVC) target:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"icon_share"] action:@selector(shareCoach) target:self];
    [self initSubviews];
}

- (void)initSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-50.0f - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds))];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.coachImagesView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds) * 4.0f/5.0f)];
    self.coachImagesView.delegate = self;
    self.coachImagesView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.coachImagesView.imageURLStringsGroup = self.coach.images;
    self.coachImagesView.pageDotColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    self.coachImagesView.currentPageDotColor = [UIColor whiteColor];
    self.coachImagesView.autoScroll = NO;
    
    ParallaxHeaderView *headerView = [ParallaxHeaderView parallaxHeaderViewWithSubView:self.coachImagesView];
    [self.tableView setTableHeaderView:headerView];
    [self.tableView sendSubviewToBack:self.tableView.tableHeaderView];
    
    [self.tableView registerClass:[HHCoachDetailDescriptionCell class] forCellReuseIdentifier:kDescriptionCellID];
    [self.tableView registerClass:[HHCoachPriceCell class] forCellReuseIdentifier:kPriceCellID];
    
    self.callButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.callButton setTitle:@"联系教练" forState:UIControlStateNormal];
    self.callButton.backgroundColor = [UIColor HHDarkOrange];
    [self.callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.callButton addTarget:self action:@selector(callSupport) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.callButton];
    [self.callButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.bottom.equalTo(self.view.bottom);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(50.0f);
    }];
}

- (void)popupVC {
    if ([self.navigationController.viewControllers count] == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }}

#pragma mark - TableView Delegate & Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return CoachCellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak HHPersonalCoachDetailViewController *weakSelf = self;
    switch (indexPath.row) {
        case CoachCellDescription: {
            HHCoachDetailDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:kDescriptionCellID forIndexPath:indexPath];
            cell.likeBlock = ^(UIButton *likeButton, UILabel *likeCountLabel) {
                if ([HHStudentStore sharedInstance].currentStudent.studentId) {
                    [weakSelf likeOrUnlikeCoachWithButton:likeButton label:likeCountLabel];
                } else {
                    [weakSelf showIntroPopup];
                }
                
            };
            [cell setupCellWithCoach:self.coach];
            return cell;
        }
            
        case CoachCellPrice: {
            HHCoachPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:kPriceCellID forIndexPath:indexPath];
           [cell setupCellWithPersonalCoach:self.coach];
            return cell;
        }
        
        default: {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case CoachCellDescription: {
            return CGRectGetHeight([self getDescriptionTextSizeWithText:[self.coach getCoachDes]]) + 55.0f;
        }
            
        case CoachCellPrice: {
            return 85 + self.coach.prices.count * 70.0f;
        }
        default: {
            return 0;
        }
    }
    
}

#pragma mark SDCycleScrollViewDelegate Method

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    HHImageGalleryViewController *galleryVC = [[HHImageGalleryViewController alloc] initWithURLs:self.coach.images currentIndex:index];
    [self presentViewController:galleryVC animated:YES completion:nil];
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

- (CGRect)getDescriptionTextSizeWithText:(NSString *)text {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds)-40.0f, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                                     context:nil];
    return rect;
}

- (void)showIntroPopup {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineSpacing = 8.0f;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"您只有注册登录后\n才可以点赞教练哦~" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:paragraphStyle}];
    HHGenericTwoButtonsPopupView *view = [[HHGenericTwoButtonsPopupView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 20.0f, 260.0f) title:@"请登录" subTitle:nil info:attributedString leftButtonTitle:@"知道了" rightButtonTitle:@"去登录"];
    self.popup = [HHPopupUtility createPopupWithContentView:view];
    view.confirmBlock = ^() {
        HHIntroViewController *vc = [[HHIntroViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    };
    view.cancelBlock = ^() {
        [HHPopupUtility dismissPopup:self.popup];
    };
    [HHPopupUtility showPopup:self.popup];
}


- (void)likeOrUnlikeCoachWithButton:(UIButton *)button label:(UILabel *)label {
    if (self.liking) {
        return;
    }
    self.liking = YES;
    NSNumber *like;
    if ([self.coach.liked boolValue]) {
        like = @(0);
    } else {
        like = @(1);
    }
    
    [[HHStudentService sharedInstance] likeOrUnlikePersonalCoachWithId:self.coach.coachId like:like completion:^(HHPersonalCoach *coach, NSError *error) {
        self.liking = NO;
        if (!error) {
            self.coach = coach;
            if (self.coachUpdateBlock) {
                self.coachUpdateBlock(self.coach);
            }
            if ([coach.liked boolValue]) {
                POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
                sprintAnimation.animationDidStartBlock = ^(POPAnimation *anim) {
                    [button setImage:[UIImage imageNamed:@"ic_list_best_click"] forState:UIControlStateNormal];
                };
                sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(10, 10)];
                sprintAnimation.springBounciness = 20.f;
                [button pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
            } else {
                [button setImage:[UIImage imageNamed:@"ic_list_best_unclick"] forState:UIControlStateNormal];
            }
            label.text = [coach.likeCount stringValue];
            
        }
    }];
    
}

- (void)callSupport {
    [[HHSupportUtility sharedManager] callSupport];
}

- (void)shareCoach {
    HHShareView *shareView = [[HHShareView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 0)];
    
    shareView.dismissBlock = ^() {
        [HHPopupUtility dismissPopup:self.popup];
    };
    shareView.actionBlock = ^(SocialMedia selecteItem) {
        switch (selecteItem) {
            case SocialMediaQQFriend: {
                [[HHSocialMediaShareUtility sharedInstance] sharePersonalCoach:self.coach shareType:ShareTypeQQ];
            } break;
                
            case SocialMediaWeibo: {
                [[HHSocialMediaShareUtility sharedInstance] sharePersonalCoach:self.coach shareType:ShareTypeWeibo];
            } break;
                
            case SocialMediaWeChatFriend: {
                [[HHSocialMediaShareUtility sharedInstance] sharePersonalCoach:self.coach shareType:ShareTypeWeChat];
            } break;
                
            case SocialMediaWeChaPYQ: {
                [[HHSocialMediaShareUtility sharedInstance] sharePersonalCoach:self.coach shareType:ShareTypeWeChatTimeLine];
            } break;
                
            case SocialMediaQZone: {
                [[HHSocialMediaShareUtility sharedInstance] sharePersonalCoach:self.coach shareType:ShareTypeQZone];
            } break;
                
            default:
                break;
                
        }
    };
    self.popup = [HHPopupUtility createPopupWithContentView:shareView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom];
    [HHPopupUtility showPopup:self.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
}



@end
