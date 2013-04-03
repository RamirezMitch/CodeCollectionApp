//
//  ItemViewController3.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 22/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DItemManager.h"
#import "ItemsHorScrollViewController_iPhone.h"
@interface ItemViewController3 : UIViewController <DItemManagerDelegate,ItemsHorScrollViewControllerDelegate, UIScrollViewDelegate>{
    UIView * viewOffersByCategory;
    NSMutableArray * arrayOffersHorScrollViewCont; // array<ItemsHorScrollViewController>
    int nCategoriesDownloaded;
    
    // Main scroll view
    UIScrollView *mainScrollView;
    
    // View as the base
    int yPosition;
    int tagLastView;
    
    // Offer Manager
    DItemManager *itemManager;
    DItemManager *categoryManager;
    NSArray *pageItems;
}

@property(nonatomic,retain) DItemManager *itemManager;
@property(nonatomic,retain) DItemManager *categoryManager;
@property(nonatomic,retain) NSArray *pageItems;
@property(nonatomic,retain) UIScrollView *mainScrollView;
@property(nonatomic,retain) UIView * viewOffersByCategory;
@property(nonatomic,retain) NSMutableArray * arrayOffersHorScrollViewCont;
@property(nonatomic,assign) int tagLastView;
- (void) addBaseView:(UIView *)baseViewIn offers:(NSArray *)offersIn title:(NSString *)titleIn tag:(NSUInteger)tagIn;
- (void) adjustOtherViews;
- (void) adjustScrollViewContentSize;
- (void) showNoOfferText:(BOOL)toShow;
- (UIView *) baseViewForEmptyOfferSection;
- (void) showTopBannerImage;
@end
