//
//  HHClubPostTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 9/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHClubPostStatView.h"
#import "HHClubPost.h"

@interface HHClubPostTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *botLine;
@property (nonatomic, strong) HHClubPostStatView *statView;
@property (nonatomic, strong) UIView *sepratorView;

- (void)setupCellWithClubPost:(HHClubPost *)clubPost;

@end
