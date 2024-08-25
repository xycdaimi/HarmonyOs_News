package com.zcxy.pojo;

import java.util.Objects;
import java.util.UUID;

/**
 * @author 谢宇宸
 * #Date: 2024/6/5 9:17
 * @version 1.0
 */
public class Comment {
    private int id;
    private int new_id;
    private UUID uid;
    private String context;
    private String create_time;
    private String niChen;

    public Comment(int id, int new_id, UUID uid, String context, String create_time,String niChen) {
        this.id = id;
        this.new_id = new_id;
        this.uid = uid;
        this.context = context;
        this.create_time = create_time;
        this.niChen=niChen;
    }

    public Comment() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getNew_id() {
        return new_id;
    }

    public void setNew_id(int new_id) {
        this.new_id = new_id;
    }

    public UUID getUid() {
        return uid;
    }

    public void setUid(UUID uid) {
        this.uid = uid;
    }

    public String getContext() {
        return context;
    }

    public void setContext(String context) {
        this.context = context;
    }

    public String getCreate_time() {
        return create_time;
    }

    public void setCreate_time(String create_time) {
        this.create_time = create_time;
    }

    public String getNiChen() {
        return niChen;
    }

    public void setNiChen(String niChen) {
        this.niChen = niChen;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Comment comment = (Comment) o;
        return id == comment.id && new_id == comment.new_id && Objects.equals(uid, comment.uid) && Objects.equals(context, comment.context) && Objects.equals(create_time, comment.create_time) && Objects.equals(niChen, comment.niChen);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, new_id, uid, context, create_time, niChen);
    }

    @Override
    public String toString() {
        return "Comment{" +
                "id=" + id +
                ", new_id=" + new_id +
                ", uid=" + uid +
                ", context='" + context + '\'' +
                ", create_time='" + create_time + '\'' +
                ", niChen='" + niChen + '\'' +
                '}';
    }
}
