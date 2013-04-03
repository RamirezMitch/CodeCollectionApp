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
@interface CarouselViewController : UIViewController <iCarouselDelegate,iCarouselDataSource,UIAlertViewDelegate, UIWebViewDelegate>{
    NSArray *catalogue;
    NSString *xlsContent;
    UIView *viewDarken;
    UIActivityIndicatorView *activityIndicator;
    NSArray *arrRowBundle;
    
    NSMutableArray *listBundlePrd;
    
    Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;

}
@property NSInteger currentPage;
@property NSInteger totalPage;
@property (nonatomic, retain) iCarousel *slideView;
@property (nonatomic, retain) UIView *moreView;
@property (nonatomic, retain) UILabel *loadMoreLabel;
@property (nonatomic, retain) UIActivityIndicatorView *loadMoreIndicatoreView;
@property (nonatomic, retain) NSMutableDictionary *listSection;
-(BOOL)internetAvailable;
-(void)showNoInternetAlert;


- (void)loadMoreForICarousel;
- (void) appendDataToICarousel:(NSArray *)theRsArray;
- (void) appendTableDepth:(NSMutableArray *)data;
@end
