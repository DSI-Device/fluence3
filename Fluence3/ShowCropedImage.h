//
//  TakeCameraPhoto2.h
//  Fluence3
//
//  Created by Naim on 3/28/13.
//
//

#import <UIKit/UIKit.h>

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
    
    UIImage *rootImage;
    UIImageView *imageView;
    
}
@property (nonatomic, retain) IBOutlet UIImageView *rootImageView;
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
