//
//  DataModel.h
//  YoutubeToAudio
//
//  Created by ranjith on 17/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DataModel : NSObject

/*!
 Initializes with Server dictionary
 */
- (id)initWithServerDictionary:(NSDictionary*)dictionary;

/*!
 Returns dictionary that can be safely updated to Server.
 This dictionary contains server keys.
 */
- (NSDictionary*)dictionary;

@property (nonatomic,readwrite) NSString *title;
@property (nonatomic,readonly) NSString *videoId;
@property (nonatomic,readwrite) NSString *thumbnailUrl;
@property (nonatomic,readonly) NSString *videoDescription;

@property (nonatomic,readwrite) NSString *videoDuration;

@property (nonatomic,readonly) NSString *kind;
@property (nonatomic,readonly) NSString *channelTitle;
@property (nonatomic,readonly) NSString *publishedAt;

// This one is optional. Even you can able to fill this one at later.
@property (nonatomic,readwrite) UIImage *videoImage;



/*!
 @note:Refer http://www.raywenderlich.com/19788/how-to-use-nsoperations-and-nsoperationqueues
 */
#pragma mark - Newly added

@property (nonatomic, readonly) BOOL hasImage; // Return YES if image is downloaded.
@property (nonatomic, getter = isFiltered) BOOL filtered; // Return YES if image is sepia-filtered
@property (nonatomic, getter = isFailed) BOOL failed; // Return Yes if image failed to be downloaded




#pragma mark - Reference
//{
//    etag = "\"jOXstHOM20qemPbHbyzf7ztZ7rI/1iFiy7cHI6i4FbSK30x4HKrdhYo\"";
//    items =     (
//                 {
//                     etag = "\"jOXstHOM20qemPbHbyzf7ztZ7rI/140dRgj7XGVcIR4ZQhemUuHm2MQ\"";
//                     id =             {
//                         kind = "youtube#video";
//                         videoId = nHmqYK80hJo;
//                     };
//                     kind = "youtube#searchResult";
//                     snippet =             {
//                         channelId = "UCSGzE-FGYpr2V0VgTKFgjXw";
//                         channelTitle = Marvinmahes66;
//                         description = "Madrasapattinam Arya Amy Jackson.";
//                         liveBroadcastContent = none;
//                         publishedAt = "2010-12-17T10:04:22.000Z";
//                         thumbnails =                 {
//                         default =                     {
//                             url = "https://i.ytimg.com/vi/nHmqYK80hJo/default.jpg";
//                         };
//                             high =                     {
//                                 url = "https://i.ytimg.com/vi/nHmqYK80hJo/hqdefault.jpg";
//                             };
//                             medium =                     {
//                                 url = "https://i.ytimg.com/vi/nHmqYK80hJo/mqdefault.jpg";
//                             };
//                         };
//                         title = "Pookal Pookum Tharunam Aaruyire Partha Thavanam Illaiyei Video Song HD";
//                     };
//                 },
//                 {
//                     etag = "\"jOXstHOM20qemPbHbyzf7ztZ7rI/QPAIQ5C02fKQdUyIGaUWD5aJHVI\"";
//                     id =             {
//                         kind = "youtube#video";
//                         videoId = "W7w_kftqgoI";
//                     };
//                     kind = "youtube#searchResult";
//                     snippet =             {
//                         channelId = UCbtP37x46TOHdrc72FmjCFw;
//                         channelTitle = "";
//                         description = "Madharasapattinam - Pookal Pookum Lyrics.";
//                         liveBroadcastContent = none;
//                         publishedAt = "2013-08-29T19:04:52.000Z";
//                         thumbnails =                 {
//                         default =                     {
//                             url = "https://i.ytimg.com/vi/W7w_kftqgoI/default.jpg";
//                         };
//                             high =                     {
//                                 url = "https://i.ytimg.com/vi/W7w_kftqgoI/hqdefault.jpg";
//                             };
//                             medium =                     {
//                                 url = "https://i.ytimg.com/vi/W7w_kftqgoI/mqdefault.jpg";
//                             };
//                         };
//                         title = "Madharasapattinam - Pookal Pookum Lyrics";
//                     };
//                 },
//                 {
//                     etag = "\"jOXstHOM20qemPbHbyzf7ztZ7rI/hTT6Ev86whbJSqVgW99kR9Jc15A\"";
//                     id =             {
//                         kind = "youtube#video";
//                         videoId = 0x0SWzOfC6A;
//                     };
//                     kind = "youtube#searchResult";
//                     snippet =             {
//                         channelId = "UCMLNLy39AB_jWhZz_O4jd0g";
//                         channelTitle = "";
//                         description = "Jaihind TV Dhwani Song_Pookal Pookum - Madrasapattinam Ralfin Stephen(keyboards & piano), Rajesh N K (flute) , Ebenezer Michel (bass guitar), Rony ...";
//                         liveBroadcastContent = none;
//                         publishedAt = "2014-03-01T08:15:57.000Z";
//                         thumbnails =                 {
//                         default =                     {
//                             url = "https://i.ytimg.com/vi/0x0SWzOfC6A/default.jpg";
//                         };
//                             high =                     {
//                                 url = "https://i.ytimg.com/vi/0x0SWzOfC6A/hqdefault.jpg";
//                             };
//                             medium =                     {
//                                 url = "https://i.ytimg.com/vi/0x0SWzOfC6A/mqdefault.jpg";
//                             };
//                         };
//                         title = "Pookal Pookum ( Madrasapattinam) cover by Amritha & Jyothi Krishna _Dhwani JaihindTV";
//                     };
//                 }
//                 );
//    kind = "youtube#searchListResponse";
//    nextPageToken = CAMQAA;
//    pageInfo =     {
//        resultsPerPage = 3;
//        totalResults = 3980;
//    };
//}

@end
