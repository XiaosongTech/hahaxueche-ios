//
//  HHClubPostCommentsViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/22/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHClubPostCommentsViewController.h"
#import "UIColor+HHColor.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "Masonry.h"
#import "HHCommentView.h"
#import "HHPopupUtility.h"
#import "HHClubPostCommentTableViewCell.h"
#import "HHClubPostService.h"
#import "HHLoadingViewUtility.h"
#import "HHToastManager.h"
#import "HHStudentStore.h"
#import "HHGenericTwoButtonsPopupView.h"
#import "HHIntroViewController.h"

static NSString *const kCellId = @"kCellId";


@interface HHClubPostCommentsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *botToolBar;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) HHCommentView *commentView;
@property (nonatomic, strong) HHClubPost *post;

@end

@implementation HHClubPostCommentsViewController

- (instancetype)initWithPost:(HHClubPost *)post {
    self = [super init];
    if (self) {
        self.post = post;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"评论";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[HHClubPostCommentTableViewCell class] forCellReuseIdentifier:kCellId];
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(self.view.bottom).offset(-50.0f);
    }];
    
    self.botToolBar = [[UIView alloc] init];
    [self.view addSubview:self.botToolBar];
    [self.botToolBar makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50.0f);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.bottom.equalTo(self.view.bottom);
    }];
    
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
    [self.commentButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botToolBar.centerY);
        make.width.equalTo(self.botToolBar.width).offset(-30.0f);
        make.height.mas_equalTo(30.0f);
        make.left.equalTo(self.botToolBar.left).offset(15.0f);
    }];

}

#pragma mark - UITableView Delegate & Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHClubPostCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    [cell setupViewWithComment:self.post.comments[indexPath.row]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.post.comments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHPostComment *comment = self.post.comments[indexPath.row];
    return [self getCellHeightWithComment:comment];
}


- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showCommentTextView {
    if (![HHStudentStore sharedInstance].currentStudent.studentId) {
        [self showLoginPopupForComment];
    }
    __weak HHClubPostCommentsViewController *weakSelf = self;
    self.commentView = [[HHCommentView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 158.0f)];
    self.commentView.cancelBlock = ^(){
        [weakSelf.commentView.textView resignFirstResponder];
        [HHPopupUtility dismissPopup:weakSelf.popup];
    };
    
    self.commentView.confirmBlock = ^(NSString *content) {
        [[HHLoadingViewUtility sharedInstance] showLoadingView];
        [[HHClubPostService sharedInstance] commentPostWithId:weakSelf.post.postId content:content completion:^(HHClubPost *post, NSError *error) {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
            if (!error) {
                weakSelf.post = post;
                [weakSelf.tableView reloadData];
                if (weakSelf.updateBlock) {
                    weakSelf.updateBlock(post);
                }
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

- (void)showLoginPopupForComment {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineSpacing = 8.0f;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"注册登录后, 才可以评价文章哦~\n注册获得更多学车咨询!~" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:paragraphStyle}];
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

- (CGFloat)getCellHeightWithComment:(HHPostComment *)comment {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 4.0f;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:comment.content attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHTextDarkGray], NSParagraphStyleAttributeName:paraStyle}];
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds])-65.0f, CGFLOAT_MAX)
                                                                            options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                                                            context:nil];
    return CGRectGetHeight(rect)+ 45.0f;
}



@end
