//
//  HHCoachDetailViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachDetailViewController.h"
#import "UIColor+HHColor.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "ParallaxHeaderView.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHCoachDetailDescriptionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HHCoachDetailSectionTwoCell.h"
#import "HHCoachDetailBottomBarView.h"
#import "HHCoachDetailCommentsCell.h"
#import <KLCPopup.h>
#import "HHTryCoachView.h"
#import "HHPopupUtility.h"
#import "HHShareView.h"
#import "HHPriceDetailView.h"
#import "HHSocialMediaShareUtility.h"
#import "HHSingleFieldMapViewController.h"
#import "HHConstantsStore.h"
#import "HHStudentService.h"
#import "HHStudentStore.h"
#import "HHIntroViewController.h"
#import "HHToastManager.h"
#import "HHFormatUtility.h"
#import "HHCoachService.h"
#import "HHReviews.h"
#import "HHReview.h"
#import "HHReviewListViewController.h"
#import "HHEventTrackingManager.h"
#import "HHImageGalleryViewController.h"
#import "HHLoadingViewUtility.h"
#import "HHPurchaseConfirmViewController.h"
#import "HHCoachPriceCell.h"
#import "HHCoachServiceTypeCell.h"
#import "HHCoachFieldCell.h"
#import <pop/POP.h>
#import "HHGenericTwoButtonsPopupView.h"
#import "HHWebViewController.h"

typedef NS_ENUM(NSInteger, CoachCell) {
    CoachCellDescription,
    CoachCellPrice,
    CoachCellType,
    CoachCellField,
    CoachCellInfoTwo,
    CoachCellComments,
    CoachCellCount,
};

static NSString *const kDescriptionCellID = @"kDescriptionCellID";
static NSString *const kPriceCellID = @"kPriceCellID";
static NSString *const kTypeCellID = @"kTypeCellID";
static NSString *const kFiledCellID = @"kFiledCellID";
static NSString *const kInfoTwoCellID = @"kInfoTwoCellID";
static NSString *const kCommentsCellID = @"kCommentsCellID";

@interface HHCoachDetailViewController () <UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *coachImagesView;
@property (nonatomic, strong) HHCoach *coach;
@property (nonatomic, strong) NSString *coachId;
@property (nonatomic, strong) HHCoachDetailBottomBarView *bottomBar;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) HHStudent *currentStudent;
@property (nonatomic, strong) HHReviews *reviewsObject;
@property (nonatomic, strong) NSArray *reviews;
@property (nonatomic) BOOL liking;

@end

@implementation HHCoachDetailViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCoach:(HHCoach *)coach {
    self = [super init];
    if (self) {
        self.coach = coach;
        self.currentStudent = [HHStudentStore sharedInstance].currentStudent;
    }
    return self;
}

- (instancetype)initWithCoachId:(NSString *)coachId {
    self = [super init];
    if (self) {
        self.coachId = coachId;
        self.currentStudent = [HHStudentStore sharedInstance].currentStudent;
        [[HHCoachService sharedInstance] fetchCoachWithId:self.coachId completion:^(HHCoach *coach, NSError *error) {
            if (!error) {
                self.coach = coach;
            }
        }];
    }
    return self;
}

- (void)setCoach:(HHCoach *)coach {
    _coach = coach;
    [[HHCoachService sharedInstance] fetchReviewsWithUserId:self.coach.userId completion:^(HHReviews *reviews, NSError *error) {
        if (!error) {
            self.reviewsObject = reviews;
            self.reviews = reviews.reviews;
            self.coachImagesView.imageURLStringsGroup = coach.images;
            [self.tableView reloadData];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"教练详情";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(popupVC) target:self];
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
    
    [self.tableView registerClass:[HHCoachDetailDescriptionCell class] forCellReuseIdentifier:kDescriptionCellID];
    [self.tableView registerClass:[HHCoachPriceCell class] forCellReuseIdentifier:kPriceCellID];
    [self.tableView registerClass:[HHCoachServiceTypeCell class] forCellReuseIdentifier:kTypeCellID];
    [self.tableView registerClass:[HHCoachFieldCell class] forCellReuseIdentifier:kFiledCellID];
    [self.tableView registerClass:[HHCoachDetailSectionTwoCell class] forCellReuseIdentifier:kInfoTwoCellID];
    [self.tableView registerClass:[HHCoachDetailCommentsCell class] forCellReuseIdentifier:kCommentsCellID];
    
    ParallaxHeaderView *headerView = [ParallaxHeaderView parallaxHeaderViewWithSubView:self.coachImagesView];
    [self.tableView setTableHeaderView:headerView];
    [self.tableView sendSubviewToBack:self.tableView.tableHeaderView];

    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.bottomBar = [[HHCoachDetailBottomBarView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.tableView.bounds), CGRectGetWidth(self.view.bounds), 50.0f) followed:NO];
    [self.view addSubview:self.bottomBar];
    
    
    __weak HHCoachDetailViewController *weakSelf = self;
    self.bottomBar.shareAction = ^(){
        HHShareView *shareView = [[HHShareView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(weakSelf.view.bounds), 0)];
        
        shareView.dismissBlock = ^() {
            [HHPopupUtility dismissPopup:weakSelf.popup];
        };
        shareView.actionBlock = ^(SocialMedia selecteItem) {
            switch (selecteItem) {
                case SocialMediaQQFriend: {
                    [[HHSocialMediaShareUtility sharedInstance] shareCoach:weakSelf.coach shareType:ShareTypeQQ];
                } break;
                    
                case SocialMediaWeibo: {
                    [[HHSocialMediaShareUtility sharedInstance] shareCoach:weakSelf.coach shareType:ShareTypeWeibo];
                } break;
                    
                case SocialMediaWeChatFriend: {
                    [[HHSocialMediaShareUtility sharedInstance] shareCoach:weakSelf.coach shareType:ShareTypeWeChat];
                } break;
                    
                case SocialMediaWeChaPYQ: {
                    [[HHSocialMediaShareUtility sharedInstance] shareCoach:weakSelf.coach shareType:ShareTypeWeChatTimeLine];
                } break;
                    
                default:
                    break;

            }
        };
        weakSelf.popup = [HHPopupUtility createPopupWithContentView:shareView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom];
        [HHPopupUtility showPopup:weakSelf.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
    };
    
    self.bottomBar.followAction = ^(){
        if (!weakSelf.currentStudent.studentId) {
            [weakSelf showLoginSignupAlertView];
            return ;
        }
        
        [[HHCoachService sharedInstance] followCoach:weakSelf.coach.userId completion:^(NSError *error) {
            if (!error) {
                weakSelf.bottomBar.followed = YES;
            }
            
        }];
    };
    
    self.bottomBar.unFollowAction = ^(){
        if (!weakSelf.currentStudent.studentId) {
            [weakSelf showLoginSignupAlertView];
            return ;
        }
        
        [[HHCoachService sharedInstance] unfollowCoach:weakSelf.coach.userId completion:^(NSError *error) {
            if (!error) {
                weakSelf.bottomBar.followed = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kUnfollowCoach" object:@{@"coachId":weakSelf.coach.coachId}];
            }
        }];
    };
    
    self.bottomBar.tryCoachAction = ^(){
        [weakSelf tryCoachForFree];
    };
    
    self.bottomBar.purchaseCoachAction = ^(){
        if (!weakSelf.currentStudent.studentId) {
            [weakSelf showLoginSignupAlertView];
            return ;
        }
        HHPurchaseConfirmViewController *vc = [[HHPurchaseConfirmViewController alloc] initWithCoach:weakSelf.coach];
        [weakSelf.navigationController pushViewController:vc animated:YES];

    };
    
    [[HHCoachService sharedInstance] checkFollowedCoach:self.coach.userId completion:^(BOOL followed) {
        weakSelf.bottomBar.followed = followed;
    }];
    
}

#pragma mark - TableView Delegate & Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return CoachCellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak HHCoachDetailViewController *weakSelf = self;
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
            cell.standartPriceItemView.priceDetailBlock = ^() {
                HHCity *city = [[HHConstantsStore sharedInstance] getAuthedUserCity];
                CGFloat height = 190.0f + (city.cityFixedFees.count + 1) * 50.0f;
                HHPriceDetailView *priceView = [[HHPriceDetailView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(weakSelf.view.bounds)-20.0f, height) title:@"价格明细" totalPrice:weakSelf.coach.price showOKButton:YES];
                priceView.cancelBlock = ^() {
                    [HHPopupUtility dismissPopup:weakSelf.popup];
                };
                weakSelf.popup = [HHPopupUtility createPopupWithContentView:priceView];
                [HHPopupUtility showPopup:weakSelf.popup];


            };
            if ([self.coach.VIPPrice floatValue] > 0) {
                cell.VIPPriceItemView.priceDetailBlock = ^() {
                    HHCity *city = [[HHConstantsStore sharedInstance] getAuthedUserCity];
                    CGFloat height = 190.0f + (city.cityFixedFees.count + 1) * 50.0f;
                    HHPriceDetailView *priceView = [[HHPriceDetailView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(weakSelf.view.bounds)-20.0f, height) title:@"价格明细" totalPrice:weakSelf.coach.VIPPrice showOKButton:YES];
                    priceView.cancelBlock = ^() {
                        [HHPopupUtility dismissPopup:weakSelf.popup];
                    };
                    weakSelf.popup = [HHPopupUtility createPopupWithContentView:priceView];
                    [HHPopupUtility showPopup:weakSelf.popup];
                };
            }
            [cell setupCellWithCoach:self.coach];
            return cell;
        }
            
        case CoachCellType: {
            HHCoachServiceTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:kTypeCellID forIndexPath:indexPath];
            [cell setupCellWithCoach:self.coach];
            return cell;
        }
            
        case CoachCellField: {
            HHCoachFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:kFiledCellID forIndexPath:indexPath];
            cell.fieldBlock = ^() {
                HHSingleFieldMapViewController *vc = [[HHSingleFieldMapViewController alloc] initWithField:[weakSelf.coach getCoachField]];
                [weakSelf.navigationController pushViewController:vc animated:YES];

            };
            [cell setupCellWithField:[self.coach getCoachField]];
            return cell;
        }
            
        case CoachCellInfoTwo: {
            HHCoachDetailSectionTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:kInfoTwoCellID forIndexPath:indexPath];
            [cell setupWithCoach:self.coach];
            cell.coachesListCell.peerCoachTappedAction = ^(NSInteger index) {
                HHCoach *coach = self.coach.peerCoaches[index];
                HHCoachDetailViewController *detailVC = [[HHCoachDetailViewController alloc] initWithCoachId:coach.coachId];
                detailVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:detailVC animated:YES];
            };
            return cell;
        }
            
        case CoachCellComments: {
            HHCoachDetailCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentsCellID forIndexPath:indexPath];
            [cell setupCellWithCoach:self.coach reviews:self.reviews];
            cell.tapBlock = ^() {
                HHReviewListViewController *vc = [[HHReviewListViewController alloc] initWithReviews:weakSelf.reviewsObject coach:weakSelf.coach];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
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
            return CGRectGetHeight([self getDescriptionTextSizeWithText:self.coach.bio]) + 55.0f;
        }
            
        case CoachCellPrice: {
            if ([self.coach.VIPPrice floatValue] > 0) {
                return 156.0f + 70.0f;
            } else {
                return 156.0f;
            }
            
        }
           
        case CoachCellType: {
            return 70.0f;
        }
            
        case CoachCellField: {
            return 141.0f;
        }
            
            
        case CoachCellInfoTwo: {
            CGFloat height = 195.0f;
            if ([self.coach.peerCoaches count]) {
                height = height + 70.0f * self.coach.peerCoaches.count + 36.0f;
            }
            return height ;
        }
            
        case CoachCellComments: {
            CGFloat height = 130.0f;
            if (self.reviews.count >= 3) {
                return height + 90 * 3;
            } else if (self.reviews.count < 3 && self.reviews.count > 0){
                return height + 90 * self.reviews.count;
            } else {
                return height;
            }
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

#pragma mark - Button Actions

- (void)popupVC {
    if ([self.navigationController.viewControllers count] == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
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

- (void)showLoginSignupAlertView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请先登陆或者注册" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"现在就去" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        HHIntroViewController *introVC = [[HHIntroViewController alloc] init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:introVC];
        [self presentViewController:navVC animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
        [self presentViewController:vc animated:YES completion:nil];
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
    
    [[HHStudentService sharedInstance] likeOrUnlikeCoachWithId:self.coach.coachId like:like completion:^(HHCoach *coach, NSError *error) {
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

- (void)openWebPage:(NSURL *)url {
    HHWebViewController *webVC = [[HHWebViewController alloc] initWithURL:url];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    
}

- (void)tryCoachForFree {
    NSString *urlBase = @"http://m.hahaxueche.com/free_trial";
    HHStudent *student = [HHStudentStore sharedInstance].currentStudent;
    NSString *paramString;
    if(student.studentId) {
        paramString = [NSString stringWithFormat:@"?coach_id=%@&name=%@&phone=%@&city_id=%@", self.coach.coachId, student.name, student.cellPhone, [student.cityId stringValue]];
    } else {
        paramString = [NSString stringWithFormat:@"?coach_id=%@", self.coach.coachId];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", urlBase, paramString];
    [self openWebPage:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
}

@end
