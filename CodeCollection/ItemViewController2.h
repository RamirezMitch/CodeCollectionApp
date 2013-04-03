//
//  ItemViewController2.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 18/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFRequestManager.h"
#import "ViewController.h"
@interface ItemViewController2 : UIViewController <AFRequestManagerDelegate>{
    UIView * viewBase;
   
}
@property (nonatomic,retain) ViewController * collectionViewController;
@property(nonatomic,retain) IBOutlet UIView * viewBase;
@property (nonatomic,retain) NSArray * itemList;
@property(nonatomic,retain) AFRequestManager *requestManager;
@end
