//
//  MainViewController.h
//  DevTool
//
//  Created by Stereo on 15/11/20.
//  Copyright © 2015年 epoluodi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"


typedef enum TCP_ENUM:int{
    TCP_SERVER,TCP_CLINET,UDP
} TCPENUM;

@interface MainViewController : NSViewController<NSTextFieldDelegate,GCDAsyncSocketDelegate,GCDAsyncUdpSocketDelegate,NSComboBoxDelegate>
{
    GCDAsyncSocket *tcpserver;
    GCDAsyncSocket *tcpclinet;
    GCDAsyncSocket *newsocketed;
    GCDAsyncUdpSocket *udp;
    TCPENUM tcpenum;
    NSTimer *timerloop;
    BOOL isloop;
    ULONG  r_count,s_count;
    BOOL ISOpen;
}


@property (weak) IBOutlet NSComboBox *cmbtype;
@property (weak) IBOutlet NSTextField *txtIPaddr;
@property (weak) IBOutlet NSTextField *txtport;
@property (weak) IBOutlet NSButton *btnconnect;


@property (weak) IBOutlet NSButton *chkR16hex;
@property (weak) IBOutlet NSButton *chkRautoclear;
@property (weak) IBOutlet NSButton *btnRclear;


@property (weak) IBOutlet NSButton *chkS16hex;
@property (weak) IBOutlet NSButton *chkSautoclear;
@property (weak) IBOutlet NSButton *chkSwhilesend;
@property (weak) IBOutlet NSButton *chkSudpBordcast;

@property (weak) IBOutlet NSButton *btnSclear;
@property (unsafe_unretained) IBOutlet NSTextView *txtR;
@property (unsafe_unretained) IBOutlet NSTextView *txtS;


@property (weak) IBOutlet NSTextField *txtSinfo;
@property (weak) IBOutlet NSTextField *txtRinfo;
@property (weak) IBOutlet NSTextField *txttime;
@property (weak) IBOutlet NSButton *btnsend;



- (IBAction)clicksend:(id)sender;
- (IBAction)clickclearS:(id)sender;
- (IBAction)clickclearR:(id)sender;
- (IBAction)clickconnect:(id)sender;










@end
