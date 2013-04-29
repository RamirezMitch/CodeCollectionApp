//
//  CollapseViewController.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 24/4/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductManager.h"
@interface CollapseViewController : UIViewController <ProductManagerDelegate, UITableViewDataSource, UITableViewDelegate>{
    
}
@property(nonatomic,retain) ProductManager *productManager;
@property(nonatomic,retain) IBOutlet UITableView *myTable;
@property(nonatomic,retain)NSArray      *sectionTitleArray;
@property(nonatomic,retain)NSMutableDictionary *sectionContentDict;
@property(nonatomic,retain)NSMutableArray      *arrayForBool;

@end
