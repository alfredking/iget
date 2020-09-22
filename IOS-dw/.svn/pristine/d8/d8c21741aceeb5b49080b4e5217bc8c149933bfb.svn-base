//
//  IDMPValidateCodeView.m
//  IDMPCMCC
//
//  Created by wj on 2017/7/23.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "IDMPValidateCodeView.h"
#import "UIColor+Hex.h"
#import "IDMPScreen.h"

@interface IDMPValidateCodeView()

@property (nonatomic, strong) NSMutableArray <UILabel *>*pincodeArrayTF;
@property (nonatomic, strong) UITextField *pincodeTF;

@end

@implementation IDMPValidateCodeView

- (instancetype)init {
    if (self = [super init]) {
        
        self.pincodeTF = [UITextField new];
        self.pincodeTF.delegate = self;
        self.pincodeTF.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:self.pincodeTF];
        [self.pincodeTF becomeFirstResponder];
        
        self.pincodeArrayTF = [[NSMutableArray alloc]initWithCapacity:0];
        for (int i=0; i<4; i++) {
            UILabel *lbl = [UILabel new];
            lbl.textColor = [UIColor idmp_colorWithHex:0x1979bc];
            lbl.layer.borderWidth = 0.5;
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.layer.borderColor = i==0 ? [[UIColor idmp_colorWithHex:0x1979bc] CGColor] : [[UIColor idmp_colorWithHex:0xa6a6a6] CGColor];
            lbl.layer.masksToBounds = YES;
            lbl.layer.cornerRadius = 4;
            [self addSubview:lbl];
            [lbl setTranslatesAutoresizingMaskIntoConstraints:NO];
            NSLayoutConstraint *lblTop = [NSLayoutConstraint constraintWithItem:lbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
            NSLayoutConstraint *lblCenterX = [NSLayoutConstraint constraintWithItem:lbl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:(-99 + i * 66)*IDMPWidthScale];
            NSLayoutConstraint *lblWidth = [NSLayoutConstraint constraintWithItem:lbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:46*IDMPWidthScale];
            NSLayoutConstraint *lblHeight = [NSLayoutConstraint constraintWithItem:lbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:46*IDMPWidthScale];
            [lbl addConstraints:@[lblWidth,lblHeight]];
            [self addConstraints:@[lblTop,lblCenterX]];
            
            [self.pincodeArrayTF addObject:lbl];
        }
    }
    return self;
}

- (void)clearText {
    self.pincodeTF.text = nil;
    for (int i=0; i<self.pincodeArrayTF.count; i++) {
        self.pincodeArrayTF[i].text = nil;
        if (i != 0) {
            self.pincodeArrayTF[i].layer.borderColor = [[UIColor idmp_colorWithHex:0xa6a6a6] CGColor];
        }
    }
}

#pragma mark - textField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *pincode = [NSString stringWithFormat:@"%@%@",textField.text,string];
    NSUInteger count = pincode.length;
    
    if (count <= self.pincodeArrayTF.count) {
        self.pincodeArrayTF[count - 1].text = [string isEqualToString:@""] ? string : @"*";
        self.pincodeArrayTF[count - 1].layer.borderColor = [string isEqualToString:@""] ? [[UIColor idmp_colorWithHex:0xa6a6a6] CGColor] : [[UIColor idmp_colorWithHex:0x1979bc] CGColor];
        if (textField.text.length >= 4) {
            return YES;
        }
        if (pincode.length == 4) {
            self.endEditBlcok(pincode);
        }
    }
    return textField.text.length + (string.length - range.length) <= 4;
}



@end
