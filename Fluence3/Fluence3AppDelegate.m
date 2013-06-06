//
//  AppDelegate.m
//  FBTest
//
//  Created by Joseph Armand Baroi on 3/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Fluence3AppDelegate.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "ISViewController.h"
#import "ISColumnsController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface Fluence3AppDelegate ()

//@property (strong, nonatomic) UINavigationController* navController;

@end

@implementation Fluence3AppDelegate

NSString *const SessionStateChangedNotification = @"com.dsi.Fluence3:SessionStateChangedNotification";

@synthesize window = _window;
//@synthesize mainViewController = _mainViewController;
//@synthesize navController = _navController;
@synthesize userId,loggedInUser;
@synthesize userGalleryId;
@synthesize isStylist;
@synthesize userName;
@synthesize userProfileImage;
@synthesize accessToken,responseData;
@synthesize session = _session;
@synthesize navigationController = _navigationController;
@synthesize columnsController = _columnsController;
@synthesize img;
@synthesize imgOptimized;
@synthesize selectedPoseList;
@synthesize notification,currentImageGallery,currentStylistImage,tagID,TagBrandID,spinner;

- (void)dealloc {
    [_navigationController release];
    [_columnsController release];
    //	[_navController release];
    //  [_mainViewController release];
    [_window release];
    [_session release];
    [userId release];
    [userGalleryId release];
    [notification release];
    [userName release];
    [userProfileImage release];
    [accessToken release];
    [img release];
    [imgOptimized release];
    [currentStylistImage release];
    [currentImageGallery release];
    [super dealloc];
}

#pragma mark Facebook Login

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)showLoginView
{
    UIViewController *topViewController = [self.navigationController topViewController];
    UIViewController *modalViewController = [topViewController modalViewController];
    
    // If the login screen is not already displayed, display it. If the login screen is   563130931
    // displayed, then getting back here means the login in progress did not successfully
    // complete. In that case, notify the login view so it can update its UI appropriately.
    if (![modalViewController isKindOfClass:[LoginViewController class]]) {
        LoginViewController* loginViewController = [[LoginViewController alloc]
                                                    initWithNibName:@"LoginViewController"
                                                    bundle:nil];
        [topViewController presentViewController:loginViewController animated:NO completion:nil];
        [loginViewController release];
    } else {
        LoginViewController* loginViewController = (LoginViewController*)modalViewController;
        [loginViewController loginFailed];
    }
    
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            UIViewController *topViewController = [self.navigationController topViewController];
            if ([[topViewController modalViewController] isKindOfClass:[LoginViewController class]]) {
                [topViewController dismissModalViewControllerAnimated:YES];
            }
            self.accessToken = session.accessToken;
            self.session = session;
            [FBRequestConnection
             startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                               id<FBGraphUser> user,
                                               NSError *error) {
                 if(!error) {
                     responseData = [[NSMutableData data] retain];
                     self.loggedInUser = user;
                     self.userId = user.id;
                     self.userName = user.name;
                     dispatch_queue_t downloader = dispatch_queue_create("PicDownloader", NULL);
                     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal", user.id]];
                     dispatch_async(downloader, ^{
                         NSData *data = [NSData dataWithContentsOfURL:url];
                         self.userProfileImage = [UIImage imageWithData:data];
                     });
                     self.accessToken = FBSession.activeSession.accessToken;
                     NSLog(@"--UserId: %@, Token: %@",url, FBSession.activeSession.accessToken);
                     //[self getUserId];
                 }
             }];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [self.navigationController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self showLoginView];
            break;
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SessionStateChangedNotification object:session];
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */

- (void)openSession
{
    [spinner startAnimating];
    //FBSession *session = [[FBSession alloc] initWithAppID:nil permissions:nil urlSchemeSuffix:@"foo" tokenCacheStrategy:nil];
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"publish_stream",
                            nil];
    [FBSession openActiveSessionWithPermissions:permissions
                                   allowLoginUI:YES
                              completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                  [self sessionStateChanged:session state:state error:error];
                                  [FBRequestConnection
                                   startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                                                     id<FBGraphUser> user,
                                                                     NSError *error) {
                                       if(!error) {
                                           self.loggedInUser = user;
                                           self.userId = user.id;
                                           self.userName = user.name;
                                           dispatch_queue_t downloader = dispatch_queue_create("PicDownloader", NULL);
                                           NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal", user.id]];
                                           dispatch_async(downloader, ^{
                                               NSData *data = [NSData dataWithContentsOfURL:url];
                                               self.userProfileImage = [UIImage imageWithData:data];
                                           });
                                           self.accessToken = FBSession.activeSession.accessToken;
                                           NSLog(@"--UserId: %@, Token: %@",user.id, FBSession.activeSession.accessToken);
                                           [self getUserId];
                                       }
                                   }];
                              }];
    //result = session.isOpen;
}

- (void)getUserId
{
    NSDictionary *jsoning = [[NSDictionary alloc] initWithObjectsAndKeys: self.userId , @"Fb", nil];
    
    NSMutableDictionary *dictionnary = [NSMutableDictionary dictionary];
    [dictionnary setObject:jsoning forKey:@"postData"];
    
    NSString *jsonStr = [dictionnary JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonStr);
    
    NSURL *nsurl = [ NSURL URLWithString: [[utils performSelector:@selector(getServerURL)] stringByAppendingFormat:@"index.php/welcome/getAppId/" ]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl
                                    
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    
                                                       timeoutInterval:60.0];
    
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

// methods for NSURLConnection delegate

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
    
	NSString *responseString = [[NSString alloc]
                                initWithData:responseData encoding:NSUTF8StringEncoding];
    
	NSDictionary *dict = [responseString JSONValue];
    NSDictionary *dict2 = [dict objectAtIndex:0];
    self.userGalleryId = [NSString stringWithFormat:@"%d", [[dict2 objectForKey:@"AppID"] intValue]];
    NSLog(@"Got json: %d",
          [[dict2 objectForKey:@"AppID"] intValue]
          );
    
	[responseData release];
    [spinner stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
   
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {;
	NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
   
}

#pragma mark Default Delegate Functions

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]autorelease];
     // Override point for customization after application launch.
     self.mainViewController = [[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil]autorelease];
     self.navController = [[[UINavigationController alloc] initWithRootViewController:self.mainViewController]autorelease];
     self.window.rootViewController = self.navController;
     [self.window makeKeyAndVisible];
     
     // See if we have a valid token for the current state.
     if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
     // To-do, show logged in view
     [self openSession];
     } else {
     // No, display the login page.
     [self showLoginView];
     }
     
     return YES;*/
        self.columnsController = [[[ISColumnsController alloc] init] autorelease];
    self.columnsController.navigationItem.rightBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                      style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(logoutButtonWasPressed)] autorelease];
    [self reloadViewControllers];
    
    self.navigationController = [[[UINavigationController alloc] init] autorelease];
    self.navigationController.viewControllers = [NSArray arrayWithObject:self.columnsController];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor blackColor];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // To-do, show logged in view
        [self openSession];
    } else {
        // No, display the login page.
        [self showLoginView];
    }
    selectedPoseList = [[NSMutableArray alloc] init];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //[spinner setCenter:_window.center]; 
    spinner.center = self.window.rootViewController.view.center;
    
    spinner.layer.backgroundColor = [[UIColor colorWithWhite:0.0f alpha:0.5f] CGColor];
    spinner.hidesWhenStopped = YES;
    spinner.frame = _window.bounds;
    [self.window.rootViewController.view addSubview:spinner];
    //[_window addSubview:spinner];

    return YES;
}

- (void)reloadViewControllers
{
    self.userGalleryId = @"1";
    self.isStylist = FALSE;
    self.notification = @"1";
    ISViewController *viewController1 = [[[ISViewController alloc] init] autorelease];
    viewController1.navigationItem.title = @"Fluence";
    
    ISViewController *viewController2 = [[[ISViewController alloc] init] autorelease];
    viewController2.navigationItem.title = @"Fluence";
    
    ISViewController *viewController3 = [[[ISViewController alloc] init] autorelease];
    viewController3.navigationItem.title = @"Fluence";
    
    self.columnsController.viewControllers = [NSArray arrayWithObjects:
                                              viewController1,
                                              viewController2,
                                              viewController3, nil];
    
}

-(void)logoutButtonWasPressed {
    [FBSession.activeSession closeAndClearTokenInformation];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    if (FBSession.activeSession.state == FBSessionStateCreatedOpening) {
        // BUG: for the iOS 6 preview we comment this line out to compensate for a race-condition in our
        // state transition handling for integrated Facebook Login; production code should close a
        // session in the opening state on transition back to the application; this line will again be
        // active in the next production rev
        //[FBSession.activeSession close]; // so we close our session and start over
    }	
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}
@end
