//
//  DashboardViewController.m
//  WildScan
//
//  Created by Shabir Jan on 15/03/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "DashboardViewController.h"
#import "IdentifySpecieViewController.h"
#import "Events.h"
#import "EventTableViewCell.h"
#import "reverseGeoCoder.h"
#import "Species.h"
#import "EventsViewController.h"
#import "EventDetailsViewController.h"
#import "MapViewController.h"
#import "ImageSelectionViewController.h"
#import "GlobalTableViewCell.h"
#import "SettingTableViewCell.h"
#import "Content.h"
#import "SettingViewController.h"
#import "RegionStats.h"
#import "SynchHelper.h"
@interface DashboardViewController (){
    BOOL isRegionDownloading;
    RegionStats *regionBeingDownloaded;
}
@property (nonatomic,strong)NSMutableArray *events;
@property (nonatomic,strong)NSMutableArray *regions;
@property (nonatomic,strong)NSMutableArray *regionStats;
@end

@implementation DashboardViewController
@synthesize events;
@synthesize regions,regionStats;
-(void)fetchEventArray{
    events = [NSMutableArray arrayWithArray:[Events getAllEvents:self.moc]];
    NSArray *eventsArray = [events sortedArrayUsingFunction:dateSort context:nil];
    events = [NSMutableArray arrayWithArray:eventsArray];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    isRegionDownloading = NO;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.tutorialView.hidden = NO;
        self.backViewForBlurr.hidden = NO;
    }
   
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ISBACGROUNDKSYNC];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //[self.globalTableView registerNib:[UINib nibWithNibName:@"globalCell" bundle:nil] forCellReuseIdentifier:@"globalCell"];
    
    self.lblDialogHeading1.text = NSLocalizedString(@"region_dialog_heading1", @"");
    self.lblSpeciesContactsHeading.text = NSLocalizedString(@"region_dialog_heading2", @"");
    self.lblDownloadExtraHeading.text = NSLocalizedString(@"region_dialog_sub_title", @"");
    self.lblRegion.text =  NSLocalizedString(@"region_dialog_global", @"");
    
    // Comment out to avoid updating every launch
    /*
    SynchHelper *syncHelper = [[SynchHelper alloc]init];
    syncHelper.moc = self.moc;
    syncHelper.delegate = self;
    [syncHelper startSync];
    */
    
    regions = [NSMutableArray arrayWithArray:[Region getAllRegions:self.moc]];
    regionStats = [NSMutableArray arrayWithArray:[RegionStats getAllRegionStats:self.moc]];
    NSString *selectedr = [[NSUserDefaults standardUserDefaults] stringForKey:SELECTEDREGIONS];

    NSArray *sr = [selectedr componentsSeparatedByString:@","];
    NSInteger cnt = [sr count];
    NSInteger rcnt = [regionStats count];
    for (int i=0;i<cnt;i++) {
        for (int j=0;j<rcnt;j++) {
            RegionStats *currentObj = [regionStats objectAtIndex:j];
            if ([currentObj.regionStatRID isEqualToString:sr[i]]) {
                currentObj.regionIsDownloaded = [NSNumber numberWithBool:YES];
            }
        }
    }
    [self fetchEventArray];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOccured)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOccured)];
    tapGesture.delegate = self;
    [self.tutorialView addGestureRecognizer:tapGesture];
    
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOccured)];
    tapGesture.delegate = self;
    [self.tutorialImage addGestureRecognizer:tapGesture];
    
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOccured)];
    tapGesture.delegate = self;
    [self.backViewForBlurr addGestureRecognizer:tapGesture];
    // Do any additional setup after loading the view.
}

NSComparisonResult dateSort(Events *s1, Events *s2, void *context) {
    NSDateFormatter *dateFormatter2;
    dateFormatter2 = [[NSDateFormatter alloc]init];
    // [dateFormatter2 setDateFormat:@""];
    [dateFormatter2 setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter2 setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *d1 = [dateFormatter2 dateFromString:s1.eventIncidentDate];
    NSDate *d2 = [dateFormatter2 dateFromString:s2.eventIncidentDate];
    
    return [d2 compare:d1]; // ascending order
    
}
-(void)tapOccured{
    self.tutorialView.hidden = YES;
    self.globalView.hidden = YES;
    self.backViewForBlurr.hidden = YES;
    self.regionTableView.hidden = YES;
    self.menuTableView.hidden = YES;
    self.backBlurrView.hidden = YES;
    self.settingView.hidden = YES;
}
- (IBAction)btnViewMoreEventsPressed:(id)sender {
    EventsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"eventsVC"];
    vc.moc = self.moc ;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnMapPressed:(id)sender {
    MapViewController *mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mapVC"];
    mapVC.moc = self.moc;
    [self.navigationController pushViewController:mapVC animated:YES];
}

- (IBAction)btnSubmitReportPressed:(id)sender {
    ImageSelectionViewController *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"imageVC"];
    vc.moc = self.moc;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnGlobePressed:(id)sender {
    //self.backBlurrView.hidden = NO;
    self.globalView.hidden = NO;
    self.globalTableView.hidden = NO;
}

- (IBAction)btnGlobeViewPressed:(id)sender {
    self.globalTableView.hidden = YES;
    self.regionTableView.hidden = NO;
}

- (IBAction)btnMenuPressed:(id)sender {
    //self.backBlurrView.hidden = NO;
    self.menuTableView.hidden = NO;
}

- (IBAction)btnCheckmarkPressed:(id)sender {
    UIButton *buttonPressed = (UIButton*)sender;
    
    GlobalTableViewCell *cell = [self.globalTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:buttonPressed.tag inSection:0 ]];
    NSString *regionI = cell.regionID;
    RegionStats *currentObj = [regionStats objectAtIndex:[regionI integerValue]];
    
    if ([currentObj.regionStatRID isEqualToString:@"1"]) {
        
    }else{
        if ([currentObj.regionStatRID isEqualToString:@"2"]) {
            [cell.btnCheckmark setSelected:YES];
            
        }else if ([currentObj.regionStatRID isEqualToString:@"3"]){
            if ([cell.btnCheckmark isSelected]) {
                cell.btnCheckmark.selected = NO;
                [[NSUserDefaults standardUserDefaults]setValue:@"2" forKey:SELECTEDREGIONS];
            }else{
                cell.btnCheckmark.selected = YES;
                
                [[NSUserDefaults standardUserDefaults]setValue:@"2,4" forKey:SELECTEDREGIONS];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ISBACGROUNDKSYNC];
                [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:LASTSYNC];
                [[NSUserDefaults standardUserDefaults]synchronize];
                if ([currentObj.regionIsDownloaded boolValue]) {
                    
                }else{
                    regionBeingDownloaded= currentObj;
                    isRegionDownloading = YES;
                    SynchHelper *syncHelper = [[SynchHelper alloc]init];
                    syncHelper.moc = self.moc;
                    syncHelper.delegate = self;
                    [syncHelper startSync];
                }
                
            }
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnSelectRegionPressed:(id)sender {
    self.regionTableView.hidden = NO;
}

- (IBAction)btnSelectRegionSpeciesPressed:(id)sender {
    self.globalTableView.hidden = NO;
}

- (IBAction)btnContactPressed:(id)sender {
    ContactsViewController *contactVC = [self.storyboard instantiateViewControllerWithIdentifier:@"contactsVC"];
    contactVC.moc = self.moc;
    [self.navigationController pushViewController:contactVC animated:YES];
}
- (IBAction)btnSpeciesPressed:(id)sender {
    SpeciesLibraryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"speciesLibraryVC"];
    vc.moc = self.moc;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnIdentifySpeciePressed:(id)sender {
    IdentifySpecieViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"identifySpecieVC"];
    vc.moc = self.moc;
    vc.descriptionText=NSLocalizedString(@"id_wizard_questions_live_deceased", @"");
    [self.navigationController  pushViewController:vc animated:YES];
    
}
#pragma mark -
#pragma mark - UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.globalTableView) {
        return 1;
    }
    else {
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.globalTableView) {
        return 3; //regionStats.count;
    }
    else if (tableView == self.menuTableView){
        return 3;
    }
    else if (tableView == self.regionTableView){
        return regions.count;
    }else if (tableView == self.settingTableView){
        return 10;
    }
    return events.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.regionTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Region *currentRegion = [regions objectAtIndex:indexPath.row];
        NSString *regionLocalizedName = @"";
        if ([currentRegion.regionName isEqualToString:@"Global"]){
            regionLocalizedName = NSLocalizedString(@"region_dialog_global", @"");
        }
        else if ([currentRegion.regionName isEqualToString:@"West Africa"]){
            regionLocalizedName = NSLocalizedString(@"region_dialog_africa", @"");
        }
        else if ([currentRegion.regionName isEqualToString:@"South America"]){
            regionLocalizedName = NSLocalizedString(@"region_dialog_south_america", @"");
        }
        else if ([currentRegion.regionName isEqualToString:@"South East Asia"]){
            regionLocalizedName = NSLocalizedString(@"region_dialog_south_asia", @"");
        }
        cell.textLabel.text = regionLocalizedName;
        
        return cell;
    }
    else if (tableView == self.menuTableView){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
       
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell1"];
        }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"action_synchronize", @"");
        }else if (indexPath.row == 1){
            cell.textLabel.text = NSLocalizedString(@"action_settings", @"");
            
        }
        else if (indexPath.row == 2){
            cell.textLabel.text = NSLocalizedString(@"action_info", @"");
        }
        return cell;
        
    }
    else if (tableView == self.globalTableView) {
        /*
        NSFetchRequest *rfetch = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
        NSError *error = nil;
        NSArray *regionArray = [self.moc executeFetchRequest:rfetch error:&error];
        
        NSError *error = nil;
        NSFetchRequest *rsfetch = [NSFetchRequest fetchRequestWithEntityName:@"RegionStats"];
        NSArray *regionstatArray = [self.moc executeFetchRequest:rsfetch error:&error];
        */
        
        NSString *selectedr = [[NSUserDefaults standardUserDefaults] stringForKey:SELECTEDREGIONS];
        NSArray *sr = [selectedr componentsSeparatedByString:@","];
        
        GlobalTableViewCell *cell = nil;
        cell = (GlobalTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"globalCell"];
        if (cell == nil) {
            GlobalTableViewCell *cell = [[GlobalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"globalCell"];
        }
        
        /*
        GlobalTableViewCell *cell = (GlobalTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"globalCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        */
        //RegionStats *currentObj = [regionstatArray objectAtIndex: indexPath.row];
        //NSLog(@"Number of Species: %@\n",currentObj.regionStatTotalSpecies);
        if (indexPath.row == 0) {
            RegionStats *currentObj = [RegionStats getRegionStatForID:@"1" moc:self.moc];
            cell.lblName.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"region_dialog_global", @"")];
            cell.lblSpecies.text = [NSString stringWithFormat:@"Species: %@",currentObj.regionStatTotalSpecies];
            cell.lblContacts.text = [NSString stringWithFormat:@"Contacts: %@",currentObj.regionStatTotalContacts];
            cell.btnCheckmark.tag = indexPath.row;
            cell.regionID = @"1";
            cell.btnCheckmark.selected = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            /*
            if (currentObj.regionIsDownloaded) {
                cell.lblName.text = [cell.lblName.text stringByAppendingString:@" (Installed)"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            */
        }else if (indexPath.row==1){
            RegionStats *currentObj = [RegionStats getRegionStatForID:@"2" moc:self.moc];
            cell.lblName.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"region_dialog_south_asia", @"")];
            cell.lblSpecies.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"region_species", @""),currentObj.regionStatTotalSpecies];
            cell.lblContacts.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"region_contacts", @""),currentObj.regionStatTotalContacts];
            cell.btnCheckmark.tag = indexPath.row;
            cell.regionID = @"2";
            
            //if (currentObj.regionIsDownloaded) {
            if ([sr containsObject:@"2"]) {
                cell.lblName.text = [cell.lblName.text stringByAppendingString:@" (Installed)"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            /*
            if([currentObj.regionIsDownloaded boolValue]){
                cell.btnCheckmark.selected=YES;
            }else{
                cell.btnCheckmark.selected=NO;
            }
            */
        }else if (indexPath.row==2){
            RegionStats *currentObj = [RegionStats getRegionStatForID:@"3" moc:self.moc];
            cell.lblName.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"region_dialog_africa", @"")];
            cell.lblSpecies.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"region_species", @""),currentObj.regionStatTotalSpecies];
            cell.lblContacts.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"region_contacts", @""),currentObj.regionStatTotalContacts];
            cell.btnCheckmark.tag = indexPath.row;
            cell.regionID = @"3";
            //if (currentObj.regionIsDownloaded) {
            if ([sr containsObject:@"3"]) {
                cell.lblName.text = [cell.lblName.text stringByAppendingString:@" (Installed)"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            /*
            if([currentObj.regionIsDownloaded boolValue]){
                cell.btnCheckmark.selected=YES;
            }else{
                cell.btnCheckmark.selected=NO;
            }
            */
            //cell.btnCheckmark.enabled = true;
            //[cell.lblName setTextColor:[UIColor grayColor]];
            //[cell.lblContacts setTextColor:[UIColor grayColor]];
            //[cell.lblSpecies setTextColor:[UIColor grayColor]];

        }else if (indexPath.row==3){
            /*
             RegionStats *currentObj = [RegionStats getRegionStatForID:@"3" moc:self.moc];
            cell.lblName.text = [NSString stringWithFormat:@"%@ (%@)",NSLocalizedString(@"region_dialog_south_america", @""),NSLocalizedString(@"text_coming_soon", @"")];
            cell.lblSpecies.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"region_species", @""),currentObj.regionStatTotalSpecies];
            cell.lblContacts.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"region_contacts", @""),currentObj.regionStatTotalContacts];
            cell.btnCheckmark.tag = indexPath.row;
            cell.regionID = @"2";
            cell.btnCheckmark.enabled = false;
            [cell.lblName setTextColor:[UIColor grayColor]];
            [cell.lblContacts setTextColor:[UIColor grayColor]];
            [cell.lblSpecies setTextColor:[UIColor grayColor]];
            */
        }

        NSLog(@"Cell = %@\n", cell.lblName.text);
        return cell;
    }else if (tableView == self.settingTableView){
        SettingTableViewCell *cell = (SettingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"settingCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
        cell.lblTitle.numberOfLines = 0;
        cell.lblTitle.font = [cell.lblTitle.font fontWithSize:15];
      //  cell.backgroundColor = [UIColor lightGrayColor];
        if (indexPath.row == 0) {
            cell.lblTitle.text = NSLocalizedString(@"info_about", @"");
        }else if (indexPath.row == 1){
            cell.lblTitle.text = NSLocalizedString(@"info_eula", @"");
            
        }
        else if (indexPath.row == 2){
            cell.lblTitle.text = NSLocalizedString(@"info_consumer", @"");
        }
    
        else if (indexPath.row == 3){
            cell.lblTitle.text = NSLocalizedString(@"info_responder", @"");
        }

        else if (indexPath.row == 4){
            cell.lblTitle.text = NSLocalizedString(@"info_law_enforcement", @"");
        }

        else if (indexPath.row == 5){
            cell.lblTitle.text = NSLocalizedString(@"info_national_laws", @"");
        }

        else if (indexPath.row == 6){
            cell.lblTitle.text = NSLocalizedString(@"info_credits", @"");
        }
        else if (indexPath.row == 7){
            cell.lblTitle.text = NSLocalizedString(@"info_contributors", @"");
        }
        else if (indexPath.row == 8){
            cell.lblTitle.text = NSLocalizedString(@"info_help", @"");
        }
        else if (indexPath.row == 9){
            cell.lblTitle.text = NSLocalizedString(@"info_back", @"");
        }
        return cell;
    }
    else{
        EventTableViewCell *cell = (EventTableViewCell*)[self.eventsTableView dequeueReusableCellWithIdentifier:@"eventCell"];
        Events *currentObj = [events objectAtIndex:indexPath.row];
        
        cell.lblDate.text = currentObj.eventIncidentDate;
        cell.lblCountry.text = currentObj.eventCountry;
        Species *species = [Species getSpecieByID:currentObj.eventSpecies moc:self.moc];
        cell.lblSpecie.text = species.specieCommonName;
        cell.lblEventDetail.text = currentObj.eventIncident;
        if (currentObj.eventImageUrl == nil || [currentObj.eventImageUrl isEqualToString:@""]) {
            cell.eventImage.image = [UIImage imageNamed:@"empty_photo"];
        }else{
            cell.eventImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:currentObj.eventImageUrl]];
        }
        
        
        
        return cell;
    }
}
    
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.globalTableView) {
       // self.globalView.hidden = YES;
        GlobalTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSLog(@"%@", cell.regionID);
        
        if (![cell.regionID isEqualToString:@"1"]) {
            cell.btnCheckmark.selected = YES;
            RegionStats *currentObj = [RegionStats getRegionStatForID:cell.regionID moc:self.moc];
            NSLog(@"%@", currentObj.regionStatRID);
            
            //[[NSUserDefaults standardUserDefaults]setValue:cell.regionID forKey:SELECTEDREGIONS];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ISBACGROUNDKSYNC];
            [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:LASTSYNC];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSLog(@"%@", [currentObj.regionIsDownloaded stringValue]);
            //if ([currentObj.regionIsDownloaded boolValue]==TRUE) {
                //NSLog(@"This region has already been downloaded");
            //}else{

            //}
            
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        //regionBeingDownloaded= currentObj;
        isRegionDownloading = YES;
        SynchHelper *syncHelper = [[SynchHelper alloc]init];
        syncHelper.moc = self.moc;
        syncHelper.delegate = self;
        [syncHelper startSync];
        
        if (indexPath.row == 0) {
            [cell.btnCheckmark setSelected:YES];
        }else if (indexPath.row==1 || indexPath.row == 2){
            RegionStats *currentObj = [RegionStats getRegionStatForID:cell.regionID moc:self.moc];
            NSLog(@"%@", currentObj.regionStatRID);
            NSString *selectedr = [[NSUserDefaults standardUserDefaults] stringForKey:SELECTEDREGIONS];
            NSArray *sr = [selectedr componentsSeparatedByString:@","];
            //if ([cell.btnCheckmark isSelected]) {
            if ([sr containsObject:currentObj.regionStatRID]) {
                cell.btnCheckmark.selected = NO;
                currentObj.regionIsDownloaded =[NSNumber numberWithBool:NO];
                
                if (indexPath.row==1) {
                    cell.lblName.text = @"South East Asia";
                    if ([sr containsObject:@"3"]) {
                        [[NSUserDefaults standardUserDefaults]setValue:@"1,3" forKey:SELECTEDREGIONS];
                    }
                    else {
                        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:SELECTEDREGIONS];
                    }
                }
                else {
                    cell.lblName.text = @"Africa";
                    if ([sr containsObject:@"2"]) {
                        [[NSUserDefaults standardUserDefaults]setValue:@"1,2" forKey:SELECTEDREGIONS];
                    }
                    else {
                        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:SELECTEDREGIONS];
                    }
                }
                
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ISBACGROUNDKSYNC];
                [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:LASTSYNC];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }else{
                cell.btnCheckmark.selected = YES;
                currentObj.regionIsDownloaded =[NSNumber numberWithBool:YES];
                if (indexPath.row==1) {
                    cell.lblName.text = @"South East Asia (Installed)";
                    if ([sr containsObject:@"3"]) {
                        [[NSUserDefaults standardUserDefaults]setValue:@"1,2,3" forKey:SELECTEDREGIONS];
                    }
                    else {
                        [[NSUserDefaults standardUserDefaults]setValue:@"1,2" forKey:SELECTEDREGIONS];
                    }
                }
                else {
                    cell.lblName.text = @"Africa (Installed)";
                    if ([sr containsObject:@"2"]) {
                        [[NSUserDefaults standardUserDefaults]setValue:@"1,2,3" forKey:SELECTEDREGIONS];
                    }
                    else {
                        [[NSUserDefaults standardUserDefaults]setValue:@"1,3" forKey:SELECTEDREGIONS];
                    }
                }
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ISBACGROUNDKSYNC];
                [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:LASTSYNC];
                [[NSUserDefaults standardUserDefaults]synchronize];
                /*
                if ([currentObj.regionIsDownloaded boolValue]) {
                    
                }else{
                    regionBeingDownloaded= currentObj;
                    isRegionDownloading = YES;
                    SynchHelper *syncHelper = [[SynchHelper alloc]init];
                    syncHelper.moc = self.moc;
                    syncHelper.delegate = self;
                    [syncHelper startSync];
                }
                */
            }
            //[[NSUserDefaults standardUserDefaults]synchronize];
        }
        
    }
    else if (tableView == self.menuTableView){
        self.menuTableView.hidden = YES;
        //self.backBlurrView.hidden = YES;
        UITableViewCell *cell = [self.menuTableView cellForRowAtIndexPath:indexPath];
        if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"action_settings",@"")]) {
            SettingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"settingVC"];
            vc.moc = self.moc;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"action_info", @"")]){
            //self.backBlurrView.hidden = NO;
            self.settingView.hidden = NO;
            self.infoView.hidden = YES;
    
        }else{
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ISBACGROUNDKSYNC];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            SynchHelper *syncHelper = [[SynchHelper alloc]init];
            syncHelper.moc = self.moc;
            syncHelper.delegate = self;
            [syncHelper startSync];
        }
        
    }
    else if (tableView == self.settingTableView){
        NSString *contentToLoad=[[NSString alloc]init];
        NSString *currentLanguage = [[NSUserDefaults standardUserDefaults]valueForKey:CURRENTLANGUAGE];
        NSLog(@"content %@",[Content getContent:@"en" type:@"about" moc:self.moc]);
        Content *currentObj= nil;
        if (indexPath.row == 0) {
            self.lblSetting.text= NSLocalizedString(@"info_about", @"");
            currentObj = [Content getContent:currentLanguage type:@"about" moc:self.moc];
            if (!currentObj) {
                currentObj = [Content getContent:@"en" type:@"about" moc:self.moc];
            }
        }else if (indexPath.row == 1){
            self.lblSetting.text = NSLocalizedString(@"info_eula", @"");
            currentObj = [Content getContent:currentLanguage type:@"terms" moc:self.moc];
            if (!currentObj) {
                currentObj = [Content getContent:@"en" type:@"terms" moc:self.moc];
            }
        }
        else if (indexPath.row == 2){
            self.lblSetting.text = NSLocalizedString(@"info_consumer", @"");
            currentObj = [Content getContent:currentLanguage type:@"consumer-advice" moc:self.moc];
            if (!currentObj) {
                currentObj = [Content getContent:@"en" type:@"consumer-advice" moc:self.moc];
            }
        }
        else if (indexPath.row == 3){
            self.lblSetting.text = NSLocalizedString(@"info_responder", @"");
            currentObj = [Content getContent:currentLanguage type:@"first-responder" moc:self.moc];
            if (!currentObj) {
                currentObj = [Content getContent:@"en" type:@"first-responder" moc:self.moc];
            }
        }
        
        else if (indexPath.row == 4){
            self.lblSetting.text = NSLocalizedString(@"info_law_enforcement", @"");
            currentObj = [Content getContent:currentLanguage type:@"enforcement-advice" moc:self.moc];
            if (!currentObj) {
                currentObj = [Content getContent:@"en" type:@"enforcement-advice" moc:self.moc];
            }
        }
        
        else if (indexPath.row == 5){
            self.lblSetting.text = NSLocalizedString(@"info_national_laws", @"");
            currentObj = [Content getContent:currentLanguage type:@"legal" moc:self.moc];
            if (!currentObj) {
                currentObj = [Content getContent:@"en" type:@"legal" moc:self.moc];
            }
        }
        
        else if (indexPath.row == 6){
            self.lblSetting.text = NSLocalizedString(@"info_credits", @"");
            currentObj = [Content getContent:currentLanguage type:@"credits" moc:self.moc];
            if (!currentObj) {
                currentObj = [Content getContent:@"en" type:@"credits" moc:self.moc];
            }
        }
        else if (indexPath.row == 7){
            self.lblSetting.text = NSLocalizedString(@"info_contributors", @"");
            currentObj = [Content getContent:currentLanguage type:@"contributor" moc:self.moc];
            if (!currentObj) {
                currentObj = [Content getContent:@"en" type:@"contributor" moc:self.moc];
            }
        }
        else if (indexPath.row == 8){
            self.lblSetting.text = NSLocalizedString(@"info_help", @"");
            currentObj = [Content getContent:currentLanguage type:@"help" moc:self.moc];
            if (!currentObj) {
                currentObj = [Content getContent:@"en" type:@"help" moc:self.moc];
            }
        }
        if (indexPath.row==9) {
            self.tutorialView.hidden = YES;
            self.globalView.hidden = YES;
            self.backViewForBlurr.hidden = YES;
            self.regionTableView.hidden = YES;
            self.menuTableView.hidden = YES;
            self.backBlurrView.hidden = YES;
            self.settingView.hidden = YES;
            //[self.settingTableView setHidden:YES];
            //[self.infoView setHidden:YES];
        } else {
            contentToLoad = currentObj.contentBody;
            [self.webView loadHTMLString:contentToLoad baseURL:nil];
            [self.settingTableView setHidden:YES];
            [self.infoView setHidden:NO];
        }
    }
    else if (tableView == self.regionTableView){
        Region *currentRegion =[regions objectAtIndex:indexPath.row];
        
        NSString *regionLocalizedName = @"";
        if ([currentRegion.regionName isEqualToString:@"Global"]){
            regionLocalizedName = NSLocalizedString(@"region_dialog_global", @"");
        }else if ([currentRegion.regionName isEqualToString:@"West Africa"]){
            regionLocalizedName = NSLocalizedString(@"region_dialog_africa", @"");
            
        }else if ([currentRegion.regionName isEqualToString:@"South America"]){
            regionLocalizedName = NSLocalizedString(@"region_dialog_south_america", @"");
            
        }else if ([currentRegion.regionName isEqualToString:@"South East Asia"]){
            regionLocalizedName = NSLocalizedString(@"region_dialog_south_asia", @"");
            
        }
        
        self.lblRegion.text = regionLocalizedName;
        [self.regionTableView setHidden:YES];
        [[NSUserDefaults standardUserDefaults]setValue:currentRegion.regionID forKey:REPORTINGREGION];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else{
    Events *currentEvent = [events objectAtIndex:indexPath.row];
    
    EventDetailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetailsVC"];
    vc.moc = self.moc;
    vc.currentEvent = currentEvent;
    [self.navigationController pushViewController:vc animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.settingTableView) {
        return 60;
    }else if (tableView == self.eventsTableView ){
        return 80;
    }
    else if (tableView == self.globalTableView){
        return 63;
    }
    return 44;
}
#pragma mark -
#pragma mark - GestureReconginzer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    if ([touch.view isDescendantOfView:self.eventsTableView] || [touch.view isDescendantOfView:self.globalTableView] || [touch.view isDescendantOfView:self.globalView] || [touch.view isDescendantOfView:self.regionTableView] || [touch.view isDescendantOfView:self.menuTableView]|| [touch.view isDescendantOfView:self.settingTableView]) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    
    
    return YES;
}


- (IBAction)btnBackSetting:(id)sender {
    self.infoView.hidden = YES;
    self.settingTableView.hidden = NO;
}
#pragma mark -
#pragma mark -
-(void)synchHelper:(SynchHelper *)client didSyncSuccess:(BOOL)success{
    if (isRegionDownloading) {
        regionBeingDownloaded.regionIsDownloaded=[NSNumber numberWithBool:YES];
        [self.moc save:nil];
    }
    [SVProgressHUD dismiss];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
	[dateFormatter setTimeZone:timeZone];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
	[[NSUserDefaults standardUserDefaults]setValue:dateString forKey:LASTSYNC];
	[[NSUserDefaults standardUserDefaults]synchronize];    [events removeAllObjects];
    [self fetchEventArray];
      [self.eventsTableView reloadData];
    NSLog(@"ok");
}

-(void)synchHelper:(SynchHelper *)client didSyncFailed:(NSError *)error{
     [SVProgressHUD dismiss];
//	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//	NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
//	[dateFormatter setTimeZone:timeZone];
//	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//	NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
//	[[NSUserDefaults standardUserDefaults]setValue:dateString forKey:LASTSYNC];
//	[[NSUserDefaults standardUserDefaults]synchronize];
	[self.eventsTableView reloadData];
    NSLog(@"%@",[error localizedDescription]);
}
@end
