package com.task.controller;

import com.task.entity.User;
import com.task.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
public class UserController {

    @Autowired
    private UserService userService;

    // 1. 访问登录页面的请求 (GET)
    @GetMapping("/login")
    public String showLoginPage() {
        // 返回 "login" 字符串，SpringMVC 会自动去 /WEB-INF/views/ 下找 login.jsp
        return "login";
    }

    // 2. 访问注册页面的请求 (GET)
    @GetMapping("/register")
    public String showRegisterPage() {
        return "register";
    }

    // 3. 处理登录提交 (POST)
    @PostMapping("/login")
    public String doLogin(@RequestParam String username,
                          @RequestParam String password,
                          HttpSession session,
                          Model model) {

        User user = userService.login(username, password);

        if (user != null) {
            // 登录成功！
            // 把用户信息存入 Session，以此标记用户已登录
            session.setAttribute("currentUser", user);

            // 重定向到主页 (防止用户刷新页面重复提交登录)
            return "redirect:/main";
        } else {
            // 登录失败
            model.addAttribute("errorMsg", "用户名或密码错误！");
            return "login"; // 回到登录页并显示错误
        }
    }

    // 4. 处理注册提交 (POST)
    @PostMapping("/register")
    public String doRegister(User user, Model model) {
        // SpringMVC 会自动把表单数据封装到 User 对象中
        boolean success = userService.register(user);

        if (success) {
            // 注册成功，跳转到登录页，并提示
            model.addAttribute("msg", "注册成功，请登录！");
            return "login";
        } else {
            // 注册失败（通常是用户名已存在）
            model.addAttribute("errorMsg", "用户名已存在，请换一个！");
            return "register";
        }
    }

    // 5. 临时的“主页”入口 (为了测试登录成功)
    //@GetMapping("/main")
    public String showMainPage(HttpSession session) {
        // 检查用户是否登录
        if (session.getAttribute("currentUser") == null) {
            return "redirect:/login"; // 没登录就踢回登录页
        }
        return "main"; // 登录了就显示 main.jsp
    }

    // 6. 退出登录
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); // 销毁 Session
        return "redirect:/login";
    }
}