//
//  AppDelegate.h
//  FBTest
//
//  Created by Joseph Armand Baroi on 3/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class MainViewController;

@interface Fluence3AppDelegate : UIResponder <UIApplicationDelegate>{
    NSString *userId;
    NSString *userName;
    NSString *accessToken;
    BOOL isStylist;
}

extern NSString *const SessionStateChangedNotification;

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *accessToken;

@property (strong, nonatomic) FBSession *session;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainViewController *mainViewController;

- (void)openSession;

@end
