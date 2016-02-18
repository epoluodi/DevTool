//
//  MainWindowController.h
//  DevTool
//
//  Created by Stereo on 15/11/19.
//  Copyright © 2015年 epoluodi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainViewController.h"
#import "HttpViewController.h"
#import "NetViewController.h"

@interface MainWindowController : NSWindowController<NSWindowDelegate>
{
    MainViewController *mainview;
    HttpViewController *httpview;
    NetViewController *netview;
}
@property (weak) IBOutlet NSToolbar *toolbar;

@property (weak) IBOutlet NSToolbarItem *httpbar;
@property (weak) IBOutlet NSToolbarItem *netbar;
@property (weak) IBOutlet NSToolbarItem *colorbar;






@end
