//
//  TextPlayViewController.h
//  CodeCollection
//
//  Created by Michelle Ramirez on 10/4/13.
//  Copyright (c) 2013 Michelle Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXLabel.h"


@interface TextPlayViewController : UIViewController <UIGestureRecognizerDelegate>{
    
    CGFloat _lastScale;
	CGFloat _lastRotation;
	CGFloat _firstX;
	CGFloat _firstY;
}
@property (nonatomic, strong) IBOutlet UITextField *enterText;
@property (nonatomic, strong) IBOutlet UIButton *addText;
-(IBAction)addTransformText:(id)sender;
@end


