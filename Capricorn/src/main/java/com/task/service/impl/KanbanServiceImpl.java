package com.task.service.impl;

import com.task.entity.Card;
import com.task.entity.KanbanList;
import com.task.entity.Project;
import com.task.mapper.KanbanMapper;
import com.task.service.KanbanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class KanbanServiceImpl implements KanbanService {

    @Autowired
    private KanbanMapper kanbanMapper;

    @Override
    public Project getProjectFullData(Integer projectId) {
        Project project = new Project();
        project.setProjectId(projectId);

        List<KanbanList> lists = kanbanMapper.findListsByProjectId(projectId);
        project.setLists(lists);

        return project;
    }

    @Override
    public List<Project> getUserProjects(Integer userId) {
        return kanbanMapper.findProjectsByUserId(userId);
    }

    @Override
    public List<KanbanList> getBoardData(Integer projectId) {
        return kanbanMapper.findListsByProjectId(projectId);
    }

    @Override
    public void addCard(Card card) {
        kanbanMapper.addCard(card);
    }

    @Override
    public boolean moveCard(Integer cardId, Integer newListId) {
        return kanbanMapper.updateCardList(cardId, newListId) > 0;
    }

    @Override
    public boolean deleteCard(Integer cardId) {
        try {
            kanbanMapper.deleteCard(cardId);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public void addList(KanbanList list) {
        kanbanMapper.addList(list);
    }

    @Override
    public void renameList(Integer listId, String newName) {
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

    private void createListInternal(Integer projectId, String name, int order) {
        KanbanList list = new KanbanList();
        list.setProjectId(projectId);
        list.setListName(name);
        list.setOrderIndex(order);
        kanbanMapper.addList(list);
    }
}