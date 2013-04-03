//
//  MainTableViewController.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 17/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFRequestManager.h"

typedef enum {
    SortCriteriaItemsByDate = 1,
    SortCriteriaItemsByLevel = 2,
    SortCriteriaItemsNone = 0
} SortCriteriaItems;

@protocol MainTableViewControllerDelegate;
@interface MainTableViewController : UITableViewController <AFRequestManagerDelegate>
@property (nonatomic,retain) NSMutableArray * items;
@property (nonatomic,retain) AFRequestManager * requestManager;
@property (nonatomic,assign) id<MainTableViewControllerDelegate> delegate;
@property (nonatomic,assign) SortCriteriaItems currentSortCriteria;
@property (nonatomic,assign) BOOL isEditable;

- (void) retrieveItems:(NSString *)catID;
- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (NSMutableArray *) itemsFromRawArray:(NSArray *)arrayIn;
- (void) cancelRequests;
- (void) retrieveDetailsOfItemWithId:(NSString *)iId;
- (void) showTable;
@end


@protocol MainTableViewControllerDelegate <NSObject>

- (void)mainTableViewController:(MainTableViewController *)itvc
         didRetrieveListOfItems:(NSArray *)items
                      withError:(NSString *)errorIn;
@optional
- (void)mainTableViewController:(MainTableViewController *)itvc
shouldRetrieveDetailsOfItemWithId:(NSString *)iId;
- (void)mainTableViewController:(MainTableViewController *)itvc
      shouldRetrieveListOfItems:(BOOL)toRetrieve;
- (void)mainTableViewController:(MainTableViewController *)itvc shouldShowDetailsOfItem:(id)i atSectionIndex:(int)sIdx atRowIndex:(int)rIdx;
- (void)mainTableViewController:(MainTableViewController *)vtvc
                 willDeleteItem:(id)i;
- (void)mainTableViewController:(MainTableViewController *)vtvc
               shouldDeleteItem:(id)i;
- (void)mainTableViewController:(MainTableViewController *)vtvc
                  didDeleteItem:(id)i;
- (void)mainTableViewController:(MainTableViewController *)vtvc shouldDeleteItems:(NSArray *)items;
- (void)mainTableViewController:(MainTableViewController *)vtvc willDeleteItems:(NSArray *)items;
- (void)mainTableViewController:(MainTableViewController *)vtvc didDeleteItems:(NSArray *)items;
- (void)mainTableViewController:(MainTableViewController *)vtvc didSelectItem:(BOOL)didSelect;

@end;