//
//  FGalleryViewController.h
//  FGallery
//
//  Created by Grant Davis on 5/19/10.
//  Copyright 2011 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FGalleryPhotoView.h"
#import "FGalleryPhoto.h"
#import "RemoveEventView.h"
#import "Fluence3AppDelegate.h"
#import "TSPopoverController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Fluence3AppDelegate.h"
#import "YHCPickerView.h"
#import "galleryDateSelect.h"
#import "GalleryController.h"
#import "CQMFloatingController.h"
#import "GalleryCommentViewController.h"
#import "UAModalPanel.h"

@class DDMenuController;
typedef enum
{
	FGalleryPhotoSizeThumbnail,
	FGalleryPhotoSizeFullsize
} FGalleryPhotoSize;

typedef enum
{
	FGalleryPhotoSourceTypeNetwork,
	FGalleryPhotoSourceTypeLocal
} FGalleryPhotoSourceType;

@protocol FGalleryViewControllerDelegate;

@interface FGalleryViewController : UIViewController <UIScrollViewDelegate,FGalleryPhotoDelegate,FGalleryPhotoViewDelegate,UITextFieldDelegate,GalleryCommentViewControllerDelegate> {
	
	BOOL _isActive;
	BOOL _isFullscreen;
	BOOL _isScrolling;
	BOOL _isThumbViewShowing;
    
    NSMutableArray * countriesArray;
	
	UIStatusBarStyle _prevStatusStyle;
	CGFloat _prevNextButtonSize;
	CGRect _scrollerRect;
	NSString *galleryID;
	NSInteger _currentIndex;
    NSString *currentDate;
	TSPopoverController *popoverController;
    
	UIView *_container; // used as view for the controller
	UIView *_innerContainer; // sized and placed to be fullscreen within the container
	UIToolbar *_toolbar;
    UIToolbar *_toolbar1;
	UIScrollView *_thumbsView;
	UIScrollView *_scroller;
	UIView *_captionContainer;
	UILabel *_caption;
    
    UIView *_userInfoContainer;
	UILabel *_userInfoCaption;
    UIButton *_userProfileImage;
    
    RemoveEventView *_tagContainer;
    UILabel *_tag;
    UIView *_tagCaptionContainer;
    
	NSMutableDictionary *_photoLoaders;
	NSMutableArray *_barItems;
	NSMutableArray *_photoThumbnailViews;
	NSMutableArray *_photoViews;
	
	NSObject <FGalleryViewControllerDelegate> *_photoSource;
    
	UIBarButtonItem *_nextButton;
	UIBarButtonItem *_prevButton;
    
    
    UIButton *_likeButton;
    UIButton *_topButton;
    UIButton *_shareButton;
    UIButton *_commentButton;
    UIButton *_stylistButton;
    UITextField *_commentTextField;
    UILabel *_shareloading;
    
    UILabel *_likeNumber;
    
    Fluence3AppDelegate *appdt;
    
    CQMFloatingController *floatingController;
    UAModalPanel *panel;
}


- (id)initWithPhotoSource:(NSObject<FGalleryViewControllerDelegate>*)photoSrc;
- (id)initWithPhotoSource:(NSObject<FGalleryViewControllerDelegate>*)photoSrc barItems:(NSArray*)items;

- (void)next;
- (void)previous;
- (void)gotoImageByIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)removeImageAtIndex:(NSUInteger)index;
- (void)reloadGallery;
- (FGalleryPhoto*)currentPhoto;
- (void)addMyButton:(NSInteger)index:(NSString*)caption:(UIView*)container:(NSInteger)xc:(NSInteger)yc;
//- (void)commentDone:(NSString*)comment;
@property (nonatomic, retain) UAModalPanel *panel;
@property (nonatomic, retain) CQMFloatingController *floatingController;
@property (nonatomic, retain) Fluence3AppDelegate *appdt;
@property (nonatomic,retain) NSString *currentDate;
@property NSInteger currentIndex;
@property NSInteger startingIndex;
@property (nonatomic,assign) NSObject<FGalleryViewControllerDelegate> *photoSource;
@property (nonatomic,readonly) UIToolbar *toolBar;
@property (nonatomic,readonly) UIToolbar *toolBar1;
@property (nonatomic,readonly) UIView* thumbsView;
@property (nonatomic,retain) NSString *galleryID;
@property (nonatomic) BOOL useThumbnailView;
@property (nonatomic) BOOL beginsInThumbnailView;
@property (nonatomic) BOOL hideTitle;
//@property (strong, nonatomic) DDMenuController *menuController;
//@property (strong, nonatomic) UIWindow *window;
-(void)promptUserWithAccountName;
-(void)controlStatusUsable:(BOOL)usable;
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)commentDone:(GalleryCommentViewController *)controller didFinishEnteringBrand:(NSString *)item;
@end


@protocol FGalleryViewControllerDelegate

@required
- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController*)gallery;
- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController*)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index;

@optional
- (NSString*)photoGallery:(FGalleryViewController*)gallery captionForPhotoAtIndex:(NSUInteger)index;
- (NSMutableArray*)photoGallery:(FGalleryViewController *)gallery tagsForPhotoAtIndex:(NSUInteger)index;
- (NSMutableArray*)stylistInfos;
- (NSDictionary*)photoGallery:(FGalleryViewController *)gallery tagsForPhotoAtId:(NSUInteger)tagId:(NSUInteger)index;
- (NSDictionary*)photoGallery:(FGalleryViewController*)gallery infoForPhotoAtIndex:(NSUInteger)index;

// the photosource must implement one of these methods depending on which FGalleryPhotoSourceType is specified
- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index;
- (NSString*)photoGallery:(FGalleryViewController*)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index;


//Date Related Datasource Change
- (void)photoGallery:(FGalleryViewController*)gallery handleChangeDate:(NSString*)date;

//Date Related Datasource Change
- (int)photoGallery:(FGalleryViewController*)gallery likeButtonClicked:(NSString*)imageId:(NSInteger)imgIndex;
- (void)commentButtonClicked:(NSString*)imageId:(NSString*)comment;
- (void)photoGallery:(FGalleryViewController*)gallery stylistButtonClicked:(NSInteger)stylistId:(NSString*)userId:(NSString*)imageId:(NSString*)query;

- (void)photoGallery:(FGalleryViewController*)gallery commentButtonClicked:(NSString*)imageId:(NSString*)comment;

@end
