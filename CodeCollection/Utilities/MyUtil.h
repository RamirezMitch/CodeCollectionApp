//
//  MyUtil.h
//  Trudon
//
//  Created by Johannes Dwiartanto on 4/19/11.
//  Copyright 2011 CellCity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUtil : NSObject {
    
}

+ (NSString *)flattenHTML:(NSString *)html;
+ (NSString *)encodedURL:(NSString *)url;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alphaIn;
+ (UIColor *)colorWithRGBHex:(UInt32)hex alpha:(CGFloat)alphaIn;
+ (NSString *)safeString:(NSString *)stringValue;
+ (NSNumber *)safeNumber:(NSNumber *)numberValue;
+ (NSDate *)safeDate:(id)dateValue;


+ (NSString *) dateStringFromString:(NSString *)dateStringIn;
+ (BOOL) isExpiredWithDate:(NSDate *)dateIn;

+ (NSString *)lastupdateDateStringFromDate;

+ (NSDate *)eventGroupDateFromString:(id)dateStringIn;
+ (NSString *) eventDateStringFromDate:(NSDate *)dateIn; // for Events
+ (NSString *) eventTimeStringFromDate:(NSDate *)dateIn; // for Events
+ (NSString *) daysInfoWithStartDate:(NSDate *)dateStart endDate:(NSDate *)dateEnd; // for Events/offer
+ (int) daysBetween:(NSDate *)dt1 and:(NSDate *)dt2;
+ (NSString *) flagFilenameWithStartDate:(NSDate *)dateStart endDate:(NSDate *)dateEnd;

+ (BOOL) canGetNumberFromString:(NSString *)stringIn;

+ (NSString *) urlImage:(NSString *)url width:(int)w height:(int)h;

+ (void)showAlertViewWithOkButtonWithMessage:(NSString *)msg;
+ (void)showAlertViewWithOkButtonWithMessage:(NSString *)msg withTitle:(NSString *)t;
//+ (void)showAlertViewWithResetButtonWithMessage:(NSString *)msg;
+ (void)showAlertViewWithOkButtonWithErrorCode:(NSString *)errorCode;



// Sort the merchant by the distance
// Specific to this app, but may be an idea for other project
// But this is no longer used. The client does not allow us to sort.
//+ (NSMutableArray *) sortByDistanceOnMerchantList:(NSMutableArray *)mList;

@end
//E6972B