//
//  HHReferFriendsViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/25/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHReferFriendsViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHButton.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "NSNumber+HHNumber.h"
#import "HHSocialMediaShareUtility.h"
#import "HHLoadingViewUtility.h"
#import "HHToastManager.h"
#import <MessageUI/MessageUI.h>
#import <UIImageView+WebCache.h>
#import "HHConstantsStore.h"
#import "HHWithdrawViewController.h"


static NSString *const kRulesString = @"1）好友通过您的专属链接注册并成功报名，您的好友报名成功后，您将获得%@元，累计无上限，可随时提现\n\n2）好友需通过您的专属二维码免费试学才能建立推荐关系\n\n3）如发现作弊行为将取消用户活动资格，并扣除所获奖励\n\n4）如对本活动规则有任何疑问，请联系哈哈学车客服：400-001-6006\n\n";

static NSString *const kLawString = @"＊在法律允许的范围内，哈哈学车有权对活动规则进行解释";

@interface HHReferFriendsViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *eventTitleImageView;
@property (nonatomic, strong) UILabel *eventRulesLabel;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIButton *withdrawButton;

@end

@implementation HHReferFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我为哈哈代言";
    
    self.view.backgroundColor = [UIColor HHBackgroundGary];
     self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(popupVC) target:self];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    
    UIView *bounceBGVIew = [[UIView alloc] initWithFrame:CGRectMake(0,-480,CGRectGetWidth(self.view.bounds),480)];
    bounceBGVIew.backgroundColor = [UIColor HHOrange];
    [self.scrollView addSubview:bounceBGVIew];
    
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor HHOrange];
    [self.scrollView addSubview:self.topView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"可提现";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.topView addSubview:self.titleLabel];
    
    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.textColor = [UIColor whiteColor];
    self.valueLabel.text = @"$100";
    self.valueLabel.font = [UIFont systemFontOfSize:25.0f];
    [self.topView addSubview:self.valueLabel];
    
    self.withdrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.withdrawButton setTitle:@"提现" forState:UIControlStateNormal];
    [self.withdrawButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.withdrawButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.withdrawButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.withdrawButton.layer.masksToBounds = YES;
    self.withdrawButton.layer.cornerRadius = 5.0f;
    self.withdrawButton.layer.borderWidth = 2.0f/[UIScreen mainScreen].scale;
    [self.withdrawButton addTarget:self action:@selector(showWithdrawVC) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.withdrawButton];
    
    HHCity *city = [[HHConstantsStore sharedInstance] getAuthedUserCity];
    self.imageView = [[UIImageView alloc] init];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:city.referalBanner] placeholderImage:nil];
    [self.scrollView addSubview:self.imageView];
    
    self.eventTitleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_line"]];
    [self.scrollView addSubview:self.eventTitleImageView];
    
    self.eventRulesLabel = [[UILabel alloc] init];
    self.eventRulesLabel.numberOfLines = 0;
    self.eventRulesLabel.attributedText = [self buildRulesString];
    [self.scrollView addSubview:self.eventRulesLabel];
    
    [self makeConstraints];
    
}

- (NSMutableAttributedString *)buildRulesString {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:kRulesString, [[HHConstantsStore sharedInstance] getCityReferrerBonus]] attributes:@{NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}];
    
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:kLawString attributes:@{NSForegroundColorAttributeName:[UIColor HHOrange], NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}];
    [attrString appendAttributedString:attrString2];
    return attrString;
}


- (void)makeConstraints {
    
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
        make.bottom.equalTo(self.eventRulesLabel.bottom).offset(20.0f);
    }];
    
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(90.0f);
        
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.top).offset(20.0f);
        make.left.equalTo(self.topView.left).offset(20.0f);
    }];
    
    [self.valueLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(5.0f);
        make.left.equalTo(self.topView.left).offset(20.0f);
    }];
    
    [self.withdrawButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.top).offset(30.0f);
        make.right.equalTo(self.topView.right).offset(-20.0f);
        make.width.mas_equalTo(60.0f);
        make.height.mas_equalTo(30.0f);
        
    }];
    
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.bottom);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(335.0f);
    }];

    
    [self.eventTitleImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.bottom).offset(30.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.equalTo(self.scrollView.width);

    }];
    
    [self.eventRulesLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.eventTitleImageView.bottom).offset(20.0f);
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.equalTo(self.scrollView.width).offset(-60.0f);
    }];
    
}

- (void)popupVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showWithdrawVC {
    HHWithdrawViewController *vc = [[HHWithdrawViewController alloc] initWithAvailableAmount:@(10000)];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
