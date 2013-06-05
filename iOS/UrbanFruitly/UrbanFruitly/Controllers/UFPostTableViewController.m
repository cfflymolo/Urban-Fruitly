//
//  UFPostTableViewController.m
//  UrbanFruitly
//
//  Created by Robert Colin on 6/1/13.
//
//

#import "UFPostTableViewController.h"
#import "UKImage.h"
#import "MBProgressHUD.h"
#import "GradientButton.h"
#import <Parse/Parse.h>

#define TYPE_PICKERVIEW_HEIGHT 180

@interface UFPostTableViewController () <UIPickerViewDataSource,UIPickerViewDelegate>
{
    CGRect originalPickerFrame;
    MBProgressHUD* progressHud;
    BOOL useGPS;
}
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UITextField *productTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;

@property (weak, nonatomic) IBOutlet UITextField *expirationTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@property (weak, nonatomic) IBOutlet UIButton *gpsLocationButton;

@property (weak, nonatomic) IBOutlet UIButton *postButton;

@property (weak, nonatomic) IBOutlet UIButton *selectPhotoButton;


@property (strong, nonatomic) NSArray *expirationDurations;
@property (strong, nonatomic) UIPickerView *expirationPickerView;
@end

@implementation UFPostTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    useGPS = false;
    
    originalPickerFrame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width ,TYPE_PICKERVIEW_HEIGHT);
    
    self.expirationPickerView = [[UIPickerView alloc] initWithFrame:originalPickerFrame];
    self.expirationPickerView.delegate = self;
    
    UIView* topView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    [topView addSubview:self.expirationPickerView];
    
    self.expirationDurations = @[@"1 Week", @"2 Weeks", @"3 Weeks",@"4 Weeks", @"5 Weeks", @"6 Weeks",@"7 Weeks", @"8 Weeks"];
    self.expirationTextField.enabled = NO;
    
    self.priceTextField.delegate = self;
    self.quantityTextField.delegate = self;
    self.addressTextField.delegate = self;
    
    [self setAppearance];
    
    self.addressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==0){

    }
//    else if (indexPath.section == 1 && indexPath.row == 0) {
//        [UIView animateWithDuration:0.5 animations:^{
//            CGRect frame = self.typePickerView.frame;
//            self.typePickerView.frame = CGRectMake(frame.origin.x, frame.origin.y-TYPE_PICKERVIEW_HEIGHT, UIScreen.mainScreen.bounds.size.width, TYPE_PICKERVIEW_HEIGHT);
//        }];
//    }
    else if (indexPath.section == 1 && indexPath.row == 3) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = originalPickerFrame;
            self.expirationPickerView.frame = CGRectMake(frame.origin.x, frame.origin.y-TYPE_PICKERVIEW_HEIGHT, UIScreen.mainScreen.bounds.size.width, TYPE_PICKERVIEW_HEIGHT);
        }];
    }

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex==0){
        NSLog(@"Pick from album");
        [self pickPhotoFromAlbum];
    }
    else if(buttonIndex==1){
        NSLog(@"Pick from Camera");
        [self takePicture];
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.expirationDurations.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    return self.expirationDurations[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [UIView animateWithDuration:0.5f animations:^{
        pickerView.frame = originalPickerFrame;
    }];
    
    self.expirationTextField.text = self.expirationDurations[row];
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    UITableViewCell *cell = (UITableViewCell*) [[textField superview] superview];
    [(UITableView*)self.view scrollToRowAtIndexPath:[(UITableView*)self.view indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Photo Picker Methods

- (void)takePicture{
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = (id)self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentModalViewController:imagePicker animated:YES];
}

- (void)pickPhotoFromAlbum{
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = (id)self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentModalViewController:imagePicker animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void) imagePickerController:(UIImagePickerController*) picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if(image==nil)
        return;
    
    CGSize smallSize = CGSizeMake(image.size.width/4.0, image.size.height/4.0);
    UIImage* smallImage = [image scaleImageToSize:smallSize];
    //set image
    self.productImageView.image = smallImage;
    self.productImageView.contentMode = UIViewContentModeScaleAspectFit;
}


#pragma mark - Storyboard methods

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"Segue Id: %@",segue.identifier);
    if([segue.identifier isEqualToString:@"ChooseProduceType"]){
        UFProductSelectionTableViewController* vc = segue.destinationViewController;
        vc.delegate = self;
    }
}


#pragma mark UFProductSelectionTableViewControllerDelegate methods

- (void)productTypeSelected:(NSString *)type{
    self.productTypeTextField.text = type;
}



#pragma mark - Cloud Methods

- (void) saveProfileToTheCloud{
    
    //set Image
    NSData *imageData = UIImageJPEGRepresentation(self.productImageView.image, 0.05f);
    PFFile *imageFile = [PFFile fileWithName:@"ProductImage.jpg" data:imageData];
    
    progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //Save Image object
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {

            [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
                if (!error) {
                    [self saveProfileToTheCloudAfterImageFileUpload:imageFile withLocation:geoPoint];
                }
            }];
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        progressHud.progress = (float)percentDone/100;
    }];
}

- (void) saveProfileToTheCloudAfterImageFileUpload:(PFFile*)imageFile withLocation:(PFGeoPoint*)geoPoint{
    PFUser* currentUser = [PFUser currentUser];
    if(!currentUser)
        return;
    
    PFObject* prodObj = [PFObject objectWithClassName:@"Product"];

    
    [prodObj setObject:imageFile forKey:@"image"];
    
    // Set the access control list to current user for security purposes
    //prodObj.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    //[prodObj.ACL setPublicReadAccess:YES];
    
    //Set values in the object
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * quantity = [f numberFromString:self.quantityTextField.text];
    NSNumber * price = [f numberFromString:self.priceTextField.text];
    
    [prodObj setObject:geoPoint forKey:@"location"];
    [prodObj setObject:quantity forKey:@"quantity"];
    [prodObj setObject:price forKey:@"price"];
    [prodObj setObject:self.productTypeTextField.text forKey:@"type"];
    [prodObj setObject:[PFUser currentUser] forKey:@"user"];
    
    [prodObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(succeeded){
       //     NSLog(@"Obect ID: %@",profileObj.objectId);
            //  [UserDataModel setProfileObjectId:profileObj.objectId];
        }
        else{
            //handle error
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle: @"Problem Occured"
                                      message: @"Could not save the profile info. Please try later."
                                      delegate: nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
    }];
}



- (IBAction)postData:(id)sender {
    [self saveProfileToTheCloud];
}

- (IBAction)selectPhotoButtonTapped:(id)sender {
    NSString *actionSheetTitle = @"Select Photo"; //Action Sheet Title
    NSString *other1 = @"From Album";
    NSString *other2 = @"Take Picture";
    NSString *cancelTitle = @"Cancel";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, other2, nil];
    [actionSheet showInView:[self.view window]];
}

- (IBAction)gpsLocationButtonTapped:(id)sender {
    useGPS = YES;
    self.addressTextField.text = @"Using GPS Location";
}

#pragma mark - Appearance methods

- (void) setAppearance{
    UIImage* gpsButtonImage = [UIImage imageNamed:@"whiteButtonHighlight"];
    gpsButtonImage = [gpsButtonImage resizableImageWithCapInsets:UIEdgeInsetsMake(18,18,18,18)];
    [self.gpsLocationButton setBackgroundImage:gpsButtonImage forState:UIControlStateNormal];

    UIImageView* iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    iconView.image = [UIImage imageNamed:@"74-location"];
    [self.gpsLocationButton addSubview:iconView];
    
    UIImageView* tableBgView = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
    tableBgView.image = [[UIImage imageNamed:@"squairy_light"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
    self.tableView.backgroundView = tableBgView;
    
    //post button
    UIImage* greenButtonImage = [[UIImage imageNamed:@"greenButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(18,18,18,18)];
//    UIImage* greenButtonHighlightImage = [[UIImage imageNamed:@"greenButtonHighlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(18,18,18,18)];
    [self.postButton setBackgroundImage:greenButtonImage forState:UIControlStateNormal];
//    [self.postButton setBackgroundImage:greenButtonHighlightImage forState:UIControlStateHighlighted];
    
    //photo button
    UIImage* whiteButtonImage = [[UIImage imageNamed:@"whiteButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(18,18,18,18)];
    [self.selectPhotoButton setBackgroundImage:whiteButtonImage forState:UIControlStateNormal];
    
    
}

@end
