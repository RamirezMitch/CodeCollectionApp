//
//  CarouselViewController.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 18/3/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "CarouselViewController.h"
#import "Product.h"
#import "MyUtil.h"
#import "CCObject.h"
#import "Category.h"
#import "DItem.h"
#define NUMBER_OF_VISIBLE_ITEMS 12
#define ITEM_SPACING 210.0f
#define INCLUDE_PLACEHOLDERS YES
@interface CarouselViewController ()
@property (nonatomic,retain) UIImage *frameImage;
@end

@implementation CarouselViewController
@synthesize slideView;
@synthesize frameImage;
@synthesize moreView,loadMoreLabel,loadMoreIndicatoreView;
@synthesize productManager;
@synthesize itemManager;

- (UIImage *)frameImage
{
    if (frameImage == nil) {
        UIImage *img = [UIImage imageNamed:@"detail-img"];
        if ([img respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
            frameImage = [img resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        } else {
            frameImage = [img stretchableImageWithLeftCapWidth:49.0 topCapHeight:44.0];
        }
    }
    return frameImage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.slideView = [[[iCarousel alloc] initWithFrame:self.view.frame] autorelease];
    self.slideView.delegate = self;
    self.slideView.dataSource = self;
    [self.view addSubview:self.slideView];
    self.slideView.type = iCarouselTypeCoverFlow2;
    self.slideView.scrollSpeed = 0.2f;
    
    self.itemManager = [[[DItemManager alloc] initWithDelegate:self] autorelease];
    [self.itemManager requestAllItems];
    self.productManager = [[[ProductManager alloc] initWithDelegate:self] autorelease];

  // [self.slideView reloadData];
    [self initialSetup];
}

-(void) initialSetup{
    

    if ([self internetAvailable])
    {
            [self showActivityIndicator];
            [self.productManager loadXLS];
    }
    else
    {
        [self showNoInternetAlert];
    }
}
-(void) showNoInternetAlert{
    UIAlertView * alertView = [[[UIAlertView alloc] initWithTitle:@"Network Connection Error"
                                                          message:@"No Internet Connection detected"
                                                         delegate:self
                                                cancelButtonTitle:nil
                                                otherButtonTitles:@"OK", nil] autorelease];
    [alertView show];
}
-(BOOL)internetAvailable
{
    BOOL gotConnection;
	bool success = false;
	const char *host_name = [@"www.google.com" cStringUsingEncoding:NSASCIIStringEncoding];
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
	SCNetworkReachabilityFlags flags;
	success = SCNetworkReachabilityGetFlags(reachability, &flags);
	bool isAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
	if (isAvailable) {
		gotConnection = YES;
	}
	else {
		gotConnection = NO;
	}
    return gotConnection;
}
-(void)showActivityIndicator
{
    viewDarken = [[UIView alloc]init];
    viewDarken.frame = self.view.frame;
    viewDarken.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_darken.png"]];
    [self.view addSubview:viewDarken];
    
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	activityIndicator.center = self.view.center;
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator startAnimating];
	[viewDarken addSubview: activityIndicator];
    
}

-(void)hideActivityIndicator
{
    //[viewDarken removeFromSuperview];
    viewDarken.hidden = YES;
    [activityIndicator stopAnimating];
    //[viewDarken release];
    //[activityIndicator release];
}
- (void) dItemManager:(DItemManager *)om shouldShowAllItems:allItems {
    
    NSInteger tagIndex = 0;
    
    for (NSDictionary *item in allItems) {
        
        NSDictionary *catItem = [item objectForKey:@"Category"];
        Category *cat = [[Category alloc] initWithDictionary:catItem];
        
        NSArray *itemList = [item objectForKey:@"OfferList"];
        if ([itemList count]) { // show offers only when offer list not empty
            
            NSMutableArray *theItems = [[NSMutableArray alloc] init];
            for (NSDictionary *itemDict in itemList) {
                DItem *itm = [[DItem alloc] initWithDictionary:itemDict];
                [theItems addObject:itm];
                [itm release];
            }
            
/////// catalogue
            [theItems release];
        }
        [cat release];
        tagIndex ++;
    }
}


- (void)dProductManager:(ProductManager *)om shouldShowAllCategories:(NSArray *)allCategories {
    catalogue=allCategories;
    //[self.slideView reloadData];
     [self appendDataToICarousel:catalogue];
    [self hideActivityIndicator];
}

- (void)didselectedObject:(NSInteger)index{}
#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    if (catalogue != nil) {
            return [catalogue count]+1;
    }
    
    return 0;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 260)] autorelease];
        
        UIImageView *frameView = [[UIImageView alloc] initWithImage:self.frameImage];
        [frameView setFrame:CGRectMake(0, 0, 260, 260)];
        [view addSubview:frameView];
        [frameView release];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 250, 250)];
        imageView.tag = 1;
        [view addSubview:imageView];
        [imageView release];
        
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-10, 260, 270, 50)] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:14.0];
        label.numberOfLines = 2;
        [view addSubview:label];
        
    }
    
    if ([catalogue count] == index) {
        
        for (UIView *subView in view.subviews) {
            
            if ([subView isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = (UIImageView *)subView;
                if (imageView.tag == 1) {
                    [imageView setImage:[UIImage imageNamed:@"loading-img.png"]];
                }
                
            }
            
        }
    }
    
    else{
        
        //id<CCObject> object = [catalogue objectAtIndex:index];
        Product *prd = [catalogue objectAtIndex:index];
        for (UIView *subView in view.subviews) {
            if ([subView isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)subView;
                
                label.text = [prd product_title];
            }
            if ([subView isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = (UIImageView *)subView;
                if (imageView.tag == 1) {
                    [imageView setImage:[UIImage imageNamed:prd.imageUrlSmall]];
                }
                
            }
            NSLog(@"index:%d  - prod_title:%@  - prod_img: %@  ", index, prd.product_title, prd.imageUrlSmall);
        }
    }
  
    return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return INCLUDE_PLACEHOLDERS? 2: 0;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    
    if (carousel.currentItemIndex == [catalogue count]) {
        [self loadMoreForICarousel];
    }
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //usually this should be slightly wider than the item views
    return ITEM_SPACING;
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * slideView.itemWidth);
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    
    if ([catalogue count] == index) {
        [self.moreView setBackgroundColor:[UIColor blueColor]];
        [self performSelectorInBackground:@selector(loadMoreForICarousel) withObject:nil];
    }
    else {
        [self didselectedObject:index];
    }
    
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionWrap) {
        value = 1.0;
    } else if (option == iCarouselOptionVisibleItems) {
        value = NUMBER_OF_VISIBLE_ITEMS;
    }
    return value;
}

#pragma mark - load more

- (void)loadMoreForICarousel{
    
    if(catalogue !=nil || [catalogue count]!=0){
            [self.slideView removeItemAtIndex:[catalogue count] animated:NO];
        }
    
    //[self loadObjects:self.currentPage];
}


- (void) appendDataToICarousel:(NSArray *)theRsArray{
    
    //[super appendData:theRsArray];
    
    if (theRsArray != nil && [theRsArray count] > 0 ) {
                   
            catalogue = theRsArray;
            
            [self.slideView reloadData];
            
    }
       
    
}

- (void)dealloc{
    
    slideView.delegate = nil;
    slideView.dataSource = nil;
    [slideView release];
     [moreView release];
    [loadMoreLabel release];
    [loadMoreIndicatoreView release];
     [super dealloc];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
