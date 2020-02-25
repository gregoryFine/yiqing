package com.ln.yiqing;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

/**
 * 处理ajax跨域请求
 * 若使用网关服务调用微服务，则注掉@Configuration注解；不使用网关服务，需将注解打开
 * @author Administrator
 *
 */
@Configuration
public class CorsConfig {
	
	private CorsConfiguration buildConfig() {
		CorsConfiguration corsConfiguration = new CorsConfiguration();
		corsConfiguration.addAllowedOrigin("*"); //任何域名访问
		corsConfiguration.addAllowedHeader("*"); // 任何header访问
		corsConfiguration.addAllowedMethod("*"); // 任何方法访问
		corsConfiguration.setAllowCredentials(true);
		return corsConfiguration;
	}
	
	@Bean
	public CorsFilter corsFilter() {
		UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
		source.registerCorsConfiguration("/**", buildConfig());
		return new CorsFilter(source);
	}

}
