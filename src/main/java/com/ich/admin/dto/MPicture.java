package com.ich.admin.dto;

public class MPicture {
	public MPicture(){}
	/** 原图ID */
	private String id;
	/** 图片名称 */
	private String dataName;
	/** 相对路径 */
	private String dataUrl;
	/** 绝对路径 */
	private String url;
	/** IP */
	private String uploadIP;
	/** 完成状态 */
	private Boolean status;
	/***/
	private Integer width;
	/***/
	private Integer height;

	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getDataName() {
		return dataName;
	}
	public void setDataName(String dataName) {
		this.dataName = dataName;
	}
	public String getDataUrl() {
		return dataUrl;
	}
	public void setDataUrl(String dataUrl) {
		this.dataUrl = dataUrl;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getUploadIP() {
		return uploadIP;
	}
	public void setUploadIP(String uploadIP) {
		this.uploadIP = uploadIP;
	}
	public Integer getWidth() {
		return width;
	}
	public void setWidth(Integer width) {
		this.width = width;
	}
	public Integer getHeight() {
		return height;
	}
	public void setHeight(Integer height) {
		this.height = height;
	}
	public Boolean getStatus() {
		return status;
	}
	public void setStatus(Boolean status) {
		this.status = status;
	}
}
