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
#import "HHWebViewController.h"
#import "HHStudentStore.h"
#import "HHClubPostService.h"
#import "HHGenericTwoButtonsPopupView.h"
#import "HHIntroViewController.h"
#import "HHClubPostService.h"
#import "HHLoadingViewUtility.h"
#import "HHToastManager.h"
#import "HHPostCommentView.h"
#import "HHSocialMediaShareUtility.h"

@interface HHClubPostDetailViewController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) HHClubPost *clubPost;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *botToolBar;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) HHClubPostStatView *statView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) HHCommentView *commentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *userCommentsView;
@property (nonatomic, strong) NSMutableArray *userCommentViewArray;
@property (nonatomic) CGFloat webViewHeight;

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
    
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:NULL];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:article_detail_page_viewed attributes:nil];
}

- (void)initSubviews {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor HHBackgroundGary];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.webView = [[WKWebView alloc] init];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.clubPost getPostUrl]]]];
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.scrollView addSubview:self.webView];
    
    [self buildBotToolBarView];
    
    if (self.clubPost.comments.count > 0) {
        self.userCommentsView = [self buildCommentsView];
        [self.scrollView addSubview:self.userCommentsView];
    }
    
    [self makeConstraints];
    
}

- (void)makeConstraints {
    UIView *lastView = self.webView;
    
    [self.scrollView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height).offset(-50.0f);
        make.left.equalTo(self.view.left);
    }];
    
    [self.webView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(self.webViewHeight);
        make.left.equalTo(self.scrollView.left);
    }];
    
    [self.botToolBar remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(50.0f);
        make.left.equalTo(self.view.left);
    }];
    
    [self.commentButton remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botToolBar.centerY);
        make.width.equalTo(self.botToolBar.width).multipliedBy(1.0f/2.0f);
        make.height.mas_equalTo(30.0f);
        make.left.equalTo(self.botToolBar.left).offset(15.0f);

    }];
    
    [self.statView remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botToolBar.centerY);
        make.right.equalTo(self.botToolBar.right);
        make.height.equalTo(self.botToolBar.height);
        make.left.equalTo(self.commentButton.right);
        
    }];
    
    if (self.userCommentsView) {
        [self.userCommentsView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.webView.bottom);
            make.width.equalTo(self.scrollView.width);
            make.left.equalTo(self.scrollView.left);
            CGFloat height = 85.0f;
            for (HHPostCommentView *view in self.userCommentViewArray) {
                height = height + [view getViewHeightWithComment:view.comment];
            }
            make.height.mas_equalTo(height);
        }];
        lastView = self.userCommentsView;
    }
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:lastView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-10.0f]];
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
        if ([[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
            [[HHClubPostService sharedInstance] likeOrUnlikePostWithId:weakSelf.clubPost.postId like:like completion:^(HHClubPost *post, NSError *error) {
                if (!error) {
                    weakSelf.clubPost = post;
                    [weakSelf.statView setupViewWithClubPost:weakSelf.clubPost];
                    if (weakSelf.updateBlock) {
                        weakSelf.updateBlock(post);
                    }
                } 
            }];
        } else {
            [weakSelf showLoginPopupForLike];
        }
    };
    
    self.statView.commentAction = ^() {
        [weakSelf jumpToCommentsVC];
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
        [[HHSocialMediaShareUtility sharedInstance] sharePost:weakSelf.clubPost shareType:selecteItem];
    };
    
    self.popup = [HHPopupUtility createPopupWithContentView:shareView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom];
    [HHPopupUtility showPopup:self.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
}

- (void)showCommentTextView {
    if (![[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
        [self showLoginPopupForComment];
        return;
    }
    
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
                [weakSelf updateView];
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

- (void)showLoginPopupForLike {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineSpacing = 8.0f;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"注册登录后才可以点赞文章哦~\n快去注册支持教练把!" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:paragraphStyle}];
    HHGenericTwoButtonsPopupView *view = [[HHGenericTwoButtonsPopupView alloc] initWithTitle:@"请登录" info:attributedString leftButtonTitle:@"知道了" rightButtonTitle:@"去登录"];
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

- (void)showLoginPopupForComment {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineSpacing = 8.0f;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"注册登录后, 才可以评价文章哦~\n注册获得更多学车咨询!~" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:paragraphStyle}];
    HHGenericTwoButtonsPopupView *view = [[HHGenericTwoButtonsPopupView alloc] initWithTitle:@"请登录" info:attributedString leftButtonTitle:@"知道了" rightButtonTitle:@"去登录"];
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


- (UIView *)buildCommentsView {
    if (self.userCommentsView) {
        [self.userCommentsView removeFromSuperview];
        self.userCommentsView = nil;
        [self.userCommentViewArray removeAllObjects];
    }
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor HHLightLineGray];
    [view addSubview:topLine];
    [topLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(15.0f);
        make.top.equalTo(view.top);
        make.width.equalTo(view.width).offset(-30.0f);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor darkTextColor];
    titleLabel.font = [UIFont systemFontOfSize:22.0f];
    titleLabel.text = @"评论";
    [view addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.centerX);
        make.top.equalTo(view.top).offset(10.0f);
    }];
    
    int i = 0;
    self.userCommentViewArray = [NSMutableArray array];
    for (HHPostComment *comment in self.clubPost.comments) {
        if (i == 3) {
            break;
        }
        HHPostCommentView *commentView = [[HHPostCommentView alloc] init];
        [commentView setupViewWithComment:comment];
        [view addSubview:commentView];
        [self.userCommentViewArray addObject:commentView];
        [commentView makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.equalTo(view.top).offset(35.0f);
            } else {
                HHPostCommentView *preView = self.userCommentViewArray[i-1];
                make.top.equalTo(preView.bottom);
            }
            make.left.equalTo(view.left);
            make.width.equalTo(view.width);
            make.height.mas_equalTo([commentView getViewHeightWithComment:comment]);
        }];
        
        i++;
    }
    
    HHPostCommentView *lastView = [self.userCommentViewArray lastObject];
    lastView.botLine.hidden = YES;
    
    UIView *botLine = [[UIView alloc] init];
    botLine.backgroundColor = [UIColor HHLightLineGray];
    [view addSubview:botLine];
    [botLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.bottom).offset(-50.0f);
        make.left.equalTo(view.left).offset(15.0f);
        make.width.equalTo(view.width).offset(-30.0f);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    UILabel *checkMoreLabel = [[UILabel alloc] init];
    checkMoreLabel.text = @"点击查看更多";
    checkMoreLabel.textColor = [UIColor HHOrange];
    checkMoreLabel.font = [UIFont systemFontOfSize:15.0f];
    [view addSubview:checkMoreLabel];
    [checkMoreLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.centerX);
        make.centerY.equalTo(view.bottom).offset(-25.0f);
    }];
    
    UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToCommentsVC)];
    [view addGestureRecognizer:rec];
    return view;
}


- (void)jumpToCommentsVC {
    __weak HHClubPostDetailViewController *weakSelf = self;
    HHClubPostCommentsViewController *vc = [[HHClubPostCommentsViewController alloc] initWithPost:weakSelf.clubPost];
    vc.updateBlock = ^(HHClubPost *post) {
        weakSelf.clubPost = post;
        [weakSelf updateView];
        if (weakSelf.updateBlock) {
            weakSelf.updateBlock(post);
        }
    };
    [weakSelf.navigationController pushViewController:vc animated:YES];
}

- (void)updateView {
    [self.statView setupViewWithClubPost:self.clubPost];
    self.userCommentsView = [self buildCommentsView];
    [self.scrollView addSubview:self.userCommentsView];
    [self makeConstraints];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    __weak HHClubPostDetailViewController *weakSelf = self;
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
        [[HHLoadingViewUtility sharedInstance] showProgressView:self.webView.estimatedProgress];

        if(self.webView.estimatedProgress >= 1.0f) {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
                [self.webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable height, NSError * _Nullable error) {
                weakSelf.webViewHeight = [height floatValue];
                [weakSelf makeConstraints];
            }];
        }
    }
    else {
        // Make sure to call the superclass's implementation in the else block in case it is also implementing KVO
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    
    if ([self isViewLoaded]) {
        [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    }
    
    // if you have set either WKWebView delegate also set these to nil here
    [self.webView setNavigationDelegate:nil];
    [self.webView setUIDelegate:nil];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if (![navigationAction.request.URL.absoluteString isEqualToString:[self.clubPost getPostUrl]]) {
        HHWebViewController *vc = [[HHWebViewController alloc] initWithURL:navigationAction.request.URL];
        [self.navigationController pushViewController:vc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }

}


@end
