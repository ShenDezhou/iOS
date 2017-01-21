//
//  AppDelegate.m
//  bjsubway
//
//  Created by apple on 14/11/30.
//  Copyright (c) 2014年 bangtech. All rights reserved.
//

#import "AppDelegate.h"
#import "Graph.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _rate = NOSTATUS;
    _willNotice = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    GraphList *g = malloc(sizeof(GraphList));
    _graphlist = [NSData dataWithBytesNoCopy:g length:sizeof(GraphList)];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    _graphlist = nil;
}

#pragma mark 接收本地通知时触发
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSDictionary *userInfo=notification.userInfo;
//    [userInfo writeToFile:@"/Users/kenshincui/Desktop/didReceiveLocalNotification.txt" atomically:YES];
    NSLog(@"didReceiveLocalNotification:The userInfo is %@",userInfo);
}
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    if (notificationSettings.types!=UIUserNotificationTypeNone) {
//        [self addLocalNotification];
    }
}


@end
