//
//  AppDelegate.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 9/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "AppDelegate.h"

#import "ConnectionsViewController.h"
#import "StyleViewController.h"
#import "MoveScaleImageViewController.h"
#import "MapAndLocationViewController.h"
#import "SharingViewController.h"
#import "AllFileViewController.h"
#import "ImageControllViewController.h"
#import "HomeViewController.h"
@implementation AppDelegate
@synthesize mainNav;
- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    UIViewController *homeViewController = [[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil] autorelease];
    UIViewController *viewController1 = [[[ConnectionsViewController alloc] initWithNibName:@"ConnectionsViewController" bundle:nil] autorelease];
    UIViewController *viewController2 = [[[StyleViewController alloc] initWithNibName:@"StyleViewController" bundle:nil] autorelease];
    UIViewController *viewController3 = [[[MapAndLocationViewController alloc] initWithNibName:@"MapAndLocationViewController" bundle:nil] autorelease];
    UIViewController *viewController4 = [[[SharingViewController alloc] initWithNibName:@"SharingViewController" bundle:nil] autorelease];
    UIViewController *viewController5 = [[[ImageControllViewController alloc] initWithNibName:@"ImageControllViewController" bundle:nil] autorelease];
    UIViewController *viewController6 = [[[AllFileViewController alloc] initWithNibName:@"AllFileViewController" bundle:nil] autorelease];
    
    self.mainNav = [[[UINavigationController alloc] initWithRootViewController:homeViewController] autorelease];
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = @[self.mainNav, viewController2, viewController3, viewController4, viewController5,viewController6];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    
    // Handle launching from a notification
	UILocalNotification *localNotif =
	[launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
		NSLog(@"Recieved Notification %@",localNotif);
	}
	
    return YES;
}
- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
	// Handle the notificaton when the app is running
	NSLog(@"Recieved Notification %@",notif);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
