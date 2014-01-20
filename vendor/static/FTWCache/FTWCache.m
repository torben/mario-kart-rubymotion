//
//  FTWCache.m
//  FTW
//
//  Created by Soroush Khanlou on 6/28/12.
//  Copyright (c) 2012 FTW. All rights reserved.
//

#import "FTWCache.h"

static NSTimeInterval cacheTime =  (double)604800;

@implementation FTWCache

+ (void) resetCache {
  [[NSFileManager defaultManager] removeItemAtPath:[FTWCache cacheDirectory] error:nil];
}

+ (NSString*) cacheDirectory {
  NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *cacheDirectory = [paths objectAtIndex:0];
  cacheDirectory = [cacheDirectory stringByAppendingPathComponent:@"FTWCaches"];
  return cacheDirectory;
}

+ (NSData*) objectForKey:(NSString*)key {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:key];
  
  if ([fileManager fileExistsAtPath:filename])
  {
    NSDate *modificationDate = [[fileManager attributesOfItemAtPath:filename error:nil] objectForKey:NSFileModificationDate];
    if ([modificationDate timeIntervalSinceNow] > cacheTime) {
      [fileManager removeItemAtPath:filename error:nil];
    } else {
      NSData *data = [NSData dataWithContentsOfFile:filename];
      return data;
    }
  }
  return nil;
}

+ (void) setObject:(NSData*)data forKey:(NSString*)key {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:key];

  BOOL isDir = YES;
  if (![fileManager fileExistsAtPath:self.cacheDirectory isDirectory:&isDir]) {
    [fileManager createDirectoryAtPath:self.cacheDirectory withIntermediateDirectories:NO attributes:nil error:nil];
  }
  
  NSError *error;
  @try {
    [data writeToFile:filename options:NSDataWritingAtomic error:&error];
  }
  @catch (NSException * e) {
    //TODO: error handling maybe
  }
}

+ (void) flushCache:(bool)complete {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSError *error;
  NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:self.cacheDirectory error:&error];

  for(int i=0,n=[directoryContents count];i<n;i++) {
    NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:directoryContents[i]];
    NSDate *modificationDate = [[fileManager attributesOfItemAtPath:filename error:nil] objectForKey:NSFileModificationDate];
    NSDate *fiveDays = [[NSDate date] dateByAddingTimeInterval:(-5*24*60*60)];

    if ([modificationDate compare:fiveDays] == NSOrderedAscending || complete) {
      [fileManager removeItemAtPath:filename error:nil];
    }
  }
}

@end
