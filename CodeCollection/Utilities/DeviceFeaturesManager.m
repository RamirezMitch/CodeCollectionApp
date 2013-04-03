//
//  DeviceFeaturesManager.m
//  DBSShopper
//
//  Created by Low Chee Yong on 8/23/10.
//             Johannes Dwiartanto on 4/8/11
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DeviceFeaturesManager.h"
#import <MessageUI/MessageUI.h>


@implementation DeviceFeaturesManager
@synthesize canSendSMS;
@synthesize canCall;
@synthesize hasCamera;
@synthesize hasMagnetometerMeter;
@synthesize supportsInAppSMS;
@synthesize isRetinaDisplay;
@synthesize isIOS5;
@synthesize isIOS6;

static DeviceFeaturesManager * deviceFeaturesManager;

+ (DeviceFeaturesManager *) defaultManager
{
	if(deviceFeaturesManager==nil)
	{
		deviceFeaturesManager = [[DeviceFeaturesManager alloc] init];
	}
	return deviceFeaturesManager;
}

- (id) init
{
    self = [super init];
	if(self)
	{
		NSURL *urlObject = [NSURL URLWithString:@"sms://"];
        
        if ([[UIApplication sharedApplication] canOpenURL:urlObject] && [NSClassFromString(@"MFMessageComposeViewController") canSendText])
            self.canSendSMS = TRUE;
        else
            self.canSendSMS = FALSE;

		Class smsClass = (NSClassFromString(@"MFMessageComposeViewController"));
        if(smsClass)
			self.supportsInAppSMS = YES;
		else 
			self.supportsInAppSMS = NO;
		
		urlObject = [NSURL URLWithString:@"tel://"];
		self.canCall = [[UIApplication sharedApplication] canOpenURL:urlObject];
		
		urlObject = nil;
		
		self.hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
		
		//self.hasMagnetometerMeter = [MyApplication sharedMyApplication].deviceHasMagnetometer;
		
#if TARGET_IPHONE_SIMULATOR
		hasCamera = YES;
		hasMagnetometerMeter = YES;
#endif
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0)) {
            self.isRetinaDisplay = YES;
        } else {
            self.isRetinaDisplay = NO;
        }
        
        self.isIOS6 = NO;
        self.isIOS5 = NO;
        NSArray *versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
        if ( 6 == [[versionCompatibility objectAtIndex:0] intValue] ) { /// iOS6 is installed
            self.isIOS6 = YES;
        } else  { /// iOS5 is installed
            self.isIOS5 = YES;
        }         
	}
	return self;
}

-(void)dealloc
{
	if(deviceFeaturesManager!=nil)
	{
		[deviceFeaturesManager release];
		deviceFeaturesManager = nil;
	}
	[super dealloc];
}


@end
