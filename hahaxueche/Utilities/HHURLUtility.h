//
//  HHURLUtility.h
//  hahaxueche
//
//  Created by Zixiao Wang on 17/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHURLUtility : NSObject

+ (HHURLUtility *)sharedManager;
- (NSString *)generateShortURLWithOriginalURL:(NSString *)string;

@end
