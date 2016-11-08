//
//  HHClubPostCommentsViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 9/22/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHClubPost.h"

typedef void (^HHUpdatePostBlock)(HHClubPost *post);

@interface HHClubPostCommentsViewController : UIViewController

- (instancetype)initWithPost:(HHClubPost *)post;

@property (nonatomic, strong) HHUpdatePostBlock updateBlock;

@end
