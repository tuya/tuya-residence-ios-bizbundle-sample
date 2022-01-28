//
//  AppDelegate.m
//  TuyaSmartResidenceSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "AppDelegate.h"

#define APP_KEY @"<#AppKey#>"
#define APP_SECRET_KEY @"<#SecretKey#>"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[TuyaSmartSDK sharedInstance] startWithAppKey:APP_KEY secretKey:APP_SECRET_KEY];
    
#ifdef DEBUG
    // Enable debug mode, which allows you to see logs.
    [[TuyaSmartSDK sharedInstance] setDebugMode:YES];
#else
#endif

    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
        
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([TuyaSmartUser sharedInstance].isLogin) {
        
        UIStoryboard *homeSB = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        UINavigationController *nav = [homeSB instantiateInitialViewController];
        self.window.rootViewController = nav;
        
    } else {
        
        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *nav = [mainSB instantiateInitialViewController];
        self.window.rootViewController = nav;
        
    }
    
    [[UIApplication sharedApplication] delegate].window = self.window;
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
