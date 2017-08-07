//
//  LoginViewController.m
//  ZZTouchID
//
//  Created by zhouzheng on 2017/8/7.
//  Copyright © 2017年 周正. All rights reserved.
//

#import "LoginViewController.h"
#import "TouchIDVerify.h"

@interface LoginViewController ()
{
    TouchIDVerify *_touchID;
}

@property (weak, nonatomic) IBOutlet UITextField *accountNumTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *touchIDBtn;
- (IBAction)touchIDBtnClick:(UIButton *)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.view.backgroundColor = [UIColor whiteColor];
    
    _touchIDBtn.hidden = NO;
    
    _touchID = [[TouchIDVerify alloc] init];
    if (![_touchID deviceIsCanEvaluatePolicy] || [[NSUserDefaults standardUserDefaults] objectForKey:@"TouchID"] == nil) {
        //设备不支持TouchID或者用户还没有绑定TouchID，不显示使用TouchID登录
        _touchIDBtn.hidden = YES;
    }
    if ([_touchID deviceIsCanEvaluatePolicy] && [[NSUserDefaults standardUserDefaults] objectForKey:@"TouchID"] != nil) {
        //设备支持TouchID并且用户已经绑定TouchID，默认使用TouchID登录
        [self touchIDBtnClick:_touchIDBtn];
    }
    
}

#pragma mark - 账号密码登录
- (IBAction)loginBtnClick:(UIButton *)sender {
    //默认账号密码都为123
    if ([_accountNumTF.text isEqualToString:@"123"] && [_passwordTF.text isEqualToString:@"123"]) {
        //登录成功
        [self loginSuccess];
    }
    
}

#pragma mark - TouchID登录
- (IBAction)touchIDBtnClick:(UIButton *)sender {
    
    __weak typeof(self)weakself = self;
    [_touchID touchIDVerifyCompletion:^(BOOL canEvaluatePolicy, BOOL isSuccess, NSError * _Nullable error) {
        if (canEvaluatePolicy) {
            if (isSuccess) {
                //touchID验证成功
                //实际开发中，这里结合也无需求做处理
                [weakself loginSuccess];
            }
        }
    }];
}

//登录成功，记录登录状态
- (void)loginSuccess {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@"123" forKey:@"accountID"];
    [userDefault synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
