#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"
#import "Fluence3AppDelegate.h"

@interface AROverlayViewController : UIViewController {
    NSTimer *counterTimer;
    Fluence3AppDelegate *appdt;
}

@property (retain) CaptureSessionManager *captureManager;
@property (nonatomic, retain) UILabel *scanningLabel;
@property (nonatomic, retain) UILabel *counterLabel;
@property (nonatomic, retain) IBOutlet Fluence3AppDelegate *appdt;
@property (nonatomic, retain) NSTimer *counterTimer;

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

@end
