//
//  ItemsHorScrollViewController.m
//  gpt
//
//  Created by Johannes Dwiartanto on 7/26/11.
//  Copyright 2011 CellCity. All rights reserved.
//

#import "ItemsHorScrollViewController_iPhone.h"
#import "MyUtil.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "DItem.h"
//#import "UIImageView+AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ItemsHorScrollViewController_iPhone

@synthesize currentScrollView;
@synthesize pageControl;
@synthesize pageItems;
@synthesize requestManager;
@synthesize delegate;
@synthesize noOfPages;
@synthesize heightCatTitle;
@synthesize heightPageControl;
@synthesize heightScrollView;
@synthesize heightAdjust;
//@synthesize imageDownloader;
@synthesize otherInfo;
@synthesize textNoData;

#define TAG_HORSCROLLITEM_IMAGE_START 800
#define TAG_HORSCROLLITEM_ACTIVITYINDICATOR_IMAGE 2000

- (id)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        self.pageItems = [[[NSArray alloc] initWithArray:items] autorelease];
        self.noOfPages = ceil([pageItems count]/3);
        if(([pageItems count]%3)!=0){
            self.noOfPages+=1;
        }
        NSLog(@"nubmerofpages: %d",self.noOfPages);
    }
    return self;
}

- (void)dealloc
{
    //[imageDownloader release];
    [currentScrollView release];
    [pageControl release];
    [pageItems release];
    [requestManager release];
    [textNoData release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    //self.imageDownloader = [[[ImageDownloader alloc] initWithDelegate:self] autorelease];
    
    // Page Control
    self.pageControl = [[[UIPageControl alloc] initWithFrame:CGRectMake(0, self.heightScrollView, self.view.frame.size.width, self.heightPageControl)] autorelease];
	[self.pageControl setBackgroundColor:[UIColor clearColor]];
	[self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
	[self.pageControl setCurrentPage:0];
	[self.pageControl setNumberOfPages:self.noOfPages];
    [self.view addSubview:self.pageControl];
    
    // Scroll View
    self.currentScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.heightScrollView)] autorelease];
	self.currentScrollView.backgroundColor = [UIColor clearColor];
	self.currentScrollView.pagingEnabled = YES;
	self.currentScrollView.delegate = self;
    [self.currentScrollView setContentSize:CGSizeMake((self.view.frame.size.width * (self.noOfPages)), self.heightScrollView)];
    
    NSLog(@"itemsHorScrollViewController.contentSize  width=%f height=%f",self.currentScrollView.contentSize.width, self.currentScrollView.contentSize.height);
    
    [self.currentScrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    [self.view addSubview:self.currentScrollView];
    [self.currentScrollView setUserInteractionEnabled:YES];
    [self.currentScrollView setScrollEnabled:YES];
    [self.currentScrollView setExclusiveTouch:NO];
    [self.currentScrollView setMultipleTouchEnabled:YES];
    [self.currentScrollView setDirectionalLockEnabled:YES];
    
    // Populate
    [self populateView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.currentScrollView = nil;
    self.pageControl = nil;
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    //[self.imageDownloader cancel];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 

- (void) populateView {
    int xLoc = 0;
	int yLoc = 0;
    int pagecount = 0;
    int i = 0;
	int itemCount = 0;
    BOOL firstIconOnPage = TRUE;
	while (i < [self.pageItems count]) {
        
        DItem * myitem = (DItem *)[self.pageItems objectAtIndex:i];
        
        //DebugLog("content %d  x=%d",itemCount,x);
        
		if (itemCount % 3 == 0) {
			if (itemCount>0) {
                pagecount++;
            }
			firstIconOnPage = TRUE;
			itemCount = 0;
		}
		
		if (firstIconOnPage) {
			xLoc = (self.view.frame.size.width * pagecount) + 8;
			firstIconOnPage = FALSE;
		}
		else {
			xLoc = xLoc + 95 + 10;
		}
		
        /* Temporary
        UIButton * buttonCat = [UIButton buttonWithType:UIButtonTypeCustom];
		//[buttonCat setBackgroundImage:myoffer.offerImage forState:UIControlStateNormal];
		buttonCat.frame = CGRectMake(xLoc, yLoc, 95, 100-self.heightAdjust);
		buttonCat.tag = TAG_HORSCROLLITEM_IMAGE_START + i;
		[buttonCat addTarget:self action:@selector(tapItem:) forControlEvents:UIControlEventTouchUpInside];
        */
        
        ////////
        CGFloat heightImg = 66.6; //95*66.6 = 97*68
        //UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(xLoc, yLoc, 95, 90-self.heightAdjust)];
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(xLoc, yLoc, 95, heightImg)];
        [imgView setUserInteractionEnabled:YES];
        UIButton * buttonCat = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonCat setBackgroundColor:[UIColor clearColor]];
		buttonCat.frame = imgView.bounds;
		buttonCat.tag = TAG_HORSCROLLITEM_IMAGE_START + i;
		[buttonCat addTarget:self action:@selector(tapItem:) forControlEvents:UIControlEventTouchUpInside];
        [imgView addSubview:buttonCat];
        [imgView setContentMode:UIViewContentModeScaleToFill];
        
       /* UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGRect f = activityIndicator.frame;
        f.origin.x = imgView.frame.size.width/2 - activityIndicator.frame.size.width/2;
        f.origin.y = imgView.frame.size.height/2 - activityIndicator.frame.size.height/2;
        activityIndicator.frame = f;
        [activityIndicator setHidesWhenStopped:YES];
        [activityIndicator setColor:[UIColor lightGrayColor]];
        [imgView addSubview:activityIndicator];
        [activityIndicator startAnimating];*/
       // NSString * imageURL = [NSString stringWithFormat:@"%@%@", BASE_URL, myitem.imageUrlSmall];
        NSString * theImageUrl = [NSString stringWithFormat:@"%@%@", BASE_URL, myitem.imageUrlSmall];
        //cell.image.image = [UIImage imageNamed:theImageUrl];
        [imgView setImageWithURL:[NSURL URLWithString:theImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
       /* [imgView setImageWithURL:[NSURL URLWithString:imageURL]
                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                           success:^(UIImage *image, BOOL cached) {
                               [activityIndicator stopAnimating];
                           }
                           failure:^(NSError *error) {
                               [activityIndicator stopAnimating];
                           }];*/
        
       // [activityIndicator release];
        [self.currentScrollView addSubview:imgView];
        [imgView release];
        //////
        
        //[self.currentScrollView addSubview:buttonCat]; // TEMP
        
        CGFloat yTitle = yLoc + heightImg + 6;
        CGFloat heightTitle = 15;
        //UILabel *itemTitle = [[UILabel alloc] initWithFrame:CGRectMake(xLoc,105-self.heightAdjust,95,20)];
        UILabel *itemTitle = [[UILabel alloc] initWithFrame:CGRectMake(xLoc,yTitle,95,heightTitle)];
        itemTitle.textColor= [UIColor orangeColor];
        itemTitle.backgroundColor=[UIColor clearColor];
        itemTitle.font= [UIFont boldSystemFontOfSize:13.0];
        itemTitle.text = myitem.title;
       // itemTitle.text = myitem.store.storeName;
       // itemTitle.textAlignment= UITextAlignmentLeft;
       // [itemTitle setLineBreakMode:UILineBreakModeTailTruncation];
        itemTitle.numberOfLines=1;
        [self.currentScrollView addSubview:itemTitle];
        [itemTitle release];
        
        CGFloat ySubTitle = yTitle + heightTitle + 3;
        CGFloat heightSubTitle = 30;
        //UILabel *itemSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(xLoc,130-self.heightAdjust,95,28)];
        UILabel *itemSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(xLoc,ySubTitle,95,heightSubTitle)];
        itemSubTitle.textColor= [UIColor whiteColor];
        itemSubTitle.backgroundColor=[UIColor clearColor];
        itemSubTitle.font= [UIFont boldSystemFontOfSize:12.0];
        itemSubTitle.text = myitem.title; // @"Article Description here";
    //    itemSubTitle.textAlignment= UITextAlignmentLeft;
    //    [itemSubTitle setLineBreakMode:UILineBreakModeWordWrap];
        itemSubTitle.numberOfLines=2;
        [self.currentScrollView addSubview:itemSubTitle];
        [itemSubTitle release];
        
		itemCount++;
		i++;
	}
}

#pragma mark ImageDownloader

/*
- (void)imageDownloader:(ImageDownloader *)imgDownloader didDownloadImage:(UIImage *)imgDownloaded withImageId:(NSString *)imgId {
    int index = [imgId integerValue];
    int theId = TAG_HORSCROLLITEM_IMAGE_START + index;
    
    DebugLog("didDownloadImage theId=%d",theId);
    
    Offer * offerobj = (Offer *)[self.pageItems objectAtIndex:index];
    offerobj.offerImage = imgDownloaded;
    
    UIButton * btn = (UIButton *)[self.currentScrollView viewWithTag:theId];
    [btn setBackgroundImage:imgDownloaded forState:UIControlStateNormal];
    [btn setNeedsDisplay];
    
    [(UIActivityIndicatorView *)[btn viewWithTag:(btn.tag + TAG_HORSCROLLITEM_ACTIVITYINDICATOR_IMAGE)] stopAnimating];
}
*/

#pragma mark -

- (void) tapItem:(id)sender {
    UIButton * button = (UIButton *)sender;
    if (!button || button == (id)[NSNull null]) {
        return;
    }
    NSInteger itemId = button.tag - TAG_HORSCROLLITEM_IMAGE_START; //[NSString stringWithFormat:@"%d",button.tag];
    
    NSLog(@"... tapItem:%d ...",itemId);
    
    [self.delegate itemsHorScrollViewController:self didTapItemWithId:itemId];
    
    // Tracker
    /*
    [MyTracker logEvent:TRACK_EVENT_CATEGORY withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            categoryId, @"CategoryId",
                                                            catName, @"CategoryName", 
                                                            nil]];
     */
}


#pragma mark - RequestManagerDelegate

- (void) requestManager:(AFRequestManager *)sh didGetResults:(NSDictionary *)resultsIn withError:(NSString *)errorIn ofQuery:(QueryType)qType {
}


#pragma mark - UIScrollView

- (void)changePage:(id)sender
{
    int page = self.pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    
	// update the scroll view to the appropriate page
    CGRect frame = currentScrollView.frame;
    frame.origin.x = 320 * page;
    frame.origin.y = 0;
    [self.currentScrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}


#pragma mark Scroll View Delegates

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = currentScrollView.frame.size.width;
    int page = floor((currentScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}


#pragma mark -

- (void) cancel {
    //[self.imageDownloader cancel];
}


@end
