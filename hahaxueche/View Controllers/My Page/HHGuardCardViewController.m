//
//  HHGuardCardViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 21/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHGuardCardViewController.h"
#import <TTTAttributedLabel.h>
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "HHSupportUtility.h"

static NSString *const kBaseString = @"*如有其它疑问请联系客服或您的专属学车顾问\n哈哈学车客服热线:400-001-6006\n哈哈学车在线客服";

@interface HHGuardCardViewController () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) TTTAttributedLabel *supportLabel;

@end

@implementation HHGuardCardViewController

- (instancetype)init {
    self = [super initWithImage:[UIImage imageNamed:@"Group_15"]];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"科目一四挂科险";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 8.0f;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:kBaseString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHOrange], NSParagraphStyleAttributeName:style}];
    
    NSRange range = [string.string rangeOfString:@"400-001-6006"];
    [string addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
    
    range = [string.string rangeOfString:@"在线客服"];
    [string addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
    
    self.supportLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.supportLabel.textAlignment = NSTextAlignmentLeft;
    self.supportLabel.linkAttributes = @{(NSString *)kCTForegroundColorAttributeName:[UIColor HHOrange]};
    self.supportLabel.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName:[UIColor HHOrange]};
    self.supportLabel.attributedText = string;
    self.supportLabel.numberOfLines = 0;
    self.supportLabel.delegate = self;
    [self.scrollView addSubview:self.supportLabel];
    [self.supportLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(20.0f);
        make.width.equalTo(self.scrollView.width).offset(-40.0f);
        make.top.equalTo(self.imageView.bottom);
    }];
    
    [self.supportLabel addLinkToURL:[NSURL URLWithString:@"callSupport"] withRange:[string.string rangeOfString:@"400-001-6006"]];
    [self.supportLabel addLinkToURL:[NSURL URLWithString:@"onlineSupport"] withRange:[string.string rangeOfString:@"在线客服"]];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.supportLabel
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-30.0f]];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([url.absoluteString isEqualToString:@"callSupport"]) {
        [[HHSupportUtility sharedManager] callSupport];
        
    } else if ([url.absoluteString isEqualToString:@"onlineSupport"]){
        [self.navigationController pushViewController:[[HHSupportUtility sharedManager] buildOnlineSupportVCInNavVC:self.navigationController] animated:YES];
    }
}


@end
