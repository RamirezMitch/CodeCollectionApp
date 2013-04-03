//
//  DItem.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 10/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "DItem.h"
#import "MyUtil.h"
#import "Constants.h"

@implementation DItem
@synthesize offerId;
@synthesize title;
@synthesize desc;
@synthesize imageUrlLarge;
@synthesize imageUrlSmall;
@synthesize dateTimeStart;
@synthesize dateTimeEnd;

@synthesize isEndingSoon;
@synthesize isHotOffer;
@synthesize isNewListing;
@synthesize storeLocation;
@synthesize offerImage;


#define OFFER_IMG_SMALL_WIDTH   19
#define OFFER_IMG_SMALL_HEIGHT  17
#define OFFER_IMG_LARGE_WIDTH   320
#define OFFER_IMG_LARGE_HEIGHT  200


- (id) initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.offerId = [MyUtil safeString:[dict objectForKey:@"ID"]];
        self.title = [MyUtil safeString:[dict objectForKey:@"Title"]];
        self.desc = [MyUtil safeString:[dict objectForKey:@"Description"]];
        
        NSString * imgUrl = [MyUtil safeString:[dict objectForKey:@"ImageUrl"]];
        self.imageUrlLarge = [MyUtil urlImage:imgUrl width:IMAGESIZE_LARGE_WIDTH_OFFER height:0];
        self.imageUrlSmall = [MyUtil urlImage:imgUrl width:IMAGESIZE_SMALL_WIDTH_OFFER height:0];
        
        self.dateTimeStart = [MyUtil safeDate:[dict objectForKey:@"DateStart"]];
        self.dateTimeEnd = [MyUtil safeDate:[dict objectForKey:@"DateEnd"]];

        
        self.isEndingSoon = [((NSNumber *)[MyUtil safeNumber:[dict objectForKey:@"IsEndingSoon"]]) boolValue];
        self.isHotOffer = [((NSNumber *)[MyUtil safeNumber:[dict objectForKey:@"IsHotOffer"]]) boolValue];
        self.isNewListing = [((NSNumber *)[MyUtil safeNumber:[dict objectForKey:@"IsNewListing"]]) boolValue];
        

        self.isImageDownloaded = NO;

    }
    return self;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"Offer:%@",title];
}

- (void) dealloc {
    [offerId release];
    [title release];
    [desc release];
    [storeLocation release];
    [dateTimeStart release];
    [dateTimeEnd release];

    [imageUrlSmall release];
    [imageUrlLarge release];
    [offerImage release];
  
    [super dealloc];
}
@end
