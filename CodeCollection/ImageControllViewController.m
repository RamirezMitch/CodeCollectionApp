//
//  ImageControllViewController.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 28/2/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "ImageControllViewController.h"
#import "MoveScaleImageViewController.h"
#import "AppDelegate.h"

@interface ImageControllViewController ()

@end

@implementation ImageControllViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Image", @"Image");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)imageMoveScale:(id)sender{
    MoveScaleImageViewController *movescaleView =[[MoveScaleImageViewController alloc]initWithNibName:@"MoveScaleImageViewController" bundle:nil];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.mainNav pushViewController:movescaleView animated:YES];
    [movescaleView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
