//
//  AppDelegate.h
//  FBTest
//
//  Created by Joseph Armand Baroi on 3/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "utils.h"
#import <FacebookSDK/FacebookSDK.h>
#import <CoreLocation/CoreLocation.h>
#import "OpeningViewController.h"
@class MainViewController;
@class ISColumnsController;

@interface Fluence3AppDelegate : UIResponder <UIApplicationDelegate>{
    CLLocationManager *locationManager;
    NSString *userId;
    NSString *userGalleryId;
    NSString *userName;
    NSString *accessToken;
    NSString *notification;
    NSString *message;
    NSString *currentStylistImageId;
    UIImage *userProfileImage;
    NSMutableData *responseData;
    BOOL *isStylist;
    BOOL *conCheckr;
    CLLocationDegrees latitude;
	CLLocationDegrees longitude;
    UIImage *img;
    UIImage *imgOptimized;
    NSMutableArray *selectedPoseList;
    id<FBGraphUser> loggedInUser;
    NSString *currentImageGallery;
    NSString *currentStylistImage;
    NSString *tagID1;
    NSString *TagBrandID;
    UIActivityIndicatorView *spinner;
}

extern NSString *const SessionStateChangedNotification;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, nonatomic) CLLocationDegrees latitude;
@property (nonatomic, nonatomic) CLLocationDegrees longitude;
@property (nonatomic, strong) NSString *userGalleryId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *currentStylistImage;
@property (nonatomic, strong) NSString *currentStylistImageId;
@property (nonatomic, strong) UIImage *userProfileImage;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *notification;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSString *currentImageGallery;
@property (strong, nonatomic) FBSession *session;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,readonly) UIActivityIndicatorView *spinner;
@property (retain, nonatomic) UINavigationController *navigationController;
@property (retain, nonatomic) ISColumnsController *columnsController;

@property (nonatomic, strong) UIImage *img;
@property BOOL *isStylist;
@property (nonatomic, strong) UIImage *imgOptimized;
@property (nonatomic, strong) NSMutableArray *selectedPoseList;
//@property (strong, nonatomic) MainViewController *mainViewController;
@property (nonatomic, strong) NSString *tagID1;
@property (nonatomic, strong) NSString *TagBrandID;
- (void)openSession;
- (void)reloadViewControllers;
-(void)logoutButtonWasPressed;

@end
