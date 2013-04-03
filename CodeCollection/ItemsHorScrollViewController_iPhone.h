//
//  ItemsHorScrollViewController.h
//  gpt
//
//  Created by Johannes Dwiartanto on 7/26/11.
//  Copyright 2011 CellCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFRequestManager.h"
//#import "DeviceFeaturesManager.h"
//#import "ImageDownloader.h"

@protocol ItemsHorScrollViewControllerDelegate;
 
@interface ItemsHorScrollViewController_iPhone : UIViewController <AFRequestManagerDelegate, UIScrollViewDelegate> {
    
    UIScrollView * currentScrollView;
    UIPageControl *pageControl;
    int noOfpages;
    BOOL pageControlUsed;
    
    NSArray * pageItems;
    
    AFRequestManager * requestManager;
    //ImageDownloader * imageDownloader;
    
    BOOL areAllLoaded; // Check. E.g. when the app resume from background but the cats are not loaded yet due to network timeout
    
    float heightCatTitle;
    float heightScrollView;
    float heightPageControl;
    float heightAdjust; // to adjust the height of the image and so affect the title and subtitle. the smaller the higher the result
    
    int otherInfo; // if needed
    
    NSString * textNoData;
    
    id<ItemsHorScrollViewControllerDelegate> delegate;
}

@property(nonatomic,retain) UIScrollView * currentScrollView;
@property(nonatomic,retain) UIPageControl *pageControl;
@property(nonatomic,retain) NSArray *pageItems;
@property(nonatomic,retain) AFRequestManager * requestManager;
@property(nonatomic,assign) float heightCatTitle;
@property(nonatomic,assign) float heightScrollView;
@property(nonatomic,assign) float heightPageControl;
@property(nonatomic,assign) float heightAdjust;
@property(nonatomic,assign) int noOfPages;
@property(nonatomic,assign) id<ItemsHorScrollViewControllerDelegate> delegate;
//@property (nonatomic,retain) ImageDownloader * imageDownloader;
@property (nonatomic,assign) int otherInfo;
@property (nonatomic,retain) NSString * textNoData;

- (id)initWithItems:(NSArray *)items;
- (void) populateView;
- (void) tapItem:(id)sender;
- (void) changePage:(id)sender;
- (void) cancel;

@end


@protocol ItemsHorScrollViewControllerDelegate <NSObject>
- (void)itemsHorScrollViewController:(ItemsHorScrollViewController_iPhone *)cvc didTapItemWithId:(NSInteger)itemId;
@optional
- (void)itemsHorScrollViewController:(ItemsHorScrollViewController_iPhone *)cvc didRetrieveItemsWithError:(NSString *)errorIn;
@end