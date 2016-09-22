//
//  HHCommentView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 9/22/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHCommentViewBlock)();

@interface HHCommentView : UIView

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) HHCommentViewBlock cancelBlock;
@property (nonatomic, strong) HHCommentViewBlock confirmBlock;

@end
