//
//  ServiceHelper.m
//  WildScan
//
//  Created by Shabir Jan on 14/03/2016.
//  Copyright © 2016 Shabir Jan. All rights reserved.
//

#import "ServiceHelper.h"
#import "AFHTTPRequestOperationManager.h"

static NSString * const serviceURLString = @"https://wildscan.org/laos/api/api.php";
@implementation ServiceHelper

+(ServiceHelper*)sharedServiceHelperClient{
    static ServiceHelper *_serviceHelper = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _serviceHelper = [[self alloc]initWithBaseURL:[NSURL URLWithString:serviceURLString]];
    });
    return _serviceHelper;
}

-(instancetype)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return  self;
}
-(void)fetchAllRegions{
    NSString *url=[NSString stringWithFormat:@"https://wildscan.org/laos/api/api.php?r=get-regions&t=OXUTzKm/rp5qCfotOhWj9Y600G/OIBNNNMNwGf7ZWNqXzF3N"];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(serviceHelper:didFetchRegion:)]) {
            [self.delegate serviceHelper:self didFetchRegion:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(serviceHelper:didFetchRegionFailed:)]) {
            [self.delegate serviceHelper:self didFetchRegionFailed:error];
        }
    }];
}
-(void)fetchAllRegionStats{
    NSString *url=[NSString stringWithFormat:@"https://wildscan.org/laos/api/api.php?r=get-regions-stats&t=OXUTzKm/rp5qCfotOhWj9Y600G/OIBNNNMNwGf7ZWNqXzF3N"];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(serviceHelper:didFetchRegionStats:)]) {
            [self.delegate serviceHelper:self didFetchRegionStats:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(serviceHelper:didFetchRegionFailed:)]) {
            [self.delegate serviceHelper:self didFetchRegionStatsFailed:error];
        }
    }];
}
-(void)submitReport:(NSDictionary *)dic{
    NSMutableArray *allReport = [[NSMutableArray alloc]initWithObjects:dic, nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:allReport options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSDictionary *mainDic = [[NSDictionary alloc]initWithObjectsAndKeys:jsonString,@"json", nil];
    NSString *url = [NSString stringWithFormat:@"https://wildscan.org/laos/api/submit-report-json.php"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:mainDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([self.delegate respondsToSelector:@selector(serviceHelper:didReportSubmitSucess:)]) {
            [self.delegate serviceHelper:self didReportSubmitSucess:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *myString = [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding];
        NSLog(@"Error: %@", myString);
        if ([self.delegate respondsToSelector:@selector(serviceHelper:didReportSubmitFailed:)]) {
            [self.delegate serviceHelper:self didReportSubmitFailed:error];
        }
    }];
}
-(void)fetchAllEvents{
    NSString *url=[NSString stringWithFormat:@"https://wildscan.org/laos/api/api.php?r=get-submit-reports&t=OXUTzKm/rp5qCfotOhWj9Y600G/OIBNNNMNwGf7ZWNqXzF3N&later_than=%@",[[NSUserDefaults standardUserDefaults]valueForKey:LASTSYNC]];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(serviceHelper:didFetchEvents:)]) {
            [self.delegate serviceHelper:self didFetchEvents:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(serviceHelper:didFetchEventsFailed:)]) {
            [self.delegate serviceHelper:self didFetchEventsFailed:error];
        }
    }];
}
-(void)fetchAllContent{
    NSString *url=[NSString stringWithFormat:@"https://wildscan.org/laos/api/api.php?r=get-static-contents&t=OXUTzKm/rp5qCfotOhWj9Y600G/OIBNNNMNwGf7ZWNqXzF3N"];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(serviceHelper:didFetchContent:)]) {
            [self.delegate serviceHelper:self didFetchContent:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(serviceHelper:didFetchContentFailed:)]) {
            [self.delegate serviceHelper:self didFetchContentFailed:error];
        }
    }];
}
-(void)fetchAllContacts{
    NSString *url=[NSString stringWithFormat:@"https://wildscan.org/laos/api/api.php?r=get-contacts&t=OXUTzKm/rp5qCfotOhWj9Y600G/OIBNNNMNwGf7ZWNqXzF3N&region=%@&later_than=%@",[[NSUserDefaults standardUserDefaults]valueForKey:SELECTEDREGIONS],[[NSUserDefaults standardUserDefaults]valueForKey:LASTSYNC]];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(serviceHelper:didFetchContacts:)]) {
            [self.delegate serviceHelper:self didFetchContacts:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(serviceHelper:didFetchContactsFailed:)]) {
            [self.delegate serviceHelper:self didFetchContactsFailed:error];
        }
    }];
}
-(void)fetchAllContactsTranslation{
    NSString *url=[NSString stringWithFormat:@"https://wildscan.org/laos/api/api.php?r=get-contacts-translations&t=OXUTzKm/rp5qCfotOhWj9Y600G/OIBNNNMNwGf7ZWNqXzF3N&region=%@&later_than=%@",[[NSUserDefaults standardUserDefaults]valueForKey:SELECTEDREGIONS],[[NSUserDefaults standardUserDefaults]valueForKey:LASTSYNC]];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(serviceHelper:didFetchContactsTranslation:)]) {
            [self.delegate serviceHelper:self didFetchContactsTranslation:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(serviceHelper:didFetchContactsFailedTranlsation:)]) {
            [self.delegate serviceHelper:self didFetchContactsFailedTranlsation:error];
        }
    }];
}
-(BOOL)IsMainThread {
    return dispatch_get_main_queue() == dispatch_get_current_queue();
}
-(void)fetchAllSpecies{
    if ([self IsMainThread]) {
        NSLog(@"main thread");
    }else{
        NSLog(@"issue hy bhai");
    }

    NSString *url=[NSString stringWithFormat:@"https://wildscan.org/laos/api/api.php?r=get-species&t=OXUTzKm/rp5qCfotOhWj9Y600G/OIBNNNMNwGf7ZWNqXzF3N&region=%@&later_than=%@",[[NSUserDefaults standardUserDefaults]valueForKey:SELECTEDREGIONS],[[NSUserDefaults standardUserDefaults]valueForKey:LASTSYNC]];
    url  =[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(serviceHelper:didFetchSpecies:)]) {
            [self.delegate serviceHelper:self didFetchSpecies:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(serviceHelper:didSpeciesFetchFailed:)]) {
            [self.delegate serviceHelper:self didSpeciesFetchFailed:error];
        }
    }];
}
-(void)fetallAllSpeciesTranslation{
	
	NSString *lastSynced = [[NSUserDefaults standardUserDefaults]valueForKey:LASTSYNC];
	if ([lastSynced isEqualToString:@""] || lastSynced == nil){
		lastSynced = @"2016-7-20 19:00:00";
	}
    NSString *url=[NSString stringWithFormat:@"https://wildscan.org/laos/api/api.php?r=get-species-translations&t=OXUTzKm/rp5qCfotOhWj9Y600G/OIBNNNMNwGf7ZWNqXzF3N&region=%@&later_than=%@",[[NSUserDefaults standardUserDefaults]valueForKey:SELECTEDREGIONS],lastSynced];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(serviceHelper:didFetchSpeciesTranslation:)]) {
            [self.delegate serviceHelper:self didFetchSpeciesTranslation:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(serviceHelper:didSpeciesImagePathFetchFailed:)]) {
            [self.delegate serviceHelper:self didSpeciesImagePathFetchFailed:error];
        }
    }];
}
-(void)fetchAllSpecieImagePaths{
    NSString *url=[NSString stringWithFormat:@"https://wildscan.org/laos/api/api.php?r=get-species-images&t=OXUTzKm/rp5qCfotOhWj9Y600G/OIBNNNMNwGf7ZWNqXzF3N&region=%@&later_than=%@",[[NSUserDefaults standardUserDefaults]valueForKey:SELECTEDREGIONS],[[NSUserDefaults standardUserDefaults]valueForKey:LASTSYNC]];
    [self GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(serviceHelper:didFetchSpeciesImagePath:)]) {
            [self.delegate serviceHelper:self didFetchSpeciesImagePath:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(serviceHelper:didSpeciesImagePathFetchFailed:)]) {
            [self.delegate serviceHelper:self didSpeciesImagePathFetchFailed:error];
        }
    }];
}
@end
