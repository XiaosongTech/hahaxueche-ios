//
//  HHClubPostStatView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 9/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHClubPost.h"

typedef void (^HHClubPostBlock)();

@interface HHClubPostStatView : UIView

- (instancetype)initWithInteraction:(BOOL)enableInteraction;

@property (nonatomic, strong) UIImageView *eyeView;
@property (nonatomic, strong) UIImageView *thumbUpView;
@property (nonatomic, strong) UIImageView *commentView;

@property (nonatomic, strong) UILabel *eyeCountLabel;
@property (nonatomic, strong) UILabel *thumbUpCountLabel;
@property (nonatomic, strong) UILabel *commentCountLabel;

@property (nonatomic, strong) HHClubPostBlock likeAction;
@property (nonatomic, strong) HHClubPostBlock commentAction;

- (void)setupViewWithClubPost:(HHClubPost *)clubPost;

@end
