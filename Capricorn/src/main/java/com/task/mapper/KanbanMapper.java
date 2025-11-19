package com.task.mapper;

import com.task.entity.KanbanList;
import com.task.entity.Project;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface KanbanMapper {
    // 1. 查找某个用户的所有项目
    List<Project> findProjectsByUserId(Integer userId);

    // 2. 核心：查找某个项目下的所有列表（并包含列表里的卡片）
    List<KanbanList> findListsByProjectId(Integer projectId);

    // 3. 移动卡片时需要的操作（暂时留空，后面做拖拽再加）
}