//
//  DefineUrl.h
//  RelaxTime
//
//  Created by 千锋 on 16/6/28.
//  Copyright © 2016年 abc. All rights reserved.
//

#ifndef DefineUrl_h
#define DefineUrl_h

/***********首页接口 get ***/
//
#define Home_URl   @"http://v3.wufazhuce.com:8000/api/hp/more/0"
//后面拼接 月份日期 2016-06

#define Home_before_URL @"http://v3.wufazhuce.com:8000/api/hp/bymonth/"
/*******************************/

/***********查询接口 get ***/
//后面拼接 以“/”拼接 文字转成UTF8
//参数 hp 插图 reading 阅读 music 音乐 movie 电影 作者 author

//总查询
#define Search_URL  @"http://v3.wufazhuce.com:8000/api/search/";
//插图
#define Search_hp_URL  @"http://v3.wufazhuce.com:8000/api/search/hp/";
//阅读
#define Search_read_URL  @"http://v3.wufazhuce.com:8000/api/search/reading/";
// 音乐
#define Search_Music_URL  @"http://v3.wufazhuce.com:8000/api/search/music/";
//电影
#define Search_Movie_URL  @"http://v3.wufazhuce.com:8000/api/search/movie/";
//作者
#define Search_Author_URL  @"http://v3.wufazhuce.com:8000/api/search/author/";
/*******************************/


/***********阅读的滚动条接口 get ***/
//
#define Read_Scroll_URL   @"http://v3.wufazhuce.com:8000/api/reading/carousel"


//加了文章参数是详情  格式 拼接文章  id  90
#define Read_Scroll_Detail_URL  @"http://v3.wufazhuce.com:8000/api/reading/carousel/"

//点进去返回文章数组 通过type判断是短篇还是什么的  用item_id请求数据 （等号处的url）

/***********阅读的内容接口 get ***/
//返回三个数组（10） 分别是 短篇essay 连载  问答 分别显示在cell上
#define Read_Bottom_URL   @"http://v3.wufazhuce.com:8000/api/reading/index"
/**
 *  点击cell 短篇  连载  问答
 */
//点击cell   加上类型 和 id请求 内容 （模型都不相同）
//====================
// 连载   serialcontent  //(essay? serialcontent? question)/ (各自的id)
  #define Read_detailContent_URL   @"http://v3.wufazhuce.com:8000/api/"

// 请求短篇推荐 （模型都不相同） (essay? serial? question)/(各自的id)
#define Read_detail_relate_URL  @"http://v3.wufazhuce.com:8000/api/related/"
//  评论   加载更多评论  以评论模型的id继续请求 （评论模型都是一样的） (essay? serial? question)/(各自的id)/（0）
#define Read_detail_comment_URL @"http://v3.wufazhuce.com:8000/api/comment/praiseandtime/"
//======================
//http://v3.wufazhuce.com:8000/api/comment/praiseandtime/essay/1446/23264


/***********音乐接口 get ***/
#define Music_first_URL @"http://v3.wufazhuce.com:8000/api/music/idlist/0"
//从上面的请求中取第一个数字继续请求
//内容
#define Music_detail_URL @"http://v3.wufazhuce.com:8000/api/music/detail/"
//推荐
#define Music_Relate_URL @"http://v3.wufazhuce.com:8000/api/related/music/"
//评论
#define Music_comment_URL @"http://v3.wufazhuce.com:8000/api/comment/praiseandtime/music/"


/***********电影 get ***/
//以模型的id进行刷新操作
#define Movie_URL @"http://v3.wufazhuce.com:8000/api/movie/list/0";
//#define Movie_URL @"http://v3.wufazhuce.com:8000/api/movie/list/34";

//详情
#define Movie_detail_URL @"http://v3.wufazhuce.com:8000/api/movie/detail/85"
//评论
#define Movie_comment_URL @" http://v3.wufazhuce.com:8000/api/comment/praiseandtime/movie/85/0"
//电影故事第一次一个
#define Movie_StoryFirst_URL @"http://v3.wufazhuce.com:8000/api/movie/84/story/1/0";

//加载更多  以id加载
#define Movie_StorySecond_URL @"http://v3.wufazhuce.com:8000/api/movie/84/story/0/0";



#endif /* DefineUrl_h */

/*
NSString *urlPath = [url stringByAppendingString:word];

//将链接中的中文转换成%形式
NSString *string_2 = [urlPath stringByAddingPercentEncodingWithAllowedCharacters:
                      [NSCharacterSet characterSetWithCharactersInString:word].invertedSet];
*/