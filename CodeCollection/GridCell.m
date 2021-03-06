//
//  GridCell.m
//  CodeCollection
//
//  Created by Michelle Ramirez on 29/4/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import "GridCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation GridCell
@synthesize thumbnail;
@synthesize label;

- (id)init {
	
    if (self = [super init]) {
		
        self.frame = CGRectMake(0, 0, 80, 80);
		
		[[NSBundle mainBundle] loadNibNamed:@"GridCell" owner:self options:nil];
		
        [self addSubview:self.view];
		
		self.thumbnail.layer.cornerRadius = 4.0;
		self.thumbnail.layer.masksToBounds = YES;
		self.thumbnail.layer.borderColor = [UIColor lightGrayColor].CGColor;
		self.thumbnail.layer.borderWidth = 1.0;
	}
	
    return self;
	
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */

- (void)dealloc {
    [super dealloc];
}

@end
