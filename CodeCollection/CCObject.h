//
//  CCObject.h
//  DBSReflect
//
//  Created by danielzhao on 18/6/12.
//  Copyright (c) 2012 alex@thecellcity.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol CCObject <NSObject>

@property (nonatomic, readonly) NSURL *lowImageURL;
@property (nonatomic, readonly) NSURL *mediumImageURL;
@property (nonatomic, readonly) NSURL *highImageURL;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *publishStartDatestr;
@property (nonatomic, readonly) NSString *publishEndDatestr;

@optional

@property (nonatomic, readonly) NSString *objectId;
@property (nonatomic, readonly) NSArray *outletArray;
@property (nonatomic, readonly) NSString *tncType;
@property (nonatomic, readonly) NSString *tnc;
@property (nonatomic, readonly) NSString *shortDes;
@property (nonatomic, readonly) NSString *longDes;

@end
