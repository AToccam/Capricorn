package com.task.entity;

public class User {
    // 对应 t_user 表的 user_id
    private Integer userId;
    // 对应 t_user 表的 username
    private String username;
    // 对应 t_user 表的 password
    private String password;

    // 必须提供无参构造器
    public User() {
    }

    // 为了方便，提供一个带参构造器
    public User(String username, String password) {
        this.username = username;
        this.password = password;
    }

    // --- Getter 和 Setter 方法 (必须有，否则MyBatis无法赋值) ---

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Override
    public String toString() {
        return "User{userId=" + userId + ", username='" + username + "'}";
    }
}