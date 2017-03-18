//
//  ContentView.h
//  ChatTextView
//
//  Created by Prateek Grover on 06/08/15.
//  Copyright (c) 2015 Prateek Grover. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContentView;
@protocol ContentViewDelegate <NSObject>

-(void)hideTextViewPlaceHolder:(BOOL)hide;

@end

@interface ContentView : UIView

@property (nonatomic, strong) UITextView *chatTextView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, strong) id <ContentViewDelegate> delegate;

-(id)initWithTextView:(UITextView *)textView ChatTextViewHeightConstraint:(NSLayoutConstraint *)heightConstraint contentView:(UIView *)contentView ContentViewHeightConstraint:(NSLayoutConstraint *)contentViewHeightConstraint andContentViewBottomConstraint:(NSLayoutConstraint *)contentViewBottomConstraint;

- (void)updateMinimumNumberOfLines:(NSInteger)minimumNumberOfLines
            andMaximumNumberOfLine:(NSInteger)maximumNumberOfLines;

- (void)resizeTextViewWithAnimation:(BOOL)animated;
-(void)textViewDidChange:(UITextView *)textView;
@end
