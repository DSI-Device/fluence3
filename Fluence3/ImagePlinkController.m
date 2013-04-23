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
@class ASIFormDataRequest;
#define kCaptionPadding 3
#define kToolbarHeight 40

@implementation ImagePlinkController

@synthesize toolBar = _toolbar;
@synthesize _tagCategory;

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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

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
    
// setup tag
    _tagContainer.hidden				= NO;
    _tagContainer.backgroundColor       = [UIColor colorWithWhite:1.0 alpha:0.0];
    _tagContainer.frame                 = CGRectMake(0, 0, _container.frame.size.width, 320);

// setup tag Caption
    _tagCaptionContainer.hidden				= YES;
    _tagCaptionContainer.backgroundColor    = [UIColor colorWithWhite:1.0 alpha:0.0];
    _tagCaption.font								= [UIFont systemFontOfSize:14.0];
    _tagCaption.textColor							= [UIColor whiteColor];
    _tagCaption.backgroundColor					= [UIColor clearColor];
    _tagCaption.textAlignment						= UITextAlignmentCenter;
    _tagCaption.shadowColor						= [UIColor blackColor];
    _tagCaption.shadowOffset						= CGSizeMake( 1, 1 );    
// setup Image view
    _plinkImage.image = appdt.img;
    
//setup buttons
    _saveButton  = [UIButton buttonWithType:UIButtonTypeCustom];

//set the position of the button
    _saveButton.frame = CGRectMake(5, 10, 60, 40);

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
    [_cancelButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
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

    _tag = [[NSMutableDictionary alloc] initWithObjectsAndKeys: @"0", @"tagId", @"0", @"imageId", @"Test", @"tagCaption", @"http://www.google.com", @"tagShopLink", [NSString stringWithFormat:@"%d", x], @"tagX", [NSString stringWithFormat:@"%d", y], @"tagY", @"testBrand", @"tagBrand", @"0", @"tagDeleted", nil];
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
	
	NSString *strURL = @"http://103.4.147.139/fluence3/index.php/welcome/upload";
    
    //ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]]; // Upload a file on disk
    NSString *filename1=[NSString stringWithFormat:@"ipodfile.jpg"];
    NSData *imageData1=UIImageJPEGRepresentation(appdt.img, 1.0);
    [request setData:imageData1 withFileName:filename1 andContentType:@"image/jpeg" forKey:@"ipodfile"];
    [request setRequestMethod:@"POST"];
    //[request appendPostData:body];
    [request setDelegate:self];
    [request setTimeOutSeconds:3.0];
    //request.shouldAttemptPersistentConnection = NO;
    [request setDidFinishSelector:@selector(uploadRequestFinished:)];
    [request setDidFailSelector:@selector(uploadRequestFailed:)];
    [request startAsynchronous];
    
}
- (void)uploadRequestFinished:(ASIHTTPRequest *)request
{
    NSLog(@" Error - Statistics file upload finish: \"%@\"",[request responseString]);
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request{
    NSLog(@" Error - Statistics file upload failed: \"%@\"",[[request error] localizedDescription]);
    
}

@end
