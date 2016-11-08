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
#import <pop/POP.h>

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
            self.thumbUpView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTapped)];
            [self.thumbUpView addGestureRecognizer:tapRec];
            
            self.thumbUpCountLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapRec4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTapped)];
            [self.thumbUpCountLabel addGestureRecognizer:tapRec4];
            
            self.commentView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapRec2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTapped)];
            [self.commentView addGestureRecognizer:tapRec2];
            
            self.commentCountLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapRec3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTapped)];
            [self.commentCountLabel addGestureRecognizer:tapRec3];
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
    self.commentCountLabel.text = [NSString stringWithFormat:@"%ld", clubPost.comments.count];
    self.eyeCountLabel.text = [clubPost.viewCount stringValue];
    self.thumbUpCountLabel.text = [clubPost.likeCount stringValue];
    if ([clubPost.liked boolValue]) {
        POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        sprintAnimation.animationDidStartBlock = ^(POPAnimation *anim) {
            self.thumbUpView.image = [UIImage imageNamed:@"icon_like_click"];;
        };
        sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(10, 10)];
        sprintAnimation.springBounciness = 20.f;
        [self.thumbUpView pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
        self.thumbUpCountLabel.textColor = [UIColor HHOrange];
    } else {
        self.thumbUpView.image = [UIImage imageNamed:@"icon_like"];
        self.thumbUpCountLabel.textColor = [UIColor HHLightestTextGray];;
    }
}

@end
