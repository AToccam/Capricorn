package com.task.controller;

import com.task.entity.KanbanList;
import com.task.entity.Project;
import com.task.entity.User;
import com.task.service.KanbanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class KanbanController {

    @Autowired
    private KanbanService kanbanService;

    // 1. 显示项目列表页 (覆盖之前的临时 main 页)
    @GetMapping("/main")
    public String showProjectList(HttpSession session, Model model) {
        // 从Session获取当前登录用户
        User user = (User) session.getAttribute("currentUser");
        if (user == null) return "redirect:/login";

        // 查出该用户的所有项目
        List<Project> projects = kanbanService.getUserProjects(user.getUserId());
        model.addAttribute("projects", projects);

        return "main";
    }

    // 2. 显示看板详情页 (核心页面)
    @GetMapping("/board")
    public String showBoard(@RequestParam Integer projectId,
                            @RequestParam String projectName,
                            Model model, HttpSession session) {
        if (session.getAttribute("currentUser") == null) return "redirect:/login";

        // 查出这个项目下的所有列表和卡片
        List<KanbanList> kanbanLists = kanbanService.getBoardData(projectId);

        // 放入 Model 传给 JSP
        model.addAttribute("kanbanLists", kanbanLists);
        model.addAttribute("currentProjectName", projectName);
        model.addAttribute("currentProjectId", projectId);

        return "board";
    }
}