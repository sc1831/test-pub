//
//  GHAPI.h
//  LXY
//
//  Created by guohui on 16/3/8.
//  Copyright © 2016年 guohui. All rights reserved.
//

#ifndef GHAPI_h
#define GHAPI_h
//#define HTTPSERVICE @"http://192.168.1.146/index.php"
#define HTTPSERVICE @"http://www.lexianyu.com/index.php"
//注册发送短信
#define REGISTRE_SEND_SMS @"app/Register/send_sms"
//注册验证验证码
#define REGISTRE_SEND_AUTH_CODE @"app/Register/check_sms"
//注册店铺
#define REGISTRE_STOR_NAME @"app/register/register"
//获取省市县
#define GET_CITY_ADDRESS @"app/Address/get_region"
//忘记密码
#define BACK_PASSWORD @"app/Register/back_password"

//购物车
#define SHOP_GOODS @"app/cart/index"
#define SHOP_GOODS_TWO @"app/cart/cart_list"
//添加购物车
#define ADD_SHOP_GOODS @"app/cart/add"
//删除购物车商品
#define DELLECT_SHOP_GOODS @"app/cart/del"
//添加购物数量
#define ADD_SHOP_GOODS_NUM @"app/cart/edit_cart_num"


//登录
#define LOGIN @"app/Register/login"
#define EDIT_USER_TOKEN @"app/User/edit_user_token"
//退出登录
#define LOGIN_OUT @"app/user/logout"

//-------------------------------------------个人中心页面

//个人信息
#define MY_USER_ACCOUNT @"app/user/my_account"
//我的收藏
#define MY_COLLECT @"app/User/my_ollection"
//删除我的收藏
#define MY_DELLECT_COLLECT @"app/User/del_ollection"
//我的足迹
#define MY_FOOTER @"app/User/my_footprint"
//删除我的足迹
#define MY_DELLECT_FOOTER @"app/User/del_footprint"
//我的订单
#define MY_REGISTER @"app/User/my_order"
//取消订单
#define MY_CANCEL_REGISTER @"app/User/cancel_order"
#define MY_GOODS_CONFIRM @"app/goods/confirm"
//修改密码
#define MY_EDIT_PWD @"app/User/edit_pwd"
//意见反馈类型
#define MY_FEEDBACK_TYPE @"app/Feedback/get_opiniontype"
//提交意见反馈信息
#define MY_FEEDBACK_INFORMATION @"app/User/add_feedback"
//修改绑定手机号
#define MY_EDIT_BING_PHONE @"app/User/edit_bind_phone"
//图片上传
#define UPLOAD_AVATAR @"app/image/upload_avatar"
//-------------------------------------------首页
#define HOME_INDEX @"app/index/index"
//可能感兴趣的商品
#define RECOMMEND_GOODS @"app/index/recommend_goods"
#endif /* GHAPI_h */

//------------------------------------------分类
#define G_CLASS @"app/goods/g_class" //分类
#define SECOND_CLASS @"app/goods/second_class" //二级分类
#define COMPOSITE @"app/goods/more" //商品列表

//-------------------------------------------商品详情
#define DETAIL_URL @"app/goods/detail_url" //商品详情

