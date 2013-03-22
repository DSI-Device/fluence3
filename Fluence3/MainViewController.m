//
//  ViewController.m
//  FBTest
//
//  Created by Joseph Armand Baroi on 3/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Fluence3AppDelegate.h"
#import "GalleryController.h"

@implementation MainViewController 

@synthesize userNameLabel;
@synthesize userProfileImage;
@synthesize menuTableView;
@synthesize friendPickerController = _friendPickerController;
@synthesize selectedFriends = _selectedFriends;
@synthesize locationManager = _locationManager;
@synthesize placePickerController = _placePickerController;
@synthesize selectedPlace = _selectedPlace; 
@synthesize gc;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    _friendPickerController.delegate = nil;
    _locationManager.delegate = nil;
    _placePickerController.delegate = nil;
    _placePickerController = nil;
    _selectedPlace = nil;
    [menuTableView release];
    [userProfileImage release];
    [userNameLabel release];
    [gc release];
    [super dealloc];
}

#pragma mark table view related

- (void)updateCellIndex:(int)index withSubtitle:(NSString*)subtitle {
    UITableViewCell *cell = (UITableViewCell *)[self.menuTableView 
                                                cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    cell.detailTextLabel.text = subtitle;
}

- (void)updateSelections 
{
    NSString* friendsSubtitle = @"Select friends";
    int friendCount = self.selectedFriends.count;
    if (friendCount > 2) {
        // Just to mix things up, don't always show the first friend.
        id<FBGraphUser> randomFriend = 
        [self.selectedFriends objectAtIndex:arc4random() % friendCount];
        friendsSubtitle = [NSString stringWithFormat:@"%@ and %d others", 
                           randomFriend.name,
                           friendCount - 1];
    } else if (friendCount == 2) {
        id<FBGraphUser> friend1 = [self.selectedFriends objectAtIndex:0];
        id<FBGraphUser> friend2 = [self.selectedFriends objectAtIndex:1];
        friendsSubtitle = [NSString stringWithFormat:@"%@ and %@",
                           friend1.name,
                           friend2.name];
    } else if (friendCount == 1) {
        id<FBGraphUser> friend = [self.selectedFriends objectAtIndex:0];
        friendsSubtitle = friend.name;
    }
    [self updateCellIndex:2 withSubtitle:friendsSubtitle];
    [self updateCellIndex:1 withSubtitle:(self.selectedPlace ?
                                          self.selectedPlace.name :
                                          @"Select One")];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:
            if (!self.placePickerController) {
                self.placePickerController = [[[FBPlacePickerViewController alloc] initWithNibName:nil bundle:nil] autorelease];
                self.placePickerController.title = @"Select a restaurant";
            }
            self.placePickerController.locationCoordinate = self.locationManager.location.coordinate;
            self.placePickerController.radiusInMeters = 1000;
            self.placePickerController.resultsLimit = 50;
            self.placePickerController.searchText = @"restaurant";
            self.placePickerController.itemPicturesEnabled = NO;
            self.placePickerController.delegate = self;
//            
            [self.placePickerController loadData];
            [self.navigationController pushViewController:self.placePickerController 
                                                 animated:true];
            break;

        case 2:
            if (!self.friendPickerController) {
                self.friendPickerController = [[[FBFriendPickerViewController alloc] initWithNibName:nil bundle:nil]autorelease];
                self.friendPickerController.title = @"Select friends";
                
                // Set the friend picker delegate
                self.friendPickerController.delegate = self;
            }
            
            [self.friendPickerController loadData];
            [self.navigationController pushViewController:self.friendPickerController 
                                                 animated:true];
            break;
        
        case 3:
            gc = [[[GalleryController alloc] initWithNibName:@"GalleryController" bundle:nil]autorelease];
                
            gc.title = @"Gallery";
                
            // Set the friend picker delegate
            //gc.delegate = self;
                
            [self.navigationController pushViewController:gc animated:true];
            break;
            
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
        cell.textLabel.clipsToBounds = YES;
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.4 
                                                         green:0.6
                                                          blue:0.8 
                                                         alpha:1];
        cell.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
        cell.detailTextLabel.clipsToBounds = YES;
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"What are you eating?";
            cell.detailTextLabel.text = @"Select one";
            cell.imageView.image = [UIImage imageNamed:@"action-eating.png"];
            break;
            
        case 1:
            cell.textLabel.text = @"Where are you?";
            cell.detailTextLabel.text = @"Select one";
            cell.imageView.image = [UIImage imageNamed:@"action-location.png"];
            break;
            
        case 2:
            cell.textLabel.text = @"With whom?";
            cell.detailTextLabel.text = @"Select friends";
            cell.imageView.image = [UIImage imageNamed:@"action-people.png"];
            break;
            
        case 3:
            cell.textLabel.text = @"Got a picture?";
            cell.detailTextLabel.text = @"Take one";
            cell.imageView.image = [UIImage imageNamed:@"action-photo.png"];
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - FB Related

- (void)friendPickerViewControllerSelectionDidChange:
(FBFriendPickerViewController *)friendPicker
{
    self.selectedFriends = friendPicker.selection;
    [self updateSelections];
}

- (void)populateUserDetails 
{
    appdt = [[UIApplication sharedApplication] delegate];
    
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, 
           NSDictionary<FBGraphUser> *user, 
           NSError *error) {
             if (!error) {
                 self.userNameLabel.text = user.name;
                 self.userProfileImage.profileID = user.id;
                 appdt.userId = user.id;
                 appdt.accessToken = FBSession.activeSession.accessToken;

             }
         }];      
    }
}  
- (void)sessionStateChanged:(NSNotification*)notification {
    [self populateUserDetails];
}

#pragma mark -location related

- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation 
{
    if (!oldLocation ||
        (oldLocation.coordinate.latitude != newLocation.coordinate.latitude && 
         oldLocation.coordinate.longitude != newLocation.coordinate.longitude)) {
            // To-do, add code for triggering view controller update
            NSLog(@"Got location: %f, %f", 
                  newLocation.coordinate.latitude, 
                  newLocation.coordinate.longitude);
        }
}

- (void)locationManager:(CLLocationManager *)manager 
       didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)placePickerViewControllerSelectionDidChange:
(FBPlacePickerViewController *)placePicker
{
    self.selectedPlace = placePicker.selection;
    [self updateSelections];
    if (self.selectedPlace.count > 0) {
        [self.navigationController popViewControllerAnimated:true];
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
                                              initWithTitle:@"Logout"
                                              style:UIBarButtonItemStyleBordered
                                              target:self
                                              action:@selector(logoutButtonWasPressed:)]autorelease];
    [super viewDidLoad];

    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(sessionStateChanged:) 
     name:SessionStateChangedNotification
     object:nil];
    self.title = @"Fluence3";
    
    self.locationManager = [[[CLLocationManager alloc] init]autorelease];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    // We don't want to be notified of small changes in location, 
    // preferring to use our last cached results, if any.
    self.locationManager.distanceFilter = 50;
    [self.locationManager startUpdatingLocation];
	// Do any additional setup after loading the view, typically from a nib.

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.friendPickerController = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (FBSession.activeSession.isOpen) {
        [self populateUserDetails];
    }
//    else{
//        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
//        [appDelegate openSession];
//    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)logoutButtonWasPressed:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
}

@end
