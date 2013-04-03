//
//  MyUtil.m
//  Trudon
//
//  Created by Johannes Dwiartanto on 4/19/11.
//  Copyright 2011 CellCity. All rights reserved.
//

#import "MyUtil.h"
#import "DeviceFeaturesManager.h"

#define APP_TITLE                       @"Code Collection"

@implementation MyUtil

+ (NSString *)flattenHTML:(NSString *)html {
	
    NSScanner *theScanner;
    NSString *text = nil;
	
    theScanner = [NSScanner scannerWithString:html];
	
    while ([theScanner isAtEnd] == NO) {
		
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ; 
		
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
		
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
				[ NSString stringWithFormat:@"%@>", text]
											   withString:@" "];
		
    } // while //
    if (html != nil) {
        NSString * result = [[NSString alloc] initWithString:html];
        return [result autorelease];
    }
    return nil;
}

+ (NSString *)encodedURL:(NSString *)url
{
	NSString * result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef) url, NULL, CFSTR("?=+"), kCFStringEncodingUTF8);
	return [result autorelease];                                                                                                                        
}


+ (void)showAlertViewWithOkButtonWithMessage:(NSString *)msg {

    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:APP_TITLE
                                                         message:msg
                                                        delegate:self
                                               cancelButtonTitle: @"OK"
                                               otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

+ (void)showAlertViewWithOkButtonWithMessage:(NSString *)msg withTitle:(NSString *)t{
    

    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:t
                                                         message:msg
                                                        delegate:self
                                               cancelButtonTitle: @"OK"
                                               otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

+ (void)showAlertViewWithOkButtonWithErrorCode:(NSString *)errorCode {
    

    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:APP_TITLE
                                                         message:errorCode
                                                        delegate:self
                                               cancelButtonTitle: @"OK"
                                               otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}


// Returns a UIColor by scanning the string for a hex number and passing that to +[UIColor colorWithRGBHex:]
// Skips any leading whitespace and ignores any trailing characters
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alphaIn
{
	NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
	unsigned hexNum;
	if (![scanner scanHexInt:&hexNum]) return nil;
	return [self colorWithRGBHex:hexNum alpha:alphaIn];
}

// Returns a UIColor by a hex as the input
+ (UIColor *)colorWithRGBHex:(UInt32)hex alpha:(CGFloat)alphaIn
{
	int r = (hex >> 16) & 0xFF;
	int g = (hex >> 8) & 0xFF;
	int b = (hex) & 0xFF;
	
	return [UIColor colorWithRed:r / 255.0f
						   green:g / 255.0f
							blue:b / 255.0f
						   alpha:alphaIn];
}

+ (NSString *)safeString:(id)stringValue
{
	if (stringValue==nil) {
		return @"";
    }
    else if (stringValue == (id)[NSNull null]) {
        return @"";
    }
    else if ((NSNull *)stringValue == [NSNull null]) {
        return @"";
    }
    else if ([stringValue isEqual:[NSNull null]]) {
		return @"";
    }
    else if ([stringValue respondsToSelector:@selector(stringByTrimmingCharactersInSet:)]) {
        if ([[stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            return @"";
        }
    }
    else if ([stringValue respondsToSelector:@selector(numberWithFloat:)]) { // if it is a Number (in case of nasty API)
        return [NSString stringWithFormat:@"%@",stringValue];
    }
	return stringValue;
}

+ (NSNumber *)safeNumber:(id)numberValue
{
	if (numberValue==nil) {
		return [NSNumber numberWithInteger:0];
    }
	else if (numberValue == (id)[NSNull null]) {
        return [NSNumber numberWithInteger:0];
    }
    else if ([numberValue respondsToSelector:@selector(stringByAppendingString:)]) { // if it's a string. to handle nasty API
        if (![numberValue isEqualToString:@""]) {
            
            // If it is an integer, return [NSNumber numberWithInteger:...]
            // If it is a float, return [NSNumber numberWithFloat:...]
            
            return [NSNumber numberWithFloat:[numberValue floatValue]];
        }
        else {
            return [NSNumber numberWithFloat:0.0];
        }
    }
	return numberValue;
}

#pragma mark - Date

+ (NSDate *)safeDate:(id)dateStringIn
{
    NSString * dateString = dateStringIn;
    if (dateStringIn == nil) {
		dateString = @"1970-01-01 00:00:00";
    } 
	else if (dateStringIn == (id)[NSNull null]) {
        dateString = @"1970-01-01 00:00:00";
    }
    
    // Formatter
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd-HHmm"];
	
    NSDate * dateFromStr = [dateFormatter dateFromString:dateString];
    [dateFormatter release];
    return dateFromStr;
}

+ (BOOL) isExpiredWithDate:(NSDate *)dateIn {
    if ([dateIn timeIntervalSinceNow] < 0) {
        return YES;
    }
    return NO;
}

+ (NSDate *)eventGroupDateFromString:(id)dateStringIn
{
    NSString * dateString = dateStringIn;
    if (dateStringIn == nil) {
		dateString = @"1970-01-01 00:00:00";
    }
	else if (dateStringIn == (id)[NSNull null]) {
        dateString = @"1970-01-01 00:00:00";
    }
    
    // Formatter
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
	
    NSDate * dateFromStr = [dateFormatter dateFromString:dateString];
    [dateFormatter release];
    return dateFromStr;
}

+ (NSString *)lastupdateDateStringFromDate {
    NSDate * now = [NSDate date];
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM"];
    NSString * stringFromDate = [dateFormatter stringFromDate:now];
    [dateFormatter release];
    NSDateFormatter * timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"hh:mm a"];
    NSString * stringFromTime = [[timeFormatter stringFromDate:now] lowercaseString];
    [timeFormatter release];
  
    NSString *updateString = [NSString stringWithFormat:@"Last updated:\n%@, %@" , stringFromDate, stringFromTime];
    return updateString;
}

+ (NSString *)eventDateStringFromDate:(NSDate *)dateIn {
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yy"];
    NSString * stringFromDate = [dateFormatter stringFromDate:dateIn];
    
    NSDate * now = [NSDate date];
    NSString * stringFromNow = [dateFormatter stringFromDate:now];
    
    [dateFormatter release];
    
    if ([stringFromDate isEqualToString:stringFromNow]) { // If today, return "Today"
        return NSLocalizedString(@"Today",@"Today");
    }
    return stringFromDate;
}

+ (NSString *)eventTimeStringFromDate:(NSDate *)dateIn {
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString * stringFromDate = [[dateFormatter stringFromDate:dateIn] lowercaseString];
    [dateFormatter release];
    return stringFromDate;
}

/*
if (ending date > today && starting date <= today)
    Ongoing
else if (ending date = today)
    Last Day
else if ((ending date-starting date) > 1)
    Multi days
else if (ending date < today)
    Expired
*/
+ (NSString *) flagFilenameWithStartDate:(NSDate *)dateStart endDate:(NSDate *)dateEnd {
    NSDate * today = [NSDate date];
    
    
    int daysFromNowToStart = [self daysBetween:today and:dateStart];
    int daysFromNowToEnd = [self daysBetween:today and:dateEnd];
    int daysFromStartToEnd = [self daysBetween:dateStart and:dateEnd];
    
   
    if (daysFromNowToEnd == 0) { // Last Day
        return @"FlagLastday.png";
    }
    else if (daysFromNowToEnd>0 && daysFromNowToStart<=0) {
        return @"FlagOngoing.png";
    }
    else if (daysFromStartToEnd > 1) {
        return @"FlagMultidays.png";
    }
    else if (daysFromNowToEnd < 0) {
        return @"FlagExpired.png";
    }
    return @"";
}

/*
 If the ending date < today
    expired
 else if the starting date > today
    n days to go
 else if the starting date <= today and the ending date > today
    n days left
 */
+ (NSString *) daysInfoWithStartDate:(NSDate *)dateStart endDate:(NSDate *)dateEnd {

    NSDate * today = [NSDate date];
    
    
    int daysFromNowToStart = [self daysBetween:today and:dateStart];
    int daysFromNowToEnd = [self daysBetween:today and:dateEnd];
    
    if (daysFromNowToEnd < 0) {
        return @"Expired";
    }
    else if (daysFromNowToStart <= 0 && daysFromNowToEnd>0) {
        NSString * d = @"days";
        if (daysFromNowToEnd==1) {
            d = @"day";
        }
        return [NSString stringWithFormat:@"%d %@ left", daysFromNowToEnd, d];
    }
    else if (daysFromNowToStart > 0) {
        NSString * d = @"days";
        if (daysFromNowToStart==1) {
            d = @"day";
        }
        return [NSString stringWithFormat:@"%d %@ to go", daysFromNowToStart, d];
    }
    return @"";
}

+ (int) daysBetween:(NSDate *)dt1 and:(NSDate *)dt2 {
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    return [components day];
}


+ (NSString *) dateStringFromString:(NSString *)dateStringIn {
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    
    // 1st, convert to date
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate * dateFromStr = [dateFormatter dateFromString:dateStringIn];
    
    // 2nd, convert the date to string
    [dateFormatter setDateFormat:@"d MMM yyyy"];
    NSString * stringFromNewDate = [dateFormatter stringFromDate:dateFromStr];
    
    [dateFormatter release];
    
    return stringFromNewDate;
}

+ (BOOL) canGetNumberFromString:(NSString *)stringIn {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    NSLocale * l_en = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US"];
    [f setLocale:l_en];
    [l_en release];
    NSNumber * n = [f numberFromString:stringIn];
    [f release];
    if (n==nil) {
        return NO;
    }
    return YES;
}

+ (NSString *)urlImage:(NSString *)urlString width:(int)w height:(int)h {
    
    if ([DeviceFeaturesManager defaultManager].isRetinaDisplay) {
        w = w * 2;
        h = h * 2;
    }
    
    NSString * wStr = @"";
    NSString * hStr = @"";
    if (w>0)
        wStr = [NSString stringWithFormat:@"%d",w];
    if (h>0)
        hStr = [NSString stringWithFormat:@"%d",h];
    
    NSString * newUrlString = [NSString stringWithFormat:@"%@?width=%@&height=%@", urlString, wStr, hStr];
    
    
    return newUrlString;
}



@end
