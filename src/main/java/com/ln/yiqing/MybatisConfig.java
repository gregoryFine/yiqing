package com.ln.yiqing;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.autoconfigure.jdbc.DataSourceBuilder;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

@Configuration
@MapperScan(basePackages = {"com.ln.yiqing.mapper.**"}, sqlSessionFactoryRef="sqlSessionFactory")
public class MybatisConfig {
	
	@Bean(name = "primaryDataSource")
	@Primary
	@ConfigurationProperties(prefix="spring.datasource")
	public DataSource primaryDataSource() {
		return DataSourceBuilder.create().build();
	}
	
	public SqlSessionFactory sqlSessionFactory(@Qualifier("primaryDataSource") DataSource primaryDataSource) throws Exception {
		SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
		factoryBean.setDataSource(primaryDataSource);
		return factoryBean.getObject();
	}
	
	public SqlSessionTemplate sqlSessionTemplate(@Qualifier("primaryDataSource") DataSource primaryDataSource) throws Exception {
		SqlSessionTemplate template = new SqlSessionTemplate(sqlSessionFactory(primaryDataSource));
		return template;
	}

}
