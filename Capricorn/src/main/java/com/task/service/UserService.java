package com.task.service;

import com.task.entity.User;

public interface UserService {

    /**
     * 用户登录
     * @param username 用户名
     * @param password 密码
     * @return 登录成功的User对象，失败返回null
     */
    User login(String username, String password);

    /**
     * 用户注册
     * @param user 用户信息
     * @return 是否注册成功（如果用户名已存在则失败）
     */
    boolean register(User user);
}