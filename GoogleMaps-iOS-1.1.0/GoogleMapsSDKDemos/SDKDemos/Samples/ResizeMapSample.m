#import "SDKDemos/MapSampleViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface ResizeMapSample : MapSampleViewController
@end

@implementation ResizeMapSample {
  UIBarButtonItem *resetButton_;
}

+ (NSString *)notes {
  return @"Allows resizing of a GMSMapView.";
}

- (void)loadView {
  // NOTE: This explicitly _does not_ call [super loadView], as this would set
  // the GMSMapView as the whole view.

  self.view = [[UIView alloc] initWithFrame:CGRectZero];
  [self.view addSubview:self.mapView];
  self.mapView.autoresizingMask =
      UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

  self.mapView.frame = self.view.frame;
  self.mapView.clipsToBounds = YES;
  self.mapView.layer.borderColor = [[UIColor whiteColor] CGColor];

  resetButton_ =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                    target:self
                                                    action:@selector(didTapBig)];
  resetButton_.enabled = NO;

  UIBarButtonItem *smallButton =
      [[UIBarButtonItem alloc] initWithTitle:@"Make Small"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(didTapSmall)];

  self.navigationItem.rightBarButtonItems = @[ resetButton_, smallButton ];

}

- (void)didTapBig {
  self.mapView.frame = self.view.frame;
  resetButton_.enabled = NO;

  // Remove any border added in didTapSmall.
  self.mapView.layer.borderWidth = 0;
  self.mapView.layer.cornerRadius = 0;
}

- (void)didTapSmall {
  self.mapView.frame = CGRectInset(self.view.frame, rand() % 100, rand() % 100);
  resetButton_.enabled = YES;

  // Stylize the border of the GMSMapView.
  self.mapView.layer.borderWidth = 2;
  self.mapView.layer.cornerRadius = 4;
}

@end
