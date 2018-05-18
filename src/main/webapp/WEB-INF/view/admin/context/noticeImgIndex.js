var params = {
	fileInput: $("#uploadify").get(0),
	url: basePath + "management/file/img/upload",
	filter: function(files) {
		var arrFiles = [];
		for (var i = 0, file; file = files[i]; i++) {
			if (file.type.indexOf("image") == 0) {
				if (file.size >= 1024000) {
					alert('您这张"'+ file.name +'"图片大小过大，应小于1024k');	
				} else {
					arrFiles.push(file);
				}			
			} else {
				alert('文件"' + file.name + '"不是图片。');	
			}
		}
		return arrFiles;
	},
	onSelect: function(files) {
		var html = '', i = 0;
		var funAppendImage = function() {
			file = files[0];
			if (file) {
				var reader = new FileReader()//用户点击上传方案，不适用于自动上传
				reader.onload = function(e) {
					$("#img").attr("src",e.target.result);
				}
				reader.readAsDataURL(file);//现用户本地使用
				ZXXFILE.funUploadFile();
			} else {
				alert();
			}
		};
		funAppendImage();		
	},
	onProgress: function(file, loaded, total) {
//		var eleProgress = $("#uploadProgress_div"), percent = (loaded / total * 100).toFixed(2) + '%';
//		eleProgress.show().html("正在上传："+percent);
	},
	onSuccess: function(file, response) {
        var json = eval('(' + response + ')');
        $("#img_input").val(json.data[0].url);
		alert("上传完成");
//		$("#uploadProgress_div").show().html("上传完成");
	},
	onFailure: function(file) {
		alert("上传失败");
//		$("#uploadProgress_div").show().html();
	},
	onComplete: function() {
		//alert("<p>当前图片全部上传完毕，可继续添加上传。</p>");
	}
};
ZXXFILE = $.extend(ZXXFILE, params);
ZXXFILE.init();