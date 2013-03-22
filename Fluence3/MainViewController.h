//
//  ViewController.h
//  FBTest
//
//  Created by Joseph Armand Baroi on 3/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class Fluence3AppDelegate;
@class GalleryController;

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, FBFriendPickerDelegate, CLLocationManagerDelegate, FBPlacePickerDelegate>{
    Fluence3AppDelegate *appdt;
    GalleryController *gc;
}

@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UITableView *menuTableView;
@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (strong, nonatomic) NSArray* selectedFriends;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) FBPlacePickerViewController *placePickerController;
@property (strong, nonatomic) NSObject<FBGraphPlace>* selectedPlace;
@property (strong, nonatomic) GalleryController *gc;

- (void)populateUserDetails; 

@end
