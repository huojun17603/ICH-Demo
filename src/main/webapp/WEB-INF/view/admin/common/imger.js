//**********图片预览器******//
function imgDIV(uri){
    var img_div = '<div></div>';
    var img = '<img style="max-width:950px;margin-top: 5px;margin-left: 5px;" src="'+uri+'" />';
    $window = $(img_div);
    $window.append(img);
    var max_width = 950;
    var pigw = 24;
    var pigh = 46;
    var imgs = new Image();
    imgs.src = uri;
    var width = 950;
    var height = 800;
    // 如果图片被缓存，则直接返回缓存数据
    if(imgs.complete){
        width = imgs.width;
        height = imgs.height;
        if(width>max_width) {
            width = max_width;
            height = imgs.height/imgs.width*max_width;
        }
        createIMGWindow($window,width+pigw,height+pigh,img_div);
        return ;
    }else{
        // 完全加载完毕的事件
        imgs.onload = function(){
            width = imgs.width;
            height = imgs.height;
            if(width>max_width) {
                width = max_width;
                height = imgs.height/imgs.width*max_width;
            }
            createIMGWindow($window,width+pigw,height+pigh,img_div);
            $.messager.progress('close');
        }
        imgs.onerror = function(){
            $window.window({
                width:200 + pigw,
                height:200 + pigh
            })
            createIMGWindow($window,200,200,img_div);
            $.messager.progress('close');
        }
        $.messager.progress({
            title:'加载中……',
            msg:'正在加载，请稍等……'
        });
    }

}
function createIMGWindow($window,width,height,img_div){
    //创建Window
    $window.window({
        title:'图片浏览器',
        width:width,
        height:height,
        modal:true,
        collapsible:false,
        minimizable:false,
        maximizable:false,
        resizable:false,
        closable:true,
        closed:false,
        onClose:function(){
            $(img_div).remove();
        }
    });
}

//将此类的构造函数加入至JQUERY对象中
jQuery.extend({
    createIMG:function(uri){
        return new imgDIV(uri);
    }
});

//**********图片上传功能**********//
//*****需引入html5.upload.js*****//
var jcrop_api;
var $boundx;
var $boundy;
var $preview;
var $pcnt;
var $pimg;
var $xsize;
var $ysize;

var init_ZXXFILE = false;

function OPEN_CROP_WIN(property){
    var mw = property.minSize[0];
    var mh = property.minSize[1];
    var sly = 'style="width:'+mw+'px;height:'+mh+'px;"';
    property.aspectRatio = mw/mh;
    var crop_div = '<div style="padding:5px;"></div>';
    var form = '<form id="img_cut_form" style="margin: 0;">'
        +'<input id="img_id" type="hidden" name="id"/>'
        +'<input id="img_cut_x" type="hidden" name="cut_x"/>'
        +'<input id="img_cut_y" type="hidden" name="cut_y"/>'
        +'<input id="img_cut_w" type="hidden" name="cut_w"/>'
        +'<input id="img_cut_h" type="hidden" name="cut_h"/>'
        +'<input id="img_ratios" type="hidden" name="ratios"/>'
        +'</form>';
    var jcrop_div = '<div class="jcrop-div jcrop-box"><img id="jcrop_img" /></div>'
        +'<div id="preview-pane" class="jcrop-box"><div  class="preview-container" '+sly+'><img id="jcrop_preview" class="jcrop-preview" alt="预览效果" /></div></div>';
    var btn_div = '<div class="sgtz_center" >'
        +'<a id="crop_btn" href="javascript:void(0)" class="easyui-linkbutton" style="width:100px;margin-right:20px;">截取保存</a>'
        +'<a id="crop_close_btn" href="javascript:void(0)" class="easyui-linkbutton" style="width:100px">取消返回</a>'
        +'</div>';
    $window = $(crop_div);
    $window.append($(form));
    $window.append($(jcrop_div));
    $window.append($(btn_div));

    //创建Window
    $window.window({
        title:'图片裁剪器',
        width:600 + mw,
        height:500,
        modal:true,
        collapsible:false,
        minimizable:false,
        maximizable:false,
        resizable:false,
        closable:false,
        closed:false
    });
    $.parser.parse($window);
    $("#crop_close_btn").on("click",{inthis:this},function(e){
        $window.window("close");
        $window.empty();
    });
    $("#crop_btn").on("click",{inthis:this},function(e){
        property.callCorp($("#img_cut_form").serialize());
        $window.window("close");
        $window.empty();
    });

    $("#img_ratios").val(property.ratios);

    property.previews = "jcrop_img,jcrop_preview";
    property.callUpload = function(file, response) {
        var json = eval('(' + response + ')');

        var width = json.data[0].width;
        var height = json.data[0].height;
        var radio = width/height;
        var radio_div = 1.33333333333;

        $("#img_id").val(json.data[0].url);

        if(!isEmpty(jcrop_api)){
            jcrop_api.destroy();
            $("#jcrop_img").css("width",width);
            $("#jcrop_img").css("height",height);
        }
        jcrop_img = $("#jcrop_img").Jcrop({
            boxWidth:512,
            boxHeight:384,
            aspectRatio:property.aspectRatio,
            minSize:property.minSize,
            onSelect: preview_crop
        },function(){
            var bounds = this.getBounds();
            boundx = bounds[0];
            boundy = bounds[1];
            jcrop_api = this;
        });
        if(width<=512&&height<=384){//图层大小调整
            $("div.jcrop-holder").css("margin-left",(512-width)/2);
            $("div.jcrop-holder").css("margin-top",(384-height)/2);
        }else{
            if(radio>radio_div){
                $("div.jcrop-holder").css("margin-top",(384-512/radio)/2);
            }else{
                $("div.jcrop-holder").css("margin-left",(512-384*radio)/2);
            }
        }
    }

    $preview = $('#preview-pane');
    $pcnt = $('#preview-pane .preview-container');
    $pimg = $('#preview-pane .preview-container img');
    xsize = $pcnt.width();
    ysize = $pcnt.height();

    OPEN_LOAD_WIN(property);
}

function OPEN_LOAD_WIN(property){
    ZXXFILE.fileInput = $("#uploadify").get(0);
    ZXXFILE.url = property.url;
    ZXXFILE.filter= function(files) {
        var arrFiles = [];
        for (var i = 0, file; file = files[i]; i++) {
            if (file.type.indexOf("image") == 0) {
                if (file.size >= 4096000) {
                    alert('您这张"'+ file.name +'"图片大小过大，应小于4M');
                } else {
                    arrFiles.push(file);
                }
            } else {
                alert('文件"' + file.name + '"不是图片。');
            }
        }
        return arrFiles;
    }
    ZXXFILE.onSelect = function(files) {
        var html = '', i = 0;
        var funAppendImage = function() {
            file = files[0];
            if (file) {
                var reader = new FileReader()//用户点击上传方案，不适用于自动上传
                reader.onload = function(e) {
                    if(property.previews){
                        var preview_arr = property.previews.split(",");
                        for(i=0;i<preview_arr.length;i++){
                            $("#"+preview_arr[i]).attr("src",e.target.result);
                        }
                    }
                }
                reader.readAsDataURL(file);//现用户本地使用
                ZXXFILE.funUploadFile();
            }
        };
        funAppendImage();
    }
    ZXXFILE.onProgress = function(file, loaded, total) {
//		var eleProgress = $("#uploadProgress_div"), percent = (loaded / total * 100).toFixed(2) + '%';
//		eleProgress.show().html("正在上传："+percent);
    }
    ZXXFILE.onSuccess = function(file, response) {
        property.callUpload(file, response);
    }
    ZXXFILE.onFailure = function(file) {
        alert("上传失败");
//		$("#uploadProgress_div").show().html();
    }
    ZXXFILE.onComplete = function() {
        //alert("<p>当前图片全部上传完毕，可继续添加上传。</p>");
    }
    if(!init_ZXXFILE){
        ZXXFILE.init();
        init_ZXXFILE = !init_ZXXFILE;
    }
    $('#uploadify').val("");
    $('#uploadify').click();
}

function preview_crop(obj) {

    $("#img_cut_x").val(Number(obj.x).toFixed(0));
    $("#img_cut_y").val(Number(obj.y).toFixed(0));
    $("#img_cut_w").val(Number(obj.w).toFixed(0));
    $("#img_cut_h").val(Number(obj.h).toFixed(0));
    if (parseInt(obj.w) > 0) {
        //计算预览区域图片缩放的比例，通过计算显示区域的宽度(与高度)与剪裁的宽度(与高度)之比得到
        var rx = xsize / obj.w;
        var ry = ysize / obj.h;
        //通过比例值控制图片的样式与显示
        $pimg.css({
            width: Math.round(rx * boundx) + 'px',
            height: Math.round(ry * boundy) + 'px',
            marginLeft: '-' + Math.round(rx * obj.x) + 'px',
            marginTop: '-' + Math.round(ry * obj.y) + 'px'
        });
    }
}

jQuery.extend({
    UPLOAD_IMG:function(property){
        if(property.crop){
            return new OPEN_CROP_WIN(property);
        }else{
            return new OPEN_LOAD_WIN(property);
        }
    }
});

