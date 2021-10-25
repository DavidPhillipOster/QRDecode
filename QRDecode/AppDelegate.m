//  AppDelegate.m
//  QRDecode
//
//  Created by david on 10/22/21.
//

#import "AppDelegate.h"

#import "QRViewController.h"

@implementation AppDelegate

- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
  return YES;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)app {
  return YES;
}

- (void)application:(NSApplication *)application openURLs:(NSArray<NSURL *> *)urls {
  QRViewController *viewController = (QRViewController *) application.windows.firstObject.contentViewController;
  [viewController openURLs:urls];
}

@end
