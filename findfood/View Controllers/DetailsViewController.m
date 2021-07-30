//
//  DetailsViewController.m
//  findfood
//
//  Created by dylanfdl on 7/13/21.
//

#import "DetailsViewController.h"
#import "SSBouncyButton/SSBouncyButton.h"
#import <ChameleonFramework/Chameleon.h>

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *roundedContainer;
@property (weak, nonatomic) IBOutlet UIImageView *detailsPhoto;

@property (weak, nonatomic) IBOutlet SSBouncyButton *contactButton;
@property (weak, nonatomic) IBOutlet SSBouncyButton *favoriteButton;

@property (weak, nonatomic) IBOutlet UILabel *truckNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

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


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"details";
    
    [self roundImageViewTopCorners];
    [self setContactFavoriteButtonUI];
    
    [self setTruckHoursLabels];
    
    [self loadDetailsPhoto];

}

- (void)loadDetailsPhoto {
    PFFileObject *tempFile = self.currentTruckViewed[@"detailsImage"];
    [tempFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            UIImage *thumbnailImage = [UIImage imageWithData:imageData];
            UIImageView *thumbnailImageView = [[UIImageView alloc] initWithImage:thumbnailImage];
            self.detailsPhoto.image = thumbnailImageView.image;
        }];
}

- (void)setTruckHoursLabels {
    PFUser *displayedTruck = self.currentTruckViewed;
    self.truckNameLabel.text = displayedTruck[@"fullName"];
    self.addressLabel.text = displayedTruck[@"streetName"];
    
    self.sunOpenLabel.text = displayedTruck[@"sunOpenTime"];
    self.monOpenLabel.text = displayedTruck[@"monOpenTime"];
    self.tueOpenLabel.text = displayedTruck[@"tueOpenTime"];
    self.wedOpenLabel.text = displayedTruck[@"wedOpenTime"];
    self.thuOpenLabel.text = displayedTruck[@"thuOpenTime"];
    self.friOpenLabel.text = displayedTruck[@"friOpenTime"];
    self.satOpenLabel.text = displayedTruck[@"satOpenTime"];
    self.sunOpenLabel.text = displayedTruck[@"sunOpenTime"];
    
    self.sunCloseLabel.text = displayedTruck[@"sunCloseTime"];
    self.monCloseLabel.text = displayedTruck[@"monCloseTime"];
    self.tueCloseLabel.text = displayedTruck[@"tueCloseTime"];
    self.wedCloseLabel.text = displayedTruck[@"wedCloseTime"];
    self.thuCloseLabel.text = displayedTruck[@"thuCloseTime"];
    self.friCloseLabel.text = displayedTruck[@"friCloseTime"];
    self.satCloseLabel.text = displayedTruck[@"satCloseTime"];
    self.sunCloseLabel.text = displayedTruck[@"sunCloseTime"];
}

- (void)setContactFavoriteButtonUI {
    self.contactButton.tintColor = [UIColor colorWithHexString:@"3B5B33"];
    self.favoriteButton.tintColor = [UIColor colorWithHexString:@"3B5B33"];
    
    self.contactButton.backgroundColor = [UIColor colorWithHexString:@"B6D2AF"];
    self.favoriteButton.backgroundColor = [UIColor colorWithHexString:@"B6D2AF"];
}

- (void)roundImageViewTopCorners {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.roundedContainer.bounds
                              byRoundingCorners:UIRectCornerTopLeft| UIRectCornerTopRight
                              cornerRadii:CGSizeMake(40.0, 40.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.roundedContainer.bounds;
    maskLayer.path = maskPath.CGPath;
    self.roundedContainer.layer.mask = maskLayer;
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
