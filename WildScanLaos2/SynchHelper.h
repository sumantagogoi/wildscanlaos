//
//  SynchHelper.h
//  WildScan
//
//  Created by Shabir Jan on 15/05/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceHelper.h"

@protocol SyncHelperDelegate;
@interface SynchHelper : AFHTTPSessionManager
{
    BOOL isBackSync;
}
@property (nonatomic,weak)id<SyncHelperDelegate>delegate;


@property (nonatomic,strong)NSManagedObjectContext *moc;


-(void)startSync;

@end
@protocol SyncHelperDelegate<NSObject>
@optional
-(void)synchHelper:(SynchHelper *)client didSyncSuccess:(BOOL)success;
-(void)synchHelper:(SynchHelper *)client didSyncFailed:(NSError *)error;

@end