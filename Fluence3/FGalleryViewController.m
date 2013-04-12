//
//  FGalleryViewController.m
//  FGallery
//
//  Created by Grant Davis on 5/19/10.
//  Copyright 2011 Grant Davis Interactive, LLC. All rights reserved.
//Fluence

#import "FGalleryViewController.h"
#import "RemoveEventView.h"
#import "OBShapedButton.h"

#define kThumbnailSize 75
#define kThumbnailSpacing 4
#define kCaptionPadding 3
#define kToolbarHeight 40


@interface FGalleryViewController (Private)

// general
- (void)buildViews;
- (void)destroyViews;
- (void)layoutViews;
- (void)moveScrollerToCurrentIndexWithAnimation:(BOOL)animation;
- (void)updateTitle;
- (void)updateButtons;
- (void)layoutButtons;
- (void)updateScrollSize;
- (void)updateCaption;
- (void)updateTag;
- (void)updateUserInfo;
- (void)resizeImageViewsWithRect:(CGRect)rect;
- (void)resetImageViewZoomLevels;

- (void)enterFullscreen;
- (void)exitFullscreen;
- (void)enableApp;
- (void)disableApp;

- (void)positionInnerContainer;
- (void)positionScroller;
- (void)positionToolbar;
- (void)resizeThumbView;

// thumbnails
- (void)toggleThumbnailViewWithAnimation:(BOOL)animation;
- (void)showThumbnailViewWithAnimation:(BOOL)animation;
- (void)hideThumbnailViewWithAnimation:(BOOL)animation;
- (void)buildThumbsViewPhotos;

- (void)arrangeThumbs;
- (void)loadAllThumbViewPhotos;

- (void)preloadThumbnailImages;
- (void)unloadFullsizeImageWithIndex:(NSUInteger)index;

- (void)scrollingHasEnded;

- (void)handleSeeAllTouch:(id)sender;
- (void)handleThumbClick:(id)sender;

- (FGalleryPhoto*)createGalleryPhotoForIndex:(NSUInteger)index;

- (void)loadThumbnailImageWithIndex:(NSUInteger)index;
- (void)loadFullsizeImageWithIndex:(NSUInteger)index;

@end

//test

@implementation FGalleryViewController
@synthesize galleryID;
@synthesize photoSource = _photoSource;
@synthesize currentIndex = _currentIndex;
@synthesize thumbsView = _thumbsView;
@synthesize toolBar = _toolbar;
@synthesize toolBar1 = _toolbar1;
@synthesize useThumbnailView = _useThumbnailView;
@synthesize startingIndex = _startingIndex;
@synthesize beginsInThumbnailView = _beginsInThumbnailView;
@synthesize hideTitle = _hideTitle;
@synthesize currentDate;

#pragma mark - Public Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if((self = [super initWithNibName:nil bundle:nil])) {
        
		// init gallery id with our memory address
		self.galleryID						= [NSString stringWithFormat:@"%p", self];
        
        // configure view controller
		self.hidesBottomBarWhenPushed		= YES;
        
        // set defaults
        _useThumbnailView                   = YES;
		_prevStatusStyle					= [[UIApplication sharedApplication] statusBarStyle];
        _hideTitle                          = NO;
		
		// create storage objects
		_currentIndex						= 0;
        _startingIndex                      = 0;
		_photoLoaders						= [[NSMutableDictionary alloc] init];
		_photoViews							= [[NSMutableArray alloc] init];
		_photoThumbnailViews				= [[NSMutableArray alloc] init];
		_barItems							= [[NSMutableArray alloc] init];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        self.currentDate = [dateFormatter stringFromDate:[NSDate date]];
        
        [dateFormatter release];
        /*
         // debugging:
         _container.layer.borderColor = [[UIColor yellowColor] CGColor];
         _container.layer.borderWidth = 1.0;
         
         _innerContainer.layer.borderColor = [[UIColor greenColor] CGColor];
         _innerContainer.layer.borderWidth = 1.0;
         
         _tagContainer.layer.borderColor = [[UIColor blueColor] CGColor];
         _tagContainer.layer.borderWidth = 1.0;
         
         _scroller.layer.borderColor = [[UIColor redColor] CGColor];
         _scroller.layer.borderWidth = 2.0;
         */
        
	}
	return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (self != nil) {
		self.galleryID						= [NSString stringWithFormat:@"%p", self];
		
        // configure view controller
		self.hidesBottomBarWhenPushed		= YES;
        
        // set defaults
        _useThumbnailView                   = YES;
		_prevStatusStyle					= [[UIApplication sharedApplication] statusBarStyle];
        _hideTitle                          = NO;
		
		// create storage objects
		_currentIndex						= 0;
        _startingIndex                      = 0;
		_photoLoaders						= [[NSMutableDictionary alloc] init];
		_photoViews							= [[NSMutableArray alloc] init];
		_photoThumbnailViews				= [[NSMutableArray alloc] init];
		_barItems							= [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (id)initWithPhotoSource:(NSObject<FGalleryViewControllerDelegate>*)photoSrc
{
	if((self = [self initWithNibName:nil bundle:nil])) {
		_photoSource = photoSrc;
	}
	return self;
}


- (id)initWithPhotoSource:(NSObject<FGalleryViewControllerDelegate>*)photoSrc barItems:(NSArray*)items
{
	if((self = [self initWithPhotoSource:photoSrc])) {
		
		[_barItems addObjectsFromArray:items];
	}
	return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //Up-Down Gesture add to change date
    UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreenDown:)];
    swipeGestureDown.numberOfTouchesRequired = 1;
    swipeGestureDown.direction = (UISwipeGestureRecognizerDirectionDown);
    [[self view] addGestureRecognizer:swipeGestureDown];
    UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreenUp:)];
    swipeGestureUp.numberOfTouchesRequired = 1;
    swipeGestureUp.direction = (UISwipeGestureRecognizerDirectionUp);
    [[self view] addGestureRecognizer:swipeGestureUp];
    [swipeGestureDown release];
    [swipeGestureUp release];
    // Do any additional setup after loading the view from its nib.
    
}

- (void) backButtonClicked: (id) sender{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadView
{
    
    // create public objects first so they're available for custom configuration right away. positioning comes later.
    _container							= [[UIView alloc] initWithFrame:CGRectZero];
    _innerContainer						= [[UIView alloc] initWithFrame:CGRectZero];
    _scroller							= [[UIScrollView alloc] initWithFrame:CGRectZero];
    _thumbsView							= [[UIScrollView alloc] initWithFrame:CGRectZero];
    
    _toolbar1							= [[UIToolbar alloc] initWithFrame:CGRectZero];
    _toolbar							= [[UIToolbar alloc] initWithFrame:CGRectZero];
    _toolbar1							= [[UIToolbar alloc] initWithFrame:CGRectZero];
    _captionContainer					= [[UIView alloc] initWithFrame:CGRectZero];
    _caption							= [[UILabel alloc] initWithFrame:CGRectZero];
    
    _userInfoContainer					= [[UIView alloc] initWithFrame:CGRectZero];
    _userInfoCaption					= [[UILabel alloc] initWithFrame:CGRectZero];
    _userProfileImage                   = [[UIButton alloc] initWithFrame:CGRectZero];
    
    _tagContainer                       = [[RemoveEventView alloc] initWithFrame:CGRectZero];
    
    _tagCaptionContainer                = [[UIView alloc] initWithFrame:CGRectZero];
    _tag                                = [[UILabel alloc] initWithFrame:CGRectZero];
    
    _tagCaptionContainer.backgroundColor = [UIColor grayColor];
    _toolbar1.backgroundColor			= [UIColor grayColor];
    _toolbar.tintColor					= [UIColor whiteColor];
    _toolbar1.tintColor					= [UIColor whiteColor];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    _container.backgroundColor			= [UIColor whiteColor];
    
    // listen for container frame changes so we can properly update the layout during auto-rotation or going in and out of fullscreen
    [_container addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    // setup scroller
    _scroller.delegate							= self;
    _scroller.pagingEnabled						= YES;
    _scroller.showsVerticalScrollIndicator		= NO;
    _scroller.showsHorizontalScrollIndicator	= NO;
    
    // setup caption
    _captionContainer.backgroundColor			= [UIColor clearColor];
    _captionContainer.hidden					= YES;
    _captionContainer.userInteractionEnabled	= NO;
    _captionContainer.exclusiveTouch			= YES;
    _caption.font								= [UIFont systemFontOfSize:14.0];
    _caption.textColor							= [UIColor whiteColor];
    _caption.backgroundColor					= [UIColor clearColor];
    _caption.textAlignment						= UITextAlignmentCenter;
    _caption.shadowColor						= [UIColor blackColor];
    _caption.shadowOffset						= CGSizeMake( 1, 1 );

    
    // setup user Info container
    _userInfoContainer.backgroundColor			= [UIColor clearColor];
    _userInfoContainer.hidden					= YES;
    _userInfoContainer.userInteractionEnabled	= NO;
    _userInfoContainer.exclusiveTouch			= YES;
    _userInfoCaption.font						= [UIFont systemFontOfSize:14.0];
    _userInfoCaption.textColor					= [UIColor whiteColor];
    _userInfoCaption.backgroundColor			= [UIColor clearColor];
    _userInfoCaption.textAlignment				= UITextAlignmentCenter;
    _userInfoCaption.shadowColor				= [UIColor blackColor];
    _userInfoCaption.shadowOffset				= CGSizeMake( 1, 1 );
    _userProfileImage.contentMode = UIViewContentModeCenter;
    
    // setup tag
    _tagContainer.hidden					    = NO;
    _tagContainer.backgroundColor               = [UIColor colorWithWhite:1.0 alpha:0.0];
    _tagContainer.frame                         = CGRectMake(100, 114, 256, 278);
    
    _tagCaptionContainer.hidden					= NO;
    _tagCaptionContainer.backgroundColor        = [UIColor colorWithWhite:1.0 alpha:0.0];
    //_tagCaptionContainer.frame                  = CGRectMake(64, 114, 256, 278);
    
    _tag.font								    = [UIFont systemFontOfSize:14.0];
    _tag.textColor							    = [UIColor whiteColor];
    _tag.backgroundColor					    = [UIColor clearColor];
    _tag.textAlignment						    = UITextAlignmentCenter;
    _tag.shadowColor						    = [UIColor blackColor];
    _tag.shadowOffset						    = CGSizeMake( 1, 1 );
    
    // make things flexible
    _container.autoresizesSubviews				= NO;
    _innerContainer.autoresizesSubviews			= NO;
    _scroller.autoresizesSubviews				= NO;
    _container.autoresizingMask					= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // setup thumbs view
    _thumbsView.backgroundColor					= [UIColor whiteColor];
    _thumbsView.hidden							= YES;
    _thumbsView.contentInset					= UIEdgeInsetsMake( kThumbnailSpacing, kThumbnailSpacing, kThumbnailSpacing, kThumbnailSpacing);
    
    
    _likeButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    //set the position of the button
    _likeButton.frame = CGRectMake(5, 20, 40, 40);
    UIImage *buttonImage = [UIImage imageNamed:@"heart-icon.png"];
    
    //create the button and assign the image addSubview:button
    
    [_likeButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_likeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //set the button's title
    [_likeButton setTitle:@"12" forState:UIControlStateNormal];
    //listen for clicks
    [_likeButton addTarget:self action:@selector(buttonPressed)
          forControlEvents:UIControlEventTouchUpInside];
    //add the button to the view
    _shareButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    //set the position of the button
    _shareButton.frame = CGRectMake(5, 90, 40, 40);
    UIImage *buttonImage1 = [UIImage imageNamed:@"share.png"];
    
    //create the button and assign the image addSubview:button
    
    [_shareButton setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
    [_shareButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //set the button's title
    [_shareButton setTitle:@"3" forState:UIControlStateNormal];
    //listen for clicks
    [_shareButton addTarget:self action:@selector(buttonPressed)
           forControlEvents:UIControlEventTouchUpInside];
    
    _commentButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    //set the position of the button
    _commentButton.frame = CGRectMake(5, 160, 40, 40);
    UIImage *buttonImage2 = [UIImage imageNamed:@"comment.png"];
    
    //create the button and assign the image addSubview:button
    
    [_commentButton setBackgroundImage:buttonImage2 forState:UIControlStateNormal];
    [_commentButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //set the button's title
    [_commentButton setTitle:@"5" forState:UIControlStateNormal];
    //listen for clicks
    [_commentButton addTarget:self action:@selector(buttonPressed)
             forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
	// set view
	self.view = _container;
	
	// add items to their containers
	[_container addSubview:_innerContainer];
	[_container addSubview:_thumbsView];
	
	[_innerContainer addSubview:_scroller];
    [_innerContainer addSubview:_userInfoContainer];
	[_innerContainer addSubview:_toolbar];
    [_innerContainer addSubview:_toolbar1];
    [_innerContainer addSubview:_tagContainer];
    [_innerContainer addSubview:_tagCaptionContainer];
        
    [_toolbar1 addSubview:_likeButton];
    [_toolbar1 addSubview:_shareButton];
    [_toolbar1 addSubview:_commentButton];

	[_toolbar addSubview:_captionContainer];
	[_captionContainer addSubview:_caption];
    
    [_tagCaptionContainer addSubview:_tag];
	[_userInfoContainer addSubview:_userInfoCaption];
    [_userInfoContainer addSubview:_userProfileImage];
    
	// create buttons for toolbar
	UIImage *leftIcon = [UIImage imageNamed:@"photo-gallery-left.png"];
	UIImage *rightIcon = [UIImage imageNamed:@"photo-gallery-right.png"];
	_nextButton = [[UIBarButtonItem alloc] initWithImage:rightIcon style:UIBarButtonItemStylePlain target:self action:@selector(next)];
	_prevButton = [[UIBarButtonItem alloc] initWithImage:leftIcon style:UIBarButtonItemStylePlain target:self action:@selector(previous)];
	
	// add prev next to front of the array
	[_barItems insertObject:_nextButton atIndex:0];
	[_barItems insertObject:_prevButton atIndex:0];
	
	_prevNextButtonSize = leftIcon.size.width;
	
	// set buttons on the toolbar.
	//[_toolbar setItems:_barItems animated:NO];
    
    // build stuff
    [self reloadGallery];
}


- (void)viewDidUnload {
    
    [self destroyViews];
    [_shareButton release], _shareButton = nil;
    [_commentButton release], _commentButton = nil;
    [_likeButton release], _likeButton = nil;
    [_toolbar1 release], _toolbar = nil;
    [_barItems release], _barItems = nil;
    [_nextButton release], _nextButton = nil;
    [_prevButton release], _prevButton = nil;
    [_container release], _container = nil;
    [_innerContainer release], _innerContainer = nil;
    [_scroller release], _scroller = nil;
    [_thumbsView release], _thumbsView = nil;
    [_toolbar release], _toolbar = nil;
    [_tagContainer release], _tagContainer = nil;
    [_tagCaptionContainer release], _tagCaptionContainer = nil;
    [_tag release], _tag = nil;
    [_captionContainer release], _captionContainer = nil;
    [_caption release], _caption = nil;
    [_userInfoContainer release], _userInfoContainer = nil;
    [_userInfoCaption release], _userInfoCaption = nil;
    [_userProfileImage release], _userProfileImage = nil;
    
    [super viewDidUnload];
}


- (void)destroyViews {
    //removes tag
//    NSInteger t = [[_tagContainer subviews] count];
//    for (int i = 0; i < [[_tagContainer subviews] count]; i++ ) {
//        [[[_tagContainer subviews] objectAtIndex:i] removeFromSuperview];
//    }
    // remove previous photo views
    for (UIView *view in _photoViews) {
        [view removeFromSuperview];
    }
    [_photoViews removeAllObjects];
    
    // remove previous thumbnails
    for (UIView *view in _photoThumbnailViews) {
        [view removeFromSuperview];
    }
    [_photoThumbnailViews removeAllObjects];
    
    // remove photo loaders
    NSArray *photoKeys = [_photoLoaders allKeys];
    for (int i=0; i<[photoKeys count]; i++) {
        FGalleryPhoto *photoLoader = [_photoLoaders objectForKey:[photoKeys objectAtIndex:i]];
        photoLoader.delegate = nil;
        [photoLoader unloadFullsize];
        [photoLoader unloadThumbnail];
    }
    [_photoLoaders removeAllObjects];
}


- (void)reloadGallery
{
    _currentIndex = _startingIndex;
    _isThumbViewShowing = NO;
    
    // remove the old
    [self destroyViews];
    
    // build the new
    if ([_photoSource numberOfPhotosForPhotoGallery:self] > 0) {
        // create the image views for each photo
        [self buildViews];
        
        // create the thumbnail views
        [self buildThumbsViewPhotos];
        
        // start loading thumbs
        [self preloadThumbnailImages];
        
        // start on first image
        [self gotoImageByIndex:_currentIndex animated:NO];
        
        // layout
        [self layoutViews];
    }
}

- (FGalleryPhoto*)currentPhoto
{
    return [_photoLoaders objectForKey:[NSString stringWithFormat:@"%i", _currentIndex]];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
    _isActive = YES;
    
    self.useThumbnailView = _useThumbnailView;
	
    // toggle into the thumb view if we should start there
    if (_beginsInThumbnailView && _useThumbnailView) {
        [self showThumbnailViewWithAnimation:NO];
        [self loadAllThumbViewPhotos];
    }
    
	[self layoutViews];
	
	// update status bar to be see-through
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:animated];
	
	// init with next on first run.
	if( _currentIndex == -1 ) [self next];
	else [self gotoImageByIndex:_currentIndex animated:NO];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
	_isActive = NO;
    
	[[UIApplication sharedApplication] setStatusBarStyle:_prevStatusStyle animated:animated];
}


- (void)resizeImageViewsWithRect:(CGRect)rect
{
    if(!_isFullscreen)
    {
        // resize all the image views
        NSUInteger i, count = [_photoViews count];
        float dx = 0;
        for (i = 0; i < count; i++) {
            FGalleryPhotoView * photoView = [_photoViews objectAtIndex:i];
            photoView.frame = CGRectMake(dx+50, 114, rect.size.width - 50,  _scroller.frame.size.height-(kToolbarHeight + 114)  );
            dx += rect.size.width;
        }
    }
}


- (void)resetImageViewZoomLevels
{
	// resize all the image views
	NSUInteger i, count = [_photoViews count];
	for (i = 0; i < count; i++) {
		FGalleryPhotoView * photoView = [_photoViews objectAtIndex:i];
		[photoView resetZoom];
	}
}


- (void)removeImageAtIndex:(NSUInteger)index
{
	// remove the image and thumbnail at the specified index.
	FGalleryPhotoView *imgView = [_photoViews objectAtIndex:index];
 	FGalleryPhotoView *thumbView = [_photoThumbnailViews objectAtIndex:index];
	FGalleryPhoto *photo = [_photoLoaders objectForKey:[NSString stringWithFormat:@"%i",index]];
	
	[photo unloadFullsize];
	[photo unloadThumbnail];
	
	[imgView removeFromSuperview];
	[thumbView removeFromSuperview];
	
	[_photoViews removeObjectAtIndex:index];
	[_photoThumbnailViews removeObjectAtIndex:index];
	[_photoLoaders removeObjectForKey:[NSString stringWithFormat:@"%i",index]];
	
	[self layoutViews];
	[self updateButtons];
    [self updateTitle];
}


- (void)next
{
	NSUInteger numberOfPhotos = [_photoSource numberOfPhotosForPhotoGallery:self];
	NSUInteger nextIndex = _currentIndex+1;
	
	// don't continue if we're out of images.
	if( nextIndex <= numberOfPhotos )
	{
		[self gotoImageByIndex:nextIndex animated:NO];
	}
}



- (void)previous
{
	NSUInteger prevIndex = _currentIndex-1;
	[self gotoImageByIndex:prevIndex animated:NO];
}



- (void)gotoImageByIndex:(NSUInteger)index animated:(BOOL)animated
{
	NSUInteger numPhotos = [_photoSource numberOfPhotosForPhotoGallery:self];
	
	// constrain index within our limits
    if( index >= numPhotos ) index = numPhotos - 1;
	
	
	if( numPhotos == 0 ) {
		
		// no photos!
		_currentIndex = -1;
	}
	else {
		
		// clear the fullsize image in the old photo
		[self unloadFullsizeImageWithIndex:_currentIndex];
		
		_currentIndex = index;
		[self moveScrollerToCurrentIndexWithAnimation:animated];
		[self updateTitle];
		
		if( !animated )	{
			[self preloadThumbnailImages];
			[self loadFullsizeImageWithIndex:index];
		}
	}
	[self updateButtons];
	[self updateCaption];
    [self updateUserInfo];
    [self updateTag];
}


- (void)layoutViews
{
	[self positionInnerContainer];
	[self positionScroller];
	[self resizeThumbView];
	[self positionToolbar];
	[self updateScrollSize];
	[self updateCaption];
    [self updateTag];
    [self updateUserInfo];
	[self resizeImageViewsWithRect:_scroller.frame];
	[self layoutButtons];
	[self arrangeThumbs];
	[self moveScrollerToCurrentIndexWithAnimation:NO];
}


- (void)setUseThumbnailView:(BOOL)useThumbnailView
{
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Back", @"") style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    [newBackButton release];
    
    _useThumbnailView = useThumbnailView;
    if( self.navigationController ) {
        
    }
}



#pragma mark - Private Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if([keyPath isEqualToString:@"frame"])
	{
		[self layoutViews];
	}
}


- (void)positionInnerContainer
{
	CGRect screenFrame = [[UIScreen mainScreen] bounds];
	CGRect innerContainerRect;
	
	if( self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown )
	{//portrait
		innerContainerRect = CGRectMake( 0, _container.frame.size.height - screenFrame.size.height, _container.frame.size.width, screenFrame.size.height );
	}
	else
	{// landscape
		innerContainerRect = CGRectMake( 0, _container.frame.size.height - screenFrame.size.width, _container.frame.size.width, screenFrame.size.width );
	}
	
	_innerContainer.frame = innerContainerRect;
}


- (void)positionScroller
{
	CGRect screenFrame = [[UIScreen mainScreen] bounds];
	CGRect scrollerRect;
	
	if( self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown )
	{//portrait
		scrollerRect = CGRectMake( 0, 0, screenFrame.size.width, screenFrame.size.height );
	}
	else
	{//landscape
		scrollerRect = CGRectMake( 0, 0, screenFrame.size.height, screenFrame.size.width );
	}
	
	_scroller.frame = scrollerRect;
}


- (void)positionToolbar
{
    _toolbar1.frame = CGRectMake( 0, 114, 50, _scroller.frame.size.height-(kToolbarHeight + 114) );
    _toolbar.frame = CGRectMake( 0, _scroller.frame.size.height-kToolbarHeight, _scroller.frame.size.width, kToolbarHeight );
    CALayer *rightBorder = [CALayer layer];
    
    rightBorder.frame = CGRectMake(49, 0, 2.0, _scroller.frame.size.height-(kToolbarHeight + 114));
    
    rightBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                    alpha:1.0f].CGColor;
    
    [_toolbar1.layer addSublayer:rightBorder];
    
}


- (void)resizeThumbView
{
    int barHeight = 0;
    if (self.navigationController.navigationBar.barStyle == UIBarStyleBlackTranslucent) {
        barHeight = self.navigationController.navigationBar.frame.size.height;
    }
	_thumbsView.frame = CGRectMake( 0, barHeight, _container.frame.size.width, _container.frame.size.height-barHeight );
}


- (void)enterFullscreen
{
    if (!_isThumbViewShowing)
    {
        _isFullscreen = YES;
        [self disableApp];
        UIApplication* application = [UIApplication sharedApplication];
        
        if ([application respondsToSelector: @selector(setStatusBarHidden:withAnimation:)]) {
            [[UIApplication sharedApplication] setStatusBarHidden: YES withAnimation: UIStatusBarAnimationFade]; // 3.2+
        } else {
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
            [[UIApplication sharedApplication] setStatusBarHidden: YES animated:YES]; // 2.0 - 3.2
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
        }
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [UIView beginAnimations:@"galleryOut" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(enableApp)];
        _toolbar.alpha = 0.0;
        _toolbar1.alpha = 0.0;
        _captionContainer.alpha = 0.0;
        _tagContainer.alpha = 0.0;
        _tagCaptionContainer.alpha = 0.0;
        _userInfoContainer.alpha = 0.0;
        [UIView commitAnimations];
        
        CGRect rect = _scroller.frame;
        NSUInteger i, count = [_photoViews count];
        float dx = 0;
        for (i = 0; i < count; i++)
        {
            FGalleryPhotoView * photoView = [_photoViews objectAtIndex:i];
            photoView.frame = CGRectMake(dx, 0, rect.size.width, rect.size.height );
            dx += rect.size.width;
        }
    }
}


- (void)exitFullscreen
{
	_isFullscreen = NO;
    
	[self disableApp];
    
	UIApplication* application = [UIApplication sharedApplication];
	if ([application respondsToSelector: @selector(setStatusBarHidden:withAnimation:)]) {
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade]; // 3.2+
	} else {
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
		[[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO]; // 2.0 - 3.2
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
	}
    
	[self.navigationController setNavigationBarHidden:NO animated:YES];
    
	[UIView beginAnimations:@"galleryIn" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(enableApp)];
	_toolbar.alpha = 1.0;
    _toolbar1.alpha = 1.0;
	_captionContainer.alpha = 1.0;
    _tagContainer.alpha = 1.0;
	_userInfoContainer.alpha = 1.0;
    [UIView commitAnimations];
}



- (void)enableApp
{
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}


- (void)disableApp
{
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}


- (void)didTapPhotoView:(FGalleryPhotoView*)photoView
{
	// don't change when scrolling
	if( _isScrolling || !_isActive ) return;
	
	// toggle fullscreen.
	if( _isFullscreen == NO ) {
		
		[self enterFullscreen];
	}
	else {
		[self exitFullscreen];
	}
    
}


- (void)updateCaption
{
	if([_photoSource numberOfPhotosForPhotoGallery:self] > 0 )
	{
		if([_photoSource respondsToSelector:@selector(photoGallery:captionForPhotoAtIndex:)])
		{
			NSString *caption = [_photoSource photoGallery:self captionForPhotoAtIndex:_currentIndex];
			if([caption length] > 0 )
			{
				float captionWidth = _container.frame.size.width-kCaptionPadding*2;
				CGSize textSize = [caption sizeWithFont:_caption.font];
				NSUInteger numLines = ceilf( textSize.width / captionWidth );
				NSInteger height = ( textSize.height + kCaptionPadding ) * numLines;
				_caption.numberOfLines = numLines;
				_caption.text = caption;
				NSInteger containerHeight = height+kCaptionPadding*2;
				_captionContainer.frame = CGRectMake(0, containerHeight-20, _container.frame.size.width, containerHeight );
				_caption.frame = CGRectMake(kCaptionPadding, kCaptionPadding, captionWidth, height );
				// show caption bar
				_captionContainer.hidden = NO;
			}
			else {
				// hide it if we don't have a caption.
				_captionContainer.hidden = YES;
			}
		}
	}
}


- (void)updateScrollSize
{
	float contentWidth = _scroller.frame.size.width * [_photoSource numberOfPhotosForPhotoGallery:self];
	[_scroller setContentSize:CGSizeMake(contentWidth, _scroller.frame.size.height)];
}


- (void)updateTitle
{
    if (!_hideTitle){
        [self setTitle:@"Fluence"];
    }else{
        [self setTitle:@""];
    }
}


- (void)updateButtons
{
	_prevButton.enabled = ( _currentIndex <= 0 ) ? NO : YES;
	_nextButton.enabled = ( _currentIndex >= [_photoSource numberOfPhotosForPhotoGallery:self]-1 ) ? NO : YES;
}


- (void)layoutButtons
{
	NSUInteger buttonWidth = roundf( _toolbar.frame.size.width / [_barItems count] - _prevNextButtonSize * .5);
	
	// loop through all the button items and give them the same width
	NSUInteger i, count = [_barItems count];
	for (i = 0; i < count; i++) {
		UIBarButtonItem *btn = [_barItems objectAtIndex:i];
		btn.width = buttonWidth;
	}
	[_toolbar setNeedsLayout];
}


- (void)moveScrollerToCurrentIndexWithAnimation:(BOOL)animation
{
	int xp = _scroller.frame.size.width * _currentIndex;
	[_scroller scrollRectToVisible:CGRectMake(xp, 0, _scroller.frame.size.width, _scroller.frame.size.height) animated:animation];
	_isScrolling = animation;
}


// creates all the image views for this gallery
- (void)buildViews
{
	NSUInteger i, count = [_photoSource numberOfPhotosForPhotoGallery:self];
	for (i = 0; i < count; i++) {
		FGalleryPhotoView *photoView = [[FGalleryPhotoView alloc] initWithFrame:CGRectZero];
		photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		photoView.autoresizesSubviews = YES;
		photoView.photoDelegate = self;
		[_scroller addSubview:photoView];
		[_photoViews addObject:photoView];
		[photoView release];
	}
}


- (void)buildThumbsViewPhotos
{
	NSUInteger i, count = [_photoSource numberOfPhotosForPhotoGallery:self];
	for (i = 0; i < count; i++) {
		FGalleryPhotoView *thumbView = [[FGalleryPhotoView alloc] initWithFrame:CGRectZero target:self action:@selector(handleThumbClick:)];
		[thumbView setContentMode:UIViewContentModeScaleAspectFill];
		[thumbView setClipsToBounds:YES];
		[thumbView setTag:i];
		[_thumbsView addSubview:thumbView];
		[_photoThumbnailViews addObject:thumbView];
		[thumbView release];
	}
}

- (void)arrangeThumbs
{
	float dx = 0.0;
	float dy = 0.0;
	// loop through all thumbs to size and place them
	NSUInteger i, count = [_photoThumbnailViews count];
	for (i = 0; i < count; i++) {
		FGalleryPhotoView *thumbView = [_photoThumbnailViews objectAtIndex:i];
		[thumbView setBackgroundColor:[UIColor grayColor]];
		
		// create new frame
		thumbView.frame = CGRectMake( dx, dy, kThumbnailSize, kThumbnailSize);
		
		// increment position
		dx += kThumbnailSize + kThumbnailSpacing;
		
		// check if we need to move to a different row
		if( dx + kThumbnailSize + kThumbnailSpacing > _thumbsView.frame.size.width - kThumbnailSpacing )
		{
			dx = 0.0;
			dy += kThumbnailSize + kThumbnailSpacing;
		}
	}
	
	// set the content size of the thumb scroller
	[_thumbsView setContentSize:CGSizeMake( _thumbsView.frame.size.width - ( kThumbnailSpacing*2 ), dy + kThumbnailSize + kThumbnailSpacing )];
}


- (void)toggleThumbnailViewWithAnimation:(BOOL)animation
{
    if (_isThumbViewShowing) {
        [self hideThumbnailViewWithAnimation:animation];
    }
    else {
        [self showThumbnailViewWithAnimation:animation];
    }
}


- (void)showThumbnailViewWithAnimation:(BOOL)animation
{
    _isThumbViewShowing = YES;
    
    [self arrangeThumbs];
    [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"Close", @"")];
    
    if (animation) {
        // do curl animation
        [UIView beginAnimations:@"uncurl" context:nil];
        [UIView setAnimationDuration:.666];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_thumbsView cache:YES];
        [_thumbsView setHidden:NO];
        [UIView commitAnimations];
    }
    else {
        [_thumbsView setHidden:NO];
    }
}


- (void)hideThumbnailViewWithAnimation:(BOOL)animation
{
    _isThumbViewShowing = NO;
    [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"See all", @"")];
    
    if (animation) {
        // do curl animation
        [UIView beginAnimations:@"curl" context:nil];
        [UIView setAnimationDuration:.666];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:_thumbsView cache:YES];
        [_thumbsView setHidden:YES];
        [UIView commitAnimations];
    }
    else {
        [_thumbsView setHidden:NO];
    }
}


- (void)handleSeeAllTouch:(id)sender
{
	// show thumb view
	[self toggleThumbnailViewWithAnimation:YES];
	
	// tell thumbs that havent loaded to load
	[self loadAllThumbViewPhotos];
}


- (void)handleThumbClick:(id)sender
{
	FGalleryPhotoView *photoView = (FGalleryPhotoView*)[(UIButton*)sender superview];
	[self hideThumbnailViewWithAnimation:YES];
	[self gotoImageByIndex:photoView.tag animated:NO];
}


#pragma mark - Image Loading


- (void)preloadThumbnailImages
{
	NSUInteger index = _currentIndex;
	NSUInteger count = [_photoViews count];
    
	// make sure the images surrounding the current index have thumbs loading
	NSUInteger nextIndex = index + 1;
	NSUInteger prevIndex = index - 1;
	
	// the preload count indicates how many images surrounding the current photo will get preloaded.
	// a value of 2 at maximum would preload 4 images, 2 in front of and two behind the current image.
	NSUInteger preloadCount = 1;
	
	FGalleryPhoto *photo;
	
	// check to see if the current image thumb has been loaded
	photo = [_photoLoaders objectForKey:[NSString stringWithFormat:@"%i", index]];
	
	if( !photo )
	{
		[self loadThumbnailImageWithIndex:index];
		photo = [_photoLoaders objectForKey:[NSString stringWithFormat:@"%i", index]];
	}
	
	if( !photo.hasThumbLoaded && !photo.isThumbLoading )
	{
		[photo loadThumbnail];
	}
	
	NSUInteger curIndex = prevIndex;
	while( curIndex > -1 && curIndex > prevIndex - preloadCount )
	{
		photo = [_photoLoaders objectForKey:[NSString stringWithFormat:@"%i", curIndex]];
		
		if( !photo ) {
			[self loadThumbnailImageWithIndex:curIndex];
			photo = [_photoLoaders objectForKey:[NSString stringWithFormat:@"%i", curIndex]];
		}
		
		if( !photo.hasThumbLoaded && !photo.isThumbLoading )
		{
			[photo loadThumbnail];
		}
		
		curIndex--;
	}
	
	curIndex = nextIndex;
	while( curIndex < count && curIndex < nextIndex + preloadCount )
	{
		photo = [_photoLoaders objectForKey:[NSString stringWithFormat:@"%i", curIndex]];
		
		if( !photo ) {
			[self loadThumbnailImageWithIndex:curIndex];
			photo = [_photoLoaders objectForKey:[NSString stringWithFormat:@"%i", curIndex]];
		}
		
		if( !photo.hasThumbLoaded && !photo.isThumbLoading )
		{
			[photo loadThumbnail];
		}
		
		curIndex++;
	}
}


- (void)loadAllThumbViewPhotos
{
	NSUInteger i, count = [_photoSource numberOfPhotosForPhotoGallery:self];
	for (i=0; i < count; i++) {
		
		[self loadThumbnailImageWithIndex:i];
	}
}


- (void)loadThumbnailImageWithIndex:(NSUInteger)index
{
	FGalleryPhoto *photo = [_photoLoaders objectForKey:[NSString stringWithFormat:@"%i", index]];
	
	if( photo == nil )
		photo = [self createGalleryPhotoForIndex:index];
	
	[photo loadThumbnail];
}


- (void)loadFullsizeImageWithIndex:(NSUInteger)index
{
	FGalleryPhoto *photo = [_photoLoaders objectForKey:[NSString stringWithFormat:@"%i", index]];
	
	if( photo == nil )
		photo = [self createGalleryPhotoForIndex:index];
	
	[photo loadFullsize];
}


- (void)unloadFullsizeImageWithIndex:(NSUInteger)index
{
	if (index < [_photoViews count]) {
		FGalleryPhoto *loader = [_photoLoaders objectForKey:[NSString stringWithFormat:@"%i", index]];
		[loader unloadFullsize];
		
		FGalleryPhotoView *photoView = [_photoViews objectAtIndex:index];
		photoView.imageView.image = loader.thumbnail;
	}
}


- (FGalleryPhoto*)createGalleryPhotoForIndex:(NSUInteger)index
{
	FGalleryPhotoSourceType sourceType = [_photoSource photoGallery:self sourceTypeForPhotoAtIndex:index];
	FGalleryPhoto *photo;
	NSString *thumbPath;
	NSString *fullsizePath;
	
	if( sourceType == FGalleryPhotoSourceTypeLocal )
	{
		thumbPath = [_photoSource photoGallery:self filePathForPhotoSize:FGalleryPhotoSizeThumbnail atIndex:index];
		fullsizePath = [_photoSource photoGallery:self filePathForPhotoSize:FGalleryPhotoSizeFullsize atIndex:index];
		photo = [[[FGalleryPhoto alloc] initWithThumbnailPath:thumbPath fullsizePath:fullsizePath delegate:self] autorelease];
	}
	else if( sourceType == FGalleryPhotoSourceTypeNetwork )
	{
		thumbPath = [_photoSource photoGallery:self urlForPhotoSize:FGalleryPhotoSizeThumbnail atIndex:index];
		fullsizePath = [_photoSource photoGallery:self urlForPhotoSize:FGalleryPhotoSizeFullsize atIndex:index];
		photo = [[[FGalleryPhoto alloc] initWithThumbnailUrl:thumbPath fullsizeUrl:fullsizePath delegate:self] autorelease];
	}
	else
	{
		// invalid source type, throw an error.
		[NSException raise:@"Invalid photo source type" format:@"The specified source type of %d is invalid", sourceType];
	}
    
	// assign the photo index
	photo.tag = index;
	
	// store it
	[_photoLoaders setObject:photo forKey: [NSString stringWithFormat:@"%i", index]];
	
	return photo;
}


- (void)scrollingHasEnded {
	
	_isScrolling = NO;
	
	NSUInteger newIndex = floor( _scroller.contentOffset.x / _scroller.frame.size.width );
	
	// don't proceed if the user has been scrolling, but didn't really go anywhere.
	if( newIndex == _currentIndex )
		return;
	
	// clear previous
	[self unloadFullsizeImageWithIndex:_currentIndex];
	
	_currentIndex = newIndex;
	[self updateCaption];
    [self updateUserInfo];
    [self updateTag];
	[self updateTitle];
	[self updateButtons];
	[self loadFullsizeImageWithIndex:_currentIndex];
	[self preloadThumbnailImages];
    if(_isFullscreen)
    {
        
    }
    else
    {
        
        _toolbar1.alpha = 1.0;
    }
}


#pragma mark - FGalleryPhoto Delegate Methods


- (void)galleryPhoto:(FGalleryPhoto*)photo willLoadThumbnailFromPath:(NSString*)path
{
	// show activity indicator for large photo view
	FGalleryPhotoView *photoView = [_photoViews objectAtIndex:photo.tag];
	[photoView.activity startAnimating];
	
	// show activity indicator for thumbail
	if( _isThumbViewShowing ) {
		FGalleryPhotoView *thumb = [_photoThumbnailViews objectAtIndex:photo.tag];
		[thumb.activity startAnimating];
	}
}


- (void)galleryPhoto:(FGalleryPhoto*)photo willLoadThumbnailFromUrl:(NSString*)url
{
	// show activity indicator for large photo view
	FGalleryPhotoView *photoView = [_photoViews objectAtIndex:photo.tag];
	[photoView.activity startAnimating];
	
	// show activity indicator for thumbail
	if( _isThumbViewShowing ) {
		FGalleryPhotoView *thumb = [_photoThumbnailViews objectAtIndex:photo.tag];
		[thumb.activity startAnimating];
	}
}


- (void)galleryPhoto:(FGalleryPhoto*)photo didLoadThumbnail:(UIImage*)image
{
	// grab the associated image view
	FGalleryPhotoView *photoView = [_photoViews objectAtIndex:photo.tag];
	
	// if the gallery photo hasn't loaded the fullsize yet, set the thumbnail as its image.
	if( !photo.hasFullsizeLoaded )
		photoView.imageView.image = photo.thumbnail;
    
	[photoView.activity stopAnimating];
	
	// grab the thumbail view and set its image
	FGalleryPhotoView *thumbView = [_photoThumbnailViews objectAtIndex:photo.tag];
	thumbView.imageView.image = image;
	[thumbView.activity stopAnimating];
}



- (void)galleryPhoto:(FGalleryPhoto*)photo didLoadFullsize:(UIImage*)image
{
	// only set the fullsize image if we're currently on that image
	if( _currentIndex == photo.tag )
	{
		FGalleryPhotoView *photoView = [_photoViews objectAtIndex:photo.tag];
		photoView.imageView.image = photo.fullsize;
	}
	// otherwise, we don't need to keep this image around
	else [photo unloadFullsize];
}


#pragma mark - UIScrollView Methods


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	_isScrolling = YES;
    _toolbar1.alpha = 0.0;
    _tagContainer.alpha = 0.0;
    _tagCaptionContainer.alpha = 0.0;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if( !decelerate )
	{
		[self scrollingHasEnded];
	}
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self scrollingHasEnded];
    if( _isFullscreen == NO )
    {
        _toolbar1.alpha = 1.0;
        _tagContainer.alpha = 1.0;
        
    }
}


#pragma mark - Memory Management Methods

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
	
	NSLog(@"[FGalleryViewController] didReceiveMemoryWarning! clearing out cached images...");
	// unload fullsize and thumbnail images for all our images except at the current index.
	NSArray *keys = [_photoLoaders allKeys];
	NSUInteger i, count = [keys count];
    if (_isThumbViewShowing==YES) {
        for (i = 0; i < count; i++)
        {
            FGalleryPhoto *photo = [_photoLoaders objectForKey:[keys objectAtIndex:i]];
            [photo unloadFullsize];
            
            // unload main image thumb
            FGalleryPhotoView *photoView = [_photoViews objectAtIndex:i];
            photoView.imageView.image = nil;
        }
    } else {
        for (i = 0; i < count; i++)
        {
            if( i != _currentIndex )
            {
                FGalleryPhoto *photo = [_photoLoaders objectForKey:[keys objectAtIndex:i]];
                [photo unloadFullsize];
                [photo unloadThumbnail];
                
                // unload main image thumb
                FGalleryPhotoView *photoView = [_photoViews objectAtIndex:i];
                photoView.imageView.image = nil;
                
                // unload thumb tile
                photoView = [_photoThumbnailViews objectAtIndex:i];
                photoView.imageView.image = nil;
            }
        }
    }
}


- (void)dealloc {
	
	// remove KVO listener
	[_container removeObserver:self forKeyPath:@"frame"];
	
	// Cancel all photo loaders in progress
	NSArray *keys = [_photoLoaders allKeys];
	NSUInteger i, count = [keys count];
	for (i = 0; i < count; i++) {
		FGalleryPhoto *photo = [_photoLoaders objectForKey:[keys objectAtIndex:i]];
		photo.delegate = nil;
		[photo unloadThumbnail];
		[photo unloadFullsize];
	}
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	self.galleryID = nil;
	
	_photoSource = nil;
    
    [_tag release];
    _tag = nil;
	
    [_tagContainer release];
    _tagContainer = nil;
   	
    [_caption release];
    _caption = nil;
	
    [_captionContainer release];
    _captionContainer = nil;

    [_userInfoContainer release];
    _userInfoContainer = nil;

    [_userInfoCaption release];
    _userInfoCaption = nil;
    
    [_userProfileImage release];
    _userProfileImage = nil;
    
    [_container release];
    _container = nil;
	
    [_innerContainer release];
    _innerContainer = nil;
	
    [_toolbar release];
    _toolbar = nil;
    
    [_toolbar1 release];
    _toolbar1 = nil;
	
    [_thumbsView release];
    _thumbsView = nil;
	
    [_scroller release];
    _scroller = nil;
	
	[_photoLoaders removeAllObjects];
    [_photoLoaders release];
    _photoLoaders = nil;
	
	[_barItems removeAllObjects];
	[_barItems release];
	_barItems = nil;
	
	[_photoThumbnailViews removeAllObjects];
    [_photoThumbnailViews release];
    _photoThumbnailViews = nil;
	
	[_photoViews removeAllObjects];
    [_photoViews release];
    _photoViews = nil;
	
    [_nextButton release];
    _nextButton = nil;
	
    [_prevButton release];
    _prevButton = nil;
    
    [_likeButton release];
    _likeButton = nil;
    
    [_shareButton release];
    _shareButton = nil;
	
    [_commentButton release];
    _commentButton = nil;
	
    [super dealloc];
}

#pragma mark - User Info Related

- (void)updateUserInfo
{
	if([_photoSource numberOfPhotosForPhotoGallery:self] > 0 )
	{
		if([_photoSource respondsToSelector:@selector(photoGallery:infoForPhotoAtIndex:)])
		{
			NSDictionary *imageInfo = [_photoSource photoGallery:self infoForPhotoAtIndex:_currentIndex];
			
//            NSString* userId   = [NSString stringWithFormat:[imageInfo objectForKey:@"userId"]];
            NSString* userName = [NSString stringWithFormat:[imageInfo objectForKey:@"userName"]];
            NSString* userPic  = [NSString stringWithFormat:[imageInfo objectForKey:@"userPic"]];
            
            _userInfoCaption.text = userName;
            
            dispatch_queue_t downloader = dispatch_queue_create("PicDownloader", NULL);
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:userPic]];
            dispatch_async(downloader, ^{
                NSData *data = [NSData dataWithContentsOfURL:url];
                [_userProfileImage setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
            });
            //enable caching loose-end
/*          FGalleryPhoto *photoProfile;
            NSString *thumbPath;
            NSString *fullsizePath;
            
            thumbPath = userPic;
            fullsizePath = userPic;
            photoProfile = [[[FGalleryPhoto alloc] initWithThumbnailUrl:thumbPath fullsizeUrl:fullsizePath delegate:self] autorelease];
            [photoProfile loadThumbnail];

            [_userProfileImage setBackgroundImage:photoProfile.fullsize forState:UIControlStateNormal];
//            photoView.imageView.image = photo.fullsize;
            [photoProfile release];*/
            
            if([userName length] > 0 )
			{
				float captionWidth = _container.frame.size.width-kCaptionPadding*2-_userProfileImage.frame.size.width;
				CGSize textSize = [userName sizeWithFont:_userInfoCaption.font];
				NSUInteger numLines = ceilf( textSize.width / captionWidth );
//				NSInteger height = ( textSize.height + kCaptionPadding ) * numLines;
				_userInfoCaption.numberOfLines = numLines;
				_userInfoCaption.text = userName;
//				NSInteger containerHeight = height+kCaptionPadding*2;
//				_userInfoContainer.frame = CGRectMake(0, containerHeight-20, _container.frame.size.width, containerHeight );
                _userInfoContainer.frame = CGRectMake(0, 64, _container.frame.size.width, 50 );

				_userInfoCaption.frame = CGRectMake(_userProfileImage.frame.size.width+kCaptionPadding, kCaptionPadding, captionWidth, 42 );
                _userProfileImage.frame = CGRectMake(kCaptionPadding, kCaptionPadding, 45, 45);
                
				// show caption bar
				_userInfoContainer.hidden = NO;
                
                CALayer *rightBorder = [CALayer layer];
                
                rightBorder.frame = CGRectMake(0, 113, _container.frame.size.width, 2.0);
                
                rightBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                                alpha:1.0f].CGColor;
                
                [_innerContainer.layer addSublayer:rightBorder];
			}
			else {
				// hide it if we don't have a caption.
				_userInfoContainer.hidden = YES;
			}
		}
	}
}

#pragma mark - Tagging Related

- (void)updateTag
{
 	if([_photoSource numberOfPhotosForPhotoGallery:self] > 0 )
	{
		if([_photoSource respondsToSelector:@selector(photoGallery:tagsForPhotoAtIndex:)])
		{
            //removes tag
//            NSInteger t = [[_tagContainer subviews] count];
            //for (int i = 0; i < [[_tagContainer subviews] count]; i++ ) {
                //[[[_tagContainer subviews] objectAtIndex:i] removeFromSuperview];
            for (OBShapedButton *btn in _tagContainer.subviews){     
//                UIView *test = [[_tagContainer subviews] objectAtIndex:i];
                [btn removeFromSuperview];
                
            }

            NSMutableArray *tag = [_photoSource photoGallery:self tagsForPhotoAtIndex:_currentIndex];
            NSInteger tagCount = [tag count];
            if(tagCount > 0 )
			{
                for (int i = 0; i < tagCount; i++) {
                    id row = [tag objectAtIndex:i];
                    //for(id key in row) {
                    NSString* tagId = [NSString stringWithFormat:[row objectForKey:@"tagId"]];
                    NSString* tagCaption = [NSString stringWithFormat:[row objectForKey:@"tagCaption"]];
                    NSString* tagX = [NSString stringWithFormat:[row objectForKey:@"tagX"]];
                    NSString* tagY = [NSString stringWithFormat:[row objectForKey:@"tagY"]];
                    [self addMyButton:[tagId integerValue]:tagCaption:_tagContainer:[tagX integerValue]:[tagY integerValue]];
                    //}
                }
            }
			else {
				// hide it if we don't have a tag.
				_tagContainer.hidden = YES;
			}
		}
	}
}

- (void)addMyButton:(NSInteger)index:(NSString*)caption:(UIView*)container:(NSInteger)xc:(NSInteger)yc{    // Method for creating button, with background image and other properties
    OBShapedButton *button = [[OBShapedButton buttonWithType:UIButtonTypeCustom] retain];
    button.frame = CGRectMake(xc, yc, 25.0, 25.0);
    [button setTitle:caption forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    UIImage *buttonImageNormal = [UIImage imageNamed:@"button-normal.png"];
    UIImage *strechableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    
    [button setImage:strechableButtonImageNormal forState:UIControlStateNormal];
    UIImage *buttonImagePressed = [UIImage imageNamed:@"button-highlighted.png"];
    UIImage *strechableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    
    [button setImage:strechableButtonImagePressed forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(tappedBtn:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = index;
    [_tagContainer addSubview:button];
    [button release];
}

- (void)tappedBtn:(id)sender
{
    OBShapedButton *button = (OBShapedButton *)sender;
    int bTag = button.tag;
    _tagCaptionContainer.alpha = 1.0;
    NSDictionary *tag = [_photoSource photoGallery:self tagsForPhotoAtId:bTag:_currentIndex];
    
    if(tag != Nil){
        float tagWidth = _container.frame.size.width-kCaptionPadding*2;
        CGSize textSize = [[tag objectForKey:@"tagCaption"] sizeWithFont:_tag.font];
        NSUInteger numLines = ceilf( textSize.width / tagWidth );
        NSInteger height = ( textSize.height + kCaptionPadding ) * numLines;
        _tag.numberOfLines = numLines;
        _tag.text = [tag objectForKey:@"tagCaption"];
        
//        CGSize conSize = _container.frame.size;
//        CGPoint conCord = _container.frame.origin;
//        CGSize inConSize = _innerContainer.frame.size;
//        CGPoint inConCord = _innerContainer.frame.origin;
//        CGSize toolSize = _toolbar.frame.size;
//        CGPoint toolCord = _toolbar.frame.origin;
//        CGSize capSize = _captionContainer.frame.size;
//        CGPoint capCord = _captionContainer.frame.origin;
        NSInteger containerHeight = height + kCaptionPadding*2;
        //NSInteger containerY = toolCord.y - 27 - capSize.height;
        _tagCaptionContainer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _tagCaptionContainer.frame = CGRectMake(50, _scroller.frame.size.height-(kToolbarHeight+27), _container.frame.size.width-50, containerHeight);
        _tag.frame = CGRectMake(kCaptionPadding-25, kCaptionPadding, tagWidth-80, height);
        
        NSString* shopUrl = [tag objectForKey:@"tagShopLink"];
        if(shopUrl != nil && shopUrl != @""){
            CGSize tagSize = _tag.frame.size;
            
            OBShapedButton *buttonShop = [[OBShapedButton buttonWithType:UIButtonTypeCustom] retain];
            buttonShop.frame = CGRectMake(tagSize.width-40, kCaptionPadding-7, 35.0, 35.0);
            //            buttonShop.frame = CGRectMake(10, 20, 30.0, 30.0); //change location
            
            [buttonShop setTitle:@"Shop" forState:UIControlStateNormal];
            buttonShop.backgroundColor = [UIColor clearColor];
            [buttonShop setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
            UIImage *buttonImageNormal = [UIImage imageNamed:@"shop.png"];
            UIImage *strechableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
            [buttonShop setImage:strechableButtonImageNormal forState:UIControlStateNormal];
            UIImage *buttonImagePressed = [UIImage imageNamed:@"shop.png"];
            UIImage *strechableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
            [buttonShop setImage:strechableButtonImagePressed forState:UIControlStateHighlighted];
            [buttonShop addTarget:self action:@selector(tappedShopBtn:) forControlEvents:UIControlEventTouchUpInside];
            buttonShop.stringId = shopUrl;
            [_tagCaptionContainer addSubview:buttonShop]; //change container
            [buttonShop release];
        }
        // show caption bar
        _tagCaptionContainer.hidden = NO;
    }
}

- (void)tappedShopBtn:(id)sender{
    OBShapedButton* shopBtn = (OBShapedButton *)sender;
    NSString* url = shopBtn.stringId;
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"URl Selected"
                          message: [NSString stringWithFormat:url]
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark Date-Related Operation

- (void) swipedScreenDown:(UISwipeGestureRecognizer*)swipeGesture {
    //[utils showAlert:@"Warning !!" message:@"Activation Failed !! Please try again with correct credential." delegate:self];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromStr = [dateFormatter dateFromString:self.currentDate];    
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar] autorelease];
    NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
    components.day = 1;
    NSDate *newDate = [calendar dateByAddingComponents: components toDate: dateFromStr options: 0];
    
    [_photoSource photoGallery:self handleChangeDate:[dateFormatter stringFromDate:newDate]];
    [dateFormatter release];

}
- (void) swipedScreenUp:(UISwipeGestureRecognizer*)swipeGesture {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Previous Date"
                          message: @"Previous date selected!"
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}


@end


/**
 *	This section overrides the auto-rotate methods for UINaviationController and UITabBarController
 *	to allow the tab bar to rotate only when a FGalleryController is the visible controller. Sweet.
 */

@implementation UINavigationController (FGallery)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if([self.visibleViewController isKindOfClass:[FGalleryViewController class]])
	{
        return YES;
	}
    
	// To preserve the UINavigationController's defined behavior,
	// walk its stack.  If all of the view controllers in the stack
	// agree they can rotate to the given orientation, then allow it.
	BOOL supported = YES;
	for(UIViewController *sub in self.viewControllers)
	{
		if(![sub shouldAutorotateToInterfaceOrientation:interfaceOrientation])
		{
			supported = NO;
			break;
		}
	}
	if(supported)
		return YES;
	
	// we need to support at least one type of auto-rotation we'll get warnings.
	// so, we'll just support the basic portrait.
	return ( interfaceOrientation == UIInterfaceOrientationPortrait ) ? YES : NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	// see if the current controller in the stack is a gallery
	if([self.visibleViewController isKindOfClass:[FGalleryViewController class]])
	{
		FGalleryViewController *galleryController = (FGalleryViewController*)self.visibleViewController;
		[galleryController resetImageViewZoomLevels];
	}
}

@end




@implementation UITabBarController (FGallery)


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // only return yes if we're looking at the gallery
    if( [self.selectedViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navController = (UINavigationController*)self.selectedViewController;
        
        // see if the current controller in the stack is a gallery
        if([navController.visibleViewController isKindOfClass:[FGalleryViewController class]])
        {
            return YES;
        }
    }
	
	// we need to support at least one type of auto-rotation we'll get warnings.
	// so, we'll just support the basic portrait.
	return ( interfaceOrientation == UIInterfaceOrientationPortrait ) ? YES : NO;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if([self.selectedViewController isKindOfClass:[UINavigationController class]])
	{
		UINavigationController *navController = (UINavigationController*)self.selectedViewController;
		
		// see if the current controller in the stack is a gallery
		if([navController.visibleViewController isKindOfClass:[FGalleryViewController class]])
		{
			FGalleryViewController *galleryController = (FGalleryViewController*)navController.visibleViewController;
			[galleryController resetImageViewZoomLevels];
		}
	}
}


@end



