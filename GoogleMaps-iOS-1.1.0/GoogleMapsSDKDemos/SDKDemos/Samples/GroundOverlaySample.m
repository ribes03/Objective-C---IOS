#import "SDKDemos/MapSampleViewController.h"

@interface GroundOverlaySample : MapSampleViewController
@end

@implementation GroundOverlaySample {
  GMSGroundOverlayOptions *options_;
  id<GMSGroundOverlay> overlay_;
}

+ (NSString *)notes {
  return @"Showcases Ground Overlays.";
}

- (void)loadView {
  [super loadView];

  options_ = [GMSGroundOverlayOptions options];
  options_.icon = [UIImage imageNamed:@"australia_large.png"];
  options_.position = CLLocationCoordinate2DMake(-27.644606, 133.76294);
  options_.bearing = 0.f;
  options_.zoomLevel = 4;
  overlay_ = [self.mapView addGroundOverlayWithOptions:options_];

  [NSTimer scheduledTimerWithTimeInterval:(1.f/30.f)
                                   target:self
                                 selector:@selector(rotateOverlay)
                                 userInfo:nil
                                  repeats:YES];
}

#pragma mark - Private methods

- (void)rotateOverlay {
  overlay_.bearing += 2.f;
  if (overlay_.bearing > 360.f) {
    overlay_.bearing -= 360.f;
  }
}

@end