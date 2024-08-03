//
//  ContactsViewController.h
//  WildScan
//
//  Created by Shabir Jan on 14/03/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnFavoriteShow;
- (IBAction)btnFavoriteShowPressed:(id)sender;
- (IBAction)btnCellFavoritePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *contactTableView;
- (IBAction)btnBackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchView;
- (IBAction)btnSearchPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *touchView;
@property (nonatomic,strong)NSManagedObjectContext *moc;
@property (nonatomic)BOOL isContactSelection;
@end
