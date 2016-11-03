//
//  HHPostCommentView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 03/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHPostComment.h"

@interface HHPostCommentView : UIView

@property (nonatomic, strong) UIImageView *avaView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *botLine;
@property (nonatomic, strong) HHPostComment *comment;

- (void)setupViewWithComment:(HHPostComment *)comment;

- (CGFloat)getViewHeightWithComment:(HHPostComment *)comment;

@end
