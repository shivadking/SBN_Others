#import <UIKit/UIKit.h>

@class TEST_DRAW_APPViewController;

@interface TEST_DRAW_APPAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TEST_DRAW_APPViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TEST_DRAW_APPViewController *viewController;

@end

