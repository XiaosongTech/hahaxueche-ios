//
//  HHCollaborateCoachesView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/11/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHPeerCoachActionBlock)(NSInteger index);

@interface HHCollaborateCoachesView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *viewsArray;
@property (nonatomic, strong) HHPeerCoachActionBlock peerCoachTappedAction;

- (void)setupCellWithCoaches:(NSArray *)coaches;

@end
