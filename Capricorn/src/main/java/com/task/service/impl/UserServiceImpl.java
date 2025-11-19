package com.task.service.impl;

import com.task.entity.User;
import com.task.mapper.UserMapper;
import com.task.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper; // 注入 Mapper

    @Override
    public User login(String username, String password) {
        User user = userMapper.findByUsername(username);

        if (user != null) {
            if (user.getPassword().equals(password)) {
                return user; // 登录成功
            }
        }
        return null; // 用户不存在或密码错误
    }

    @Override
    @Transactional
    public boolean register(User user) {
        // 1. 先检查用户名是否已存在
        User existUser = userMapper.findByUsername(user.getUsername());
        if (existUser != null) {
            return false; // 用户名已被占用
        }

        int rows = userMapper.insertUser(user);
        return rows > 0;
    }
}