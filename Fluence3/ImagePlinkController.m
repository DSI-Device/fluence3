//
//  ImagePlinkController.m
//  Fluence3
//
//  Created by Joseph Armand Baroi on 4/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ImagePlinkController.h"
#import <QuartzCore/QuartzCore.h>
#import "OBShapedButton.h"
#import "TagCategoryController.h"
#import "LocationGetter.h"
#import "ASIFormDataRequest.h"

@class ASIFormDataRequest;
@class CameraImageController;

#define kCaptionPadding 3
#define kToolbarHeight 40

@implementation ImagePlinkController

const NSString *kWundergroundKey = @"67b642d58e39c9cc";

@synthesize toolBar = _toolbar;
@synthesize _tagCategory,spinner,lastKnownLocation,title,tagWord;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _tag						= [[NSMutableDictionary alloc] init];
		_tagItems					= [[NSMutableArray alloc] init];
        appdt                       = [[UIApplication sharedApplication] delegate];
        _currentIndex               = 0;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(handleBack1:)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    //[backButton release];
    [super viewDidLoad];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(((self.view.frame.size.width/2.0)), ((self.view.frame.size.height/2.0)-80))]; 
    
    spinner.layer.backgroundColor = [[UIColor colorWithWhite:0.0f alpha:0.5f] CGColor];
    spinner.hidesWhenStopped = YES;
    spinner.frame = self.view.bounds;
    
    [self.view addSubview:spinner];
    // Do any additional setup after loading the view from its nib.
    
    // get our physical location
    LocationGetter *locationGetter = [[LocationGetter alloc] init];
    locationGetter.delegate = self;
    [locationGetter startUpdates];

}
- (void)loadView
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithString: @"test.png"] ];
     appdt.img = appdt.imgOptimized = [UIImage imageWithContentsOfFile:path];

    
    // appdt.img = appdt.imgOptimized = [UIImage imageNamed:@"test.png"];
    // create public objects first so they're available for custom configuration right away. positioning comes later.
    _container							= [[UIView alloc] initWithFrame:CGRectZero];
    _innerContainer						= [[UIView alloc] initWithFrame:CGRectZero];
    _toolbar							= [[UIToolbar alloc] initWithFrame:CGRectZero];
    _tagContainer                       = [[UIView alloc] initWithFrame:CGRectZero];
    _plinkImage                         = [[UIImageView alloc] initWithFrame:CGRectZero];
    _tagCaptionContainer                = [[UIView alloc] initWithFrame:CGRectZero];
    _tagCaption                         = [[UILabel alloc] initWithFrame:CGRectZero];
    
//setup views
    CGRect screenFrame                  = [[UIScreen mainScreen] bounds];
	_container.frame                    = CGRectMake(0, 0, screenFrame.size.width, screenFrame.size.height);
    CGRect innerContainerRect;
    innerContainerRect                  = CGRectMake(0, 0, _container.frame.size.width, screenFrame.size.height);
    _innerContainer.frame               = innerContainerRect;
    _toolbar.frame                      = CGRectMake( 0, _container.frame.size.height-120, _container.frame.size.width, 60);
    _plinkImage.frame                   = CGRectMake(0, 0, _container.frame.size.width, 320);
    CGRect cr = _plinkImage.frame;
    NSLog(@"asa");
// setup tag
    _tagContainer.hidden				= NO;
    _tagContainer.backgroundColor       = [UIColor colorWithWhite:1.0 alpha:0.0];
    _tagContainer.frame                 = CGRectMake(0, 0, _container.frame.size.width, 320);

// setup tag Caption
    _tagCaptionContainer.hidden				= YES;
    _tagCaptionContainer.backgroundColor    = [UIColor colorWithWhite:1.0 alpha:0.0];
    _tagCaption.font						= [UIFont systemFontOfSize:14.0];
    _tagCaption.textColor					= [UIColor whiteColor];
    _tagCaption.backgroundColor				= [UIColor clearColor];
    _tagCaption.textAlignment				= UITextAlignmentCenter;
    _tagCaption.shadowColor					= [UIColor blackColor];
    _tagCaption.shadowOffset				= CGSizeMake( 1, 1 );    
// setup Image view
    _plinkImage.image                       = appdt.img;
    
//setup buttons
    _saveButton                             = [UIButton buttonWithType:UIButtonTypeCustom];

//set the position of the button
    _saveButton.frame                       = CGRectMake(5, 10, 60, 40);

//background image
//    UIImage *buttonImage = [UIImage imageNamed:@"heart-icon.png"];
    
//create the button and assign the image addSubview:button
    
//    [_saveButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
   
    [_saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _saveButton.backgroundColor = [UIColor whiteColor];
    _saveButton.layer.borderColor = [UIColor blackColor].CGColor;
    _saveButton.layer.borderWidth = 0.5f;
    _saveButton.layer.cornerRadius = 10.0f;
    
    
//set the button's title
    [_saveButton setTitle:@"Upload" forState:UIControlStateNormal];
//listen for clicks
    [_saveButton addTarget:self action:@selector(uploadImage_asi) forControlEvents:UIControlEventTouchUpInside];
//add the button to the view
    _cancelButton  = [UIButton buttonWithType:UIButtonTypeCustom];
//set the position of the button
    
    _cancelButton.frame = CGRectMake(_container.frame.size.width-65, 10, 60, 40);
//background image
//    UIImage *buttonImage = [UIImage imageNamed:@"heart-icon.png"];
    
//create the button and assign the image addSubview:button
//    [_saveButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _cancelButton.backgroundColor = [UIColor whiteColor];
    _cancelButton.layer.borderColor = [UIColor blackColor].CGColor;
    _cancelButton.layer.borderWidth = 0.5f;
    _cancelButton.layer.cornerRadius = 10.0f;
    
//set the button's title
    [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
//listen for clicks
    [_cancelButton addTarget:self action:@selector(handleBack) forControlEvents:UIControlEventTouchUpInside];
//add the button to the view
    
// set view
	self.view = _container;
    
// add items to their containers                                                                       
	[_container addSubview:_innerContainer];
	[_innerContainer addSubview:_toolbar];
    [_innerContainer addSubview:_plinkImage];    
    [_innerContainer addSubview:_tagContainer];
    [_innerContainer addSubview:_tagCaptionContainer];

    [_toolbar addSubview:_cancelButton];
    [_toolbar addSubview:_saveButton];
    
    [_tagCaptionContainer addSubview:_tagCaption];
//For debug
    
//    CGSize contS = _container.frame.size;
//    CGPoint contP = _container.frame.origin;
//    
//    CGSize inContS = _innerContainer.frame.size;
//    CGPoint inContP = _innerContainer.frame.origin;
//
//    CGSize tContS = _tagContainer.frame.size;
//    CGPoint tContP = _tagContainer.frame.origin;
//    
//    CGSize tbContS = _toolbar.frame.size;
//    CGPoint tbContP = _toolbar.frame.origin;
//
//    CGSize piContS = _plinkImage.frame.size;
//    CGPoint piContP = _plinkImage.frame.origin;
    
    
    
    

}

- (void)viewDidUnload {
    [_cancelButton release], _cancelButton = nil;
    [_saveButton release], _saveButton = nil;
    [_tagItems release], _tagItems = nil;
    [_container release], _container = nil;
    [_innerContainer release], _innerContainer = nil;
    [_toolbar release], _toolbar = nil;
    [_tagContainer release], _tagContainer = nil;
    [_tag release], _tag = nil;
    [spinner release];
    [super viewDidUnload];
}

- (void)dealloc {
    [_tag release];
    _tag = nil;
	
    [_tagItems release];
    _tagItems = nil;
    
    [_tagContainer release];
    _tagContainer = nil;
    
    [_saveButton release];
    _saveButton = nil;
    
    [_cancelButton release];
    _cancelButton = nil;
    
    [_toolbar release];
    _toolbar = nil;
    
    [_plinkImage release];
    _plinkImage = nil;
    
    [_innerContainer release];
    _innerContainer = nil;
    
    [_container release];
    _container = nil;
    
    [spinner release];
    [lastKnownLocation release];
    
    [super dealloc];
}

- (void)removeImageAtIndex:(NSUInteger)index
{
	// remove the image and thumbnail at the specified index.

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark Tag Related

- (void)addItemViewController:(TagCategoryController *)controller didFinishEnteringItem:(NSString *)item:(NSString *)item2
{
    [_tag setValue:item forKey:@"tagCaption"];
    [_tag setValue:item2 forKey:@"tagBrand"];
//    UIAlertView *alert = [[UIAlertView alloc]
//                          initWithTitle: @"Previous Date"
//                          message: item
//                          delegate: nil
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles:nil];
//    [alert show];
//    [alert release];
    [_tag setValue:appdt.tagID forKey:@"CategoryID"];
    [_tag setValue:appdt.TagBrandID forKey:@"TagBrandID"];
    [_tag setValue:item2 forKey:@"tagBrand"];
    NSInteger myX = [[_tag objectForKey:@"tagX"] intValue];
    NSInteger myY = [[_tag objectForKey:@"tagY"] intValue];

//    _tagItems = [[NSMutableArray alloc] initWithObjects:_tag, nil];    
    [_tagItems insertObject:_tag atIndex:_currentIndex];
    OBShapedButton *button = [[OBShapedButton buttonWithType:UIButtonTypeCustom] retain];
    button.frame = CGRectMake(myX, myY, 25.0, 25.0);
    [button setTitle:@"tagBtn" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    UIImage *buttonImageNormal = [UIImage imageNamed:@"button-normal.png"];
    UIImage *strechableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    
    [button setImage:strechableButtonImageNormal forState:UIControlStateNormal];
    UIImage *buttonImagePressed = [UIImage imageNamed:@"button-highlighted.png"];
    UIImage *strechableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    
    [button setImage:strechableButtonImagePressed forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(tappedBtn:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = _currentIndex;
    [_tagContainer addSubview:button];
    [button release];
    _currentIndex++;
}

- (void)tappedBtn:(id)sender
{
    OBShapedButton *button = (OBShapedButton *)sender;
    int bTag = button.tag;
    //_tagCaptionContainer.alpha = 0.5;
    _tag = [_tagItems objectAtIndex:bTag];
    
    float tagWidth = _container.frame.size.width-kCaptionPadding*2;
    CGSize textSize = [[_tag objectForKey:@"tagCaption"] sizeWithFont:_tagCaption.font];
    NSUInteger numLines = ceilf( textSize.width / tagWidth );
    NSInteger height = ( textSize.height + kCaptionPadding ) * numLines;
    _tagCaption.numberOfLines = numLines;
    NSString *result;
    result = [result stringByAppendingString:[_tag objectForKey:@"tagCaption"]];
    result = [result stringByAppendingString:[_tag objectForKey:@"tagBrand"]];
    _tagCaption.text = result;

    NSInteger containerHeight = height + kCaptionPadding*2;
    _tagCaptionContainer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _tagCaptionContainer.frame = CGRectMake(0, _toolbar.frame.origin.y - 40, _container.frame.size.width, containerHeight+12);
//    _toolbar.frame                      = CGRectMake( 0, _container.frame.size.height-80, _container.frame.size.width, _container.frame.size.height );
    _tagCaption.frame = CGRectMake(kCaptionPadding+20, kCaptionPadding+5, tagWidth-80, height);
    //_tagCaption.frame = CGRectMake(25, 10, 80, 20);
    CGSize tagSize = _tagCaption.frame.size;
            
    OBShapedButton *buttonDelete = [[OBShapedButton buttonWithType:UIButtonTypeCustom] retain];
    buttonDelete.frame = CGRectMake(tagSize.width+10, kCaptionPadding+5, 60.0, 30.0);
    [buttonDelete setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonDelete setTitle:@"Delete" forState:UIControlStateNormal];
    buttonDelete.backgroundColor = [UIColor whiteColor];
    buttonDelete.layer.borderColor = [UIColor blackColor].CGColor;
    buttonDelete.layer.borderWidth = 0.5f;
    buttonDelete.layer.cornerRadius = 10.0f;
    
    [buttonDelete addTarget:self action:@selector(tappedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    buttonDelete.tag = bTag;
    [_tagCaptionContainer addSubview:buttonDelete]; //change container
    [buttonDelete release];
    
// show caption bar
    _tagCaptionContainer.hidden = NO;
    
}

- (void)tappedDeleteBtn:(id)sender{
    OBShapedButton* deleteBtn = (OBShapedButton *)sender;
    NSInteger bTag = deleteBtn.tag;
    [[_tagContainer viewWithTag:bTag] removeFromSuperview];
    [[_tagItems objectAtIndex:bTag]setValue:@"1" forKey:@"tagDeleted"];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Touches began!");
    UITouch *touch= [[event allTouches] anyObject];
    CGPoint point= [touch locationInView:touch.view];
    UIView *hitView = [self.view hitTest:point withEvent:event];
    
    if (hitView == _tagContainer) {
        TagCategoryController* nextView = [[TagCategoryController alloc]initWithNibName:@"TagCategoryController" bundle:[NSBundle mainBundle]];
        nextView.delegate = self;
        [self presentViewController:nextView animated:YES completion:nil];
        [nextView release];
    }
    NSInteger x = point.x-12;
    NSInteger y = point.y-25;

    _tag = [[NSMutableDictionary alloc] initWithObjectsAndKeys: @"0", @"tagId", @"0", @"imageId", @"Test", @"tagCaption", @"http://www.google.com", @"tagShopLink", [NSString stringWithFormat:@"%d", x], @"tagX", [NSString stringWithFormat:@"%d", y], @"tagY", @"0", @"tagId", @"testBrand", @"tagBrand", @"0", @"tagDeleted", nil];
}

#pragma mark Image Upload Code

- (IBAction)uploadImage {
	/*
	 turning the image into a NSData object
	 getting the image back out of the UIImageView
	 setting the quality to 90
     */
	NSData *imageData = UIImageJPEGRepresentation(appdt.img, 90);
	// setting up the URL to post to
	NSString *urlString = @"http://103.4.147.139/fluence3/index.php/welcome/upload";
	
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	/*
	 add some header info now
	 we always need a boundary when we post a file
	 also we need to set the content type
	 
	 You might want to generate a random boundary.. this is just the same
	 as my output from wireshark on a valid html post
     */
	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	/*
	 now lets create the body of the post
     */
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"ipodfile.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(returnString);
}

#pragma mark Image Upload Code using ASIHTTPRequest

- (IBAction)uploadImage_asi {
    
    [spinner startAnimating];
    
    //NSString *latitude = [[NSString alloc] initWithFormat:@"%f°", self.lastKnownLocation.coordinate.latitude];
    //NSString *longitude = [[NSString alloc] initWithFormat:@"%f°", self.lastKnownLocation.coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%f", self.lastKnownLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", self.lastKnownLocation.coordinate.longitude];
    tagWord=@"Tag1,Tag2";
    title = @"Test Title";
    NSLog(@" Statistics file upload finish: \"%@\"", title);
    NSMutableDictionary *datas = [[NSMutableDictionary alloc] initWithObjectsAndKeys:title, @"Title", appdt.userId, @"FbId",appdt.userGalleryId, @"UserId",latitude,@"Latitude",longitude,@"Longitude",_tagItems,@"Tags",@"0",@"WeatherId",tagWord,@"tagWord",nil];
    
    
    NSMutableDictionary *dictionnary = [NSMutableDictionary dictionary];
    [dictionnary setObject:datas forKey:@"postData"];
    NSString *jsonRequest = [dictionnary JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    	    
	NSString *strURL = @"http://103.4.147.139/fluence3/index.php/welcome/upload";
    
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]]; // Upload a file on disk
    NSString *filename1=[NSString stringWithFormat:@"ipodfile.jpg"];
    NSData *imageData1=UIImageJPEGRepresentation(appdt.img, 1.0);
    [request addData:imageData1 withFileName:filename1 andContentType:@"image/jpeg" forKey:@"ipodfile"];
    
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    [request addPostValue:datas forKey:@"postData"];
    [request setRequestMethod:@"POST"];
    //[request appendPostData:body];
    [request setDelegate:self];
    [request setTimeOutSeconds:300.0];
    //request.shouldAttemptPersistentConnection = NO;
    [request setDidFinishSelector:@selector(uploadRequestFinished:)];
    [request setDidFailSelector:@selector(uploadRequestFailed:)];
    [request startAsynchronous];
    
    
        
    
    self.navigationItem.hidesBackButton = YES;
    
}
- (void)uploadRequestFinished:(ASIHTTPRequest *)request
{
    NSLog(@" Statistics file upload finish: \"%@\"",[request responseString]);
    [spinner stopAnimating];
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request{
    NSLog(@" Error - Statistics file upload failed: \"%@\"",[[request error] localizedDescription]);
    [spinner stopAnimating];
    
}

# pragma mark LocationGetter Delegate Methods

- (void)newPhysicalLocation:(CLLocation *)location {
    
    // Store for later use
    self.lastKnownLocation = location;
    [self retrieveWeatherForLocation:self.lastKnownLocation orZipCode:nil];

    /*    
    // Alert user
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Found" message:[NSString stringWithFormat:@"Found physical location.  %f %f", self.lastKnownLocation.coordinate.latitude, self.lastKnownLocation.coordinate.longitude] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release]; */ 
}


#pragma mark - Methods for retrieving weather from Wunderground

- (void)retrieveWeatherForLocation:(CLLocation *)location orZipCode:(NSString *)zipCode
{
    NSString *urlString;
    
    // get URL for current conditions
    
    if (location)
    {
        // based upon longitude and latitude returned by CLLocationManager
        
        urlString = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%+f,%+f.json",
                     kWundergroundKey,
                     location.coordinate.latitude,
                     location.coordinate.longitude];
    }
    else if ([zipCode length] == 5)
    {
        // based upon the zip code
        
        urlString = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%@.json",
                     kWundergroundKey,
                     zipCode];
        
    }
    else
    {
        NSAssert(NO, @"You must provide a CLLocation object or five digit zip code");
    }
    
    // Log it so you can see what the URL was for diagnostic purposes.
    // It's often useful to pull this up in a web browser like FireFox
    // so you can diagnose what's going on.
    
//    [self updateStatusMessage:@"Identified location; determining weather" stopActivityIndicator:NO stopLocationServices:NO logMessage:urlString];
    
    NSURL *url          = [NSURL URLWithString:urlString];
    
    NSData *weatherData = [NSData dataWithContentsOfURL:url];
    
    // make sure we were able to get some response from the URL; if not
    // maybe your internet connection is not operational, or something
    // like that.
    
    if (weatherData == nil)
    {
        // Alert user
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Try again later" message:[NSString stringWithFormat:@"Unable to retrieve data from weather service.  %f %f", self.lastKnownLocation.coordinate.latitude, self.lastKnownLocation.coordinate.longitude] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release]; 
        //[self updateStatusMessage:@"Unable to retrieve data from weather service" stopActivityIndicator:YES stopLocationServices:YES logMessage:@"weatherData is nil"];
        return;
    }
    
    // parse the JSON results
    
    NSError *error;
    id weatherResults = [NSJSONSerialization JSONObjectWithData:weatherData options:0 error:&error];
    
    // if there was an error, report this
    
//    if(error != nil){
//        NSString *desc = [error localizedFailureReason];
//    }
    if (error == nil)
    { 
        // Alert user
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Try again later" message:[NSString stringWithFormat:@"Error parsing results from weather service.  %f %f", self.lastKnownLocation.coordinate.latitude, self.lastKnownLocation.coordinate.longitude] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        //[self updateStatusMessage:@"Error parsing results from weather service" stopActivityIndicator:YES stopLocationServices:YES logMessage:error];
        return;
    }
    
    // otherwise, let's make sure we got a NSDictionary like we expected
    
    else if (![weatherResults isKindOfClass:[NSDictionary class]])
    {
        // Alert user
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Try again later" message:[NSString stringWithFormat:@"Unexpected results from weather service.  %f %f", self.lastKnownLocation.coordinate.latitude, self.lastKnownLocation.coordinate.longitude] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        //[self updateStatusMessage:@"Unexpected results from weather service" stopActivityIndicator:YES stopLocationServices:YES logMessage:weatherResults];
        return;
    }
    NSDictionary *test = (NSDictionary *)weatherResults;
    
    // if we've gotten here, that means that we've parsed the JSON feed from Wunderground,
    // so now let's see if we got the expected response
    
    NSDictionary *response = [test objectForKey:@"response"]; //weatherResults[@"response"];
    if (response == nil || ![response isKindOfClass:[NSDictionary class]])
    {
        // Alert user
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Try again later" message:[NSString stringWithFormat:@"Error parsing results from weather service.  %f %f", self.lastKnownLocation.coordinate.latitude, self.lastKnownLocation.coordinate.longitude] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    // now, let's see if that response reported any particular error
    
    NSDictionary *errorDictionary = [response objectForKey:@"error"];//response[@"error"];
    if (errorDictionary != nil)
    {
        NSString *message = @"Error reported by weather service";
        
        if ([errorDictionary objectForKey:@"description"])//errorDictionary[@"description"])
            message = [NSString stringWithFormat:@"%@: %@", message, [errorDictionary objectForKey:@"description"]];//errorDictionary[@"description"]];
        // Alert user
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Try again later" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        //        if ([errorDictionary[@"type"] isEqualToString:@"keynotfound"])
        //        {
        //            NSLog(@"%s You must get a key for your app from http://www.wunderground.com/weather/api/", __FUNCTION__);
        //        }
        return;
    }
    
    // if no errors thus far, then we can now inspect the current_observation
    
    NSDictionary *currentObservation = [test objectForKey:@"current_observation"];//weatherResults[@"current_observation"];
    
    if (currentObservation == nil)
    {
        // if not found, let's tell the user
        NSString *message = @"No observation data found";
        // Alert user
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Try again later" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    // otherwise, let's look up the barometer information
    
    NSString *statusMessage;
    NSString *pressureMb = [currentObservation objectForKey:@"pressure_mb"];//[@"pressure_mb"];
    NSString *weather = [currentObservation objectForKey:@"weather"];//[@"pressure_mb"];
    if (pressureMb)
    {
        statusMessage = @"Retrieved barometric pressure";
        //self.pressureMbLabel.text = pressureMb;
    }
    else
    {
        statusMessage = @"No barometric information found";
    }
    
    NSNumber *tempC      = [currentObservation objectForKey:@"temp_c"];//[@"temp_c"];
    
    if (tempC)
    {
        statusMessage = @"Retrieved temperature";
//        self.tempCLabel.text = [tempC stringValue];
    }
    else
    {
        statusMessage = @"No temperature information found";
    }
    
    // update the user interface status message
    
//    [self updateStatusMessage:statusMessage stopActivityIndicator:YES stopLocationServices:YES logMessage:weatherResults];
}

-(void)handleBack
{
    //handle back
    
    CameraImageController *nCameraImage = [[[CameraImageController alloc] initWithNibName:@"CameraImageController" bundle:nil]autorelease];
    nCameraImage.title = @"Capture New";
    [self.navigationController pushViewController:nCameraImage animated:true];
    
}

- (void)handleBack1:(id)sender {
    ISViewController *nCameraImage = [[[ISViewController alloc] initWithNibName:@"ISViewController" bundle:nil]autorelease];
    nCameraImage.title = @"Fluence";
    [self.navigationController pushViewController:nCameraImage animated:true];}


@end
