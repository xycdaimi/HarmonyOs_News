import com.zcxy.pojo.News;
import com.zcxy.pojo.Role;
import com.zcxy.pojo.Sex;
import com.zcxy.pojo.User;
import org.junit.Test;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

/**
 * @author 罗航
 * #Date 2024/6/10 17:23
 * @version 1.0
 */
public class test {
    //测试新闻插入
    @Test
    public void adder()throws IOException {
        List<User> users1 = ServerSql.selectUserByUsername("xhs");
        System.out.println(users1.get(0).getAccount());
        News a = new News(1,"欧央行鹰派管委：未来政策将取决于数据，美联储是不可忽视的因素","    财联社6月9日讯（编辑 夏军雄）欧洲央行管委会成员、奥地利央行行长罗伯特·霍尔兹曼表示，尽管欧洲央行\n" +
                "本周宣布了降息，但现在就判断该央行未来将继续降息还为时过早。\n" +
                "    欧洲央行周四宣布降息25个基点，成为继加拿大央行之后，又一家放松货币政策的央行。欧洲央行三大关键利率主要再融资利率、边际借贷利率和存款机制利率分别下调至4.25%、4.50%和3.75%。\n" +
                "    由于欧元区最近几周的通胀数据令人失望，欧洲央行没有承诺进一步降息。根据欧盟统计局此前发布的初步统计数据，5月欧元区CPI同比增速从4月的2.4%反弹至2.6%。\n" +
                "    事实上，即使是本周的降息行动，欧洲央行内部也没有完全达成一致。霍尔兹曼是欧洲央行管理委员会26名成员中唯一反对降息的成员，他通常被视为欧洲央行管委会中鹰派阵营的代表人物。\n" +
                "    霍尔兹曼接受了奥地利电台的采访，采访于当地时间周六播出。他强调，数据驱动型决策应该以数据为指导，以此解释自己为何反对降息。\n" +
                "    当被问及本次降息是否代表者利率将进一步下降时，霍尔兹曼持谨慎态度。他表示，未来的政策决定将取决于数据。\n" +
                "    霍尔兹曼在采访中表示，需要考虑的因素之一是欧洲央行和美联储之间的利差。他警告称，如果美联储没有像美国决策者年初暗示的那样降息三次，那将影响美元兑欧元的汇率，从而可能加剧欧元区的通胀。\n" +
                "    尽管包括欧洲央行行长拉加德在内的政策制定者多次强调，欧洲央行将依据经济数据来行动，而不是美联储的动向，但霍尔兹曼曾多次公开承认，欧洲决策者必须考虑到美联储和美国的通胀形势。\n" +
                "    霍尔兹曼说，欧洲央行只有在通胀率降至2%的目标水平后，才能宣布取得胜利。他补充道：“我们希望能在2026年到达那里，这是模型预测的结果，而这一切都是基于没有进一步冲击的假设。”",
                users1.get(0).getUid(),
                "2024-06-09 12:30:00",
                "3.jpg",
                "经济",
                "新华社");
        int i = ServerSql.insertNews(a);
        if (i==1){
            System.out.println("ok");
        }else {
            System.out.println("no");
        }
    }
    //测试搜素框功能
    @Test
    public void selectt()throws IOException{
        List<News> a = ServerSql.selectNewsByTitle("|",0,2);
        System.out.println(a.get(0).getTitle());
    }
    //测试用户注册
    @Test
    public void register()throws IOException{

        Role a=Role.USER;
        Sex b=Sex.MALE;

        int i = ServerSql.insertUser("xxx","123144","17873952628","3041176185@qq.com","kkx",a,b);
        if (i==1){

            System.out.println("ok");

        }else {

            System.out.println("no");
        }
    }
    //测试编辑资料，更改用户邮箱
    @Test
    public void edit()throws IOException{
        List<User> h = ServerSql.selectUserByUsername("xxx");
        User a=h.get(0);
        a.setEmail("123144@qq.com");
        int i = ServerSql.updateUser(a);
        if (i==1){
            System.out.println("ok");
        }else {
            System.out.println("no");
        }
    }
    //测试编辑资料，更改用户昵称
    @Test
    public void edit1()throws IOException{
        List<User> h = ServerSql.selectUserByUsername("xxx");
        User a=h.get(0);
        a.setAvatar("摸鱼");
        int i = ServerSql.updateUser(a);
        if (i==1){
            System.out.println("ok");
        }else {
            System.out.println("no");
        }
    }
    //测试编辑资料，更改用户密码
    @Test
    public void edit2()throws IOException{
        List<User> h = ServerSql.selectUserByUsername("xxx");
        User a=h.get(0);
        a.setPassword("123144");
        int i = ServerSql.updateUser(a);
        if (i==1){
            System.out.println("ok");
        }else {
            System.out.println("no");
        }
    }
    //测试编辑资料，更改用户性别
    @Test
    public void edit3()throws IOException{
        List<User> h = ServerSql.selectUserByUsername("xxx");
        User a=h.get(0);
        a.setSex(Sex.FEMALE);
        int i = ServerSql.updateUser(a);
        if (i==1){
            System.out.println("ok");
        }else {
            System.out.println("no");
        }
    }
    //测试编辑资料，更改用户手机号
    @Test
    public void edit4()throws IOException{
        List<User> h = ServerSql.selectUserByUsername("xxx");
        User a=h.get(0);
        a.setPhone("17873952628");
        int i = ServerSql.updateUser(a);
        if (i==1){
            System.out.println("ok");
        }else {
            System.out.println("no");
        }
    }
    //测试编辑资料，更改用户角色
    @Test
    public void edit5()throws IOException{
        List<User> h = ServerSql.selectUserByUsername("xxx");
        User a=h.get(0);
        a.setRole(Role.ADMIN);
        int i = ServerSql.updateUser(a);
        if (i==1){
            System.out.println("ok");
        }else {
            System.out.println("no");
        }
    }
    //测试搜索用户手机号
    @Test
    public void searchPhone()throws IOException{
        List<User> h = ServerSql.selectUserByPhone("17873952628");
        System.out.println(h.get(0));
    }
    //测试搜索用户账户名
    @Test
    public void searchUsername()throws IOException{
        List<User> h = ServerSql.selectUserByUsername("xxx");
        System.out.println(h.get(0));
    }
    //测试搜索用户uid
    @Test
    public void searchUid()throws IOException{
        List<User> h = ServerSql.selectUserByUsername("xxx");
        UUID a=h.get(0).getUid();
        User b = ServerSql.selectUserByUid(a);
        System.out.println(b);
    }
    //测试搜索类别分页
    @Test
    public void searchPage()throws IOException {
        List<News> a = ServerSql.selectNewsByType("体育", 0, 10);
        System.out.println(a.get(0).getTitle());
    }
    //测试搜索类别分页
    @Test
    public void searchPage1()throws IOException {
        List<News> a = ServerSql.selectNewsByType("经济", 0, 10);
        System.out.println(a.get(0).getTitle());
    }
    //测试搜索类别分页
    @Test
    public void searchPage2()throws IOException {
        List<News> a = ServerSql.selectNewsByType("文化", 0, 10);
        System.out.println(a.get(0).getTitle());
    }
    //测试搜索类别分页
    @Test
    public void searchPage3()throws IOException {
        List<News> a = ServerSql.selectNewsByType("政治", 0, 10);
        System.out.println(a.get(0).getTitle());
    }
    //测试搜索类别分页
    @Test
    public void searchPage4()throws IOException {
        List<News> a = ServerSql.selectNewsByType("社会", 0, 10);
        System.out.println(a.get(0).getTitle());
    }

}
