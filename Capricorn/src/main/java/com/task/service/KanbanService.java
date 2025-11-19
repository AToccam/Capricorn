package com.task.service;

import com.task.entity.KanbanList;
import com.task.entity.Project;
import java.util.List;

public interface KanbanService {
    List<Project> getUserProjects(Integer userId);
    List<KanbanList> getBoardData(Integer projectId);
    boolean moveCard(Integer cardId, Integer newListId);
}