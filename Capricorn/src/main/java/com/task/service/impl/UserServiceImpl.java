package com.task.service.impl;

import com.task.entity.User;
import com.task.mapper.UserMapper;
import com.task.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service // 告诉Spring：我是业务类，请管理我
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper; // 注入 Mapper

    @Override
    public User login(String username, String password) {
        // 1. 根据用户名查询用户
        User user = userMapper.findByUsername(username);

        // 2. 判断用户是否存在
        if (user != null) {
            // 3. 判断密码是否匹配 (这里暂时用明文比较，实际项目建议加密)
            if (user.getPassword().equals(password)) {
                return user; // 登录成功
            }
        }
        return null; // 用户不存在或密码错误
    }

    @Override
    @Transactional // 开启事务：如果插入失败，会自动回滚
    public boolean register(User user) {
        // 1. 先检查用户名是否已存在
        User existUser = userMapper.findByUsername(user.getUsername());
        if (existUser != null) {
            return false; // 用户名已被占用
        }

        // 2. 插入新用户
        int rows = userMapper.insertUser(user);
        return rows > 0;
    }
}