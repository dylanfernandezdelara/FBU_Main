//
//  UserSignUpViewController.m
//  findfood
//
//  Created by dylanfdl on 7/12/21.
//

#import "UserSignUpViewController.h"
#import "Parse/Parse.h"

@interface UserSignUpViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *profilePhotoButton;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

@end

@implementation UserSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFUser *currUser =  [PFUser currentUser];
    if (currUser[@"fullName"] != nil && currUser[@"email"] != nil && currUser[@"Image"] != nil){
        
        self.nameField.text = currUser[@"fullName"];
        self.emailField.text = currUser[@"email"];
        
        PFFileObject *temp_file = currUser[@"Image"];
        [temp_file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                UIImage *thumbnailImage = [UIImage imageWithData:imageData];
                UIImageView *thumbnailImageView = [[UIImageView alloc] initWithImage:thumbnailImage];
            [self.profilePhotoButton setImage:thumbnailImageView.image forState:UIControlStateNormal];
            }];
    }
}

- (IBAction)saveNow:(UIButton *)sender {
    PFUser *currUser =  [PFUser currentUser];
    
    currUser[@"fullName"] = self.nameField.text;
    currUser[@"email"] = self.emailField.text;
    currUser[@"userType"] = @"generalUser";
    
    NSData *imageData = UIImagePNGRepresentation(self.profilePhotoButton.currentImage);
    PFFileObject *image = [PFFileObject fileObjectWithName:@"name.png" data:imageData];
    currUser[@"Image"] = image;
    
    [[PFUser currentUser] saveInBackground];
}

- (IBAction)selectPhotoNow:(UIButton *)sender {
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
    [self.profilePhotoButton setImage:temp forState:UIControlStateNormal];
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
