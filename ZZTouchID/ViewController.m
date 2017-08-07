//
//  ViewController.m
//  ZZTouchID
//
//  Created by zhouzheng on 16/5/20.
//  Copyright © 2016年 周正. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "TouchIDVerify.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *touchIDView;
@property (weak, nonatomic) IBOutlet UISwitch *touchIDSwitch;
- (IBAction)switchAction:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
- (IBAction)logoutBtnClick:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"accountID"] == nil) {
        //当前为未登录状态
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    BOOL isOn = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SwitchIsOn"] boolValue];
    _touchIDSwitch.on = isOn;
}

#pragma mark - 退出登录
- (IBAction)logoutBtnClick:(UIButton *)sender {
    
    //清除登录状态
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accountID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"accountID"] == nil) {
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

#pragma mark - Touch ID 开启与否
- (IBAction)switchAction:(UISwitch *)sender {
    
    TouchIDVerify *touchid = [[TouchIDVerify alloc] init];
    
    if ([_touchIDSwitch isOn]) {
        //开
        [touchid touchIDVerifyCompletion:^(BOOL canEvaluatePolicy, BOOL isSuccess, NSError * _Nullable error) {
            if (canEvaluatePolicy) {
                if (isSuccess) {
                    //验证成功，记录switch状态、TouchID
                    //注意：TouchID对应的value建议使用一些唯一标识（例如账户id、设备号等等按一定规则拼接并且加密处理）
                    //我这里只是简单的存到本地，实际开发中还应该将自定义的TouchID与账户进行绑定
                    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                    [userDefault setObject:@"123" forKey:@"TouchID"];
                    [userDefault setObject:@"1" forKey:@"SwitchIsOn"];
                    [userDefault synchronize];
                }
            }
        }];
    }else {
        //关
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault removeObjectForKey:@"TouchID"];
        [userDefault setObject:@"0" forKey:@"SwitchIsOn"];
        [userDefault synchronize];
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
