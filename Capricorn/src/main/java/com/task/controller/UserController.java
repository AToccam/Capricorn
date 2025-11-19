package com.task.controller;

import com.task.entity.User;
import com.task.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
public class UserController {

    @Autowired
    private UserService userService;

    // 访问登录页面 (GET)
    @GetMapping("/login")
    public String showLoginPage() {
        return "login";
    }

    // 访问注册页面 (GET)
    @GetMapping("/register")
    public String showRegisterPage() {
        return "register";
    }

    // 处理登录提交 (POST)
    @PostMapping("/login")
    public String doLogin(@RequestParam String username,
                          @RequestParam String password,
                          HttpSession session,
                          Model model) {

        User user = userService.login(username, password);

        if (user != null) {
            // 把用户信息存入 Session
            session.setAttribute("currentUser", user);
            return "redirect:/main";
        } else {
            // 登录失败
            model.addAttribute("errorMsg", "用户名或密码错误！");
            return "login";
        }
    }

    // 处理注册提交
    @PostMapping("/register")
    public String doRegister(User user, Model model) {
        // SpringMVC 会自动把表单数据封装到 User 对象中
        boolean success = userService.register(user);

        if (success) {
            // 注册成功
            model.addAttribute("msg", "注册成功，请登录！");
            return "login";
        } else {
            // 用户名重复
            model.addAttribute("errorMsg", "用户名已存在，请换一个！");
            return "register";
        }
    }

    //退出登录
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); // 销毁 Session
        return "redirect:/login";
    }
}