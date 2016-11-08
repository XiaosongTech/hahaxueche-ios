//
//  HHPostCommentView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 03/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPostCommentView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHFormatUtility.h"
#import <UIImageView+WebCache.h>

@implementation HHPostCommentView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.avaView = [[UIImageView alloc] init];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 15.0f;
        [self addSubview:self.avaView];
        [self.avaView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top).offset(10.0f);
            make.left.equalTo(self.left).offset (15.0f);
            make.width.mas_equalTo(30.0f);
            make.height.mas_equalTo(30.0f);
        }];
        
        self.nameLabel = [self buildLabelWithFont:[UIFont systemFontOfSize:12.0f] color:[UIColor HHLightTextGray]];
        [self addSubview:self.nameLabel];
        [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.avaView.centerY).offset(-2.0f);
            make.left.equalTo(self.avaView.right).offset(5.0f);
        }];
        
        self.dateLabel = [self buildLabelWithFont:[UIFont systemFontOfSize:12.0f] color:[UIColor HHLightTextGray]];
        [self addSubview:self.dateLabel];
        [self.dateLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.avaView.centerY).offset(-2.0f);
            make.right.equalTo(self.right).offset(-15.0f);
        }];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.numberOfLines = 0;
        [self addSubview:self.contentLabel];
        [self.contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avaView.centerY).offset(3.0f);
            make.left.equalTo(self.nameLabel.left);
            make.right.equalTo(self.dateLabel.right);
        }];
        
        self.botLine = [[UIView alloc] init];
        self.botLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.botLine];
        [self.botLine makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom);
            make.left.equalTo(self.nameLabel.left);
            make.right.equalTo(self.dateLabel.right);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
    }
    return self;
}

- (UILabel *)buildLabelWithFont:(UIFont *)font color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = font;
    label.numberOfLines = 0;
    return label;
}

- (void)setupViewWithComment:(HHPostComment *)comment {
    self.comment = comment;
    self.nameLabel.text = comment.studentName;
    self.dateLabel.text = [[HHFormatUtility fullDateSlashFormatter] stringFromDate:comment.createdAt];
    self.contentLabel.attributedText = [self buildContenStringWithComment:comment];
    [self.avaView sd_setImageWithURL:[NSURL URLWithString:comment.avatar] placeholderImage:[UIImage imageNamed:@"ic_mypage_ava"]];
}

- (CGFloat)getViewHeightWithComment:(HHPostComment *)comment {
    CGRect rect = [[self buildContenStringWithComment:comment] boundingRectWithSize:CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds])-65.0f, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                                                            context:nil];
    return CGRectGetHeight(rect)+ 45.0f;
}

- (NSMutableAttributedString *)buildContenStringWithComment:(HHPostComment *)comment {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 4.0f;
    return [[NSMutableAttributedString alloc] initWithString:comment.content attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHTextDarkGray], NSParagraphStyleAttributeName:paraStyle}];
}

@end
