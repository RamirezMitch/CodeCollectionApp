//
//  ItemViewController4.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 22/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "ItemViewController4.h"
#import "DItem.h"
#import "Product.h"
#import "Category.h"


@interface ItemViewController4 (private)
- (void)updateLayout:(UIInterfaceOrientation)interfaceOrientation;
- (void)initialTransaction;
- (void)initializeCoupons;
@end


@implementation ItemViewController4
@synthesize sheet,currentSheet,nextSheet,previousSheet,pageView;
@synthesize itemCategoryDictionary,itemsMutableArray;
@synthesize productManager;

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
    currentSheet = [[PageSheetView alloc] initWithFrame:CGRectMake(0, 0, self.sheet.frame.size.width, self.sheet.frame.size.height)];
	nextSheet = [[PageSheetView alloc] initWithFrame:CGRectMake(0, 0, self.sheet.frame.size.width, self.sheet.frame.size.height)];
	previousSheet = [[PageSheetView alloc] initWithFrame:CGRectMake(0, 0, self.sheet.frame.size.width, self.sheet.frame.size.height)];
	self.nextSheet.hidden = YES;
	self.previousSheet.hidden = YES;
	
	pageView = [[PageView alloc] initWithFrame:CGRectMake(0, 0, self.sheet.frame.size.width, self.sheet.frame.size.height)];
	self.pageView._delegate = self;
	self.pageView.hidden = YES;
	self.pageView.currentPageIndex = 0;
	self.pageView.totalPageNumber = 0;
	
	self.pageView.currentView = self.currentSheet;
	self.pageView.nextView = self.nextSheet;
	self.pageView.previousView = self.previousSheet;
	self.currentSheet.pageView = self.pageView;
	self.nextSheet.pageView = self.pageView;
	self.previousSheet.pageView = self.pageView;
	[self.sheet addSubview:self.currentSheet];
	[self.sheet addSubview:self.nextSheet];
	[self.sheet addSubview:self.previousSheet];
	[self.sheet addSubview:self.pageView];
}
- (void)dealloc
{
	[sheet release];
	[currentSheet release];
	[nextSheet release];
	[previousSheet release];
	[pageView release];
	[itemCategoryDictionary release];
    [itemsMutableArray release];
    [super dealloc];
}
- (void)updateLayout:(UIInterfaceOrientation)interfaceOrientation
{
	if ((interfaceOrientation == UIInterfaceOrientationPortrait) ||
		(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
		self.sheet.frame = CGRectMake(0, 0, 320, 548);
	} else {
		self.sheet.frame = CGRectMake(0, 0, 568, 240);
    }
	
	[self.currentSheet updateLayout:interfaceOrientation];
	[self.nextSheet updateLayout:interfaceOrientation];
	[self.previousSheet updateLayout:interfaceOrientation];
}
- (void)initialTransaction
{
	
   // [self loadItems];
    self.productManager = [[[ProductManager alloc] initWithDelegate:self :NO] autorelease];
    [self.productManager loadXLS];
}

- (void)loadItems{
    self.requestManager = [[[AFRequestManager alloc] initWithDelegate:self withQueryType:QueryTypeOffersAllCategories]autorelease];
    
    [self.requestManager requestWithSuffixPath:@"" paramKeys:[NSArray arrayWithObjects:@"catIds", @"page",@"itemspercat", nil] values:[NSArray arrayWithObjects:@"ce48e178-88fb-4f7f-a0ab-b0d59d3502ea,de391a14-3536-4a71-8fc8-52cf6877a5e9,41e197ff-e362-40fa-b688-bbe18de6c1ae,82a023b7-f0a8-4836-8077-95fdddaea94b,d4f067b6-d22f-4749-91d2-7505a3aa3740,10bae0b9-7058-486c-8e6a-cdd88e5c8a56,08d3be5d-bc5e-4ca6-9241-e024109e2074,57359977-73c4-4c83-910a-dc165beb079d,179f2f7c-9547-4501-a3ba-e9d4cd8b6b16,fd461612-520a-455b-b512-ca8ea3338231",@"1",@"20",nil]];

}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [self updateLayout:self.interfaceOrientation];
	[self initialTransaction];
}
- (void)viewDidDisappear:(BOOL)animated
{
	[self.currentSheet clearContents];
	[self.nextSheet clearContents];
	[self.previousSheet clearContents];
	self.pageView.totalPageNumber = 1;
	self.pageView.currentPageIndex = 0;
}
- (void) afrequestManager:(AFRequestManager *)sh didGetResults:(NSDictionary *)resultsIn withError:(NSString *)errorIn ofQuery:(QueryType)qType {
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init]; // for passing
    NSMutableArray *allOffers = [[NSMutableArray alloc]init];
    
    NSArray *array = [resultsIn objectForKey:@"Data"];
    if (array!=nil && array!=(id)[NSNull null] && [array count]>0){
        for (int i=0; i<[array count]; i++) {
            NSDictionary * mainDict = [array objectAtIndex:i];
            
            NSDictionary * catDict = [mainDict objectForKey:@"Category"];
            if (catDict!=(id)[NSNull null]) {
                Category * c = [[Category alloc] initWithDictionary:catDict];
                
                NSArray *offerList = [mainDict objectForKey:@"OfferList"];
                if (offerList!=(id)[NSNull null]) {
                    NSMutableArray * offerObjList = [[NSMutableArray alloc] init];
                    for (int j=0; j<[offerList count]; j++) {
                        NSDictionary * offerDict = [offerList objectAtIndex:j];
                        DItem *offerObj = [[DItem alloc] initWithDictionary:offerDict];
                        [offerObjList addObject:offerObj];
                        [allOffers addObject:offerDict];
                        [offerObj release];
                    }
                     [self.itemCategoryDictionary setObject:offerObjList forKey:c.catId];
                   //   [allOffers addObject:offerObjList];
                    [offerObjList release];
                }
                [c release];
            }
            
            [resultArray addObject:mainDict];
        } //end forloop
        NSMutableArray *offerarray = [[[NSMutableArray alloc] init] autorelease];
        for (int i=0; i<[allOffers count]; i++) {
            NSDictionary *dic = (NSDictionary *)[allOffers objectAtIndex:i];
            DItem *itemObj = [[DItem alloc] initWithDictionary:dic];
            [offerarray addObject:itemObj];
            [itemObj release];
            
            NSLog(@"Offer populated i=%d",i);
            
        }
        self.itemsMutableArray=[NSArray arrayWithArray:offerarray];
        NSLog(@"itemsMutableArray:%@",itemsMutableArray);
        [self initializeIndulgeCoupons];
    }
}

- (void)dProductManager:(ProductManager *)om shouldShowAllItems:(NSMutableDictionary *)allItems {
    //Using ProductManager
    self.itemsMutableArray=[NSArray arrayWithArray:allItems];
    NSLog(@"itemsMutableArray:%@",itemsMutableArray);
    [self initializeIndulgeCoupons];
}
- (void)couponViewClicked:(id)sender
{
    DItem* senderCouponView = (DItem*)[(UIButton*)sender superview];
	NSLog(@"%@",senderCouponView.title);
}

- (void)initializeIndulgeCoupons
{
	int totalContents = [itemsMutableArray count];
	self.pageView.totalPageNumber = 1+(totalContents-1)/6;
	self.pageView.currentPageIndex = 0;
		
	PageSheetView* current	= (PageSheetView*)self.pageView.currentView;
	PageSheetView* next		= (PageSheetView*)self.pageView.nextView;
	PageSheetView* previous = (PageSheetView*)self.pageView.previousView;
	
	[current	applyDealsPageIndex:0 contents:itemsMutableArray];
	[next		applyDealsPageIndex:1 contents:itemsMutableArray];
	[previous	applyDealsPageIndex:-1 contents:itemsMutableArray];
	[current	updateCouponViewVisibility:self.interfaceOrientation];
	[next		updateCouponViewVisibility:self.interfaceOrientation];
	[previous	updateCouponViewVisibility:self.interfaceOrientation];
}
- (void)didIncrementPage:(int)toIndex
{
	UIView* tmpPageSheetView = self.pageView.previousView;
	self.pageView.previousView = self.pageView.currentView;
	self.pageView.currentView = self.pageView.nextView;
	self.pageView.nextView = tmpPageSheetView;
	
	PageSheetView* current	= (PageSheetView*)self.pageView.currentView;
	PageSheetView* next		= (PageSheetView*)self.pageView.nextView;
	PageSheetView* previous = (PageSheetView*)self.pageView.previousView;
	
	current.hidden = NO;
	next.hidden = YES;
	previous.hidden = YES;
	
    [next applyDealsPageIndex:toIndex+1 contents:itemsMutableArray];
	[current	updateCouponViewVisibility:self.interfaceOrientation];
	[next		updateCouponViewVisibility:self.interfaceOrientation];
	[previous	updateCouponViewVisibility:self.interfaceOrientation];
	
}
- (void)didDecrementPage:(int)toIndex
{
	UIView* tmpPageSheetView = self.pageView.nextView;
	self.pageView.nextView = self.pageView.currentView;
	self.pageView.currentView = self.pageView.previousView;
	self.pageView.previousView = tmpPageSheetView;
	
	PageSheetView* current	= (PageSheetView*)self.pageView.currentView;
	PageSheetView* next		= (PageSheetView*)self.pageView.nextView;
	PageSheetView* previous = (PageSheetView*)self.pageView.previousView;
	
	current.hidden = NO;
	next.hidden = YES;
	previous.hidden = YES;
	
	[previous applyDealsPageIndex:toIndex-1 contents:itemsMutableArray];
	[current	updateCouponViewVisibility:self.interfaceOrientation];
	[next		updateCouponViewVisibility:self.interfaceOrientation];
	[previous	updateCouponViewVisibility:self.interfaceOrientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
