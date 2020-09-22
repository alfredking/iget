//
//  WBRequestType.h
//  Fenvo
//
//  Created by Neil on 15/8/30.
//  Copyright © 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ENUM(NSInteger, WBRequestURLType)
{
    WeiboSDKHttpRequestDemoTypeReturn = 0,
    WeiboSDKHttpRequestDemoTypeRequestForFriendsListOfUser,
    WeiboSDKHttpRequestDemoTypeRequestForFriendsUserIDListOfUser,
    WeiboSDKHttpRequestDemoTypeRequestForCommonFriendsListBetweenTwoUser,
    WeiboSDKHttpRequestDemoTypeRequestForBilateralFriendsListOfUser,
    WeiboSDKHttpRequestDemoTypeRequestForFollowersListOfUser,
    WeiboSDKHttpRequestDemoTypeRequestForFollowersUserIDListOfUser,
    WeiboSDKHttpRequestDemoTypeRequestForActiveFollowersListOfUser,
    WeiboSDKHttpRequestDemoTypeRequestForBilateralFollowersListOfUser,
    WeiboSDKHttpRequestDemoTypeRequestForFriendshipDetailBetweenTwoUser,
    WeiboSDKHttpRequestDemoTypeRequestForFollowAUser,
    WeiboSDKHttpRequestDemoTypeRequestForCancelFollowingAUser,
    WeiboSDKHttpRequestDemoTypeRequestForRemoveFollowerUser,
    WeiboSDKHttpRequestDemoTypeRequestForInviteBilateralFriend,
    WeiboSDKHttpRequestDemoTypeRequestForUserProfile,
    WeiboSDKHttpRequestDemoTypeRequestForStatusIDs,
    WeiboSDKHttpRequestDemoTypeRequestForRepostAStatus,
    WeiboSDKHttpRequestDemoTypeRequestForPostAStatus,
    WeiboSDKHttpRequestDemoTypeRequestForPostAStatusAndPic,
    WeiboSDKHttpRequestDemoTypeRequestForPostAStatusAndPicurl,
    WeiboSDKHttpRequestDemoTypeRequestForRenewAccessToken,
    WeiboSDKHttpRequestDemoTypeAddGameObject,
    WeiboSDKHttpRequestDemoTypeAddGameAchievementObject,
    WeiboSDKHttpRequestDemoTypeAddGameAchievementGain,
    WeiboSDKHttpRequestDemoTypeAddGameScoreGain,
    WeiboSDKHttpRequestDemoTypeRequestForGameScore,
    WeiboSDKHttpRequestDemoTypeRequestForFriendsGameScore,
    WeiboSDKHttpRequestDemoTypeRequestForGameAchievementGain,
};

const NSArray *__WBRequestURLType;
#define WBRequestURLTypeGet (__WBRequestURLType == nil ?__WBRequestURLType = [[NSArray alloc] initWithObjects:@"",kCATransitionFade,kCATransitionMoveIn,kCATransitionPush,kCATransitionReveal,@"cube",@"suckEffect",@"oglFlip",@"rippleEffect",nil] : __AnimationType)
#define WBRequestURLTypeString(type) ([WBRequestURLTypeGet objectAtIndex:type])// 枚举 to 字串
#define WBRequestURLTypeEnum(string) ([WBRequestURLTypeGet indexOfObject:string])// 字串 to 枚举

@interface WBRequestType : NSObject

@end
