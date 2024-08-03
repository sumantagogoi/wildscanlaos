//
//  SubmitReportViewController.m
//  WildScan
//
//  Created by Shabir Jan on 03/05/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "SubmitReportViewController.h"
#import "SubmitReport1TableViewCell.h"
#import "AddContactTableViewCell.h"
#import "ContactsViewController.h"
#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#import "SVProgressHUD.h"
#import "Region.h"
@interface SubmitReportViewController (){
    NSString *image1String;
    NSString *image2String;
    NSString *image3String;
    NSString *dateTime;
    CLLocation *userLocation;
    NSString *offense;
    NSString *specie;
    NSString *amount;
    NSString *amounType;
    NSString *condition;
    NSString *offenseMoreDetail;
    NSString *method;
    NSString *valueEstimate;
    NSString *originLocation;
    NSString *destinationLocation;
    NSString *vehicleDescription;
    NSString *License;
    NSString *vesselName;
    NSString *reportStatus;
    BOOL sendReportEmail;
    NSString *lati;
    NSString *longi;
}
@property (nonatomic)BOOL isImage1Taken;
@property (nonatomic)BOOL isImage2Taken;
@property (nonatomic)BOOL isImage3Taken;
@end

@implementation SubmitReportViewController
@synthesize contactsArray;
@synthesize isImage1Taken;
@synthesize isImage2Taken;
@synthesize isImage3Taken;

- (void)viewDidLoad {
    [super viewDidLoad];
    image1String=@"";
    image2String=@"";
    image3String=@"";
    dateTime=@"";
    
    lati =@"";
    longi=@"";
    offense=@"";
    specie=@"";
    amount=@"";
    amounType=@"";
    condition=@"";
    offenseMoreDetail=@"";
    method=@"";
    valueEstimate=@"";
    originLocation=@"";
    destinationLocation=@"";
    vehicleDescription=@"";
    License=@"";
    vesselName=@"";
    reportStatus = @"";
    sendReportEmail = NO;
   
    if ([self.btnReportPrivate isSelected]) {
        reportStatus = @"1";
    }else{
        reportStatus = @"0";
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // [self.mainTableView reloadData];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     contactsArray = [NSMutableArray arrayWithArray:[Contacts getContactsForReport:self.moc]];
    [self.mainTableView reloadData];
    AppDelegate *dlg = (AppDelegate*)[UIApplication sharedApplication].delegate;
    for (NSDictionary *dic in dlg.submitReportData) {
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
            NSLog(@"%@", key);
            if ([key isEqualToString:@"imageString"]) {
                if (!isImage1Taken) {
                    
                    
                    NSString *encodedString = object;
                    image1String = encodedString;
                    NSData *data = [[NSData alloc]initWithBase64EncodedString:encodedString options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    UIImage *currentImage= [UIImage imageWithData:data];
                    if (currentImage != nil) {
                        self.btnRemoveImage1.hidden = NO;
                        isImage1Taken = YES;
                    }
                    [self.btnImage1 setImage:currentImage forState:UIControlStateNormal];
                }
                
            }
            else if ([key isEqualToString:@"selectedDateTime"]){
                dateTime = object;
            }
            else if ([key isEqualToString:@"userLocation"]){
                userLocation = object;
            }
            else if ([key isEqualToString:@"incidentInfo"]){
                offense = object;
            }
            else if ([key isEqualToString:@"userSelectedSID"]){
                specie = object;
            }
            else if ([key isEqualToString:@"amountInfo"]){
                amount = object;
            }
            else if ([key isEqualToString:@"amountType"]){
                amounType = object;
            }
            else if ([key isEqualToString:@"conditionType"]){
                condition = object;
            }
            else if ([key isEqualToString:@"offenseMoreInfo"]){
                offenseMoreDetail = object;
            }
            else if ([key isEqualToString:@"methodInfo"]){
                method = object;
            }
            else if ([key isEqualToString:@"valueEstimate"]){
                valueEstimate = object;
            }
            else if ([key isEqualToString:@"originLocation"]){
                originLocation = object;
            }
            else if ([key isEqualToString:@"destinationLocation"]){
                destinationLocation = object;
            }
            else if ([key isEqualToString:@"vehicleDescription"]){
                vehicleDescription = object;
            }
            else if ([key isEqualToString:@"licenseNumber"]){
                License = object;
            }
            else if ([key isEqualToString:@"vesselNumber"]){
                vesselName = object;
            }
        }];
    }
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)btnReportPrivatePressed:(id)sender {
    [self.btnReportPrivate setSelected:!self.btnReportPrivate.selected];
    if ([self.btnReportPrivate isSelected]) {
        reportStatus = @"1";
    }else{
        reportStatus = @"0";
    }
}
- (IBAction)btnBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnReportEmail:(id)sender {
    UIButton *btn = (UIButton*)sender;
    [btn setSelected:!btn.selected];
    if ([btn isSelected]) {
        sendReportEmail = YES;
    }else{
        sendReportEmail = NO;
    }
}
- (IBAction)btnAddContactPressed:(id)sender {
    UIButton *btn = (UIButton*)sender;
    AddContactTableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
    if (!cell.isButtonAdd) {
        Contacts *contact = [contactsArray objectAtIndex:btn.tag-1];
        contact.contactSelectedForReport=[NSNumber numberWithBool:NO];
        [self.moc save:nil];
        [contactsArray removeObjectAtIndex:btn.tag-1];
        [self.mainTableView reloadData];
    }else{
        ContactsViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"contactsVC"];
        vc.moc = self.moc;
        vc.isContactSelection = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -
#pragma mark - UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2+contactsArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SubmitReport1TableViewCell *cell = (SubmitReport1TableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell.btnShareEmail.tag = indexPath.row;
        return cell;
    }else if(indexPath.row == contactsArray.count+1){
        AddContactTableViewCell *cell = (AddContactTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell.lblName.text = NSLocalizedString(@"report_wizard_screen_4_add_contact", @"");
        [cell.btnAddContact setImage:[UIImage imageNamed:@"ic_action_add_contact"] forState:UIControlStateNormal];
        cell.isButtonAdd = YES;
        cell.btnAddContact.tag = indexPath.row;
        return cell;
    }else{
        AddContactTableViewCell *cell = (AddContactTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        Contacts *contact = [contactsArray objectAtIndex:indexPath.row-1];
        cell.lblName.text = contact.contactName;
        cell.isButtonAdd = NO;
        [cell.btnAddContact setImage:[UIImage imageNamed:@"ic_action_remove_contact"] forState:UIControlStateNormal];
        cell.btnAddContact.tag = indexPath.row;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 165;
    }
    return 44;
}

- (IBAction)btnRemoveImage1Pressed:(id)sender {
    [self.btnRemoveImage1 setHidden:YES];
    image1String=@"";
    isImage1Taken = NO;
    [self.btnImage1 setImage:[UIImage imageNamed:@"empty_photo"] forState:UIControlStateNormal];
}

- (IBAction)btnRemoveImage2Pressed:(id)sender {
    [self.btnRemoveImage2 setHidden:YES];
    image2String=@"";
    isImage2Taken = NO;
    [self.btnImage2 setImage:[UIImage imageNamed:@"empty_photo"] forState:UIControlStateNormal];
    
}

- (IBAction)btnRemoveImage3Pressed:(id)sender {
    [self.btnRemoveImage3 setHidden:YES];
    image3String=@"";
    isImage3Taken = NO;
    [self.btnImage3 setImage:[UIImage imageNamed:@"empty_photo"] forState:UIControlStateNormal];
    
}

- (IBAction)btnImage1Pressed:(id)sender {
    if (isImage1Taken) {
        
    }else{
        [self selectPhoto];
    }
}

- (IBAction)btnImage2Pressed:(id)sender {
    if (isImage2Taken) {
        
    }else{
        [self selectPhoto];
    }
}

- (IBAction)btnImage3Pressed:(id)sender {
    if (isImage3Taken) {
        
    }else{
        [self selectPhoto];
    }
}

- (IBAction)btnTakeCamera:(id)sender {
    if (isImage1Taken && isImage2Taken && isImage3Taken) {
        
    }else{
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (IBAction)btnTakeExisting:(id)sender {
    if (isImage1Taken && isImage2Taken && isImage3Taken) {
        
    }else{
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (IBAction)btnCancelPressed:(id)sender {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:NSLocalizedString(@"report_wizard_confirm_discard_title", @"")
                                  message:NSLocalizedString(@"report_wizard_confirm_discard_message", @"")
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:NSLocalizedString(@"discard", @"")
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             NSMutableArray *allControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                             for (id object in allControllers) {
                                 if ([object isKindOfClass:[DashboardViewController class]]) {
                                     [self.navigationController popToViewController:object animated:YES];
                                 }
                             }
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"cancel", @"")
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)btnSubmitPressed:(id)sender {
    NSMutableString *contactString = [[NSMutableString alloc]init];
    if (contactsArray.count>0) {
        for (Contacts *contact in contactsArray) {
            [contactString appendFormat:@"%@,",contact.contactID];
        }
    }
   NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd,yyyy HH:mm"];
    NSDate *date1 = [dateFormatter dateFromString:dateTime];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSString *dateTimes = [dateFormatter stringFromDate:date1];
    NSString *shareString = [NSString stringWithFormat:@"Wildscan apps, %@",contactString];
    lati = [NSString stringWithFormat:@"%.3f",userLocation.coordinate.latitude];
    longi = [NSString stringWithFormat:@"%.3f",userLocation.coordinate.longitude];
    
//    image1String = [image1String stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
//    image2String = [image2String stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
//    image3String = [image3String stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSDictionary *mainDic = [NSDictionary dictionaryWithObjectsAndKeys:dateTimes,@"incident_date",
                             lati,@"location_lat",
                             longi,@"location_lon",
                             offense,@"incident",
                             specie,@"species",
                             amount,@"number",
                             amounType,@"number_unit",
                             condition,@"incident_condition",
                             offenseMoreDetail,@"offense_description",
                             method,@"method",
                             valueEstimate,@"value_estimated_usd",
                             originLocation,@"origin_address",
                             destinationLocation,@"destination_address",
                             vehicleDescription,@"vehicle_vessel_description",
                             License,@"vehicle_vessel_license_number",
                             vesselName,@"vessel_name",
                             @"2",@"region",
                             shareString,@"share_with",
                             reportStatus,@"status",
                             @"-2",@"created_by",
                             image1String,@"submit_report_image1",
                             image2String,@"submit_report_image2",
                             image3String,@"submit_report_image3",
                             nil];
    
    ServiceHelper *sh = [[ServiceHelper alloc]init];
    sh.delegate =self;
    [SVProgressHUD showWithStatus:NSLocalizedString(@"report_submit_message", @"")];
    
    [sh submitReport:mainDic];
}
-(void)selectPhoto{
    
}
#pragma mark -
#pragma mark - UIImagePickerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    

    UIImage *img = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
   // img = [self compressImage:img];
    if (!isImage1Taken) {
        
        self.btnRemoveImage1.hidden = NO;
        isImage1Taken = YES;
        NSData *imgData = UIImageJPEGRepresentation(img, 0.1);

        NSString *encodedString = [imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        image1String = encodedString;
        [self.btnImage1 setImage:img forState:UIControlStateNormal];
    }else if (!isImage2Taken){
        self.btnRemoveImage2.hidden = NO;
        isImage2Taken = YES;
       
        NSData *imgData = UIImageJPEGRepresentation(img, 0.1);
        NSString *encodedString = [imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        image2String = encodedString;
        
        [self.btnImage2 setImage:img forState:UIControlStateNormal];
        
    }else{
        self.btnRemoveImage3.hidden = NO;
        isImage3Taken = YES;
        
        NSData *imgData = UIImageJPEGRepresentation(img, 0.1);
        NSString *encodedString = [imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        image3String = encodedString;
        [self.btnImage3 setImage:img forState:UIControlStateNormal];
        
    }
}
#pragma mark -
#pragma mark - Helper
- (UIImage *)compressImage:(UIImage *)image{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.1;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth) {
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
}
#pragma mark -
#pragma mark - Service Delegate
-(void)serviceHelper:(ServiceHelper *)client didReportSubmitSucess:(id)message{
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"report_submit_success", @"")];
    if (sendReportEmail) {
        Species *species =[Species getSpecieByID:specie moc:self.moc];
        NSString *emailBody = @"Wildscan App Automatic Report";
        if (self.btnReportPrivate.isSelected) {
            emailBody = [NSString stringWithFormat:@"Date/Time:\n%@\n\nLocation latitude:\n%@\n\nLocation longitude:\n%@\n\nIncident description:\n%@\n\nSpecies:\n%@\n\nNumber:\n%@ %@\n\nCondition:\n%@\n\nOffense Detail:\n%@\n\nMethod:\n%@\n\nValue Estimate(USD):\n%@\n\nOrigin address:\n%@\n\nDestination address:\n%@\n\nVehicle/Vessel description:\n%@\n\nVehicle/Vessel license number:\n%@\n\nVessel name:\n%@\n\nThis report was marked as private and will not be syndicated via WildScan app.",dateTime,lati,longi,offense,species.specieCommonName,amount,amounType,condition,offenseMoreDetail,method,valueEstimate,originLocation,destinationLocation,vehicleDescription,License,vesselName];
        }
        else{
            emailBody = [NSString stringWithFormat:@"Date/Time:\n%@\n\nLocation latitude:\n%@\n\nLocation longitude:\n%@\n\nIncident description:\n%@\n\nSpecies:\n%@\n\nNumber:\n%@ %@\n\nCondition:\n%@\n\nOffense Detail:\n%@\n\nMethod:\n%@\n\nValue Estimate(USD):\n%@\n\nOrigin address:\n%@\n\nDestination address:\n%@\n\nVehicle/Vessel description:\n%@\n\nVehicle/Vessel license number:\n%@\n\nVessel name:\n%@",dateTime,lati,longi,offense,species.specieCommonName,amount,amounType,condition,offenseMoreDetail,method,valueEstimate,originLocation,destinationLocation,vehicleDescription,License,vesselName];
        }
        
        if([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
            mailCont.mailComposeDelegate = self;
            
            NSString *regionID  = [[NSUserDefaults standardUserDefaults]valueForKey:REPORTINGREGION];
            Region *region = [Region getRegionByID:regionID moc:self.moc];
            NSRange range = [region.regionReportEmail rangeOfString:@","];
            NSMutableArray *contacts = [NSMutableArray new];
            if (range.location != NSNotFound)
            {
                NSArray *emails = [region.regionReportEmail componentsSeparatedByString:@","];
                [contacts addObjectsFromArray:emails];
                
            }else{
                [contacts addObject:region.regionReportEmail];
            }
                       
            [mailCont setSubject:@"Wildscan App Automatic Report"];
            
            [mailCont setToRecipients:[NSArray arrayWithArray:contacts]];
            [mailCont setMessageBody:emailBody isHTML:NO];
            if (isImage1Taken) {
               
                
                NSData *data = [[NSData alloc]initWithBase64EncodedString:image1String options:NSDataBase64DecodingIgnoreUnknownCharacters];
                [mailCont addAttachmentData:data mimeType:@"image/png" fileName:@"Image1"];
            }
            if (isImage2Taken) {
                
                
                NSData *data = [[NSData alloc]initWithBase64EncodedString:image2String options:NSDataBase64DecodingIgnoreUnknownCharacters];
                [mailCont addAttachmentData:data mimeType:@"image/png" fileName:@"Image2"];
            }
            if (isImage3Taken) {
                
                
                NSData *data = [[NSData alloc]initWithBase64EncodedString:image3String options:NSDataBase64DecodingIgnoreUnknownCharacters];
                [mailCont addAttachmentData:data mimeType:@"image/png" fileName:@"Image3"];
            }
            [self presentViewController:mailCont animated:YES completion:nil];
            
        }
        
    }else{
        NSMutableArray *allControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        for (id object in allControllers) {
            if ([object isKindOfClass:[DashboardViewController class]]) {
                [self.navigationController popToViewController:object animated:YES];
            }
        }
    }
}
-(void)serviceHelper:(ServiceHelper *)client didReportSubmitFailed:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"report_submit_fail", @"")];
}
#pragma mark -
#pragma mark - MFMailMessageCompose Delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSMutableArray *allControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (id object in allControllers) {
        if ([object isKindOfClass:[DashboardViewController class]]) {
            [self.navigationController popToViewController:object animated:YES];
        }
    }
    
}

@end
