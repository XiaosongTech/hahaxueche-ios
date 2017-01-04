//
//  HHEventTrackingManager.h
//  hahaxueche
//
//  Created by Zixiao Wang on 11/13/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define homepage_free_trial_tapped @"homepage_free_trial_tapped"
#define homepage_group_purchase_tapped @"homepage_group_purchase_tapped"
#define homepage_online_support_tapped @"homepage_online_support_tapped"
#define homepage_phone_support_tapped @"homepage_phone_support_tapped"
#define homepage_driving_school_tapped @"homepage_driving_school_tapped"
#define homepage_coach_tapped @"homepage_coach_tapped"
#define homepage_advisor_tapped @"homepage_advisor_tapped"
#define homepage_strength_tapped @"homepage_strength_tapped"
#define homepage_process_tapped @"homepage_process_tapped"
#define home_page_viewed @"home_page_viewed"
#define find_coach_page_field_icon_tapped @"find_coach_page_field_icon_tapped"
#define find_coach_page_search_tapped @"find_coach_page_search_tapped"
#define find_coach_page_filter_tapped_tapped @"find_coach_page_filter_tapped_tapped"
#define find_coach_page_sort_tapped @"find_coach_page_sort_tapped"
#define find_coach_page_filter_personal_coach_tapped @"find_coach_page_filter_personal_coach_tapped"
#define find_coach_page_sort_personal_coach_tapped @"find_coach_page_sort_personal_coach_tapped"
#define find_coach_page_what_is_personal_coach_tapped @"find_coach_page_what_is_personal_coach_tapped"
#define find_coach_page_coach_tapped @"find_coach_page_coach_tapped"
#define find_coach_page_personal_coach_tapped @"find_coach_page_personal_coach_tapped"
#define find_coach_page_viewed @"find_coach_page_viewed"
#define coach_detail_page_price_detail_tapped @"coach_detail_page_price_detail_tapped"
#define coach_detail_page_free_trial_tapped @"coach_detail_page_free_trial_tapped"
#define coach_detail_page_follow_unfollow_tapped @"coach_detail_page_follow_unfollow_tapped"
#define coach_detail_page_like_unlike_tapped @"coach_detail_page_like_unlike_tapped"
#define coach_detail_page_comment_tapped @"coach_detail_page_comment_tapped"
#define coach_detail_page_share_coach_tapped @"coach_detail_page_share_coach_tapped"
#define coach_detail_page_share_coach_succeed @"coach_detail_page_share_coach_succeed"
#define coach_detail_page_field_tapped @"coach_detail_page_field_tapped"
#define coach_detail_page_purchase_tapped @"coach_detail_page_purchase_tapped"
#define coach_detail_page_viewed @"coach_detail_page_viewed"
#define personal_coach_detail_page_call_coach_tapped @"personal_coach_detail_page_call_coach_tapped"
#define personal_coach_detail_page_share_coach_tapped @"personal_coach_detail_page_share_coach_tapped"
#define personal_coach_detail_page_share_coach_succeed @"personal_coach_detail_page_share_coach_succeed"
#define personal_coach_detail_page_like_unlike_tapped @"personal_coach_detail_page_like_unlike_tapped"
#define personal_coach_detail_page_viewed @"personal_coach_detail_page_viewed"
#define club_page_group_purchase_tapped @"club_page_group_purchase_tapped"
#define club_page_online_test_tapped @"club_page_online_test_tapped"
#define club_page_viewed @"club_page_viewed"
#define article_detail_page_like_unlike_tapped @"article_detail_page_like_unlike_tapped"
#define article_detail_page_comment_tapped @"article_detail_page_comment_tapped"
#define article_detail_page_view_comment_tapped @"article_detail_page_view_comment_tapped"
#define article_detail_page_share_article_tapped @"article_detail_page_share_article_tapped"
#define article_detail_page_share_article_succeed @"article_detail_page_share_article_succeed"
#define article_detail_page_viewed @"article_detail_page_viewed"
#define my_page_pay_coach_status_tapped @"my_page_pay_coach_status_tapped"
#define my_page_my_coach_tapped @"my_page_my_coach_tapped"
#define my_page_my_followed_coach_tapped @"my_page_my_followed_coach_tapped"
#define my_page_my_course_tapped @"my_page_my_course_tapped"
#define my_page_my_advisor_tapped @"my_page_my_advisor_tapped"
#define my_page_online_support_tapped @"my_page_online_support_tapped"
#define my_page_FAQ_tapped @"my_page_FAQ_tapped"
#define my_page_rate_us_tapped @"my_page_rate_us_tapped"
#define my_page_version_check_tapped @"my_page_version_check_tapped"
#define my_page_refer_tapped @"my_page_refer_tapped"
#define my_page_viewed @"my_page_viewed"
#define refer_page_share_pic_tapped @"refer_page_share_pic_tapped"
#define refer_page_share_pic_succeed @"refer_page_share_pic_succeed"
#define refer_page_check_balance_tapped @"refer_page_check_balance_tapped"
#define refer_page_cash_tapped @"refer_page_cash_tapped"
#define refer_page_viewed @"refer_page_viewed"
#define pay_coach_status_page_comment_tapped @"pay_coach_status_page_comment_tapped"
#define pay_coach_status_page_comment_succeed @"pay_coach_status_page_comment_succeed"
#define pay_coach_status_page_pay_coach_tapped @"pay_coach_status_page_pay_coach_tapped"
#define pay_coach_status_page_pay_coach_succeed @"pay_coach_status_page_pay_coach_succeed"
#define pay_coach_status_page_i_tapped @"pay_coach_status_page_i_tapped"
#define pay_coach_status_page_viewed @"pay_coach_status_page_viewed"
#define purchase_confirm_page_viewed @"purchase_confirm_page_viewed"
#define purchase_confirm_page_purchase_button_tapped @"purchase_confirm_page_purchase_button_tapped"
#define my_coach_page_share_coach_tapped @"my_coach_page_share_coach_tapped"
#define my_coach_page_viewed @"my_coach_page_viewed"
#define my_coach_page_share_coach_succeed @"my_coach_page_share_coach_succeed"
#define online_test_page_viewed @"online_test_page_viewed"
#define online_test_page_order_tapped @"online_test_page_order_tapped"
#define online_test_page_random_tapped @"online_test_page_random_tapped"
#define online_test_page_simu_tapped @"online_test_page_simu_tapped"
#define online_test_page_my_lib_tapped @"online_test_page_my_lib_tapped"

#define home_page_online_test_tapped @"home_page_online_test_tapped"
#define home_page_course_one_tapped @"home_page_course_one_tapped"
#define home_page_platform_guard_tapped @"home_page_platform_guard_tapped"
#define home_page_refer_friends_tapped @"home_page_refer_friends_tapped"

#define my_page_contract_tapped @"my_page_contract_tapped"

#define upload_id_page_viewed @"upload_id_page_viewed"
#define upload_id_page_cancel_tapped @"upload_id_page_cancel_tapped"
#define upload_id_page_popup_cancel_tapped @"upload_id_page_popup_cancel_tapped"
#define upload_id_page_popup_confirm_tapped @"upload_id_page_popup_confirm_tapped"
#define upload_id_page_confirm_tapped @"upload_id_page_confirm_tapped"


#define sign_contract_page_viewed @"sign_contract_page_viewed"
#define sign_contract_check_box_checked @"sign_contract_check_box_checked"
#define sign_contract_check_box_unchecked @"sign_contract_check_box_unchecked"

#define my_contract_page_viewed @"my_contract_page_viewed"
#define my_contract_page_top_right_button_tapped @"my_contract_page_top_right_button_tapped"
#define my_contract_page_send_by_email_tapped @"my_contract_page_send_by_email_tapped"

#define home_page_voucher_popup_share_tapped @"home_page_voucher_popup_share_tapped"
#define home_page_banner_tapped @"home_page_banner_tapped"
#define home_page_voucher_popup_share_succeed @"home_page_voucher_popup_share_succeed"

#define my_page_course_guard_tapped @"my_page_course_guard_tapped"
#define find_coach_flying_envelop_tapped @"find_coach_flying_envelop_tapped"

#define club_page_flying_envelop_tapped @"club_page_flying_envelop_tapped"



@interface HHEventTrackingManager : NSObject

+ (HHEventTrackingManager *)sharedManager;

- (void)eventTriggeredWithId:(NSString *)eventId attributes:(NSDictionary *)attributes;

@end
