//
//  HHClubPostDetailViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHClubPostDetailViewController.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "HHClubPostStatView.h"
#import "HHPopupUtility.h"
#import "HHShareView.h"
#import "HHCommentView.h"
#import "HHClubPostCommentsViewController.h"
#import "HHWebViewController.h"
#import "HHStudentStore.h"
#import "HHClubPostService.h"
#import "HHGenericTwoButtonsPopupView.h"
#import "HHIntroViewController.h"
#import "HHClubPostService.h"
#import "HHLoadingViewUtility.h"
#import "HHToastManager.h"

@interface HHClubPostDetailViewController () <UIWebViewDelegate>

@property (nonatomic, strong) HHClubPost *clubPost;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *botToolBar;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) HHClubPostStatView *statView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) HHCommentView *commentView;

@end

@implementation HHClubPostDetailViewController

- (instancetype)initWithClubPost:(HHClubPost *)clubPost {
    self = [super init];
    if (self) {
        self.clubPost = clubPost;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"icon_share"] action:@selector(sharePost) target:self];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initSubviews];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:article_detail_page_viewed attributes:nil];
}

- (void)initSubviews {
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    [self buildBotToolBarView];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height).offset(-50.0f);
        make.left.equalTo(self.view.left);
    }];
    
    [self.botToolBar makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(50.0f);
        make.left.equalTo(self.view.left);
    }];
    
    [self.commentButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botToolBar.centerY);
        make.width.equalTo(self.botToolBar.width).multipliedBy(1.0f/2.0f);
        make.height.mas_equalTo(30.0f);
        make.left.equalTo(self.botToolBar.left).offset(15.0f);

    }];
    
    [self.statView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botToolBar.centerY);
        make.right.equalTo(self.botToolBar.right);
        make.height.equalTo(self.botToolBar.height);
        make.left.equalTo(self.commentButton.right);
        
    }];
}


- (void)buildBotToolBarView {
    __weak HHClubPostDetailViewController *weakSelf = self;
    
    self.botToolBar = [[UIView alloc] init];
    self.botToolBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.botToolBar];
    
    self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    self.commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.commentButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);;
    [self.commentButton setTitle:@"发表伟大言论..." forState:UIControlStateNormal];
    [self.commentButton setTitleColor:[UIColor HHLightestTextGray] forState:UIControlStateNormal];
    self.commentButton.backgroundColor = [UIColor HHLightBackgroudGray];
    self.commentButton.layer.masksToBounds = YES;
    self.commentButton.layer.cornerRadius = 15.0f;
    [self.commentButton addTarget:self action:@selector(showCommentTextView) forControlEvents:UIControlEventTouchUpInside];
    [self.botToolBar addSubview:self.commentButton];
    
    self.statView = [[HHClubPostStatView alloc] initWithInteraction:YES];
    self.statView.likeAction = ^() {
        NSNumber *like = @(1);
        if ([weakSelf.clubPost.liked boolValue]) {
            like = @(0);
        }
        if ([HHStudentStore sharedInstance].currentStudent.studentId) {
            [[HHClubPostService sharedInstance] likeOrUnlikePostWithId:weakSelf.clubPost.postId like:like completion:^(HHClubPost *post, NSError *error) {
                if (!error) {
                    weakSelf.clubPost = post;
                    [weakSelf.statView setupViewWithClubPost:weakSelf.clubPost];
                } 
            }];
        } else {
            [weakSelf showLoginPopupForLike];
        }
    };
    
    self.statView.commentAction = ^() {
        HHClubPostCommentsViewController *vc = [[HHClubPostCommentsViewController alloc] initWithPost:weakSelf.clubPost];
        vc.updateBlock = ^(HHClubPost *post) {
            [weakSelf.statView setupViewWithClubPost:post];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [self.statView setupViewWithClubPost:self.clubPost];
    [self.botToolBar addSubview:self.statView];

}

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sharePost {
    __weak HHClubPostDetailViewController *weakSelf = self;
    HHShareView *shareView = [[HHShareView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 0)];
    shareView.dismissBlock = ^() {
        [HHPopupUtility dismissPopup:weakSelf.popup];
    };
    shareView.actionBlock = ^(SocialMedia selecteItem) {
        switch (selecteItem) {
            case SocialMediaQQFriend: {
                
            } break;
                
            case SocialMediaWeibo: {
                ;
            } break;
                
            case SocialMediaWeChatFriend: {
                
            } break;
                
            case SocialMediaWeChaPYQ: {
                
            } break;
                
            case SocialMediaQZone: {
                
            } break;
                
            default:
                break;
        }
    };
    
    self.popup = [HHPopupUtility createPopupWithContentView:shareView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom];
    [HHPopupUtility showPopup:self.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
}

- (void)showCommentTextView {
    __weak HHClubPostDetailViewController *weakSelf = self;
    self.commentView = [[HHCommentView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 158.0f)];
    self.commentView.cancelBlock = ^(){
        [weakSelf.commentView.textView resignFirstResponder];
        [HHPopupUtility dismissPopup:weakSelf.popup];
    };
    
    self.commentView.confirmBlock = ^(NSString *content) {
        [[HHLoadingViewUtility sharedInstance] showLoadingView];
        [[HHClubPostService sharedInstance] commentPostWithId:weakSelf.clubPost.postId content:content completion:^(HHClubPost *post, NSError *error) {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
            if (!error) {
                weakSelf.clubPost = post;
                [weakSelf.statView setupViewWithClubPost:post];
            } else {
                [[HHToastManager sharedManager] showErrorToastWithText:@"评论失败, 请重试"];
            }
            
        }];

        [weakSelf.commentView.textView resignFirstResponder];
        [HHPopupUtility dismissPopup:weakSelf.popup];
    };

    self.popup = [HHPopupUtility createPopupWithContentView:self.commentView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom];
    self.popup.willStartDismissingCompletion = ^() {
        [weakSelf.commentView.textView resignFirstResponder];
    };
    [HHPopupUtility showPopup:self.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    HHWebViewController *vc = [[HHWebViewController alloc] initWithURL:request.URL];
    [self.navigationController pushViewController:vc animated:YES];
    return YES;
    
}

- (void)showLoginPopupForLike {
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



@end
