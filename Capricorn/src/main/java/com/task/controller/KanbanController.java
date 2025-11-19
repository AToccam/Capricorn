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

    // 新增：处理卡片移动的 AJAX 请求
    @PostMapping("/moveCard")
    @ResponseBody // 关键！表示直接返回数据，而不是跳转页面
    public String moveCard(@RequestParam Integer cardId,
                           @RequestParam Integer newListId) {

        System.out.println("收到拖拽请求：卡片 " + cardId + " -> 列表 " + newListId);

        boolean success = kanbanService.moveCard(cardId, newListId);

        return success ? "success" : "fail";
    }
    @RequestMapping(value = "/board/addCard", method = RequestMethod.POST)
    @ResponseBody // 重要：表示返回的是数据而不是页面跳转
    public Map<String, Object> addCard(Integer listId, String cardContent) {
        Map<String, Object> result = new HashMap<>();

        try {
            Card card = new Card();
            card.setListId(listId);
            card.setCardContent(cardContent);

            // 调用 Service 保存 (假设 Service 调用的就是上面写的 Mapper)
            kanbanService.addCard(card);

            // 返回成功状态和新生成的ID
            result.put("status", "success");
            result.put("newCardId", card.getCardId());
        } catch (Exception e) {
            result.put("status", "error");
        }

        return result;
    }
}