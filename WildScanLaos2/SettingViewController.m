//
//  SettingViewController.m
//  WildScan
//
//  Created by Shabir Jan on 10/05/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//
#import "AppDelegate.h"
#import "SettingViewController.h"
#import "Setting2TableViewCell.h"
#import "GalleryTableViewCell.h"
@interface SettingViewController ()
@property (nonatomic,strong)NSString *galleryStyle;
@property (nonatomic)BOOL isGallerySelected;
@property (nonatomic)BOOL isListSelected;
@property (nonatomic)BOOL isOtherSelected;
@property (nonatomic,strong)NSMutableArray *allContacts;
@end

@implementation SettingViewController
@synthesize allContacts;
- (void)viewDidLoad {
    [super viewDidLoad];
    allContacts = [NSMutableArray arrayWithArray:[Contacts getAllContacts:self.moc]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)btnCheckmarkPressed:(id)sender {
    UIButton *btn = (UIButton*)sender;
    Setting2TableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
    if ([cell.btnCheckmark isSelected]) {
        [cell.btnCheckmark setSelected:NO];
        if (btn.tag==0) {
             [[NSUserDefaults standardUserDefaults]setBool:NO forKey:SAVEREPORT];
        }else{
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:SHOWREPORTWARNING];
        }
    }else{
        [cell.btnCheckmark setSelected:YES];
        if (btn.tag==0) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:SAVEREPORT];
        }else{
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:SHOWREPORTWARNING];
        }
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (IBAction)btnCancelContactPressed:(id)sender {
    self.contactsView.hidden =YES;
    self.backBlurrView.hidden =YES;
}

- (IBAction)btnOkPressed:(id)sender {
    self.contactsView.hidden =YES;
    self.backBlurrView.hidden =YES;
}
- (IBAction)btnCancelPressed:(id)sender {
    self.galleryView.hidden = YES;
    self.backBlurrView.hidden = YES;
}

- (IBAction)btnRadioPressed:(id)sender {
//    UIButton *btn = (UIButton*)sender;
//    GalleryTableViewCell *cell = [self.galleryTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
//    if ([cell.btnRadio isSelected]) {
//        [cell.btnRadio setSelected:NO];
//    }else{
//        [cell.btnRadio setSelected:YES];
//    }
}
- (IBAction)btnBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark - UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.galleryTable) {
        return 3;
    }
    else if (tableView == self.contactsTableView){
        return allContacts.count;
    }
    return 5;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.mainTableView) {
        
        
        Setting2TableViewCell *cell = (Setting2TableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"setting2Cell"];
        cell.backgroundColor= [UIColor clearColor];
        if (indexPath.row == 0) {
            cell.lblMain.text = NSLocalizedString(@"pref_label_save_report", @"");
            cell.lblSub.text = NSLocalizedString(@"pref_summary_save_report", @"");
            cell.btnCheckmark.tag = indexPath.row;
            BOOL isSaveReport = [[NSUserDefaults standardUserDefaults]boolForKey:SAVEREPORT];
            if (isSaveReport) {
                cell.btnCheckmark.selected = YES;
            }else{
                cell.btnCheckmark.selected = NO;
            }
        }
        else if (indexPath.row == 1){
            cell.lblMain.text = NSLocalizedString(@"pref_label_show_warning", @"");
            cell.lblSub.text = NSLocalizedString(@"pref_summary_show_warning", @"");
            cell.btnCheckmark.tag = indexPath.row;
            BOOL isReportWarning = [[NSUserDefaults standardUserDefaults]boolForKey:SHOWREPORTWARNING];
            if (isReportWarning) {
                cell.btnCheckmark.selected = YES;
            }else{
                cell.btnCheckmark.selected = NO;
            }
        }
        else if (indexPath.row == 2){
            cell.lblMain.text = NSLocalizedString(@"pref_label_gallery_view", @"");
            BOOL isGallerySelected1 = [[NSUserDefaults standardUserDefaults]boolForKey:SHOWGALLERY];
            BOOL isListSelected1 = [[NSUserDefaults standardUserDefaults]boolForKey:SHOWLIST];
            BOOL isAsILeftSelected1 = [[NSUserDefaults standardUserDefaults]boolForKey:SHOWASILEFT];
            if (isGallerySelected1) {
                cell.lblSub.text = NSLocalizedString(@"pref_gallery_view_gallery", @"");
            }else if (isListSelected1){
                cell.lblSub.text = NSLocalizedString(@"pref_gallery_view_list", @"");
            }
            else if (isAsILeftSelected1){
                cell.lblSub.text = NSLocalizedString(@"pref_gallery_view_as_left", @"");
            }
            else{
                cell.lblSub.text = self.galleryStyle;
            }
            
            cell.btnCheckmark.hidden = YES;
        }
        else if (indexPath.row == 3){
            //cell.lblMain.enabled = false;
            //cell.lblSub.enabled = false;
            cell.lblMain.text = NSLocalizedString(@"pref_label_language", @"");
            cell.lblSub.text = NSLocalizedString(@"pref_entry_device_language", @"");
            cell.btnCheckmark.hidden = YES;
        }
        else if (indexPath.row == 4){
            cell.lblMain.text = NSLocalizedString(@"pref_label_auto_contacts", @"");
            cell.lblSub.text = NSLocalizedString(@"pref_summary_auto_contacts", @"");
            cell.btnCheckmark.hidden= YES;
        }
        
        return cell;
    }else if(tableView == self.galleryTable) {
        GalleryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gallery1Cell"];
        cell.backgroundColor= [UIColor clearColor];
        if (indexPath.row ==0) {
            cell.lblMain.text = NSLocalizedString(@"pref_gallery_view_gallery", @"");
            cell.btnRadio.tag = indexPath.row;
            BOOL isGallerySelected1 = [[NSUserDefaults standardUserDefaults]boolForKey:SHOWGALLERY];
            if (_isGallerySelected || isGallerySelected1) {
                cell.btnRadio.selected =YES;
            }
        }
        else if (indexPath.row == 1){
            cell.lblMain.text = NSLocalizedString(@"pref_gallery_view_list", @"");
            cell.btnRadio.tag = indexPath.row;
            BOOL isListSelected1 = [[NSUserDefaults standardUserDefaults]boolForKey:SHOWLIST];
            if (_isListSelected || isListSelected1) {
                cell.btnRadio.selected =YES;
            }
        }else{
            cell.lblMain.text = NSLocalizedString(@"pref_gallery_view_as_left", @"");
            BOOL isAsILeftSelected1 = [[NSUserDefaults standardUserDefaults]boolForKey:SHOWASILEFT];
            if (_isOtherSelected || isAsILeftSelected1) {
                cell.btnRadio.selected = YES;
            }
        }
        
        return cell;
    }else{
        GalleryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"galleryCell2"];
        cell.backgroundColor= [UIColor clearColor];
        Contacts *currentObj = [allContacts objectAtIndex:indexPath.row];
        if ([currentObj.contactSelectedForReport boolValue]) {
            cell.btnRadio.selected = YES;
        }else{
            cell.btnRadio.selected = NO;
        }
        cell.lblMain.text = currentObj.contactName;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.galleryTable) {
        return 40;
    }else if (tableView == self.contactsTableView){
        return 58;
    }
    return 75;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.mainTableView) {
        if (indexPath.row == 0) {
            Setting2TableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            if ([cell.btnCheckmark isSelected]) {
                [cell.btnCheckmark setSelected:NO];
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:SAVEREPORT];
            }else{
                [cell.btnCheckmark setSelected:YES];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:SAVEREPORT];
            }
        }
        else if (indexPath.row == 1){
            Setting2TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if ([cell.btnCheckmark isSelected]) {
                [cell.btnCheckmark setSelected:NO];
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:SHOWREPORTWARNING];
            }else{
                [cell.btnCheckmark setSelected:YES];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:SHOWREPORTWARNING];
            }
        }
        else if (indexPath.row == 2){
            self.galleryView.hidden = NO;
            self.backBlurrView.hidden = NO;
        }
        else if (indexPath.row == 3) {
            self.backBlurrView.hidden = NO;
        }
        else if (indexPath.row == 4){
            self.contactsView.hidden =NO;
            self.backBlurrView.hidden =NO;
        }
    }else if (tableView == self.galleryTable){
        if (indexPath.row ==0) {
            
            _isGallerySelected = YES;
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:SHOWGALLERY];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:SHOWLIST];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:SHOWASILEFT];
            _isListSelected = NO;
            _isOtherSelected = NO;
            GalleryTableViewCell *cell1 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell1.btnRadio.selected = YES;
            GalleryTableViewCell *cell2 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            cell2.btnRadio.selected = NO;
            GalleryTableViewCell *cell3 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            cell3.btnRadio.selected = NO;
             self.galleryStyle = @"Gallery";
        }else if (indexPath.row==1){
            _isListSelected = YES;
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:SHOWGALLERY];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:SHOWLIST];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:SHOWASILEFT];
            _isGallerySelected = NO;
            GalleryTableViewCell *cell1 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell1.btnRadio.selected = NO;
            GalleryTableViewCell *cell2 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            cell2.btnRadio.selected = YES;
            GalleryTableViewCell *cell3 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            cell3.btnRadio.selected = NO;
            _isOtherSelected = NO;

            self.galleryStyle = @"List";
        }else{
            _isListSelected = NO;
            _isGallerySelected = NO;
            GalleryTableViewCell *cell1 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell1.btnRadio.selected = NO;
            GalleryTableViewCell *cell2 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            cell2.btnRadio.selected = NO;
            GalleryTableViewCell *cell3 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            cell3.btnRadio.selected = YES;
            _isOtherSelected = YES;
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:SHOWGALLERY];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:SHOWLIST];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:SHOWASILEFT];
            self.galleryStyle = @"As i left it";
            
        }
        [self.mainTableView reloadData];
        self.galleryView.hidden = YES;
        self.backBlurrView.hidden = YES;
    }else{
        GalleryTableViewCell *cell1 = [tableView cellForRowAtIndexPath:indexPath];
        cell1.btnRadio.selected =!cell1.btnRadio.isSelected;
        Contacts *contact = [allContacts objectAtIndex:indexPath.row];
        if (cell1.btnRadio.isSelected) {
            contact.contactSelectedForReport = [NSNumber numberWithBool:YES];
        }else{
            contact.contactSelectedForReport = [NSNumber numberWithBool:NO];
        }
        [self.moc save:nil];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}



@end
