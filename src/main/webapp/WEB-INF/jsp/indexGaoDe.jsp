<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set value="${pageContext.request.contextPath}" var="path"
	scope="page" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
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
		<div id = 'location_div'></div>
	</div>
	<script src="${path}/js/jquery-3.4.1.js"></script>
	<script src="https://webapi.amap.com/maps?v=1.4.15&key=d7dca585ec822e6d7761b179f70e26e7"></script>
		

	<script>
		map = new AMap.Map("container", {
			resizeEnable : true,
			zoom : 12,
			/* center : [ 117.024967066, 36.6827847272 ], */
			viewMode : "3D"
		});
		
		 var infoWindow = new AMap.InfoWindow({offset: new AMap.Pixel(0, -30)});
		 console.log('infoWindow', infoWindow)
		
		/** 地图定位相关操作 */
		AMap.plugin('AMap.Geolocation', function() {
			  var geolocation = new AMap.Geolocation({
			    // 是否使用高精度定位，默认：true
			    enableHighAccuracy: true,
			    // 设置定位超时时间，默认：无穷大
			    timeout: 10000,
			    // 定位按钮的停靠位置的偏移量，默认：Pixel(10, 20)
			    buttonOffset: new AMap.Pixel(10, 20),
			    //  定位成功后调整地图视野范围使定位位置及精度范围视野内可见，默认：false
			    zoomToAccuracy: true,     
			    //  定位按钮的排放位置,  RB表示右下
			    showButton:true,
			    buttonPosition: 'RB',
			    showMarker: true,        //定位成功后在定位到的位置显示点标记，默认：true
		        showCircle: true,        //定位成功后用圆圈表示定位精度范围，默认：true
		        panToLocation: true     //定位成功后将定位到的位置作为地图中心点，默认：true
			  })

			  //map.addControl(geolocation); // 打开注释，让定位生效
			  geolocation.getCurrentPosition();
			  AMap.event.addListener(geolocation, 'complete', onComplete)
			  AMap.event.addListener(geolocation, 'error', onError)

			  function onComplete (data) {
			    // data是具体的定位信息
			    //$("#location_div").html('当前地址：'+ data.formattedAddress + '<br/>' +'经度：' + data.position.lng + '，纬度：' + data.position.lat)
			  }

			  function onError (data) {
			    // 定位出错
			  }
			})

		function getData() {
			$.ajax({
				type : "POST",
				url : "${path}/detail/findAll",
				dataType : "json",
				crossDomain : true,
				success : function(result) {
					console.log('result', result)
					dealWithData(result);
				}
			});
		}
		
		

		function dealWithData(data) {
			
			var pointData = [];
			data.forEach(function(item, index){
				var singlePoint = {
						lnglat: [parseFloat(item.jxl_x_xz) + 0.003, parseFloat(item.jxl_y_xz) + 0.002],
						name: item.cons_no,
						id:index,
						tg_id:item.tg_id
						
				};
				pointData.push(singlePoint);
			});
			
			// 实例化 AMap.MassMarks
			massMarks = new AMap.MassMarks(pointData, {//创建一个海量麻点图层
			    url: '${path}/img/circle.png',
			    anchor: new AMap.Pixel(100,100),
			    size: new AMap.Size(11, 11),
			    opacity:1,
			    cursor:'pointer',
			    zIndex: 10
			    }); 

			// 将 massMarks 添加到地图实例
			massMarks.setMap(map);
			
			massMarks.on("mouseover", infoOpen);
			massMarks.on("mouseout", infoClose);
		}

		
		function infoOpen(e){
			var content = "<div style = 'font-size:10px;font-family:Microsoft Yahei;'> tg_id：" + e.data.tg_id + "<br/>"+ "经度："+ e.data.lnglat.lng +"<br/>纬度：" + e.data.lnglat.lat + "</div>"
			infoWindow.setContent(content);
	        infoWindow.open(map, e.data.lnglat); 
		}
		
		function infoClose(e){
			infoWindow.close(map, e.data.lnglat);
		}
		
		$(function() {
			getData()
		})
	</script>
</body>
</html>
