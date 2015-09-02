//
//  ItemViewController1.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 17/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFRequestManager.h"
#import "ProductManager.h"
#import "ItemsTableViewController.h"
@interface ItemViewController1 : UIViewController <MainTableViewControllerDelegate,AFRequestManagerDelegate>{
UIView * viewBase;
NSArray * itemList;
}
@property (nonatomic,retain) ItemsTableViewController * itemsTableViewController;
@property (nonatomic,retain) NSArray * itemList;
@property(nonatomic,retain) IBOutlet UIView * viewBase;
@property(nonatomic,retain) AFRequestManager *requestManager;
@property(nonatomic,retain) ProductManager *productManager;
@end
