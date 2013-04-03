//
//  DItemManager.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 10/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFRequestManager.h"
#import "DItem.h"

@protocol DItemManagerDelegate;
@interface DItemManager : NSObject <AFRequestManagerDelegate> {
NSArray *allitemArray;
    id<DItemManagerDelegate> delegate;
    NSMutableDictionary *itembyCategoryDict;
    
}
@property(nonatomic,retain) NSMutableDictionary *itembyCategoryDict;
@property(nonatomic,assign) id<DItemManagerDelegate> delegate;
@property(nonatomic,retain) AFRequestManager * requestManager;
@property(nonatomic,retain) NSArray *allitemArray;
@property (nonatomic,retain) NSMutableArray * allCategories;
@property (nonatomic,retain) NSArray *catIds;
-(id)initWithDelegate:(id)del;
- (void) cancelRequest;
- (void)requestAllItems;
-(void) requestCategories;
@end

@protocol DItemManagerDelegate <NSObject>
@optional
- (void)dItemManager:(DItemManager *)om willRequestItem:(BOOL)will;
- (void)dItemManager:(DItemManager *)om shouldShowAllItems:(NSArray *)allItems;
- (void)dItemManager:(DItemManager *)om shouldShowOffersWithCategory:(NSString *)catId;
- (void)dItemManager:(DItemManager *)om shouldShowOffersInAllCategories:(NSArray *)allOffers;
- (void)dItemManager:(DItemManager *)om shouldShowAllCategories:(NSArray *)allCategories;
@end