//
//  LocationSearchViewController.m
//  findfood
//
//  Created by dylanfdl on 7/15/21.
//

#import "LocationSearchViewController.h"
#import "Mapkit/Mapkit.h"
#import <CoreLocation/CoreLocation.h>
#import "AddressResultsCell.h"

@interface LocationSearchViewController ()<MKLocalSearchCompleterDelegate, UISearchBarDelegate, UISearchDisplayDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) MKLocalSearchCompleter *completer;
@property(nonatomic, strong) NSArray <MKLocalSearchCompletion *> *results;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic)  CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LocationSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
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
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{

    [self.locationManager stopUpdatingLocation];
    CGFloat usersLatitude = self.locationManager.location.coordinate.latitude;
    CGFloat usersLongidute = self.locationManager.location.coordinate.longitude;
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(usersLatitude, usersLongidute);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 500, 500);
    self.completer.region = region;
    NSLog(@"%f, %f", usersLatitude, usersLongidute);
}

- (void) completerDidUpdateResults:(MKLocalSearchCompleter *)completer {
    for (MKLocalSearchCompletion *completion in completer.results) {
        // NSLog(@"------ %@",completion.description);
    }
    self.results = completer.results;
    [self.tableView reloadData];
}

- (void) completer:(MKLocalSearchCompleter *)completer didFailWithError:(NSError *)error {
    NSLog(@"Completer failed with error: %@",error.description);

}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText{
    self.completer.queryFragment = self.searchBar.text;
    // NSLog(@"%@", self.searchBar.text);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AddressResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressResultsCell"];
    cell.nameAddressLabel.text = (self.results[indexPath.row]).title;
    cell.subtitleLabel.text = (self.results[indexPath.row]).subtitle;
    NSLog(@"%@", (self.results[indexPath.row]).title);
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

@end
