//
//  HHGroupPurchaseView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 5/6/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHGroupPurchaseView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

static NSString *const kText = @"本次活动已经结束, 更多活动请您留意官网精彩活动页面.请您继续关注哈哈学车!";
static NSString *const kText2 = @"\n如有疑问, 可直接拨打客服热线: 400-001-6006\n或联系客服QQ: 3319762526";

@interface HHGroupPurchaseView () <UITextFieldDelegate>

@end

@implementation HHGroupPurchaseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor HHOrange];
    [self addSubview:self.topView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"团购活动已经结束~";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [self.topView addSubview:self.titleLabel];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setImage:[UIImage imageNamed:@"ic_homepage_groupbuy_close"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.cancelButton];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8.0f;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:kText attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor HHTextDarkGray], NSParagraphStyleAttributeName:paragraphStyle}];
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:kText2 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor HHTextDarkGray], NSParagraphStyleAttributeName:paragraphStyle}];
    [attrString appendAttributedString:attrString2];
    
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.numberOfLines = 0;
    self.subtitleLabel.attributedText = attrString;
    [self addSubview:self.subtitleLabel];

    [self makeConstraints];

}

- (void)makeConstraints {
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(70.0f);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.centerY);
        make.left.equalTo(self.topView.left).offset(15.0f);
    }];
    
    [self.cancelButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.centerY);
        make.right.equalTo(self.topView.right).offset(-15.0f);
    }];
    
    [self.subtitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.bottom).offset(25.0f);
        make.width.equalTo(self.width).offset(-40.0f);
        make.centerX.equalTo(self.centerX);
    }];
}

- (void)cancelTapped {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}



@end
