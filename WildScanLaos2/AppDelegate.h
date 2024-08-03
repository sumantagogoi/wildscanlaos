//
//  AppDelegate.h
//  WildScan
//
//  Created by Shabir Jan on 11/03/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#define SAVEREPORT @"saveReport"
#define SHOWREPORTWARNING   @"reportWarning"
#define SHOWLIST  @"showList"
#define SHOWGALLERY   @"showGallery"
#define SHOWASILEFT       @"asILeft"
#define PRICE      @"price"
#define NAME       @"name"
#define ADDRESS1   @"address1"
#define ADDRESS2   @"address2"
#define CITY       @"city"
#define COUNTRYID  @"countryid"
#define STATEID    @"stateid"
#define ZIP        @"zip"
#define PHONE      @"phone"
#define EMAIL      @"email"
#define SHAREIMAGE @"shareImage"
#define IMAGERESIZERID @"resizeImageID"
#define REPORTINGREGION @"reportingRegion"
#define SELECTEDREGIONS @"userSelectedRegions"
#define LASTSYNC @"lastSyncTime"
#define UTCFORMAT @"yyyy-MM-dd'T'HH:mm:ss'Z'"
#define ISBACGROUNDKSYNC @"isBackgroundSync"
#define CURRENTLANGUAGE @"deviceCurrentLanguage"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,strong)NSString *languageISO;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@property (nonatomic,strong)NSMutableArray *submitReportData;
@property (nonatomic,strong)NSMutableArray *contactsSelected;
@end

