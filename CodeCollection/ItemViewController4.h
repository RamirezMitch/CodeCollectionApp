//
//  ItemViewController4.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 22/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageSheetView.h"
#import "PageView.h"
#import "DItem.h"
#import "AFRequestManager.h"
#import "ProductManager.h"
@class PageSheetView;
@interface ItemViewController4 : UIViewController <PageViewDelegate,AFRequestManagerDelegate> {
    IBOutlet UIView* sheet;
	PageSheetView* currentSheet;
	PageSheetView* nextSheet;
	PageSheetView* previousSheet;
	PageView* pageView;
    NSDictionary* itemCategoryDictionary;
    NSMutableArray *itemsMutableArray;
    
}
@property(nonatomic,retain) AFRequestManager *requestManager;
@property(nonatomic,retain) ProductManager *productManager;
@property(nonatomic,retain) IBOutlet UIView* sheet;
@property(nonatomic,retain) PageSheetView* currentSheet;
@property(nonatomic,retain) PageSheetView* nextSheet;
@property(nonatomic,retain) PageSheetView* previousSheet;
@property(nonatomic,retain) PageView* pageView;
@property(nonatomic,retain) NSDictionary* itemCategoryDictionary;
@property(nonatomic,retain) NSMutableArray *itemsMutableArray;
- (IBAction)featuredCouponClicked;
- (void)couponViewClicked:(id)sender;

@end
