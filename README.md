# QRDecode
A complete Mac App: drag an image file to the top section and the bottom section will show you the text of any QRCodes in the image.

## QRDecode is
 
A complete Mac App: drag an image file to the top section and the bottom section will show you the text of any QRCodes in the image.

You can also drop files on the app icon, in the file system or in the dock.

You can use the app's open dialog box.

You can specify complete file paths on the command line, except it doesn't work because the sandboxing doesn't let you arbitrary points in the file system.

## Theory of operation:

* TopView handles the layout, laying out an imageView above a scrollable textView.
* ImageView is a subclass of NSImageView - it responds to dropping an image file onto it. When you assign an NSImage to it, it tries to find and delegates to QRCodeDecoder to decode any QRCodes in the image as well as all the normal NSImageView stuff. If it finds any it calls its delegate method with the payload string.
* QRDecoder decodes an image, calling its QRDelegate delegate with the decoded result.
* TextViewDelegatablePaste is a subclass of NSTextView - if the pasteboard has an image, it calls paste on its PateDelegate delegate rather than passing it on to NSTextView.
* QRViewController holds and organizes all of the above.



## Lessons learned:

* Opening files from the dock icon: 
	* I couldn't connect the viewController to the appDelegate in interface builder, but following the ownership chain seems to work at run time.
	* To open from the doc icon, I had to set up my Info.plist correctly - I used the reference doc to figure it out UTIs there
* Opening files the open dialog: I had to figure out UTIs again.
* Opening files the drop destination:  I had to figure out UTIs yet again.
* Open Recent works by registering it with the correct NSDocumentController api.
* I couldn't get layout constraints to work properly (window filled screen on drop. (TextView wouldn't let me type) so I just got rid of them and did the layout in TopView.
* drop destination handling was not obvious.
* Actual QRCode scanning was not obvious: I needed to create a handler, that references the image, and hand it a request.
* Xcode injects additional arguments into the command line like  $ myProgram -NSDocumentRevisionsDebugMode YES
* Opening files from the command-line doesn't work because of sandboxing. It would work if it were turned off.
* NSTextView, as firstResponder, disallows pasting images so QEViewController never gets a chance to see the paste. I kluged a subclass of NSTextView to handle pasting images into the viewController.

## License

Apache 2 - Open Source
