//
//  SectionTableViewController.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 15/3/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "SectionTableViewController.h"
#import "Product.h"
@interface SectionTableViewController ()

@end

@implementation SectionTableViewController
@synthesize filteredListContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive;
@synthesize tableView;
@synthesize searchProduct;
@synthesize searchDisplayController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.tableView.scrollEnabled = YES;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorColor=[UIColor grayColor];
	// restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        self.savedSearchTerm = nil;
    }
    
    
    [self.searchDisplayController setSearchResultsDelegate:self];
    [self.searchDisplayController setSearchResultsDataSource:self];
    [self.searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor blackColor]];
    [self.searchDisplayController.searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.searchDisplayController.searchResultsTableView setSeparatorColor:[UIColor grayColor]];

        [self initialSetup];
}
-(void) initialSetup{
    if ([self internetAvailable])
    {
        [self loadXLS];
    }
    else
    {
        [self showNoInternetAlert];
    }
}
-(BOOL)internetAvailable
{
    BOOL gotConnection;
	bool success = false;
	const char *host_name = [@"www.google.com" cStringUsingEncoding:NSASCIIStringEncoding];
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
	SCNetworkReachabilityFlags flags;
	success = SCNetworkReachabilityGetFlags(reachability, &flags);
	bool isAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
	if (isAvailable) {
		gotConnection = YES;
	}
	else {
		gotConnection = NO;
	}
    return gotConnection;
}
-(void)showActivityIndicator
{
    viewDarken = [[UIView alloc]init];
    viewDarken.frame = self.view.frame;
    viewDarken.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_darken.png"]];
    [self.view addSubview:viewDarken];
    
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	activityIndicator.center = self.view.center;
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator startAnimating];
	[viewDarken addSubview: activityIndicator];
    
}

-(void)hideActivityIndicator
{
    //[viewDarken removeFromSuperview];
    viewDarken.hidden = YES;
    [activityIndicator stopAnimating];
    //[viewDarken release];
    //[activityIndicator release];
}

-(void)loadXLS
{   [self showActivityIndicator];
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];

    NSString *f = [[NSBundle mainBundle] pathForResource:@"BundleProducts" ofType:@"xls"];
    NSURL *url=[NSURL fileURLWithPath:f];
    
    NSURLRequest *requestObj=[NSURLRequest requestWithURL:url];
    [web loadRequest:requestObj];
    
    web.delegate = self;
}

-(NSString*)getXLSField:(int)row:(int)col
{
    if (row + 1 == [arrRowBundle count])
    {
        return @"";
    }
    
    NSArray *arrCol = [[arrRowBundle objectAtIndex:row + 1] componentsSeparatedByString:@"<td"];
    
    NSString *result = [[[arrCol objectAtIndex:col + 1] componentsSeparatedByString:@">"] objectAtIndex:1];
    
    result = [[result componentsSeparatedByString:@"<"] objectAtIndex:0];
    result = [result stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
    result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return result;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    listBundlePrd = [[NSMutableArray alloc] init];
    
    xlsContent = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    arrRowBundle = [xlsContent componentsSeparatedByString:@"<tr"];
    
    //[NSThread detachNewThreadSelector:@selector(prepareBundleXLS) toTarget:self withObject:nil];
    
    int row = 1;
    NSString *prdCode = [self getXLSField:row :0];
    
    NSMutableArray *listPrdTmp;
    NSMutableArray *theProducts = [[NSMutableArray alloc] init];
     while (![prdCode isEqualToString:@""])
    {
        NSString *brand = [self getXLSField:row :1];
        NSString *desc = [self getXLSField:row :2];
        NSString *prdCat = [self getXLSField:row :4];
        NSString *thumbURL = [self getXLSField:row :5];
        listPrdTmp = [[NSMutableArray alloc] init];
        
        [listPrdTmp addObject:prdCode];
        [listPrdTmp addObject:brand];
        [listPrdTmp addObject:desc];
        [listPrdTmp addObject:thumbURL];
        [listPrdTmp addObject:prdCat];
        
        [listBundlePrd addObject:listPrdTmp];
        
        row = row + 1;
        prdCode = [self getXLSField:row :0];
        
        //Product *p = [Product alloc] initWithDictionary:arrRowBundle obje
        Product *p = [[Product alloc] init];
        p.product_code = prdCode;
        p.product_title = brand;
        p.desc = desc;
        p.segmentDesc = prdCat;
        p.imageUrlSmall = thumbURL;
         NSLog(@"title: %@", p.product_title);
        NSString *c = [p.product_title substringToIndex:1];
        p.characterGroup=[c uppercaseString];
        [theProducts addObject:p];
        [p release];
        
    }
    NSArray *sortedArray;
    NSSortDescriptor *lastDescriptor =[[NSSortDescriptor alloc] initWithKey:@"characterGroup"
                                                                  ascending:YES
                                                                   selector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSArray *descriptors = [NSArray arrayWithObjects:lastDescriptor, nil];
    sortedArray = [theProducts sortedArrayUsingDescriptors:descriptors];
    // [lastDescriptor release];
    NSLog(@"sortedProducts: %@", theProducts);
    
    self.listContent = [NSArray arrayWithArray:sortedArray];
    [theProducts release];
    [lastDescriptor release];
    
    self.listSection = [[NSMutableDictionary alloc] init];
    
    BOOL found;
    
    // Loop through the books and create our keys
    for (Product *prd in self.listContent)
    {
        NSString *c = [prd.product_title substringToIndex:1];
        
        found = NO;
        
        for (NSString *str in [self.listSection allKeys])
        {
            if ([str isEqualToString:c])
            {
                found = YES;
            }
        }
        
        if (!found)
        {
            [self.listSection setValue:[[NSMutableArray alloc] init] forKey:c];
        }
    }
    
    // Loop again and sort the books into their respective keys
    for (Product *prd in self.listContent)
    {
        [[self.listSection objectForKey:[prd.product_title substringToIndex:1]] addObject:prd];
    }
    
    // Sort each section array
    for (NSString *key in [self.listSection allKeys])
    {
        [[self.listSection objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"product_title" ascending:YES]]];
    }
    
    
    [self.tableView reloadData];
    self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];

    [self hideActivityIndicator];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView_
{
    if (tableView_ == self.searchDisplayController.searchResultsTableView)
	{
        return 1;
    }else{
        return [[self.listSection allKeys] count];
    }
}

- (NSString *)tableView:(UITableView *)tableView_ titleForHeaderInSection:(NSInteger)section
{
    if (tableView_ == self.searchDisplayController.searchResultsTableView)
	{
        return  @"";
    }else{
        
        return [[[self.listSection allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    }
}

- (NSInteger)tableView:(UITableView *)tableView_ numberOfRowsInSection:(NSInteger)section
{
    if (tableView_ == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count];
    }else{
        return [[self.listSection valueForKey:[[[self.listSection allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
    }
}

//To Display Alphabets section on the side of the table
/*- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView_ {
 
 return [[self.listSection allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
 
 }*/

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellID = @"cellID";
    
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:kCellID];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellID] autorelease];
        [cell setBackgroundColor:[UIColor blackColor]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,14,23)];
        [accessoryView setImage:[UIImage imageNamed:@"arrow.png"]];   //accessoryIcon.png
        [cell setAccessoryView:accessoryView];
    }
    
    /*
     If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
     */
    Product *prd=nil;
    
    if (tableView_ == self.searchDisplayController.searchResultsTableView)
    {
        
        prd = [self.filteredListContent objectAtIndex:indexPath.row];
        
    }else{
        prd = [[self.listSection valueForKey:[[[self.listSection allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
    }
    
    cell.textLabel.text = prd.product_title;
    cell.textLabel.textColor =[UIColor whiteColor];
    cell.textLabel.font=[UIFont boldSystemFontOfSize:15];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
    // }
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       
    Product *prd=nil;
    if (tableView_ == self.searchDisplayController.searchResultsTableView)
    {
        
        prd = [self.filteredListContent objectAtIndex:indexPath.row];
        
    }else{
        prd = [[self.listSection valueForKey:[[[self.listSection allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
    }
    
    NSLog(@"wiki-selected: %@",prd.product_title);
   /* FoodWikiDetailViewController_iPhone *foodwikiDVC = [[FoodWikiDetailViewController_iPhone alloc] init];
    foodwikiDVC.currentWiki = foodwikiListItem;
    foodwikiDVC.wikiItem = foodwikiListItem.title;
    [self.navigationController pushViewController:foodwikiDVC animated:YES];
    [foodwikiDVC release];*/
    
    
}

#pragma mark -

- (void) cancelSearch {
    //[self hideHud];
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods
#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    self.savedSearchTerm = searchString;
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	//[self loadSearchData];
    /*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	for (Product *prdObj in self.listContent)
	{
        NSComparisonResult result = [prdObj.product_title compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame)
        {
            [self.filteredListContent addObject:prdObj];
        }
	}
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableViewIn {
    
    NSLog(@"searchDisplayController  willShowSearchResultsTableView..");
    
    [tableViewIn setBackgroundColor:[UIColor blackColor]];
    //[tableViewIn setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
    NSLog(@"searchDisplayControllerWillBeginSearch..");
}

// 'Cancel' was tapped
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    
    NSLog(@"searchDisplayControllerDidEndSearch..");
    
    [self cancelSearch];
}

// 'Cancel' was tapped
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    
    NSLog(@"searchDisplayControllerWillEndSearch..");
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) dealloc
{
    [listContent release];
    [searchProduct release];
    [listSection release];
    [filteredListContent release];
    [tableView release];
    [searchDisplayController release];
	[super dealloc];
}

@end
