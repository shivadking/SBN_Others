#import "TEST_DRAW_APPAppDelegate.h"
#import "TEST_DRAW_APPViewController.h"

@implementation TEST_DRAW_APPAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application { 
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

@end
