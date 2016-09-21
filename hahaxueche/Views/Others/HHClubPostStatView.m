//
//  HHClubPostStatView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHClubPostStatView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHClubPostStatView

- (instancetype)initWithInteraction:(BOOL)enableInteraction {
    self = [super init];
    if (self) {
        
        self.commentCountLabel = [self buildLabel];
        [self addSubview:self.commentCountLabel];
        [self.commentCountLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(-10.0f);
            make.centerY.equalTo(self.centerY);
        }];
        
        self.commentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_comment"]];
        [self addSubview:self.commentView];
        [self.commentView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.commentCountLabel.left).offset(-1.0f);
            make.centerY.equalTo(self.centerY);
        }];
        
        
        self.thumbUpCountLabel = [self buildLabel];
        [self addSubview:self.thumbUpCountLabel];
        [self.thumbUpCountLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.commentView.left).offset(-7.0f);
            make.centerY.equalTo(self.centerY);
        }];
        
        self.thumbUpView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_like"]];
        [self addSubview:self.thumbUpView];
        [self.thumbUpView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.thumbUpCountLabel.left).offset(-2.0f);
            make.centerY.equalTo(self.centerY);
        }];
        
        self.eyeCountLabel = [self buildLabel];
        [self addSubview:self.eyeCountLabel];
        [self.eyeCountLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.thumbUpView.left).offset(-7.0f);
            make.centerY.equalTo(self.centerY);
        }];
        
        self.eyeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_view"]];
        [self addSubview:self.eyeView];
        [self.eyeView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.eyeCountLabel.left).offset(-2.0f);
            make.centerY.equalTo(self.centerY);
        }];
        
        
       
    
        
        if (enableInteraction) {
            UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTapped)];
            [self.thumbUpView addGestureRecognizer:tapRec];
            
            UITapGestureRecognizer *tapRec2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTapped)];
            [self.commentView addGestureRecognizer:tapRec2];
        }
    }
    return self;
}

- (void)likeTapped {
    if (self.likeAction) {
        self.likeAction();
    }
}

- (void)commentTapped {
    if (self.commentAction) {
        self.commentAction();
    }
}

- (UILabel *)buildLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor HHLightestTextGray];
    label.font = [UIFont systemFontOfSize:15.0f];
    return label;
}

- (void)setupViewWithClubPost:(HHClubPost *)clubPost {
    self.commentCountLabel.text = @"12";
    self.eyeCountLabel.text = @"122";
    self.thumbUpCountLabel.text = @"2";
}

@end
