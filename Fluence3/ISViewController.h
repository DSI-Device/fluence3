#import <UIKit/UIKit.h>

@class GalleryController;
@class MainViewController;
@class CameraImageController;
@class SelectListViewController;

@interface ISViewController : UIViewController
{
    MainViewController *mc;
    GalleryController *gc;
    CameraImageController *nCameraImage;
    SelectListViewController *selectListView;
}

@property (strong, nonatomic) GalleryController *gc;
@property (strong, nonatomic) MainViewController *mc;
@property (strong, nonatomic) CameraImageController *nCameraImage;
@property (strong, nonatomic) SelectListViewController *selectListView;
- (IBAction)pushViewController;
- (IBAction)galleryClicked;
- (IBAction)profileClicked;
- (IBAction)findPeopleClicked;
- (IBAction)newCameraImageClicked;

@end
