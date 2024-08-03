//
//  ServiceHelper.h
//  WildScan
//
//  Created by Shabir Jan on 14/03/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "AFHTTPSessionManager.h"

#import "AFHTTPSessionManager.h"

@protocol ServiceHelperDelegate;

@interface ServiceHelper : AFHTTPSessionManager
@property (nonatomic, weak) id<ServiceHelperDelegate>delegate;

+ (ServiceHelper *)sharedServiceHelperClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)fetchAllContacts;
- (void)fetchAllContactsTranslation;

- (void)fetchAllSpecies;
- (void)fetallAllSpeciesTranslation;
- (void)fetchAllSpecieImagePaths;

- (void)fetchAllContent;
- (void)fetchAllEvents;
- (void)fetchAllRegions;
-(void)fetchAllRegionStats;
- (void)submitReport:(NSDictionary*)dic;
@end

@protocol ServiceHelperDelegate <NSObject>
@optional
-(void)serviceHelper:(ServiceHelper *)client didFetchContent:(id)content;
-(void)serviceHelper:(ServiceHelper *)client didFetchContentFailed:(NSError *)error;

-(void)serviceHelper:(ServiceHelper *)client didFetchEvents:(id)events;
-(void)serviceHelper:(ServiceHelper *)client didFetchEventsFailed:(NSError *)error;


-(void)serviceHelper:(ServiceHelper *)client didFetchRegion:(id)region;
-(void)serviceHelper:(ServiceHelper *)client didFetchRegionFailed:(NSError *)error;


-(void)serviceHelper:(ServiceHelper *)client didFetchRegionStats:(id)regionStat;
-(void)serviceHelper:(ServiceHelper *)client didFetchRegionStatsFailed:(NSError *)error;


-(void)serviceHelper:(ServiceHelper *)client didReportSubmitSucess:(id)message;
-(void)serviceHelper:(ServiceHelper *)client didReportSubmitFailed:(NSError *)error;

-(void)serviceHelper:(ServiceHelper *)client didFetchSpecies:(id)species;
-(void)serviceHelper:(ServiceHelper *)client didSpeciesFetchFailed:(NSError *)error;

-(void)serviceHelper:(ServiceHelper *)client didFetchSpeciesTranslation:(id)speciesTranslation;
-(void)serviceHelper:(ServiceHelper *)client didSpeciesTranslationFetchFailed:(NSError *)error;

-(void)serviceHelper:(ServiceHelper *)client didFetchSpeciesImagePath:(id)speciesTranslation;
-(void)serviceHelper:(ServiceHelper *)client didSpeciesImagePathFetchFailed:(NSError *)error;

-(void)serviceHelper:(ServiceHelper *)client didFetchContacts:(id)contacts;
-(void)serviceHelper:(ServiceHelper *)client didFetchContactsFailed:(NSError *)error;

-(void)serviceHelper:(ServiceHelper *)client didFetchContactsTranslation:(id)contactsTranlsation;
-(void)serviceHelper:(ServiceHelper *)client didFetchContactsFailedTranlsation:(NSError *)error;


@end