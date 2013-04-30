//
//  GridViewController.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 29/4/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "GridViewController.h"
#import "GridCell.h"

@interface GridViewController ()

@end

@implementation GridViewController
@synthesize table;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
	return 80;
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
	return 80;
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
	return 4;
}


- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
	return 33;
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
	GridCell *cell = (GridCell *)[grid dequeueReusableCell];
	
	if (cell == nil) {
		cell = [[GridCell alloc] init];
	}
	
	cell.label.text = [NSString stringWithFormat:@"(%d,%d)", rowIndex, columnIndex];
	return cell;
}

- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex
{
	NSLog(@"%d, %d clicked", rowIndex, colIndex);
}


@end
