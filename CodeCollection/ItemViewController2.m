//
//  ItemViewController2.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 18/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "ItemViewController2.h"
#import "DItem.h"
#import "Category.h"
#import "AppDelegate.h"

@implementation ItemViewController2
@synthesize itemList;
@synthesize viewBase,collectionViewController;
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
     self.productManager = [[[ProductManager alloc] initWithDelegate:self :NO] autorelease];
    [self.productManager loadXLS];
    
   /* self.requestManager = [[[AFRequestManager alloc] initWithDelegate:self withQueryType:QueryTypeOffersAllCategories]autorelease];
    
    [self.requestManager requestWithSuffixPath:@"" paramKeys:[NSArray arrayWithObjects:@"catIds", @"page",@"itemspercat", nil] values:[NSArray arrayWithObjects:@"ce48e178-88fb-4f7f-a0ab-b0d59d3502ea,de391a14-3536-4a71-8fc8-52cf6877a5e9,41e197ff-e362-40fa-b688-bbe18de6c1ae,82a023b7-f0a8-4836-8077-95fdddaea94b,d4f067b6-d22f-4749-91d2-7505a3aa3740,10bae0b9-7058-486c-8e6a-cdd88e5c8a56,08d3be5d-bc5e-4ca6-9241-e024109e2074,57359977-73c4-4c83-910a-dc165beb079d,179f2f7c-9547-4501-a3ba-e9d4cd8b6b16,fd461612-520a-455b-b512-ca8ea3338231",@"1",@"20",nil]];*/

    // Do any additional setup after loading the view from its nib.
}
- (void)dProductManager:(ProductManager *)om shouldShowAllItems:(NSMutableDictionary *)allItems {
    //Using ProductManager
    self.itemList=[NSArray arrayWithArray:allItems];
    self.collectionViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.collectionViewController.items = [NSArray arrayWithArray:self.itemList];
    // [self.viewBase addSubview:self.collectionViewController.view];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.mainNav pushViewController:self.collectionViewController animated:YES];
    [self.collectionViewController release];
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
                    // [self.itembyCategoryDict setObject:offerObjList forKey:c.catId];
                    //  [allOffers addObject:offerObjList];
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
        self.itemList=[NSArray arrayWithArray:offerarray];
        self.collectionViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
        self.collectionViewController.items = [NSArray arrayWithArray:self.itemList];
       // [self.viewBase addSubview:self.collectionViewController.view];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.mainNav pushViewController:self.collectionViewController animated:YES];
        [self.collectionViewController release];

        NSLog(@"*** ALL ITEMS: resultIn=%@ ***",self.itemList);
    }
}
- (void)dealloc {

  [itemList release];
  [super dealloc];
}
        

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
