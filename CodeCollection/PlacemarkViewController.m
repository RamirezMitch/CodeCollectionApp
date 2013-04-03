/*
     File: PlacemarkViewController.m
 Abstract: Displays the address data in the placemark acquired from the reverse geocoder.
  Version: 1.3
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2012 Apple Inc. All Rights Reserved.
 
 */

#import "PlacemarkViewController.h"

@implementation PlacemarkViewController
@synthesize placemark;
@synthesize label1, label2, label3, label4, label5, label6, label7, label8, label9;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.label1.text = [NSString stringWithFormat:@"%@ %@",self.label1.text,self.placemark.thoroughfare];
    self.label2.text = [NSString stringWithFormat:@"%@ %@",self.label2.text,self.placemark.subThoroughfare];
    self.label3.text = [NSString stringWithFormat:@"%@ %@",self.label3.text,self.placemark.locality];
    self.label4.text = [NSString stringWithFormat:@"%@ %@",self.label4.text,self.placemark.subLocality];
    self.label5.text = [NSString stringWithFormat:@"%@ %@",self.label5.text,self.placemark.administrativeArea];
    self.label6.text = [NSString stringWithFormat:@"%@ %@",self.label6.text,self.placemark.subAdministrativeArea];
    self.label7.text = [NSString stringWithFormat:@"%@ %@",self.label7.text,self.placemark.postalCode];
    self.label8.text = [NSString stringWithFormat:@"%@ %@",self.label8.text,self.placemark.country];
    self.label9.text = [NSString stringWithFormat:@"%@ %@",self.label9.text,self.placemark.ISOcountryCode];
   
}

@end

