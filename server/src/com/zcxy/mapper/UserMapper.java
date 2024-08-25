package com.zcxy.mapper;

import com.zcxy.pojo.User;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.UUID;

public interface UserMapper {
    int addUser(User user);
    int updateUser(User user);

    int deleteByUids(@Param("ids") UUID[] ids);
    int deleteByAccounts(@Param("ids") String[] ids);
    int deleteByPhones(@Param("ids") String[] ids);

    User selectByUid(UUID uid);
    List<User> selectByAccount(String account);
    List<User> selectByPhone(String phone);
    @Select("SELECT COUNT(*) FROM User")
    int selectCount();
    @Select("SELECT * FROM User")
    List<User> selectAll();//使用注解开发
}
