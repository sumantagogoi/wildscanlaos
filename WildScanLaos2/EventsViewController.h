//
//  EventsViewController.h
//  WildScan
//
//  Created by Shabir Jan on 10/04/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)btnBackPressed:(id)sender;
@property (nonatomic,strong)NSManagedObjectContext *moc;
- (IBAction)btnMapPressed:(id)sender;
@end
