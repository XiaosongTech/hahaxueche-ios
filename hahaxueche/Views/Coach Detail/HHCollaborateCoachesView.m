//
//  HHCollaborateCoachesView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/11/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCollaborateCoachesView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "HHCoach.h"
#import "HHCoachCellView.h"

@implementation HHCollaborateCoachesView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubviews];
        self.backgroundColor = [UIColor whiteColor];
        self.viewsArray = [NSMutableArray array];
    }
    return self;
}

- (void)initSubviews {
    self.titleLabel = [[UILabel alloc] init];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentNatural;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@" 合作教练" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHOrange], NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"ic_coachmsg_partner"];
    textAttachment.bounds = CGRectMake(0, -2.0f, textAttachment.image.size.width, textAttachment.image.size.height);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedString insertAttributedString:attrStringWithImage atIndex:0];
    self.titleLabel.attributedText = attributedString;
    [self addSubview:self.titleLabel];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(self.top).offset(18.0f);
    }];
}

- (void)setupCellWithCoaches:(NSArray *)coaches {
    for (HHCoachCellView *view in self.viewsArray) {
        [view removeFromSuperview];
    }
    [self.viewsArray removeAllObjects];
    
    int i = 0;
    for (HHCoach *coach in coaches) {
        HHCoachCellView *view = [[HHCoachCellView alloc] initWithCoach:coach];
        view.tag = i;
        [self addSubview:view];
        
        UITapGestureRecognizer *tapRecognizer =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coachViewTapped:)];
        [view addGestureRecognizer:tapRecognizer];
        if (i == 0) {
            [view makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLabel.bottom);
                make.width.equalTo(self.width);
                make.left.equalTo(self.left);
                make.height.mas_equalTo(70.0f);
            }];
        } else {
            HHCoachCellView *preView = self.viewsArray[i-1];
            [view makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(preView.bottom);
                make.width.equalTo(self.width);
                make.left.equalTo(self.left);
                make.height.mas_equalTo(70.0f);
            }];
        }
        [self.viewsArray addObject:view];
        
        i++;
    }
   
}

- (void)coachViewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *view = recognizer.view;
    if (self.peerCoachTappedAction) {
        self.peerCoachTappedAction(view.tag);
    }
}

@end
