//
//  TouchIDVerify.h
//  ZZTouchID
//
//  Created by zhouzheng on 2017/8/4.
//  Copyright © 2017年 周正. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface TouchIDVerify : NSObject


/**
 判断设备是否支持TouchID

 @return YES or NO
 */
- (BOOL)deviceIsCanEvaluatePolicy;

/**
 Touch ID 验证

 @param completion 完成回调（canEvaluatePolicy 判断设备是否支持TouchID，isSuccess 指纹或者密码是否正确，error 报错信息）
 */
- (void)touchIDVerifyCompletion:(void(^_Nullable)(BOOL canEvaluatePolicy, BOOL isSuccess, NSError * _Nullable error))completion;

@end
