package com.fengxf.feng.activity.ebuy.bean;

import java.util.List;

public class OrderBean {  
	private OrderheadBean orderhead=null;
	private  List<OrderbodyBean> orderbody=null;
	public OrderheadBean getOrderhead() {
		return orderhead;
	}
	public void setOrderhead(OrderheadBean orderhead) {
		this.orderhead = orderhead;
	}
	public List<OrderbodyBean> getOrderbody() {
		return orderbody;
	}
	public void setOrderbody(List<OrderbodyBean> orderbody) {
		this.orderbody = orderbody;
	}
	 
	 
	 
	
}
