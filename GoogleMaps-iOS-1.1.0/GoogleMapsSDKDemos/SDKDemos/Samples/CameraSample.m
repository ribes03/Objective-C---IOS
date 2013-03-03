#import "SDKDemos/MapSampleViewController.h"

@interface CameraSample : MapSampleViewController
@end

@implementation CameraSample

+ (NSString *)notes {
  return @"Configures a default tilted/angled camera.";
}

- (void)loadView {
  [super loadView];

  CGFloat zoom = 18;
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    zoom -= 1;
  }

  // Show Melbourne at a specific bearing/angle.
  self.mapView.camera = [GMSCameraPosition cameraWithLatitude:-37.819487
                                                    longitude:144.965699
                                                         zoom:zoom
                                                      bearing:10.f
                                                 viewingAngle:37.5f];

  // Create a reference marker, and select it by default.
  GMSMarkerOptions *options = [GMSMarkerOptions options];
  options.title = @"Melbourne";
  options.snippet = @"Population: 4,169,103";
  options.position = CLLocationCoordinate2DMake(-37.81969, 144.966085);
  options.icon = [UIImage imageNamed:@"glow-marker"];
  self.mapView.selectedMarker = [self.mapView addMarkerWithOptions:options];

  // Draw a polyline down the river.
  GMSMutablePath *path = [GMSMutablePath path];
  [path addCoordinate:CLLocationCoordinate2DMake(-37.826186, 144.98026)];
  [path addCoordinate:CLLocationCoordinate2DMake(-37.821695, 144.976087)];
  [path addCoordinate:CLLocationCoordinate2DMake(-37.819304, 144.972846)];
  [path addCoordinate:CLLocationCoordinate2DMake(-37.81923, 144.969146)];
  [path addCoordinate:CLLocationCoordinate2DMake(-37.820002, 144.963578)];
  [path addCoordinate:CLLocationCoordinate2DMake(-37.821497, 144.959233)];

  GMSPolylineOptions *polyline = [GMSPolylineOptions options];
  polyline.path = path;
  polyline.width = 10;
  polyline.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
  [self.mapView addPolylineWithOptions:polyline];
}

@end
