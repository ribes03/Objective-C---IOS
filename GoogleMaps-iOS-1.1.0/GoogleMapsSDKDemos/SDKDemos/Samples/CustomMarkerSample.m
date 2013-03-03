#import "SDKDemos/MapSampleViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface CustomMarkerSample : MapSampleViewController
@end

@implementation CustomMarkerSample {
  UIImage *baseImage_;
  UIImageView *selectedMarkerView_;
}

+ (NSString *)notes {
  return @"Add custom markers and changes their images at regular intervals.";
}

- (void)loadView {
  [super loadView];

  baseImage_ = [self imageForBrightness:0.f hue:0.f];

  selectedMarkerView_ = [[UIImageView alloc] initWithFrame:CGRectZero];
  selectedMarkerView_.layer.masksToBounds = NO;
  selectedMarkerView_.layer.shadowOffset = CGSizeMake(0, 8);
  selectedMarkerView_.layer.shadowRadius = 8;
  selectedMarkerView_.layer.shadowOpacity = 0.5;
  [self.view addSubview:selectedMarkerView_];

  UIBarButtonItem *addButton =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                    target:self
                                                    action:@selector(didTapAddMarker)];

  UIBarButtonItem *resetButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                  target:self
                                                  action:@selector(didTapReset)];

  self.navigationItem.rightBarButtonItems = @[ addButton, resetButton ];
}

#pragma mark - GMSMapViewDelegate

// NOTE: Uncomment this to prevent info windows from displaying.
/*
- (UIView *)mapView:(GMSMapView *)mapView
   markerInfoWindow:(id<GMSMarker>)marker {
  return [[UIView alloc] initWithFrame:CGRectZero];
}
*/

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(id<GMSMarker>)marker {
  id userData = marker.userData;
  if (userData != nil && [userData isKindOfClass:[NSNumber class]]) {
    NSNumber *number = (NSNumber *)userData;
    NSLog(@"Tapped on marker with hue: %.2f", [number floatValue]);
  } else {
    NSLog(@"Tapped on unknown marker");
  }

  // Poor man's observing of "selectedMarker".
  if (mapView.selectedMarker == marker) {
    // This marker is about to become unselected.
    marker = nil;
  }
  [self updateSelectedMarkerView:marker];
  return NO;
}

#pragma mark - Private methods

// Resets the map.
- (void)didTapReset {
  [self.mapView clear];
  [self updateSelectedMarkerView:nil];
}

// Adds a single marker, and schedules that every 5-8 secs, it should change
// its icon.
- (void)didTapAddMarker {
  float latitude = (((float)arc4random()/0x100000000)*160)-80.f;
  float longitude = (((float)arc4random()/0x100000000)*360)-180.f;

  NSTimeInterval interval = 5+rand()%4;
  GMSMarkerOptions *options = [GMSMarkerOptions options];
  options.position = CLLocationCoordinate2DMake(latitude, longitude);
  options.title =
      [NSString stringWithFormat:@"%.0fs: %f,%f", interval, latitude, longitude];
  options.icon = baseImage_;

  id marker = [self.mapView addMarkerWithOptions:options];

  [NSTimer scheduledTimerWithTimeInterval:interval
                                   target:self
                                 selector:@selector(updateMarker:)
                                 userInfo:marker
                                  repeats:YES];
}

// Updates the marker contained in the userInfo of the given NSTimer, with
// either a brand new icon or the same icon as a random previous marker.
- (void)updateMarker:(NSTimer *)timer {
  id<GMSMarker> marker = timer.userInfo;
  NSArray *markers = self.mapView.markers;

  // If the map has been refreshed, this timer/marker is expired; invalidate.
  if (![markers containsObject:marker]) {
    [timer invalidate];
    return;
  }

  BOOL changed = NO;
  if (rand() % 2 && [markers count] > 0) {
    id<GMSMarker> randMarker = [markers objectAtIndex:rand() % [markers count]];
    if (randMarker.userData != nil) {
      marker.icon = randMarker.icon;
      marker.userData = randMarker.userData;

      NSNumber *number = (NSNumber *)marker.userData;
      CGFloat hue = [number floatValue];

      NSLog(@"Re-using previous image for changed marker, hue=%.2f", hue);
      marker.snippet = [NSString stringWithFormat:@"reuse: %.2f", hue];
      changed = YES;
    }
  }

  if (changed == NO) {
    CGFloat hue = (rand() % 20 + 1) * 0.05f;
    NSLog(@"Creating new image for changed marker, hue=%.2f", hue);
    marker.icon = [self imageForBrightness:1.0f hue:hue];
    marker.userData = [NSNumber numberWithFloat:hue];
    marker.snippet = [NSString stringWithFormat:@"brand new: %.2f", hue];
    changed = YES;
  }

  assert(changed);

  // Update the top-left selected marker view if appropriate.
  if (marker == self.mapView.selectedMarker) {
    [self updateSelectedMarkerView:marker];
  }
}

- (void)updateSelectedMarkerView:(id<GMSMarker>)marker {
  if (marker == nil) {
    selectedMarkerView_.image = nil;
    selectedMarkerView_.frame = CGRectZero;
  } else {
    UIImage *image = marker.icon;
    selectedMarkerView_.frame =
        CGRectMake(8, 8, 96, 96 * (1.f * image.size.height / image.size.width));
    selectedMarkerView_.image = image;
  }
}

// Builds a new image with the given brightness/hue; just a square.
- (UIImage *)imageForBrightness:(CGFloat)brightness
                            hue:(CGFloat)hue {
  static int count = 0;
  int w = 192 + rand()%64, h = 192 + rand()%64;
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
  view.backgroundColor = [UIColor colorWithHue:hue
                                    saturation:1.0f
                                    brightness:brightness
                                         alpha:1.0f];
  view.layer.borderWidth = 2;
  view.layer.cornerRadius = 4;
  view.layer.borderColor = [[UIColor blackColor] CGColor];

  UILabel *label = [[UILabel alloc] initWithFrame:view.frame];
  label.text = [NSString stringWithFormat:@"%d: %.2f", ++count, hue];
  label.textColor = [UIColor blackColor];
  label.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.0f];
  label.textAlignment = NSTextAlignmentCenter;
  [view addSubview:label];

  UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.f);
  [view.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return resultingImage;
}

@end
