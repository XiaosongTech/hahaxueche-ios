//
//  APIPaths.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/8/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#ifndef APIPaths_h
#define APIPaths_h

#pragma mark User Auth

#define kAPISendVeriCodePath @"send_auth_token"
#define kAPIUserPath @"users"
#define kAPIStudentPath @"students/%@"
#define kAPILoginPath @"sessions"
#define kAPILogoutPath @"sessions/%@"
#define kAPIResetPWDPath @"users/reset_password"
#define kAPIUserReviews @"users/reviews/%@"

#pragma mark Payment
#define kAPICharges @"charges"

#pragma mark Student

#define kAPIStudentAvatar @"students/%@/avatar"
#define kAPIStudentFollows @"users/follows/%@"
#define kAPIStudentTryCoach @"students/trial/%@"
#define kAPIStudentPurchasedService @"students/purchased_service"
#define kAPIStudent @"students/%@"

#pragma mark Coach

#define kAPICoaches @"coaches"
#define kAPICoach @"coaches/%@"


#pragma mark Constants

#define kAPIConstantsPath @"constants"

#endif /* APIPaths_h */
