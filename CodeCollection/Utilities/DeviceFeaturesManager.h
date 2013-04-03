//
//  DeviceFeaturesManager.h
//  DBSShopper
//
//  Created by Low Chee Yong on 8/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DeviceFeaturesManager : NSObject
{
	BOOL canSendSMS;
	BOOL canCall;
	BOOL hasCamera;
	BOOL hasMagnetometerMeter;
	BOOL supportsInAppSMS;
    BOOL isRetinaDisplay;
    BOOL isIOS5;
    BOOL isIOS6;
}

@property (nonatomic) BOOL canSendSMS;
@property (nonatomic) BOOL canCall;
@property (nonatomic) BOOL hasCamera;
@property (nonatomic) BOOL hasMagnetometerMeter;
@property (nonatomic) BOOL supportsInAppSMS;
@property (nonatomic) BOOL isRetinaDisplay;
@property (nonatomic) BOOL isIOS5;
@property (nonatomic) BOOL isIOS6;

+(DeviceFeaturesManager *) defaultManager;
-init;

@end
