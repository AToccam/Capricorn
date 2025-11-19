package com.task.service.impl;

import com.task.entity.Card;
import com.task.entity.KanbanList;
import com.task.entity.Project;
import com.task.mapper.KanbanMapper;
import com.task.service.KanbanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

// 1. 这里的 abstract 去掉了，因为下面我们把所有活都干完了
@Service
public class KanbanServiceImpl implements KanbanService {

    @Autowired
    private KanbanMapper kanbanMapper;

    // ==========================================
    // 1. 必须实现的方法：getProjectFullData
    // ==========================================
    @Override
    public Project getProjectFullData(Integer projectId) {
        // 【关键修正】不调 getProjectCanvas，而是手动组装
        // 因为你的 Mapper 里只有 findListsByProjectId
        Project project = new Project();
        project.setProjectId(projectId);

        // 调用原版 Mapper 方法查出列表和卡片
        List<KanbanList> lists = kanbanMapper.findListsByProjectId(projectId);
        project.setLists(lists);

        return project;
    }

    // ==========================================
    // 2. 原有查询方法
    // ==========================================
    @Override
    public List<Project> getUserProjects(Integer userId) {
        return kanbanMapper.findProjectsByUserId(userId);
    }

    @Override
    public List<KanbanList> getBoardData(Integer projectId) {
        return kanbanMapper.findListsByProjectId(projectId);
    }

    // ==========================================
    // 3. 卡片操作
    // ==========================================
    @Override
    public void addCard(Card card) {
        kanbanMapper.addCard(card);
    }

    @Override
    public boolean moveCard(Integer cardId, Integer newListId) {
        return kanbanMapper.updateCardList(cardId, newListId) > 0;
    }

    // 【必须实现的方法】删除卡片
    @Override
    public boolean deleteCard(Integer cardId) {
        // 假设 Mapper.deleteCard 没有返回值(void)或者返回 int
        // 这里简单调用即可，如果你的 XML 没写返回值，就不用 return > 0
        try {
            kanbanMapper.deleteCard(cardId); // 如果 Mapper 返回 void，这样写
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    // ==========================================
    // 4. 列表操作 (这是你之前加的新功能)
    // ==========================================
    @Override
    public void addList(KanbanList list) {
        kanbanMapper.addList(list);
    }

    @Override
    public void renameList(Integer listId, String newName) {
        // 对应 Mapper 里的 updateListName
        // 如果 Mapper 没这个方法，可以在 Mapper 补一个，或者这里暂时留空不报错
        kanbanMapper.updateListName(listId, newName);
    }

    @Override
    public void deleteList(Integer listId) {
        Integer projectId = kanbanMapper.getProjectIdByListId(listId);
        if (projectId == null) return;

        Integer uncategorizedId = kanbanMapper.getListIdByName(projectId, "未分类");

        if (uncategorizedId != null && !listId.equals(uncategorizedId)) {
            kanbanMapper.moveAllCards(listId, uncategorizedId);
        } else if (listId.equals(uncategorizedId)) {
            kanbanMapper.deleteCardsByListId(listId);
        }

        kanbanMapper.deleteList(listId);
    }

    // ==========================================
    // 5. 项目操作
    // ==========================================
    @Override
    public void addProject(Project project) {
        kanbanMapper.addProject(project);
        Integer pid = project.getProjectId();

        createListInternal(pid, "待办事项", 1);
        createListInternal(pid, "进行中", 2);
        createListInternal(pid, "已完成", 3);
        createListInternal(pid, "未分类", 999);
    }

    @Override
    public void renameProject(Integer projectId, String newName) {
        kanbanMapper.updateProjectName(projectId, newName);
    }

    @Override
    public void deleteProject(Integer projectId) {
        kanbanMapper.deleteCardsByProjectId(projectId);
        kanbanMapper.deleteListsByProjectId(projectId);
        kanbanMapper.deleteProject(projectId);
    }

    // --- 辅助方法 ---
    private void createListInternal(Integer projectId, String name, int order) {
        KanbanList list = new KanbanList();
        list.setProjectId(projectId);
        list.setListName(name);
        list.setOrderIndex(order);
        kanbanMapper.addList(list);
    }
}