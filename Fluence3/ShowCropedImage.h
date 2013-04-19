//
//  TakeCameraPhoto2.h
//  Fluence3
//
//  Created by Naim on 3/28/13.
//
//

#import <UIKit/UIKit.h>
#import "Fluence3AppDelegate.h"

@interface ShowCropedImage : UIViewController
{
    // UIImageView *rootImageView;
    
    IBOutlet UIImageView *rootImageView;
    UIToolbar *toolBar;
    UISegmentedControl *seg;
    UIImage *currentImage;
    UIImagePickerController *imagePicker;
    NSData *data;
    UIScrollView *scrollerView;
    Fluence3AppDelegate *appdt;
    UIImage *rootImage;
    UIImageView *imageView;
    
}
@property (nonatomic, retain) IBOutlet UIImageView *rootImageView;
@property (nonatomic, retain) IBOutlet Fluence3AppDelegate *appdt;
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
