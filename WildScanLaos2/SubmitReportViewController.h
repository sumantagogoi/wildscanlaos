//
//  SubmitReportViewController.h
//  WildScan
//
//  Created by Shabir Jan on 03/05/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import <MessageUI/MessageUI.h>
@interface SubmitReportViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ServiceHelperDelegate,MFMailComposeViewControllerDelegate>
- (IBAction)btnReportPrivatePressed:(id)sender;
- (IBAction)btnReportEmail:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
- (IBAction)btnAddContactPressed:(id)sender;
@property (nonatomic,strong)NSManagedObjectContext *moc;
- (IBAction)btnBackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnReportPrivate;
@property (nonatomic,strong)NSMutableArray *contactsArray;
@property (weak, nonatomic) IBOutlet UIButton *btnImage1;
@property (weak, nonatomic) IBOutlet UIButton *btnImage2;
@property (weak, nonatomic) IBOutlet UIButton *btnImage3;
@property (weak, nonatomic) IBOutlet UIButton *btnRemoveImage1;
@property (weak, nonatomic) IBOutlet UIButton *btnRemoveImage2;
@property (weak, nonatomic) IBOutlet UIButton *btnRemoveImage3;
- (IBAction)btnRemoveImage1Pressed:(id)sender;
- (IBAction)btnRemoveImage2Pressed:(id)sender;
- (IBAction)btnRemoveImage3Pressed:(id)sender;
- (IBAction)btnImage1Pressed:(id)sender;
- (IBAction)btnImage2Pressed:(id)sender;
- (IBAction)btnImage3Pressed:(id)sender;
- (IBAction)btnTakeCamera:(id)sender;
- (IBAction)btnTakeExisting:(id)sender;
- (IBAction)btnCancelPressed:(id)sender;
- (IBAction)btnSubmitPressed:(id)sender;

@end
