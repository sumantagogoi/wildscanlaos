//
//  ViewController.h
//  WildScan
//
//  Created by Shabir Jan on 11/03/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "UAProgressView.h"

@interface ViewController : UIViewController<ServiceHelperDelegate>
@property (nonatomic,strong)NSManagedObjectContext *moc;
@property (weak, nonatomic) IBOutlet UILabel *lblSyncText;
@property (weak, nonatomic) IBOutlet UAProgressView *loaderView;

@end

