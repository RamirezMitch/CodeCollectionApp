//
//  ItemsTableViewController.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 17/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "MainTableViewController.h"

@interface ItemsTableViewController : MainTableViewController
- (void) populateItemsFromRawResponse:(NSArray *)rawArray;

@property(nonatomic,assign) BOOL isDirty;

@end
