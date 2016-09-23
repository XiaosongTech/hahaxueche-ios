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

static NSString *const kCellId = @"kCellId";

@interface HHClubPostCommentsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *botToolBar;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) HHCommentView *commentView;

@end

@implementation HHClubPostCommentsViewController

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
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}


- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showCommentTextView {
    __weak HHClubPostCommentsViewController *weakSelf = self;
    self.commentView = [[HHCommentView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 158.0f)];
    self.commentView.cancelBlock = ^(){
        [weakSelf.commentView.textView resignFirstResponder];
        [HHPopupUtility dismissPopup:weakSelf.popup];
    };
    
    self.commentView.confirmBlock = ^() {
        [weakSelf.commentView.textView resignFirstResponder];
        [HHPopupUtility dismissPopup:weakSelf.popup];
    };
    
    self.popup = [HHPopupUtility createPopupWithContentView:self.commentView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom];
    self.popup.willStartDismissingCompletion = ^() {
        [weakSelf.commentView.textView resignFirstResponder];
    };
    [HHPopupUtility showPopup:self.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
}


@end
