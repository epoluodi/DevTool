//
//  MainWindowController.m
//  DevTool
//
//  Created by Stereo on 15/11/19.
//  Copyright © 2015年 epoluodi. All rights reserved.
//

#import "MainWindowController.h"

@interface MainWindowController ()

@end

@implementation MainWindowController
@synthesize toolbar;
@synthesize  colorbar;
@synthesize httpbar;
@synthesize netbar;
- (void)windowDidLoad {
    [super windowDidLoad];
    
    mainview = (MainViewController *)self.contentViewController;
    netbar.target=self;
    netbar.action = @selector(clicknetview);
    httpbar.target = self;
    httpbar.action=@selector(clickhttpview);
    
    
     NSStoryboard  *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    httpview = (HttpViewController*)[storyboard instantiateControllerWithIdentifier:@"httpview"];
    netview = (NetViewController *)[storyboard instantiateControllerWithIdentifier:@"netview"];
    self.window.delegate=self;
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
-(void)windowWillClose:(NSNotification *)notification
{
    NSApplication *nsapp = [NSApplication sharedApplication];
    [nsapp terminate:nil];
    NSLog(@"close");
}
-(BOOL)windowShouldClose:(id)sender
{
    return YES;
}
-(void)clicknetview
{

//    [self setContentViewController:netview];
  
}
-(void)clickhttpview
{
//    [self setContentViewController:httpview];
}



@end
