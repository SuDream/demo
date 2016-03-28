//
//  AppDelegate.m
//  itemXmppXF
//
//  Created by Moon on 16/3/26.
//  Copyright © 2016年 SuDream. All rights reserved.
//

#import "AppDelegate.h"
#import "v1.h"
#import "v2.h"
#import "taskLeft.h"

#import "mainVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
#if 0
    v1 *v=[[v1 alloc] init];
    v2 *vs=[[v2 alloc] init];
    
    UITabBarController  *tabbar=[[UITabBarController alloc] init];
    tabbar.viewControllers=@[v,vs];
    [self.window makeKeyAndVisible];
    self.window.rootViewController=tabbar;
    
    
#endif
    
#if  0
    mainVC *mian=[[mainVC alloc] init];
    UINavigationController  *nv=[[UINavigationController alloc] initWithRootViewController:mian];
    self.window.rootViewController=nv;
    
#endif
    
#if 1
    taskLeft *left=[[taskLeft alloc] init];
    UINavigationController *nv=[[UINavigationController alloc] initWithRootViewController:left];
    self.window.rootViewController=nv;
    
#endif
    
    
    
    
    
    
    
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
