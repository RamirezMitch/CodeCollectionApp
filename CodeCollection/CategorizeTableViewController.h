//
//  CategorizeTableViewController.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 18/3/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface CategorizeTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIWebViewDelegate>{
    NSArray *catalogue;
    NSString *xlsContent;
    UIView *viewDarken;
    UIActivityIndicatorView *activityIndicator;
    
    NSArray *arrRowBundle;
    NSMutableArray *listBundlePrd;
    
    NSMutableDictionary			*listSection;			// The master content.
   
    Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;
    
}
@property (nonatomic, retain) NSMutableDictionary *listSection;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
-(BOOL)internetAvailable;
-(void)showNoInternetAlert;

@end
