//
//  Product.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 18/3/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "Product.h"
#import "MyUtil.h"
#import "Constants.h"

@implementation Product
@synthesize product_code;
@synthesize product_title;
@synthesize desc;
@synthesize segmentCode;
@synthesize segmentDesc;
@synthesize imageUrlSmall;
@synthesize characterGroup;
#define OFFER_IMG_SMALL_WIDTH   19
#define OFFER_IMG_SMALL_HEIGHT  17

/*- (id) initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.product_code=[MyUtil safeString:[dict objectForKey:@"ID"]];
        NSString * imgUrl = [MyUtil safeString:[dict objectForKey:@"ImageUrl"]];
        self.imageUrlSmall = [MyUtil urlImage:imgUrl width:IMAGESIZE_SMALL_WIDTH_OFFER height:0];
        
    }
    return self;
}*/
- (id) init {
    self = [super init];
    if (self) {
       //
    }
    return self;
}
-(void)dealloc{
    [product_code release];
    [product_title release];
    [desc release];
    [segmentDesc release];
    [imageUrlSmall release];
    [characterGroup release];
    [super dealloc];
}
@end
