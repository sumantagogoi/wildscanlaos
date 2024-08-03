//
//  SettingViewController.h
//  WildScan
//
//  Created by Shabir Jan on 10/05/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic,strong)NSManagedObjectContext *moc;
- (IBAction)btnCheckmarkPressed:(id)sender;
- (IBAction)btnBackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *galleryView;
@property (weak, nonatomic) IBOutlet UITableView *galleryTable;
- (IBAction)btnCancelPressed:(id)sender;
- (IBAction)btnRadioPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *backBlurrView;
@property (weak, nonatomic) IBOutlet UIView *contactsView;
- (IBAction)btnCancelContactPressed:(id)sender;
- (IBAction)btnOkPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;
@end
