//
//  AllFileViewController.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 28/2/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "AllFileViewController.h"

@interface AllFileViewController ()

@end

@implementation AllFileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"File", @"File");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];

    }
    return self;
}

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
