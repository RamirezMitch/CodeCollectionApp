//
//  PageSheetView.m
//  DBSDemo
//
//  Created by Naoya on 4/12/11.
//  Copyright 2011 CellCity. All rights reserved.
//

#import "PageSheetView.h"
#import "PageView.h"
#import "ItemView.h"
#import "DItem.h"

@interface PageSheetView (private)
- (void)initialize;
- (void)swipeRight:(UISwipeGestureRecognizer *)gestureRecognizer;
- (void)swipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer;
@end

@implementation PageSheetView
@synthesize couponViewArray,pageView,curlPage,curlPageLeft,pageNumberLabel,activeCouponNumber,isNearBy;

#pragma mark - Basic lifecycle
- (void)dealloc
{
	[couponViewArray release];
	[pageView release];
	[curlPage release];
	[curlPageLeft release];
	[pageNumberLabel release];
    [super dealloc];
}
- (void)initialize
{
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.backgroundColor = [UIColor whiteColor];
	
	curlPage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"curlpage.png"]];
	self.curlPage.frame = CGRectMake(self.frame.size.width - 20, self.frame.size.height - 20, 20, 20);
	self.curlPage.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
	[self addSubview:self.curlPage];

	curlPageLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"L-curlpage.png"]];
	self.curlPageLeft.hidden = YES;
	self.curlPageLeft.frame = CGRectMake(0, self.frame.size.height - 20, 20, 20);
	self.curlPageLeft.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin;
	[self addSubview:self.curlPageLeft];
	
	UIView* leftLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1.0, self.frame.size.height)];
	leftLine.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
	leftLine.backgroundColor = [UIColor lightGrayColor];
	[self addSubview:leftLine];
	[leftLine release];
	
	UIView* rightLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-1.0, 0.0, 1.0, self.frame.size.height)];
	rightLine.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
	rightLine.backgroundColor = [UIColor lightGrayColor];
	[self addSubview:rightLine];
	[rightLine release];
	
	UIView* topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 1.0)];
	topLine.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
	topLine.backgroundColor = [UIColor lightGrayColor];
	[self addSubview:topLine];
	[topLine release];
	
	UIView* bottomLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.height-1.0, 0.0, self.frame.size.width, 1.0)];
	bottomLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
	bottomLine.backgroundColor = [UIColor lightGrayColor];
	[self addSubview:bottomLine];
	[bottomLine release];
	
	pageNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
	self.pageNumberLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|
		UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
	self.pageNumberLabel.center = CGPointMake(self.center.x, self.frame.size.height-10);
	self.pageNumberLabel.textColor = [UIColor grayColor];
	//self.pageNumberLabel.textAlignment = UITextAlignmentCenter;
	self.pageNumberLabel.hidden = YES;
	[self addSubview:self.pageNumberLabel];
	
	
	NSMutableArray* tmpArray = [[NSMutableArray alloc] init];
	for (int i=0; i<7; i++) {
		ItemView* tmpCouponView = [[ItemView alloc] init];
		
		[tmpCouponView.clearButton addTarget:self.superview action:@selector(couponViewClicked:) 
							forControlEvents:UIControlEventTouchUpInside];
		
		UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
		swipe.direction = UISwipeGestureRecognizerDirectionRight;
		[tmpCouponView.clearButton addGestureRecognizer:swipe];
		[swipe release];
		UISwipeGestureRecognizer* swipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
		swipe2.direction = UISwipeGestureRecognizerDirectionLeft;
		[tmpCouponView.clearButton addGestureRecognizer:swipe2];
		[swipe2 release];
		
		tmpCouponView.clearButton.exclusiveTouch = YES;
		tmpCouponView.hidden = YES;
		
		[tmpArray addObject:tmpCouponView];
		[self addSubview:tmpCouponView];
		[tmpCouponView release];
	}
	couponViewArray = [[NSArray alloc] initWithArray:tmpArray];
	[tmpArray release];
	self.activeCouponNumber = 0;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self initialize];
    }
    return self;
}
- (void)awakeFromNib
{
	[self initialize];
}

#pragma mark - Rotation and Layout
- (void)updateLayout:(UIInterfaceOrientation)interfaceOrientation
{
	ItemView* tmpCouponView;
	if ((interfaceOrientation == UIInterfaceOrientationPortrait) ||
		(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
		int n=0;
		for (int j=0; j<3; j++) {
			for (int i=0; i<2; i++,n++){
				tmpCouponView = [self.couponViewArray objectAtIndex:n];
				tmpCouponView.frame = CGRectMake(10+i*150, 5+j*120,
												 tmpCouponView.frame.size.width, tmpCouponView.frame.size.height);
			}
		}
	} else {
		int n=0;
		for (int j=0; j<3; j++) {
			for (int i=0; i<3; i++,n++){
				tmpCouponView = [self.couponViewArray objectAtIndex:n];
				tmpCouponView.frame = CGRectMake(5+i*100, 5+j*120,
												 tmpCouponView.frame.size.width, tmpCouponView.frame.size.height);
			}
		}
	}
	
	[self updateCouponViewVisibility:interfaceOrientation];
}
- (void)updateCouponViewVisibility:(UIInterfaceOrientation)interfaceOrientation
{
	int i;
	for (i=0; i<self.activeCouponNumber; i++) {
		[[self.couponViewArray objectAtIndex:i] setHidden:NO];
	}
	for (; i<7; i++) {
		[[self.couponViewArray objectAtIndex:i] setHidden:YES];
	}
	if ((interfaceOrientation == UIInterfaceOrientationPortrait) ||
		(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
		[[self.couponViewArray objectAtIndex:6] setHidden:YES];
	}
}
- (void)applyPageIndex:(int)pageIndex contents:(NSDictionary*)contents
{
	int total = [[contents objectForKey:@"data"] count];
	if (total == 0){
		self.activeCouponNumber = 0;
		return;
	}
	
	if (pageIndex < 0) {
		self.activeCouponNumber = 0;
	} else {
		int tmpActiveCouponNumber = total - 6*pageIndex;
		tmpActiveCouponNumber = MIN(tmpActiveCouponNumber,7);
		self.activeCouponNumber = MAX(tmpActiveCouponNumber,0);
	}
	
	for (int i=0; i<self.activeCouponNumber; i++) {
		[[self.couponViewArray objectAtIndex:i]
		 applyItemData:[[contents objectForKey:@"data"] objectAtIndex:6*pageIndex+i]];
	}
	
	self.curlPage.hidden = (pageIndex+1 == self.pageView.totalPageNumber)? YES:NO;
	self.curlPageLeft.hidden = (pageIndex == 0)? YES:!self.curlPage.hidden;
	self.pageNumberLabel.text = [NSString stringWithFormat:@"Page %d of %d",pageIndex+1,self.pageView.totalPageNumber];
	self.pageNumberLabel.hidden = NO;
}

- (void)applyDealsPageIndex:(int)pageIndex contents:(NSArray*)contents
{
	int total = [contents count];
	if (total == 0){
		self.activeCouponNumber = 0;
		return;
	}
	
	if (pageIndex < 0) {
		self.activeCouponNumber = 0;
	} else {
		int tmpActiveCouponNumber = total - 6*pageIndex;
		tmpActiveCouponNumber = MIN(tmpActiveCouponNumber,7);
		self.activeCouponNumber = MAX(tmpActiveCouponNumber,0);
	}
	
	for (int i=0; i<self.activeCouponNumber; i++) {
		[[self.couponViewArray objectAtIndex:i]
		 applyDealsData:[contents objectAtIndex:6*pageIndex+i]];
	}
	
	self.curlPage.hidden = (pageIndex+1 == self.pageView.totalPageNumber)? YES:NO;
	self.curlPageLeft.hidden = (pageIndex == 0)? YES:!self.curlPage.hidden;
	self.pageNumberLabel.text = [NSString stringWithFormat:@"Page %d of %d",pageIndex+1,self.pageView.totalPageNumber];
	self.pageNumberLabel.hidden = NO;
}

- (void)clearContents
{
	self.activeCouponNumber = 0;
	for (int i=0; i<7; i++) {
		[[self.couponViewArray objectAtIndex:i] clearItemData];
	}
	self.pageNumberLabel.hidden = YES;
}


#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!isNearBy)
        [self.pageView touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!isNearBy)
        [self.pageView touchesMoved:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!isNearBy)
        [self.pageView touchesEnded:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
     if(!isNearBy)
        [self.pageView touchesCancelled:touches withEvent:event];
}

- (void)swipeRight:(UISwipeGestureRecognizer *)gestureRecognizer
{
	[self.pageView goToPreviousPage];
}
- (void)swipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer
{
	[self.pageView goToNextPage];
}

@end
