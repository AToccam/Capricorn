package com.task.entity;

import java.util.List;

public class KanbanList {
    private Integer listId;
    private String listName;
    private Integer projectId;
    private Integer orderIndex;

    private List<Card> cards;

    // Getter/Setter
    public Integer getListId() { return listId; }
    //public void setListId(Integer listId) { this.listId = listId; }
    public String getListName() { return listName; }
    public void setListName(String listName) { this.listName = listName; }
    //public Integer getProjectId() { return projectId; }
    public void setProjectId(Integer projectId) { this.projectId = projectId; }
    //public Integer getOrderIndex() { return orderIndex; }
    public void setOrderIndex(Integer orderIndex) { this.orderIndex = orderIndex; }
    public List<Card> getCards() { return cards; }
    //public void setCards(List<Card> cards) { this.cards = cards; }
}