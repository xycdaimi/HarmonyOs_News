package com.zcxy.pojo;

import java.util.Objects;
import java.util.UUID;

/**
 * @author 谢宇宸
 * #Date: 2024/5/8 9:48
 * @version 1.0
 */
public class News {
    //region 变量成员
    private int id;

    private String title;

    private String content;

    private UUID author;

    private String date_time;

    private String image;

    private String new_type;

    private int comments;
    private String niChen;
    //endregion

    //region 构造函数
    public News() {
    }

    public News(String title, String content, UUID author, String date_time, String image, String new_type, int comments, String niChen) {
        this.title = title;
        this.content = content;
        this.author = author;
        this.date_time = date_time;
        this.image = image;
        this.new_type = new_type;
        this.comments = comments;
        this.niChen = niChen;
    }

    public News(String title, String content, UUID author, String date_time, String image, String new_type, String niChen) {
        this.title = title;
        this.content = content;
        this.author = author;
        this.date_time = date_time;
        this.image = image;
        this.new_type = new_type;
        this.niChen = niChen;
    }

    public News(int id, String title, String content, UUID author, String date_time, String image, String new_type, int comments, String niChen) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.author = author;
        this.date_time = date_time;
        this.image = image;
        this.new_type = new_type;
        this.comments = comments;
        this.niChen = niChen;
    }

    public News(int id, String title, String content, UUID author, String date_time, String image, String new_type, String niChen) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.author = author;
        this.date_time = date_time;
        this.image = image;
        this.new_type = new_type;
        this.niChen = niChen;
        this.comments=0;
    }
//endregion

    //region get和set方法

    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public UUID getAuthor() {
        return author;
    }

    public void setAuthor(UUID author) {
        this.author = author;
    }

    public String getDate_time() {
        return date_time;
    }

    public void setDate_time(String date_time) {
        this.date_time = date_time;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getNew_type() {
        return new_type;
    }

    public void setNew_type(String new_type) {
        this.new_type = new_type;
    }

    public int getComments() {
        return comments;
    }

    public void setComments(int comments) {
        this.comments = comments;
    }

    public String getNiChen() {
        return niChen;
    }

    public void setNiChen(String niChen) {
        this.niChen = niChen;
    }
//endregion


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        News news = (News) o;
        return id == news.id && comments == news.comments && Objects.equals(title, news.title) && Objects.equals(content, news.content) && Objects.equals(author, news.author) && Objects.equals(date_time, news.date_time) && Objects.equals(image, news.image) && Objects.equals(new_type, news.new_type) && Objects.equals(niChen, news.niChen);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, title, content, author, date_time, image, new_type, comments, niChen);
    }

    @Override
    public String toString() {
        return "News{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", content='" + content + '\'' +
                ", author=" + author +
                ", date_time='" + date_time + '\'' +
                ", image='" + image + '\'' +
                ", new_type='" + new_type + '\'' +
                ", comments=" + comments +
                ", niChen='" + niChen + '\'' +
                '}';
    }
}
