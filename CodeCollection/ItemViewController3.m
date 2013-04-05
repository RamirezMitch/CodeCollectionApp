//
//  ItemViewController3.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 22/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "ItemViewController3.h"
#import "DItem.h"
#import "Category.h"
#import "AppDelegate.h"
#define OFFER_SUBVIEW_TAG     100
#define ITEMSCROLL_TAG        200
#define VIEW_TAG              0
#define HEIGHT_OFFER_SECTION        190
#define HEIGHT_CONTENT_BASE_VIEW    326
#define HEIGHT_OFFER_SECTION_EMPTY  90
#define TAG_OFFER_START_BASEVIEW    3000


@implementation ItemViewController3
@synthesize itemManager, pageItems, mainScrollView, viewOffersByCategory, arrayOffersHorScrollViewCont, tagLastView,categoryManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.arrayOffersHorScrollViewCont = [[[NSMutableArray alloc] init] autorelease];
        self.tagLastView = TAG_OFFER_START_BASEVIEW;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Main scrollView
    self.mainScrollView =[[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    self.mainScrollView.backgroundColor = [UIColor clearColor];
    self.mainScrollView.delegate=self;
    self.mainScrollView.scrollEnabled=YES;
    [self.mainScrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    [self.mainScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    [self.mainScrollView setBackgroundColor:[UIColor blackColor]];
    [self.mainScrollView setUserInteractionEnabled:YES];
    [self.mainScrollView setMultipleTouchEnabled:YES];
    [self.mainScrollView setExclusiveTouch:NO];
    [self.mainScrollView setClipsToBounds:YES];
    [self.view addSubview:self.mainScrollView];
    
    self.itemManager = [[[DItemManager alloc] initWithDelegate:self] autorelease];
    [self.itemManager requestAllItems];
    self.categoryManager = [[[DItemManager alloc] initWithDelegate:self] autorelease];
    [self.categoryManager requestCategories];
}

-(void)viewWillAppear:(BOOL)animated{
       /* self.requestManager = [[[AFRequestManager alloc] initWithDelegate:self withQueryType:QueryTypeOffersAllCategories]autorelease];
    
    [self.requestManager requestWithSuffixPath:@"" paramKeys:[NSArray arrayWithObjects:@"catIds", @"page",@"itemspercat", nil] values:[NSArray arrayWithObjects:@"ce48e178-88fb-4f7f-a0ab-b0d59d3502ea,de391a14-3536-4a71-8fc8-52cf6877a5e9,41e197ff-e362-40fa-b688-bbe18de6c1ae,82a023b7-f0a8-4836-8077-95fdddaea94b,d4f067b6-d22f-4749-91d2-7505a3aa3740,10bae0b9-7058-486c-8e6a-cdd88e5c8a56,08d3be5d-bc5e-4ca6-9241-e024109e2074,57359977-73c4-4c83-910a-dc165beb079d,179f2f7c-9547-4501-a3ba-e9d4cd8b6b16,fd461612-520a-455b-b512-ca8ea3338231",@"1",@"20",nil]];
    */
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.itemManager cancelRequest];

}

- (void) adjustScrollViewContentSize {
    CGSize currentSize = self.mainScrollView.contentSize;
    CGFloat currentHeight = currentSize.height;
    if ((yPosition+HEIGHT_OFFER_SECTION) > HEIGHT_CONTENT_BASE_VIEW) {
        CGFloat newHeight = currentHeight + HEIGHT_OFFER_SECTION;
        [self.mainScrollView setContentSize:CGSizeMake(currentSize.width, newHeight)];
    }
}

- (UIView *) baseViewForOfferSection {
    
    UIView * baseView = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition, self.view.frame.size.width, HEIGHT_OFFER_SECTION)];
    baseView.tag = self.tagLastView;
    baseView.backgroundColor= [UIColor blackColor];
    
    yPosition += HEIGHT_OFFER_SECTION;
    self.tagLastView++;
    
    return [baseView autorelease];
}

-(void) dItemManager:(DItemManager *)om shouldShowOffersInAllCategories:resultArray{
    NSInteger tagIndex = 0;
    for (NSDictionary *item in resultArray) {
        
        NSDictionary *catItem = [item objectForKey:@"Category"];
        Category *cat = [[Category alloc] initWithDictionary:catItem];
        
        NSArray *itemList = [item objectForKey:@"OfferList"];
        if ([itemList count]) {
            // show offers only when offer list not empty
            NSMutableArray *theItems = [[NSMutableArray alloc] init];
            for (NSDictionary *itemDict in itemList) {
                DItem *itm = [[DItem alloc] initWithDictionary:itemDict];
                [theItems addObject:itm];
                [itm release];
            }
            
            [self adjustScrollViewContentSize];
            UIView * baseView = [self baseViewForOfferSection];
            [self addBaseView:baseView
                       offers:theItems
                        title:cat.catname
                          tag:tagIndex];
            [theItems release];
        }
        [cat release];
        tagIndex ++;
    }
}

- (void) addBaseView:(UIView *)baseViewIn offers:(NSArray *)offersIn title:(NSString *)titleIn tag:(NSUInteger)tagIn {
    // Title
    CGFloat heightTitle = 40;
    UILabel * labelCatTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width, heightTitle)];
    [labelCatTitle setBackgroundColor:[UIColor blackColor]];
    [labelCatTitle setText:titleIn];
    [labelCatTitle setTextColor:[UIColor orangeColor]];
    [labelCatTitle setFont:[UIFont boldSystemFontOfSize:15]];
   // [labelCatTitle setTextAlignment:UITextAlignmentLeft];
   // [labelCatTitle setLineBreakMode:UILineBreakModeTailTruncation];
    [labelCatTitle setNumberOfLines:1];
    [baseViewIn addSubview:labelCatTitle];
    [labelCatTitle release];
    
    if (offersIn && [offersIn count]>0) {
        // Scroll View
        ItemsHorScrollViewController_iPhone * ihsc = [[ItemsHorScrollViewController_iPhone alloc] initWithItems:offersIn];
        [ihsc setDelegate:self];
        [ihsc setHeightPageControl:8];
        [ihsc setHeightScrollView:130];
        [ihsc setHeightAdjust:23.4]; // to the image is 95*66.6 (=97*68)
        [ihsc.view setFrame:CGRectMake(0, heightTitle, self.view.frame.size.width, HEIGHT_OFFER_SECTION)];
        [ihsc setOtherInfo:tagIn];
        [baseViewIn addSubview:ihsc.view];
        [self.arrayOffersHorScrollViewCont addObject:ihsc];
        [ihsc release];
    }
    else {
        // Empty message
        UILabel * labelEmptyOffer = [[UILabel alloc] initWithFrame:CGRectMake(10, heightTitle-10, self.view.frame.size.width-20, HEIGHT_OFFER_SECTION_EMPTY-heightTitle)];
        [labelEmptyOffer setNumberOfLines:0];
        [labelEmptyOffer setLineBreakMode:UILineBreakModeWordWrap];
        [labelEmptyOffer setFont:[UIFont boldSystemFontOfSize:12]];
        [labelEmptyOffer setTextColor:[UIColor whiteColor]];
        [labelEmptyOffer setBackgroundColor:[UIColor clearColor]];
        [labelEmptyOffer setText:[NSString stringWithFormat:@"No Offer"]];
        [baseViewIn addSubview:labelEmptyOffer];
        [labelEmptyOffer release];
    }
    
    // Line
    CGFloat heightLine = 1;
    UIView * viewLine = [[UIView alloc] initWithFrame:CGRectMake(10, baseViewIn.frame.size.height-1, baseViewIn.frame.size.width-20, heightLine)];
    [viewLine setBackgroundColor:[UIColor grayColor]];
    [baseViewIn addSubview:viewLine];
    [viewLine release];
    
    baseViewIn.tag = tagIn;
    [self.mainScrollView addSubview:baseViewIn];
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
            
            [self adjustScrollViewContentSize];
            UIView * baseView = [self baseViewForOfferSection];
            [self addBaseView:baseView
                       offers:theItems
                        title:cat.catname
                          tag:tagIndex];
            [theItems release];
        }
        [cat release];
        tagIndex ++;
    }
}

- (void) dItemManager:(DItemManager *)om shouldShowAllCategories:(NSArray *)allCategories {
    NSLog(@"allcateogries: %@",allCategories);
}
#pragma mark - Delegate

- (void) itemsHorScrollViewController:(ItemsHorScrollViewController_iPhone *)cvc didTapItemWithId:(NSInteger)itemId {
    
    NSLog(@"itemId tapped: %d", itemId);

        int catIndex = cvc.otherInfo;
        Category * c = (Category *)[self.itemManager.allCategories objectAtIndex:catIndex];
        NSArray * theItems = [self.itemManager.itembyCategoryDict objectForKey:c.catId];
        DItem * itm = [theItems objectAtIndex:itemId];
         NSLog(@"DItem tapped: %@", itm);
}


#pragma mark -

-(void)dealloc{
     [mainScrollView release];
   [arrayOffersHorScrollViewCont release];
    [itemManager release];
    [categoryManager release];
    [pageItems release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
