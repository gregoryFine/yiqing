<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set value="${pageContext.request.contextPath}" var="path"
	scope="page" />
	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<style>
html, body {
	width: 100%;
	height: 100%;
	padding: 0;
	margin: 0;
}

.main_div {
	width: 100%;
	height: 100%;
}

#container {
	width: 100%;
	height: 100%;
}
#location_div{
	position:absolute;
	border:solid 0px red;
	width:200px;
	height:100px;
	right:0;
	top:0;
	font-size:10px;
	font-family:Microsoft Yahei;
}
</style>
</head>
<body>
<div class='main_div'>
		<div id="container"></div>
</div>

<script src="${path}/js/jquery-3.4.1.js"></script>
<script type="text/javascript" src="http://api.map.baidu.com/api?v=3.0&ak=Phb80fzRNTRsUAaXhrDjWGdDf55WEMy0"></script>

<script>
$(function(){
	initMap();
	getData();
})


function initMap(){
	map = new BMap.Map("container");         
	var point = new BMap.Point(117.024967066, 36.6827847272);  // 创建点坐标  
	map.centerAndZoom(point, 15);                 // 初始化地图，设置中心点坐标和地图级别 
	map.enableScrollWheelZoom(true);
	
	
	// 边界线
	var bdary = new BMap.Boundary();
	bdary.get('济南', function(rs){       //获取行政区域
	    var boundArr = rs.boundaries[0].split(';')
	    var boundPoints = [];
	    boundArr.forEach(function(item, index){
	    	var itemSplitArr = item.split(',')
	    	var boundPoint =  new BMap.Point(itemSplitArr[0], itemSplitArr[1]);
	    	boundPoints.push(boundPoint)
	    })
	    var polyline = new BMap.Polyline(boundPoints, {strokeColor:"blue", strokeWeight:3, strokeOpacity:0.5});
	    map.addOverlay(polyline);
	});
}

function getData() {
	$.ajax({
		type : "POST",
		url : "${path}/detail/findAll",
		dataType : "json",
		crossDomain : true,
		success : function(result) {
			dealWithData(result);
		}
	});
}


function dealWithData(data){
	var points = [];
	data.forEach(function(item, index){
		var point = new BMap.Point(item.jxl_x_xz, item.jxl_y_xz);
		point.tg_id = item.tg_id;
		point.cons_no = item.cons_no;
		points.push(point)
	});
	var options = {
			size: 11, // BMAP_POINT_SIZE_SMALL
			shape: BMAP_POINT_SHAPE_CIRCLE,
			color: '#F71717'
			};
	var pointCollection = new BMap.PointCollection(points, options);
	map.addOverlay(pointCollection); // 添加Overlay
	
	

	
	pointCollection.addEventListener('mouseover', function(e, a){
		
	   var opts = {
            width: 25,     // 信息窗口宽度
            height: 10,     // 信息窗口高度
            title: "信息", // 信息窗口标题
            enableMessage: false//设置允许信息窗发送短息
        };
        var infowindow = new BMap.InfoWindow("<div style = 'font-size:10px; font-family:Microsoft Yahei;'>tg_id：" + e.point.tg_id + "<br/>经度：" + e.point.lng + "<br/>纬度：" + e.point.lat + "</div>", opts);
        map.openInfoWindow(infowindow, e.point);
	})
	
	pointCollection.addEventListener('mouseout', function(e, a) {
		map.closeInfoWindow(e.point)
	}) 
	
}

</script>

</body>
</html>