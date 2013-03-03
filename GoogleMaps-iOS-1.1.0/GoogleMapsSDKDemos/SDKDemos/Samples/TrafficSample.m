#import "SDKDemos/MapSampleViewController.h"

@interface TrafficSample : MapSampleViewController
@end

@implementation TrafficSample

+ (NSString *)notes {
  return @"Shows traffic data around your location, or a default location.";
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  self.mapView.myLocationEnabled = YES;

  // Observe the current location, as to track it with the camera.
  [self.mapView addObserver:self
                 forKeyPath:@"myLocation"
                    options:NSKeyValueObservingOptionNew
                    context:NULL];
  
  NSLog(@"Waiting for first location update (or ~2 sec) to enable traffic.");
  [NSTimer scheduledTimerWithTimeInterval:2
                                   target:self
                                 selector:@selector(defaultEnableTraffic)
                                 userInfo:nil
                                  repeats:NO];
}

- (void)dealloc {
  [self.mapView removeObserver:self forKeyPath:@"myLocation"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if ([keyPath isEqualToString:@"myLocation"]) {
    [self enableTrafficAtLocation:self.mapView.myLocation.coordinate];
  }
}

- (void)defaultEnableTraffic {
  if (self.mapView.trafficEnabled == NO) {
    [self enableTrafficAtLocation:CLLocationCoordinate2DMake(37.786191, -122.391315)];
  }
}

- (void)enableTrafficAtLocation:(CLLocationCoordinate2D)location {
  [self.mapView animateToLocation:location];
  [self.mapView animateToZoom:14];
  [self.mapView animateToBearing:30];
  [self.mapView animateToViewingAngle:15];
  self.mapView.trafficEnabled = YES;
}

@end
