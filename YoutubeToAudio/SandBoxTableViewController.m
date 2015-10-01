//
//  SandBoxTableViewController.m
//  YoutubeToAudio
//
//  Created by ranjith on 18/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//


// Refer File formats supports in Apple

//https://developer.apple.com/library/ios/documentation/Miscellaneous/Conceptual/iPhoneOSTechOverview/MediaLayer/MediaLayer.html


#import "SandBoxTableViewController.h"
#import "AudioTableViewCell.h"
#import "SandBoxMediaModel.h"

@interface SandBoxTableViewController ()

@property (nonatomic) NSArray *dataSource;

@property (nonatomic)SandBoxMediaModel *tappedMediaModel;

@end

@implementation SandBoxTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib* cellNib = [UINib nibWithNibName:@"AudioTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"AudioTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self findFiles:@"m4a"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AudioTableViewCell *audioTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"AudioTableViewCell" forIndexPath:indexPath];
    SandBoxMediaModel *mediaModel = [self.dataSource objectAtIndex:indexPath.row];
    
    [audioTableViewCell feedCellWithObject:mediaModel];

    self.tappedMediaModel = mediaModel;

    return audioTableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tappedMediaModel = [self.dataSource objectAtIndex:indexPath.row];
}




-(void)findFiles:(NSString *)extension{
    
    NSMutableArray *matches = [[NSMutableArray alloc]init];
    NSFileManager *fManager = [NSFileManager defaultManager];
    NSString *item;
    NSArray *contents = [fManager contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] error:nil];
    
    for (item in contents){
        if ([[item pathExtension] isEqualToString:extension]) {
            SandBoxMediaModel *media  = [SandBoxMediaModel new];
            [media setName:item];
            [media setUrl:[NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],item]];
            [matches addObject:media];
        }
    }
    self.dataSource = [NSArray arrayWithArray:matches];
    [self.tableView reloadData];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSMutableArray *dummyArray = [self.dataSource mutableCopy];
        [dummyArray removeObject:[self.dataSource objectAtIndex:indexPath.row]];
        self.dataSource  = dummyArray;
        
        // Delete the row from the data source
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        NSFileManager *fManager = [NSFileManager defaultManager];
        SandBoxMediaModel *mediaModel = [self.dataSource objectAtIndex:indexPath.row];
        
        NSError *error = nil;

        [fManager removeItemAtPath:mediaModel.url error:&error];
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
