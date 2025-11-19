package com.task.mapper;

import com.task.entity.User;
import org.apache.ibatis.annotations.Param;

public interface UserMapper {

    /**
     * 根据用户名查找用户（用于登录检查）
     * @param username 用户名
     * @return 找到的User对象，没找到返回null
     */
    User findByUsername(@Param("username") String username);

    /**
     * 插入新用户（用于注册）
     * @param user 用户对象
     * @return 影响的行数（1表示成功）
     */
    int insertUser(User user);
}