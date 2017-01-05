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
#define kAPIUserFollows @"users/follows/"
#define kAPIToken @"sessions/access_token/valid"

#pragma mark Payment
#define kAPICharges @"charges"

#pragma mark Student

#define kAPIStudentAvatar @"students/%@/avatar"
#define kAPIStudentFollows @"users/follows/%@"
#define kAPIStudentTryCoach @"students/trial"
#define kAPIStudentPurchasedService @"students/purchased_service"
#define kAPIStudent @"students/%@"
#define kAPIBestMatchCoach @"students/best_match_coach"
#define kAPIBookSchedule @"students/%@/%@/schedule"
#define kAPIStudentSchedule @"students/%@/course_schedules"
#define kAPIStudentUnschedule @"students/%@/%@/unschedule"
#define kAPIStudentReviewSchedule @"students/%@/%@/review_schedule_event"
#define kAPIStudentBonusSummary @"students/%@/referal_bonus_summary"
#define kAPIStudentReferees @"students/%@/referees"
#define kAPIStudentWithdrawTransacion @"bank_cards/withdraw_records"
#define kAPIGroupPurchase @"activity_users"
#define kAPILikeCoach @"students/%@/like/%@"
#define kAPILikePersonalCoach @"students/%@/liked_training_partners/%@"
#define kAPIEvents @"events"
#define kAPIBankCards @"bank_cards"
#define kAPIStudentWithdraw @"students/%@/withdraw"
#define kAPIAdvisor @"employees/advisers"
#define kAPIValidVouchers @"students/%@/vouchers"
#define kAPIVouchers @"vouchers"
#define kAPIStudentIDCard @"students/%@/id_card"
#define kAPIStudentAgreement @"students/%@/agreement"
#define kAPIStudentSendAgreement @"students/%@/agreement_mail"
#define kAPIStudentTestResult @"students/%@/exam_results"


#pragma mark Coach

#define kAPICoaches @"coaches"
#define kAPICoach @"coaches/%@"
#define kAPIPersonalCoaches @"training_partners"
#define kAPIPersonalCoach @"training_partners/%@"

#pragma mark ClubPost

#define kAPIClubPosts @"articles"
#define kAPIClubPost @"articles/%@"
#define kAPIClubPostLike @"students/%@/liked_articles/%@"
#define kAPIClubPostComment @"articles/%@/comments"
#define kAPIClubPostHeadLine @"articles/headline"

#pragma mark Constants

#define kAPIConstantsPath @"constants"

#define kAPIAddressBook @"address_books"

#endif /* APIPaths_h */
