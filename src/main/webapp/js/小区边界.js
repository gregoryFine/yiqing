
window.onload = function(){
	var contain = document.getElementById('contain');
	// 初始化地图
    var map = new BMap.Map(contain);
    var top_left_navigation = new BMap.NavigationControl();  //左上角，添加默认缩放平移控件
    var top_left_control = new BMap.ScaleControl({anchor: BMAP_ANCHOR_TOP_LEFT});// 左上角，添加比例尺
    map.addControl(top_left_control);
    map.addControl(top_left_navigation);
    // 设置中心点坐标和地图级别
	var center = new BMap.Point(113.270506,23.135308); //滨河花园113.7456,27.639319
	map.centerAndZoom(center,19);
    map.enableScrollWheelZoom(true); // 开启鼠标滚轮缩放
 
    //小区名称
    var XQ = '竹园小区';
    //保存小区边界的经纬度
    var boundaryPoints = {
    	lng: [],
    	lat: [],
    	lngMin: 0,
    	lngMax: 0,
    	latMin: 0,
    	latMin: 0,
    }
    //保存过滤后的pois
    var filterPoisPoints = [];
    /**
     * 根据中心点获取当前小区的uid
     */
    var getLocalUid = function(){
		var local = new BMap.LocalSearch(map, {
			renderOptions:{map: map}
		});
		local.setMarkersSetCallback(function(pois){
			map.clearOverlays();
			console.log(pois);
			//画小区边界
			var uid = pois[0].uid;
			drowBoundary(uid,pois);
		})
		local.search(XQ);
  	};
 
  	/**
  	 * 根据获取到的uid，获取小区边界坐标集合，画多边形
  	 */
  	var drowBoundary = function(uid,pois){
  		$.ajax({  
            async: false,
            url:"http://map.baidu.com/?pcevaname=pc4.1&qt=ext&ext_ver=new&l=12&uid="+uid,
            dataType:'jsonp',  
            jsonp:'callback',
            success:function(result) {
                var content = result.content;
                if(content.geo != null && content.geo != undefined){
					var geo = content.geo;
					var points = coordinateToPoints(geo);
					//point分组，得到多边形的每一个点，画多边形
					if (points && points.indexOf(";") >= 0) {
						points = points.split(";");
					} 
					var arr=[];
					for (var i=0;i<points.length-1;i++){
						var temp = points[i].split(",");
						arr.push(new BMap.Point(parseFloat(temp[0]),parseFloat(temp[1])));
						boundaryPoints.lng.push(parseFloat(temp[0]));
						boundaryPoints.lat.push(parseFloat(temp[1]));
					}
					//创建多边形
					var polygon = new BMap.Polygon(arr, {
						strokeColor: "blue",
						strokeWeight: 2,
						strokeOpacity: 0.5,
					});
					map.addOverlay(polygon);   //增加多边形
					map.setViewport(polygon.getPath());    //调整视野
                }else{
                	console.log('暂无小区边界信息');
                }
                //获取小区边界最大最小经纬度
				getboundaryMinMaxLngLat(boundaryPoints);
				//过滤pois，去掉不在小区里边的点
				filterPois(pois);
				//重新撒下小区中的点
				for(var i=0;i<filterPoisPoints.length;i++){
					var marker = new BMap.Marker(filterPoisPoints[i].point);
					map.addOverlay(marker);
					//闭包给每个marker添加点击事件
					(function(i){
						marker.addEventListener('click',function(){
							console.log(filterPoisPoints[i].title)
						});
					})(i);
				}
            },
            timeout:3000
        });
  	};
 
  	/**
  	 * 百度米制坐标转为经纬度
  	 */
	var coordinateToPoints = function(coordinate) { 
		var points ="";
		if (coordinate) {
		    var projection = BMAP_NORMAL_MAP.getProjection();
		    if (coordinate && coordinate.indexOf("-") >= 0) {
		        coordinate = coordinate.split('-');
		    }
		    //取点集合
		    var tempco = coordinate[1];
		    if (tempco && tempco.indexOf(",") >= 0) {
		        tempco = tempco.replace(";","").split(",");
		    }
		    //分割点，两个一组，组成百度米制坐标
		    var temppoints=[];
		    for(var i = 0, len = tempco.length; i < len; i++){
		        var obj = new Object(); 
		        obj.lng=tempco[i];
		        obj.lat=tempco[i+1];
		        temppoints.push(obj);
		        i++;
		    }
		    //遍历米制坐标，转换为经纬度
		    for ( var i = 0, len = temppoints.length; i < len; i++) {
	            var pos = temppoints[i];
	            var point = projection.pointToLngLat(new BMap.Pixel(pos.lng, pos.lat));
	            points += ([ point.lng, point.lat ].toString() + ";");
		    }
		}
		return points;
	}
 
	/**
	 * 获取小区边界最大最小经纬度
	 */
	var getboundaryMinMaxLngLat = function(boundaryPoints){
		if (boundaryPoints && boundaryPoints.lng.length && boundaryPoints.lat.length) {
			boundaryPoints.lngMin = Math.min.apply(null,boundaryPoints.lng);
			boundaryPoints.lngMax = Math.max.apply(null,boundaryPoints.lng);
			boundaryPoints.latMin = Math.min.apply(null,boundaryPoints.lat);
			boundaryPoints.latMax = Math.max.apply(null,boundaryPoints.lat);
		}
	};
	/**
	 * 过滤pois，去掉不在小区里边的点
	 */
	var filterPois = function(pois){
		if (pois && pois.length && 
			boundaryPoints && boundaryPoints.lng.length && boundaryPoints.lat.length &&
			boundaryPoints.lngMin != 0 && boundaryPoints.lngMax != 0 &&
			boundaryPoints.latMin != 0 && boundaryPoints.latMax != 0) {
			for (var i = pois.length - 1; i >= 0; i--) {
				if(pois[i].point.lng > boundaryPoints.lngMin && 
					pois[i].point.lng < boundaryPoints.lngMax && 
					pois[i].point.lat > boundaryPoints.latMin && 
					pois[i].point.lat < boundaryPoints.latMax){
					filterPoisPoints.push(pois[i]);
				}
			}
		}
		console.log('过滤后小区内坐标')
		console.log(filterPoisPoints)
	};
   	getLocalUid();
}
