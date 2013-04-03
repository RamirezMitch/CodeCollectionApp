//
//  SecondViewController.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 9/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "StyleViewController.h"
#import "ItemViewController1.h"
#import "ItemViewController2.h"
#import "ItemViewController3.h"
#import "ItemViewController4.h"
#import "AppDelegate.h"
#import "ViewController.h"

@interface StyleViewController ()

@end

@implementation StyleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Items", @"Items");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)showDTable:(id)sender{
    ItemViewController1 *view1 =[[ItemViewController1 alloc]initWithNibName:@"ItemViewController1" bundle:nil];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.mainNav pushViewController:view1 animated:YES];
    [view1 release];
}
-(IBAction)showDCollection:(id)sender{
    ItemViewController2 *view2 =[[ItemViewController2 alloc]init];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.mainNav pushViewController:view2 animated:YES];
    [view2 release];
}
-(IBAction)showPageControl:(id)sender{
    ItemViewController3 *view3 =[[ItemViewController3 alloc]init];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.mainNav pushViewController:view3 animated:YES];
    [view3 release];
}
-(IBAction)showPageSheet:(id)sender{
    ItemViewController4 *view4 =[[ItemViewController4 alloc]init];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.mainNav pushViewController:view4 animated:YES];
    [view4 release];
}
@end
