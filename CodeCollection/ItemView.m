//
//  ItemView.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 22/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "ItemView.h"
#import "Constants.h"

@implementation ItemView
@synthesize mainImage,title,arrowImage,clearButton,offerSheet,offerLabel,itemData;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
	[mainImage release];
	[title release];
	[arrowImage release];
	[clearButton release];
	[itemData release];
    [super dealloc];
}

- (id)init
{
	self = [super init];
	if (self) {
		self.frame = CGRectMake(0.0, 0.0, 150, 140);
		UIView* blackFlame = [[[UIView alloc] initWithFrame:CGRectMake(23, -1, 103, 92)] autorelease];
		blackFlame.backgroundColor = [UIColor clearColor];
		mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 0.0, 100, 90)];
		mainImage.backgroundColor = [UIColor whiteColor];
		clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
		clearButton.frame = CGRectMake(25, 0.0, 100, 90);
		clearButton.center = mainImage.center;
		clearButton.backgroundColor = [UIColor clearColor];
		
		title = [[UILabel alloc] initWithFrame:CGRectMake(25, 100, 100, 10)];
		self.title.backgroundColor = [UIColor clearColor];
        self.title.font = [UIFont systemFontOfSize:10.0];
		self.title.hidden = YES;
		arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(115, 105, 10, 10)];
		arrowImage.image = [UIImage imageNamed:@"arrow.png"];
        offerSheet = [[UIView alloc] initWithFrame:CGRectMake(25, 60, 100, 30)];
		self.offerSheet.backgroundColor = [UIColor colorWithRed:154.0/255.0 green:29.0/255.0 blue:16.0/255.0 alpha:0.75];
		offerLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 60, 100, 30)];
		self.offerLabel.textColor = [UIColor whiteColor];
		self.offerLabel.backgroundColor = [UIColor clearColor];
		self.offerLabel.numberOfLines = 2;
		self.offerLabel.font = [UIFont boldSystemFontOfSize:10.0];
        [self addSubview:blackFlame];
		[self addSubview:self.mainImage];
		[self addSubview:self.title];
		[self addSubview:self.arrowImage];
        [self addSubview:self.offerSheet];
		[self addSubview:self.offerLabel];
		[self addSubview:self.clearButton];
	}
	return self;
}

- (void)applyDealsData:(Product*)item
{
	self.deal = item;
    
	self.title.text =  item.product_title;
	self.title.hidden = NO;
	self.offerLabel.text = item.product_code;
	
	self.mainImage.image = [UIImage imageNamed:item.imageUrlSmall];
    /*NSString * theImageUrl = [NSString stringWithFormat:@"%@%@", BASE_URL, item.imageUrlSmall];
    NSURL *imageURL = [NSURL URLWithString:theImageUrl];
   [self.mainImage setImageWithURL:[NSURL URLWithString:theImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];*/
}

- (void)applyItemData:(NSDictionary*)data
{
	/*self.couponData = data;
	
	self.title.text = (NSString*)[data objectForKey:@"name"];
	self.title.hidden = NO;
	self.offerLabel.text = (NSString*)[data objectForKey:@"description"];
	
	if (self.priorCacheRequest != nil) [self.priorCacheRequest clearDelegatesAndCancel];
	if (self.modifyCheckRequest != nil) [self.modifyCheckRequest clearDelegatesAndCancel];
	
	self.mainImage.image = [UIImage imageNamed:@"defaultMerchantImg.png"];//nil;
	NSString* tmpString = [data objectForKey:@"image_ipad"];
	if ([tmpString length] == 0) return;
	
	self.priorCacheRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:tmpString]];
	self.priorCacheRequest.delegate = self;
	self.priorCacheRequest.timeOutSeconds = 20.0;
	self.priorCacheRequest.cachePolicy = ASIOnlyLoadIfNotCachedCachePolicy;
	self.priorCacheRequest.cacheStoragePolicy = ASICachePermanentlyCacheStoragePolicy;
	[self.priorCacheRequest startAsynchronous];
	[self.indicator startAnimating];*/
}

- (void)clearItemData
{
	self.title.text = @"";
	self.title.hidden = NO;
	self.mainImage.image = nil;
	self.offerLabel.text = @"";
	self.itemData = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
