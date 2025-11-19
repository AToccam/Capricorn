package com.task.mapper;

import com.task.entity.Card;
import com.task.entity.KanbanList;
import com.task.entity.Project;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface KanbanMapper {
    //查找某个用户的所有项目
    List<Project> findProjectsByUserId(Integer userId);
    // 核心：查找某个项目下的所有列表（并包含列表里的卡片）
    List<KanbanList> findListsByProjectId(Integer projectId);
    //移动卡片时需要的操作
    int updateCardList(@Param("cardId") Integer cardId, @Param("listId") Integer listId);

    int addCard(Card card);
    int addProject(Project project);
    // 重命名项目
    int updateProjectName(@Param("projectId") Integer projectId, @Param("projectName") String projectName);
    // 删除项目本身
    int deleteProject(Integer projectId);
    // 删除项目下的所有列表 (用于级联删除)
    int deleteListsByProjectId(Integer projectId);
    // 删除项目下的所有卡片 (用于级联删除)
    int deleteCardsByProjectId(Integer projectId);

    int moveAllCards(@Param("sourceListId") Integer sourceListId, @Param("targetListId") Integer targetListId);
    Integer getProjectIdByListId(Integer listId);
    Integer getListIdByName(@Param("projectId") Integer projectId, @Param("listName") String listName);

    // 解决 kanbanMapper.addList(list) 报错
    int addList(KanbanList list);

    // 解决 kanbanMapper.deleteCardsByListId(listId) 报错
    int deleteCardsByListId(@Param("listId") Integer listId);

    // 解决 kanbanMapper.deleteList(listId) 报错
    int deleteList(@Param("listId") Integer listId);
    // (顺手补一个重命名列表，防止以后报错，不想要可以删掉)
    int updateListName(@Param("listId") Integer listId, @Param("listName") String listName);

    // 添加这一行
    int deleteCard(Integer cardId);
}