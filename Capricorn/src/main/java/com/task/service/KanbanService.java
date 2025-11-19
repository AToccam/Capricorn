package com.task.service;

import com.task.entity.Card;
import com.task.entity.KanbanList;
import com.task.entity.Project;
import java.util.List;

public interface KanbanService {
    List<Project> getUserProjects(Integer userId);
    List<KanbanList> getBoardData(Integer projectId);
    boolean deleteCard(Integer cardId);
    boolean moveCard(Integer cardId, Integer newListId);
    void addCard(Card card);
    void addProject(Project project);
    void renameProject(Integer projectId, String newName);
    void deleteProject(Integer projectId);
    Project getProjectFullData(Integer projectId);

    void addList(KanbanList list);
    void renameList(Integer listId, String newName);
    void deleteList(Integer listId);
}