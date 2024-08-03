//
//  ReportDetailsViewController.m
//  WildScan
//
//  Created by Shabir Jan on 26/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "ReportDetailsViewController.h"
#import "ReportDetailTableViewCell.h"
#import "ReportDetail2TableViewCell.h"
#import "ReportDetail3TableViewCell.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "SubmitReportViewController.h"
#import "SpeciesTranslation.h"

@interface ReportDetailsViewController (){
    MKPointAnnotation *point;
    CLLocationCoordinate2D touchMapCoordinate;
    AppDelegate *dlg;
    CLLocation *userLocation;
    NSString *originLocation;
    NSString *destinationLocation;
    NSString *offenseText;
    NSString *userSelectedSpecie;
    NSString *userSelectedImage;
}
@property (weak, nonatomic) IBOutlet UITableView *specieTableView;
@property (nonatomic,strong)NSString *locationValues;
@property (nonatomic,strong)NSString *dateTime;
@property (nonatomic,strong)NSString *location;
@property (nonatomic,strong)NSString *offense;
@property (nonatomic,strong)NSString *species;
@property (nonatomic,strong)NSString *amount;
@property (nonatomic,strong)NSString *amountType;
@property (nonatomic,strong)NSString *condition;
@property (nonatomic,strong)NSString *offenseDetail;
@property (nonatomic,strong)NSString *method;
@property (nonatomic,strong)NSString *valueEstimate;
@property (nonatomic,strong)NSString *origin;
@property (nonatomic,strong)NSString *originValues;
@property (nonatomic,strong)NSString *destination;
@property (nonatomic,strong)NSString *destinationValues;
@property (nonatomic,strong)NSString *descriptionVehicle;
@property (nonatomic,strong)NSString *license;
@property (nonatomic,strong)NSString *vesselName;
@property (nonatomic,strong)NSDateFormatter *dateFormatter;
@property (nonatomic,strong)NSMutableArray *allSpecies;
@property (nonatomic,strong)NSMutableArray *allSpeciesTranslations;
@property (nonatomic,strong)NSMutableArray *filteredSpecies;
@property (nonatomic)BOOL isIncidentLocationPressed;
@property (nonatomic)BOOL isOriginLocationPressed;
@property (nonatomic)BOOL isDestinationLocationPressed;
@property (nonatomic)BOOL isMoreDetailPressed;
@property (nonatomic)BOOL isUserSearch;
@end

@implementation ReportDetailsViewController
@synthesize dateFormatter;
@synthesize dateTime;
@synthesize location;
@synthesize isMoreDetailPressed;
@synthesize origin;
@synthesize destination;
@synthesize species;
@synthesize amount;
@synthesize condition;
@synthesize method;
@synthesize offenseDetail;
@synthesize valueEstimate;
@synthesize descriptionVehicle;
@synthesize license;
@synthesize vesselName;
@synthesize locationValues;
@synthesize originValues;
@synthesize destinationValues;
@synthesize allSpecies;
@synthesize filteredSpecies;
@synthesize isUserSearch;
@synthesize allSpeciesTranslations;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    dlg = (AppDelegate*)[UIApplication sharedApplication].delegate;
    allSpecies= [NSMutableArray arrayWithArray:[Species getAllSpecies:self.moc]];
    allSpeciesTranslations = [NSMutableArray arrayWithArray: [SpeciesTranslation getAllSpeciesTranslations:dlg.languageISO moc:self.moc]];
    
    filteredSpecies  = [NSMutableArray new];
    origin = @"";
    userSelectedImage=@"";
    destination = @"";
    amount = @"";
    condition = @"";
    method = @"";
    offenseDetail = @"";
    valueEstimate = @"";
    descriptionVehicle = @"";
    license=@"";
    vesselName=@"";
    userSelectedSpecie=@"";
    originValues=@"";
    destinationValues=@"";
    offenseText =@"";
    originLocation =@"";
    destinationLocation=@"";
    isUserSearch = NO;
    
    Species *currentObj = [Species getSpecieByID:[[NSUserDefaults standardUserDefaults]objectForKey:@"reportSpecie"] moc:self.moc];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"reportSpecie"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if (currentObj) {
        species = currentObj.specieCommonName;
        userSelectedSpecie = currentObj.specieID;
    }
    isMoreDetailPressed = false;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    self.map.showsUserLocation = YES;
    
    //    MKUserLocation *userLocation = self.map.userLocation;
    //    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (
    //                                                                    userLocation.location.coordinate, 2, 2);
    //    [self.map setRegion:region animated:NO];
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd,yyyy HH:mm"];
    
    NSString *currentDateTime = [dateFormatter stringFromDate:[NSDate date]];
    dateTime = currentDateTime;
    
    
    
    point = [[MKPointAnnotation alloc] init];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOccured)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    [self.dateTimePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    
    UITapGestureRecognizer *lpgr = [[UITapGestureRecognizer alloc]
                                    initWithTarget:self action:@selector(handlePress:)];
    //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [super viewDidAppear:animated];
    AppDelegate *dlg1 = (AppDelegate*)[UIApplication sharedApplication].delegate;
    for (NSDictionary *dic in dlg1.submitReportData) {
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
            NSLog(@"%@", key);
            if ([key isEqualToString:@"userSelectedSpecie"]) {
                Species *currentSpecie = (Species*)object;
                species = currentSpecie.specieCommonName;
                userSelectedSpecie = currentSpecie.specieID;
                NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:1 inSection:0];
                NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
                [self.tableViewReport reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
            }
            if ([key isEqualToString:@"imageString"]) {
                NSString *encodedString = object;
                userSelectedImage = encodedString;
            }
        }];
    }
    
}
-(void)tapOccured{
    if ((isMoreDetailPressed)) {
        ReportDetail3TableViewCell *cell = (id)[self.tableViewReport cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        valueEstimate = cell.txtValueEstimate.text;
        license = cell.txtLicense.text;
        vesselName = cell.txtVesselNumber.text;
        [cell.txtViewOffenseDetail resignFirstResponder];
        [cell.txtViewMethod resignFirstResponder];
        [cell.txtDestination resignFirstResponder];
        [cell.txtOrigin resignFirstResponder];
        [cell.txtVehicleDescription resignFirstResponder];
        [cell.txtLicense resignFirstResponder];
        [cell.txtVesselNumber resignFirstResponder];
        
        
    }else{
        ReportDetail2TableViewCell *cell  = (id)[self.tableViewReport cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [cell.textView resignFirstResponder];
        [cell.txtAmount resignFirstResponder];
        [cell.txtSpecies resignFirstResponder];
    }
    
}

- (void)handlePress:(UIGestureRecognizer *)gestureRecognizer
{
    
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.map];
    touchMapCoordinate = [self.map convertPoint:touchPoint toCoordinateFromView:self.map];
    point.coordinate = touchMapCoordinate;
    [self.map addAnnotation:point];
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnCancelPressed:(id)sender {
    self.mapView.hidden = YES;
    self.lblViewTitle.text = NSLocalizedString(@"report_wizard_screen_2_title", @"");
}

- (IBAction)btnSetPressed:(id)sender {
    self.lblViewTitle.text = NSLocalizedString(@"report_wizard_screen_2_title", @"");
    self.mapView.hidden = YES;
    if (self.isIncidentLocationPressed) {
        location  = [NSString stringWithFormat:@"[%.03f,%.03f]",touchMapCoordinate.latitude,touchMapCoordinate.longitude];
        CLLocation *locations = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
        CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
        [geoCoder reverseGeocodeLocation:locations completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error) {
                locationValues = location;
            }else{
                CLPlacemark *placeMark = [placemarks lastObject];
                locationValues = ABCreateStringWithAddressDictionary(placeMark.addressDictionary,NO);
                
                locationValues = [locationValues stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                locationValues = [locationValues stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                NSLog(@"location %@",locationValues);
            }
            NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:0 inSection:0];
            NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
            [self.tableViewReport reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
        }];
        
    }
    else if (self.isOriginLocationPressed){
        origin  = [NSString stringWithFormat:@"[%.03f,%.03f]",touchMapCoordinate.latitude,touchMapCoordinate.longitude];
        CLLocation *locations = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
        //originLocation = locations;
        CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
        [geoCoder reverseGeocodeLocation:locations completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error) {
                originValues = self->origin;
            }else{
                CLPlacemark *placeMark = [placemarks lastObject];
                originValues = ABCreateStringWithAddressDictionary(placeMark.addressDictionary,NO);
                
                originValues = [originValues stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                originValues = [originValues stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                originLocation = originValues;
                NSLog(@"location %@",originValues);
            }
            NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:0 inSection:0];
            NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
            [self.tableViewReport reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
        }];
        
    }else{
        destination  = [NSString stringWithFormat:@"[%.03f,%.03f]",touchMapCoordinate.latitude,touchMapCoordinate.longitude];
        CLLocation *locations = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
        
        CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
        [geoCoder reverseGeocodeLocation:locations completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error) {
                destinationValues = destination;
            }else{
                CLPlacemark *placeMark = [placemarks lastObject];
                destinationValues = ABCreateStringWithAddressDictionary(placeMark.addressDictionary,NO);
                
                destinationValues = [destinationValues stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                destinationValues = [destinationValues stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                destinationLocation = destinationValues;
                NSLog(@"location %@",destinationValues);
            }
            NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:0 inSection:0];
            NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
            [self.tableViewReport reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
        }];
        
    }
}

- (IBAction)btnCancelReportPressed:(id)sender {
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

- (IBAction)btnMoreDetailPressed:(id)sender {
    self.lblViewTitle.text = NSLocalizedString(@"report_wizard_screen_3_title", @"");
    
    isMoreDetailPressed = YES;
    [self.tableViewReport reloadData];
}

- (IBAction)btnSubmitReportPressed:(id)sender {
    [dlg.submitReportData removeAllObjects];
    NSDictionary *dateTimeDic = [[NSDictionary alloc]initWithObjectsAndKeys:dateTime,@"selectedDateTime", nil];
    NSDictionary *imageDic = [[NSDictionary alloc]initWithObjectsAndKeys:userSelectedImage,@"imageString", nil];
    NSDictionary *userSelectedLocation = [[NSDictionary alloc]initWithObjectsAndKeys:userLocation,@"userLocation", nil];
    
    NSString *offense = offenseText;
    NSDictionary *incidentDic = [[NSDictionary alloc]initWithObjectsAndKeys:offense,@"incidentInfo", nil];
    
    ReportDetail2TableViewCell *cell  = (id)[self.tableViewReport cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    amount = cell.txtAmount.text;
    NSDictionary *amountDic = [[NSDictionary alloc]initWithObjectsAndKeys:amount,@"amountInfo", nil];
    
    NSDictionary *amountTypedic = [[NSDictionary alloc]initWithObjectsAndKeys:self.amountType,@"amountType", nil];
    
    NSDictionary *conditionDic = [[NSDictionary alloc]initWithObjectsAndKeys:condition,@"conditionType", nil];
    
    NSDictionary *offenseMoreDic  = [[NSDictionary alloc]initWithObjectsAndKeys:offenseDetail,@"offenseMoreInfo", nil];
    
    NSDictionary *methodDic = [[NSDictionary alloc]initWithObjectsAndKeys:method,@"methodInfo", nil];
    
    NSDictionary *valueEstimateDic = [[NSDictionary alloc]initWithObjectsAndKeys:valueEstimate,@"valueEstimate", nil];
    
    NSDictionary *originDic = [[NSDictionary alloc]initWithObjectsAndKeys:originLocation,@"originLocation", nil];
    
    NSDictionary *destinationDic = [[NSDictionary alloc]initWithObjectsAndKeys:destinationLocation,@"destinationLocation", nil];
    
    NSDictionary *vehicleDescDic = [[NSDictionary alloc]initWithObjectsAndKeys:descriptionVehicle,@"vehicleDescription", nil];
    
    NSDictionary *specieDic = [[NSDictionary alloc]initWithObjectsAndKeys:userSelectedSpecie,@"userSelectedSID", nil];
    
    NSDictionary *licenseDic = [[NSDictionary alloc]initWithObjectsAndKeys:license,@"licenseNumber", nil];
    
    NSDictionary *vesselNameDic = [[NSDictionary alloc]initWithObjectsAndKeys:vesselName,@"vesselNumber", nil];
    
    [dlg.submitReportData addObject:imageDic];
    [dlg.submitReportData addObject:dateTimeDic];
    [dlg.submitReportData addObject:userSelectedLocation];
    [dlg.submitReportData addObject:incidentDic];
    [dlg.submitReportData addObject:specieDic];
    [dlg.submitReportData addObject:amountDic];
    [dlg.submitReportData addObject:amountTypedic];
    [dlg.submitReportData addObject:conditionDic];
    [dlg.submitReportData addObject:offenseMoreDic];
    [dlg.submitReportData addObject:methodDic];
    [dlg.submitReportData addObject:valueEstimateDic];
    [dlg.submitReportData addObject:originDic];
    [dlg.submitReportData addObject:destinationDic];
    [dlg.submitReportData addObject:vehicleDescDic];
    [dlg.submitReportData addObject:licenseDic];
    [dlg.submitReportData addObject:vesselNameDic];
    
    
    SubmitReportViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"submitReportVC"];
    vc.moc = self.moc;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnSpeciePressed:(id)sender {
    IdentifySpecieViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"identifySpecieVC"];
    vc.moc = self.moc;
    vc.descriptionText=NSLocalizedString(@"id_wizard_questions_live_deceased", @"");
    vc.isSubmitReportView = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnIndividualPressed:(id)sender {
    ReportDetail2TableViewCell *cell =  (id)[self.tableViewReport cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    self.amountType = @"individuals";
    [cell.btnKg setSelected:NO];
    [cell.btnIndividual setSelected:YES];
}

- (IBAction)btnKgPressed:(id)sender {
    ReportDetail2TableViewCell *cell =  (id)[self.tableViewReport cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    self.amountType = @"kg";
    [cell.btnKg setSelected:YES];
    [cell.btnIndividual setSelected:NO];
    
}

- (IBAction)btnAlivePressed:(id)sender {
    ReportDetail2TableViewCell *cell =  (id)[self.tableViewReport cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    condition = @"alive";
    [cell.btnAlive setSelected:YES];
    [cell.btnDead setSelected:NO];
    [cell.btnMixed setSelected:NO];
}

- (IBAction)btnDeadPressed:(id)sender {
    ReportDetail2TableViewCell *cell =  (id)[self.tableViewReport cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    condition = @"dead";
    [cell.btnAlive setSelected:NO];
    [cell.btnDead setSelected:YES];
    [cell.btnMixed setSelected:NO];
}

- (IBAction)btnMixedPressed:(id)sender {
    ReportDetail2TableViewCell *cell =  (id)[self.tableViewReport cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    condition = @"mixed";
    [cell.btnAlive setSelected:NO];
    [cell.btnDead setSelected:NO];
    [cell.btnMixed setSelected:YES];
}

- (IBAction)btnOriginPressed:(id)sender {
    self.isIncidentLocationPressed = NO;
    self.isOriginLocationPressed = YES;
    self.isDestinationLocationPressed = NO;
    self.mapView.hidden = NO;
    self.lblViewTitle.text = NSLocalizedString(@"report_wizard_location_pick_title", @"");
}

- (IBAction)btnDestinationPressed:(id)sender {
    self.isIncidentLocationPressed = NO;
    self.isOriginLocationPressed = NO;
    self.isDestinationLocationPressed = YES;
    self.mapView.hidden = NO;
    self.lblViewTitle.text = NSLocalizedString(@"report_wizard_location_pick_title", @"");
}

- (IBAction)btnDateTimePressed:(id)sender {
    self.DateTimeView.hidden = NO;
}

- (IBAction)btnLocationPressed:(id)sender {
    self.isIncidentLocationPressed = YES;
    self.isOriginLocationPressed = NO;
    self.isDestinationLocationPressed = NO;
    self.mapView.hidden = NO;
    self.lblViewTitle.text = NSLocalizedString(@"report_wizard_location_pick_title", @"");
}

- (IBAction)btnBackPressed:(id)sender {
    if (isMoreDetailPressed) {
        isMoreDetailPressed = NO;
        [self.tableViewReport reloadData];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)btnDonePressed:(id)sender {
    self.DateTimeView.hidden = YES;
    
}

#pragma mark -
#pragma mark - UITableViewCell Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.specieTableView) {
        return filteredSpecies.count;
    }else{
        if (isMoreDetailPressed) {
            return 1;
        }
        return 2;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.specieTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor= [UIColor whiteColor];
        if (isUserSearch) {
            if ([dlg.languageISO isEqualToString:@"en"]) {
                Species *currentSpecies = [filteredSpecies objectAtIndex:indexPath.row];
                cell.textLabel.text = currentSpecies.specieCommonName;
            }else{
                SpeciesTranslation *obj = [allSpeciesTranslations objectAtIndex:indexPath.row];
                if (obj!=nil) {
                    if ([obj.specieCommonName isEqualToString:@""] || obj.specieCommonName ==nil) {
                        cell.textLabel.text = obj.specieID.specieCommonName;
                    }else{
                        cell.textLabel.text = obj.specieCommonName;
                    }
                }else{
                    cell.textLabel.text = obj.specieID.specieCommonName;
                }
            }
        }else{
            Species *currentSpecies = [filteredSpecies objectAtIndex:indexPath.row];
            cell.textLabel.text = currentSpecies.specieCommonName;
        }
        return cell;
    }else{
        if (isMoreDetailPressed) {
            ReportDetail3TableViewCell *cell = (ReportDetail3TableViewCell*)[self.tableViewReport dequeueReusableCellWithIdentifier:@"reportcell3"];
            cell.backgroundColor = [UIColor clearColor];
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
            cell.txtOrigin.leftView = paddingView;
            cell.txtOrigin.leftViewMode = UITextFieldViewModeAlways;
            paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
            cell.txtDestination.leftView = paddingView;
            cell.txtDestination.leftViewMode = UITextFieldViewModeAlways;
            paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
            cell.txtVesselNumber.leftView = paddingView;
            cell.txtVesselNumber.leftViewMode = UITextFieldViewModeAlways;
            
            paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
            cell.txtValueEstimate.leftView = paddingView;
            cell.txtValueEstimate.leftViewMode = UITextFieldViewModeAlways;
            
            paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
            cell.txtDestination.leftView = paddingView;
            cell.txtDestination.leftViewMode = UITextFieldViewModeAlways;
            
            paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
            cell.txtLicense.leftView = paddingView;
            cell.txtLicense.leftViewMode = UITextFieldViewModeAlways;
            
            if ([cell.txtOrigin respondsToSelector:@selector(setAttributedPlaceholder:)]) {
                UIColor *color = [UIColor blackColor];
                cell.txtOrigin.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"report_wizard_location_hint", @"") attributes:@{NSForegroundColorAttributeName: color}];
            }
            
            if ([cell.txtDestination respondsToSelector:@selector(setAttributedPlaceholder:)]) {
                UIColor *color = [UIColor blackColor];
                cell.txtDestination.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"report_wizard_location_hint", @"") attributes:@{NSForegroundColorAttributeName: color}];
            }
            
            
            
            cell.txtOrigin.text = originValues;
            cell.txtDestination.text = destinationValues;
            cell.txtOrigin.tintColor = [UIColor blackColor];
            cell.txtValueEstimate.tintColor = [UIColor blackColor];
            cell.txtDestination.tintColor = [UIColor blackColor];
            cell.txtVehicleDescription.tintColor = [UIColor blackColor];
            cell.txtLicense.tintColor = [UIColor blackColor];
            cell.txtVesselNumber.tintColor = [UIColor blackColor];
            
            cell.txtViewMethod.text= NSLocalizedString(@"report_wizard_screen_3_method_hint", @"");
            cell.txtViewOffenseDetail.text= NSLocalizedString(@"report_wizard_screen_3_offense_details_hint", @"");
            
            return cell;
        }else{
            if (indexPath.row == 0) {
                ReportDetailTableViewCell *cell = (ReportDetailTableViewCell*)[self.tableViewReport dequeueReusableCellWithIdentifier:@"reportcell"];
                cell.lblDateTime.text = dateTime;
                cell.lblLocation.text = locationValues;
                cell.backgroundColor = [UIColor clearColor];
                
                return cell;
            }else{
                ReportDetail2TableViewCell *cell = (ReportDetail2TableViewCell*)[self.tableViewReport dequeueReusableCellWithIdentifier:@"reportcell2"];
                cell.backgroundColor = [UIColor clearColor];
                if ([cell.txtSpecies respondsToSelector:@selector(setAttributedPlaceholder:)]) {
                    UIColor *color = [UIColor blackColor];
                    cell.txtSpecies.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"report_wizard_screen_2_species_hint", "") attributes:@{NSForegroundColorAttributeName: color}];
                }
                cell.textView.text = NSLocalizedString(@"report_wizard_screen_2_offense_hint", @"");
                cell.txtAmount.tintColor = [UIColor blackColor];
                cell.txtSpecies.tintColor = [UIColor blackColor];
                UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
                cell.txtSpecies.leftView = paddingView;
                cell.txtSpecies.leftViewMode = UITextFieldViewModeAlways;
                paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
                cell.txtAmount.leftView = paddingView;
                cell.txtAmount.leftViewMode = UITextFieldViewModeAlways;
                
                cell.btnKg.tag = indexPath.row;
                if (cell.btnIndividual.isSelected) {
                    self.amountType = @"individuals";
                }
                cell.btnIndividual.tag = indexPath.row;
                cell.btnAlive.tag = indexPath.row;
                cell.btnDead.tag = indexPath.row;
                cell.btnMixed.tag = indexPath.row;
                cell.txtSpecies.text = species;
                return cell;
            }
        }
    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.specieTableView) {
        if (isUserSearch) {
            if ([dlg.languageISO isEqualToString:@"en"]) {
                Species *currentSpecies = [filteredSpecies objectAtIndex:indexPath.row];
                species = currentSpecies.specieCommonName;
                userSelectedSpecie = currentSpecies.specieID;
            

            }else{
                SpeciesTranslation *obj = [allSpeciesTranslations objectAtIndex:indexPath.row];
                if (obj!=nil) {
                    if ([obj.specieCommonName isEqualToString:@""] || obj.specieCommonName ==nil) {
                        species = obj.specieID.specieCommonName;
                    }else{
                        species = obj.specieCommonName;
                    }
                }else{
                    species = obj.specieID.specieCommonName;
                }
            }
        }else{
            Species *currentSpecies = [filteredSpecies objectAtIndex:indexPath.row];
            species = currentSpecies.specieCommonName;
            userSelectedSpecie = currentSpecies.specieID;
        }
        self.specieTableView.hidden = YES;
        NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:1 inSection:0];
        NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
        [self.tableViewReport reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.specieTableView) {
        return 44;
    }else{
        if (isMoreDetailPressed) {
            return 481;
        }else{
            if (indexPath.row==0) {
                return 87;
            }
            
            return 267;
        }
    }
}
#pragma mark -
#pragma mark - UIDatePickerDelegate
- (IBAction)dateTimePickerValueChanged:(id)sender {
    UIDatePicker *datePicker = (UIDatePicker*)sender;
    NSDate *userSelectedDate = [datePicker date];
    dateTime = [dateFormatter stringFromDate:userSelectedDate];
    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [self.tableViewReport reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -
#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *currentlocation = [locations firstObject];
    userLocation = currentlocation;
    location  = [NSString stringWithFormat:@"[%.03f,%.03f]",currentlocation.coordinate.latitude,currentlocation.coordinate.longitude];
    [self.locationManager stopUpdatingLocation];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:currentlocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            locationValues = location;
        }else{
            CLPlacemark *placeMark = [placemarks lastObject];
            locationValues = ABCreateStringWithAddressDictionary(placeMark.addressDictionary,NO);
            
            locationValues = [locationValues stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            locationValues = [locationValues stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            NSLog(@"location %@",locationValues);
        }
        NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:0 inSection:0];
        NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
        [self.locationManager stopUpdatingLocation];
        [self.tableViewReport reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    
}
#pragma mark -
#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    if (isMoreDetailPressed) {
        ReportDetail3TableViewCell *cell = (id)[self.tableViewReport cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (cell.txtValueEstimate == textField) {
            valueEstimate = cell.txtValueEstimate.text;
        }
        else if (cell.txtLicense == textField){
            license = textField.text;
        }else if (cell.txtVesselNumber == textField){
            vesselName = textField.text;
        }
        
    }
    {
        ReportDetail2TableViewCell *cell  = (id)[self.tableViewReport cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        if (textField == cell.txtAmount) {
            amount = cell.txtAmount.text;
        }
    }
    return [textField resignFirstResponder];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    
    
    return  YES;
}
- (void)textFieldValueChanged:(NSNotification*)notification
{
    ReportDetail2TableViewCell *cell  = (id)[self.tableViewReport cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITextField  *txtField = notification.object;
    
    if (txtField == cell.txtSpecies && txtField.text.length>2)
    {
        self.specieTableView.frame = CGRectMake(cell.txtSpecies.frame.origin.x, cell.txtSpecies.frame.origin.x, cell.txtSpecies.frame.size.width, 200);
        self.specieTableView.translatesAutoresizingMaskIntoConstraints = YES;
        self.specieTableView.hidden = NO;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"specieCommonName CONTAINS[cd] %@",txtField.text];
        NSArray *result = [[NSArray alloc]init];
        if ([dlg.languageISO isEqualToString:@"en"]) {
            result = [allSpecies filteredArrayUsingPredicate:predicate];
        }else{
            result = [allSpeciesTranslations filteredArrayUsingPredicate:predicate];
        }
        
        if (result.count == 0) {
            predicate = [NSPredicate predicateWithFormat:@"specieKnownAs CONTAINS[cd] %@",txtField.text];
            result = [allSpecies filteredArrayUsingPredicate:predicate];
        }
        filteredSpecies = [NSMutableArray arrayWithArray:result];
        if (filteredSpecies.count>0) {
            
            isUserSearch = YES;
            [self.specieTableView reloadData];
        }
    }
    else
    {
        self.specieTableView.hidden = YES;
    }
    if(txtField.text.length==0)
    {
        isUserSearch = NO;
        [self.specieTableView reloadData];
        
    }
    
}

#pragma mark -
#pragma mark - UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (isMoreDetailPressed) {
        ReportDetail3TableViewCell *cell = (id)[self.tableViewReport cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (textView == cell.txtViewOffenseDetail) {
            if ([textView.text isEqualToString:NSLocalizedString(@"report_wizard_screen_3_offense_details_hint", @"")]) {
                textView.text = @"";
                offenseDetail=textView.text;
                //textView.textColor = [UIColor blackColor]; //optional
            }
        }
        else if (textView == cell.txtViewMethod){
            if ([textView.text isEqualToString:NSLocalizedString(@"report_wizard_screen_3_method_hint", @"")]) {
                textView.text = @"";
                method = textView.text;
                // textView.textColor = [UIColor blackColor]; //optional
            }
        }
        else if (textView == cell.txtVehicleDescription){
            descriptionVehicle = textView.text;
        }
    }else{
        ReportDetail2TableViewCell *cell  = (id)[self.tableViewReport cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        if (textView == cell.textView) {
            if ([textView.text isEqualToString:NSLocalizedString(@"report_wizard_screen_2_offense_hint", @"")]) {
                textView.text = @"";
                offenseText = textView.text;
                //textView.textColor = [UIColor blackColor]; //optional
            }
        }
        
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ((isMoreDetailPressed)) {
        ReportDetail3TableViewCell *cell = (id)[self.tableViewReport cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (textView == cell.txtViewOffenseDetail) {
            if ([textView.text isEqualToString:@""]) {
                textView.text =NSLocalizedString(@"report_wizard_screen_3_offense_details_hint", @"");
                // textView.textColor = [UIColor lightGrayColor]; //optional
            }
            else{
                offenseDetail=textView.text;
            }
        }
        else if (textView == cell.txtViewMethod){
            if ([textView.text isEqualToString:@""]) {
                textView.text = NSLocalizedString(@"report_wizard_screen_3_method_hint", @"");
                //textView.textColor = [UIColor blackColor]; //optional
            }else{
                method = textView.text;
            }
        }else if (textView == cell.txtVehicleDescription){
            descriptionVehicle = textView.text;
        }
        
    }else{
        ReportDetail2TableViewCell *cell  = (id)[self.tableViewReport cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        if (textView == cell.textView) {
            if ([textView.text isEqualToString:@""]) {
                textView.text = NSLocalizedString(@"report_wizard_screen_2_offense_hint", @"");
                // textView.textColor = [UIColor lightGrayColor]; //optional
            }else{
                offenseText =textView.text;
            }
            
            
        }
    }
    [textView resignFirstResponder];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
#pragma mark -
#pragma mark - Keyboard
- (void)keyboardWillShow:(NSNotification *)sender
{
    CGFloat height = [[sender.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSTimeInterval duration = [[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions curveOption = [[sender.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue] << 16;
    
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState|curveOption animations:^{
        
    } completion:^(BOOL finished) {
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, height, 0);
        self.tableViewReport.contentInset = edgeInsets;
        self.tableViewReport.scrollIndicatorInsets = edgeInsets;
    }];
    
    
    
    
}

- (void)keyboardWillHide:(NSNotification *)sender
{
    NSTimeInterval duration = [[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions curveOption = [[sender.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue] << 16;
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState|curveOption animations:^{
        
    } completion:^(BOOL finished) {
        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
        self.tableViewReport.contentInset = edgeInsets;
        self.tableViewReport.scrollIndicatorInsets = edgeInsets;
        
    }];
    
    
}
#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    if ([touch.view isDescendantOfView:self.tableViewReport] || [touch.view isDescendantOfView:self.specieTableView]) {
        
        
        return NO;
    }
    
    
    return YES;
}

@end
