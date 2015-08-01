//
//  HHSearchBar.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/9/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHSearchBar.h"
#import "UIColor+HHColor.h"
#import "UIView+HHRect.h"
#import <QuartzCore/QuartzCore.h>

#define kSearchBarPlaceholderColor [UIColor darkGrayColor]
#define kSearchBarTextfieldBackgroundColor [UIColor whiteColor]

@implementation HHSearchBar


- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.subviews.count > 0) {
        UIView *subview = [self.subviews objectAtIndex:0];
        if (subview.subviews.count > 1) {
            self.searchField = subview.subviews[1];
        }
    }
    
    if(self.searchField) {
        self.backgroundColor = [UIColor clearColor];

        self.searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.searchField.textColor = [UIColor blackColor];
        self.searchField.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 25.0f);
        self.searchField.tintColor = [UIColor HHOrange];
        self.searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.searchField.placeholder = NSLocalizedString(@"搜索教练",nil);
        [self.searchField setBackgroundColor:[UIColor whiteColor]];
        [self.searchField setBorderStyle:UITextBorderStyleRoundedRect];
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon"]];
        [iconImageView setFrameWithSize:CGSizeMake(15.0f, 15.0f)];
        [self.searchField setLeftView:iconImageView];
        self.searchField.rightViewMode = UITextFieldViewModeWhileEditing;
        [self.searchField becomeFirstResponder];

    }
}



@end
