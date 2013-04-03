//
//  MapAndLocationViewController.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 28/2/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "MapAndLocationViewController.h"

@interface MapAndLocationViewController ()

@end

@implementation MapAndLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Map", @"Map");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
