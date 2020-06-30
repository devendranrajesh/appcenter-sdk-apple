// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

#import "MSErrorLogFormatter.h"

@class PLCrashReportThreadInfo;

@interface MSErrorLogFormatter ()

/**
 * Remove user information from a path when the crash happened in the simulator.
 *
 * @param path The path that needs to be anonymized.
 *
 * @return The anonymized path.
 */
+ (NSString *)anonymizedPathFromPath:(NSString *)path;

/**
 * Determines the MSBinaryImageType.
 *
 * @param imagePath The path to a binary image.
 * @param processPath The process path.
 *
 * @return The type of the binary image.
 */
+ (MSBinaryImageType)imageTypeForImagePath:(NSString *)imagePath processPath:(NSString *)processPath;

/**
 * Create an id for a crash report. Uses the one generated by PLCrashReporter or generates a new UUID.
 *
 * @param report The crash report.
 *
 * @return an error id as a NSString.
 */
+ (NSString *)errorIdForCrashReport:(PLCrashReport *)report;

/**
 * Convenience method to add process information and application path to an error log. For simulator builds, it will anonymize the path and
 * remove user information from it. It was not split into two methods because separating into a method to add the processInfo and one for
 * the applicationPath would mean duplicating logic.
 *
 * @param errorLog The error log object that will be returned.
 * @param crashReport The crash
 *
 * @return The error log with process information and the application path.
 */
+ (MSAppleErrorLog *)addProcessInfoAndApplicationPathTo:(MSAppleErrorLog *)errorLog fromCrashReport:(PLCrashReport *)crashReport;

/**
 * Convenience method to find the crashed thread in a crash report.
 *
 * @param report The crash report.
 *
 * @return The crashed thread info.
 */
+ (PLCrashReportThreadInfo *)findCrashedThreadInReport:(PLCrashReport *)report;

/**
 * Extract binary images from a crash report. This only extracts the binary images that we "care" about, meaning those that are contained
 * in the crash's stack frames.
 *
 * @param report The crash report.
 * @param is64bit A flag that indicates if this is a 64bit architecture.
 *
 * @return An array of binary images.
 */
+ (NSArray<MSBinary *> *)extractBinaryImagesFromReport:(PLCrashReport *)report is64bit:(BOOL)is64bit;

/**
 * Format a memory address into a string. This normalizes arm64 addresses.
 *
 * @param address The address that will be formatted.
 * @param is64bit A flag that indicates if this is a 64bit architecture.
 *
 * @return A formatted memory address as a string.
 */
+ (NSString *)formatAddress:(uint64_t)address is64bit:(BOOL)is64bit;

@end
