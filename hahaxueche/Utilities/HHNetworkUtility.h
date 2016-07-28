//
//  HHNetworkUtility.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/28/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHNetworkUtility : NSObject

+ (HHNetworkUtility *)sharedManager;
- (void)monitorNetwork;

@end
