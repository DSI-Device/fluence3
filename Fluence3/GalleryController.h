//
//  GalleryController.h
//  FBTest
//
//  Created by Joseph Armand Baroi on 3/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fluence3AppDelegate.h"
#import "utils.h"
#import "ISViewController.h"
@interface GalleryController : UIViewController <UINavigationControllerDelegate> {
	Fluence3AppDelegate *appdt;
    IBOutlet UIView *subNavContainer;
    UINavigationController *subNavCntlr;
}


@end
