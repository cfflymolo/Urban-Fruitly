//
//  UFPostTableViewController.m
//  UrbanFruitly
//
//  Created by Robert Colin on 6/1/13.
//
//

#import "UFPostTableViewController.h"

#define TYPE_PICKERVIEW_HEIGHT 180

@interface UFPostTableViewController () <UIPickerViewDataSource,UIPickerViewDelegate>
{
    CGRect originalPickerFrame;
}
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *expirationTextField;

@property (strong, nonatomic) NSArray *productTypes;
@property (strong, nonatomic) NSArray *expirationDurations;
@property (strong, nonatomic) UIPickerView *typePickerView;
@property (strong, nonatomic) UIPickerView *expirationPickerView;
@end

@implementation UFPostTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    originalPickerFrame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width ,TYPE_PICKERVIEW_HEIGHT);
    
    self.typePickerView = [[UIPickerView alloc] initWithFrame:originalPickerFrame];
    self.expirationPickerView = [[UIPickerView alloc] initWithFrame:originalPickerFrame];
    
    self.typePickerView.dataSource = self.expirationPickerView.dataSource = self;
    self.typePickerView.delegate = self.expirationPickerView.delegate = self;
    
    
    UIView* topView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    [topView addSubview:self.typePickerView];
    [topView addSubview:self.expirationPickerView];
    
    self.productTypes = @[@"Apple", @"Oranges", @"Avacado"];
    self.expirationDurations = @[@"1 Week", @"2 Weeks", @"3 Weeks"];
    self.typeTextField.enabled = NO;
    self.expirationTextField.enabled = NO;
    
    self.priceTextField.delegate = self;
    self.quantityTextField.delegate = self;
    self.descriptionTextField.delegate = self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==0){
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
        [actionSheet showInView:self.view];
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.typePickerView.frame;
            self.typePickerView.frame = CGRectMake(frame.origin.x, frame.origin.y-TYPE_PICKERVIEW_HEIGHT, UIScreen.mainScreen.bounds.size.width, TYPE_PICKERVIEW_HEIGHT);
        }];
    }
    else if (indexPath.section == 1 && indexPath.row == 2) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.expirationPickerView.frame;
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
    if(pickerView == self.typePickerView)
        return self.productTypes.count;
    return self.expirationDurations.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == self.typePickerView)
        return self.productTypes [row];
    
    return self.expirationDurations [row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [UIView animateWithDuration:0.5f animations:^{
        pickerView.frame = originalPickerFrame;
    }];
    
    if(pickerView == self.typePickerView)
        self.typeTextField.text = self.productTypes [row];
    else{
        self.expirationTextField.text = self.expirationDurations[row];
    }
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


@end
