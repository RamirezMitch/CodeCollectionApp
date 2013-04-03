//
//  PageView.m
//  AnimationTest1
//
//  Created by Naoya on 3/23/11.
//  Copyright 2011 CellCity. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PageView.h"

@interface PageView (private)
- (CATransform3D)getTransform:(CGFloat)angle;
- (CATransform3D)getTransformFromX:(CGFloat)x;
- (UIImage*)captureLeftView:(UIView*)target;
- (UIImage*)captureRightView:(UIView*)target;
- (void)initRightToLeftFlip;
- (void)initLeftToRightFlip;
- (void)dropPage:(CGPoint)locationInView;
- (void)flipSecondHalfAnimation;
- (void)flipFirstHalfAnimation:(CGPoint)locationInView;
- (void)flipFirstHalfAnimationFull;
- (void)rotatePage:(CGPoint)locationInView;
- (void)flipToRightAnimation:(CGPoint)locationInView;
- (void)flipToLeftAnimation:(CGPoint)locationInView;
- (bool)ignoreTouch;
@end

@implementation PageView
@synthesize currentView,previousView,nextView;
@synthesize totalPageNumber,currentPageIndex,_delegate;
@synthesize kPerspectiveZValue,kFlipGestureThreshold,kFullFlipDuration,kFlipRange,kBackgroundShadowOpacity,kUntouchableWidth;
@synthesize rotateView,frontView,rearView,backgroundView,shadowView,backgroundShadowView;
@synthesize frontImageView,rearImageView,backgroundLeftImageView,backgroundRightImageView,isFlippingToRight;
@synthesize isFirstHalfAnimation,isAnimating,beginingPosition,lastPosition,isIncrement,isDecrement,isFinished;

#pragma mark - Basic lifecycle
- (void)dealloc{
	[currentView release];
	[previousView release];
	[nextView release];
	[rotateView release];
	[frontView release];
	[rearView release];
	[backgroundView release];
	[shadowView release];
	[backgroundShadowView release];
	[frontImageView release];
	[rearImageView release];
	[backgroundLeftImageView release];
	[backgroundRightImageView release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		self.backgroundColor = [UIColor clearColor];
		//self.multipleTouchEnabled = YES;
		
		CGRect halfFrame = frame;
		halfFrame.size.width = halfFrame.size.width/2;
		
		UIView* tmpRotateView = [[UIView alloc] initWithFrame:frame];
		tmpRotateView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		tmpRotateView.backgroundColor = [UIColor clearColor];
		self.rotateView = tmpRotateView;
		[tmpRotateView release];
		
		UIView* tmpFrontView = [[UIView alloc] initWithFrame:frame];
		tmpFrontView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		tmpFrontView.backgroundColor = [UIColor clearColor];
		self.frontView = tmpFrontView;
		[tmpFrontView release];
		
		UIView* tmpRearView = [[UIView alloc] initWithFrame:frame];
		tmpRearView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		tmpRearView.backgroundColor = [UIColor clearColor];
		tmpRearView.hidden = YES;
		self.rearView = tmpRearView;
		[tmpRearView release];
		CATransform3D transform = CATransform3DIdentity;
		transform = CATransform3DRotate(transform, M_PI, 0.0, 1.0, 0.0);
		self.rearView.layer.transform = transform;
		
		UIView* tmpBackgroundView = [[UIView alloc] initWithFrame:frame];
		tmpBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		tmpBackgroundView.backgroundColor = [UIColor clearColor];
		self.backgroundView = tmpBackgroundView;
		[tmpBackgroundView release];
		
		UIImageView* tmpFrontImageView = [[UIImageView alloc] initWithFrame:halfFrame];
		tmpFrontImageView.contentMode = UIViewContentModeTopLeft;
		self.frontImageView =  tmpFrontImageView;
		[self.frontView addSubview:self.frontImageView];
		[tmpFrontImageView release];
		
		UIImageView* tmpRearImageView = [[UIImageView alloc] initWithFrame:frame];
		tmpRearImageView.contentMode = UIViewContentModeTopLeft;
		self.rearImageView =  tmpRearImageView;
		[self.rearView addSubview:self.rearImageView];
		[tmpRearImageView release];
		
		UIImageView* tmpBackgroundLeftImageView = [[UIImageView alloc] initWithFrame:halfFrame];
		tmpBackgroundLeftImageView.contentMode = UIViewContentModeTopLeft;
		self.backgroundLeftImageView =  tmpBackgroundLeftImageView;
		[tmpBackgroundLeftImageView release];
		
		UIImageView* tmpBackgroundRightImageView = [[UIImageView alloc] initWithFrame:frame];
		tmpBackgroundRightImageView.contentMode = UIViewContentModeTopLeft;
		self.backgroundRightImageView =  tmpBackgroundRightImageView;
		[tmpBackgroundRightImageView release];
		
		UIView* tmpShadowView = [[UIView alloc] initWithFrame:halfFrame];
		tmpShadowView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		tmpShadowView.backgroundColor = [UIColor blackColor];
		tmpShadowView.layer.opacity = 0.03;
		tmpShadowView.hidden = YES;
		self.shadowView = tmpShadowView;
		[tmpShadowView release];
		
		UIView* tmpBackgroundShadowView = [[UIView alloc] initWithFrame:halfFrame];
		tmpBackgroundShadowView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		tmpBackgroundShadowView.backgroundColor = [UIColor blackColor];
		tmpBackgroundShadowView.layer.opacity = kBackgroundShadowOpacity;
		tmpBackgroundShadowView.hidden = YES;
		self.backgroundShadowView = tmpBackgroundShadowView;
		[tmpBackgroundShadowView release];
		
		[self.backgroundView addSubview:self.backgroundRightImageView];
		[self.backgroundView addSubview:self.backgroundLeftImageView];
		[self.backgroundView addSubview:self.backgroundShadowView];
		[self addSubview:self.backgroundView];
		[self.rotateView addSubview:self.rearView];
		[self.rotateView addSubview:self.frontView];
		[self.rotateView addSubview:shadowView];
		[self addSubview:self.rotateView];
		
		self.currentView = nil;
		self.previousView = nil;
		self.nextView = nil;
		
		self.totalPageNumber = 3;
		self.currentPageIndex = 1;
		
		self.isFlippingToRight = NO;
		self.isFirstHalfAnimation = NO;
		self.isAnimating = NO;
		self.lastPosition = CGPointMake(0.0, 0.0);
		self.isIncrement = NO;
		self.isDecrement = NO;
		self.isFinished = YES;
		
		kPerspectiveZValue = 2000.0;
		kFlipGestureThreshold = 30.0;
		kFullFlipDuration = 0.7;
		kFlipRange = 720.0;
		kBackgroundShadowOpacity = 1.0;
		kUntouchableWidth = 150.0;
    }
    return self;
}

#pragma mark - Animation
- (CATransform3D)getTransform:(CGFloat)angle{
	CATransform3D transform = CATransform3DIdentity;
	transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0);
	CATransform3D perspective = CATransform3DIdentity;
	perspective.m34 = -1.0/kPerspectiveZValue;
	return CATransform3DConcat(transform, perspective);
}
- (CATransform3D)getTransformFromX:(CGFloat)x{
	CGFloat angle = degreesToRadians(90.0+(x - self.center.x)/(kFlipRange/180.0));
	if (angle < 0.0) angle = 0.0;
	else if (angle > M_PI) angle = M_PI;
	
	return [self getTransform:angle];
}

#pragma mark Initialize
- (UIImage*)captureLeftView:(UIView*)target{
	UIImage* tmpImage;
	CGRect tmpRect = self.frame;
	tmpRect.size.width = tmpRect.size.width/2;
	
	UIGraphicsBeginImageContext(tmpRect.size);{
		[target.layer renderInContext:UIGraphicsGetCurrentContext()];
		tmpImage = UIGraphicsGetImageFromCurrentImageContext();
	}UIGraphicsEndImageContext();
	
	//UIGraphicsGetImageFromCurrentImageContext returns autorelease object
	return tmpImage;
}
- (UIImage*)captureRightView:(UIView*)target{	
	UIImage* tmpImage;
	CGRect tmpRect = self.frame;
	tmpRect.origin.x = tmpRect.size.width/2;
	tmpRect.size.width = tmpRect.size.width/2;

	UIGraphicsBeginImageContext(self.frame.size);{
		UIRectClip(tmpRect);
		[target.layer renderInContext:UIGraphicsGetCurrentContext()];
		tmpImage = UIGraphicsGetImageFromCurrentImageContext();
	}UIGraphicsEndImageContext();

	//UIGraphicsGetImageFromCurrentImageContext returns autorelease object
	return tmpImage;
}
- (void)initRightToLeftFlip{
	self.backgroundLeftImageView.image	= [self captureLeftView:self.currentView];
	self.rearImageView.image			= [self captureRightView:self.currentView];
	
	bool tmpHidden = self.nextView.hidden;
	self.nextView.hidden = NO;
	self.frontImageView.image			= [self captureLeftView:self.nextView];
	self.backgroundRightImageView.image = [self captureRightView:self.nextView];
	self.nextView.hidden = tmpHidden;

	self.frontView.hidden = YES;
	self.rearView.hidden = NO;

	CGRect tmpFrame = self.frame;
	tmpFrame.size.width = tmpFrame.size.width/2;
	self.shadowView.frame = tmpFrame;
	self.shadowView.hidden = NO;

	tmpFrame.origin.x = tmpFrame.size.width;
	self.backgroundShadowView.frame = tmpFrame;
	self.backgroundShadowView.hidden = NO;
}
- (void)initLeftToRightFlip{
	bool tmpHidden = self.previousView.hidden;
	self.previousView.hidden = NO;
	self.backgroundLeftImageView.image	= [self captureLeftView:self.previousView];
	self.rearImageView.image			= [self captureRightView:self.previousView];
	self.previousView.hidden = tmpHidden;
	
	self.frontImageView.image			= [self captureLeftView:self.currentView];
	self.backgroundRightImageView.image = [self captureRightView:self.currentView];

	self.frontView.hidden = NO;
	self.rearView.hidden = YES;

	CGRect tmpFrame = self.frame;
	tmpFrame.size.width = tmpFrame.size.width/2;
	self.shadowView.frame = tmpFrame;
	self.shadowView.hidden = NO;
	self.backgroundShadowView.frame = tmpFrame;
	self.backgroundShadowView.hidden = NO;
}

#pragma mark Action
- (void)dropPage:(CGPoint)locationInView{
	if (self.beginingPosition.x < self.center.x && locationInView.x >= self.center.x) {
		self.isDecrement = YES;
		if ([self._delegate respondsToSelector:@selector(willDecrementPage:)]){
			[self._delegate willDecrementPage:self.currentPageIndex-1];
		}
	} else if (self.beginingPosition.x >= self.center.x && locationInView.x < self.center.x) {
		self.isIncrement = YES;
		if ([self._delegate respondsToSelector:@selector(willIncrementPage:)]){
			[self._delegate willIncrementPage:self.currentPageIndex+1];
		}
	}
	
	CFTimeInterval tmpDuration;
	CGRect tmpFrame = self.backgroundShadowView.frame;
	if (locationInView.x < self.center.x) {
		self.frontView.hidden = NO;
		self.rearView.hidden = YES;
		tmpDuration = (kFullFlipDuration/2)-(self.center.x-locationInView.x)/kFlipRange;
		tmpFrame.origin.x = 0.0;
	} else {
		self.frontView.hidden = YES;
		self.rearView.hidden = NO;
		tmpDuration = (kFullFlipDuration/2)+(self.center.x-locationInView.x)/kFlipRange;
		tmpFrame.origin.x = tmpFrame.size.width;
	}
	if(tmpDuration<=0.0) tmpDuration=0.0;
	self.backgroundShadowView.frame = tmpFrame;
	
	CGFloat tmpFloat = (locationInView.x < self.center.x)? 0.0:M_PI;
	CATransform3D tmpTransform = [self getTransform:tmpFloat];
	
	CABasicAnimation* animation1;
	animation1 = [CABasicAnimation animationWithKeyPath:@"transform"];
	animation1.duration = tmpDuration;
	animation1.fromValue = [NSValue valueWithCATransform3D:[self getTransformFromX:locationInView.x]];
	animation1.toValue = [NSValue valueWithCATransform3D:tmpTransform];
	animation1.delegate = self;
	[self.rotateView.layer addAnimation:animation1 forKey:@"dropAnimation"];
	self.rotateView.layer.transform = tmpTransform;

	CABasicAnimation* animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
	animation2.duration = tmpDuration;
	animation2.fromValue = [NSNumber numberWithFloat:self.backgroundShadowView.layer.opacity];
	animation2.toValue = [NSNumber numberWithFloat:1.0];
	[self.backgroundShadowView.layer addAnimation:animation2 forKey:@"shadowAnimation"];
	self.backgroundShadowView.layer.opacity = 1.0;
		
	self.isAnimating = YES;
}
- (void)flipSecondHalfAnimation{
	CGFloat tmpFloat = (self.isFlippingToRight)? M_PI:0.0;
	CATransform3D tmpTransform = [self getTransform:tmpFloat];
	
	CABasicAnimation* animation1;
	animation1 = [CABasicAnimation animationWithKeyPath:@"transform"];
	animation1.duration = kFullFlipDuration/2.0;
	animation1.fromValue = [NSValue valueWithCATransform3D:[self getTransform:M_PI_2]];
	animation1.toValue = [NSValue valueWithCATransform3D:tmpTransform];
	animation1.delegate = self;
	[self.rotateView.layer addAnimation:animation1 forKey:@"secondHalfAnimation"];
	self.rotateView.layer.transform = tmpTransform;
	
	CABasicAnimation* animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
	animation2.duration = kFullFlipDuration/2.0;
	animation2.fromValue = [NSNumber numberWithFloat:self.backgroundShadowView.layer.opacity];
	animation2.toValue = [NSNumber numberWithFloat:1.0];
	[self.backgroundShadowView.layer addAnimation:animation2 forKey:@"shadowAnimation"];
	self.backgroundShadowView.layer.opacity = 1.0;
	
	self.isAnimating = YES;
}
- (void)flipFirstHalfAnimation:(CGPoint)locationInView{
	if ((locationInView.x > self.center.x && self.isFlippingToRight) ||
		(locationInView.x < self.center.x && !self.isFlippingToRight)) {
		[self dropPage:locationInView];
		return;
	}
	
	if (self.beginingPosition.x < self.center.x && self.isFlippingToRight) {
		self.isDecrement = YES;
		if ([self._delegate respondsToSelector:@selector(willDecrementPage:)]){
			[self._delegate willDecrementPage:self.currentPageIndex-1];
		}
	} else if (self.beginingPosition.x >= self.center.x && !self.isFlippingToRight) {
		self.isIncrement = YES;
		if ([self._delegate respondsToSelector:@selector(willIncrementPage:)]){
			[self._delegate willIncrementPage:self.currentPageIndex+1];
		}
	}
	
	CATransform3D tmpTransform = [self getTransform:M_PI_2];
	CFTimeInterval tmpDuration = self.center.x-locationInView.x;
	tmpDuration = (tmpDuration<0)? -kFullFlipDuration*tmpDuration/kFlipRange : kFullFlipDuration*tmpDuration/kFlipRange;
	if (tmpDuration<=0) tmpDuration=0;
	
	CABasicAnimation* animation1;
	animation1 = [CABasicAnimation animationWithKeyPath:@"transform"];
	animation1.duration = tmpDuration;
	animation1.fromValue = [NSValue valueWithCATransform3D:self.rotateView.layer.transform];
	animation1.toValue = [NSValue valueWithCATransform3D:tmpTransform];
	animation1.delegate = self;
	[self.rotateView.layer addAnimation:animation1 forKey:@"firstHalfAnimation"];
	self.rotateView.layer.transform = tmpTransform;
	
	CABasicAnimation* animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
	animation2.duration = tmpDuration;
	animation2.fromValue = [NSNumber numberWithFloat:self.backgroundShadowView.layer.opacity];
	animation2.toValue = [NSNumber numberWithFloat:0.0];
	[self.backgroundShadowView.layer addAnimation:animation2 forKey:@"shadowAnimation"];
	self.backgroundShadowView.layer.opacity = 0.0;
	
	self.isAnimating = YES;
	self.isFirstHalfAnimation = YES;
}
- (void)flipFirstHalfAnimationFull{
	if (self.isFlippingToRight) {
		self.isDecrement = YES;
		if ([self._delegate respondsToSelector:@selector(willDecrementPage:)]){
			[self._delegate willDecrementPage:self.currentPageIndex-1];
		}
	} else {
		self.isIncrement = YES;
		if ([self._delegate respondsToSelector:@selector(willIncrementPage:)]){
			[self._delegate willIncrementPage:self.currentPageIndex+1];
		}
	}
	
	CGFloat tmpFloat = (self.isFlippingToRight)? 0.0:M_PI;
	CATransform3D tmpTransform = [self getTransform:tmpFloat];
	
	CABasicAnimation* animation1;
	animation1 = [CABasicAnimation animationWithKeyPath:@"transform"];
	animation1.duration = kFullFlipDuration/2.0;
	animation1.fromValue = [NSValue valueWithCATransform3D:tmpTransform];
	animation1.toValue = [NSValue valueWithCATransform3D:[self getTransform:M_PI_2]];
	animation1.delegate = self;
	[self.rotateView.layer addAnimation:animation1 forKey:@"firstHalfAnimation"];
	self.rotateView.layer.transform = tmpTransform;
	
	CABasicAnimation* animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
	animation2.duration = kFullFlipDuration/2.0;
	animation2.fromValue = [NSNumber numberWithFloat:self.backgroundShadowView.layer.opacity];
	animation2.toValue = [NSNumber numberWithFloat:0.0];
	[self.backgroundShadowView.layer addAnimation:animation2 forKey:@"shadowAnimation"];
	self.backgroundShadowView.layer.opacity = 0.0;
	
	self.isAnimating = YES;
	self.isFirstHalfAnimation = YES;
}
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
	if (self.isFirstHalfAnimation) {
		self.isFirstHalfAnimation = NO;
		
		self.frontView.hidden = !self.frontView.hidden;
		self.rearView.hidden = !self.rearView.hidden;
		CGRect tmpFrame = self.backgroundShadowView.frame;
		if (self.isFlippingToRight) {
			tmpFrame.origin.x = tmpFrame.size.width;
		} else {
			tmpFrame.origin.x = 0.0;
		}
		self.backgroundShadowView.frame = tmpFrame;

		[self flipSecondHalfAnimation];
	} else {
		self.hidden = YES;
		self.isFinished = YES;
		self.isAnimating = NO;
		if (self.isIncrement) {
			self.currentPageIndex = self.currentPageIndex+1;
			if ([self._delegate respondsToSelector:@selector(didIncrementPage:)]){
				[self._delegate didIncrementPage:self.currentPageIndex];
			}
		} else if (self.isDecrement) {
			self.currentPageIndex = self.currentPageIndex-1;
			if ([self._delegate respondsToSelector:@selector(didDecrementPage:)]){
				[self._delegate didDecrementPage:self.currentPageIndex];
			}
		}
		self.isIncrement = NO;
		self.isDecrement = NO;
		NSLog(@"index:%d",self.currentPageIndex);
	}
}

- (void)rotatePage:(CGPoint)locationInView{
	self.rotateView.layer.transform = [self getTransformFromX:locationInView.x];
	
	CGFloat tmpOpacity;
	CGRect tmpFrame = self.backgroundShadowView.frame;
	if (locationInView.x < self.center.x) {
		self.frontView.hidden = NO;
		self.rearView.hidden = YES;
		tmpOpacity = kBackgroundShadowOpacity * (self.center.x - locationInView.x)/(kFlipRange/2.0);
		tmpFrame.origin.x = 0.0;
	} else {
		self.frontView.hidden = YES;
		self.rearView.hidden = NO;
		tmpOpacity = kBackgroundShadowOpacity * (locationInView.x - self.center.x)/(kFlipRange/2.0);
		tmpFrame.origin.x = tmpFrame.size.width;
	}
	self.backgroundShadowView.layer.opacity = tmpOpacity;
	self.backgroundShadowView.frame = tmpFrame;
}

#pragma mark - Touches
- (bool)ignoreTouch{
	if (self.isFinished) return YES;
	if (self.isAnimating) return YES;
	if ((self.beginingPosition.x > self.center.x - kUntouchableWidth/2) &&
		(self.beginingPosition.x < self.center.x + kUntouchableWidth/2)) {
		return YES;
	}
	if (((self.beginingPosition.x < self.center.x) && (self.currentPageIndex <= 0)) ||
		((self.beginingPosition.x >= self.center.x) && ((self.currentPageIndex+1) >= self.totalPageNumber))) {
		return YES;
	}
	
	return NO;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch* touch = [touches anyObject];
	self.beginingPosition = [touch locationInView:self];
	self.isFinished = NO;
	if ([self ignoreTouch]) return;
	
	if ([touch locationInView:self].x < self.center.x) {
		[self initLeftToRightFlip];
	} else {
		[self initRightToLeftFlip];
	}
	
	[self rotatePage:[touch locationInView:self]];
	self.lastPosition = [touch locationInView:self];
	self.hidden = NO;
	[self.superview bringSubviewToFront:self];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch* touch = [touches anyObject];
	if ([self ignoreTouch]) return;
	
	CGFloat diffX = [touch locationInView:self].x - [touch previousLocationInView:self].x;
	if (diffX > kFlipGestureThreshold) {
		self.isFlippingToRight = YES;
		[self flipFirstHalfAnimation:[touch locationInView:self]];
	} else if (diffX < -kFlipGestureThreshold) {
		self.isFlippingToRight = NO;
		[self flipFirstHalfAnimation:[touch locationInView:self]];
	} else {
		[self rotatePage:[touch locationInView:self]];
	}
	
	self.lastPosition = [touch locationInView:self];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch* touch = [touches anyObject];
	if ([self ignoreTouch]) return;
	
	self.lastPosition = [touch locationInView:self];
	[self dropPage:[touch locationInView:self]];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	[self forceDropPage];
	self.hidden = YES;
}

#pragma mark - Other
- (void)forceDropPage{
	if (self.hidden) return;
	if ([self ignoreTouch]) return;
	
	[self dropPage:self.lastPosition];
}
- (void)goToPreviousPage{
	if (self.hidden == NO) return;
	if (self.currentPageIndex == 0){
		return;
	}
	
	[self initLeftToRightFlip];
	self.hidden = NO;
	[self.superview bringSubviewToFront:self];
	self.isFlippingToRight = YES;
	[self flipFirstHalfAnimationFull];
}
- (void)goToNextPage{
	if (self.hidden == NO) return;
	if ((self.currentPageIndex+1) == self.totalPageNumber) {
		return;
	}
	
	[self initRightToLeftFlip];
	self.hidden = NO;
	[self.superview bringSubviewToFront:self];
	self.isFlippingToRight = NO;
	[self flipFirstHalfAnimationFull];
}

@end
