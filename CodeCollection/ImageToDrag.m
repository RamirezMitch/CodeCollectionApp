//
//  ImageToDrag.m
//
//  Created by John on 1/11/11.
//  Copyright iOSDeveloperTips.com All rights reserved.
//

#import "ImageToDrag.h"

@implementation ImageToDrag
@synthesize canvasView;
- (id)initWithImage:(UIImage *)image :(UIView *)parentView;
{
	if (self = [super initWithImage:image])
		self.userInteractionEnabled = YES;
    self.canvasView = parentView;
    
    if (!_marque) {
        _marque = [[CAShapeLayer layer] retain];
        _marque.fillColor = [[UIColor clearColor] CGColor];
        _marque.strokeColor = [[UIColor redColor] CGColor];
        _marque.lineWidth = 2.0f;
        _marque.lineJoin = kCALineJoinRound;
        _marque.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:10],[NSNumber numberWithInt:5], nil];
        _marque.bounds = CGRectMake(self.frame.origin.x, self.frame.origin.y, 0, 0);
        _marque.position = CGPointMake(self.frame.origin.x + self.canvasView.frame.origin.x, self.frame.origin.y + self.canvasView.frame.origin.y);
    }
    [[self layer] addSublayer:_marque];
    
    UITapGestureRecognizer *tapProfileImageRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)] autorelease];
    [tapProfileImageRecognizer setNumberOfTapsRequired:1];
    [tapProfileImageRecognizer setDelegate:self];
    [self addGestureRecognizer:tapProfileImageRecognizer];
    
    /*UIPanGestureRecognizer *panRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)] autorelease];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [self.canvasView addGestureRecognizer:panRecognizer];*/
    
    UIPinchGestureRecognizer *pinchRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)] autorelease];
    [pinchRecognizer setDelegate:self];
    [self addGestureRecognizer:pinchRecognizer];
    
    UIRotationGestureRecognizer *rotationRecognizer = [[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)] autorelease];
    [rotationRecognizer setDelegate:self];
    [self addGestureRecognizer:rotationRecognizer];
    
	return self;
}

-(void)showOverlayWithFrame:(CGRect)frame {
    
    if (![_marque actionForKey:@"linePhase"]) {
        CABasicAnimation *dashAnimation;
        dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
        [dashAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
        [dashAnimation setToValue:[NSNumber numberWithFloat:15.0f]];
        [dashAnimation setDuration:0.5f];
        [dashAnimation setRepeatCount:HUGE_VALF];
        [_marque addAnimation:dashAnimation forKey:@"linePhase"];
    }
    
    _marque.bounds = CGRectMake(frame.origin.x, frame.origin.y, 0, 0);
    _marque.position = CGPointMake(frame.origin.x + self.canvasView.frame.origin.x, frame.origin.y + self.canvasView.frame.origin.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, frame);
    [_marque setPath:path];
    CGPathRelease(path);
    
    _marque.hidden = NO;
    
}

-(void)scale:(id)sender {
    NSLog(@"Pinching...");
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform currentTransform = self.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [self setTransform:newTransform];
    
    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
     NSLog (@"Scale: %@ --- ScaleBounds :x- %d y- %d w-%f h-%f",self, (int)self.bounds.origin.x, (int)self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    [self showOverlayWithFrame:self.frame];
}

-(void)rotate:(id)sender {
       NSLog(@"Rotating...");
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        _lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (_lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    CGAffineTransform currentTransform = self.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [self setTransform:newTransform];
    
    _lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
      NSLog (@"RotateBounds :x- %d y- %d w-%f h-%f", (int)self.bounds.origin.x, (int)self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    [self showOverlayWithFrame:self.frame];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ![gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]];
}
-(void)move:(id)sender {
        NSLog(@"Moving...");
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.canvasView];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _firstX = [self center].x;
        _firstY = [self center].y;
    }
    
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    
    [self setCenter:translatedPoint];
    [self showOverlayWithFrame:self.frame];
}

-(void)tapped:(id)sender {
      _marque.hidden = YES;
       NSLog (@"Image tapped! %@", self.canvasView);
     NSLog (@"TapBounds :x- %d y- %d w-%2f h-%2f", (int)self.bounds.origin.x, (int)self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
}

- (void)dealloc
{
     [_marque release];
    [canvasView release];
    [super dealloc];
}
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	// When a touch starts, get the current location in the view
	currentPoint = [[touches anyObject] locationInView:self];
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
     NSLog (@"MoveBounds :x- %d y- %d w-%f h-%f", (int)self.bounds.origin.x, (int)self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
	// Get active location upon move
	CGPoint activePoint = [[touches anyObject] locationInView:self];

	// Determine new point based on where the touch is now located
	CGPoint newPoint = CGPointMake(self.center.x + (activePoint.x - currentPoint.x),
                                 self.center.y + (activePoint.y - currentPoint.y));

	//--------------------------------------------------------
	// Make sure we stay within the bounds of the parent view
	//--------------------------------------------------------
  float midPointX = CGRectGetMidX(self.bounds);
	// If too far right...
  if (newPoint.x > self.canvasView.bounds.size.width  - midPointX)
  	newPoint.x = self.canvasView.bounds.size.width - midPointX;
	else if (newPoint.x < midPointX) 	// If too far left...
  	newPoint.x = midPointX;
  
	float midPointY = CGRectGetMidY(self.bounds);
  // If too far down...
	if (newPoint.y > self.canvasView.bounds.size.height  - midPointY)
  	newPoint.y = self.canvasView.bounds.size.height - midPointY;
	else if (newPoint.y < midPointY)	// If too far up...
  	newPoint.y = midPointY;

	// Set new center location
	self.center = newPoint;
}


@end
