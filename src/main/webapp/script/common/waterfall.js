function initWaterFall(panel){
	var $boxs = $("#"+panel+">div");//获取瀑布流中所有的DIV
	var width = $boxs.eq(0).outerWidth();//获取DIV的宽度
	var clos = Math.floor($(window).width()/width);
	var hArr = [];
	$boxs.each(function(index,value){
		var h = $boxs.eq(index).outerHeight();
		if(index<clos){
			hArr[index] = h;
		}else{
			var minH = Math.min.apply(null,hArr);
			var minHIndex = $.inArray(minH,hArr);
			$(value).css({
				'position':'absolute',
				'top':minH+'px',
				'left':minHIndex*width+'px',
				'float':'left'
			});
			hArr[minHIndex] += $boxs.eq(index).outerHeight();
		}
	});
}