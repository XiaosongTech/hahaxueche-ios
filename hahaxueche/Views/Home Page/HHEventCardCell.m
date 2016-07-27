//
//  HHEventCardCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/27/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHEventCardCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHEventCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        self.containerView = [[UIView alloc] init];
        self.containerView.layer.cornerRadius = 5.0f;
        self.containerView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.containerView];
        
        self.topView = [[UIView alloc] init];
        self.topView.backgroundColor = [UIColor HHOrange];
        [self.containerView addSubview:self.topView];
        
        self.botView = [[UIView alloc] init];
        self.botView.backgroundColor = [UIColor whiteColor];
        [self.containerView addSubview:self.botView];
        
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:20.0f];
        [self.topView addSubview:self.titleLabel];
        
        self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_group_ic"]];
        [self.topView addSubview:self.imgView];
        
        self.moreLabel = [[UILabel alloc] init];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"查看详情 " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
        
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:@"ic_group_more"];
        textAttachment.bounds = CGRectMake(2.0f, -1.0f, textAttachment.image.size.width, textAttachment.image.size.height);
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        
        [attributedString appendAttributedString:attrStringWithImage];
        self.moreLabel.attributedText = attributedString;
        [self.botView addSubview:self.moreLabel];
        
        
        [self makeConstraints];
    }
    return self;
}

- (void)makeConstraints {
    [self.containerView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.centerX);
        make.top.equalTo(self.contentView.top).offset(20.0f);
        make.width.equalTo(self.contentView.width).offset(-40.0f);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.left);
        make.top.equalTo(self.containerView.top);
        make.width.equalTo(self.containerView.width);
        make.bottom.equalTo(self.containerView.bottom).offset(-35.0f);
    }];
    
    [self.botView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.left);
        make.top.equalTo(self.topView.bottom);
        make.width.equalTo(self.containerView.width);
        make.bottom.equalTo(self.containerView.bottom);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.left).offset(15.0f);
        make.centerY.equalTo(self.topView.centerY);
    }];
    
    [self.imgView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.right);
        make.top.equalTo(self.topView.top);
    }];
    
    [self.moreLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.botView.right).offset(-15.0f);
        make.centerY.equalTo(self.botView.centerY);
    }];
}

- (void)setupCellWithEvent:(HHEvent *)event {
    self.titleLabel.text = event.title;
    
    self.countDownView = [[HHCountDownView alloc] initWithStartDate:[NSDate date] finishDate:event.endDate numberColor:[UIColor HHOrange] textColor:[UIColor HHLightTextGray] numberFont:[UIFont systemFontOfSize:15.0f] textFont:[UIFont systemFontOfSize:12.0f]];
    [self.botView addSubview:self.countDownView];
    
    [self.countDownView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botView.centerY);
        make.left.equalTo(self.botView.left).offset(15.0f);
        make.width.mas_equalTo(110.0f);
        make.height.mas_equalTo(20.0f);
    }];
}

@end
