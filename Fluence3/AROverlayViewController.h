#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"

@interface AROverlayViewController : UIViewController {
    NSTimer *counterTimer;
}

@property (retain) CaptureSessionManager *captureManager;
@property (nonatomic, retain) UILabel *scanningLabel;
@property (nonatomic, retain) UILabel *counterLabel;

@property (nonatomic, retain) NSTimer *counterTimer;

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

@end
