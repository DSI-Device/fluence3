//
//  ColorViewController.h
//  Fluence3
//
//  Created by Joseph Armand Baroi on 3/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fluence3AppDelegate.h"

@interface ColorViewController : UIViewController <UITabBarDelegate>{
	Fluence3AppDelegate *appdt;
	IBOutlet UIImageView *imageView;    
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
-(IBAction)reset:(id)sender;
-(IBAction)done:(id)sender;

- (UIImage *)makeImageBlackWhite:(UIImage *)img;
- (UIImage *)makeSepia:(UIImage *)img;

@end
