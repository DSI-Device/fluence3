//
//  CameraImageController.h
//  Fluence3
//
//  Created by Naim on 3/28/13.
//
//

#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"
#import "AROverlayViewController.h"
#import "ISViewController.h"
@interface CameraImageController : UIViewController <UINavigationControllerDelegate>{
    NSTimer *counterTimer;
    CaptureSessionManager *captureManager;
    UILabel *scanningLabel;
    UILabel *counterLabel;
    AROverlayViewController *arOverlayView;
    
}
@property (retain) CaptureSessionManager *captureManager;
@property (nonatomic, retain) UILabel *scanningLabel;
@property (nonatomic, retain) UILabel *counterLabel;
@property (nonatomic, retain) AROverlayViewController *arOverlayView;
@property (nonatomic, retain) NSTimer *counterTimer;



- (IBAction)view01Action;
- (IBAction)cameraTimerAction;
- (IBAction)openPlinkingController;

@end
