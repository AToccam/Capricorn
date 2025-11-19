package com.task.entity;

import java.util.List;

public class Project {
    private Integer projectId;
    private String projectName;
    private Integer ownerUserId;
    private List<KanbanList> lists;
    public Integer getProjectId() { return projectId; }
    public void setProjectId(Integer projectId) { this.projectId = projectId; }
    public String getProjectName() { return projectName; }
    public void setProjectName(String projectName) { this.projectName = projectName; }
    //public Integer getOwnerUserId() { return ownerUserId; }
    public void setOwnerUserId(Integer ownerUserId) { this.ownerUserId = ownerUserId; }

    /*public List<KanbanList> getLists() {
        return lists;
    }*/

    public void setLists(List<KanbanList> lists) {
        this.lists = lists;
    }
}