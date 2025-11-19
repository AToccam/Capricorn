package com.task.entity;

public class Card {
    private Integer cardId;
    private String cardContent;
    private Integer listId;
    private Integer orderIndex;

    // Getter/Setter
    public Integer getCardId() { return cardId; }
    public void setCardId(Integer cardId) { this.cardId = cardId; }
    public String getCardContent() { return cardContent; }
    public void setCardContent(String cardContent) { this.cardContent = cardContent; }
    public Integer getListId() { return listId; }
    public void setListId(Integer listId) { this.listId = listId; }
    public Integer getOrderIndex() { return orderIndex; }
    public void setOrderIndex(Integer orderIndex) { this.orderIndex = orderIndex; }
}