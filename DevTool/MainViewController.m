//
//  MainViewController.m
//  DevTool
//
//  Created by Stereo on 15/11/20.
//  Copyright © 2015年 epoluodi. All rights reserved.
//

#import "MainViewController.h"
#import <ifaddrs.h>
#import <arpa/inet.h>


@interface MainViewController ()

@end

@implementation MainViewController
@synthesize cmbtype,txtIPaddr,txtport,btnconnect;
@synthesize chkR16hex,btnRclear,chkRautoclear;
@synthesize chkS16hex,chkSautoclear,chkSwhilesend,btnSclear,chkSudpBordcast;
@synthesize txtR,txtS,txtRinfo,txtSinfo,txttime,btnsend;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [cmbtype selectItemAtIndex:1];
    tcpenum = TCP_CLINET;
    chkSudpBordcast.enabled=NO;
    
    cmbtype.delegate = self;
    txtIPaddr.stringValue =[self getIPAddress];
    txtIPaddr.delegate = self;
    ISOpen = NO;
    isloop =NO;
    btnsend.enabled=ISOpen;
    r_count=0;
    s_count=0;
  
    txtSinfo.stringValue = [NSString stringWithFormat:@"发送字节: %d",s_count];
    txtRinfo.stringValue =[NSString stringWithFormat:@"接收字节: %d",r_count];
    
    [chkSwhilesend setTarget:self];
    [chkSwhilesend setAction:@selector(clickloop)];
    txttime.stringValue=@"1";
    txttime.enabled=chkSwhilesend.state;
}

-(void)clickloop
{
   txttime.enabled =chkSwhilesend.state;
 
    
}

-(void)txt

{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"测试富文本显示"] ;
    //为所有文本设置字体
    [attributedString addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:24] range:NSMakeRange(0, [attributedString length])];
    //将“测试”两字字体颜色设置为蓝色
    [attributedString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:NSMakeRange(0, 2)];
    //将“富文本”三个字字体颜色设置为红色
    [attributedString addAttribute:NSForegroundColorAttributeName value:[NSColor redColor] range:NSMakeRange(2, 3)];
    
//    //在“测”和“试”两字之间插入一张图片
//    NSString *imageName = @"taobao.png";
//    NSFileWrapper *imageFileWrapper = [[[NSFileWrapper alloc] initRegularFileWithContents:[[NSImage imageNamed:imageName] TIFFRepresentation]] autorelease];
//    imageFileWrapper.filename = imageName;
//    imageFileWrapper.preferredFilename = imageName;
//    
//    NSTextAttachment *imageAttachment = [[[NSTextAttachment alloc] initWithFileWrapper:imageFileWrapper] autorelease];
//    NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
//    [attributedString insertAttributedString:imageAttributedString atIndex:1];
    
    /*
     其实插入图片附件之后 attributedString的长度增加了1 变成了8，所以可以预见其实图片附件属性对应的内容应该是一个长度的字符
     Printing description of attributedString:
     测{
     NSColor = "NSCalibratedRGBColorSpace 0 0 1 1";
     NSFont = "\"LucidaGrande 24.00 pt. P [] (0x10051bfd0) fobj=0x101e687f0, spc=7.59\"";
     }￼{
     NSAttachment = "<NSTextAttachment: 0x101e0c9c0> \"taobao.png\"";
     }试{
     NSColor = "NSCalibratedRGBColorSpace 0 0 1 1";
     NSFont = "\"LucidaGrande 24.00 pt. P [] (0x10051bfd0) fobj=0x101e687f0, spc=7.59\"";
     }富文本{
     NSColor = "NSCalibratedRGBColorSpace 1 0 0 1";
     NSFont = "\"LucidaGrande 24.00 pt. P [] (0x10051bfd0) fobj=0x101e687f0, spc=7.59\"";
     }显示{
     NSFont = "\"LucidaGrande 24.00 pt. P [] (0x10051bfd0) fobj=0x101e687f0, spc=7.59\"";
     }
     */
    
    
    [txtR insertText:attributedString];
}
-(BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector
{
    NSLog(@"commandSelector:%@",NSStringFromSelector(commandSelector));
    return false;
}

// ip txt改变事件
-(void)controlTextDidChange:(NSNotification *)obj
{
    NSString *searchText = txtIPaddr.stringValue;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])$" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    if (!result) {
        NSLog(@"%@\n", [searchText substringWithRange:result.range]);
        txtIPaddr.textColor= [NSColor redColor];
        btnconnect.enabled=NO;
    }
    else{
        txtIPaddr.textColor= [NSColor blackColor];
        btnconnect.enabled=YES;
    }
}

//combox 改变
-(void)comboBoxSelectionDidChange:(NSNotification *)notification
{
    tcpenum = (TCPENUM)cmbtype.indexOfSelectedItem;
    if (tcpenum == UDP){
        chkSudpBordcast.enabled=YES;
        [chkSudpBordcast setTarget:self];
        [chkSudpBordcast setAction:@selector(clickchkboardcast)];
    }
    else{
        chkSudpBordcast.enabled=NO;
        [chkSudpBordcast setTarget:nil];
        [chkSudpBordcast setAction:nil];
    }
    btnconnect.image = [NSImage imageNamed:@"disconnect"];
    [self closesocket];
}


//广播
-(void)clickchkboardcast
{
    [self closesocket];
    if (chkSudpBordcast.state == YES)
    {
      
        txtIPaddr.stringValue=@"255.255.255.255";
        btnconnect.enabled=NO;
        btnsend.enabled=YES;
    }
    else
    {
        btnsend.enabled=NO;
        btnconnect.enabled=YES;
    }
}
//关闭所有连接
-(void)closesocket
{
    if (newsocketed)
    {
        newsocketed.delegate=nil;
        [newsocketed disconnect];
        newsocketed =nil;
    }
    if (tcpserver){
        tcpserver.delegate=nil;
        [tcpserver disconnect];
        tcpserver =nil;
    }
    if (tcpclinet)
    {
        tcpclinet.delegate=nil;
        [tcpclinet disconnect];
        tcpclinet=nil;
    }
    if (udp)
    {
        udp.delegate=nil;
        [udp close];
        udp=nil;
    }
    btnsend.enabled=NO;
    r_count=0;
    s_count=0;
    
    txtSinfo.stringValue = [NSString stringWithFormat:@"发送字节: %d",s_count];
    txtRinfo.stringValue =[NSString stringWithFormat:@"接收字节: %d",r_count];
}

//获取本机IP
- (NSString *)getIPAddress {
    NSString *address = @"";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET ||
               temp_addr->ifa_addr->sa_family == AF_DECnet) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]
                   ||
                   [[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en1"]
                   ) {
                    
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    break;
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}


-(void)ConnectSocket
{
    uint16_t RECIVE_PORT;
    NSString *host;
    host = txtIPaddr.stringValue;
    RECIVE_PORT = [txtport.stringValue intValue];
    switch (tcpenum) {
        case TCP_SERVER:
            
            
            tcpserver = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
            if (![tcpserver acceptOnPort:RECIVE_PORT error:nil])
            {
                tcpserver.delegate=nil;
                [tcpserver disconnect ];
                tcpclinet=nil;
                NSAlert *alert= [NSAlert alertWithMessageText:@"提示" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"监听端口失败"];
                alert.alertStyle=NSWarningAlertStyle;
                [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
                
                return;
            }
            btnconnect.image = [NSImage imageNamed:@"connect"];
            btnconnect.title = @"断开";
            ISOpen=YES;
            
            break;
        case TCP_CLINET:
 
            tcpclinet = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
            if (![tcpclinet connectToHost:host onPort:RECIVE_PORT withTimeout:5 error:nil])
            {
                tcpclinet.delegate=nil;
                [tcpclinet disconnect];
                tcpclinet=nil;
                NSAlert *alert= [NSAlert alertWithMessageText:@"提示" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"连接失败"];
                alert.alertStyle=NSWarningAlertStyle;
                [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
                
                return;
            }
            
            break;
        case UDP:
       
            udp = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
            
            
            
            if (![udp bindToPort:RECIVE_PORT error:nil])
                        {
                            udp.delegate=nil;
                            [udp close];
                            udp=nil;
                            NSAlert *alert= [NSAlert alertWithMessageText:@"提示" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"端口打开失败"];
                            alert.alertStyle=NSWarningAlertStyle;
                            [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
                        }
            
      
            if (![udp connectToHost:host onPort:RECIVE_PORT error:nil])
            {
                [udp close];
                udp=nil;
                NSAlert *alert= [NSAlert alertWithMessageText:@"提示" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"端口打开失败"];
                alert.alertStyle=NSWarningAlertStyle;
                [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
            }
            
       
            break;
            
    }
}

- (NSString *)hexStringFromData:(NSData *)data{
    
    Byte *bytes = (Byte *)[data bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    NSMutableString *mstr = [[NSMutableString alloc] init];
    for(int i=0;i<[data length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
        
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"0%@",[newHexStr uppercaseString] ];
        else
            hexStr = [newHexStr uppercaseString];
        [mstr appendFormat:@"%@ ",hexStr];
    }
    NSLog(@"%@",mstr);
    
    return mstr;
}


-(NSData *)dataFromHexString:(NSString *)hexstr
{
    NSArray * arr= [hexstr componentsSeparatedByString:@" "];
    NSMutableData *hexData = [[NSMutableData alloc] init];
    for (NSString *str in arr) {
        unsigned long hex = strtoul([str UTF8String],0,16);
        
        [hexData appendBytes:&hex length:1];
      
    }
    return hexData;
    
}


#pragma mark tcp


-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    newsocketed = newSocket;
    newsocketed.delegate=self;
    btnsend.enabled=YES;
    [newsocketed readDataWithTimeout:1 tag:1];
}

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    
    NSLog(@"连接成功 %@ %d",host,port);
    btnconnect.image = [NSImage imageNamed:@"connect"];
    btnconnect.title = @"断开";
    ISOpen = YES;
    btnsend.enabled=ISOpen;
    [sock readDataWithTimeout:1 tag:1];
 
    
}

-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"发送完毕");
    [sock readDataWithTimeout:1 tag:1];
    
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *host = nil;
    uint16_t port = 0;

    
    [GCDAsyncSocket getHost:&host port:&port fromAddress:sock.connectedAddress];
    
    
    NSString *strdata ;
    
    NSMutableAttributedString *richtxt;
    NSString *info  = [NSString stringWithFormat:@"【来自连接地址：%@ : %d】\n",host,port];
    richtxt = [[NSMutableAttributedString alloc] initWithString:info];
    [richtxt addAttribute:NSForegroundColorAttributeName value:[[NSColor grayColor ] colorWithAlphaComponent:0.8] range:NSMakeRange(0, info.length)];
    NSMutableAttributedString *richtxt1;
    
    if (chkR16hex.state==YES)
        strdata = [self hexStringFromData:data];
    else
        strdata = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    r_count +=strdata.length;
    txtRinfo.stringValue =[NSString stringWithFormat:@"接收字节: %d",r_count];
    richtxt1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"> %@\n\n",strdata]];
    [richtxt1 addAttribute:NSForegroundColorAttributeName value:[NSColor blackColor ] range:NSMakeRange(2, strdata.length)];
    if (chkR16hex.state==YES)
        [richtxt1 addAttribute:NSBackgroundColorAttributeName value:[[NSColor grayColor ] colorWithAlphaComponent:0.3] range:NSMakeRange(2, strdata.length)];
    [richtxt appendAttributedString:richtxt1];
    
    if (chkRautoclear.state==NO)
    {
        
        [txtR insertText:richtxt];
    }
    else{
        
        [txtR insertText:richtxt replacementRange:NSMakeRange(0, txtR.string.length)];
    }

    
    
    [sock readDataWithTimeout:1 tag:1];
    
}
-(NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length
{
    [sock readDataWithTimeout:1 tag:1];
   
    return 10;
}
-(NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length
{
    [tcpclinet disconnect];
    tcpclinet = nil;
    
    btnconnect.image = [NSImage imageNamed:@"disconnect"];
    btnconnect.title = @"连接";
    ISOpen = NO;
    btnsend.enabled=ISOpen;
    
    return 0;
}
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (newsocketed)
    {
        if (newsocketed.isDisconnected)
        {
            btnsend.enabled=NO;
            return;
        }
    }
    [self closesocket];
    btnconnect.image = [NSImage imageNamed:@"disconnect"];
    btnconnect.title = @"连接";
    ISOpen = NO;
    btnsend.enabled=ISOpen;

    NSLog(@"连接关闭");
}



#pragma mark -

#pragma mark udp 委托
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address
{
    if (chkSudpBordcast.state == YES)
        return;
    [udp beginReceiving:nil];
    btnconnect.image = [NSImage imageNamed:@"connect"];
    btnconnect.title = @"断开";
    ISOpen = YES;
    btnsend.enabled=ISOpen;
}

-(void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    [udp close];
    udp = nil;
    if (chkSudpBordcast.state == YES)
        return;
    
    btnconnect.image = [NSImage imageNamed:@"disconnect"];
    btnconnect.title = @"连接";
    ISOpen = NO;
    btnsend.enabled=ISOpen;
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSString *host = nil;
    uint16_t port = 0;
    


    
    [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
    
    if (chkSudpBordcast.state ==YES)
    {
   
        if ([[host substringToIndex:7] isEqualToString:@"::ffff:"] ||
            [host isEqualToString:[self getIPAddress]])
        {
            return;
        }
    }
    NSLog(@"来自连接地址--%@",host);
    NSString *strdata ;
    
    NSMutableAttributedString *richtxt;
    NSString *info  = [NSString stringWithFormat:@"【来自连接地址：%@ : %d】\n",host,port];
    richtxt = [[NSMutableAttributedString alloc] initWithString:info];
    [richtxt addAttribute:NSForegroundColorAttributeName value:[[NSColor grayColor ] colorWithAlphaComponent:0.8] range:NSMakeRange(0, info.length)];
    NSMutableAttributedString *richtxt1;
    
    if (chkR16hex.state==YES)
        strdata = [self hexStringFromData:data];
    else
        strdata = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    r_count +=strdata.length;
    txtRinfo.stringValue =[NSString stringWithFormat:@"接收字节: %d",r_count];
    richtxt1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"> %@\n\n",strdata]];
    [richtxt1 addAttribute:NSForegroundColorAttributeName value:[NSColor blackColor ] range:NSMakeRange(2, strdata.length)];
    if (chkR16hex.state==YES)
        [richtxt1 addAttribute:NSBackgroundColorAttributeName value:[[NSColor grayColor ] colorWithAlphaComponent:0.3] range:NSMakeRange(2, strdata.length)];
    [richtxt appendAttributedString:richtxt1];
    
    if (chkRautoclear.state==NO)
    {
        
        [txtR insertText:richtxt];
    }
    else{
       
        [txtR insertText:richtxt replacementRange:NSMakeRange(0, txtR.string.length)];
    }
    if (chkSudpBordcast.state == YES)
        [sock close];

}

#pragma mark -

-(void)send
{
    uint16_t RECIVE_PORT;
    NSString *host;
    NSData *data;
    NSData *senddata;
    switch (tcpenum) {
        case TCP_SERVER:
            
            if ([txtS.string isEqualToString:@""])
            {
                NSAlert *alert= [NSAlert alertWithMessageText:@"提示" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"输入发送的类容"];
                alert.alertStyle=NSWarningAlertStyle;
                [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
                return;
                
            }
            
            if (chkS16hex.state ==YES)
                data= [self dataFromHexString:txtS.string];
            else
                data = [txtS.string dataUsingEncoding:NSUTF8StringEncoding];
            s_count +=data.length;
            txtSinfo.stringValue = [NSString stringWithFormat:@"发送字节: %d",s_count];
            [newsocketed writeData:data withTimeout:4 tag:1];
            
            if (chkSautoclear.state == YES)
                txtS.string=@"";
            
            break;
        case TCP_CLINET:
            if ([txtS.string isEqualToString:@""])
            {
                NSAlert *alert= [NSAlert alertWithMessageText:@"提示" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"输入发送的类容"];
                alert.alertStyle=NSWarningAlertStyle;
                [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
                return;
                
            }
            
            if (chkS16hex.state ==YES)
                data= [self dataFromHexString:txtS.string];
            else
                data = [txtS.string dataUsingEncoding:NSUTF8StringEncoding];
            s_count +=data.length;
            txtSinfo.stringValue = [NSString stringWithFormat:@"发送字节: %d",s_count];
            [tcpclinet writeData:data withTimeout:4 tag:1];
            
            if (chkSautoclear.state == YES)
                txtS.string=@"";
            break;
            
            
        case UDP:
            
            if (chkSudpBordcast.state ==YES)
            {
                
                [udp close];
                udp=nil;
                RECIVE_PORT = [txtport.stringValue intValue];
                udp = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
                
                
                
                if (![udp bindToPort:RECIVE_PORT error:nil])
                {
                    [udp close];
                    udp=nil;
                    NSAlert *alert= [NSAlert alertWithMessageText:@"提示" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"端口打开失败"];
                    alert.alertStyle=NSWarningAlertStyle;
                    [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
                }
                
                host = txtIPaddr.stringValue;
                [udp beginReceiving:nil];
                
                if (chkS16hex.state ==YES)
                    senddata= [self dataFromHexString:txtS.string];
                else
                    senddata =[txtS.string dataUsingEncoding:NSUTF8StringEncoding];
                s_count +=senddata.length;
                txtSinfo.stringValue = [NSString stringWithFormat:@"发送字节: %d",s_count];
                [udp enableBroadcast:YES error:nil];
                [udp sendData:senddata toHost:host port:RECIVE_PORT withTimeout:5 tag:0];
                
                return;
            }
            
            
            if ([txtS.string isEqualToString:@""])
            {
                NSAlert *alert= [NSAlert alertWithMessageText:@"提示" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"输入发送的类容"];
                alert.alertStyle=NSWarningAlertStyle;
                [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
                return;
                
            }
            
            if (chkS16hex.state ==YES)
                data= [self dataFromHexString:txtS.string];
            else
                data = [txtS.string dataUsingEncoding:NSUTF8StringEncoding];
            [udp sendData:data withTimeout:10 tag:0];
            if (chkSautoclear.state == YES)
                txtS.string=@"";
            break;
    }

}

#pragma mark 按钮事件
- (IBAction)clicksend:(id)sender {
    if (chkSwhilesend.state==YES)
    {
        
        if (isloop)
        {
            isloop=NO;
            [timerloop invalidate];
            timerloop = nil;
            btnsend.title=@"发送";
            return;
        }
        
        [txttime validateEditing];
        if ([txttime.stringValue isEqualToString:@""])
        {
            NSAlert *alert= [NSAlert alertWithMessageText:@"提示" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"输入秒数!!"];
            alert.alertStyle=NSWarningAlertStyle;
            [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
            return;
        }

        
        
        timerloop = [NSTimer scheduledTimerWithTimeInterval:[txttime.stringValue integerValue] target:self selector:@selector(send) userInfo:nil repeats:YES];
        [timerloop fire];
        btnsend.title=@"停止发送";
        isloop=YES;
    }
    else
        [self send];
}

- (IBAction)clickclearS:(id)sender {
    txtS.string = @"";
    s_count=0;
    txtSinfo.stringValue = [NSString stringWithFormat:@"发送字节: %d",s_count];
    
}

- (IBAction)clickclearR:(id)sender {
    txtR.string=@"";
    r_count=0;
    txtRinfo.stringValue =[NSString stringWithFormat:@"接收字节: %d",r_count];
}

- (IBAction)clickconnect:(id)sender {
    
    if (ISOpen)
    {
        [self closesocket];
        ISOpen=NO;
        btnconnect.image= [NSImage imageNamed:@"disconnect"];
        btnconnect.title=@"连接";
        return;
    }
    [txtport validateEditing];
    if ([txtport.stringValue isEqualToString:@""] ||
        txtport.stringValue.length>6)
    {
        NSAlert *alert= [NSAlert alertWithMessageText:@"提示" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"端口号不正确"];
        alert.alertStyle=NSWarningAlertStyle;
        [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
        
    }
    
    [self ConnectSocket];
    
}



#pragma mark -
@end
