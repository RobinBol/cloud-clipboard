//
//  AppDelegate.h
//  cloud-clipboard
//
//  Created by Robin Bolscher on 27-03-14.
//  Copyright (c) 2014 GreenCoding. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GCDAsyncSocket.h"
#import "SocketExtend.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusHighLightImage;
    NSInteger lastChangeCount;
    NSArray *types;
    NSArray *currentPasteboardData;
}

@property (weak) IBOutlet NSMenuItem *Menu1;

@property (strong) SocketExtend *gcdSocket;

-(IBAction)getPasteItem:(id)sender;

@property (assign) IBOutlet NSWindow *window;

@property(readwrite, retain) NSPasteboard *whichPboard;

@end
