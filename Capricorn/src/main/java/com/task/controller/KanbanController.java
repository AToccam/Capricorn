package com.task.controller;

import com.task.entity.Card;
import com.task.entity.KanbanList;
import com.task.entity.Project;
import com.task.entity.User;
import com.task.service.KanbanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class KanbanController {
    @GetMapping("/")
    public String index() {
        // 访问根路径 http://localhost:8081/kanban/ 时
        // Spring 会去 /WEB-INF/views/ 找 index.jsp
        return "index";
    }

    @Autowired
    private KanbanService kanbanService;

    // 1. 显示项目列表页
    @GetMapping("/main")
    public String showProjectList(HttpSession session, Model model) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) return "redirect:/login";

        List<Project> projects = kanbanService.getUserProjects(user.getUserId());
        model.addAttribute("projects", projects);

        return "main";
    }

    // 2. 显示看板详情页
    @GetMapping("/board")
    public String showBoard(@RequestParam Integer projectId,
                            @RequestParam String projectName,
                            Model model, HttpSession session) {
        if (session.getAttribute("currentUser") == null) return "redirect:/login";

        // 查出这个项目下的所有列表和卡片
        // 注意：为了配合 board.jsp 的逻辑，这里最好是用 Project 里的 lists
        // 如果你的 Service 实现里 getProjectFullData 是手动组装的，用 getProjectFullData 更好
        // 这里沿用你代码里的 getBoardData
        List<KanbanList> kanbanLists = kanbanService.getBoardData(projectId);

        model.addAttribute("kanbanLists", kanbanLists);
        model.addAttribute("currentProjectName", projectName);
        model.addAttribute("currentProjectId", projectId);

        return "board";
    }

    // 新增：处理卡片移动的 AJAX 请求
    @PostMapping("/moveCard")
    @ResponseBody
    public String moveCard(@RequestParam Integer cardId,
                           @RequestParam Integer newListId) {
        System.out.println("收到拖拽请求：卡片 " + cardId + " -> 列表 " + newListId);
        boolean success = kanbanService.moveCard(cardId, newListId);
        return success ? "success" : "fail";
    }

    @RequestMapping(value = "/board/addCard", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> addCard(Integer listId, String cardContent) {
        Map<String, Object> result = new HashMap<>();
        try {
            Card card = new Card();
            card.setListId(listId);
            card.setCardContent(cardContent);
            kanbanService.addCard(card);
            result.put("status", "success");
            result.put("newCardId", card.getCardId());
        } catch (Exception e) {
            result.put("status", "error");
        }
        return result;
    }

    // 1. 添加项目
    @PostMapping("/addProject")
    @ResponseBody
    public Map<String, Object> addProject(String projectName, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            result.put("status", "fail");
            return result;
        }

        Project project = new Project();
        project.setProjectName(projectName);
        project.setOwnerUserId(user.getUserId());
        kanbanService.addProject(project);

        result.put("status", "success");
        result.put("newId", project.getProjectId());
        return result;
    }

    // 2. 重命名项目
    @PostMapping("/renameProject")
    @ResponseBody
    public String renameProject(Integer projectId, String projectName) {
        kanbanService.renameProject(projectId, projectName);
        return "success";
    }

    // 3. 删除项目
    @PostMapping("/deleteProject")
    @ResponseBody
    public String deleteProject(Integer projectId) {
        kanbanService.deleteProject(projectId);
        return "success";
    }

    // 1. 添加列表
    @RequestMapping(value = "/board/addList", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> addList(Integer projectId, String listName) {
        Map<String, Object> result = new HashMap<>();
        try {
            KanbanList list = new KanbanList();
            list.setProjectId(projectId);
            list.setListName(listName);
            kanbanService.addList(list);
            result.put("status", "success");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("status", "error");
        }
        return result;
    }

    // 2. 删除列表
    @RequestMapping(value = "/board/deleteList", method = RequestMethod.POST)
    @ResponseBody
    public String deleteList(Integer listId) {
        try {
            kanbanService.deleteList(listId);
            return "success";
        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }

    // =======================================================
    // 【下面是刚才缺失的方法，必须加上才能解决 404】
    // =======================================================

    // 3. 删除卡片 (解决拖拽到垃圾桶 404 的问题)
    @RequestMapping(value = "/board/deleteCard", method = RequestMethod.POST)
    @ResponseBody
    public String deleteCard(@RequestParam Integer cardId) {
        try {
            kanbanService.deleteCard(cardId);
            return "success";
        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }

    // 4. 重命名列表 (点击列表标题修改)
    @PostMapping("/board/renameList")
    @ResponseBody
    public String renameList(Integer listId, String listName) {
        kanbanService.renameList(listId, listName);
        return "success";
    }
}