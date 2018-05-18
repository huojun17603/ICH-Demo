package com.ich.demo.pojo;

public class PWordshield {
    private String id;

    private String keyword;

    private String repword;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword == null ? null : keyword.trim();
    }

    public String getRepword() {
        return repword;
    }

    public void setRepword(String repword) {
        this.repword = repword == null ? null : repword.trim();
    }
}