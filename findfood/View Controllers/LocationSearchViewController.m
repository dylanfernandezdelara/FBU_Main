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
#import "Parse/Parse.h"
#import "Parse/PFGeoPoint.h"

@interface LocationSearchViewController ()<MKLocalSearchCompleterDelegate, UISearchBarDelegate, UISearchDisplayDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) MKLocalSearchCompleter *completer;
@property(nonatomic, strong) NSArray <MKLocalSearchCompletion *> *results;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic)  CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *pressedLocation;
@property (strong, nonatomic) NSString *_returnAddress;
@property (strong, nonatomic) PFGeoPoint *pressedGeoPoint;

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
}

- (void) completerDidUpdateResults:(MKLocalSearchCompleter *)completer {
    self.results = completer.results;
    [self.tableView reloadData];
}

- (void) completer:(MKLocalSearchCompleter *)completer didFailWithError:(NSError *)error {
    NSLog(@"Completer failed with error: %@",error.description);
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText{
    self.completer.queryFragment = self.searchBar.text;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AddressResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressResultsCell"];
    cell.nameAddressLabel.text = (self.results[indexPath.row]).title;
    cell.subtitleLabel.text = (self.results[indexPath.row]).subtitle;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.pressedLocation = (self.results[indexPath.row]).title;
    [self getGeoInformations];
    [self dismissModalViewControllerAnimated:YES];
    // [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getGeoInformations {
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder geocodeAddressString:self.pressedLocation completionHandler:^(NSArray* placemarks, NSError* error){
        CLPlacemark *placemark = [placemarks lastObject];
        NSArray *lines = placemark.addressDictionary[@"FormattedAddressLines"];
        NSString *str_latitude = [NSString stringWithFormat: @"%f", placemark.location.coordinate.latitude];
        NSString *str_longitude = [NSString stringWithFormat: @"%f", placemark.location.coordinate.longitude];
        NSString *returnAddress = [NSString stringWithFormat:@" %@, %@, %@", lines, str_latitude, str_longitude];
        PFGeoPoint *returnGeo = [PFGeoPoint geoPointWithLatitude:placemark.location.coordinate.latitude longitude:placemark.location.coordinate.longitude];

        [self loadAddress:returnAddress];
        [self loadGeoPoint:returnGeo];
    }];
}

- (void)loadAddress:(NSString*)returnAddress {
    self._returnAddress = returnAddress;
}

- (void)loadGeoPoint:(PFGeoPoint*)returnGeoPoint {
    // #5 - this will be called last, some time after view did load is done.
    self.pressedGeoPoint = returnGeoPoint;
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"truckLocation"] = self.pressedGeoPoint;
    [[PFUser currentUser] saveInBackground];
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
