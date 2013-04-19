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
    _plinkImage.frame                   = CGRectMake(0, 10, _container.frame.size.width, 278);
    
// setup tag
    _tagContainer.hidden				= NO;
    _tagContainer.backgroundColor       = [UIColor colorWithWhite:1.0 alpha:0.0];
    _tagContainer.frame                 = CGRectMake(0, 10, _container.frame.size.width, 278);

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
    _saveButton  = [UIButton buttonWithType:UIButtonTypeRoundedRect];

//set the position of the button
    _saveButton.frame = CGRectMake(5, 10, 40, 40);

//background image
//    UIImage *buttonImage = [UIImage imageNamed:@"heart-icon.png"];
    
//create the button and assign the image addSubview:button
    
//    [_saveButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_saveButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
//set the button's title
    [_saveButton setTitle:@"Save" forState:UIControlStateNormal];
//listen for clicks
    [_saveButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
//add the button to the view
    _cancelButton  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//set the position of the button
    _cancelButton.frame = CGRectMake(50, 10, 40, 40);
//background image
//    UIImage *buttonImage = [UIImage imageNamed:@"heart-icon.png"];
    
//create the button and assign the image addSubview:button
//    [_saveButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
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

//- (void)addBrandViewController:(TagBrandController *)controller didFinishEnteringBrand:(NSString *)item
//{
//    NSLog(@"This was returned from Brand Controller %@",item);    
//    [_tag setValue:item forKey:@"tagBrand"];
//    

//}

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
    _tagCaptionContainer.alpha = 0.5;
    _tag = [_tagItems objectAtIndex:bTag];
    
    float tagWidth = _container.frame.size.width-kCaptionPadding*2;
    CGSize textSize = [[_tag objectForKey:@"tagCaption"] sizeWithFont:_tagCaption.font];
    NSUInteger numLines = ceilf( textSize.width / tagWidth );
    NSInteger height = ( textSize.height + kCaptionPadding ) * numLines;
    _tagCaption.numberOfLines = numLines;
    _tagCaption.text = [_tag objectForKey:@"tagCaption"];

    NSInteger containerHeight = height + kCaptionPadding*2;
    _tagCaptionContainer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _tagCaptionContainer.frame = CGRectMake(0, _toolbar.frame.origin.y - 30, _container.frame.size.width, containerHeight);
//    _toolbar.frame                      = CGRectMake( 0, _container.frame.size.height-80, _container.frame.size.width, _container.frame.size.height );
    _tagCaption.frame = CGRectMake(kCaptionPadding, kCaptionPadding, tagWidth-80, height);
    //_tagCaption.frame = CGRectMake(25, 10, 80, 20);
    CGSize tagSize = _tagCaption.frame.size;
            
    OBShapedButton *buttonDelete = [[OBShapedButton buttonWithType:UIButtonTypeRoundedRect] retain];
    buttonDelete.frame = CGRectMake(tagSize.width-40, kCaptionPadding-7, 50.0, 35.0);
    [buttonDelete setTitle:@"Delete" forState:UIControlStateNormal];
    buttonDelete.backgroundColor = [UIColor blueColor];
    [buttonDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];

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
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"URl Selected"
                          message: [NSString stringWithFormat:@"%d", bTag]
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    [[_tagContainer viewWithTag:bTag] removeFromSuperview];
    [_tagItems removeObjectAtIndex:bTag];
    _currentIndex--;
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

    _tag = [[NSMutableDictionary alloc] initWithObjectsAndKeys: @"0", @"tagId", @"0", @"imageId", @"Test", @"tagCaption", @"http://www.google.com", @"tagShopLink", [NSString stringWithFormat:@"%d", x], @"tagX", [NSString stringWithFormat:@"%d", y], @"tagY", @"testBrand", @"tagBrand", nil];
    
    //If the hitView is THIS view, return the view that you want to receive the touch instead: NSString * tId = [NSString stringWithFormat:@"%d",tagId];
//    if (hitView == _tagContainer) {
    //return _innerContainer;
//    }
    //    Else return the hitView (as it could be one of this view's buttons):
    //    return hitView;
    //    UITouch *touch= [[event allTouches] anyObject];
    //    CGPoint point= [touch locationInView:touch.view];
    
    /*UIImage *image = [UIImage imageNamed:@"BluePin.png"];
     
     UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
     [imageView setFrame: CGRectMake(point.x-(imageView.bounds.size.width/2), point.y-(imageView.bounds.size.width/2), imageView.bounds.size.width, imageView.bounds.size.height)];
     [self.view addSubview: imageView];
     //self.currentPins += 1;
     
     [UIView animateWithDuration:2.0 delay:1.0 options:UIViewAnimationOptionCurveLinear  animations:^{
     [imageView setAlpha:0.0];
     } completion:^(BOOL finished) {
     [imageView removeFromSuperview];
     //self.currentPins -= 1;
     }];
     
     // for(;self.currentPins > 10; currentPins -= 1){
     //     [[[self subviews] objectAtIndex:0] removeFromSuperview];
     // }*/
}
/*
 // load the image
 NSString *name = @"badge.png";
 UIImage *img = [UIImage imageNamed:name];
 
 // begin a new image context, to draw our colored image onto
 UIGraphicsBeginImageContext(img.size);
 
 // get a reference to that context we created
 CGContextRef context = UIGraphicsGetCurrentContext();
 
 // set the fill color
 [color setFill];
 
 // translate/flip the graphics context (for transforming from CG* coords to UI* coords
 CGContextTranslateCTM(context, 0, img.size.height);
 CGContextScaleCTM(context, 1.0, -1.0);
 
 // set the blend mode to color burn, and the original image
 CGContextSetBlendMode(context, kCGBlendModeColorBurn);
 CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
 CGContextDrawImage(context, rect, img.CGImage);
 
 // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
 CGContextClipToMask(context, rect, img.CGImage);
 CGContextAddRect(context, rect);
 CGContextDrawPath(context,kCGPathFill);
 
 // generate a new UIImage from the graphics context we drew onto
 UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 
 //return the color-burned image
 return coloredImg;
 */


@end
