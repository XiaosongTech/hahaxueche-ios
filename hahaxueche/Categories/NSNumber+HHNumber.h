//
//  NSNumber+HHNumber.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/13/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (HHNumber)

- (NSString *)generateMoneyString;

- (NSString *)generateMoneyStringWithoutOriginalNumber;

- (NSString *)generateLargeNumberString;

@end
