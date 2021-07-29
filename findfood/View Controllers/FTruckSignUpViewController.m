//
//  FTruckSignUpViewController.m
//  findfood
//
//  Created by dylanfdl on 7/12/21.
//

#import "FTruckSignUpViewController.h"
#import "Parse/Parse.h"
#import <ChameleonFramework/Chameleon.h>

@interface FTruckSignUpViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *profilePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *detailsPhotoButton;
@property (weak, nonatomic) IBOutlet UITextField *foodTruckNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (nonatomic) bool enabled;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@end

@implementation FTruckSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFUser *currUser =  [PFUser currentUser];
    if (currUser[@"fullName"] != nil && currUser[@"email"] != nil && currUser[@"truckDescription"] != nil && currUser[@"Image"] != nil && currUser[@"detailsImage"] != nil){
        
        PFFileObject *temp_file = currUser[@"Image"];
        [temp_file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                UIImage *thumbnailImage = [UIImage imageWithData:imageData];
                UIImageView *thumbnailImageView = [[UIImageView alloc] initWithImage:thumbnailImage];
            [self.profilePhotoButton setImage:thumbnailImageView.image forState:UIControlStateNormal];
            }];
        
        PFFileObject *details_file = currUser[@"detailsImage"];
        [details_file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                UIImage *thumbnailImage = [UIImage imageWithData:imageData];
                UIImageView *thumbnailImageView = [[UIImageView alloc] initWithImage:thumbnailImage];
            [self.detailsPhotoButton setImage:thumbnailImageView.image forState:UIControlStateNormal];
            }];
        
        self.foodTruckNameField.text = currUser[@"fullName"];
        self.emailField.text = currUser[@"email"];
        self.descriptionField.text = currUser[@"truckDescription"];
        [self.locationButton setTitle:currUser[@"streetName"] forState:UIControlStateNormal];
        
    }
    
    self.profilePhotoButton.layer.cornerRadius = 5;
    self.profilePhotoButton.layer.masksToBounds = true;
    self.profilePhotoButton.backgroundColor = [UIColor colorWithHexString:@"3B5B33"];
    
    self.detailsPhotoButton.layer.cornerRadius = 5;
    self.detailsPhotoButton.layer.masksToBounds = true;
    self.detailsPhotoButton.backgroundColor = [UIColor colorWithHexString:@"3B5B33"];
    
    self.saveButton.layer.cornerRadius = 5;
    self.saveButton.layer.masksToBounds = true;
    self.saveButton.backgroundColor = [UIColor colorWithHexString:@"B6D2AF"];
    self.saveButton.tintColor = [UIColor colorWithHexString:@"3B5B33"];
    
}

- (IBAction)saveNow:(UIButton *)sender {
    PFUser *currUser =  [PFUser currentUser];
    currUser[@"fullName"] = self.foodTruckNameField.text;
    currUser[@"email"] = self.emailField.text;
    currUser[@"userType"] = @"FoodTruck";
    currUser[@"truckDescription"] = self.descriptionField.text;
    NSData *imageData = UIImagePNGRepresentation(self.profilePhotoButton.currentImage);
    PFFileObject *image = [PFFileObject fileObjectWithName:@"profilePhoto.png" data:imageData];
    currUser[@"Image"] = image;
    NSData *detailsImageData = UIImagePNGRepresentation(self.detailsPhotoButton.currentImage);
    PFFileObject *detailsImage = [PFFileObject fileObjectWithName:@"detailsPhoto.png" data:detailsImageData];
    currUser[@"detailsImage"] = detailsImage;
    [[PFUser currentUser] saveInBackground];
}

- (IBAction)selectProfilePhotoNow:(UIButton *)sender {
    self.enabled = true;
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)selectDetailsPhotoNow:(UIButton *)sender {
    self.enabled = false;
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    CGSize temp_size = CGSizeMake(600, 600);
    UIImage *temp = [self resizeImage:editedImage withSize:temp_size];
    if (self.enabled == true){
        [self.profilePhotoButton setImage:temp forState:UIControlStateNormal];
    }
    else if (self.enabled == false){
        [self.detailsPhotoButton setImage:temp forState:UIControlStateNormal];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
