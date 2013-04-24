//
//  CollapseViewController.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 24/4/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductManager.h"
@interface CollapseViewController : UITableViewController <ProductManagerDelegate>{
    
}
@property(nonatomic,retain) ProductManager *productManager;

@end
