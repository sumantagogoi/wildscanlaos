//
//  ReportDetailsViewController.h
//  WildScan
//
//  Created by Shabir Jan on 26/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "IdentifySpecieViewController.h"
@interface ReportDetailsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UITextViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)NSManagedObjectContext *moc;
@property (nonatomic,strong)CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITableView *tableViewReport;
- (IBAction)btnDateTimePressed:(id)sender;
- (IBAction)btnLocationPressed:(id)sender;
- (IBAction)btnBackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *DateTimeView;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateTimePicker;
- (IBAction)dateTimePickerValueChanged:(id)sender;
- (IBAction)btnDonePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblViewTitle;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet MKMapView *map;
- (IBAction)btnCancelPressed:(id)sender;
- (IBAction)btnSetPressed:(id)sender;
- (IBAction)btnCancelReportPressed:(id)sender;
- (IBAction)btnMoreDetailPressed:(id)sender;
- (IBAction)btnSubmitReportPressed:(id)sender;
- (IBAction)btnSpeciePressed:(id)sender;
- (IBAction)btnIndividualPressed:(id)sender;
- (IBAction)btnKgPressed:(id)sender;
- (IBAction)btnAlivePressed:(id)sender;
- (IBAction)btnDeadPressed:(id)sender;
- (IBAction)btnMixedPressed:(id)sender;
- (IBAction)btnOriginPressed:(id)sender;
- (IBAction)btnDestinationPressed:(id)sender;

@end
