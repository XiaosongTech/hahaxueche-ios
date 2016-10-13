//
//  HHPurchaseTagView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 13/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPurchaseTagView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHPurchaseTagView

- (instancetype)initWithTags:(NSArray *)tags title:(NSString *)title defaultTag:(NSString *)defaultTag {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.tagViews = [NSMutableArray array];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor HHOrange];
        self.titleLabel.text = title;
        self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top).offset(8.0f);
            make.left.equalTo(self.left).offset(20.0f);
        }];
        
        for (NSInteger i = 0; i < tags.count; i++) {
            UILabel *tag = [[UILabel alloc] init];
            [self.tagViews addObject:tag];
            tag.userInteractionEnabled = YES;
            tag.textAlignment = NSTextAlignmentCenter;
            tag.font = [UIFont systemFontOfSize:15.0f];
            tag.text = tags[i];
            tag.layer.cornerRadius = 5.0f;
            tag.layer.masksToBounds = YES;
            tag.backgroundColor = [UIColor HHBackgroundGary];
            tag.textColor = [UIColor HHLightTextGray];
            [self addSubview:tag];
            [tag sizeToFit];
            if (i == 0) {
                [tag makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.titleLabel.bottom).offset(10.0f);
                    make.left.equalTo(self.left).offset(20.0f);
                    make.height.mas_equalTo(23.0f);
                    make.width.mas_equalTo(CGRectGetWidth(tag.frame) + 20.0f);
                }];
            } else {
                UILabel *prevTag = self.tagViews[i-1];
                [tag makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(prevTag.centerY);
                    make.left.equalTo(prevTag.right).offset(15.0f);
                    make.height.mas_equalTo(25.0f);
                    make.width.mas_equalTo(CGRectGetWidth(tag.frame) + 20.0f);
                }];
            }
            
            UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagTapped:)];
            [tag addGestureRecognizer:tapRec];
            
            if ([defaultTag isEqualToString:tag.text]) {
                tag.textColor = [UIColor whiteColor];
                tag.backgroundColor = [UIColor HHOrange];
            }
            
        }
        self.botLine = [[UIView alloc] init];
        self.botLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.botLine];
        [self.botLine makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.bottom.equalTo(self.bottom);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
    }
    return self;
}

- (void)tagTapped:(UITapGestureRecognizer *)rec {
    UILabel *tappedTag = (UILabel *)rec.view;
    for (UILabel *tag in self.tagViews) {
        if ([tag isEqual:tappedTag]) {
            tag.textColor = [UIColor whiteColor];
            tag.backgroundColor = [UIColor HHOrange];
        } else {
            tag.textColor = [UIColor HHLightTextGray];
            tag.backgroundColor = [UIColor HHLightBackgroudGray];
        }
    }
    if (self.tagAction) {
        self.tagAction([self.tagViews indexOfObject:tappedTag]);
    }
}

@end
