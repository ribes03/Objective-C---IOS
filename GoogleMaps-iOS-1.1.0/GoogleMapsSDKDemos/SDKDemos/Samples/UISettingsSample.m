#import "SDKDemos/MapSampleViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface UISettingsSample : MapSampleViewController
@end

@implementation UISettingsSample {
  UISwitch *zoomSwitch_;
}

+ (NSString *)notes {
  return @"Allows controlling UISettings.";
}

- (void)loadView {
  self.view = [[UIView alloc] initWithFrame:CGRectZero];
  [self.view addSubview:self.mapView];

  self.mapView.myLocationEnabled = YES;

  self.mapView.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

  UIView *holder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 59)];
  holder.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
  holder.backgroundColor =
      [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
  [self.view addSubview:holder];

  // Zoom label.
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 200, 29)];
  label.text = @"Zooming?";
  label.font = [UIFont boldSystemFontOfSize:18.0f];
  label.textAlignment = NSTextAlignmentLeft;
  label.backgroundColor = [UIColor clearColor];
  label.layer.shadowColor = [[UIColor whiteColor] CGColor];
  label.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
  label.layer.shadowOpacity = 1.0f;
  label.layer.shadowRadius = 0.0f;
  [holder addSubview:label];

  // Control zooming.
  zoomSwitch_ = [[UISwitch alloc] initWithFrame:CGRectMake(-90, 16, 0, 0)];
  zoomSwitch_.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
  [zoomSwitch_ addTarget:self action:@selector(didChangeZoomSwitch)
          forControlEvents:UIControlEventValueChanged];
  zoomSwitch_.on = YES;
  [holder addSubview:zoomSwitch_];
}

- (void)didChangeZoomSwitch {
  self.mapView.settings.zoomGestures = zoomSwitch_.isOn;
}

@end