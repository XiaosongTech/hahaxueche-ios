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
        self.searchField.textColor = [UIColor blackColor];
        self.searchField.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 25.0f);
        self.searchField.tintColor = [UIColor HHOrange];
        self.searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"搜索教练", nil) attributes:@{NSForegroundColorAttributeName: kSearchBarPlaceholderColor, NSFontAttributeName:[UIFont fontWithName:@"SourceHanSansSC-Normal" size:11]}];
        [self.searchField setBackgroundColor:[UIColor whiteColor]];
        [self.searchField setBorderStyle:UITextBorderStyleRoundedRect];
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon"]];
        [iconImageView setFrameWithSize:CGSizeMake(15.0f, 15.0f)];
        [self.searchField setLeftView:iconImageView];
        
        self.searchField.rightViewMode = UITextFieldViewModeWhileEditing;
        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearButton sizeToFit];
        [clearButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [clearButton setTitle:@"取消" forState:UIControlStateNormal];
        [clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        clearButton.titleLabel.font = [UIFont fontWithName:@"SourceHanSansSC-Normal" size:12];
        [clearButton addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
        [self.searchField setRightView:clearButton];
      
    }
}

- (void)cancelSearch {
    self.searchField.text = @"";
    [self resignFirstResponder];
}


@end
