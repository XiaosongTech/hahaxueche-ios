//
//  HHQRCodeShareView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 13/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHQRCodeShareView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"

@implementation HHQRCodeShareView

- (instancetype)initWithTitle:(NSAttributedString *)string qrCodeImg:(UIImage *)img {
    self = [super init];
    if (self) {
        CGRect rect = [string boundingRectWithSize:CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds])-60.0f, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                           context:nil];
        
        self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(rect) + 220.0f);
        self.backgroundColor = [UIColor whiteColor];
    
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10.0f, CGRectGetWidth(self.bounds), CGRectGetHeight(rect))];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.attributedText = string;
        [self addSubview:self.titleLabel];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setFrame:CGRectMake(CGRectGetWidth(self.bounds)-40.0f, 5.0f, 0, 0)];
        [self.cancelButton sizeToFit];
        [self.cancelButton setImage:[UIImage imageNamed:@"button_close2"] forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(dismissShareView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
        
        
        self.botView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.bounds) + 10.0f, CGRectGetWidth(self.bounds), 210.0f)];
        [self addSubview:self.botView];
        
        self.qrCodeImgView = [[UIImageView alloc] initWithImage:img];
        self.qrCodeImgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.botView addSubview:self.qrCodeImgView];
        [self.qrCodeImgView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.botView.centerX);
            make.width.mas_equalTo(90.0f);
            make.height.mas_equalTo(90.0f);
            make.top.equalTo(self.botView.top);
        }];
        
        HHShareViewItem *item;
        for (int i = 0; i < SocialMediaCount; i++) {
            switch (i) {
                case SocialMediaQQFriend: {
                    item = [[HHShareViewItem alloc] initWithImage:[UIImage imageNamed:@"ic_coachmsg_sharecoach_qq"] title:@"QQ"];
                    [self.botView addSubview:item];
                    [item makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.botView.centerX).multipliedBy(1/4.0f);
                        make.width.equalTo(self.botView.width).multipliedBy(1.0f/4.0f);
                        make.height.mas_equalTo(90.0f);
                        make.top.equalTo(self.botView.top).offset(20.0f);
                    }];
                } break;
                    
                case SocialMediaWeibo: {
                    item = [[HHShareViewItem alloc] initWithImage:[UIImage imageNamed:@"ic_coachmsg_sharecoach_weibo"] title:@"微博"];
                    [self.botView addSubview:item];
                    [item makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.botView.centerX).multipliedBy(5/4.0f);
                        make.width.equalTo(self.botView.width).multipliedBy(1.0f/4.0f);
                        make.height.mas_equalTo(90.0f);
                        make.top.equalTo(self.botView.top).offset(110.0f);
                    }];
                } break;
                    
                case SocialMediaWeChatFriend: {
                    item = [[HHShareViewItem alloc] initWithImage:[UIImage imageNamed:@"ic_coachmsg_sharecoach_wechat"] title:@"微信"];
                    [self.botView addSubview:item];
                    [item makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.botView.centerX).multipliedBy(7/4.0f);
                        make.width.equalTo(self.botView.width).multipliedBy(1.0f/4.0f);
                        make.height.mas_equalTo(90.0f);
                        make.top.equalTo(self.botView.top).offset(20.0f);
                    }];
                } break;
                    
                case SocialMediaWeChaPYQ: {
                    item = [[HHShareViewItem alloc] initWithImage:[UIImage imageNamed:@"ic_coachmsg_sharecoach_friendgroup"] title:@"朋友圈"];
                    [self.botView addSubview:item];
                    [item makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.botView.centerX).multipliedBy(3/4.0f);
                        make.width.equalTo(self.botView.width).multipliedBy(1.0f/4.0f);
                        make.height.mas_equalTo(90.0f);
                        make.top.equalTo(self.botView.top).offset(110.0f);
                    }];
                } break;
                    
                case SocialMediaQZone: {
                    item = [[HHShareViewItem alloc] initWithImage:[UIImage imageNamed:@"ic_coachmsg_sharecoach_kongjian"] title:@"空间"];
                    [self.botView addSubview:item];
                    [item makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.botView.centerX).multipliedBy(1/4.0f);
                        make.width.equalTo(self.botView.width).multipliedBy(1.0f/4.0f);
                        make.height.mas_equalTo(90.0f);
                        make.top.equalTo(self.botView.top).offset(110.0f);
                    }];
                } break;
                    
                case SocialMediaMessage: {
                    item = [[HHShareViewItem alloc] initWithImage:[UIImage imageNamed:@"ic_message"] title:@"短信"];
                    [self.botView addSubview:item];
                    [item makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.botView.centerX).multipliedBy(7/4.0f);
                        make.width.equalTo(self.botView.width).multipliedBy(1.0f/4.0f);
                        make.height.mas_equalTo(90.0f);
                        make.top.equalTo(self.botView.top).offset(110.0f);
                    }];
                } break;
                    
                default:
                    break;
            }
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemSelected:)];
            item.tag = i;
            [item addGestureRecognizer:tapRecognizer];
        }
    }
    return self;
}

- (void)dismissShareView {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (void)itemSelected:(UITapGestureRecognizer *)recognizer {
    if (self.selectedBlock) {
        self.selectedBlock(recognizer.view.tag);
    }
}

@end
