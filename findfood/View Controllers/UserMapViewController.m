//
//  UserMapViewController.m
//  findfood
//
//  Created by dylanfdl on 7/13/21.
//

#import "Mapkit/Mapkit.h"
#import <CoreLocation/CoreLocation.h>
#import "UserMapViewController.h"
#import "Parse/Parse.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface UserMapViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic)  CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray *arrayOfFoodTrucks;

@end

@implementation UserMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
             [self.locationManager requestWhenInUseAuthorization];
         }
    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    
    [self.mapView setCenterCoordinate:self.locationManager.location.coordinate animated:true];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 400, 400);
    [self.mapView setRegion:region];
    
    [self fetchFoodTrucks];
}

- (void)addAnnotations {
    for (int i=0; i<self.arrayOfFoodTrucks.count; i++) {
        MKPointAnnotation* annotation= [MKPointAnnotation new];
        PFUser *tempTruck = self.arrayOfFoodTrucks[i];
        PFGeoPoint *temp = tempTruck[@"truckLocation"];
        NSLog(@"%@",temp);
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(temp.latitude, temp.longitude);
        annotation.coordinate = coord;
        annotation.title = tempTruck[@"fullName"];
        annotation.subtitle = tempTruck[@"truckDescription"];
        [self.mapView addAnnotation:annotation];
    }
}

- (MKMarkerAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation.title isEqualToString:@"My Location"]){
        return nil;
    }
    
     MKMarkerAnnotationView *annotationView = (MKMarkerAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MKMarkerAnnotationView"];
     if (annotationView == nil) {
         annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MKMarkerAnnotationView"];
         annotationView.markerTintColor = UIColorFromRGB(0x3B5B33);
         annotationView.glyphImage = [UIImage imageNamed:@"truckMarker"];
         annotationView.clusteringIdentifier = @"MKMarkerAnnotationView";
     }
     return annotationView;
 }

- (void)fetchFoodTrucks {
    PFQuery *UserQuery = [PFUser query];
    [UserQuery orderByDescending:@"createdAt"];
    [UserQuery whereKey:@"userType" equalTo:@"FoodTruck"];
    [UserQuery includeKey:@"author"];
    UserQuery.limit = 20;
    
    [UserQuery findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> * _Nullable users, NSError * _Nullable error) {
        if (users) {
            self.arrayOfFoodTrucks = users;
            [self addAnnotations];
        }
        else {
            NSLog(@"Cannot fetch data");
        }
    }];
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
