//
//  PageView.h
//  AnimationTest1
//
//  Created by Naoya on 3/23/11.
//  Copyright 2011 CellCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageViewDelegate <NSObject>
@optional
- (void)willIncrementPage:(int)toIndex;
- (void)willDecrementPage:(int)toIndex;
- (void)didIncrementPage:(int)toIndex;
- (void)didDecrementPage:(int)toIndex;
@end

@interface PageView : UIView {
    UIView* currentView;
	UIView* previousView;
	UIView* nextView;
	int totalPageNumber;
	int currentPageIndex;
	id <PageViewDelegate> _delegate;

	CGFloat kPerspectiveZValue;
	CGFloat kFlipGestureThreshold;
	CGFloat kFullFlipDuration;
	CGFloat kFlipRange;
	CGFloat kBackgroundShadowOpacity;
	CGFloat kUntouchableWidth;

@private
	UIView* rotateView;
	UIView* frontView;
	UIView* rearView;
	UIView* backgroundView;
	UIView* shadowView;
	UIView* backgroundShadowView;
	UIImageView* frontImageView;
	UIImageView* rearImageView;
	UIImageView* backgroundLeftImageView;
	UIImageView* backgroundRightImageView;
	bool isFlippingToRight;
	bool isFirstHalfAnimation;
	bool isAnimating;
	CGPoint beginingPosition;
	CGPoint lastPosition;
	bool isIncrement;
	bool isDecrement;
	bool isFinished;
}

@property(nonatomic,retain) UIView* currentView;
@property(nonatomic,retain) UIView* previousView;
@property(nonatomic,retain) UIView* nextView;
@property(nonatomic,assign) int totalPageNumber;
@property(nonatomic,assign) int currentPageIndex;
@property(nonatomic,assign) id <PageViewDelegate> _delegate;

@property(nonatomic,assign) CGFloat kPerspectiveZValue;
@property(nonatomic,assign) CGFloat kFlipGestureThreshold;
@property(nonatomic,assign) CGFloat kFullFlipDuration;
@property(nonatomic,assign) CGFloat kFlipRange;
@property(nonatomic,assign) CGFloat kBackgroundShadowOpacity;
@property(nonatomic,assign) CGFloat kUntouchableWidth;

@property(nonatomic,retain) UIView* rotateView;
@property(nonatomic,retain) UIView* frontView;
@property(nonatomic,retain) UIView* rearView;
@property(nonatomic,retain) UIView* backgroundView;
@property(nonatomic,retain) UIView* backgroundShadowView;
@property(nonatomic,retain) UIView* shadowView;
@property(nonatomic,retain) UIImageView* frontImageView;
@property(nonatomic,retain) UIImageView* rearImageView;
@property(nonatomic,retain) UIImageView* backgroundLeftImageView;
@property(nonatomic,retain) UIImageView* backgroundRightImageView;
@property(nonatomic,assign) bool isFlippingToRight;
@property(nonatomic,assign) bool isFirstHalfAnimation;
@property(nonatomic,assign) bool isAnimating;
@property(nonatomic,assign) CGPoint beginingPosition;
@property(nonatomic,assign) CGPoint lastPosition;
@property(nonatomic,assign) bool isIncrement;
@property(nonatomic,assign) bool isDecrement;
@property(nonatomic,assign) bool isFinished;

- (void)forceDropPage;
- (void)goToPreviousPage;
- (void)goToNextPage;

@end
