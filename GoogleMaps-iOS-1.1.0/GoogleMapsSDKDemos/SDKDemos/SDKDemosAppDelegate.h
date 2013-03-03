#import <UIKit/UIKit.h>

@class MapSampleViewController;

@interface SDKDemosAppDelegate : UIResponder<
    UIApplicationDelegate,
    UISplitViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UISplitViewController *splitViewController;

/**
 * Update the SDKDemos app to show the specified sample in the right side of
 * its split view controller.
 */
- (void)provideSample:(MapSampleViewController *)sample;

@end
