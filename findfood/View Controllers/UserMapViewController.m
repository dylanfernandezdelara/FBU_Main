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
#import "DetailsViewController.h"
#import "SSBouncyButton.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define EARTHCIRUMFERENCE 4007500.0

@interface UserMapViewController ()<CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet SSBouncyButton *favoriteButton;
@property (assign, nonatomic) BOOL initiallyFavorited;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;

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

@property (weak, nonatomic) IBOutlet UILabel *sunLabel;
@property (weak, nonatomic) IBOutlet UILabel *monLabel;
@property (weak, nonatomic) IBOutlet UILabel *tueLabel;
@property (weak, nonatomic) IBOutlet UILabel *wedLabel;
@property (weak, nonatomic) IBOutlet UILabel *thuLabel;
@property (weak, nonatomic) IBOutlet UILabel *friLabel;
@property (weak, nonatomic) IBOutlet UILabel *satLabel;

@property (weak, nonatomic) IBOutlet UILabel *sunOpenLabel;
@property (weak, nonatomic) IBOutlet UILabel *monOpenLabel;
@property (weak, nonatomic) IBOutlet UILabel *tueOpenLabel;
@property (weak, nonatomic) IBOutlet UILabel *wedOpenLabel;
@property (weak, nonatomic) IBOutlet UILabel *thuOpenLabel;
@property (weak, nonatomic) IBOutlet UILabel *friOpenLabel;
@property (weak, nonatomic) IBOutlet UILabel *satOpenLabel;

@property (weak, nonatomic) IBOutlet UILabel *sunCloseLabel;
@property (weak, nonatomic) IBOutlet UILabel *monCloseLabel;
@property (weak, nonatomic) IBOutlet UILabel *tueCloseLabel;
@property (weak, nonatomic) IBOutlet UILabel *wedCloseLabel;
@property (weak, nonatomic) IBOutlet UILabel *thuCloseLabel;
@property (weak, nonatomic) IBOutlet UILabel *friCloseLabel;
@property (weak, nonatomic) IBOutlet UILabel *satCloseLabel;

@property (strong, nonatomic) PFUser *tappedTruck;

@property (strong, nonatomic) NSNumber *showLabels;
@property (strong, nonatomic) NSNumber *hideLabels;

@property (weak, nonatomic) IBOutlet UILabel *pressTruckForInfoLabel;

@property (weak, nonatomic) IBOutlet UIButton *moveToDetailsView;

@end

@implementation UserMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    self.mapView.delegate = self;
    
    self.favoriteButton.alpha = 0;
    [self.favoriteButton setTitle:@"favorite" forState:UIControlStateNormal];
    [self.favoriteButton setTitle:@"favorited" forState:UIControlStateSelected];
    self.favoriteButton.tintColor = UIColorFromRGB(0x3B5B33);
    
    self.favoriteCount.backgroundColor = UIColorFromRGB(0x3B5B33);
    self.favoriteCount.layer.cornerRadius = 5;
    self.favoriteCount.layer.masksToBounds = true;
    self.favoriteCount.alpha = 0;
    
    NSNumber *trueValue = [NSNumber numberWithBool:true];
    NSNumber *falseValue = [NSNumber numberWithBool:false];
    self.showLabels = trueValue;
    self.hideLabels = falseValue;
    
    [self setAlphaValuesForLabels:self.hideLabels];
    
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
        [self initFiltersArray_initAnnotationsArray_initTruckDict];
    }
    else {
        [self.mapView addAnnotations:self.arrayOfAnnotations];
    }

    [self initFavoriteTrucksArray];
    
    [self fetchFoodTrucks:self.filterArguments];
}

- (void)setAlphaValuesForLabels:(NSNumber*)shouldDisplay {
    
    self.favoriteButton.alpha = shouldDisplay.intValue;
    self.favoriteCount.alpha = shouldDisplay.intValue;

    self.sunLabel.alpha = shouldDisplay.intValue;
    self.monLabel.alpha = shouldDisplay.intValue;
    self.tueLabel.alpha = shouldDisplay.intValue;
    self.wedLabel.alpha = shouldDisplay.intValue;
    self.thuLabel.alpha = shouldDisplay.intValue;
    self.friLabel.alpha = shouldDisplay.intValue;
    self.satLabel.alpha = shouldDisplay.intValue;

    self.sunOpenLabel.alpha = shouldDisplay.intValue;
    self.monOpenLabel.alpha = shouldDisplay.intValue;
    self.tueOpenLabel.alpha = shouldDisplay.intValue;
    self.wedOpenLabel.alpha = shouldDisplay.intValue;
    self.thuOpenLabel.alpha = shouldDisplay.intValue;
    self.friOpenLabel.alpha = shouldDisplay.intValue;
    self.satOpenLabel.alpha = shouldDisplay.intValue;

    self.sunCloseLabel.alpha = shouldDisplay.intValue;
    self.monCloseLabel.alpha = shouldDisplay.intValue;
    self.tueCloseLabel.alpha = shouldDisplay.intValue;
    self.wedCloseLabel.alpha = shouldDisplay.intValue;
    self.thuCloseLabel.alpha = shouldDisplay.intValue;
    self.friCloseLabel.alpha = shouldDisplay.intValue;
    self.satCloseLabel.alpha = shouldDisplay.intValue;

    self.truckName.alpha = shouldDisplay.intValue;
    self.truckDescription.alpha = shouldDisplay.intValue;
    
    self.pressTruckForInfoLabel.alpha = !shouldDisplay.intValue;
    self.moveToDetailsView.alpha = shouldDisplay.intValue;
}

- (void)initFiltersArray_initAnnotationsArray_initTruckDict {
    
    NSMutableArray *initArrOfAnnotations = [[NSMutableArray alloc] init];
    NSMutableArray *initArrOfTrucks = [[NSMutableArray alloc] init];
    NSMutableDictionary *initDictOfTrucks = [[NSMutableDictionary alloc] init];
    
    self.arrayOfAnnotations = initArrOfAnnotations;
    self.arrayOfFoodTrucks = initArrOfTrucks;
    self.dictOfFoodTrucks = initDictOfTrucks;
    
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
    
    [defaultArguments addObject:[NSNumber numberWithInteger:0]];
    [defaultArguments addObject:[NSNumber numberWithInteger:0]];
    
    self.filterArguments = defaultArguments;
    
}

- (void)initFavoriteTrucksArray {
    
    PFUser *currUser = [PFUser currentUser];
    if (currUser[@"favoritedTrucks"] == nil){
        NSMutableArray *initFavorites = [[NSMutableArray alloc] init];
        self.favoritedTrucks = initFavorites;
    }
    else {
        self.favoritedTrucks = currUser[@"favoritedTrucks"];
    }
    
}

- (void)addTrucksArrayToDictionary:(NSMutableArray*)truckArr {
    for (int i = 0; i < truckArr.count; i++){
        
        PFUser *currTruck = truckArr[i];
        [self.dictOfFoodTrucks setObject:currTruck forKey:currTruck[@"fullName"]];
        
    }
}

- (void)removeTrucksArrayFromDictionary:(NSMutableArray*)truckArr {
    for (int i = 0; i < truckArr.count; i++){
        
        PFUser *currTruck = truckArr[i];
        [self.dictOfFoodTrucks removeObjectForKey:currTruck[@"fullName"]];
        
    }
}

- (void)setTextLabelsWhenTruckPressed: (PFUser*)pressedTruck {
    self.truckName.text = pressedTruck[@"fullName"];
    self.truckDescription.text = pressedTruck[@"truckDescription"];
    
    self.sunOpenLabel.text = pressedTruck[@"sunOpenTime"];
    self.monOpenLabel.text = pressedTruck[@"monOpenTime"];
    self.tueOpenLabel.text = pressedTruck[@"tueOpenTime"];
    self.wedOpenLabel.text = pressedTruck[@"wedOpenTime"];
    self.thuOpenLabel.text = pressedTruck[@"thuOpenTime"];
    self.friOpenLabel.text = pressedTruck[@"friOpenTime"];
    self.satOpenLabel.text = pressedTruck[@"satOpenTime"];

    self.sunCloseLabel.text = pressedTruck[@"sunCloseTime"];
    self.monCloseLabel.text = pressedTruck[@"monCloseTime"];
    self.tueCloseLabel.text = pressedTruck[@"tueCloseTime"];
    self.wedCloseLabel.text = pressedTruck[@"wedCloseTime"];
    self.thuCloseLabel.text = pressedTruck[@"thuCloseTime"];
    self.friCloseLabel.text = pressedTruck[@"friCloseTime"];
    self.satCloseLabel.text = pressedTruck[@"satCloseTime"];
    
    self.favoriteCount.text = [pressedTruck[@"favoriteCount"] stringValue];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    NSString *annotationClass = NSStringFromClass(view.annotation.class);
    if ([annotationClass isEqualToString:@"MKClusterAnnotation"]){
        
        MKClusterAnnotation *cluster = (MKClusterAnnotation*) view.annotation;
        [mapView showAnnotations:cluster.memberAnnotations animated:YES];
    
    }
    else {
        PFUser *pressedTruck = [self.dictOfFoodTrucks objectForKey:view.annotation.title];
        self.tappedTruck = pressedTruck;
        
        PFUser *loggedInUser = [PFUser currentUser];
        NSMutableArray *userFavorites = loggedInUser[@"favoritedTrucks"];
        
        if ([userFavorites containsObject:pressedTruck.objectId]){
            self.favoriteButton.selected = true;
            self.initiallyFavorited = true;
        }
        else {
            self.favoriteButton.selected = false;
            self.initiallyFavorited = false;
        }
        
        [self setAlphaValuesForLabels:self.showLabels];
        [self setTextLabelsWhenTruckPressed:pressedTruck];
    }
}

- (void)mapView:(MKMapView *)mapView
didDeselectAnnotationView:(MKAnnotationView *)view{
    
    [self setAlphaValuesForLabels:self.hideLabels];
    
    PFUser *loggedInUser = [PFUser currentUser];
    loggedInUser[@"favoritedTrucks"] = self.favoritedTrucks;
    [[PFUser currentUser] saveInBackground];
    
    PFUser *pressedTruck = [self.dictOfFoodTrucks objectForKey:view.annotation.title];
    NSNumber *newLikesCount = [NSNumber numberWithInteger:[self.favoriteCount.text integerValue]];
    NSDictionary *params = @{@"objectId" : pressedTruck.objectId,
                                @"favoriteCount" : newLikesCount};
    
    BOOL didInitialFavoritedValueChange = self.initiallyFavorited != self.favoriteButton.selected;
    
    if (self.favoriteButton.selected && didInitialFavoritedValueChange){
        [PFCloud callFunctionInBackground:@"incrementLikes" withParameters:params block:^(id object, NSError *error) {}];
    }
    else if (didInitialFavoritedValueChange){
        [PFCloud callFunctionInBackground:@"decrementLikes" withParameters:params block:^(id object, NSError *error) {}];
    }
}

- (IBAction)favoritePressed:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected){
        
        self.favoriteCount.text = @([self.favoriteCount.text integerValue]+1).stringValue ;
        self.tappedTruck[@"favoriteCount"] = [NSNumber numberWithInteger:[self.favoriteCount.text integerValue]];
        [self.favoritedTrucks addObject:self.tappedTruck.objectId];
        
    }
    else {
        
        self.favoriteCount.text = @([self.favoriteCount.text integerValue]-1).stringValue ;
        self.tappedTruck[@"favoriteCount"] = [NSNumber numberWithInteger:[self.favoriteCount.text integerValue]];
        [self.favoritedTrucks removeObject:self.tappedTruck.objectId];
        
    }
    
}

- (MKMarkerAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation.title isEqualToString:@"My Location"]){
        return nil;
    }
    
     MKMarkerAnnotationView *annotationView = (MKMarkerAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MKMarkerAnnotationView"];
     
    if (annotationView == nil) {
         annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MKMarkerAnnotationView"];
         annotationView.clusteringIdentifier = @"cluster";
     }
    
     annotationView.markerTintColor = UIColorFromRGB(0x3B5B33);
     annotationView.glyphImage = [UIImage imageNamed:@"truckMarker"];
    
     return annotationView;
 }

- (void)isMapDoneMoving:(UIGestureRecognizer*)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
         [self fetchFoodTrucks:self.filterArguments];
    }
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (NSMutableArray*)removeExcessTrucks:(NSArray*)upToDateTruckArray removeExcessIn:(NSMutableArray*)oldTruckArray{
    
    NSMutableDictionary *objectIDtoTruck = [[NSMutableDictionary alloc] init];
    NSMutableArray *trucksToBeRemoved = [[NSMutableArray alloc] init];
    self.annotationsToBeRemoved = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < upToDateTruckArray.count; i++){
        PFUser *currTruck = upToDateTruckArray[i];
        [objectIDtoTruck setObject:currTruck forKey:currTruck.objectId];
    }
    
    for (int i = 0; i < oldTruckArray.count; i++){
        PFUser *currTruck = oldTruckArray[i];
        
        if ( ![objectIDtoTruck objectForKey:currTruck.objectId] ){
            [trucksToBeRemoved addObject:oldTruckArray[i]];
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

- (void)fetchFoodTrucks:(NSArray*)filters {
    PFQuery *TruckQuery = [PFUser query];
    
    // 360 degress, 10000m zone
    long double degreeChangeFromCenter = 360.0 * 10000.0 / EARTHCIRUMFERENCE;

    // moving west increases long, moving south increases lat
    PFGeoPoint *southwestCorner = [PFGeoPoint geoPointWithLatitude:self.mapView.centerCoordinate.latitude + degreeChangeFromCenter longitude:self.mapView.centerCoordinate.longitude + degreeChangeFromCenter];

    PFGeoPoint *northwestCorner = [PFGeoPoint geoPointWithLatitude:self.mapView.centerCoordinate.latitude - degreeChangeFromCenter longitude:self.mapView.centerCoordinate.longitude - degreeChangeFromCenter];

    [TruckQuery whereKey:@"truckLocation" withinGeoBoxFromSouthwest:southwestCorner toNortheast:northwestCorner];
    
    NSNumber *trueValue = [NSNumber numberWithBool:true];
    
    if ([filters objectAtIndex:0] == trueValue){
        [TruckQuery whereKey:@"pizzaType" equalTo:trueValue];
    }
    if ([filters objectAtIndex:1] == trueValue){
        [TruckQuery whereKey:@"bbqType" equalTo:trueValue];
    }
    if ([filters objectAtIndex:2] == trueValue){
        [TruckQuery whereKey:@"brunchType" equalTo:trueValue];
    }
    if ([filters objectAtIndex:3] == trueValue){
        [TruckQuery whereKey:@"mexicanType" equalTo:trueValue];
    }
    if ([filters objectAtIndex:4] == trueValue){
        [TruckQuery whereKey:@"seafoodType" equalTo:trueValue];
    }
    if ([filters objectAtIndex:5] == trueValue){
        [TruckQuery whereKey:@"sandwichesType" equalTo:trueValue];
    }
    if ([filters objectAtIndex:6] == trueValue){
        [TruckQuery orderByDescending:@"favoriteCount"];
        TruckQuery.limit = 20;
    }
    
    NSNumber *priceLevel = [self.filterArguments objectAtIndex:7];
    [TruckQuery whereKey:@"priceLevel" equalTo:priceLevel];
    
    [TruckQuery whereKey:@"userType" equalTo:@"FoodTruck"];
    [TruckQuery includeKey:@"author"];

    [TruckQuery findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> * _Nullable users, NSError * _Nullable error) {
            if (users) {
                if (![users isEqualToArray:self.arrayOfFoodTrucks]){
                    
                    if (users.count < self.arrayOfFoodTrucks.count){
                        
                        NSMutableArray *trucksToRemove = [self.arrayOfFoodTrucks mutableCopy];
                        trucksToRemove = [self removeExcessTrucks:users removeExcessIn:trucksToRemove];
                        [self findAndRemoveAnnotations];
                        [self.arrayOfFoodTrucks removeObjectsInArray:trucksToRemove];
                        [self removeTrucksArrayFromDictionary:trucksToRemove];
                        self.arrayOfAnnotations = [self.mapView.annotations mutableCopy];
                        
                    }
                    
                    else if (users.count > self.arrayOfFoodTrucks.count){
                        
                        NSMutableArray *trucksToAdd = [users mutableCopy];
                        [trucksToAdd removeObjectsInArray:self.arrayOfFoodTrucks];
                        [self.arrayOfFoodTrucks addObjectsFromArray:trucksToAdd];
                        [self addTrucksArrayToDictionary:trucksToAdd];
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
    
    if ([segue.identifier isEqualToString:@"toFilters"]){
        MapFiltersViewController *filtersVC = [segue destinationViewController];
        
        filtersVC.arrayOfFilters = self.filterArguments;
        filtersVC.formerFoodTrucks = self.arrayOfFoodTrucks;
        filtersVC.formerFavoritedTrucks = self.favoritedTrucks;
        filtersVC.formerDictOfFoodTrucks = self.dictOfFoodTrucks;
        
        [self.arrayOfAnnotations removeObject:self.mapView.userLocation];
        filtersVC.formerTruckAnnotations = self.arrayOfAnnotations;
    }
    
    else if ([segue.identifier isEqualToString:@"toDetailsView"]){
        DetailsViewController *detailsVC = [segue destinationViewController];
        detailsVC.currentTruckViewed = self.tappedTruck;
    }
}


@end
