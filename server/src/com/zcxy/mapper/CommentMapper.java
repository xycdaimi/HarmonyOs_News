package com.zcxy.mapper;

import com.zcxy.pojo.Comment;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import java.util.List;
import java.util.UUID;

public interface CommentMapper {
    List<Comment> selectByNewId(int new_id);
    List<Comment>selectByAllId(int new_id,UUID uid);
    List<Comment>selectByUid(UUID uid);
    List<Comment>selectById(int id);
    int selectCountByNewId(int new_id);
    int addComment(Comment comment);
    int deleteByNewIds(@Param("ids") int[] ids);
    @Select("SELECT * FROM comment")
    List<Comment> selectAll();
    List<Comment> selectList(@Param("new_id")int new_id,@Param("start")int start,@Param("limit")int limit);
}
