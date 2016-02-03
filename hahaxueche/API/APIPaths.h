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



#pragma mark Student

#define kAPIStudentAvatar @"students/%@/avatar"


#pragma mark Coach

#define kAPICoaches @"coaches"


#pragma mark Constants

#define kAPIConstantsPath @"constants"

#endif /* APIPaths_h */
