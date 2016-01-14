//
//  AppDelegate.h
//  TheWeekendHi
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MeViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

{
    NSString* wbtoken;
    NSString* wbCurrentUserID;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MeViewController *viewController;
@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbRefreshToken;
@property (strong, nonatomic) NSString *wbCurrentUserID;


@end

