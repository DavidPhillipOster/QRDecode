//  TextViewDelegatablePaste.m
//  QRDecode
//
//  Created by david on 10/22/21.
//

#import "TextViewDelegatablePaste.h"

@implementation TextViewDelegatablePaste

- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem {
  if ([anItem action] == @selector(paste:) && [self.pasteDelegate wantsPaste]) {
    return YES;
  }
  return [super validateUserInterfaceItem:anItem];
}

- (IBAction)paste:(id)sender {
  if ([self.pasteDelegate wantsPaste]) {
    [self.pasteDelegate paste:sender];
  } else {
    [super paste:sender];
  }
}

@end
