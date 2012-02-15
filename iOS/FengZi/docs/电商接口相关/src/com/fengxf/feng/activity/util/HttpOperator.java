package com.fengxf.feng.activity.util;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.Proxy;
import java.net.URL;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentProducer;
import org.apache.http.entity.EntityTemplate;
import org.apache.http.entity.FileEntity;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.CoreConnectionPNames;
import org.apache.http.protocol.HTTP;
import org.apache.http.util.EntityUtils;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import com.fengxf.feng.json.JSONException;
import com.fengxf.feng.json.JSONObject;

public class HttpOperator {

	private static  HttpClient httpclient = null;
	private static HttpPost httppost = null;
     private static final String MODULE = "HttpOperator";
     
     /**
 	* 从服务器取图�?
 	*http://bbs.3gstdy.com
 	* @param url
 	* @return
 	*/
 	public static Bitmap getHttpBitmap(String url) {
 	     URL myFileUrl = null;
 	     Bitmap bitmap = null;
 	     try { 
 	          myFileUrl = new URL(url);
 	     } catch (MalformedURLException e) {
 	          e.printStackTrace();
 	     }
 	     try {
 	    	 Proxy proxy =null;
 	    	 HttpURLConnection conn =null;
// 	    	 if(Globals.CUR_NETWORK.equals(Globals.CUR_NETWORK_3G)){
// 	    		 	proxy=new Proxy(Proxy.Type.HTTP, new InetSocketAddress(Globals.MobileProxyHost, Globals.MobileProxyPort));
// 	    		 	conn = (HttpURLConnection) myFileUrl.openConnection(proxy);
// 	    		 	 System.out.println("使用代理获取图片..............................");
// 	    	  }
// 	    	 else {
// 	    		 	conn = (HttpURLConnection) myFileUrl.openConnection();
// 			  }
 	          conn.setConnectTimeout(10000); 
 	          conn.setDoInput(true);
 	          conn.connect();
 	       
 	          InputStream is = conn.getInputStream();
 	          bitmap = BitmapFactory.decodeStream(is);
 	          is.close();
 	     } catch (IOException e) {
 	          e.printStackTrace(); 
 	     }
 	     return bitmap;
 	}
 	public static HttpResponse doPostPic(String url, JSONObject jsonParams,String action,String pic){
 		HttpResponse response=null;
 		FileOutputStream out=null;
 		try{
 			httpclient = new DefaultHttpClient();
		    httppost = new HttpPost(url);
	 		JSONObject jsonReq = new JSONObject();
			jsonReq.put("action", action);
			jsonReq.put("params", jsonParams); 
			httppost.setHeader("JSONParams", jsonReq.toString());
			String tmp_path=pic.substring(0,pic.lastIndexOf("/"));
			String tmp_filename=pic.substring(pic.lastIndexOf("/")+1);
			tmp_filename="up_"+tmp_filename;
			File imgfile = new File(tmp_path+"/"+tmp_filename);  
			if (!imgfile.exists()) {
				imgfile.createNewFile();
			}
			Bitmap bm=ImageHandle.imageDo(pic,0);
			out=new FileOutputStream(imgfile); 
			if(bm.compress(Bitmap.CompressFormat.PNG, 100, out)){ 
				out.flush(); 
				out.close(); 
			}  
			
			FileEntity fileEntity = new FileEntity(imgfile, "binary/octet-stream"); 
			 
			long lens=fileEntity.getContentLength();
			fileEntity.setContentType("binary/octet-stream"); 
			httppost.setEntity(fileEntity);
			
			response = httpclient.execute(httppost);
 		}catch (Exception e) {
			// TODO: handle exception
 			try {
 				if (out!=null) { 
 					out.close(); 
				} 
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			} 
			
		}
 		return response;
 	}
 	 public static HttpResponse doPostForJsonBody(String url, JSONObject jsonParams,String action,String content) {
      	HttpResponse response=null;
      	try{
      			httpclient = new DefaultHttpClient();
  		    	httppost = new HttpPost(url);
   		    	JSONObject jsonReq = new JSONObject();
  				jsonReq.put("action", action);
  				jsonReq.put("params", jsonParams); 
  				httppost.setHeader("JSONParams", jsonReq.toString());  
  				StringEntity reqEntity = new StringEntity(content, "UTF-8");   
  			    
  			    reqEntity.setContentType("text/plain");   
  			    reqEntity.setContentEncoding("UTF-8"); 
  			    
  				httppost.setEntity(reqEntity);
  				response = httpclient.execute(httppost);
  				
      	}catch (Exception e) {
  				// TODO: handle exception
  		}
      	return response;
      }
     public static HttpResponse doPostForJsonHearder(String url, JSONObject jsonParams,String action) {
     	HttpResponse response=null;
     	try{
//     			String aaa = "http://192.168.1.60:8080/uc/m_register.action?username=15901559579&password=111&checkcode=3466&nicname=howard";
     			httpclient = new DefaultHttpClient();
 		    	httppost = new HttpPost(url);
//  		    JSONObject jsonReq = new JSONObject();
// 				jsonReq.put("action", action);
// 				jsonReq.put("params", jsonParams); 
 				httppost.setHeader("JSONParams", jsonParams.toString());  
 				response = httpclient.execute(httppost);
 				
     	}catch (Exception e) {
 				// TODO: handle exception
 		}
     	return response;
     }
    public static HttpResponse doPostForJson(String url, JSONObject jsonParams,String action) {
    	HttpResponse response=null;
    	try{
    			httpclient = new DefaultHttpClient();
//    			String url1 = "http://192.168.1.60:8080/uc/m_login.action?username=15901559579&password=111&checkcode=3466";
		    	httppost = new HttpPost(url);
// 		    	JSONObject jsonReq = new JSONObject();
//				jsonReq.put("action", action);
//				jsonReq.put("params", jsonParams); 
				StringEntity reqEntity = new StringEntity(jsonParams.toString());  
			    reqEntity.setContentType("text/plain");   
				httppost.setEntity(reqEntity); 
				response = httpclient.execute(httppost);
				
    	}catch (Exception e) {
				// TODO: handle exception
		}
    	return response;
    }
    public static HttpResponse doPost(String url, List<NameValuePair> params) {
        HttpPost request = new HttpPost(url);
        try {
            request.setEntity(new UrlEncodedFormEntity(params, HTTP.UTF_8));
            request.setHeader("Content-Type", "application/json");  
            JSONObject jsonReq = new JSONObject();
			try {
				jsonReq.put("name", "商品名称");
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} 
			request.setEntity(new StringEntity(jsonReq.toString()));
            HttpClient httpclient = new DefaultHttpClient();
            return httpclient.execute(request);
        } catch (IOException e) {
        	e.toString();
        }
        return null;
    }
    public static HttpResponse doPostBodyJson(String url, org.json.JSONObject params) {
        HttpPost request = new HttpPost(url);
        try { 
            request.setHeader("Content-Type", "application/json");   
			request.setEntity(new StringEntity(params.toString()));
            HttpClient httpclient = new DefaultHttpClient();
            httpclient.getParams().setParameter(CoreConnectionPNames.CONNECTION_TIMEOUT, 6000);
            httpclient.getParams().setParameter(CoreConnectionPNames.SO_TIMEOUT, 6000);
            return httpclient.execute(request);
        } catch (IOException e) {
        	e.toString();
        }
        return null;
    }
    public static HttpResponse doPostPic(String url, String pic){
 		HttpResponse response=null;
 		FileOutputStream out=null;
 		FileInputStream fis=null;
 		long FileSize=0;
 		try{
 			httpclient = new DefaultHttpClient();
		    httppost = new HttpPost(url); 
			File imgfile = new File(pic);  
			if (!imgfile.exists()) {
				imgfile.createNewFile();
			}else {
				fis=new FileInputStream(imgfile);
				FileSize=fis.available();
				fis.close();
			}
			if(FileSize>1024*20){
					String tmp_path=pic.substring(0,pic.lastIndexOf("/"));
					String tmp_filename=pic.substring(pic.lastIndexOf("/")+1);
					tmp_filename="up_"+tmp_filename;
					imgfile = new File(tmp_path+"/"+tmp_filename);  
					imgfile.createNewFile();
					out=new FileOutputStream(imgfile);  
					Bitmap bm=ImageHandle.imageDo(pic,0);
					if(bm.compress(Bitmap.CompressFormat.PNG, 100, out)){ 
						out.flush(); 
						out.close(); 
					}  
			}
			FileEntity fileEntity = new FileEntity(imgfile, "image/jpeg"); 
			long lens=fileEntity.getContentLength();
			LogUtils.e(Globals.Tag, MODULE,"本次post 图片大小为..."+ lens);
			//fileEntity.setContentType("binary/octet-stream"); 
			httppost.setEntity(fileEntity); 
			response = httpclient.execute(httppost);
			LogUtils.e(Globals.Tag, MODULE,"发送完成..."+ lens);
 		}catch (Exception e) {
			// TODO: handle exception 
 			LogUtils.e(Globals.Tag, MODULE,"本次post json请求异常，返回..."+ e.toString());
 			 
		}finally{
			try {
 				if (out!=null) { 
 					out.close(); 
				} 
 				if (fis!=null) { 
 					fis.close(); 
				} 
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			} 
			
		}
 		return response;
 	}

    public static HttpResponse doGet(String url,Map params){
    	String paramString="";
    	HttpResponse response=null;
    	String curTime="";
    	if (params!=null) {
    		Iterator iter=params.entrySet().iterator();
    		while(iter.hasNext()){
        		Map.Entry entry=(Map.Entry) iter.next();
        		Object key=entry.getKey();
        		Object val=entry.getValue();
        		 
        		paramString+=paramString="&"+key+"="+val;
        	}
		} 
    
    	if(!paramString.equals("")){
    		paramString=paramString.replaceFirst("&","?");
    		url+=paramString;
    	}
    	 try {
             HttpGet request = new HttpGet(url); 
             HttpClient httpclient = new DefaultHttpClient();
           
             response=httpclient.execute(request);
             return response;
         } catch (Exception e) {
         	e.printStackTrace();
         }
    	 return null;
    }
    @Deprecated
    public static HttpResponse postPictures(String url, String path) {
        try {
            HttpPost request = new HttpPost(url);
            Bitmap bitmapOrg = BitmapFactory.decodeFile(path);
            ByteArrayOutputStream bao = new ByteArrayOutputStream();
            bitmapOrg.compress(Bitmap.CompressFormat.JPEG, 100, bao);
            byte[] ba = bao.toByteArray();
            ArrayList<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
//          nameValuePairs.add(new BasicNameValuePair("image", new BASE64Encoder().encode(ba)));  
            request.setEntity(new UrlEncodedFormEntity(nameValuePairs));
            HttpClient httpclient = new DefaultHttpClient();
//            if(Globals.CUR_NETWORK.equals(Globals.CUR_NETWORK_3G)){
//            	//getHostConfiguration().setProxy(Globals.MobileProxyHost, Globals.MobileProxyPort);
//            	 HttpHost proxy = new HttpHost(Globals.MobileProxyHost, Globals.MobileProxyPort);
//            	 httpclient.getParams().setParameter(ConnRoutePNames.DEFAULT_PROXY, proxy); 
// 	  	     } 
            return httpclient.execute(request);
        } catch (IOException e) {
        }
		return null;
    }
    private static void httpClientPost(String url) {
        HttpClient client = new DefaultHttpClient();
        HttpPost post = new HttpPost(url);

        try {
            ContentProducer cp = new ContentProducer() {
                public void writeTo(OutputStream outstream) throws IOException {
                    Writer writer = new OutputStreamWriter(outstream, "UTF-8");
                    writer.write("");
                    writer.flush();
                }
            };

            post.setEntity(new EntityTemplate(cp));
            HttpResponse response = client.execute(post);
        
            System.out.println(EntityUtils.toString(response.getEntity()));
        } catch (ClientProtocolException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    public static  boolean download(String url, List<NameValuePair> params) throws IOException{
    	String filepath=ActivityUtil.getHomePath()+"/a.txt" ;
    	File files=new File(filepath);
    	BufferedOutputStream streamInstance = new BufferedOutputStream(
				new FileOutputStream(files)); 
    	DataOutputStream outputStreamInstance = new DataOutputStream(
    			streamInstance); 
    	
    	try {
			HttpClient client = new DefaultHttpClient();
			//params[0]代表连接的url
			HttpGet get = new HttpGet(url);
			HttpResponse response = client.execute(get);
			HttpEntity entity = response.getEntity();
			long length = entity.getContentLength();
			InputStream is = entity.getContent();
			String s = null;
			if (is != null) {
				 
				byte[] buf = new byte[1024];
				int ch = -1; 
				while ((ch = is.read(buf,0,1024)) != -1) {
					outputStreamInstance.write(buf, 0, ch); 
				} 
			}
			//返回结果
			 
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}finally{
			outputStreamInstance.close();
			streamInstance.close(); 
		}
		return true;
    }
}
