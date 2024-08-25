package com.zcxy.pojo;

import java.util.Objects;
import java.util.UUID;

public class User {
    //region 变量成员
    private UUID uid;

    private String account;

    private String password;

    private String email;

    private String phone;

    private String avatar;

    private Role role;

    private Sex sex;
    private String head;
    //endregion

    //region 构造函数
    public User() {
        this.uid = UUID.randomUUID();
        this.head = "tou.jpg";
    }
    public User(String account, String password, String phone, String email, String avatar, Role role, Sex sex) {
        this.uid = UUID.randomUUID();
        this.account = account;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.avatar = avatar;
        this.role = role;
        this.sex = sex;
        this.head = "tou.jpg";
    }
    public User(String account, String password, String phone, String email, String avatar, Role role, Sex sex, String head) {
        this.uid = UUID.randomUUID();
        this.account = account;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.avatar = avatar;
        this.role = role;
        this.sex = sex;
        this.head = head;
    }

    public User(User user){
        this.uid = user.uid;
        this.account = user.account;
        this.password = user.password;
        this.email = user.email;
        this.phone = user.phone;
        this.avatar = user.avatar;
        this.role = user.role;
        this.sex = user.sex;
        this.head= user.head;
    }
    //endregion

    //region get和set函数
    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public Sex getSex() {
        return sex;
    }

    public void setSex(Sex sex) {
        this.sex = sex;
    }

    public UUID getUid() {
        return uid;
    }

    public String getHead() {
        return head;
    }

    public void setHead(String head) {
        this.head = head;
    }
    //endregion

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User user = (User) o;
        return Objects.equals(uid, user.uid) && Objects.equals(account, user.account) && Objects.equals(password, user.password) && Objects.equals(email, user.email) && Objects.equals(phone, user.phone) && Objects.equals(avatar, user.avatar) && role == user.role && sex == user.sex && Objects.equals(head, user.head);
    }

    @Override
    public int hashCode() {
        return Objects.hash(uid, account, password, email, phone, avatar, role, sex, head);
    }

    @Override
    public String toString() {
        return "User{" +
                "uid=" + uid +
                ", account='" + account + '\'' +
                ", password='" + password + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", avatar='" + avatar + '\'' +
                ", role=" + role +
                ", sex=" + sex +
                ", head='" + head + '\'' +
                '}';
    }
}
