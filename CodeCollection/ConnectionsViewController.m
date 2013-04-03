//
//  FirstViewController.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 9/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "ConnectionsViewController.h"
#import "Atlas.h"
#import "NativeRequestManager.h"
#import "NativeAPIManager.h"
@implementation ConnectionsViewController
@synthesize dItemManager,asiRequestManager,nativeRequestManager, arrayAllItems;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Connect", @"Connect");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)asiNetworking:(id)sender{
    self.asiRequestManager = [[[ASIRequestManager alloc]initWithDelegate:self] autorelease];
    [self.asiRequestManager requestAllItems];
}

-(IBAction)afNetworking:(id)sender{
    self.dItemManager = [[[DItemManager alloc] initWithDelegate:self] autorelease];
    [self.dItemManager requestAllItems];
}

-(IBAction)nativeNetworking:(id)sender{
  //arrayAllItems =  [[NativeAPIManager defaultManager] arrayAllItems];
   // NSLog(@"arrayallitems: %@",arrayAllItems);
     [[DataLibrary instance] loadAllItemswithDelegate:self];
   /* if(nativeRequestManager!=nil)
	{
		[nativeRequestManager release];
		nativeRequestManager = nil;
	}
	
	NSString *urlString = @"http://www.melbournecentral.com.au/api/servicecms.svc/GetOffersByCategories?catIds=ce48e178-88fb-4f7f-a0ab-b0d59d3502ea,de391a14-3536-4a71-8fc8-52cf6877a5e9,41e197ff-e362-40fa-b688-bbe18de6c1ae,82a023b7-f0a8-4836-8077-95fdddaea94b,d4f067b6-d22f-4749-91d2-7505a3aa3740,10bae0b9-7058-486c-8e6a-cdd88e5c8a56,08d3be5d-bc5e-4ca6-9241-e024109e2074,57359977-73c4-4c83-910a-dc165beb079d,179f2f7c-9547-4501-a3ba-e9d4cd8b6b16,fd461612-520a-455b-b512-ca8ea3338231&itemspercat=20&page=1";
    
    nativeRequestManager = [[NativeRequestManager alloc] initWithReadingURL:urlString];
    [nativeRequestManager loadData:self];
*/
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.dItemManager cancelRequest];
}

- (void) requestManager:(AFRequestManager *)sh didGetResults:(NSDictionary *)resultsIn withError:(NSString *)errorIn ofQuery:(QueryType)qType {
        NSLog(@"did getresults!!!");
   /* if ([qId isEqualToString:CC_API_QUERYID_GET_BANNER_SEASONAL]) {
        NSArray * array = (NSArray *)[resultsIn objectForKey:@"data"];
        
        DebugLog("Get banner array=%@",array);
        
        if (array && array != (id)[NSNull null] && [array isKindOfClass:[NSArray class]] && [array count]>0) {
            
            NSDictionary * dict = [[NSDictionary alloc] initWithDictionary:(NSDictionary *) [array objectAtIndex:0]];; // the first
            self.bannerSeasonal = [[[GPTBanner alloc] initWithDictionary:dict] autorelease];
            [dict release];
            
            DebugLog("Get banner imageURL=%@",self.bannerSeasonal.imageURL);
            
            if (self.bannerSeasonal.imageURL && self.bannerSeasonal.imageURL!=(id)[NSNull null] && ![self.bannerSeasonal.imageURL isEqualToString:@""]) {
                self.hasBannerTop = YES;
                [self showTopBannerImage];
            }
            else {
                self.hasBannerTop = NO;
            }
        }
    }*/
}

- (void)dItemManager:(DItemManager *)om willRequestItem:(BOOL)will {
    if (will) {
      //  [self showHud:HudActionLoading];
            NSLog(@"willrequest items!!!");
    }
}

- (void) dItemManager:(DItemManager *)om shouldShowAllItems:(NSArray *)allItems {
    NSLog(@"allItems=%@",allItems);

    
   /* DebugLog("----");
    DebugLog("offersInAllCats=%@",offersInAllCats);
    
    [self hideHud];
    
    NSInteger tagIndex = 0;
    int seasonalcount=0;
    int nEmptyOffers = 0;
    
    for (NSDictionary *item in offersInAllCats) {
        
        NSDictionary *catItem = [item objectForKey:@"Category"];
        Category *cat = [[Category alloc] initWithDictionary:catItem];
        
        NSArray *offerList = [item objectForKey:@"OfferList"];
        if ([offerList count]) { // show offers only when offer list not empty
            
            NSMutableArray *theOffers = [[NSMutableArray alloc] init];
            for (NSDictionary *offerDict in offerList) {
                Offer *ofr = [[Offer alloc] initWithDictionary:offerDict];
                [theOffers addObject:ofr];
                [ofr release];
            }
            
            [self adjustScrollViewContentSize];
            UIView * baseView = [self baseViewForOfferSection];
            [self addBaseView:baseView
                       offers:theOffers
                        title:cat.catname
                          tag:tagIndex];
            [theOffers release];
        } else {
            if(isBrowseSeasonal){   // Why mixed with seasonal offers? Seasonal offers should have its own class - needs to subclass
                seasonalcount+=1;
                if(seasonalcount==[self.seasonalArray count]){
                    [self showNoOfferText:YES];
                }
            }
            else {
                nEmptyOffers++;
                if (nEmptyOffers == [offersInAllCats count]) {
                    [self showNoOfferText:YES];
                }
            }
        }
        [cat release];
        tagIndex ++;
    }
    
    DebugLog("----");
    */
}

//For ASIHTTYPRequest
- (void)dASIRequestManager:(ASIRequestManager *)om willRequestItem:(BOOL)will{
    NSLog(@"willrequest items!!!");
}

- (void)dASIRequestManager:(ASIRequestManager *)om shouldShowAllItems:(NSArray *)allItems{
     NSLog(@"allItems=%@",allItems);
}

//Native NSURL Connection Request
-(void)retrieveData
{
    arrayAllItems = [[DataLibrary instance] getItemsArray];
}

-(void)dataLoadedWithError:(NativeRequestManager *)dataReader
{
	
	/*UIAlertView * locationAlert = [[UIAlertView alloc] initWithTitle:Localization(APP_TITLE)
     message:Localization(MESSAGE_CONNECTION_ERROR)
     delegate:nil
     cancelButtonTitle:Localization(BUTTON_OK)
     otherButtonTitles:nil];
     [locationAlert show];
     [locationAlert release];*/
}
/*-(void)dataLoaded:(NativeRequestManager *)dataReader
{
    NSDictionary *data = [dataReader getData];
    
    NSLog(@"Data Result: %@",data);
}*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
   // [_request release];
    [arrayAllItems release];
    [super dealloc];
}

@end
