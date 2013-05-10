#import <UIKit/UIKit.h>

@class GalleryController;
@class MainViewController;
@class CameraImageController;
@class SelectListViewController;
@class MapViewController;
@class SelectPoseListViewController;
@class SelectTasteListViewController;

@interface ISViewController : UIViewController
{
    MainViewController *mc;
    GalleryController *gc;
    CameraImageController *nCameraImage;
    SelectListViewController *selectListView;
    MapViewController *mapViewController;
    SelectPoseListViewController *selectPoseListView;
    SelectTasteListViewController *selectTasteListView;
}

@property (strong, nonatomic) GalleryController *gc;
@property (strong, nonatomic) MainViewController *mc;
@property (strong, nonatomic) CameraImageController *nCameraImage;
@property (strong, nonatomic) SelectListViewController *selectListView;
@property (strong, nonatomic) MapViewController *mapViewController;
@property (strong, nonatomic) SelectPoseListViewController *selectPoseListView;
@property (strong, nonatomic) SelectTasteListViewController *selectTasteListView;
- (IBAction)pushViewController;
- (IBAction)galleryClicked;
- (IBAction)profileClicked;
- (IBAction)findPeopleClicked;
- (IBAction)newCameraImageClicked;
- (IBAction)mapViewClicked;
@end
