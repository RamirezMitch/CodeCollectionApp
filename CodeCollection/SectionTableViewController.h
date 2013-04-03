//
//  SectionTableViewController.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 15/3/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface SectionTableViewController : UIViewController <UIAlertViewDelegate,UIWebViewDelegate,UITableViewDelegate,  UITableViewDataSource,UISearchDisplayDelegate> {
NSString *xlsContent;
UIView *viewDarken;
UIActivityIndicatorView *activityIndicator;

NSArray *arrRowBundle;
    NSMutableArray *listBundlePrd;

Reachability* hostReach;
Reachability* internetReach;
Reachability* wifiReach;
    
    NSMutableDictionary			*listSection;			// The master content.
	NSMutableArray	*filteredListContent;	// The content filtered as a result of a search. Will be the list of Stores
	
	// The saved state of the search UI if a memory warning removed the view.
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
    NSArray			*listContent;
    
}
-(BOOL)internetAvailable;
-(void)showNoInternetAlert;
@property (nonatomic, retain) NSMutableDictionary *listSection;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UISearchDisplayController * searchDisplayController;
@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, retain) NSMutableArray *searchProduct;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

@end
