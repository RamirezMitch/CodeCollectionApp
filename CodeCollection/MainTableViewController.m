//
//  MainTableViewController.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 17/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "MainTableViewController.h"

@interface MainTableViewController ()

@end

@implementation MainTableViewController
@synthesize items;
@synthesize requestManager;
@synthesize delegate;
//@synthesize imageDownloader;
@synthesize currentSortCriteria;
@synthesize isEditable;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.isEditable = NO; // default
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void) dealloc {
    [items release];
    [requestManager release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}
- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // to be overriden
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
     return self.isEditable;
}
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"willBeginEditingRowAtIndexPath ...");
    /*
     UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
     NSUInteger tagLabelWorthText = 11;
     NSUInteger tagLabelWorth = 5;
     UILabel * labelCellWorthText = (UILabel *)[cell viewWithTag:tagLabelWorthText];
     UILabel * labelCellWorth = (UILabel *)[cell viewWithTag:tagLabelWorth];
     [labelCellWorth setHidden:YES];
     [labelCellWorthText setHidden:YES];
     */
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
     NSUInteger tagLabelWorthText = 11;
     NSUInteger tagLabelWorth = 5;
     UILabel * labelCellWorthText = (UILabel *)[cell viewWithTag:tagLabelWorthText];
     UILabel * labelCellWorth = (UILabel *)[cell viewWithTag:tagLabelWorth];
     [labelCellWorth setHidden:NO];
     [labelCellWorthText setHidden:NO];
     */
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}
#pragma mark - Request

- (void) requestManager:(AFRequestManager *)sh didGetResults:(NSDictionary *)resultsIn withError:(NSString *)errorIn ofQuery:(QueryType)qType {
    // to be overridden
}
/*
 - (void) imageDownloader:(ImageDownloader *)imgDownloader didDownloadImage:(UIImage *)imgDownloaded withImageId:(NSString *)imgId {
 // to be overridden
 }
 */

#pragma mark -

- (void) showTable {
    
    NSLog(@".... showItemsTable ....  items=%@",self.items);
    
    // Update tableView
    [self.tableView reloadData];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES]; // Scroll to top of table
    //[self performSelector:@selector(downloadImages) withObject:nil afterDelay:0.3]; // Attempted to have faster transition
}

/*
 - (void) downloadImages {
 // to be overridden
 }
 */

- (void) retrieveItems:(NSString *)catID {
    
}

- (void) retrieveTheItemsSortedBy:(SortCriteriaItems)sort {
    // to be overridden
}

- (NSMutableArray *) itemsFromRawArray:(NSArray *)arrayIn {
    return nil;
}

- (void) cancelRequests {
    [self.requestManager cancel];
    //[imageDownloader cancel];
}

- (void) retrieveDetailsOfItemWithId:(NSString *)iId {
    // to be overridden
}


#pragma mark - PullToRefresh

- (void)refresh {
    // to be overidden
}

@end
