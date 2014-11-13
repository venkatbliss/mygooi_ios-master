//
//  BusinessAddEditView.m
//  MyGooi
//
//  Created by Vijayakumar on 07/10/14.
//  Copyright (c) 2014 Vijayakumar. All rights reserved.
//

#import "BusinessAddEditView.h"
#import <AddressBook/AddressBook.h>
#import <CoreLocation/CoreLocation.h>
#import "Confic.h"
#import "CLUploadService.h"
#import "ImageCropViewController.h"
@interface BusinessAddEditView ()<UIActionSheetDelegate,CLLocationManagerDelegate,UIScrollViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIAlertViewDelegate,CropImageDelegate>
{
    
    IBOutlet UITextField *Name,*email,*businessname,*aboutus
    ,*company,*jobtitle,*address,*phone_no,*website;
    IBOutlet UIScrollView *scroll;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIImageView *profileImg;
    IBOutlet UIButton *btnBack;
    
    AFHTTPClient    *_httpClient;
    
    CLLocationManager *locationManager;
    NSString *strImageURL;
    BOOL isImgageChanged;
    UIImage *selectedImage;
    NSString *strLatitude,*strLongtitude;
}
@end

@implementation BusinessAddEditView

- (void)viewDidLoad {
    Name.placeholder=NSLocalizedStringFromTable(@"* Name", @"InfoPlist", @"");
    email.placeholder=NSLocalizedStringFromTable(@"* Email", @"InfoPlist", @"");
    
    jobtitle.placeholder=NSLocalizedStringFromTable(@"* Job Title", @"InfoPlist", @"");
    company.placeholder=NSLocalizedStringFromTable(@"* Company", @"InfoPlist", @"");
    address.placeholder=NSLocalizedStringFromTable(@"* Address", @"InfoPlist", @"");
    businessname.placeholder=NSLocalizedStringFromTable(@"* Business Name", @"InfoPlist", @"");
    aboutus.placeholder=NSLocalizedStringFromTable(@"* About Us", @"InfoPlist", @"");
    phone_no.placeholder=NSLocalizedStringFromTable(@"* Cell Phone", @"InfoPlist", @"");
    website.placeholder=NSLocalizedStringFromTable(@"* Website", @"InfoPlist", @"");
    
    
     // [self startSignificantChangeUpdates];
    isImgageChanged=NO;
    [scroll setContentSize:CGSizeMake(0,self.view.frame.size.height+300)];
    //[self getProfileDetails];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


/***
 Method Name : setProfileValue
 Input Parameter : Dictionary
 Return Type : nil
 Method Description : set Profile details from Dictionary (NSDictionary details getProfileDetails func to  API)
 ***/
/*
-(void)setBusinessProfileValue:(NSDictionary*)dic
{
    @try {
        
        Name.text=[Confic stringEmptyValue:[dic valueForKey:@"name"]];
        email.text=[Confic stringEmptyValue:[dic valueForKey:@"email_id"]];
        businessname.text=[Confic stringEmptyValue:[dic valueForKey:@"business_name"]];
        aboutus.text=[Confic stringEmptyValue:[dic valueForKey:@"about_us"]];
        
        jobtitle.text=[Confic stringEmptyValue:[dic valueForKey:@"jobtitle"]];
        company.text=[Confic stringEmptyValue:[dic valueForKey:@"company"]];
        address.text=[Confic stringEmptyValue:[dic valueForKey:@"address"]];
     
        phone_no.text=[Confic stringEmptyValue:[dic valueForKey:@"phone_number"]];
        website.text=[Confic stringEmptyValue:[dic valueForKey:@"website"]];
        strImageURL=[Confic stringEmptyValue:[dic valueForKey:@"image_url"]];
        
        if(Name.text.length!=0 && email.text.length!=0  && businessname.text.length!=0  && aboutus.text.length!=0  && company.text.length!=0  && jobtitle.text.length!=0  && address.text.length!=0  && phone_no.text.length!=0  &&   website.text.length!=0  && strImageURL.length!=0 )
        {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:k_PROFILE_UPDATE];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        [profileImg setImageWithURL:[NSURL URLWithString:strImageURL] placeholderImage:[UIImage imageNamed:@"placeHolderCamera.png"]];
        [[NSUserDefaults standardUserDefaults] setObject:strImageURL forKey:@"image_url"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:k_PROFILE_IMAGE_CHANGE_NOTIFICATION object:nil];
        
    }
    @catch (NSException *exception) {
        [ErrorReport sendErrorReport:NSStringFromClass([self class]) Method:[NSString stringWithFormat:@"%s",__FUNCTION__] Exception:exception];
    }
}
 
#pragma mark auto scroll for textfeild edit

/***
 Method Name : scrollViewAdaptToStartEditingTextField
 Input Parameter : textField
 Return Type : nil
 Method Description : when user click the textField set ContentOffset from scrollview
 ***/
- (void) scrollViewAdaptToStartEditingTextField:(UITextField*)textField
{
    CGPoint point = CGPointMake(0, textField.frame.origin.y - 1.5 * textField.frame.size.height);
    [scroll setContentOffset:point animated:YES];
}

/***
 Method Name : scrollVievEditingFinished
 Input Parameter : textField
 Return Type : nil
 Method Description : when user complete the profile creation section to set ContentOffset from scrollview (0,0) superview coordinate
 ***/
- (void) scrollVievEditingFinished:(UITextField*)textField
{
    CGPoint point = CGPointMake(0, 0);
    [scroll setContentOffset:point animated:YES];
}

#pragma mark - Textfield Delegate

/***
 Method Name : textFieldShouldBeginEditing (Default Delegate Method)
 Input Parameter : textField
 Return Type : nil
 Method Description : when user click textfiled which kind of keyboard should be appear                            on view
 ***/
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    [scroll setContentSize:CGSizeMake(0,self.view.frame.size.height+550)];
    textField.keyboardType=UIKeyboardTypeDefault;
    textField.background=[UIImage imageNamed:@"blue_button.png"];
    if(textField==phone_no)
    {
        textField.keyboardType=UIKeyboardTypePhonePad;
    }
    [self scrollViewAdaptToStartEditingTextField:textField];
    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.background=[UIImage imageNamed:@"texfieldBackground"];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    int limit=20;
    
    if(textField.tag==21 || textField.tag==22){
        if (range.location >= limit && range.length == 0){
            
            [textField resignFirstResponder];
            
            NSString *errorMsg=[[NSString alloc] initWithFormat:TEST_VALIDATION_ERROR, limit];
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Limit" message:errorMsg delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
            [alert show];
            
            return NO; // return NO to not change text
        }
    }
       return YES;
    
}
/***
 Method Name : textFieldShouldReturn (Default Delegate Method)
 Input Parameter : textField
 Return Type : nil
 Method Description : when user click return button on keyboard automatically changed below textfied using becomeFirstResponder. if user complete or ignore webite textfield automatically submit from API
 ***/
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nexttag=textField.tag+1;
    
    UIResponder *nextresponder=[textField.superview viewWithTag:nexttag];
    
    if (nextresponder)
    {
        [nextresponder becomeFirstResponder];
    }else
    {
        [textField resignFirstResponder];
    }
    return NO;
    
}

#pragma mark - Action delegate
/***
 Method Name : actionSheet:clickedButtonAtIndex (Default Delegate Method)
 Input Parameter : actionSheet , Integer
 Return Type : nil
 Method Description : when user click actionSheet Button if buttonIndex = 1  should be appear the imagepickerviewcontroller
 ***/
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    @try {
        
        UIImagePickerController *picker;
        
        if(buttonIndex == 0)
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self presentViewController:picker animated:YES completion:Nil];
            }
            
        }else  if(buttonIndex ==1)
        {
            picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:Nil];
        }
        
    }
    @catch (NSException *exception) {
        [ErrorReport sendErrorReport:NSStringFromClass([self class]) Method:[NSString stringWithFormat:@"%s",__FUNCTION__] Exception:exception];
    }
}

#pragma mark - ImagePicker delegate

/***
 Method Name : imagePickerController:didFinishPickingMediaWithInfo (Default Delegate Method)
 Input Parameter : picker , Dictionary
 Return Type : nil
 Method Description : when user select image using imagepicker . image convert into nsdata and upload it S3 Amazon
 ***/

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    @try{
        isImgageChanged=YES;
        UIImage *image=[info valueForKey:UIImagePickerControllerOriginalImage];
        
        selectedImage = image;
        
        ImageCropViewController *imageCrop = [[ImageCropViewController alloc]init];
        imageCrop.delegate = self;
        imageCrop.image = image;
        [imageCrop presentViewControllerAnimated:YES];
        
        [picker dismissViewControllerAnimated:NO completion:nil];
        
    }
    @catch (NSException *exception) {
        [ErrorReport sendErrorReport:NSStringFromClass([self class]) Method:[NSString stringWithFormat:@"%s",__FUNCTION__] Exception:exception];
        
    }
    
}
/***
 Method Name : imagePickerControllerDidCancel (Default Delegate Method)
 Input Parameter : picker
 Return Type : nil
 Method Description : when user click cancel button dismiss picerviewController
 ***/
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:Nil];
    
}
#pragma mark Crop
/***
 Method Name : imageCropFinished (Custom Delegate Method)
 Input Parameter : UIImage
 Return Type : nil
 Method Description : when user croped image this delegate excute
 ***/
-(void)imageCropFinished:(UIImage *)image
{
    profileImg.image=image;
}
/***
 Method Name : uploadImagetoS3
 Input Parameter : nil
 Return Type : nil
 Method Description : upload image  into s3 amazon
 ***/
-(void)uploadImagetoS3
{
    
    @try{
        // Convert the image to JPEG data.
        NSData *imageData = UIImageJPEGRepresentation(profileImg.image,1);
        
        CLUploadService *uploadService = [[CLUploadService alloc]init];
        
        NSString *date=[[Confic getInstance] getCurrentTimeStamp];
        
        NSString *fileName=[[NSString alloc] initWithFormat:@"%@-profile-%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"], date];
        //NSLog(@" *****&&&&&&&B Image file naem : %@",fileName);
        
        activityIndicator.hidden=NO;
        
        [RKiOS7Loading showHUDAddedTo:self.view animated:YES];
        
        [uploadService  uploadFileWithData:imageData
                                  fileName:fileName
                                  progress:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
         {
             CGFloat precent = (totalBytesWritten / (totalBytesExpectedToWrite * 1.0f) * 10);
             if(MYGOOI_DEV)
                 NSLog(@"Uploaded:%f%%", precent);
             
         } success:^(id responseObject) {
             
             [RKiOS7Loading hideHUDForView:self.view animated:YES];
             
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
             strImageURL= [[NSString alloc] initWithFormat:@"%@%@",BSAE_S3_IMG_URL,fileName];
             if(MYGOOI_DEV)
                 NSLog(@"Upload Completed %@",responseObject);
             [self updateBusinessProfileDetails];
             activityIndicator.hidden=YES;
             
         } failure:^(NSError *error) {
             [RKiOS7Loading hideHUDForView:self.view animated:YES];
             activityIndicator.hidden=YES;
             if(MYGOOI_DEV)
                 NSLog(@"Error: %@", error);
         }];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    @catch (NSException *exception) {
        [ErrorReport sendErrorReport:NSStringFromClass([self class]) Method:[NSString stringWithFormat:@"%s",__FUNCTION__] Exception:exception];
    }
}
#pragma mark Button Action
/***
 Method Name : openImgLibrary
 Input Parameter : anyobject (UIButton)
 Return Type : nil
 Method Description : when user click import aletview should be appear select image )album or cancel
 ***/
- (IBAction)openImgLibrary:(id)sender
{
    
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Library", nil];
    [sheet showInView:self.view];
    
}
/***
 Method Name : submit
 Input Parameter : nil
 Return Type : nil
 Method Description : when user submit button resignResponder(hide keyboard) to all textfied all textfield validate after Profile details  submit into API
 ***/
-(IBAction)submit
{
    [scroll setContentSize:CGSizeMake(0,self.view.frame.size.height+380)];
    
    [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [Name resignFirstResponder];
    [email resignFirstResponder];
    [businessname resignFirstResponder];
    [aboutus resignFirstResponder];
    [company resignFirstResponder];
    [jobtitle resignFirstResponder];
    [address resignFirstResponder];
    [phone_no resignFirstResponder];
    [website resignFirstResponder];
   
    
    
    @try{
        if([self validation])
        {
            if(isImgageChanged)
                [self uploadImagetoS3];
            else
                [self updateBusinessProfileDetails];
        }
        
    }
    @catch (NSException *exception) {
        [ErrorReport sendErrorReport:NSStringFromClass([self class]) Method:[NSString stringWithFormat:@"%s",__FUNCTION__] Exception:exception];
        
    }
}
#pragma mark Request
/***
 Method Name : updateProfileDetails
 Input Parameter : nil
 Return Type : nil
 Method Description :  Profile details  submit into API
 ***/
-(void)updateBusinessProfileDetails
{
    @try{
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];
    
        
        [parameters setObject:@"1.0" forKey:@"APIVersion"];
        [parameters setObject:@"ios" forKey:@"platform"];
        [parameters setObject:[Confic getUsername] forKey:@"user_name"];
        [parameters setObject:email.text forKey:@"email_id"];
        
        [parameters setObject:Name.text forKey:@"name"];
        [parameters setObject:businessname.text  forKey:@"business_name"];
        [parameters setObject:jobtitle.text forKey:@"jobtitle"];
        [parameters setObject:company.text forKey:@"company"];
        [parameters setObject:address.text forKey:@"address"];
        [parameters setObject:website.text forKey:@"website"];
        
      
        [parameters setObject:aboutus.text forKey:@"about_us"];
    
        [parameters setObject:phone_no.text forKey:@"phone_number"];
        
        [parameters setObject:strImageURL  forKey:@"image_url"];
        //longitude,latitude
        if(strLatitude.length!=0)
        //    [parameters setObject:strLatitude forKey:@"latitude"];
        
        if(strLatitude.length!=0)
          //  [parameters setObject:strLongtitude forKey:@"longitude"];
        
        
        [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"auth_key"] forKey:@"auth_key"];
        
        if(MYGOOI_DEV)
            NSLog(@" parameters : %@",parameters);
        
        activityIndicator.hidden=NO;
        [[Confic getInstance]httpReqquest:parameters currentWindow:self.view path:@"business/add_business" success:^(id responseObject)
         {
             NSError* error;
             
             NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions  error:&error];
             
             if(error==nil && json!=nil)
             {
                 if(MYGOOI_DEV)
                     NSLog(@" The response : %@",json);
                 
            
                 [[Confic getInstance]showAlertViewWithOKButtonForTitle:@"Sucess !" andMessage:@"Your Business Profile has been sucessfully Added !"];
                 
                 [self closeView:nil];
             }
             activityIndicator.hidden=YES;
             if(MYGOOI_DEV)
                 NSLog(@"respose %@",json);
         } failure:^(NSError *error) {
             activityIndicator.hidden=YES;
             if(MYGOOI_DEV)
                 NSLog(@"error %@",error);
             
         } method:@"POST"];
        
    }
    @catch (NSException *exception) {
        
        [ErrorReport sendErrorReport:NSStringFromClass([self class]) Method:[NSString stringWithFormat:@"%s",__FUNCTION__] Exception:exception];
    }
}
/***
 Method Name : closeView
 Input Parameter : anyobject (UIButton)
 Return Type : nil
 Method Description : when user click back button dimiss profile edit viewcontroller
 ***/
- (IBAction)closeView:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark   Validation

/***
 Method Name : validation
 Input Parameter : nil
 Return Type : BOOLEAN
 Method Description : to check last_name,jobTitle , company ,address ,cellPhone  given input text lenth 0 or not if length is 0 textfield background color changed to blue color if given menitory field length is grater than 0 return true
 ***/

-(BOOL) validation{
    
    
    // In this validation if particuler text feild is invalid, we marked as feild in red color background otherwise its background in white color
    
    // if validation is correct this function return "TRUE" value otherwise "False" value
    
    BOOL validation=YES;
    @try{
        
        [Name setBackgroundColor:[UIColor whiteColor]];
        
        [email setBackgroundColor:[UIColor whiteColor]];
        
        [businessname setBackgroundColor:[UIColor whiteColor]];
        
        [aboutus setBackgroundColor:[UIColor whiteColor]];
        
        [company setBackgroundColor:[UIColor whiteColor]];
        
        [jobtitle setBackgroundColor:[UIColor whiteColor]];
        
        NSString *msg=@"Please enter valid data for ";
        
        
        
        if([Name.text length]==0 || Name.text.length<2 || Name.text.length>21){
            [Name setBackgroundColor:[[Confic getInstance] textFeilColor]];
            if(!validation)
                msg=[msg stringByAppendingString:@" and  Name(minimum 2 char) Max 20 Char "];
            else
                msg=[msg stringByAppendingString:@" Name(minimum 2 char) "];
            
            validation=NO;
            
        }
        
        
        
        if([email.text length]==0 && [[Confic getInstance] emailValidation:email.text]){
            [email setBackgroundColor:[[Confic getInstance] textFeilColor]];
            if(!validation)
                msg=[msg stringByAppendingString:@" and Valid Email ID"];
            else
                msg=[msg stringByAppendingString:@" Valid Email ID "];
            
            validation=NO;
            
        }
        
        
        if (![[Confic getInstance] validateStringContainsAlphabetsOnly:Name.text] &&[Name.text length]!=0 )
        {
            [Name setBackgroundColor:[[Confic getInstance] textFeilColor]];
            if(!validation)
                msg=[msg stringByAppendingString:@" and  Name allowd only Charator "];
            else
                msg=[msg stringByAppendingString:@" Name allowd only Charator "];
            validation=NO;
            
        }
              msg=[msg stringByAppendingString:@" field"];
        
        
        
        if(!validation)
            [[Confic getInstance] showAlertViewWithOKButtonForTitle:@"Validation Error"  andMessage:msg];
        
        
    }
    @catch (NSException *exception) {
        validation=NO;
        [ErrorReport sendErrorReport:NSStringFromClass([self class]) Method:[NSString stringWithFormat:@"%s",__FUNCTION__] Exception:exception];
        
    }
    return validation;
    
}

#pragma mark Location
/***
 Method Name : startSignificantChangeUpdates
 Input Parameter : nil
 Return Type : nil
 Method Description : locationmanager start monitoring current user location details
 ***/
/*
- (void)startSignificantChangeUpdates

{
    @try{
        if ([CLLocationManager locationServicesEnabled])
            
        {
            
            if (!locationManager)
                
                locationManager = [[CLLocationManager alloc] init];
            
            locationManager.delegate = self;
            
            [locationManager startMonitoringSignificantLocationChanges];
            
        }
        
    }
    @catch (NSException *exception) {
        
        [ErrorReport sendErrorReport:NSStringFromClass([self class]) Method:[NSString stringWithFormat:@"%s",__FUNCTION__] Exception:exception];
    }
}
*/
/***
 Method Name : locationManager:didUpdateLocations (Default Delegate Method)
 Input Parameter : LocationManager ,Array
 Return Type : nil
 Method Description : this method got current user geo location address details
 ***/
/*
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    @try{
        CLLocation *location = [locations lastObject];
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            
            strLatitude=[NSString stringWithFormat:@"%f",location.coordinate.latitude];
            strLongtitude=[NSString stringWithFormat:@"%f",location.coordinate.longitude];
            
            CLPlacemark *placemark = placemarks[0];
            
            NSDictionary *addressDictionary = [placemark addressDictionary];
            
            NSString *strCity =[Confic stringEmptyValue: addressDictionary[(NSString *)kABPersonAddressCityKey]];
            
            NSString *strState = [Confic stringEmptyValue:addressDictionary[(NSString *)kABPersonAddressStateKey]];
            
            NSString *strStreet=[Confic stringEmptyValue:addressDictionary[(NSString *)kABPersonAddressStreetKey]];
            NSString *strZip=[Confic stringEmptyValue:addressDictionary[(NSString *)kABPersonAddressZIPKey]];
            
            if([[Confic getInstance]isProfileUpdated]==NO)
            {
                address.text=[NSString stringWithFormat:@"%@ %@ %@ %@",strStreet,strCity,strState,strZip];
                city.text=strCity;
                state.text=strState;
                zipCode.text=strZip;
            }
            if(MYGOOI_DEV)
                NSLog(@"location %@",addressDictionary);
            
            
        }];
        
        [ locationManager stopUpdatingLocation];
        
        locationManager = nil;
    }
    @catch (NSException *exception) {
        
        [ErrorReport sendErrorReport:NSStringFromClass([self class]) Method:[NSString stringWithFormat:@"%s",__FUNCTION__] Exception:exception];
    }
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -hideStatusBar
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
