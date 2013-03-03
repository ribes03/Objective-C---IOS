#import "SDKDemos/MapSampleViewController.h"

static NSString const * kNormalType = @"Normal";
static NSString const * kSatelliteType = @"Satellite";
static NSString const * kHybridType = @"Hybrid";
static NSString const * kTerrainType = @"Terrain";

@interface LayersSample : MapSampleViewController
@end

@implementation LayersSample {
  UISegmentedControl *switcher_;
}

+ (NSString *)description {
  return @"Map Types";
}

+ (NSString *)notes {
  return @"Demonstrates the different map types.";
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // The possible different types to show.
  NSArray *types = @[ kNormalType, kSatelliteType, kHybridType, kTerrainType ];

  // Create a UISegmentedControl that is the navigationItem's titleView.
  switcher_ = [[UISegmentedControl alloc] initWithItems:types];
  switcher_.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
      UIViewAutoresizingFlexibleWidth |
      UIViewAutoresizingFlexibleBottomMargin;
  switcher_.selectedSegmentIndex = 0;
  switcher_.segmentedControlStyle = UISegmentedControlStyleBar;
  self.navigationItem.titleView = switcher_;

  // Listen to touch events on the UISegmentedControl.
  [switcher_ addTarget:self action:@selector(didChangeSwitcher)
      forControlEvents:UIControlEventValueChanged];
}

- (void)didChangeSwitcher {
  // Switch to the type clicked on.
  NSString *title =
      [switcher_ titleForSegmentAtIndex:switcher_.selectedSegmentIndex];
  if ([kNormalType isEqualToString:title]) {
    self.mapView.mapType = kGMSTypeNormal;
  } else if ([kSatelliteType isEqualToString:title]) {
    self.mapView.mapType = kGMSTypeSatellite;
  } else if ([kHybridType isEqualToString:title]) {
    self.mapView.mapType = kGMSTypeHybrid;
  } else if ([kTerrainType isEqualToString:title]) {
    self.mapView.mapType = kGMSTypeTerrain;
  }
}

@end
