#import "SDKDemos/MapSampleViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface MarkerSample : MapSampleViewController
@end

@implementation MarkerSample {
  id<GMSMarker> sydneyMarker_;
  int count_;
}

+ (NSString *)notes {
  return @"Allows many markers to be added to a GMSMapView.";
}

- (void)loadView {
  [super loadView];

  GMSMarkerOptions *options = [GMSMarkerOptions options];
  options.position = CLLocationCoordinate2DMake(-33.85, 151.20);
  options.icon = [UIImage imageNamed:@"glow-marker"];
  options.title = @"Sydney!";
  sydneyMarker_ = [self.mapView addMarkerWithOptions:options];
  ++count_;

  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                    target:self
                                                    action:@selector(didTapAddMarker)];
}

- (void)didTapAddMarker {
  for (int i = 0; i < 7; ++i) {
    float latitude = (((float)arc4random()/0x100000000)*180)-90.f;
    float longitude = (((float)arc4random()/0x100000000)*360)-180.f;

    GMSMarkerOptions *options = [GMSMarkerOptions options];
    options.position = CLLocationCoordinate2DMake(latitude, longitude);
    options.title = [NSString stringWithFormat:@"#%d", count_];
    [self.mapView addMarkerWithOptions:options];
    ++count_;
  }
  NSLog(@"now have %d markers", count_);
}

#pragma mark - GMSMapViewDelegate

- (UIView *)mapView:(GMSMapView *)mapView
    markerInfoWindow:(id<GMSMarker>)marker {
  if (marker == sydneyMarker_) {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon"]];
  }
  return nil;
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(id<GMSMarker>)marker {
  if (marker != self.mapView.selectedMarker) {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.125f];  // short animation
    [self.mapView animateToLocation:marker.position];
    [self.mapView animateToBearing:0];
    [self.mapView animateToViewingAngle:0];

    // If the highlight marker is selected, show it off.
    if (marker == sydneyMarker_) {
      [self.mapView animateToBearing:15];
      [self.mapView animateToViewingAngle:30];
    }

    [CATransaction commit];
  }
  return NO;
}

@end
