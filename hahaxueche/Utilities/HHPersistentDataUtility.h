//
//  HHPersistentDataUtility.h
//  hahaxueche
//
//  Created by Zixiao Wang on 31/03/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHPersistentDataUtility : NSObject

+ (HHPersistentDataUtility *)sharedManager;
- (void)saveDataWithDic:(NSDictionary *)dic key:(NSString *)key;
- (NSDictionary *)getDataWithKey:(NSString *)key;

@end
