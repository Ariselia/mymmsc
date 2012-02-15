package com.fengxf.feng.activity.ebuy.bean;

public class OrderListBean {
	private String ordered=null;
	private String price=null;
	private String ordertime=null;
	private String state=null;
	public String getOrdereid() {
		return ordered;
	}
	public void setOrdereid(String ordereid) {
		this.ordered = ordereid;
	}
	public String getPrice() {
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
	}
	public String getOrdertime() {
		return ordertime;
	}
	public void setOrdertime(String ordertime) {
		this.ordertime = ordertime;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	
}
