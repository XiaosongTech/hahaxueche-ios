//
//  HHPayCoachExplanationView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/28/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPayCoachExplanationView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "NSNumber+HHNumber.h"

@implementation HHPayCoachExplanationView

- (instancetype)initWithFrame:(CGRect)frame amount:(NSNumber *)amount {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.attributedText = [self buildTitle];
        [self addSubview:self.titleLabel];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.textColor = [UIColor HHLightTextGray];
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.numberOfLines = 0;
        self.textLabel.text = [self buildText:amount];
        [self addSubview:self.textLabel];
        
        self.buttonsView = [[HHConfirmCancelButtonsView alloc] initWithLeftTitle:@"暂不打款" rightTitle:@"确认打款"];
        [self addSubview:self.buttonsView];
        
        [self makeConstraints];
    }
    return self;
}

- (void)makeConstraints {
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(self.top).offset(15.0f);
    }];
    
    [self.textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(self.titleLabel.bottom).offset(10.0f);
        make.width.equalTo(self.width).offset(-40.0f);
    }];
    
    [self.buttonsView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(50.0f);
        make.left.equalTo(self.left);
    }];
}

- (NSMutableAttributedString *)buildTitle {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentNatural;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@" 打款提醒" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName:[UIColor HHOrange], NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"ic_paynotice"];
    textAttachment.bounds = CGRectMake(0, -2.0f, textAttachment.image.size.width, textAttachment.image.size.height);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedString insertAttributedString:attrStringWithImage atIndex:0];
    return attributedString;
    
}

- (NSString *)buildText:(NSNumber *)amount {
    NSString *string = [NSString stringWithFormat:@"点击确认打款，即表明您已完成并满意该阶段的项目或培训内容，哈哈学车会将您账户中的%@转到教练账户，该阶段的支付完成。", [amount generateMoneyString]];
    return string;
}


@end
