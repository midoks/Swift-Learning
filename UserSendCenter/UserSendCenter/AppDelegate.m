//
//  AppDelegate.m
//  UserSendCenter
//
//  Created by midoks on 15/1/27.
//  Copyright (c) 2015年 midoks. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () <NSUserNotificationCenterDelegate>

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate


#pragma mark 用户通知中心
- (void)userNotificationCenter:(NSUserNotificationCenter *)center didDeliverNotification:(NSUserNotification *)notification
{
    NSLog(@"通知已经递交！");
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification
{
    NSLog(@"用户点击了通知！");
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
    //用户中心决定不显示该条通知(如果显示条数超过限制或重复通知等)，returen YES;强制显示
    return YES;
}

-(void)userCenter:(NSString *)content
{
    //删除已经显示过的通知(已经存在用户的通知列表中的)
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
    //删除已经在执行的通知(比如那些循环递交的通知)
    for (NSUserNotification *notify in [[NSUserNotificationCenter defaultUserNotificationCenter] scheduledNotifications])
    {
        [[NSUserNotificationCenter defaultUserNotificationCenter] removeScheduledNotification:notify];
    }
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"通知中心";
    //notification.subtitle = @"小标题";
    notification.informativeText = content;
    
    //设置通知的代理
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:notification];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self userCenter:@"test ok"];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
