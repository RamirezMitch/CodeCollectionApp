//
//  DItemManager.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 10/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "DItemManager.h"
#import "DItem.h"
#import "Category.h"
@implementation DItemManager
@synthesize requestManager, delegate, allitemArray;
@synthesize itembyCategoryDict,allCategories,catIds;

-(id)initWithDelegate:(id)del {
    self = [super init];
    if (self) {
        self.itembyCategoryDict = [[[NSMutableDictionary alloc] init] autorelease];
        self.delegate = del;
    }
    return self;
}

- (void)requestAllItems {
   // [self.delegate dItemManager:self willRequestItem:YES];
    self.requestManager = [[[AFRequestManager alloc] initWithDelegate:self withQueryType:QueryTypeOffersAllCategories]autorelease];
    
    [self.requestManager requestWithSuffixPath:@"" paramKeys:[NSArray arrayWithObjects:@"catIds", @"page",@"itemspercat", nil] values:[NSArray arrayWithObjects:@"ce48e178-88fb-4f7f-a0ab-b0d59d3502ea,de391a14-3536-4a71-8fc8-52cf6877a5e9,41e197ff-e362-40fa-b688-bbe18de6c1ae,82a023b7-f0a8-4836-8077-95fdddaea94b,d4f067b6-d22f-4749-91d2-7505a3aa3740,10bae0b9-7058-486c-8e6a-cdd88e5c8a56,08d3be5d-bc5e-4ca6-9241-e024109e2074,57359977-73c4-4c83-910a-dc165beb079d,179f2f7c-9547-4501-a3ba-e9d4cd8b6b16,fd461612-520a-455b-b512-ca8ea3338231",@"1",@"20",nil]];
}
-(void) requestCategories {
    self.requestManager = [[[AFRequestManager alloc] initWithDelegate:self withQueryType:QueryTypeCategories]autorelease];
    [self.requestManager requestWithSuffixPath:@"core/0" paramKeys:[NSArray arrayWithObjects:@"page", nil] values:[NSArray arrayWithObjects:@"1", nil]];
}
- (void) afrequestManager:(AFRequestManager *)sh didGetResults:(NSDictionary *)resultsIn withError:(NSString *)errorIn ofQuery:(QueryType)qType{
    if(qType==QueryTypeOffersAllCategories){
        if (resultsIn != nil && errorIn == nil) {
            NSLog(@"The response:%@",resultsIn);
            
            if (resultsIn != (id)[NSNull null] && [resultsIn count] > 0) {
                
                NSMutableArray *resultArray = [[NSMutableArray alloc] init]; // for passing
                
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
                                    [offerObj release];
                                }
                                [self.itembyCategoryDict setObject:offerObjList forKey:c.catId];
                                [offerObjList release];
                            }
                            [c release];
                        }
                        [resultArray addObject:mainDict];
                    } //end forloop
                    
                    [self.delegate dItemManager:self shouldShowAllItems:resultArray];
                    
                } //end if(array)
                else {
                    [self.delegate dItemManager:self shouldShowAllItems:nil];
                }
                NSLog(@"data: %@",array);
                [resultArray release];
            } // end resultIn count
            else {
                [self.delegate dItemManager:self shouldShowAllItems:nil];
            }
            
        } //end result in nil
        else {
           [self.delegate dItemManager:self shouldShowAllItems:nil];
        }
    }else if(qType==QueryTypeCategories){
        if (resultsIn != nil && errorIn == nil) {
            NSLog(@"The response:%@",resultsIn);
            if ([resultsIn count] > 0) {
                NSArray *array = [resultsIn objectForKey:@"Data"];
                if (array != (id)[NSNull null]) {
                    NSMutableArray *allcorecat  = [[NSMutableArray alloc]init];
                    self.allCategories = [[[NSMutableArray alloc] init] autorelease];
                    for (int i=0; i<[array count]; i++) {
                        NSDictionary * dic = [array objectAtIndex:i];
                        Category * catObject = [[Category alloc] initWithDictionary:dic];
                        [self.allCategories addObject:catObject];
                        [allcorecat addObject:catObject.catId];
                        [catObject release];
                    }
                    self.catIds = [[[NSArray alloc] initWithArray:allcorecat] autorelease];
                    [allcorecat release];
                     [self.delegate dItemManager:self shouldShowAllCategories:self.catIds];
                }
            }
        }
    }
}
- (void) cancelRequest {
    [self.requestManager cancel];
}
- (void) dealloc {

    [allitemArray release];
    [requestManager release];
    [itembyCategoryDict release];
    [allCategories release];
    [catIds release];
    [super dealloc];
}
@end
