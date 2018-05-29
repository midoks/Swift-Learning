//
//  AppDelegate.m
//  InterfaceSwitching
//
//  Created by midoks on 2018/5/25.
//  Copyright © 2018年 midoks. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
//    NSLog(@"applicationDidFinishLaunching");
    [self setUpStatusItem];
    [JRLoginItemUtil addCurrentApplicatonToLoginItems];
    
    [self listenCode];
}

- (void)setUpStatusItem {
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [_statusItem setImage:[NSImage imageNamed:@"StatusIcon"]];
    [_statusItem setHighlightMode:YES];
    
    [_statusItem setAction:@selector(onStatusItemClicked:)];
//    [_statusItem setTarget:self];
    
//    [_statusItem setMenu:_statusBarItemMenu];
}

- (void)onStatusItemClicked:(id)sender {
    
    [JRKeyboardShortcutUtil minimizeAllWindows];
    //[_statusItem setMenu:_statusBarItemMenu];
}


-(void)listenCode {
    CFRunLoopRef theRL = CFRunLoopGetCurrent();
    CFMachPortRef keyUpEventTap = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap ,kCGEventTapOptionListenOnly,CGEventMaskBit(kCGEventKeyUp) | CGEventMaskBit(kCGEventFlagsChanged),&myCallBack,NULL);
    CFRunLoopSourceRef keyUpRunLoopSourceRef = CFMachPortCreateRunLoopSource(NULL, keyUpEventTap, 0);
    CFRelease(keyUpEventTap);
    CFRunLoopAddSource(theRL, keyUpRunLoopSourceRef, kCFRunLoopDefaultMode);
    CFRelease(keyUpRunLoopSourceRef);
}

CGEventRef myCallBack(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *userInfo)
{
    
    UniCharCount actualStringLength = 0;
    UniChar inputString[128];
    CGEventKeyboardGetUnicodeString(event, 128, &actualStringLength, inputString);
    NSString* inputedString = [[NSString alloc] initWithBytes:(const void*)inputString length:actualStringLength encoding:NSUTF8StringEncoding];
    
    CGEventFlags flag = CGEventGetFlags(event);
    NSLog(@"inputed string:%@, flags:%lld", inputedString, flag);
    return event;
}


@end
