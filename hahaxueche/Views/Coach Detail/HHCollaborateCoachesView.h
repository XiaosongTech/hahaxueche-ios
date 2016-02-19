//
//  HHCollaborateCoachesView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/11/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHCollaborateCoachesView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *viewsArray;

- (void)setupCellWithCoaches:(NSArray *)coaches;

@end
