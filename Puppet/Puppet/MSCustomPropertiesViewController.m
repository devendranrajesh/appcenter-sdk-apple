/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 */

#import "AppCenter.h"
#import "MSAppCenterPrivate.h"
#import "MSCustomPropertiesViewController.h"
#import "MSCustomPropertyTableViewCell.h"

@interface MSCustomPropertiesViewController ()

@property (nonatomic) NSInteger propertiesCount;

@end

@implementation MSCustomPropertiesViewController

#pragma mark - view controller

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.tableView setEditing:YES animated:NO];
}

- (IBAction)send {
  MSCustomProperties *customProperties = [MSCustomProperties new];
  for (int i = 0; i < self.propertiesCount; i++) {
    MSCustomPropertyTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    [cell setPropertyTo:customProperties];
  }
  [MSAppCenter setCustomProperties:customProperties];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self isInsertRowAtIndexPath:indexPath]) {
    return UITableViewCellEditingStyleInsert;
  } else {
    return UITableViewCellEditingStyleDelete;
  }
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    self.propertiesCount--;
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    self.propertiesCount++;
    [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  }
}

- (NSString *)cellIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellIdentifier = nil;
  if (![self isPropertiesRowSection:indexPath.section]) {
    cellIdentifier = @"send";
  } else if ([self isInsertRowAtIndexPath:indexPath]) {
    cellIdentifier = @"insert";
  } else {
    cellIdentifier = @"customProperty";
  }
  return cellIdentifier;
}

- (BOOL)isInsertRowAtIndexPath:(NSIndexPath *)indexPath {
  return indexPath.section == 0 &&
         indexPath.row == [self tableView:self.tableView numberOfRowsInSection:indexPath.section] - 1;
}

- (BOOL)isPropertiesRowSection:(NSInteger)section {
  return section == 0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if ([self isInsertRowAtIndexPath:indexPath]) {
     [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:indexPath];
  }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if ([self isPropertiesRowSection:section]) {
    return self.propertiesCount + 1;
  } else {
    return 1;
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if ([self isPropertiesRowSection:section]) {
    return @"Properties";
  }
  return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self isPropertiesRowSection:indexPath.section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellIdentifier = [self cellIdentifierForRowAtIndexPath:indexPath];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
  }
  return cell;
}

@end
