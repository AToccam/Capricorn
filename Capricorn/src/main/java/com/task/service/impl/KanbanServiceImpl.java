package com.task.service.impl;

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
    public List<Project> getUserProjects(Integer userId) {
        return kanbanMapper.findProjectsByUserId(userId);
    }

    @Override
    public List<KanbanList> getBoardData(Integer projectId) {
        // 这里调用了我们刚才写的那个最复杂的级联查询
        return kanbanMapper.findListsByProjectId(projectId);
    }
}