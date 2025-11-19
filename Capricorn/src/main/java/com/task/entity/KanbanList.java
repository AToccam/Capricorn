package com.task.entity;

import java.util.List; // 注意这里引入的是 java.util.List

public class KanbanList {
    private Integer listId;
    private String listName;
    private Integer projectId;
    private Integer orderIndex;

    // 🌟 重点：一个列表下面包含多个卡片 (一对多)
    // 这就是 MyBatis 的强大之处，可以直接把关联的卡片查进去
    private List<Card> cards;

    // Getter/Setter
    public Integer getListId() { return listId; }
    public void setListId(Integer listId) { this.listId = listId; }
    public String getListName() { return listName; }
    public void setListName(String listName) { this.listName = listName; }
    public Integer getProjectId() { return projectId; }
    public void setProjectId(Integer projectId) { this.projectId = projectId; }
    public Integer getOrderIndex() { return orderIndex; }
    public void setOrderIndex(Integer orderIndex) { this.orderIndex = orderIndex; }
    public List<Card> getCards() { return cards; }
    public void setCards(List<Card> cards) { this.cards = cards; }
}