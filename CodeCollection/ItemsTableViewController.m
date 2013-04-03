//
//  ItemsTableViewController.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 17/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "ItemsTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MyUtil.h"
#import "DItem.h"
#import "ItemListCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ItemsTableViewController ()

@end

@implementation ItemsTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.items = [[[NSMutableArray alloc] init] autorelease];
        self.isDirty = NO;
        [self setEditing:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat padding = 0;
    UIView * viewLine = [[UIView alloc] initWithFrame:CGRectMake(0+padding,0, self.tableView.frame.size.width-2*padding,1)];
    [viewLine setBackgroundColor:[UIColor grayColor]];
    self.tableView.tableHeaderView = viewLine;
    [viewLine release];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor blackColor]];
    self.tableView.layer.cornerRadius = 0.0;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.tableFooterView = nil;
    self.tableView.sectionHeaderHeight = 1;
    self.tableView.sectionFooterHeight = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - RequestManager

- (void) retrieveItems:(NSString *)catID {
    [self.delegate mainTableViewController:self shouldRetrieveListOfItems:YES];
    
    // Request events
    self.requestManager = [[[AFRequestManager alloc] initWithDelegate:self withQueryType:QueryTypeOffersAllCategories] autorelease];
    [self.requestManager requestWithSuffixPath:@"" paramKeys:[NSArray arrayWithObjects:@"catIds", @"page",@"itemspercat", nil] values:[NSArray arrayWithObjects:@"ce48e178-88fb-4f7f-a0ab-b0d59d3502ea,de391a14-3536-4a71-8fc8-52cf6877a5e9,41e197ff-e362-40fa-b688-bbe18de6c1ae,82a023b7-f0a8-4836-8077-95fdddaea94b,d4f067b6-d22f-4749-91d2-7505a3aa3740,10bae0b9-7058-486c-8e6a-cdd88e5c8a56,08d3be5d-bc5e-4ca6-9241-e024109e2074,57359977-73c4-4c83-910a-dc165beb079d,179f2f7c-9547-4501-a3ba-e9d4cd8b6b16,fd461612-520a-455b-b512-ca8ea3338231",@"1",@"20",nil]];

}

- (void)requestManager:(AFRequestManager *)sh didGetResults:(NSDictionary *)resultsIn withError:(NSString *)errorIn ofQuery:(QueryType)qType {
    if (errorIn == nil) { // No error
        // Assign events
        NSArray * offerDataArray = (NSArray *)[resultsIn objectForKey:@"Data"];
        
        [self populateItemsFromRawResponse:offerDataArray];
        
        // Tell the delegate
        [self.delegate mainTableViewController:self didRetrieveListOfItems:self.items withError:nil];
    } else { // Has error
        [self.delegate mainTableViewController:self didRetrieveListOfItems:nil withError:errorIn];
    }
}

- (void) populateItemsFromRawResponse:(NSArray *)rawArray {
    self.items = [[[NSMutableArray alloc] init] autorelease];
    for (int i=0; i<[rawArray count]; i++) {
        NSDictionary *dic = (NSDictionary *)[rawArray objectAtIndex:i];
        DItem *itemObj = [[DItem alloc] initWithDictionary:dic];
        [self.items addObject:itemObj];
        [itemObj release];
        
        NSLog(@"Offer populated i=%d",i);
        
    }
}

#pragma mark - Image download

- (void) downloadImages {
    /*
     for (Offer * f in self.items) {
     if (f.imageUrlSmall && ![f.imageUrlSmall isEqualToString:@""]) {
     NSString * theImageUrl = [NSString stringWithFormat:@"%@%@", BASE_URL_GPT, f.imageUrlSmall];
     [self.imageDownloader downloadImageWithURL:theImageUrl forImageId:f.offerId];
     }
     }
     */
}

/*
 - (void) imageDownloader:(ImageDownloader *)imgDownloader didDownloadImage:(UIImage *)imgDownloaded withImageId:(NSString *)imgId {
 for (Offer * f in self.items)
 if ([f.offerId isEqualToString:imgId]) {
 f.offerImage = imgDownloaded;
 f.isImageDownloaded = YES;
 }
 [self.tableView reloadData];
 }
 */

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (!self.items) {
        return 0;
    }
    NSLog(@"returncount: %i",[self.items count]);
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ItemListCell" owner:self options:nil] lastObject];
    }
    
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void) configureCell:(UITableViewCell *)cellIn atIndexPath:(NSIndexPath *)indexPath {
    ItemListCell * cell = (ItemListCell *)cellIn;
    
    DItem * o = [self.items objectAtIndex:indexPath.row];
    
    // Tags - sync with those in PointsDetailsTableCellView.xib
    NSUInteger tagLabelTitle = 1;
    NSUInteger tagImage = 4;
    NSUInteger tagImageLoadingIndicator = 5;
    NSUInteger tagViewSelect = 6;
    NSUInteger tagViewBaseContent = 7;
    NSUInteger tagButtonSelect = 8;

    
    UILabel * labelTitle = (UILabel *)[cell viewWithTag:tagLabelTitle];
    UIImageView * imageView = (UIImageView *)[cell viewWithTag:tagImage];
    UIActivityIndicatorView * indicatorImageLoading = (UIActivityIndicatorView *) [cell viewWithTag:tagImageLoadingIndicator];
    UIView * viewBaseContent = (UIView *)[cell viewWithTag:tagViewBaseContent];
    UIView * viewSelect = (UIView *)[cell viewWithTag:tagViewSelect];
    UIButton * buttonSelect = (UIButton *)[cell viewWithTag:tagButtonSelect];
    
    //172, 223
    if (self.tableView.editing) {
        [viewSelect setHidden:NO];
        CGRect f = viewBaseContent.frame;
        f.size.width = 172;
        viewBaseContent.frame = f;
        
    }
    else {
        [viewSelect setHidden:YES];
        CGRect f = viewBaseContent.frame;
        f.size.width = 223;
        viewBaseContent.frame = f;
    }
    
    NSString * theImageUrl = [NSString stringWithFormat:@"%@%@", BASE_URL, o.imageUrlSmall];
    [imageView setImageWithURL:[NSURL URLWithString:theImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
   /* [imageView setImageWithURL:[NSURL URLWithString:theImageUrl]
              placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                       success:^(UIImage *image, BOOL cached) {
                           [indicatorImageLoading stopAnimating];
                       }
                       failure:^(NSError *error) {
                           [indicatorImageLoading stopAnimating];
                       }];*/
    
    [labelTitle setText:o.title];
  
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 69;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

/*
 - (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
 CGFloat padding = 0;
 UIView * viewLine = [[UIView alloc] initWithFrame:CGRectMake(0+padding,0, self.tableView.frame.size.width-2*padding,1)];
 [viewLine setBackgroundColor:[UIColor grayColor]];
 return [viewLine autorelease];
 }
 */

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}


#pragma mark - Table view data source

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (editing) { // Edit
        [self.tableView reloadData];
    }
    else { // Done
        [self.tableView reloadData];
    }
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DItem * o = (DItem *)[self.items objectAtIndex:indexPath.row];
        [self.delegate mainTableViewController:self shouldDeleteItem:o];
        
        /*
         [self.items removeObject:o];
         // Delete the row from the data source
         [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
         */
    }
}

/*- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
 // Detemine if it's in editing mode
 if (self.editing) {
 return UITableViewCellEditingStyleDelete;
 }
 return UITableViewCellEditingStyleNone;
 }*/

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
    NSLog(@"didSelectRowAtIndexPath section=%d row=%d",indexPath.section, indexPath.row);
    
    if (!self.editing) {
        DItem * o = [self.items objectAtIndex:indexPath.row];
        [self.delegate mainTableViewController:self shouldShowDetailsOfItem:o atSectionIndex:0 atRowIndex:indexPath.row];
    }
    else {
        
        NSLog(@"toggle deletion");
        [self.tableView reloadData];
    }
}

/* for (DItem * o in self.items) {
        if (o.taggedForDeletion) {
            return YES;
        }
    }
    return NO;
*/



@end
