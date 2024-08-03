//
//  DashboardViewController.h
//  WildScan
//
//  Created by Shabir Jan on 15/03/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Region.h"
#import "SynchHelper.h"
#import <WebKit/WebKit.h>

@interface DashboardViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,SyncHelperDelegate>
- (IBAction)btnContactPressed:(id)sender;
@property (nonatomic,strong)NSManagedObjectContext *moc;
- (IBAction)btnSpeciesPressed:(id)sender;
- (IBAction)btnIdentifySpeciePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *eventsTableView;
- (IBAction)btnViewMoreEventsPressed:(id)sender;
- (IBAction)btnMapPressed:(id)sender;
- (IBAction)btnSubmitReportPressed:(id)sender;
- (IBAction)btnGlobePressed:(id)sender;
- (IBAction)btnMenuPressed:(id)sender;
- (IBAction)btnCheckmarkPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *globalView;
-(IBAction)btnSelectRegionSpeciesPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *globalTableView;
- (IBAction)btnSelectRegionPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblRegion;
@property (weak, nonatomic) IBOutlet UITableView *regionTableView;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UIView *backBlurrView;
@property (weak, nonatomic) IBOutlet UIView *tutorialView;
@property (weak, nonatomic) IBOutlet UIImageView *tutorialImage;
@property (weak, nonatomic) IBOutlet UIView *backViewForBlurr;
@property (weak, nonatomic) IBOutlet UIView *settingView;
@property (weak, nonatomic) IBOutlet UITableView *settingTableView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
- (IBAction)btnBackSetting:(id)sender;
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *lblSetting;
@property (weak, nonatomic) IBOutlet UILabel *lblDialogHeading1;
@property (weak, nonatomic) IBOutlet UILabel *lblSpeciesContactsHeading;
@property (weak, nonatomic) IBOutlet UILabel *lblDownloadExtraHeading;

@end
