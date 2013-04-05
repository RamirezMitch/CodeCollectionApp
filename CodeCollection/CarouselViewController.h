//
//  CarouselViewController.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 18/3/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "Reachability.h"
#import "ProductManager.h"
#import "DItemManager.h"
@interface CarouselViewController : UIViewController <iCarouselDelegate,iCarouselDataSource,UIAlertViewDelegate, ProductManagerDelegate>{
    NSArray *catalogue;
    UIView *viewDarken;
    UIActivityIndicatorView *activityIndicator;
    
    Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;
    ProductManager *productManager;
    DItemManager *itemManager;
   
    
}
@property(nonatomic,retain) DItemManager *itemManager;
@property(nonatomic,retain) ProductManager *productManager;
@property (nonatomic, retain) iCarousel *slideView;
@property (nonatomic, retain) UIView *moreView;
@property (nonatomic, retain) UILabel *loadMoreLabel;
@property (nonatomic, retain) UIActivityIndicatorView *loadMoreIndicatoreView;
-(BOOL)internetAvailable;
-(void)showNoInternetAlert;


- (void)loadMoreForICarousel;
- (void) appendDataToICarousel:(NSArray *)theRsArray;
- (void) appendTableDepth:(NSMutableArray *)data;
@end
