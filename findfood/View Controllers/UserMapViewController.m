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
#import "MapFiltersViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define EARTHCIRUMFERENCE 4007500.0

@interface UserMapViewController ()<CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *truckName;
@property (weak, nonatomic) IBOutlet UILabel *truckDescription;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic)  CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableDictionary *annotationsToBeRemoved;

@property(assign, nonatomic) BOOL pizzaFilter;
@property(assign, nonatomic) BOOL bbqFilter;
@property(assign, nonatomic) BOOL brunchFilter;
@property(assign, nonatomic) BOOL mexicanFilter;
@property(assign, nonatomic) BOOL seafoodFilter;
@property(assign, nonatomic) BOOL sandwichesFilter;

@property(assign, nonatomic) BOOL popularFilter;

@property(assign, nonatomic) NSInteger priceFilter;

@end

@implementation UserMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    UIPanGestureRecognizer* dragRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(isMapDoneMoving:)];
        [dragRecognizer setDelegate:self];
        [self.mapView addGestureRecognizer:dragRecognizer];
    
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
    
    if (self.filterArguments.count != 8){
        NSMutableArray *initArrOfAnnotations = [[NSMutableArray alloc] init];
        NSMutableArray *initArrOfTrucks = [[NSMutableArray alloc] init];
        self.arrayOfAnnotations = initArrOfAnnotations;
        self.arrayOfFoodTrucks = initArrOfTrucks;
        
        self.pizzaFilter = false;
        self.bbqFilter = false;
        self.brunchFilter = false;
        self.mexicanFilter = false;
        self.seafoodFilter = false;
        self.sandwichesFilter = false;
        
        NSMutableArray *defaultArguments = [[NSMutableArray alloc] init];
        [defaultArguments addObject:[NSNumber numberWithBool:self.pizzaFilter]];
        [defaultArguments addObject:[NSNumber numberWithBool:self.bbqFilter]];
        [defaultArguments addObject:[NSNumber numberWithBool:self.brunchFilter]];
        [defaultArguments addObject:[NSNumber numberWithBool:self.mexicanFilter]];
        [defaultArguments addObject:[NSNumber numberWithBool:self.seafoodFilter]];
        [defaultArguments addObject:[NSNumber numberWithBool:self.sandwichesFilter]];
        
        [defaultArguments addObject:[NSNumber numberWithInteger:2]];
        [defaultArguments addObject:[NSNumber numberWithInteger:2]];
        
        self.filterArguments = defaultArguments;
    }
    
    else {
        [self.mapView addAnnotations:self.arrayOfAnnotations];
    }

    [self fetchFoodTrucks:self.filterArguments];
}

- (void)mapView:(MKMapView *)mapView
didSelectAnnotationView:(MKMarkerAnnotationView *)view{
    if ([view.clusteringIdentifier isEqualToString:@"MKMarkerAnnotationView"]){
        
        MKClusterAnnotation *cluster = (MKClusterAnnotation*) view.annotation;
        [mapView showAnnotations:cluster.memberAnnotations animated:YES];
    
    }
}

- (MKMarkerAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation.title isEqualToString:@"My Location"]){
        return nil;
    }
    
     MKMarkerAnnotationView *annotationView = (MKMarkerAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MKMarkerAnnotationView"];
     
    if (annotationView == nil) {
         annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MKMarkerAnnotationView"];
         annotationView.clusteringIdentifier = @"MKMarkerAnnotationView";
     }
    
     annotationView.markerTintColor = UIColorFromRGB(0x3B5B33);
     annotationView.glyphImage = [UIImage imageNamed:@"truckMarker"];
    
     return annotationView;
 }

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)isMapDoneMoving:(UIGestureRecognizer*)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        
        // [self fetchFoodTrucks:self.filterArguments];

    }
}

- (void)addAnnotationsToMap {
    for (int i=0; i<self.arrayOfFoodTrucks.count; i++) {
        MKPointAnnotation* annotation= [MKPointAnnotation new];
        PFUser *tempTruck = self.arrayOfFoodTrucks[i];
        PFGeoPoint *temp = tempTruck[@"truckLocation"];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(temp.latitude, temp.longitude);
        annotation.coordinate = coord;
        annotation.title = tempTruck[@"fullName"];
        [self.mapView addAnnotation:annotation];
        [self.arrayOfAnnotations addObject:annotation];
    }
}

- (NSMutableArray*)removeExcessTrucks:(NSArray*)smallerArr removeExcessIn:(NSMutableArray*)biggerArr{
    
    NSMutableDictionary *objectIDtoTruck = [[NSMutableDictionary alloc] init];
    NSMutableArray *trucksToBeRemoved = [[NSMutableArray alloc] init];
    self.annotationsToBeRemoved = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < smallerArr.count; i++){
        PFUser *currTruck = smallerArr[i];
        [objectIDtoTruck setObject:currTruck forKey:currTruck.objectId];
    }
    
    for (int i = 0; i < biggerArr.count; i++){
        PFUser *currTruck = biggerArr[i];
        
        if ( ![objectIDtoTruck objectForKey:currTruck.objectId] ){
            [trucksToBeRemoved addObject:biggerArr[i]];
            [self.annotationsToBeRemoved setObject:currTruck forKey:currTruck[@"fullName"]];
        }
        
        else {
            [objectIDtoTruck removeObjectForKey:currTruck.objectId];
        }
        
    }
    
    NSMutableArray *newTrucksLeftover = [[objectIDtoTruck allValues] mutableCopy];
    NSMutableArray *newAnnotations = [self convertRemovedTruckObjectsToAnnotation:newTrucksLeftover];
    [self.mapView addAnnotations:newAnnotations];
    
    return trucksToBeRemoved;
    
}

- (void)findAndRemoveAnnotations {
    
    NSArray *annotationsOnMap = self.mapView.annotations;
    
    for (int i = 0; i < annotationsOnMap.count; i++){
        MKPointAnnotation *mapPoint = annotationsOnMap[i];
        
        if ([self.annotationsToBeRemoved objectForKey:mapPoint.title]){
            [self.mapView removeAnnotation:mapPoint];
        }
        
    }
    
}

- (NSMutableArray*)convertRemovedTruckObjectsToAnnotation:(NSMutableArray*)FoodTrucks {
    NSMutableArray* convertedToAnnotations = [[NSMutableArray alloc] init];
    
    for (int i=0; i<FoodTrucks.count; i++) {
        
        MKPointAnnotation* annotation= [MKPointAnnotation new];
        PFUser *tempTruck = FoodTrucks[i];
        PFGeoPoint *temp = tempTruck[@"truckLocation"];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(temp.latitude, temp.longitude);
        
        annotation.coordinate = coord;
        annotation.title = tempTruck[@"fullName"];
        
        [convertedToAnnotations addObject:annotation];
    }
    
    return convertedToAnnotations;
}

- (void)fetchFoodTrucks:(NSArray*)filters {
    PFQuery *UserQuery = [PFUser query];
    
    // 360 degress, 1000m zone
    long double degreeChangeFromCenter = 360.0 * 1000.0 / EARTHCIRUMFERENCE;

    // moving west increases long, moving south increases lat
    PFGeoPoint *southwestCorner = [PFGeoPoint geoPointWithLatitude:self.mapView.centerCoordinate.latitude + degreeChangeFromCenter longitude:self.mapView.centerCoordinate.longitude + degreeChangeFromCenter];

    PFGeoPoint *northwestCorner = [PFGeoPoint geoPointWithLatitude:self.mapView.centerCoordinate.latitude - degreeChangeFromCenter longitude:self.mapView.centerCoordinate.longitude - degreeChangeFromCenter];

    [UserQuery whereKey:@"truckLocation" withinGeoBoxFromSouthwest:southwestCorner toNortheast:northwestCorner];
    
    NSNumber *trueValue = [NSNumber numberWithBool:true];
    
    if ([filters objectAtIndex:0] == trueValue){
        [UserQuery whereKey:@"pizzaType" equalTo:trueValue];
    }
    if ([filters objectAtIndex:1] == trueValue){
        [UserQuery whereKey:@"bbqType" equalTo:trueValue];
    }
    if ([filters objectAtIndex:2] == trueValue){
        [UserQuery whereKey:@"brunchType" equalTo:trueValue];
    }
    if ([filters objectAtIndex:3] == trueValue){
        [UserQuery whereKey:@"mexicanType" equalTo:trueValue];
    }
    if ([filters objectAtIndex:4] == trueValue){
        [UserQuery whereKey:@"seafoodType" equalTo:trueValue];
    }
    if ([filters objectAtIndex:5] == trueValue){
        [UserQuery whereKey:@"sandwichesType" equalTo:trueValue];
    }
    
    [UserQuery whereKey:@"userType" equalTo:@"FoodTruck"];
    [UserQuery includeKey:@"author"];
    UserQuery.limit = 50;

    [UserQuery findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> * _Nullable users, NSError * _Nullable error) {
            if (users) {
                if (![users isEqualToArray:self.arrayOfFoodTrucks]){
                    
                    if (users.count < self.arrayOfFoodTrucks.count){
                        
                        NSMutableArray *trucksToRemove = [self.arrayOfFoodTrucks mutableCopy];
                        trucksToRemove = [self removeExcessTrucks:users removeExcessIn:trucksToRemove];
                        [self findAndRemoveAnnotations];
                        [self.arrayOfFoodTrucks removeObjectsInArray:trucksToRemove];
                        self.arrayOfAnnotations = [self.mapView.annotations mutableCopy];
                        
                    }
                    
                    else if (users.count > self.arrayOfFoodTrucks.count){
                        
                        NSMutableArray *trucksToAdd = [users mutableCopy];
                        [trucksToAdd removeObjectsInArray:self.arrayOfFoodTrucks];
                        [self.arrayOfFoodTrucks addObjectsFromArray:trucksToAdd];
                        NSMutableArray *annotationsToAdd = [self convertRemovedTruckObjectsToAnnotation:trucksToAdd];
                        [self.mapView addAnnotations:annotationsToAdd];
                        self.arrayOfAnnotations = [self.mapView.annotations mutableCopy];
                        
                    }
                    
                    else if (users.count == self.arrayOfFoodTrucks.count){
                        
                        [self.mapView removeAnnotations:self.mapView.annotations];
                        NSMutableArray *newAnnotations = [self convertRemovedTruckObjectsToAnnotation:[users mutableCopy]];
                        [self.mapView addAnnotations:newAnnotations];
                        
                    }
                }
            }
            
            else {
                NSLog(@"Cannot fetch data");
            }
        }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    MapFiltersViewController *filtersVC = [segue destinationViewController];
    
    filtersVC.arrayOfFilters = self.filterArguments;
    filtersVC.formerFoodTrucks = self.arrayOfFoodTrucks;
    
    [self.arrayOfAnnotations removeObject:self.mapView.userLocation];
    filtersVC.formerTruckAnnotations = self.arrayOfAnnotations;
}


@end
