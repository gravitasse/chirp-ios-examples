//
//  ViewController.h
//  chirpTOTP
//
//  Created by Amogh Matt on 08/06/2018.
//  Copyright © 2018 Chirp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate> {
    NSInteger digits;
    NSInteger period;
    NSTimeInterval timestamp;
    NSString * secret;
}

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UITextField *PINLabel;
@property (weak, nonatomic) IBOutlet UITextField *secretTextField;
@property (weak, nonatomic) IBOutlet UITextField *expiryTextField;
@property (weak, nonatomic) IBOutlet UITextField *digitsTextField;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

- (IBAction)sendButtonPressed: (id)sender;

@end

