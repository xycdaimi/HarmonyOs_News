package com.zcxy.mapper;

import com.zcxy.pojo.News;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.UUID;

public interface NewsMapper {
    int addNews(News news);
    int deleteByIds(@Param("ids") int[] ids);
    int updateNews(News news);
    List<News> selectByUid(@Param("uid") UUID uid,@Param("start") int start,@Param("limit") int limit);
    List<News> selectByTitle(@Param("title") String title,@Param("start") int start,@Param("limit") int limit);
    List<News> selectByType(@Param("new_type") String new_type,@Param("start")int start,@Param("limit")int limit);
    List<News> selectList(@Param("start") int start,@Param("limit") int limit);
    @Select("SELECT * FROM News")
    List<News> selectAll();//使用注解开发
    List<News> selectById(int id);
    News selectIdMax();
}
