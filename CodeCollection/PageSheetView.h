//
//  PageSheetView.h
//  DBSDemo
//
//  Created by Naoya on 4/12/11.
//  Copyright 2011 CellCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageView;

@interface PageSheetView : UIView {
	NSArray* couponViewArray;
    PageView* pageView;
	UIImageView* curlPage;
	UIImageView* curlPageLeft;
	UILabel* pageNumberLabel;
	NSUInteger activeCouponNumber;
    BOOL isNearBy;
}

@property(nonatomic,retain) NSArray* couponViewArray;
@property(nonatomic,retain) PageView* pageView;
@property(nonatomic,retain) UIImageView* curlPage;
@property(nonatomic,retain) UIImageView* curlPageLeft;
@property(nonatomic,retain) UILabel* pageNumberLabel;
@property(nonatomic,assign) NSUInteger activeCouponNumber;
@property (readwrite, assign) BOOL isNearBy;

- (void)updateLayout:(UIInterfaceOrientation)interfaceOrientation;
- (void)updateCouponViewVisibility:(UIInterfaceOrientation)interfaceOrientation;
- (void)applyPageIndex:(int)pageIndex contents:(NSDictionary*)contents;
- (void)applyDealsPageIndex:(int)pageIndex contents:(NSArray*)contents;
- (void)clearContents;


@end
