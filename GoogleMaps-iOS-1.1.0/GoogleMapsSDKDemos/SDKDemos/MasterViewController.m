#import "SDKDemos/MapSampleViewController.h"
#import "SDKDemos/MasterViewController.h"
#import "SDKDemos/SDKDemosAppDelegate.h"

#include <objc/runtime.h>

// The static set of MapSample implementations, created via +initialize.
static NSArray *samples;

@implementation MasterViewController {
  BOOL isPhone_;
  UIPopoverController *popover_;
  UIBarButtonItem *samplesButton_;
  __weak MapSampleViewController *controller_;
}

- (id)init {
  if ((self = [super initWithNibName:@"MasterViewController" bundle:nil])) {
    self.title = NSLocalizedString(@"SDKDemos", @"SDKDemos");
    isPhone_ = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
    if (!isPhone_) {
      self.clearsSelectionOnViewWillAppear = NO;
    }
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  // Create MasterViewController with init.
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  if (!isPhone_) {
    [self loadSample:[samples objectAtIndex:0]];
  }
}

+ (void)initialize {
  samples = [self findAllOf:[MapSampleViewController class]];
}

// Find all direct subclasses of |defaultClass|.
+ (NSArray *)findAllOf:(Class)defaultClass {
  int count = objc_getClassList(NULL, 0);
  if (count <= 0) {
    @throw @"Couldn't retrieve Obj-C class-list";
    return [NSArray arrayWithObject:defaultClass];
  }

  NSMutableArray *output = [NSMutableArray arrayWithObject:defaultClass];
  Class *classes = (Class *) malloc(sizeof(Class) * count);
  objc_getClassList(classes, count);
  for (int i = 0; i < count; ++i) {
    if (defaultClass == class_getSuperclass(classes[i])) {
      [output addObject:classes[i]];
    }
  }
  free(classes);
  return [NSArray arrayWithArray:output];
}

#pragma mark - UITableViewController

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [samples count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *reusableId = @"Cell";

  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:reusableId];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:reusableId];
    if (isPhone_) {
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
  }

  Class class = [samples objectAtIndex:indexPath.row];
  cell.textLabel.text = [class description];
  cell.detailTextLabel.text = [class notes];

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Class sample = [samples objectAtIndex:indexPath.row];
  [self loadSample:sample];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController
     willHideViewController:(UIViewController *)viewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)popoverController {
  popover_ = popoverController;
  samplesButton_ = barButtonItem;
  samplesButton_.title = NSLocalizedString(@"Samples", @"Samples");
  samplesButton_.style = UIBarButtonItemStyleDone;
  [controller_ updateSamplesButton:samplesButton_];
}

- (void)splitViewController:(UISplitViewController *)splitController
     willShowViewController:(UIViewController *)viewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
  popover_ = nil;
  samplesButton_ = nil;
  [controller_ updateSamplesButton:nil];
}

#pragma mark - Private methods

- (void)loadSample:(Class)sample {
  MapSampleViewController *controller = [[sample alloc] init];
  controller_ = controller;

  if (isPhone_) {
    [self.navigationController pushViewController:controller animated:YES];
  } else {
    [self.appDelegate provideSample:controller];
    [popover_ dismissPopoverAnimated:YES];
  }
  [controller updateSamplesButton:samplesButton_];
}

@end
