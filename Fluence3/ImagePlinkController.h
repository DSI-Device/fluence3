//
//  ImagePlinkController.h
//  Fluence3
//
//  Created by Joseph Armand Baroi on 4/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fluence3AppDelegate.h"
#import "RemoveEventView.h"

@interface ImagePlinkController : UIViewController{
    Fluence3AppDelegate *appdt;
    UIView *_container; // used as view for the controller
	UIView *_innerContainer; // sized and placed to be fullscreen within the container
	UIToolbar *_toolbar;
    UIImageView *_plinkImage;
    UIView *_tagContainer;
    
    UIButton *_saveButton;
    UIButton *_cancelButton;

    NSMutableDictionary *_tag;
	NSMutableArray *_tagItems;
    NSString* _tagCategory;
}

- (void)removeImageAtIndex:(NSUInteger)index;

@property (nonatomic,retain) NSString *_tagCategory;
@property (nonatomic,readonly) UIToolbar *toolBar;

@end
