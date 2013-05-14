#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"
#import "Fluence3AppDelegate.h"

@interface AROverlayViewController : UIViewController {
    NSTimer *counterTimer;
    Fluence3AppDelegate *appdt;
    int counter;
    UIButton *autoButton;
}

@property (retain) CaptureSessionManager *captureManager;
@property (nonatomic, retain) UILabel *scanningLabel;
@property (nonatomic, retain) UILabel *counterLabel;
@property (nonatomic, retain) IBOutlet Fluence3AppDelegate *appdt;
@property (nonatomic, retain) NSTimer *counterTimer;
@property (nonatomic, retain) UIButton *autoButton;
@property int counter;




@end
