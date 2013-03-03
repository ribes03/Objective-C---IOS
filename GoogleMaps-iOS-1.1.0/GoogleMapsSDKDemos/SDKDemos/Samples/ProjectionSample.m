#import "SDKDemos/MapSampleViewController.h"

@interface ProjectionSample : MapSampleViewController
@end

const static double targetLat = -33.85;
const static double targetLon = 151.20;

@implementation ProjectionSample {
  UIView *blockView_;
  UILabel *label_;
}

- (void)loadView {
  [super loadView];

  self.mapView.camera = [GMSCameraPosition cameraWithLatitude:targetLat
                                                    longitude:targetLon
                                                         zoom:10];

  // Create blockView_ (although don't use it until the first update in
  // didChangeCameraPosition).
  blockView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 175, 50)];
  blockView_.backgroundColor =
      [UIColor colorWithRed:0 green:0 blue:1.f alpha:0.75f];
  label_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 175, 50)];
  label_.textAlignment = NSTextAlignmentCenter;
  label_.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
  label_.backgroundColor = [UIColor clearColor];
  label_.textColor = [UIColor whiteColor];
  [blockView_ addSubview:label_];
}

+ (NSString *)notes {
  return @"Displays a regular UIView projected at a map location";
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView
    didChangeCameraPosition:(GMSCameraPosition *)position {
  GMSProjection *projection = mapView.projection;

  // Try to place this block over Sydney.
  CLLocationCoordinate2D target =
      CLLocationCoordinate2DMake(targetLat, targetLon);
  CGPoint point = [projection pointForCoordinate:target];

  if (blockView_.superview == nil) {
    [self.mapView addSubview:blockView_];
  }
  blockView_.center = point;
  NSLog(@"setting point: %@ (frame=%@)",
        NSStringFromCGPoint(point), NSStringFromCGRect(mapView.frame));
  label_.text = [NSString stringWithFormat:@"%@", NSStringFromCGPoint(point)];
}

@end
