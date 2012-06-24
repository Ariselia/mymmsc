package org.mymmsc.api.context.samples;

import java.util.List;

public class TObject {
	private List<Bill> bills;
	private int status;
	private String message;
	private TOrder order;
	
	public List<Bill> getBills() {
		return bills;
	}

	public void setBills(List<Bill> bills) {
		this.bills = bills;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	/**
	 * @return the order
	 */
	public TOrder getOrder() {
		return order;
	}

	/**
	 * @param order the order to set
	 */
	public void setOrder(TOrder order) {
		this.order = order;
	}
}
