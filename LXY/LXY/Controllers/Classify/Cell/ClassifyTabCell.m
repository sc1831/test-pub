//
//  ClassifyTabCell.m
//  LXY
//
//  Created by guohui on 16/3/18.
//  Copyright © 2016年 guohui. All rights reserved.
//

#import "ClassifyTabCell.h"
#import "Common.h"

@interface ClassifyTabCell()
@property (weak, nonatomic) IBOutlet UIView *selectFlagView;


@end

@implementation ClassifyTabCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)configWithClassModel:(ClassModel *)model{
    self.titleLabel.text = model.gc_name ;
}
- (void)changeFlageby:(BOOL)flag{
    if (flag) {
        _selectFlagView.backgroundColor = RGBCOLOR(255, 135, 31) ;
        self.titleLabel.textColor = RGBCOLOR(255, 135, 31);
    }else{
        _selectFlagView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = RGBCOLOR(36, 37, 38);
    }
}

@end
