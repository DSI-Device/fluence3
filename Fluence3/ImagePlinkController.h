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
#import "TagCategoryController.h"
#import "ASIHTTPRequest.h"
#import "utils.h"
#import "LocationGetter.h"
#import "CameraImageController.h"
#import "CountryListViewController.h"

@interface ImagePlinkController : UIViewController<TagCategoryControllerDelegate, LocationGetterDelegate, CountryControllerDelegate>{
    Fluence3AppDelegate *appdt;
    UIView *_container; // used as view for the controller
	UIView *_innerContainer; // sized and placed to be fullscreen within the container
	UIToolbar *_toolbar;
    UIImageView *_plinkImage;
    UIView *_tagContainer;
    UIView *_tagCaptionContainer;
    UILabel *_tagCaption;
    
    UIButton *_saveButton;
    UIButton *_cancelButton;

    NSMutableDictionary *_tag;
	NSMutableArray *_tagItems;
    NSString* _tagCategory;
    NSInteger _currentIndex;
    UIActivityIndicatorView *spinner;
    CLLocation *lastKnownLocation;
    NSString *title;
    NSString *tagWord;
}

- (void)removeImageAtIndex:(NSUInteger)index;
- (void)retrieveWeatherForLocation:(CLLocation *)location orZipCode:(NSString *)zipCode;

@property (nonatomic,retain) NSString *_tagCategory;
@property (nonatomic,readonly) UIToolbar *toolBar;
@property (nonatomic,readonly) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) CLLocation *lastKnownLocation;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *tagWord;
@end
