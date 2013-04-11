//
//  TextPlayViewController.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 10/4/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "TextPlayViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TextPlayViewController ()

@end

@implementation TextPlayViewController
@synthesize addText,enterText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
-(void) dealloc{
    [enterText release];
    [addText release];
    [super dealloc];
}
-(IBAction)addTransformText:(id)sender{
    
    //everything
    FXLabel *addedLabel = [[FXLabel alloc] initWithFrame:CGRectMake(20, 40, 150, 50)];
    [addedLabel setText:self.enterText.text];
    addedLabel.backgroundColor = [UIColor clearColor];
    addedLabel.font = [UIFont fontWithName:@"Helvetica Bold" size:41.0];
    addedLabel.shadowColor = [UIColor blackColor];
    addedLabel.shadowOffset = CGSizeZero;
    addedLabel.shadowBlur = 20.0f;
    addedLabel.innerShadowBlur = 2.0f;
    addedLabel.innerShadowColor = [UIColor yellowColor];
    addedLabel.innerShadowOffset = CGSizeMake(1.0f, 1.0f);
    addedLabel.gradientStartColor = [UIColor redColor];
    addedLabel.gradientEndColor = [UIColor yellowColor];
    addedLabel.gradientStartPoint = CGPointMake(0.0f, 0.5f);
    addedLabel.gradientEndPoint = CGPointMake(1.0f, 0.5f);
    addedLabel.oversampling = 2;
    addedLabel.userInteractionEnabled = TRUE;
    
    UIPanGestureRecognizer *gesture = [[[UIPanGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(labelDragged:)]autorelease];
	[addedLabel addGestureRecognizer:gesture];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)] autorelease];
    [pinchRecognizer setDelegate:self];
    [addedLabel addGestureRecognizer:pinchRecognizer];
    
    UIRotationGestureRecognizer *rotationRecognizer = [[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)] autorelease];
    [rotationRecognizer setDelegate:self];
    [addedLabel addGestureRecognizer:rotationRecognizer];
    [self.view addSubview:addedLabel];
    
}

- (void)labelDragged:(UIPanGestureRecognizer *)gesture
{
	FXLabel *label = (FXLabel *)gesture.view;
	CGPoint translation = [gesture translationInView:label];
    
	// move label
	label.center = CGPointMake(label.center.x + translation.x,
                               label.center.y + translation.y);
    
	// reset translation
	[gesture setTranslation:CGPointZero inView:label];
}
-(void)scale:(id)sender {
    NSLog(@"Pinching...");
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [[(UIPinchGestureRecognizer*)sender view] setTransform:newTransform];
    
    _lastScale = [(UIPinchGestureRecognizer*)sender scale];

}
-(void)rotate:(id)sender {
    NSLog(@"Rotating...");
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        _lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (_lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [[(UIPinchGestureRecognizer*)sender view] setTransform:newTransform];
    
    _lastRotation = [(UIRotationGestureRecognizer*)sender rotation];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ![gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]];
}
@end
