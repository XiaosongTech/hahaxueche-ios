//
//  HHHomePageItemsView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 28/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHHomePageItemsView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHHomePageTapView.h"

@implementation HHHomePageItemsView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        __weak HHHomePageItemsView *weakSelf = self;
        for (int i = 0; i < ItemTypeCount; i++) {
            HHHomePageTapView *tapView = nil;
            
            switch (i) {
                case ItemTypeGroupPurchase: {
                    tapView = [[HHHomePageTapView alloc] initWithImage:[UIImage imageNamed:@"ic_salewarn"] title:@"限时团购"];
                    [self addSubview:tapView];
                } break;
                    
                case ItemTypeOnlineTest: {
                    tapView = [[HHHomePageTapView alloc] initWithImage:[UIImage imageNamed:@"ic_test"] title:@"在线题库"];
                    [self addSubview:tapView];
                    
                } break;
                    
                    
                case ItemTypePeifu: {
                    tapView = [[HHHomePageTapView alloc] initWithImage:[UIImage imageNamed:@"ic_peifubaby"] title:@"赔付宝"];
                    [self addSubview:tapView];
                    
                } break;
                    
                case ItemTypePlatformGuard: {
                    tapView = [[HHHomePageTapView alloc] initWithImage:[UIImage imageNamed:@"ic_safeguard"] title:@"平台保障"];
                    [self addSubview:tapView];
                    
                } break;
                    
                case ItemTypeProcess: {
                    tapView = [[HHHomePageTapView alloc] initWithImage:[UIImage imageNamed:@"ic_flow"] title:@"学车流程"];
                    [self addSubview:tapView];
                    
                } break;
                    
                case ItemTypeReferFriends: {
                    tapView = [[HHHomePageTapView alloc] initWithImage:[UIImage imageNamed:@"ic_recommendation"] title:@"推荐好友"];
                    [self addSubview:tapView];
                    
                } break;
                    
                case ItemTypeOnlineSupport: {
                    tapView = [[HHHomePageTapView alloc] initWithImage:[UIImage imageNamed:@"ic_customerservice"] title:@"在线客服"];
                    [self addSubview:tapView];
                    
                } break;
                    
                case ItemTypeCallSupport: {
                    tapView = [[HHHomePageTapView alloc] initWithImage:[UIImage imageNamed:@"ic_phone"] title:@"电话咨询"];
                    [self addSubview:tapView];
                    
                } break;
                    
                
                    
                default:
                    break;
            }
            
            tapView.actionBlock = ^() {
                if (weakSelf.itemBlock) {
                    weakSelf.itemBlock(i);
                }
            };
            [tapView makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.top).offset((i/4) * 80.0f);
                make.centerX.equalTo(self.centerX).multipliedBy(((i%4) * 2 + 1)/4.0f);
                make.width.equalTo(self.width).multipliedBy(1.0f/4.0f);
                make.height.equalTo(self.height).multipliedBy(0.5f);
            }];
            
        }
        
    }
    return self;
    
}

@end
