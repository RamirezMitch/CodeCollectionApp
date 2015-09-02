//
//  ItemViewController1.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 17/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "ItemViewController1.h"
#import "MyUtil.h"
#import "DItem.h"
#import "AFRequestManager.h"
#import "DItemManager.h"
#import "Category.h"
#define TAG_TABLEVIEW_MP 888
@interface ItemViewController1 ()

@end

@implementation ItemViewController1
@synthesize itemList,itemsTableViewController,viewBase,requestManager,productManager;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    self.productManager = [[[ProductManager alloc] initWithDelegate:self :NO] autorelease];
    [self.productManager loadXLS];
    
    /*self.requestManager = [[[AFRequestManager alloc] initWithDelegate:self withQueryType:QueryTypeOffersAllCategories]autorelease];
    
    [self.requestManager requestWithSuffixPath:@"" paramKeys:[NSArray arrayWithObjects:@"catIds", @"page",@"itemspercat", nil] values:[NSArray arrayWithObjects:@"ce48e178-88fb-4f7f-a0ab-b0d59d3502ea,de391a14-3536-4a71-8fc8-52cf6877a5e9,41e197ff-e362-40fa-b688-bbe18de6c1ae,82a023b7-f0a8-4836-8077-95fdddaea94b,d4f067b6-d22f-4749-91d2-7505a3aa3740,10bae0b9-7058-486c-8e6a-cdd88e5c8a56,08d3be5d-bc5e-4ca6-9241-e024109e2074,57359977-73c4-4c83-910a-dc165beb079d,179f2f7c-9547-4501-a3ba-e9d4cd8b6b16,fd461612-520a-455b-b512-ca8ea3338231",@"1",@"20",nil]];*/

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.itemsTableViewController = [[[ItemsTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    [self.itemsTableViewController setDelegate:self];
    [self.itemsTableViewController.view setFrame:self.viewBase.bounds];
    [self.itemsTableViewController setIsEditable:YES];
    [self.viewBase addSubview:self.itemsTableViewController.view];
   // [self.viewBase.layer setMasksToBounds:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) afrequestManager:(AFRequestManager *)sh didGetResults:(NSDictionary *)resultsIn withError:(NSString *)errorIn ofQuery:(QueryType)qType {
      NSLog(@"*** ALL ITEMS: resultIn=%@ ***",resultsIn);
   /* NSDictionary * dict = (NSDictionary *)[resultsIn objectForKey:@"Data"];
    NSArray * offerListIn = (NSArray *)[dict objectForKey:@"OfferList"];
    self.itemList = [NSArray arrayWithArray:offerListIn];*/
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
                   // [self.itembyCategoryDict setObject:offerObjList forKey:c.catId];
                  //  [allOffers addObject:offerObjList];
                    [offerObjList release];
                }
                [c release];
            }
            
            [resultArray addObject:mainDict];
        } //end forloop
        self.itemList=[NSArray arrayWithArray:allOffers];
        
        self.itemsTableViewController = [[[ItemsTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        [self.itemsTableViewController setDelegate:self];
        [self.itemsTableViewController.view setFrame:self.viewBase.bounds];
        [self.itemsTableViewController setIsEditable:YES];
        [self.viewBase addSubview:self.itemsTableViewController.view];
        [self.itemsTableViewController.view setTag:TAG_TABLEVIEW_MP];
        //[self.view sendSubviewToBack:self.viewBase];
       // [self.viewBase.layer setMasksToBounds:YES];

        [self.itemsTableViewController populateItemsFromRawResponse:[NSMutableArray arrayWithArray:self.itemList]];
        [self.itemsTableViewController showTable];
        [self.itemsTableViewController setEditing:NO animated:NO];
        //[self.delegate dItemManager:self shouldShowOffersInAllCategories:resultArray];
    }

}
- (void)dProductManager:(ProductManager *)om shouldShowAllItems:(NSMutableDictionary *)allItems {
    //Using ProductManager
    self.itemList=[NSArray arrayWithArray:allItems];
    self.itemsTableViewController = [[[ItemsTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    [self.itemsTableViewController setDelegate:self];
    [self.itemsTableViewController.view setFrame:self.viewBase.bounds];
    [self.itemsTableViewController setIsEditable:YES];
    [self.viewBase addSubview:self.itemsTableViewController.view];
    [self.itemsTableViewController.view setTag:TAG_TABLEVIEW_MP];
    [self.itemsTableViewController populateItemsFromRawResponse:[NSMutableArray arrayWithArray:self.itemList]];
    [self.itemsTableViewController showTable];
    [self.itemsTableViewController setEditing:NO animated:NO];
}
#pragma mark -

- (void) mainTableViewController:(MainTableViewController *)itvc shouldRetrieveListOfItems:(BOOL)toRetrieve {
    
    NSLog(@"shouldRetrieveListOfItems....");
}

- (void) mainTableViewController:(MainTableViewController *)itvc didRetrieveListOfItems:(NSArray *)items withError:(NSString *)errorIn {

    if (errorIn==nil) {
        if (itvc==self.itemsTableViewController) {
            [self.itemsTableViewController showTable];
        }
    }
    else {
           NSLog(@"NO RESULTS");
    }
}

- (void) mainTableViewController:(MainTableViewController *)itvc shouldShowDetailsOfItem:(id)i atSectionIndex:(int)sIdx atRowIndex:(int)rIdx {
    if(itvc==self.itemsTableViewController){
        DItem * dItem = (DItem *)i;
        NSLog(@"The Item: %@",dItem);
       /* OfferDetailViewController_iPhone * odvc = [[OfferDetailViewController_iPhone alloc] initWithNibName:@"OfferDetailViewController_iPhone" bundle:nil];
        [odvc setCurrentOffer:offer];
        [odvc setArrayOffer:self.offersTableViewController.items];
        [odvc setCurrentIndex:rIdx];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.plannerNav pushViewController:odvc animated:YES];
        [odvc release];*/
        
    }
}

#define TAG_ALERTVIEW_DELETE_CONFIRM_OFFER 1000
#define TAG_ALERTVIEW_DELETE_CONFIRM_EVENT 1001

- (void) mainTableViewController:(MainTableViewController *)vtvc willDeleteItem:(id)item {
    if ([item isKindOfClass:[DItem class]]) {
        DItem * i = (DItem *)item;
        UIAlertView * alertView = [[[UIAlertView alloc] initWithTitle:APP_TITLE
                                                              message:[NSString stringWithFormat:@"Confirm deleting %@ from your planner?",i.title]
                                                             delegate:self
                                                    cancelButtonTitle:TXT_CANCEL
                                                    otherButtonTitles:TXT_OK, nil] autorelease];
        alertView.tag = TAG_ALERTVIEW_DELETE_CONFIRM_OFFER;
        [alertView show];
        
    }
    
}

- (void) mainTableViewController:(MainTableViewController *)vtvc shouldDeleteItems:(NSArray *)items {

    if (vtvc == self.itemsTableViewController) {
      NSLog(@"to be delete: %@",items);
    }
}

- (void) mainTableViewController:(MainTableViewController *)vtvc willDeleteItems:(NSArray *)items {
}

- (void) mainTableViewController:(MainTableViewController *)vtvc didDeleteItems:(NSArray *)items {
    if (vtvc == self.itemsTableViewController) {
        [self.itemsTableViewController setEditing:NO animated:NO];
    }
}

- (void)mainTableViewController:(ItemsTableViewController *)vtvc didSelectItem:(BOOL)didSelect {
NSLog(@"didselect: %d",didSelect);
}
- (void)dealloc {
    [itemsTableViewController release];
    [viewBase release];
    [itemList release];
    [super dealloc];
}


@end
