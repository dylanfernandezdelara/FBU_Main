//
//  LocationSearchViewController.m
//  findfood
//
//  Created by dylanfdl on 7/15/21.
//

#import "LocationSearchViewController.h"
#import "Mapkit/Mapkit.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationSearchViewController ()<MKLocalSearchCompleterDelegate, UISearchBarDelegate, UISearchDisplayDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) MKLocalSearchCompleter *completer;
@property(nonatomic, readonly, strong) NSArray <MKLocalSearchCompletion *> *results;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic)  CLLocationManager *locationManager;

@end

@implementation LocationSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
             [self.locationManager requestWhenInUseAuthorization];
         }
    [self.locationManager startUpdatingLocation];
    
    self.searchBar.delegate = self;
    self.completer = [[MKLocalSearchCompleter alloc] init];
    self.completer.delegate = self;
    self.completer.filterType = MKSearchCompletionFilterTypeLocationsAndQueries;
    // self.completer.region =
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{

    [self.locationManager stopUpdatingLocation];
    CGFloat usersLatitude = self.locationManager.location.coordinate.latitude;
    CGFloat usersLongidute = self.locationManager.location.coordinate.longitude;
    NSLog(@"%f, %f", usersLatitude, usersLongidute);
}

- (void) completerDidUpdateResults:(MKLocalSearchCompleter *)completer {
    for (MKLocalSearchCompletion *completion in completer.results) {
        NSLog(@"------ %@",completion.description);
    }
}

- (void) completer:(MKLocalSearchCompleter *)completer didFailWithError:(NSError *)error {
    NSLog(@"Completer failed with error: %@",error.description);

}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText{
    self.completer.queryFragment = self.searchBar.text;
    NSLog(@"%@", self.searchBar.text);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
