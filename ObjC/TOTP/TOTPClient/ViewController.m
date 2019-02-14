//
//  ViewController.m
//  chirpTOTP
//
//  Created by Amogh Matt on 08/06/2018.
//  Copyright © 2018 Chirp. All rights reserved.
//

#import "ViewController.h"
#import <ChirpConnect/ChirpConnect.h>
#import "Classes/TOTPGenerator.h"
#import "Classes/MF_Base32Additions.h"
#import "Credentials.h"

@interface ViewController ()
@property (nonatomic, strong) ChirpConnect *connect;
@end

@implementation ViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view, typically from a nib.
    
    [super viewDidLoad];
    
    self.secretTextField.delegate = self;
    self.expiryTextField.delegate = self;
    self.digitsTextField.delegate = self;
    
    self.secretTextField.text = APP_KEY;
    self.expiryTextField.text = @"30";
    self.digitsTextField.text = @"6";
    
    [self updateUI];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
    
    self.connect = [[ChirpConnect alloc] initWithAppKey:APP_KEY andSecret:APP_SECRET];
    [self.connect setConfig:APP_CONFIG];
    [self.connect start];
}

- (IBAction)sendButtonPressed:(id)sender
{
    NSString *chirpPIN = self.PINLabel.text;
    NSData *data = [self encodeMessage:chirpPIN];
    
    [self.connect send:data];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:timeZone];
    NSString *dateString = [dateFormatter stringFromDate:now];
    
    long timestamp = (long)[now timeIntervalSince1970];
    if(timestamp % [self.expiryTextField.text integerValue] != 0){
        timestamp -= timestamp % [self.expiryTextField.text integerValue];
    }
    
    self.dateLabel.text = dateString;
    self.timestampLabel.text = [NSString stringWithFormat:@"%ld",timestamp];
    
    [self generatePIN];
}

-(void)generatePIN
{
    NSString *secret = self.secretTextField.text;
    NSData *secretData =  [NSData dataWithBase32String:[secret base32String]];
    
    NSInteger digits = [self.digitsTextField.text integerValue];
    NSInteger period = [self.expiryTextField.text integerValue];
    NSTimeInterval timestamp = [self.timestampLabel.text integerValue];
    
    TOTPGenerator *generator = [[TOTPGenerator alloc] initWithSecret:secretData algorithm:kOTPGeneratorSHA1Algorithm digits:digits period:period];
    
    NSString *pin = [generator generateOTPForDate:[NSDate dateWithTimeIntervalSince1970:timestamp]];
    
    self.PINLabel.text = pin;
}

-(NSData *) encodeMessage:(NSString *)message
{
    NSString *string = [NSString stringWithUTF8String:message.UTF8String];
    if ([string lengthOfBytesUsingEncoding:NSUTF8StringEncoding] >
        [self.connect maxPayloadLength]) {
        return nil;
    }
    
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self.connect isValidPayload:stringData] ? stringData : nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

@end
