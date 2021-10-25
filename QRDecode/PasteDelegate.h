//  PasteDelegate.h
//  QRDecode
//
//  Created by david on 10/22/21.
//

#import <Cocoa/Cocoa.h>


// for TextViewDelegatablePaste : if the conforming object wants the paste, then TextViewDelegatablePaste
// will call the conforming objects paste: method.
@protocol PasteDelegate <NSObject>

- (BOOL)wantsPaste;

- (IBAction)paste:(id)sender;

@end


