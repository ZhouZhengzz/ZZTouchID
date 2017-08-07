//
//  TouchIDVerify.m
//  ZZTouchID
//
//  Created by zhouzheng on 2017/8/4.
//  Copyright © 2017年 周正. All rights reserved.
//

#import "TouchIDVerify.h"


@implementation TouchIDVerify

- (BOOL)deviceIsCanEvaluatePolicy {
    
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    
    return [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error];
}

- (void)touchIDVerifyCompletion:(void (^)(BOOL, BOOL, NSError * _Nullable))completion {

    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    NSString *localizedReason = @"Touch ID Test";
    //使用canEvaluatePolicy判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        //支持指纹验证
        completion(YES, NO, nil);
        
        //开始验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:localizedReason reply:^(BOOL success, NSError * _Nullable error) {

            if (success) {
                //验证成功，主线程处理UI
                if ([context evaluatedPolicyDomainState] != nil) {
                    NSLog(@"指纹验证成功");
                }else{
                    NSLog(@"TOUCH ID 解锁成功"); //系统密码输入界面
                }
                
                completion(YES, success, nil);
            
            }else {
                //验证失败
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorAuthenticationFailed: {
                        // Authentication was not successful, because user failed to provide valid credentials
                        NSLog(@"授权失败"); // -1 连续三次指纹识别错误
                    }
                        break;
                    case LAErrorUserCancel: {
                        // Authentication was canceled by user (e.g. tapped Cancel button)
                        NSLog(@"用户取消验证Touch ID"); // -2 在TouchID对话框中点击了取消按钮
                    }
                        break;
                    case LAErrorUserFallback: {
                        // Authentication was canceled, because the user tapped the fallback button (Enter Password)
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"用户选择输入密码，切换主线程处理"); // -3 在TouchID对话框中点击了输入密码按钮
                        }];
                    }
                        break;
                    case LAErrorSystemCancel: {
                        // Authentication was canceled by system (e.g. another application went to foreground)
                        NSLog(@"取消授权，如其他应用切入，用户自主"); // -4 TouchID对话框被系统取消，例如按下Home或者电源键
                    }
                        break;
                    case LAErrorPasscodeNotSet: {
                        // Authentication could not start, because passcode is not set on the device.
                        NSLog(@"设备系统未设置密码"); // -5
                    }
                        break;
                    case LAErrorTouchIDNotAvailable: {
                        // Authentication could not start, because Touch ID is not available on the device
                        NSLog(@"设备未设置Touch ID"); // -6
                    }
                        break;
                    case LAErrorTouchIDNotEnrolled: {
                        // Authentication could not start, because Touch ID has no enrolled fingers
                        NSLog(@"用户未录入指纹"); // -7
                    }
                        break;
                        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
                    case LAErrorTouchIDLockout: {
                        //Authentication was not successful, because there were too many failed Touch ID attempts and Touch ID is now locked. Passcode is required to unlock Touch ID, e.g. evaluating LAPolicyDeviceOwnerAuthenticationWithBiometrics will ask for passcode as a prerequisite 用户连续多次进行Touch ID验证失败，Touch ID被锁，需要用户输入密码解锁，先Touch ID验证密码
                        NSLog(@"Touch ID被锁，需要用户输入密码解锁"); // -8 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                    }
                        break;
                    case LAErrorAppCancel: {
                        // Authentication was canceled by application (e.g. invalidate was called while authentication was in progress) 如突然来了电话，电话应用进入前台，APP被挂起啦");
                        NSLog(@"用户不能控制情况下APP被挂起"); // -9
                    }
                        break;
                    case LAErrorInvalidContext: {
                        // LAContext passed to this call has been previously invalidated.
                        NSLog(@"LAContext传递给这个调用之前已经失效"); // -10
                    }
                        break;
#else
#endif
                    default: {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"其他情况，切换主线程处理");
                        }];
                    }
                        break;
                    
                }
                
                completion(YES, success, error);
            }
        }];
        
    }else {
        //不支持指纹识别，LOG出错误详情
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled: {
                // Authentication could not start, because Touch ID has no enrolled fingers.
                NSLog(@"设备Touch ID不可用，用户未录入");
            }
                break;
            case LAErrorPasscodeNotSet: {
                // Authentication could not start, because passcode is not set on the device.
                NSLog(@"系统未设置密码");
            }
                break;
            default: {
                NSLog(@"TouchID not available");
            }
                break;
        }
        
        NSLog(@"%@",error.localizedDescription);
        
        completion(NO, NO, error);
    }

}

@end
