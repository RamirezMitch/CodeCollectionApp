//
//  FirstViewController.h
//  MyViewController
//
//  Created by Michelle Ramirez on 12/12/12.
//  Copyright (c) 2012 Michelle Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface MoveScaleImageViewController : UIViewController <UIGestureRecognizerDelegate>{
    UIView *canvas;
    CGFloat _firstX;
	CGFloat _firstY;
    
    CGPoint currentPoint;
}
@property (nonatomic, retain) IBOutlet UIView *canvas;
@end
