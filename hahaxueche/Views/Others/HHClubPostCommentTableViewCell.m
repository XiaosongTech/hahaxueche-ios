//
//  HHClubPostCommentTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/23/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHClubPostCommentTableViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHClubPostCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
    
        self.commentView = [[HHPostCommentView alloc] init];
        [self.contentView addSubview:self.commentView];
        [self.commentView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.top);
            make.left.equalTo(self.contentView.left);
            make.width.equalTo(self.contentView.width);
            make.height.equalTo(self.contentView.height);
        }];
        
        
    }
    return self;
}

- (void)setupViewWithComment:(HHPostComment *)comment {
    [self.commentView setupViewWithComment:comment];
}

@end
