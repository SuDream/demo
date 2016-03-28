//
//  left_View.m
//  itemXmppXF
//
//  Created by Moon on 16/3/27.
//  Copyright © 2016年 SuDream. All rights reserved.
//

#import "left_View.h"

@implementation left_View
{
    UITableView *_table;
    NSArray *_data;
}
-(instancetype) initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        self.backgroundColor=[UIColor redColor];
        [self CreateUI];
        
        
    }
    return self;
}

-(void) CreateUI
{
    
    _table=[[UITableView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width*0.7,self.frame.size.height) style:UITableViewStylePlain];
    _table.delegate=self;
    _table.dataSource=self;
    [self addSubview:_table];
    
    _data=@[@"1",@"2"];
    
    
}

#pragma mark tableviewDelegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_data.count) {
        
        return _data.count;
    }
    return 0;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idsu=@"su";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:idsu];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idsu];
        
    }
    if (_data.count>indexPath.row) {
        
        cell.textLabel.text=_data[indexPath.row];
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_data.count>indexPath.row) {
        
        if (self.delegate &&[self.delegate respondsToSelector:@selector(left_ViewWith:)]) {
            
            [self.delegate left_ViewWith:(int)indexPath.row];
            
        }
    }
}



@end
