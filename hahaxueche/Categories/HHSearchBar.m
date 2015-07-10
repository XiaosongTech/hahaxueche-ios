//
//  HHSearchBar.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/9/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHSearchBar.h"
#import "UIColor+HHColor.h"

#define kSearchBarPlaceholderColor [UIColor lightGrayColor]
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
        self.searchField.textColor = [UIColor whiteColor];
        self.searchField.tintColor = [UIColor HHOrange];
        self.searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"搜索教练", nil) attributes:@{NSForegroundColorAttributeName: kSearchBarPlaceholderColor, NSFontAttributeName:[UIFont fontWithName:@"SourceHanSansSC-Normal" size:11]}];
        [self.searchField setBackgroundColor:[UIColor darkGrayColor]];
        [self.searchField setBorderStyle:UITextBorderStyleRoundedRect];
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon_sm"]];
        [self.searchField setLeftView:iconImageView];
      
    }
}

- (void)cencel {
    [self resignFirstResponder];
}



@end
