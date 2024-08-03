//
//  ReportDetail3TableViewCell.h
//  WildScan
//
//  Created by Shabir Jan on 27/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportDetail3TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *txtViewOffenseDetail;
@property (weak, nonatomic) IBOutlet UITextView *txtViewMethod;
@property (weak, nonatomic) IBOutlet UITextField *txtValueEstimate;
@property (weak, nonatomic) IBOutlet UITextField *txtOrigin;
@property (weak, nonatomic) IBOutlet UITextField *txtDestination;
@property (weak, nonatomic) IBOutlet UITextView *txtVehicleDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtLicense;
@property (weak, nonatomic) IBOutlet UITextField *txtVesselNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnOrigin;
@property (weak, nonatomic) IBOutlet UIButton *btnDestination;

@end
