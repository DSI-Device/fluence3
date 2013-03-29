//
//  TakeCameraPhoto.h
//  FBTest
//
//  Created by Naim on 3/22/13.
//
//

#import <UIKit/UIKit.h>
#import "BJImageCropper.h"
#import "Fluence3AppDelegate.h"

@interface TakeCameraPhoto : UIViewController <UINavigationControllerDelegate>
{
    IBOutlet UIImageView *image;
    IBOutlet UIButton *button;
    IBOutlet UIButton *cropButton;
    IBOutlet UIButton *filterButton;
    Fluence3AppDelegate *appdt;
    BJImageCropper *imageCropper;
    
}

@property (nonatomic, retain) IBOutlet UIImageView *image;
@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) IBOutlet UIButton *cropButton;
@property (nonatomic, retain) IBOutlet UIButton *filterButton;
@property (nonatomic, strong) BJImageCropper *imageCropper;

- (IBAction)selectPhotos;
- (IBAction)cropping;
- (IBAction)filtering;

@end
