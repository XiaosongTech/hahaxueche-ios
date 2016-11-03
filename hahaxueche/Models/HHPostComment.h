//
//  HHPostComment.h
//  hahaxueche
//
//  Created by Zixiao Wang on 03/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHPostComment : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *studentId;
@property (nonatomic, copy) NSString *studentName;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSDate *createdAt;
@property (nonatomic, copy) NSString *avatar;


- (NSString *)getShareUrl;
- (NSString *)getPostUrl;

@end
