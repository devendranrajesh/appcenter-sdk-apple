/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 */

#import "SNMCrashesHelper.h"

static NSString *const kSNMCrashesDirectory = @"com.microsoft.sonoma/crashes";

@interface SNMCrashesHelper ()

BOOL snm_isDebuggerAttached(void);
BOOL snm_isRunningInAppExtension(void);
NSString *snm_crashesDir(void);

@end

@implementation SNMCrashesHelper

#pragma mark - Public

+ (NSString *)crashesDir {
  static NSString *crashesDir = nil;
  static dispatch_once_t predSettingsDir;

  dispatch_once(&predSettingsDir, ^{
    NSFileManager *fileManager = [[NSFileManager alloc] init];

    // temporary directory for crashes grabbed from PLCrashReporter
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    crashesDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:kSNMCrashesDirectory];

    if (![fileManager fileExistsAtPath:crashesDir]) {
      NSDictionary *attributes =
          [NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedLong:0755] forKey:NSFilePosixPermissions];
      NSError *theError = NULL;

      [fileManager createDirectoryAtPath:crashesDir
             withIntermediateDirectories:YES
                              attributes:attributes
                                   error:&theError];
    }
  });

  return crashesDir;
}

+ (BOOL)isAppExtension {
  static BOOL isRunningInAppExtension = NO;
  static dispatch_once_t checkAppExtension;

  dispatch_once(&checkAppExtension, ^{
    isRunningInAppExtension =
        ([[[NSBundle mainBundle] executablePath] rangeOfString:@".appex/"].location != NSNotFound);
  });

  return isRunningInAppExtension;
}

@end
