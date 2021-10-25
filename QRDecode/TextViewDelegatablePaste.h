//  TextViewDelegatablePaste.h
//  QRDecode
//
//  Created by david on 10/22/21.
//

#import <Cocoa/Cocoa.h>
#import "PasteDelegate.h"

// Override NSTextView to let its pasteDelegate have first crack at some pastes,
@interface TextViewDelegatablePaste : NSTextView
@property(weak) IBOutlet id<PasteDelegate> pasteDelegate;
@end


