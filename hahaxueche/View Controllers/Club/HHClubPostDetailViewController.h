//
//  HHClubPostDetailViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 9/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHClubPost.h"
#import "HHClubPostCommentsViewController.h"

@interface HHClubPostDetailViewController : UIViewController

- (instancetype)initWithClubPost:(HHClubPost *)clubPost;
- (instancetype)initWithPostId:(NSString *)postId;

@property (nonatomic, strong) HHUpdatePostBlock updateBlock;

@end
