//
//  MapViewController.m
//  Fluence3
//
//  Created by Joseph Armand Baroi on 4/22/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "MyAnnotation.h"

#import "TSPopoverController.h"

@implementation MapViewController

@synthesize mapView,annotationsArray,appdt;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [mapView release];
    [annotationsArray release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    appdt = [[UIApplication sharedApplication] delegate];
    
    NSString *latitude = [NSString stringWithFormat:@"%f", appdt.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", appdt.longitude];
    
    NSDictionary *jsoning = [[NSDictionary alloc] initWithObjectsAndKeys: appdt.userGalleryId , @"UserId",latitude,@"latitude",longitude,@"longitude", nil];
    
    NSMutableDictionary *dictionnary = [NSMutableDictionary dictionary];
    [dictionnary setObject:jsoning forKey:@"postData"];
    
    NSString *jsonStr = [dictionnary JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonStr);
    
    NSURL *nsurl = [ NSURL URLWithString: [[utils performSelector:@selector(getServerURL)] stringByAppendingFormat:@"index.php/welcome/GetMapData/" ]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl
                                    
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    
                                                       timeoutInterval:60.0];
    
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    //[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSError *theError = nil;
    NSURLResponse *theResponse =[[NSURLResponse alloc]init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"Json back %@", responseString);
    
    NSMutableArray *annotationsArray2 = [responseString JSONValue];
    
    annotationsArray = [[NSMutableArray alloc] initWithObjects:nil];
    for (NSDictionary *dict in annotationsArray2) {
        [annotationsArray addObject:dict];
    }

    // Do any additional setup after loading the view from its nib.
    self.mapView.delegate = self;
    [self getLocations];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshMap)];
//    [self.navigationItem.rightBarButtonItem setTitle:@"Refresh"];
    //moving annotations maybe loose-end
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Map Related

- (void)refreshMap
{
    // start off by default in San Francisco
    NSLog(@"asa");
    id userAnnotation = self.mapView.userLocation;
    
    NSMutableArray *annotations1 = [NSMutableArray arrayWithArray:self.mapView.annotations];
    [annotations1 removeObject:userAnnotation];
    
    [self.mapView removeAnnotations:annotations1];
    [self getLocations];
}

- (void)gotoLocation
{
    // start off by default in San Francisco
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = appdt.latitude;
    newRegion.center.longitude = appdt.longitude;
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
	
    [self.mapView setRegion:newRegion animated:YES];
}

- (void)getLocations
{
    
    mapView.delegate=self;
    /*
    NSDictionary *user1 = [[NSDictionary  alloc] initWithObjectsAndKeys: @"3", @"userId", @"Naim", @"userName", @"37.786996", @"userLatitude", @"-122.419281", @"userLontitude",@"1", @"userCat", @"http://farm6.static.flickr.com/5042/5323996646_9c11e1b2f6_b.jpg", @"userPic",nil];
    NSDictionary *user2 = [[NSDictionary  alloc] initWithObjectsAndKeys: @"7", @"userId", @"Nazmul", @"userName", @"37.810000", @"userLatitude", @"-122.477989", @"userLontitude",@"1", @"userCat", @"http://farm6.static.flickr.com/5042/5323996646_9c11e1b2f6_b.jpg", @"userPic", nil];
    NSDictionary *user3 = [[NSDictionary  alloc] initWithObjectsAndKeys: @"4", @"userId", @"Shuvo", @"userName", @"37.760000", @"userLatitude", @"-122.447989", @"userLontitude",@"1", @"userCat", @"http://farm6.static.flickr.com/5042/5323996646_9c11e1b2f6_b.jpg", @"userPic", nil];
    NSDictionary *user4 = [[NSDictionary  alloc] initWithObjectsAndKeys: @"2", @"userId", @"Anik", @"userName", @"37.80000", @"userLatitude", @"-122.407989", @"userLontitude",@"1", @"userCat", @"http://farm6.static.flickr.com/5042/5323996646_9c11e1b2f6_b.jpg", @"userPic", nil];
    
    annotationsArray = [[NSMutableArray alloc] initWithObjects:user1,user2, user3, user4,nil];
   
	CLLocationCoordinate2D theCoordinate1;
    theCoordinate1.latitude = 37.786996;
    theCoordinate1.longitude = -122.419281;
	
	CLLocationCoordinate2D theCoordinate2;
    theCoordinate2.latitude = 37.810000;
    theCoordinate2.longitude = -122.477989;
	
	CLLocationCoordinate2D theCoordinate3;
    theCoordinate3.latitude = 37.760000;
    theCoordinate3.longitude = -122.447989;
	
	CLLocationCoordinate2D theCoordinate4;
    theCoordinate4.latitude = 37.80000;
    theCoordinate4.longitude = -122.407989;
	*/
    [self setLocations];
	
}

- (void)setLocations
{
    int annCount = [annotationsArray count];
    
    for (int i = 0; i < annCount; i++) {
        id row = [annotationsArray objectAtIndex:i];
        MyAnnotation* myAnnotation1=[[MyAnnotation alloc] init];
        NSString * str = [NSString stringWithFormat:[row objectForKey:@"userId"]];
        myAnnotation1.uniqueId = str;
        
        CLLocationCoordinate2D theCoordinate1;
        str = [NSString stringWithFormat:[row objectForKey:@"userLatitude"]];
        theCoordinate1.latitude = [str doubleValue];
        str = [NSString stringWithFormat:[row objectForKey:@"userLontitude"]];
        theCoordinate1.longitude = [str doubleValue];
        
        myAnnotation1.coordinate=theCoordinate1;
        str = [NSString stringWithFormat:[row objectForKey:@"userName"]];
        myAnnotation1.title=str;
        myAnnotation1.subtitle=@"Send Message";
        
        str = [NSString stringWithFormat:[row objectForKey:@"userPic"]];
        myAnnotation1.imageUrl = str;
        
        [mapView addAnnotation:myAnnotation1];
        [myAnnotation1 release];
    }   

	// Walk the list of overlays and annotations and create a MKMapRect that
    // bounds all of them and store it into flyTo.
    MKMapRect flyTo = MKMapRectNull;
	for (id annotation in annotationsArray) {
		NSLog(@"fly to on");
        NSString * str;
        CLLocationCoordinate2D theCoordinate1;
        str = [NSString stringWithFormat:[annotation objectForKey:@"userLatitude"]];
        theCoordinate1.latitude = [str doubleValue];
        str = [NSString stringWithFormat:[annotation objectForKey:@"userLontitude"]];
        theCoordinate1.longitude = [str doubleValue];;
        
        MKMapPoint annotationPoint = MKMapPointForCoordinate(theCoordinate1);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(flyTo)) {
            flyTo = pointRect;
        } else {
            flyTo = MKMapRectUnion(flyTo, pointRect);
			//NSLog(@"else-%@",annotationPoint.x);
        }
    }
    
    // Position the map so that all overlays and annotations are visible on screen.
    mapView.visibleMapRect = flyTo;

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	NSLog(@"welcome into the map view annotation");
//	MyAnnotation *vma = (MyAnnotation *)annotation;
	// if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
	// try to dequeue an existing pin view first
	static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
	MKPinAnnotationView* pinView = [[[MKPinAnnotationView alloc]
									 initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier] autorelease];
	pinView.animatesDrop=YES;
	pinView.canShowCallout=YES;
	pinView.pinColor=MKPinAnnotationColorPurple;
	
	
	UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	[rightButton setTitle:annotation.title forState:UIControlStateNormal];
//	[rightButton addTarget:self	action:@selector(calloutAccessoryControlTapped:) forControlEvents:UIControlEventTouchUpInside];
	pinView.rightCalloutAccessoryView = rightButton;
	
	UIImageView *profileIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile.png"]];
	pinView.leftCalloutAccessoryView = profileIconView;
	[profileIconView release];
   
	return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view 
calloutAccessoryControlTapped:(UIControl *)control
{
    id<MKAnnotation> selectedAnn = view.annotation;
    
    if ([selectedAnn isKindOfClass:[MyAnnotation class]])
    {
        MyAnnotation *vma = (MyAnnotation *)selectedAnn;
        NSLog(@"User Name = %@, UserId=%@", vma.title, vma.uniqueId);
        
        UIViewController *commentViewController = [UIViewController alloc];
        commentViewController.view.frame = CGRectMake(10,200, 300, 100);
        popoverController = [[TSPopoverController alloc] initWithContentViewController:commentViewController];
        
        popoverController.cornerRadius = 5;
        popoverController.titleColor = [UIColor whiteColor];
        popoverController.titleText = @"Send";
        popoverController.popoverBaseColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        popoverController.popoverGradient= NO;
        //    popoverController.arrowPosition = TSPopoverArrowPositionHorizontal;
        
        
        _shareloading = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, 200, 30)];
        _shareloading.font = [UIFont systemFontOfSize:22];
        _shareloading.text = @"Message Send";
        _shareloading.textColor = [UIColor whiteColor];
        
        _commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, 200, 30)];
        _commentTextField.borderStyle = UITextBorderStyleRoundedRect;
        _commentTextField.font = [UIFont systemFontOfSize:15];
        _commentTextField.placeholder = @"enter text";
        _commentTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _commentTextField.keyboardType = UIKeyboardTypeDefault;
        _commentTextField.returnKeyType = UIReturnKeyDone;
        _commentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _commentTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _commentTextField.delegate = self;
        _commentTextField.hidden = NO;
        _topButton.hidden = NO;
        _shareloading.hidden = YES;
        [commentViewController.view addSubview:_commentTextField];
        [commentViewController.view addSubview:_shareloading];
        [_commentTextField release];
        
        
        
        
        _topButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_topButton addTarget:self action:@selector(messageDone:forEvent:) forControlEvents:UIControlEventTouchUpInside];
        _topButton.frame = CGRectMake(220,20, 80, 30);
        [_topButton setTitle:@"Message" forState:UIControlStateNormal];
        _topButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [commentViewController.view addSubview:_topButton];
        [popoverController showPopoverWithTouchinBottom];
    }
    else
    {
        NSLog(@"selected annotation (not a VMA) = %@", selectedAnn);
    }
    
    //do something with the selected annotation... 
}
- (void)messageDone:(id)sender forEvent:(UIEvent*)event {
    _commentTextField.hidden = YES;
    _topButton.hidden = YES;
    _shareloading.hidden = NO;
    //    [popoverController dismissPopoverAnimatd:YES];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{

//    MyAnnotation* myAnnotation1=[[MyAnnotation alloc] init];
//    CLLocation *userLoc = userLocation.location;
//    CLLocationCoordinate2D userCoordinate = userLoc.coordinate;
//	NSLog(@"user latitude = %f",userCoordinate.latitude);
//	NSLog(@"user longitude = %f",userCoordinate.longitude);
//    
//    myAnnotation1.title=@"";
//    myAnnotation1.subtitle=@"Current Location";
//    myAnnotation1.coordinate=userCoordinate;
//    [self.mapView addAnnotation:myAnnotation1];
//    [myAnnotation1 release];
    
    
    
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
//    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
//    
//    // Add an annotation
//    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//    
//    CLLocationCoordinate2D location;
//    location.latitude = userLocation.coordinate.latitude+.005;//51.509979999999999
//    location.longitude = userLocation.coordinate.longitude;
//    
//    point.coordinate = location;
//    point.title = @"Where am I?";
//    point.subtitle = @"I'm here!!!";
//    
//    [self.mapView addAnnotation:point];
}

@end
