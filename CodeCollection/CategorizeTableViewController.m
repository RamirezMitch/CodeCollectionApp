//
//  CategorizeTableViewController.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 18/3/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "CategorizeTableViewController.h"
#import "Product.h"
#import "MyUtil.h"
@interface CategorizeTableViewController ()

@end

@implementation CategorizeTableViewController
@synthesize tableView;
@synthesize listSection;
- (void)dealloc
{
    [tableView release];
    [listSection release];
    [super dealloc];
}

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
    self.tableView.separatorColor = [UIColor whiteColor];
    [self initialSetup];
}
- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
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
        NSInteger prdCatCode = [self getXLSField:row :2];
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
        p.segmentCode = [MyUtil safeNumber:prdCatCode];
        p.imageUrlSmall = thumbURL;
        NSLog(@"title: %@", p.product_title);
        NSString *c = [p.segmentDesc substringToIndex:1];
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
    
  /*  NSSortDescriptor *sortRating = [[NSSortDescriptor alloc] initWithKey:@"segmentDesc" ascending:NO];
    NSSortDescriptor *sortVotes = [[NSSortDescriptor alloc] initWithKey:@"segmentCode" ascending:NO];
    
  NSArray *categorizeArray = [sortedArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortRating, sortVotes, nil]];
    [sortRating release], sortRating = nil;
    [sortVotes release], sortVotes = nil;*/

    [theProducts release];
     // catalogue = [[NSArray alloc] initWithArray:sortedArray copyItems:YES];
    for (Product *prd in sortedArray)
    {
         NSLog(@"sorted: %@", prd.segmentDesc);
    }
    catalogue = [[NSArray alloc] initWithArray:sortedArray];
    self.listSection = [[NSMutableDictionary alloc] init];
    
    BOOL found;
    
    // Loop through the books and create our keys
    for (Product *prd in catalogue)
    {
        NSString *c = prd.segmentDesc;
        
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
    for (Product *prd in catalogue)
    {
        [[self.listSection objectForKey:prd.segmentDesc] addObject:prd];
    }
    
    // Sort each section array
    for (NSString *key in [self.listSection allKeys])
    {
        [[self.listSection objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"product_title" ascending:YES]]];
    }
    NSLog(@"listsection: %@", self.listSection);

    [self.tableView reloadData];
      
    [self hideActivityIndicator];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.listSection allKeys] count];

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   // NSDictionary *dict = [[catalogue objectAtIndex:section]objectForKey:@"segmentCode"];
   // NSString *title = [dict objectForKey:@"segmentDesc"];
    NSString *title =[[[self.listSection allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];// [[self.listSection allKeys] objectAtIndex:section];
    UIView *sectionBackground = [[UIView alloc] initWithFrame:CGRectZero];
    sectionBackground.backgroundColor = [UIColor redColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 300.0f, 30.0f)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.text = title;
    [sectionBackground addSubview:headerLabel];
    [headerLabel release];
    
    return [sectionBackground autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [[self.listSection valueForKey:[[[self.listSection allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    /* Configure the cell...
    NSArray *array = [[catalogue objectAtIndex:indexPath.section]objectForKey:@"subcategory"];
    NSDictionary *subcategory = [array objectAtIndex:indexPath.row];
    cell.textLabel.text = [subcategory objectForKey:@"name"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    */
    Product *prd=nil;
    prd = [[self.listSection valueForKey:[[[self.listSection allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    cell.textLabel.text = prd.product_title;
    cell.textLabel.textColor =[UIColor blackColor];
    cell.textLabel.font=[UIFont boldSystemFontOfSize:15];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [theTableView deselectRowAtIndexPath:indexPath animated:YES];
    
  /*  NSArray *array = [[catalogue objectAtIndex:indexPath.section]objectForKey:@"subcategory"];
    NSDictionary *subcategory = [array objectAtIndex:indexPath.row];
    NSString *title = [subcategory objectForKey:@"name"];
    NSInteger categoryId = [[subcategory objectForKey:@"id"]intValue];*/
    
  /*  ProductListViewController *detailViewController = [[ProductListViewController alloc] initWithNibName:@"ProductListViewController" bundle:nil];
    detailViewController.categoryId = categoryId;
    detailViewController.type = self.type;
    detailViewController.title = title;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];*/
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
    } else {
        cell.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
