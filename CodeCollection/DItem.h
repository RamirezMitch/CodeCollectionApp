//
//  DItem.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 10/1/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DItem : NSObject
@property (nonatomic, retain) NSString * offerId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * storeLocation;
@property (nonatomic, retain) NSDate * dateTimeStart;
@property (nonatomic, retain) NSDate * dateTimeEnd;

@property (nonatomic, retain) NSString * imageUrlSmall;
@property (nonatomic, retain) NSString * imageUrlLarge;
@property (nonatomic, assign) BOOL isEndingSoon;
@property (nonatomic, assign) BOOL isHotOffer;
@property (nonatomic, assign) BOOL isNewListing;
@property (nonatomic, assign) BOOL isImageDownloaded;
@property (nonatomic, retain)  UIImage * offerImage;

- (id) initWithDictionary:(NSDictionary *)dict;
@end
