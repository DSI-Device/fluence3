//
//  GalleryController.h
//  FBTest
//
//  Created by Joseph Armand Baroi on 3/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGalleryViewController.h"
#import "Fluence3AppDelegate.h"
#import "utils.h"

@interface GalleryController : UIViewController <FGalleryViewControllerDelegate> {
	Fluence3AppDelegate *appdt;
    NSArray *localCaptions;
    NSArray *localImages;
    NSArray *networkCaptions;
    NSArray *networkImages;
	FGalleryViewController *localGallery;
    FGalleryViewController *networkGallery;
}

@property (strong, nonatomic)IBOutlet FGalleryViewController *localGallery;     

@end
