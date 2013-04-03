//
//  AppDelegate.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 9/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;
@property (retain, nonatomic) UINavigationController *mainNav;
@end
