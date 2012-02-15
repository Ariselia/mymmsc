package com.fengxf.feng.activity.ebuy.action;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Type;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EncodingUtils;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


import android.content.Context;

import com.fengxf.feng.activity.base.BaseAction; 
import com.fengxf.feng.activity.ebuy.bean.CommentListBean;
import com.fengxf.feng.activity.ebuy.bean.ExperienceForGoodsListBean;
import com.fengxf.feng.activity.ebuy.bean.ExperienceListBean;
import com.fengxf.feng.activity.ebuy.bean.ExpressNewsInfo;
import com.fengxf.feng.activity.ebuy.bean.ExpressNewsListBean;
import com.fengxf.feng.activity.ebuy.bean.GoodsInfoBean;
import com.fengxf.feng.activity.ebuy.bean.OrderBean;
import com.fengxf.feng.activity.ebuy.bean.OrderListBean;
import com.fengxf.feng.activity.ebuy.bean.PersonListBean;
import com.fengxf.feng.activity.ebuy.bean.Recommend;
import com.fengxf.feng.activity.ebuy.bean.StateBean;
import com.fengxf.feng.activity.ebuy.bean.StationMessageInfoBean;
import com.fengxf.feng.activity.ebuy.bean.StationMessageRecvListBean;
import com.fengxf.feng.activity.ebuy.bean.StationMessageSendListBean;
import com.fengxf.feng.activity.ebuy.bean.TypeBean;
import com.fengxf.feng.activity.util.Globals;
import com.fengxf.feng.activity.util.HttpOperator;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.reflect.TypeToken;

public class EbuyAction extends BaseAction{
	private Context context=null;  
	private String cur_url=null;
	public final static String module="EbuyAction";
	public EbuyAction(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
		this.context=context;
	}
//	public String Encode(String str){
//		String sm="";
//		try{
//			sm=URLEncoder.encode(str,"UTF-8").replace("+", "%20");
//		}catch (Exception e) {
//			// TODO: handle exception
//			e.toString();
//		}
//		return sm;
//	}
//	public String Decode(String str) {
//		String sm="";
//		try {
//			sm= URLDecoder.decode(str,"UTF-8");
//		} catch (UnsupportedEncodingException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//		return sm;
//	}
	/*
	 * 	功能名称：商品搜索接口
	 * */
public List<Recommend>  getSearchList(String name){
		 List <Recommend> rList=new ArrayList<Recommend>(); 
			Type  tp=new TypeToken< LinkedList<Recommend>>() {}.getType();
			rList=(List<Recommend>) get("POST",rList, Globals.EBUY_SEARCH, tp,"name",URLEncoder.encode(name));

		 return rList;
	}
/*
 * 	功能名称：商品推荐接口
 * */
public List<Recommend>  getRecommendList(int page){
	 List <Recommend> rList=new ArrayList<Recommend>(); 
		Type  tp=new TypeToken< LinkedList<Recommend>>() {}.getType();
		rList=(List<Recommend>) get("GET",rList, Globals.EBUY_PUSH, tp,"page",String.valueOf(page));

	 return rList;
}
/*
 * 	功能名称：分类列表接口,
 * 说明：
 * 判断TypeBean中的child，如果为0表示无自分类，则需要调用getGoodList接口，若有，如需子分类，继续调用该接口
 * */
public List<TypeBean>  getTypeList(String typeid,int page){
	 	List <TypeBean> rList=new ArrayList<TypeBean>(); 
		Type  tp=new TypeToken< LinkedList<TypeBean>>() {}.getType();
		rList=(List<TypeBean>) get("GET",rList, Globals.EBUY_TYPE, tp,"page",String.valueOf(page),"typeid",typeid);
	 
	 return rList;
}
/*
 * 	功能名称：商品列表接口
  * */
public List<Recommend>  getGoodList(String typeid,int page){
	 	List <Recommend> rList=new ArrayList<Recommend>(); 
		Type  tp=new TypeToken< LinkedList<Recommend>>() {}.getType();
		rList=(List<Recommend>) get("GET",rList, Globals.EBUY_GOODSLIST, tp,"page",String.valueOf(page),"typeid",typeid);
	 
	 return rList;
}
/*
 * 	功能名称：快报资讯推荐接口
 * */
public  List<ExpressNewsListBean> getExpressNewsList(int page){
	 List <ExpressNewsListBean> rList=new ArrayList<ExpressNewsListBean>();
		Type  tp=new TypeToken< LinkedList<ExpressNewsListBean>>() {}.getType();
		rList=(List<ExpressNewsListBean>) get("GET",rList, Globals.EBUY_NEW, tp,"page",String.valueOf(page));
	 return rList;
}

/*
 * 	功能名称：快报资讯详情接口
 * */
public ExpressNewsInfo getExpressNewsInfo(String id){
	ExpressNewsInfo rList=new ExpressNewsInfo();
	Type  tp=new TypeToken< ExpressNewsInfo>() {}.getType();
	rList=(ExpressNewsInfo) get("GET",rList, Globals.EBUY_MESSAGENEWINFO, tp,"id",id);

	 return rList;
}
/*
 * 	功能名称：站内信列表接口--收件箱
 * */
public List<StationMessageRecvListBean> getStationMessageRecvList(int page,String userid){
	List <StationMessageRecvListBean> rList=new ArrayList<StationMessageRecvListBean>();
	Type  tp=new TypeToken< LinkedList<StationMessageRecvListBean>>() {}.getType();
	rList=(List<StationMessageRecvListBean>) get("GET",rList, Globals.EBUY_MESSAGE_RECV, tp,"page",String.valueOf(page),"id",userid);
	return rList;
}
/*
 * 	功能名称：站内信列表接口--发件箱
 * */
public List<StationMessageSendListBean> getStationMessageSendList(int page,String userid){
	List <StationMessageSendListBean> rList=new ArrayList<StationMessageSendListBean>();
	Type  tp=new TypeToken< LinkedList<StationMessageSendListBean>>() {}.getType();
	rList=(List<StationMessageSendListBean>) get("GET",rList, Globals.EBUY_MESSAGE_SEND, tp,"page",String.valueOf(page),"id",userid);
	return rList;
}
/*
 * 	功能名称：站内信详情
 * 
public StationMessageInfoBean getStationMessageInfo(String id){
	StationMessageInfoBean rList=new StationMessageInfoBean();
	Type  tp=new TypeToken< StationMessageInfoBean>() {}.getType();
	rList=(StationMessageInfoBean) get("POST",rList, Globals.EBUY_MESSAGEINFO, tp,"id",id);
	return rList;
}
*/
/*
 * 	功能名称：站内信回复接口
 * */
public boolean addStationMessage(String id,String content){
	StateBean stateBean=new StateBean();
	Type  tp=new TypeToken< StateBean>() {}.getType();
	stateBean=(StateBean) get("POST",stateBean, Globals.EBUY_ADDMESSAGE, tp,"id",id,"content",content);
 
	 if(stateBean.getStatus().equals("-1")) {
		 return false;
	 }else {
		return true;
	}
}
/*
 * 	功能名称：订单获取接口
 * */
public List<OrderListBean>getOrderList(String id,String type,String page){
	List <OrderListBean> rList=new ArrayList<OrderListBean>();
	Type  tp=new TypeToken< LinkedList<OrderListBean>>() {}.getType();
	rList=(List<OrderListBean>) get("GET",rList, Globals.EBUY_ORDERLIST, tp,"page",page,"id",id,"type",type);

	return rList;

}
/*
 * 	功能名称：我的收藏
 * */
public List<PersonListBean> getPersonList(String id,int page){
	List <PersonListBean> rList=new ArrayList<PersonListBean>();
	Type  tp=new TypeToken< LinkedList<PersonListBean>>() {}.getType();
	rList=(List<PersonListBean>) get("GET",rList, Globals.EBUY_COLLECT, tp,"id",id,"page",String.valueOf(page));

	return rList; 
}
/*
 * 	功能名称：收藏一个商品
 * */
public boolean addPerson(String id,String userid){
	StateBean stateBean=new StateBean();
	Type  tp=new TypeToken< StateBean>() {}.getType();
	stateBean=(StateBean) get("GET",stateBean, Globals.EBUY_ADDCOLLECT, tp,"id",id,"userid",userid);
 
	 if(stateBean.getStatus().equals("-1")) {
		 return false;
	 }else {
		return true;
	}
}
/*
 * 	功能名称：删除一个收藏的商品
 * */
public boolean delPerson(String id,String userid){
	StateBean stateBean=new StateBean();
	Type  tp=new TypeToken< StateBean>() {}.getType();
	stateBean=(StateBean) get("GET",stateBean, Globals.EBUY_DELCOLLECT, tp,"id",id,"userid",userid);
 
	 if(stateBean.getStatus().equals("-1")) {
		 return false;
	 }else {
		return true;
	}
}
/*
 * 	功能名称：我的评价列表
 * */
public List<ExperienceListBean> getExperienceList(int page,String userid){
	List <ExperienceListBean> rList=new ArrayList<ExperienceListBean>();
	Type  tp=new TypeToken< LinkedList<ExperienceListBean>>() {}.getType();
	rList=(List<ExperienceListBean>) get("GET",rList, Globals.EBUY_SDANDCOMMENTLIST, tp,"page",String.valueOf(page),"userid",userid);

	return rList; 
}
/*
 * 	功能名称：发表评论
 * */
public boolean addComment(String id,String content,String grade,String pic){
	String picurl=URLEncoder.encode(uploadPic(pic));
	if(picurl!=null){
			StateBean stateBean=new StateBean();
			Type  tp=new TypeToken< StateBean>() {}.getType();
			stateBean=(StateBean) get("POST",stateBean, Globals.EBUY_ADDCOMMENT, tp,"grade",grade,"id",id,"content",content,"picurl",picurl);
		 
			 if(stateBean.getStatus().equals("-1")) {
				 return false;
			 }else {
				return true;
			}
	}else {
		return false;
	}
}
/*
 * 	功能名称：查看一个自己发表的商品心得详情
 * */
public ExperienceForGoodsListBean getExperienceForGoods(String id,int page,String userid,String orderid){
	ExperienceForGoodsListBean rList=new ExperienceForGoodsListBean();
	Type  tp=new TypeToken< ExperienceForGoodsListBean>() {}.getType();
	rList=(ExperienceForGoodsListBean) get("GET",rList, Globals.EBUY_REALIZE, tp,"id",id,"page",String.valueOf(page),"userid",userid,"orderid",orderid);

	return rList; 
}
/*
 * 	功能名称： 商品详情
 * */
public  GoodsInfoBean getGoodsInfo(String id){
	GoodsInfoBean infoBean=new GoodsInfoBean();
	Type  tp=new TypeToken<GoodsInfoBean>() {}.getType();
	infoBean=(GoodsInfoBean) get("GET",infoBean, Globals.EBUY_GOODINFO, tp,"id",id);

	return infoBean;
}
/*
 * 	功能名称：查看商品评论列表
 * */
public List<CommentListBean> getCommentList(String id,int page){
	List <CommentListBean> rList=new LinkedList<CommentListBean>();
	Type  tp=new TypeToken< LinkedList<CommentListBean>>() {}.getType();
	rList=(List<CommentListBean>) get("GET",rList, Globals.EBUY_GOODCOMMENT, tp,"id",id,"page",String.valueOf(page));
	return rList; 
}


/*
 * 	功能名称：查看订单详情接口
 * */
public OrderBean getExperienceForGoodsInfo(String id){
	OrderBean rList=new OrderBean();
	Type  tp=new TypeToken< OrderBean>() {}.getType();
	rList=(OrderBean) get("GET",rList, Globals.EBUY_ORDER_INFO, tp,"orderid",id); 
	return rList; 
}
/*
 * 	功能名称：订购N个商品
 * */
public boolean addOrderList(OrderBean order){
	JSONObject jm=new JSONObject(); 
	 try {
		
		Gson gson=new Gson(); 
		String rs=gson.toJson(order,OrderBean.class);
		JSONObject json=new JSONObject(rs); 
		jm.accumulate("order", json);
		
		 
		HttpResponse repsone=HttpOperator.doPostBodyJson(Globals.EBUY_ORDER, jm);
		HttpEntity entity = repsone.getEntity();
		if (entity != null) {
			byte[] bytes = EntityUtils.toByteArray(entity);
			//EntityUtils.toString(entity, "UTF-8");
			String arrayMsg= EncodingUtils.getString(bytes, "UTF-8");  
			if(arrayMsg==null || arrayMsg.equals("")) return false;
			JSONObject jsons = new JSONObject(arrayMsg);  
			String msg=jsons.getString("Response");
			if(msg.equals("")){
				return false;
			} 
			GsonBuilder builder = new GsonBuilder();   
			Gson gsons = builder.create();
			StateBean myBean= gsons.fromJson(msg,StateBean.class); 
			if (myBean==null) {
				return false;
			}
			if(!myBean.getStatus().equals("0")){
				return false;
			}
		 }
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		return false;
	}
	 return true;
}
public String uploadPic(String name){
	String picurl=null;
	try {
			HttpResponse repsone=HttpOperator.doPostPic(Globals.EBUY_UPLOAD_PIC,name);
			HttpEntity entity = repsone.getEntity();
			if (entity != null) {
				byte[] bytes = EntityUtils.toByteArray(entity);
				picurl= EncodingUtils.getString(bytes, "UTF-8"); 
			}	
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	return picurl;
}
/**
 * 功能名称：通用数据访问接口，完成普通获取数据
 */
public Object get(String methods, Object myBean,String url,Type tp,Object ... args){
	if(args==null|| methods==null)	return null;
	HttpResponse repsone=null;
	int size=args.length;
	String arrayName=url.substring(url.lastIndexOf("/")+1);
	try{
			if (methods.equalsIgnoreCase("POST")) {
				 JSONObject jb= new JSONObject();
				
				for (int i = 0; i < size; i=i+2) {
					jb.put((String)args[i], args[i+1]);
					 
				}
			JSONObject jbs= new JSONObject();
//				jArray.put(jb);
			jbs.accumulate(arrayName, jb);
				 
				repsone=HttpOperator.doPostBodyJson(url,jbs);
			}else {
				Map<String, String> param=new HashMap<String, String>(); 
				for (int i = 0; i < size; i=i+2) {
					param.put((String)args[i],(String)args[i+1]); 
				}
				repsone=HttpOperator.doGet(url,param);
			}
			
			
			HttpEntity entity = repsone.getEntity();
			if (entity != null) {
				byte[] bytes = EntityUtils.toByteArray(entity);
				//EntityUtils.toString(entity, "UTF-8");
				String arrayMsg= EncodingUtils.getString(bytes, "UTF-8");  
				if(arrayMsg==null || arrayMsg.equals("")) return null;
				JSONObject jsons = new JSONObject(arrayMsg);  
				String msg=jsons.getString(arrayName);
				if(msg.equals("")){
					return null;
				} 
				GsonBuilder builder = new GsonBuilder();   
				Gson gson = builder.create();
 				myBean= gson.fromJson(msg,tp); 
 			 	}
			}catch (Exception e) {
				// TODO: handle exception
				e.toString();
				return null;
			}
		return myBean;
	}
	 
}
