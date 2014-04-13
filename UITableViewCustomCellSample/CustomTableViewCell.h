//
//  CustomTableViewCell.h
//  UITableViewCustomCellSample
//
//  Created by yasuhisa.arakawa on 2014/04/14.
//  Copyright (c) 2014年 Yasuhisa Arakawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageThumb;
@property (weak, nonatomic) IBOutlet UILabel *labelDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *labelCellNumber;

+ (CGFloat)rowHeight;

@end
