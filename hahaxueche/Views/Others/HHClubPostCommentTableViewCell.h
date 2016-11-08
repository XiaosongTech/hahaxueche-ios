//
//  HHClubPostCommentTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 9/23/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHPostCommentView.h"
#import "HHPostComment.h"

@interface HHClubPostCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) HHPostCommentView *commentView;

- (void)setupViewWithComment:(HHPostComment *)comment;

@end
