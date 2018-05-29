//
//  AppDelegate.h
//  InterfaceSwitching
//
//  Created by midoks on 2018/5/25.
//  Copyright © 2018年 midoks. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JRKeyboardShortcutUtil.h"
#import "JRLoginItemUtil.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,NSWindowDelegate>


@property (nonatomic, strong) NSStatusItem *statusItem;
@property (weak) IBOutlet NSMenu *statusBarItemMenu;


@end

