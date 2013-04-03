//
//  FirstViewController.m
//  MyViewController
//
//  Created by Michelle Ramirez on 12/12/12.
//  Copyright (c) 2012 Michelle Ramirez. All rights reserved.
//

#import "MoveScaleImageViewController.h"
#import "ImageToDrag.h"
@interface MoveScaleImageViewController ()

@end

@implementation MoveScaleImageViewController
@synthesize canvas;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      //
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tapProfileImageRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)] autorelease];
    [tapProfileImageRecognizer setNumberOfTapsRequired:1];
    [tapProfileImageRecognizer setDelegate:self];
    [canvas addGestureRecognizer:tapProfileImageRecognizer];
    


}
-(void)tapped:(id)sender {
    NSLog (@"I am tapped! - %@", sender);
    
}


- (void)loadView
{
    [self setView:[[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease]];
    
	// Create view that will contain the dragging area
	canvas = [[UIView alloc] initWithFrame:CGRectMake(10, 50, 300, 300)];
	canvas.backgroundColor = [UIColor darkGrayColor];
    
	// Create an instance of the image to drag
	ImageToDrag *img = [[ImageToDrag alloc] initWithImage:[UIImage imageNamed:@"fashion-offer-pic2.png"] : self.canvas];
   // img.center = CGPointMake(110, 75);
    img.userInteractionEnabled = YES;
    //[img setTranslatesAutoresizingMaskIntoConstraints:YES];
    [canvas addSubview:img];
    [img release];
    
    // Create an instance of the image to drag
	ImageToDrag *img2 = [[ImageToDrag alloc] initWithImage:[UIImage imageNamed:@"fresh-food.png"] : self.canvas];
    // img.center = CGPointMake(110, 75);
    img2.userInteractionEnabled = YES;
    //[img2 setTranslatesAutoresizingMaskIntoConstraints:YES];
    [canvas addSubview:img2];
    [img2 release];

    
	[self.view  addSubview:canvas];
	[canvas release];
}

- (void)dealloc
{
    [canvas release];
	[super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
