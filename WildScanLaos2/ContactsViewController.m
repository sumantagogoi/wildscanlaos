//
//  ContactsViewController.m
//  WildScan
//
//  Created by Shabir Jan on 14/03/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "ContactsViewController.h"
#import "SubmitReportViewController.h"
@interface ContactsViewController (){
    AppDelegate *app;
}
@property (nonatomic,strong)NSMutableArray *allContacts;
@property (nonatomic,strong)NSMutableArray *allContactsTranslations;
@property (nonatomic)BOOL isUserSearch;
@end

@implementation ContactsViewController
@synthesize allContacts;
@synthesize isUserSearch;
@synthesize allContactsTranslations;
- (void)viewDidLoad {
    [super viewDidLoad];
    isUserSearch = NO;
    self.contactTableView.estimatedRowHeight =  230;
    self.contactTableView.rowHeight = UITableViewAutomaticDimension;
    
    
    app = [[UIApplication sharedApplication]delegate];
    
    allContacts = [NSMutableArray arrayWithArray:[Contacts getAllContacts:self.moc]];
    allContactsTranslations = [NSMutableArray arrayWithArray:[ContactsTranslation getAllContactsWithTranslation:app.languageISO moc:self.moc]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOccured)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    
    [self.contactTableView reloadData];
    // Do any additional setup after loading the view.
}
-(void)tapOccured{
    
    
    
    self.txtSearchView.text = NSLocalizedString(@"contacts_list_search_by_name_hint", @"");
    [self.txtSearchView resignFirstResponder];
    [self.searchView setHidden:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)btnFavoriteShowPressed:(id)sender {
    if (self.btnFavoriteShow.isSelected) {
        self.btnFavoriteShow.selected = NO;
        [allContacts removeAllObjects];
        allContacts = [NSMutableArray arrayWithArray:[Contacts getAllContacts:self.moc]];
        [self.contactTableView reloadData];
    }else{
        self.btnFavoriteShow.selected = YES;
        [allContacts removeAllObjects];
        allContacts =[NSMutableArray arrayWithArray:[Contacts getAllFavoriteContacts:self.moc]];
        if (allContacts.count>0) {
            [self.contactTableView reloadData];
        }else{
            [allContacts removeAllObjects];
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"msg_contact_fav_empty", @"")];
            [self.btnFavoriteShow setSelected:NO];
            allContacts = [NSMutableArray arrayWithArray:[Contacts getAllContacts:self.moc]];
            [self.contactTableView reloadData];
            
        }
        
    }
}
- (IBAction)btnSearchPressed:(id)sender {
    [self.searchView setHidden:NO];
}
- (IBAction)btnCellFavoritePressed:(id)sender {
    UIButton *pressedBtn = (UIButton*)sender;
    NSInteger indexPath = pressedBtn.tag;
    Contacts *currentObj = [allContacts objectAtIndex:indexPath];
    if ([currentObj.isContactFavorite boolValue]) {
        currentObj.isContactFavorite = [NSNumber numberWithBool:NO];
        [self.moc save:nil];
        pressedBtn.selected = NO;
        [allContacts removeObject:currentObj];
        [self.contactTableView reloadData];
        if (allContacts.count == 0) {
            [self btnFavoriteShowPressed:nil];
        }
    }else{
        pressedBtn.selected = YES;
        currentObj.isContactFavorite = [NSNumber numberWithInt:YES];
        [self.moc save:nil];
        [self.contactTableView reloadData];
    }
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
    return allContacts.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactTableViewCell *cell = (ContactTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"contactCell"];
    AppDelegate*dlg = [[UIApplication sharedApplication]delegate];
    NSString *type;
    NSString *region;
    NSString *city;
    NSString *country;
    NSString *agency;
    NSString *specalitynote;
    NSString *email ;
    NSString *phone ;
    NSString *address1 ;
    NSString *address2 ;
    NSString *website ;
    NSString *contactDetails;
    NSString *lat;
    NSString *lon;
    
    if ([dlg.languageISO isEqualToString:@"en"]) {//} || [dlg.languageISO isEqualToString:@"fr"] || [dlg.languageISO isEqualToString:@"pt"]) {
        Contacts *currentObj = [allContacts objectAtIndex:indexPath.row];
        cell.contactName.lineBreakMode = NSLineBreakByWordWrapping;
        cell.contactName.numberOfLines = 0;
        cell.contactName.text = currentObj.contactName;
        
        cell.contactAvatar.image = [UIImage imageNamed:currentObj.contactAvatarUrl];
        
        
        specalitynote = currentObj.contactSpecialCapacityScope;
        email = currentObj.contactEmail;
        phone = currentObj.contactPhone;
        address1 = currentObj.contactAddress1;
        address2 = currentObj.contactAddress2;
        website = currentObj.contactWebsite;
        type = currentObj.contactType;
        country = currentObj.contactCountry;
        region = currentObj.contactRegion;
        city = currentObj.contactCity;
        agency = currentObj.contactAgency;
        lat = currentObj.contactLat;
        lon = currentObj.contactLon;
        
        cell.btnFavorite.tag = indexPath.row;
        
        BOOL isFavorite = [currentObj.isContactFavorite boolValue];
        if (isFavorite) {
            cell.btnFavorite.selected = YES;
        }else{
            cell.btnFavorite.selected = NO;
        }
        
        
        if (![email  isEqualToString: @""]) {
            email = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"contacts_list_label_email", @""),email];
        }
        if (![phone isEqualToString:@""]) {
            phone = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"contacts_list_label_phone", @""),phone];
        }
        
        

        if (![lat isEqualToString:@""]) {
            contactDetails = [NSString stringWithFormat:@"Type: %@\nCountry: %@\n\n%@\n\n%@\n%@\n\n%@\n%@\n%@\nLat/Lon: %@,%@",type,country,agency,email,phone,address1,address2,website,lat,lon];
        }
        else {
            contactDetails = [NSString stringWithFormat:@"Type: %@\nCountry: %@\n\n%@\n\n%@\n%@\n\n%@\n%@\n%@",type,country,agency,email,phone,address1,address2,website];
        }
    }else{
        if (isUserSearch){
            
            ContactsTranslation *obj2 = [allContacts objectAtIndex:indexPath.row];
            Contacts *obj = [Contacts getContactByID:obj2.contactID.contactID moc:self.moc];
            
            
            cell.contactName.lineBreakMode = NSLineBreakByWordWrapping;
            cell.contactName.numberOfLines = 0;
            NSString *contactName = @"";
            if (obj2 != nil) {
                if ([obj2.contactName isEqualToString:@""] || obj2.contactName == nil) {
                    contactName = obj.contactName;
                }else{
                    contactName = obj2.contactName;
                }
                
            }
            else{
                contactName = obj.contactName;
            }
            cell.contactName.text = contactName;
            
            
            cell.contactAvatar.image = [UIImage imageNamed:obj.contactAvatarUrl];
            
            
            specalitynote = obj2.contactSpecailityNote;
            agency = obj2.contactAgency;
            email = obj.contactEmail;
            phone = obj.contactPhone;
            address1 = obj2.contactAddress1;
            address2 = obj2.contactAddress2;
            website = obj.contactWebsite;
            lat = obj.contactLat;
            lon = obj.contactLon;
            type = obj.contactType;
            country = obj.contactCountry;
            
            cell.btnFavorite.tag = indexPath.row;
            
            if ([specalitynote isEqualToString:@""] || specalitynote == nil) {
                specalitynote = obj.contactSpecialCapacityScope;
            }
            if ([address1 isEqualToString:@""] || address1 == nil) {
                address1 = obj.contactAddress1;
            }
            if ([address2 isEqualToString:@""] || address2 == nil) {
                address2 = obj.contactAddress2;
            }
            
            
            BOOL isFavorite = [obj.isContactFavorite boolValue];
            if (isFavorite) {
                cell.btnFavorite.selected = YES;
            }else{
                cell.btnFavorite.selected = NO;
            }
            
            
            if (![email  isEqualToString: @""]) {
                email = [NSString stringWithFormat:@"Email: %@",email];
            }
            if (![phone isEqualToString:@""]) {
                phone = [NSString stringWithFormat:@"Phone: %@",phone];
            }
            
            if (![lat isEqualToString:@""]) {
                contactDetails = [NSString stringWithFormat:@"Type: %@\nCountry: %@\n\n%@\n\n%@\n%@\n\n%@\n%@\n%@\nLat/Lon: %@,%@",type,country,agency,email,phone,address1,address2,website,lat,lon];
            }
            else {
                contactDetails = [NSString stringWithFormat:@"Type: %@\nCountry: %@\n\n%@\n\n%@\n%@\n\n%@\n%@\n%@",type,country,agency,email,phone,address1,address2,website];
            }

        }else{
            Contacts *obj = [allContacts objectAtIndex:indexPath.row];
            ContactsTranslation *obj2 = [ContactsTranslation getContactTranslationByID:obj language:[[NSUserDefaults standardUserDefaults]valueForKey:CURRENTLANGUAGE] moc:self.moc];
            
            
            cell.contactName.lineBreakMode = NSLineBreakByWordWrapping;
            cell.contactName.numberOfLines = 0;
            NSString *contactName = @"";
            if (obj2 != nil) {
                if ([obj2.contactName isEqualToString:@""] || obj2.contactName == nil) {
                    contactName = obj.contactName;
                }else{
                    contactName = obj2.contactName;
                }
                
            }
            else{
                contactName = obj.contactName;
            }
            cell.contactName.text = contactName;
            
            cell.contactAvatar.image = [UIImage imageNamed:obj.contactAvatarUrl];
            
            
            specalitynote = obj2.contactSpecailityNote;
            agency = obj2.contactAgency;
            email = obj.contactEmail;
            phone = obj.contactPhone;
            address1 = obj2.contactAddress1;
            address2 = obj2.contactAddress2;
            website = obj.contactWebsite;
            cell.btnFavorite.tag = indexPath.row;
            lat = obj.contactLat;
            lon = obj.contactLon;
            type = obj.contactType;
            country = obj.contactCountry;

            if ([specalitynote isEqualToString:@""] || specalitynote == nil) {
                specalitynote = obj.contactSpecialCapacityScope;
            }
            if ([address1 isEqualToString:@""] || address1 == nil) {
                address1 = obj.contactAddress1;
            }
            if ([address2 isEqualToString:@""] || address2 == nil) {
                address2 = obj.contactAddress2;
            }
            
            
            BOOL isFavorite = [obj.isContactFavorite boolValue];
            if (isFavorite) {
                cell.btnFavorite.selected = YES;
            }else{
                cell.btnFavorite.selected = NO;
            }
            
            
            if (![email  isEqualToString: @""]) {
                email = [NSString stringWithFormat:@"Email: %@",email];
            }
            if (![phone isEqualToString:@""]) {
                phone = [NSString stringWithFormat:@"Phone: %@",phone];
            }
            
            if (![lat isEqualToString:@""]) {
                contactDetails = [NSString stringWithFormat:@"Type: %@\nCountry: %@\n\n%@\n\n%@\n%@\n\n%@\n%@\n%@\nLat/Lon: %@,%@",type,country,agency,email,phone,address1,address2,website,lat,lon];
            }
            else {
                contactDetails = [NSString stringWithFormat:@"Type: %@\nCountry: %@\n\n%@\n\n%@\n%@\n\n%@\n%@\n%@",type,country,agency,email,phone,address1,address2,website];
            }
        }
    }
    cell.contactDetails.lineBreakMode = NSLineBreakByWordWrapping;
    cell.contactDetails.numberOfLines = 0;
    cell.contactDetails.text = contactDetails;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isContactSelection) {
        
        
        
        BOOL isVCFound = NO;
        NSMutableArray *allControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        for (id object in allControllers) {
            if ([object isKindOfClass:[SubmitReportViewController class]]) {
                if (isUserSearch) {
                    ContactsTranslation *obj2 = [allContacts objectAtIndex:indexPath.row];
                    Contacts *currentContact = [Contacts getContactByID:obj2.contactID.contactID moc:self.moc];
                    currentContact.contactSelectedForReport = [NSNumber numberWithBool:YES];
                }else{
                    Contacts *currentContact = [allContacts objectAtIndex:indexPath.row];
                    currentContact.contactSelectedForReport = [NSNumber numberWithBool:YES];
                }
                [self.moc save:nil];
                [self.navigationController popToViewController:object animated:YES];
                isVCFound = YES;
            }
        }
        if (isVCFound) {
            
        }else{
            SubmitReportViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"submitVC"];
            vc.moc = self.moc ;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
#pragma mark -
#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
- (void)textFieldValueChanged:(NSNotification*)notification
{
    UITextField  *txtField = notification.object;
    if (txtField == self.txtSearchView && txtField.text.length>1) {
        
        [self contactsValueChanged];
        
    }if(txtField.text.length==0){
        isUserSearch = NO;
        allContacts = [NSMutableArray arrayWithArray:[Contacts getAllContacts:self.moc]];
        [self.contactTableView reloadData];
        
    }
}
-(void)contactsValueChanged{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Contacts" inManagedObjectContext:self.moc];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contactName CONTAINS[cd] %@", self.txtSearchView.text];
    [fetchRequest setPredicate:predicate];
    NSArray *copyArray = [NSArray arrayWithArray:allContacts];
    NSArray *filterArray = [[NSArray alloc]init];
    if ([app.languageISO isEqualToString:@"en"]) {
        filterArray = [copyArray filteredArrayUsingPredicate:predicate];
    }else{
        
        filterArray = [allContactsTranslations filteredArrayUsingPredicate:predicate];
    }
    
    
    allContacts = [NSMutableArray arrayWithArray:filterArray];
    if ([allContacts count]>0) {
        [allContacts removeAllObjects];
        isUserSearch = YES;
        allContacts = [NSMutableArray arrayWithArray:filterArray];
        [self.contactTableView reloadData];
        
    }else{
        allContacts = [NSMutableArray arrayWithArray:[Contacts getAllContacts:self.moc]];
    }
}

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([self.searchView isHidden]) {
        
        if ([touch.view isDescendantOfView:self.contactTableView]) {
            
            // Don't let selections of auto-complete entries fire the
            // gesture recognizer
            return NO;
        }
    }
    
    return YES;
}

@end
