//
//  HHShareView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/13/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHShareView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "UIView+HHRect.h"
#import "HHShareViewItem.h"

static CGFloat const kItemViewHeight = 100.0f;
static NSInteger const kCountPerLine = 4;

@implementation HHShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setFrameWithHeight:100 + kItemViewHeight *((SocialMediaCount + kCountPerLine -1)/kCountPerLine)];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"分享给朋友";
    self.titleLabel.textColor = [UIColor HHTextDarkGray];
    self.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [self addSubview:self.titleLabel];
    
    self.botLine = [[UIView alloc] init];
    self.botLine.backgroundColor = [UIColor HHLightLineGray];
    [self addSubview:self.botLine];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor HHCancelRed] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelButton];
    

    self.itemsView = [[UIView alloc] init];
    [self addSubview:self.itemsView];

    for (int i = 0; i < SocialMediaCount; i++) {
        HHShareViewItem *item;
        switch (i) {
            case SocialMediaQQFriend: {
                item = [[HHShareViewItem alloc] initWithImage:[UIImage imageNamed:@"ic_coachmsg_sharecoach_qq"] title:@"QQ"];
            } break;
                
            case SocialMediaQQZone: {
                item = [[HHShareViewItem alloc] initWithImage:[UIImage imageNamed:@"ic_coachmsg_sharecoach_kongjian"] title:@"空间"];
            } break;
                
            case SocialMediaWeChatFriend: {
               item = [[HHShareViewItem alloc] initWithImage:[UIImage imageNamed:@"ic_coachmsg_sharecoach_wechat"] title:@"微信"];
            } break;
                
            case SocialMediaWeChaPYQ: {
                item = [[HHShareViewItem alloc] initWithImage:[UIImage imageNamed:@"ic_coachmsg_sharecoach_friendgroup"] title:@"朋友圈"];
            } break;
                
            default:
                break;
        }
                 
        item.tag = i;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemSelected:)];
        [item addGestureRecognizer:tapRecognizer];
        [self.itemsView addSubview:item];
        [self.items addObject:item];
    
        [item setFrame:CGRectMake((i%kCountPerLine) * CGRectGetWidth(self.bounds)/kCountPerLine, (i/kCountPerLine) * kItemViewHeight, CGRectGetWidth(self.bounds)/kCountPerLine, kItemViewHeight)];
    }
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(10.0f);
        make.centerX.equalTo(self.centerX);
    }];
    
    [self.itemsView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(40.0f);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kItemViewHeight *((SocialMediaCount + 3 -1)/3));
    }];
    
    [self.botLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottom).offset(-50.0f);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.cancelButton makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50.0f);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.bottom.equalTo(self.bottom);
    }];
    
    
}

- (void)dismissView {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (void)itemSelected:(UITapGestureRecognizer *)recognizer {
    if (self.actionBlock) {
        self.actionBlock(recognizer.view.tag);
    }
}

@end
