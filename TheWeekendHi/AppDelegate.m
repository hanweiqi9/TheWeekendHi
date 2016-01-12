//
//  AppDelegate.m
//  TheWeekendHi
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) UITabBarController *tabBarVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //UITabBarController
    self.tabBarVC = [[UITabBarController alloc] init];
    
    //创建被tabBarVC管理的试图控制器
    //主页
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *mainNav = mainStoryBoard.instantiateInitialViewController;
    mainNav.tabBarItem.image = [UIImage imageNamed:@"ft_home_normal_ic"];
    UIImage *mainselectImage = [UIImage imageNamed:@"ft_home_selected_ic"];
    //设置tabBar设置选中图片按照图片原始状态显示
    mainNav.tabBarItem.selectedImage = [mainselectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mainNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    //发现
    
    UIStoryboard *disStoryBoard = [UIStoryboard storyboardWithName:@"dis" bundle:nil];
    UINavigationController *disNav = disStoryBoard.instantiateInitialViewController;
    disNav.tabBarItem.image = [UIImage imageNamed:@"ft_found_normal_ic"];
    UIImage *disSelectImage = [UIImage imageNamed:@"ft_found_selected_ic"];
    //设置tabBar设置选中图片按照图片原始状态显示
    disNav.tabBarItem.selectedImage = [disSelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    disNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    
//    UIStoryboard *discoverStoryBoard = [UIStoryboard storyboardWithName:@"discover" bundle:nil];
//    UINavigationController *discoverNav = discoverStoryBoard.instantiateInitialViewController;
//    discoverNav.tabBarItem.image = [UIImage imageNamed:@"ft_found_normal_ic"];
//    //设置图片，选中的时候的图片按照原始状态显示
//    UIImage *disselectImage = [UIImage imageNamed:@"ft_found_selected_ic"];
//    discoverNav.tabBarItem.selectedImage = [disselectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    
//    discoverNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    //我的
    UIStoryboard *mineStoryBoard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    UINavigationController *mineNav = mineStoryBoard.instantiateInitialViewController;
    mineNav.tabBarItem.image = [UIImage imageNamed:@"ft_person_normal_ic"];
    //设置图片，选中时按照原始图片显示
    UIImage *mineselectImage = [UIImage imageNamed:@"ft_person_selected_ic"];
    mineNav.tabBarItem.selectedImage = [mineselectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

    
    //添加被管理的试图控制器
    self.tabBarVC.viewControllers =@[mainNav,disNav, mineNav];
    
   self.tabBarVC.tabBar.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = self.tabBarVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
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
