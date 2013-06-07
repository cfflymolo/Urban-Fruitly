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
    BOOL descriptionKeyboardVisible;
    PFGeoPoint* myGeoLocation;
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
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;


@property (strong, nonatomic) NSArray *expirationDurations;
@property (strong, nonatomic) UIPickerView *expirationPickerView;
@end

@implementation UFPostTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    useGPS = NO;
    descriptionKeyboardVisible = NO;
    myGeoLocation = nil;
    self.productToUpdate = nil;
    
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
    self.descriptionTextView.delegate = self;
    //add tap gesture to table view
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapped:)];
    [self.tableView addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer* pickerViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapped:)];
    [self.expirationPickerView addGestureRecognizer:pickerViewTapGesture];
    
    //
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:2];
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:index];
    self.descriptionTextView.backgroundColor = cell.backgroundColor;
    self.productImageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)updateUIForProduct:(UFProduct*)product{
    if(!product)
        return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(product.image){
            self.productImageView.image = product.image;
        }
        self.productTypeTextField.text = product.productType;
        self.priceTextField.text = [NSString stringWithFormat:@"%f",product.price.floatValue];
        self.quantityTextField.text = [NSString stringWithFormat:@"%d",product.quantity.intValue];
        self.descriptionTextView.text = product.description;
        self.postButton.titleLabel.text = @"Update";
        [self.postButton setTitle:@"Update" forState:UIControlStateNormal];
        
        self.navigationItem.title = @"Update Post";
    });

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


}

#pragma mark - Gesture handlers

- (void) tableViewTapped:(UITapGestureRecognizer*)recognizer{
    // if(descriptionKeyboardVisible)
    [self.descriptionTextView resignFirstResponder];
    
    CGPoint tapLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:tapLocation];

    if (indexPath.section == 1 && indexPath.row == 0) {
        [self performSegueWithIdentifier:@"ChooseProduceType" sender:nil];
    }
    else if (indexPath.section == 1 && indexPath.row == 3) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = originalPickerFrame;
            self.expirationPickerView.frame = CGRectMake(frame.origin.x, frame.origin.y-TYPE_PICKERVIEW_HEIGHT, UIScreen.mainScreen.bounds.size.width, TYPE_PICKERVIEW_HEIGHT);
        }];
    }
}

#pragma mark -

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section==2){
        // Create label with section title
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(10, 0, 284, 23);
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont fontWithName:@"Georgia" size:16];
        label.text = @"Description";
        label.backgroundColor = [UIColor clearColor];
        
        // Create header view and add label as a subview
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        [view addSubview:label];
        
        return view;
    }
    return nil;
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

#pragma mark - PickerView Delegate methods

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
    self.expirationTextField.text = self.expirationDurations[row];
}

- (void)pickerViewTapped:(UITapGestureRecognizer*)recognizer{
    [UIView animateWithDuration:0.5f animations:^{
        self.expirationPickerView.frame = originalPickerFrame;
    }];
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

#pragma mark - UITextViewDelegate Methods


- (void)textViewDidBeginEditing:(UITextView *)textView{
    descriptionKeyboardVisible = YES;
    UITableViewCell *cell = (UITableViewCell*) [[textView superview] superview];
    [(UITableView*)self.view scrollToRowAtIndexPath:[(UITableView*)self.view indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    descriptionKeyboardVisible = NO;
}

#pragma mark - Photo Picker Methods

- (void)takePicture{
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = (id)self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)pickPhotoFromAlbum{
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = (id)self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imagePicker animated:YES completion:nil];    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController*) picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if(image==nil)
        return;
    
    CGSize smallSize = CGSizeMake(image.size.width/4.0, image.size.height/4.0);
    UIImage* smallImage = [image scaleImageToSize:smallSize];
    //set image
    self.productImageView.image = smallImage;
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

- (BOOL) validateForm{
    if(self.productImageView.image==nil){
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle: @"Form Error"
                                  message: @"Please provide photo"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    //check location
    if(useGPS==NO && (self.addressTextField.text == nil || self.addressTextField.text.length == 0) ){
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle: @"Form Error"
                                  message: @"Please enter Valid Address (Street Number and Name,City,Zip)"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    if(self.productTypeTextField.text == nil || self.productTypeTextField.text.length==0){
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle: @"Form Error"
                                  message: @"Please select the fruit type"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    NSString* price  = self.priceTextField.text;
    if(price==nil){
        price = @"0";
    }
    NSScanner* priceScanner = [NSScanner scannerWithString:price];
    if (!([priceScanner scanFloat:nil] || [priceScanner scanInt:nil]))
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle: @"Form Error"
                                  message: @"Please enter valid price"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    if(self.expirationTextField.text==nil || self.expirationTextField.text.length==0){
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle: @"Form Error"
                                  message: @"Please enter expiration duration"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    NSString* quantity  = self.quantityTextField.text;

    NSScanner* quantityScanner = [NSScanner scannerWithString:quantity];
    if ([quantityScanner scanInt:nil]==NO)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle: @"Form Error"
                                  message: @"Please enter valid quantity"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    return YES;
}

- (IBAction)postData:(id)sender {
    if([self validateForm]){
        progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if(useGPS){
            [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
                if (!error) {
                    myGeoLocation = geoPoint;
                    [self postItemToTheCloud];
                }
            }];
        }
        else{
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder geocodeAddressString:self.addressTextField.text completionHandler:^(NSArray* placemarks, NSError* error){
                if(!error){
                    CLPlacemark* placemark = placemarks[0];
                    myGeoLocation = [PFGeoPoint geoPointWithLocation:placemark.location];
                    NSLog(@"GeoCoded Location : %f %f",myGeoLocation.latitude,myGeoLocation.longitude);
                    [self postItemToTheCloud];
                }
                else{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle: @"Problem Posting"
                                              message: @"Address not found. Please enter complete address or try later"
                                              delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    return ;
                }
            }];
        }
    }
}


- (void) postItemToTheCloud{
    
    //set Image
    NSData *imageData = UIImageJPEGRepresentation(self.productImageView.image, 0.05f);
    PFFile *imageFile = [PFFile fileWithName:@"ProductImage.jpg" data:imageData];

    //Save Image object
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self postItemToTheCloudAfterImageFileUpload:imageFile withLocation:myGeoLocation];
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

- (void) postItemToTheCloudAfterImageFileUpload:(PFFile*)imageFile withLocation:(PFGeoPoint*)geoPoint{
    PFUser* currentUser = [PFUser currentUser];
    if(!currentUser)
        return;
    
    PFObject* prodObj = [PFObject objectWithClassName:@"Product"];

    
    [prodObj setObject:imageFile forKey:@"image"];
    
    // Set the access control list to current user for security purposes
    prodObj.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [prodObj.ACL setPublicReadAccess:YES];
    
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
            [self.navigationController popViewControllerAnimated:YES];
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
