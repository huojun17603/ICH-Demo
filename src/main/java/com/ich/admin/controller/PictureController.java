package com.ich.admin.controller;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ich.admin.dto.MPicture;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.poi.openxml4j.opc.internal.FileHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.ich.core.base.JsonUtils;
import com.ich.core.base.ObjectHelper;
import com.ich.core.file.FileUtil;
import com.ich.core.file.ImageCut;
import com.ich.core.file.MimeType;
import com.ich.core.http.controller.CoreController;
import com.ich.core.http.other.IPUtils;
import com.ich.core.plug.jedis.JedisClient;
import sun.misc.BASE64Decoder;

@Controller
@RequestMapping("management/file")
public class PictureController extends CoreController{
	
	@Autowired
	protected JedisClient jedisClient;
	/** JEDIS 零时图片库 */
	@Value("${JEDIS_TMP_IMG}")
	private Integer JEDIS_TMP_IMG;
	
//	private String FILE_UPLOAD_ROOT;
	
//	private String FILE_MIME_TYPE;
	
	@Value("${IMG_UPLOAD_ROOT}")
	private String IMG_UPLOAD_ROOT;
	@Value("${IMG_MIME_TYPE}")
	private String IMG_MIME_TYPE;
	@Value("${FILE_SERVER_HTTP}")
	private String FILE_SERVER_HTTP;
	
	/** 图片上传【文件流】 支持多图片上传 
	 * @throws IOException */
	@RequestMapping(value="/img/upload", method=RequestMethod.POST)
    @ResponseBody
	public Map<String,Object> imgUpload(HttpServletRequest request,HttpServletResponse response) throws IOException {
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;
		Map<String, MultipartFile> fileMap = multipartRequest.getFileMap();
		String root = request.getSession().getServletContext().getRealPath("")+File.separator+IMG_UPLOAD_ROOT;
		List<MPicture> list = new ArrayList<>();
		for (Map.Entry<String, MultipartFile> entity : fileMap.entrySet()) {
			MultipartFile multipartFile = entity.getValue();//保存原图
			String fileName = multipartFile.getOriginalFilename();//检查文件MIME_TYPE类型是否存在与白名单
			String ext = FileUtil.getFileExt(fileName).substring(1);
			if(ObjectHelper.isNotEmpty(IMG_MIME_TYPE)){
				String typeArray[] = IMG_MIME_TYPE.split(",");
				Boolean flag = false;
				for(String type : typeArray) if(ext.equals(type.toLowerCase())) flag = true;
				if(!flag)return getFailMap("服务器仅支持下类文件上传："+IMG_MIME_TYPE);
			}
			if(!MimeType.filter(multipartFile.getBytes(), ext))return getFailMap("服务器仅支持下类文件上传："+IMG_MIME_TYPE);//检查文件头是否和MIME_TYPE一致
			String ip = IPUtils.findRequestIP(request);
			String randomname = FileUtil.createRandomFileName(fileName);
			String filePath = FileUtil.createTimesDirs(root);
			File file = new File(filePath+"/"+randomname.toLowerCase());
			FileCopyUtils.copy(multipartFile.getBytes(), file);
			String dataUrl = filePath.substring(filePath.indexOf(IMG_UPLOAD_ROOT));
			MPicture picture = new MPicture();
			picture.setDataName(randomname);
			picture.setUploadIP(ip);
			picture.setDataUrl(dataUrl);
			picture.setUrl(FILE_SERVER_HTTP + dataUrl +"/"+ randomname);
			picture.setStatus(false);
			BufferedImage image = ImageIO.read(file);//配置图片信息
			picture.setHeight(image.getHeight());
			picture.setWidth(image.getWidth());
			jedisClient.set(JEDIS_TMP_IMG,picture.getUrl(),JsonUtils.objectToJson(picture));
			jedisClient.expire(JEDIS_TMP_IMG,picture.getUrl(),600);//有效时间10分钟
			list.add(picture);
		}
		return getSuccessMap(list);
	}
	
	@RequestMapping(value="/img/base64",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> imgBase64(HttpServletRequest request,String base64File,String fileName) throws IOException {
		if(ObjectHelper.isEmpty(base64File))return getFailMap("请上传字节码");
		List<MPicture> list = new ArrayList<>();
		BASE64Decoder decoder = new BASE64Decoder();
        byte[] bytes = decoder.decodeBuffer(base64File);//Base64解码
        for(int i=0;i<bytes.length;++i) {
            if(bytes[i]<0) bytes[i]+=256;
        }
        String root = request.getSession().getServletContext().getRealPath("")+File.separator+IMG_UPLOAD_ROOT;
        String ext = FileUtil.getFileExt(fileName).substring(1);
		if(ObjectHelper.isNotEmpty(IMG_MIME_TYPE)){
			String typeArray[] = IMG_MIME_TYPE.split(",");
			Boolean flag = false;
			for(String type : typeArray) if(ext.equals(type.toLowerCase())) flag = true;
			if(!flag)return getFailMap("服务器仅支持下类文件上传：" + IMG_MIME_TYPE);
		}
		if(!MimeType.filter(bytes, ext))return getFailMap("服务器仅支持下类文件上传："+IMG_MIME_TYPE);//检查文件头是否和MIME_TYPE一致
		String ip = IPUtils.findRequestIP(request);
		String randomname = FileUtil.createRandomFileName(fileName);
		String filePath = FileUtil.createTimesDirs(root);
		File file = new File(filePath+"/"+randomname.toLowerCase());
		FileCopyUtils.copy(bytes, file);
		String dataUrl = filePath.substring(filePath.indexOf(IMG_UPLOAD_ROOT));
		MPicture picture = new MPicture();
		picture.setDataName(randomname);
		picture.setUploadIP(ip);
		picture.setDataUrl(dataUrl);
		picture.setUrl(FILE_SERVER_HTTP + dataUrl +"/"+ randomname);
		picture.setStatus(false);
		BufferedImage image = ImageIO.read(file);//配置图片信息
		picture.setHeight(image.getHeight());
		picture.setWidth(image.getWidth());
		jedisClient.set(JEDIS_TMP_IMG,picture.getUrl(),JsonUtils.objectToJson(picture));
		jedisClient.expire(JEDIS_TMP_IMG,picture.getUrl(),600);//有效时间10分钟
		list.add(picture);
		return getSuccessMap(list);
	}
	
	/** 裁剪图片 */
	@RequestMapping( value="/upload/crop", method=RequestMethod.POST )
	@ResponseBody
	public Map<String, Object> crop(HttpServletRequest request, HttpServletResponse response
			,String id,String ratios,Integer cut_x,Integer cut_y,Integer cut_w,Integer cut_h) {
		String jsonData = jedisClient.get(JEDIS_TMP_IMG,id);
		MPicture img = JsonUtils.jsonToPojo(jsonData, MPicture.class);
		if(ObjectHelper.isEmpty(img))return getFailMap("错误的图片信息！");
		String ip = IPUtils.findRequestIP(request);
        if(!ip.equals(img.getUploadIP()))return getFailMap("客户端验证失效，请重新上传原图！");//强制要求上传IP等于裁剪IP，可以起到一定防护作用
        String ratiosArray[] = ratios.split(",");//获取需要压缩的宽高比
        if(ObjectHelper.isNotEmpty(ratiosArray)){
        	for(String ratio : ratiosArray){
				try{
					Integer width = Integer.valueOf(ratio.split("\\*")[0]);
					Integer height = Integer.valueOf(ratio.split("\\*")[1]);
					if(ObjectHelper.isNotEmpty(width)&&ObjectHelper.isNotEmpty(height)&&height>0&&width>0){
						if(cut_w<width&&cut_w!=0) return getFailMap("要求压缩比例参数符合格式，并原图大小大于每个压缩后大小！");
						if(cut_h<height&&cut_h!=0) return getFailMap("要求压缩比例参数符合格式，并原图大小大于每个压缩后大小！");
					}else{
						return getFailMap("要求压缩比例参数符合格式，并原图大小大于每个压缩后大小！");
					}
				}catch (Exception e) {
					return getFailMap("要求压缩比例参数符合格式，并原图大小大于每个压缩后大小！");
				}
			}
        }
        String uploadRoot = request.getSession().getServletContext().getRealPath("");//系统根目录
		String srcImageFile = uploadRoot+"/"+img.getDataUrl()+"/"+img.getDataName();
		String imgName = img.getDataName().substring(0,img.getDataName().lastIndexOf("."));
		String path = img.getDataUrl();
		String ext = FileUtil.getFileExt(img.getDataName()).substring(1);
		String dirImageFile = uploadRoot+"/"+path+"/"+imgName+"_"+cut_w+"_"+cut_h+"."+ext;
		//定义返回值
		Map<String, Object> data = new HashMap<String, Object>();
		BufferedImage image;
		if(cut_w!=0&&cut_h!=0){
			try {
				File dirFile = new File(dirImageFile);
				ImageCut.abscut(srcImageFile,dirImageFile,
						cut_x,cut_y,cut_w,cut_h);//图片裁剪
				image = ImageIO.read(dirFile);
			} catch (IOException e) {
				return getFailMap("文件读取失败！");
			}
		}else{
			dirImageFile = srcImageFile;
		}
		//对裁剪后的图片压缩
		if(ObjectHelper.isNotEmpty(ratiosArray)){
			for(String ratio : ratiosArray){//开始压缩保存
				Integer width = Integer.valueOf(ratio.split("\\*")[0]);
				Integer height = Integer.valueOf(ratio.split("\\*")[1]);
				String dirImageFile2 = uploadRoot+"/"+path+"/"+imgName+"_"+width+"_"+height+"."+ext;
				ImageCut.scale(dirImageFile, dirImageFile2, width, height);
			}
		}
		return getSuccessMap();
	}



	@RequestMapping("kindeditor/uploadJson")
	@ResponseBody
	public Map<String,Object> uploadJson(HttpServletRequest request,HttpServletResponse response) throws IOException {
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("error", 1);
		if(!ServletFileUpload.isMultipartContent(request)) return map;
		String root = request.getSession().getServletContext().getRealPath("")+File.separator+IMG_UPLOAD_ROOT;
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;
		Map<String, MultipartFile> fileMap = multipartRequest.getFileMap();
		for (Map.Entry<String, MultipartFile> entity : fileMap.entrySet()) {
			MultipartFile multipartFile = entity.getValue();//保存原图
			String fileName = multipartFile.getOriginalFilename();//检查文件MIME_TYPE类型是否存在与白名单
			String ext = FileUtil.getFileExt(fileName).substring(1);
			if(ObjectHelper.isNotEmpty(IMG_MIME_TYPE)){
				String typeArray[] = IMG_MIME_TYPE.split(",");
				Boolean flag = false;
				for(String type : typeArray) if(ext.equals(type.toLowerCase())) flag = true;
				if(!flag) {
					map.put("url","服务器仅支持下类文件上传："+IMG_MIME_TYPE);
					return map;
				}
			}
			if(!MimeType.filter(multipartFile.getBytes(), ext)){
				map.put("url","服务器仅支持下类文件上传："+IMG_MIME_TYPE);
				return map;
			}
			String randomname = FileUtil.createRandomFileName(fileName);
			String filePath = FileUtil.createTimesDirs(root);
			File file = new File(filePath+"/"+randomname.toLowerCase());
			FileCopyUtils.copy(multipartFile.getBytes(), file);
			String dataUrl = filePath.substring(filePath.indexOf(IMG_UPLOAD_ROOT));
			map.put("error", 0);
			map.put("url", FILE_SERVER_HTTP + dataUrl +"/"+ randomname);

		}
		return map;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping("portal/attachment/FileManagerJson")
	@ResponseBody
	public Map<String,Object> fileManagerJson(HttpServletRequest request,HttpServletResponse response) {
		Map<String,Object> map = new HashMap<String,Object>();
		//商品编号
		String code = request.getParameter("code");
		//根目录路径，可以指定绝对路径，比如 /var/www/attached/
		String rootPath = request.getSession().getServletContext().getRealPath("/")+"upload\\";
		//pageContext.getServletContext().getRealPath("/") + "upload/";
		//根目录URL，可以指定绝对路径，比如 http://www.yoursite.com/attached/
		String rootUrl  = "/upload/";

		//图片扩展名
		String[] fileTypes = new String[]{"gif", "jpg", "jpeg", "png", "bmp"};

		String dirName = request.getParameter("dir");
		if (dirName != null) {
			if(!Arrays.<String>asList(new String[]{"image", "flash", "media", "file"}).contains(dirName)){
				map.put("error","Invalid Directory name.");
				return map;
			}
			rootPath += dirName + "/";
			rootUrl += dirName + "/";
			//访问该商品的图片
			rootPath+=code+"/";
			rootUrl += code + "/";
			File saveDirFile = new File(rootPath);
			if (!saveDirFile.exists()) {
				saveDirFile.mkdirs();
			}
		}
		//根据path参数，设置各路径和URL
		String path = request.getParameter("path") != null ? request.getParameter("path") : "";
		String currentPath = rootPath + path;
		String currentUrl = rootUrl + path;
		String currentDirPath = path;
		String moveupDirPath = "";
		if (!"".equals(path)) {
			String str = currentDirPath.substring(0, currentDirPath.length() - 1);
			moveupDirPath = str.lastIndexOf("/") >= 0 ? str.substring(0, str.lastIndexOf("/") + 1) : "";
		}

		//排序形式，name or size or type
		String order = request.getParameter("order") != null ? request.getParameter("order").toLowerCase() : "name";

		//不允许使用..移动到上一级目录
		if (path.indexOf("..") >= 0) {
			map.put("error","Access is not allowed.");
			return map;
		}
		//最后一个字符不是/
		if (!"".equals(path) && !path.endsWith("/")) {
			map.put("error","Parameter is not valid.");
			return map;
		}
		//目录不存在或不是目录
		File currentPathFile = new File(currentPath);
		if(!currentPathFile.isDirectory()){
			map.put("error","目录不存在.");
			return map;
		}

		//遍历目录取的文件信息
		List<Hashtable> fileList = new ArrayList<Hashtable>();
		if(currentPathFile.listFiles() != null) {
			for (File file : currentPathFile.listFiles()) {
				Hashtable<String, Object> hash = new Hashtable<String, Object>();
				String fileName = file.getName();
				if(file.isDirectory()) {
					hash.put("is_dir", true);
					hash.put("has_file", (file.listFiles() != null));
					hash.put("filesize", 0L);
					hash.put("is_photo", false);
					hash.put("filetype", "");
				} else if(file.isFile()){
					String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
					hash.put("is_dir", false);
					hash.put("has_file", false);
					hash.put("filesize", file.length());
					hash.put("is_photo", Arrays.<String>asList(fileTypes).contains(fileExt));
					hash.put("filetype", fileExt);
				}
				hash.put("filename", fileName);
				hash.put("datetime", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(file.lastModified()));
				fileList.add(hash);
			}
		}

		if ("size".equals(order)) {
			Collections.sort(fileList, new SizeComparator());
		} else if ("type".equals(order)) {
			Collections.sort(fileList, new TypeComparator());
		} else {
			Collections.sort(fileList, new NameComparator());
		}

		map.put("moveup_dir_path", moveupDirPath);
		map.put("current_dir_path", currentDirPath);
		map.put("current_url", currentUrl);
		map.put("total_count", fileList.size());
		map.put("file_list", fileList);

		response.setContentType("application/json; charset=UTF-8");
		return map;

	}

	class NameComparator implements Comparator {
		public int compare(Object a, Object b) {
			Hashtable hashA = (Hashtable)a;
			Hashtable hashB = (Hashtable)b;
			if (((Boolean)hashA.get("is_dir")) && !((Boolean)hashB.get("is_dir"))) {
				return -1;
			} else if (!((Boolean)hashA.get("is_dir")) && ((Boolean)hashB.get("is_dir"))) {
				return 1;
			} else {
				return ((String)hashA.get("filename")).compareTo((String)hashB.get("filename"));
			}
		}
	}
	class SizeComparator implements Comparator {
		public int compare(Object a, Object b) {
			Hashtable hashA = (Hashtable)a;
			Hashtable hashB = (Hashtable)b;
			if (((Boolean)hashA.get("is_dir")) && !((Boolean)hashB.get("is_dir"))) {
				return -1;
			} else if (!((Boolean)hashA.get("is_dir")) && ((Boolean)hashB.get("is_dir"))) {
				return 1;
			} else {
				if (((Long)hashA.get("filesize")) > ((Long)hashB.get("filesize"))) {
					return 1;
				} else if (((Long)hashA.get("filesize")) < ((Long)hashB.get("filesize"))) {
					return -1;
				} else {
					return 0;
				}
			}
		}
	}

	class TypeComparator implements Comparator {
		public int compare(Object a, Object b) {
			Hashtable hashA = (Hashtable)a;
			Hashtable hashB = (Hashtable)b;
			if (((Boolean)hashA.get("is_dir")) && !((Boolean)hashB.get("is_dir"))) {
				return -1;
			} else if (!((Boolean)hashA.get("is_dir")) && ((Boolean)hashB.get("is_dir"))) {
				return 1;
			} else {
				return ((String)hashA.get("filetype")).compareTo((String)hashB.get("filetype"));
			}
		}
	}
	
}
