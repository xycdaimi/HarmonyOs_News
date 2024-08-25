import com.zcxy.mapper.CommentMapper;
import com.zcxy.mapper.NewsMapper;
import com.zcxy.mapper.UserMapper;
import com.zcxy.pojo.*;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * @author 谢宇宸
 * #Date: 2024/5/15 11:01
 * @version 1.0
 */
public class ServerSql {
    private static SqlSessionFactory getSqlSessionFactory() throws IOException {
        //1. 从mybatis的核心配置文件，创建SqlSessionFactory
        String resource = "mybatis-config.xml";//mybatis的核心配置文件
        InputStream inputStream = Resources.getResourceAsStream(resource);
        return new SqlSessionFactoryBuilder().build(inputStream);
    }
    public static List<User> selectUserByUsername(String username) throws IOException {
        SqlSessionFactory sqlSessionFactory = getSqlSessionFactory();
        SqlSession sqlSession = sqlSessionFactory.openSession();
        UserMapper mapper = sqlSession.getMapper(UserMapper.class);
        List<User> t = mapper.selectByAccount(username);
        sqlSession.close();
        return t;
    }
    public static List<User> selectUserByPhone(String phone) throws IOException {
        SqlSessionFactory sqlSessionFactory = getSqlSessionFactory();
        SqlSession sqlSession = sqlSessionFactory.openSession();
        UserMapper mapper = sqlSession.getMapper(UserMapper.class);
        List<User> t = mapper.selectByPhone(phone);
        sqlSession.close();
        return t;
    }
    public static User selectUserByUid(UUID uid) throws IOException {
        SqlSessionFactory sqlSessionFactory = getSqlSessionFactory();
        SqlSession sqlSession = sqlSessionFactory.openSession();
        UserMapper mapper = sqlSession.getMapper(UserMapper.class);
        User t = mapper.selectByUid(uid);
        sqlSession.close();
        return t;
    }
    public static int selectUserCount()throws IOException{
        SqlSessionFactory sqlSessionFactory = getSqlSessionFactory();
        SqlSession sqlSession = sqlSessionFactory.openSession();
        UserMapper mapper = sqlSession.getMapper(UserMapper.class);
        int i = mapper.selectCount();
        sqlSession.close();
        return i;
    }

    public static int insertUser(String username, String password, String phone, String email, String niChen,Role role,Sex sex) throws IOException{
        SqlSessionFactory sqlSessionFactory = getSqlSessionFactory();
        SqlSession sqlSession = sqlSessionFactory.openSession();
        UserMapper mapper = sqlSession.getMapper(UserMapper.class);
        int i = mapper.addUser(new User(username, password, phone, email, niChen, role, sex));
        if (i==1){
            sqlSession.commit();
        }
        sqlSession.close();
        return i;
    }
    public static int updateUser(User user) throws IOException{
        SqlSessionFactory sqlSessionFactory = getSqlSessionFactory();
        SqlSession sqlSession = sqlSessionFactory.openSession();
        UserMapper mapper = sqlSession.getMapper(UserMapper.class);
        int i = mapper.updateUser(user);
        if (i==1){
            sqlSession.commit();
        }
        sqlSession.close();
        return i;
    }
    public static List<News> selectNewsByUid(UUID uid,int start,int end) throws IOException{
        SqlSessionFactory sqlSessionFactory = getSqlSessionFactory();
        SqlSession sqlSession = sqlSessionFactory.openSession();
        NewsMapper mapper = sqlSession.getMapper(NewsMapper.class);
        List<News> t = mapper.selectByUid(uid,start,end);
        sqlSession.close();
        return t;
    }
    public static List<News> selectNewsByType(String new_type,int start,int end) throws IOException{
        SqlSessionFactory sqlSessionFactory = getSqlSessionFactory();
        SqlSession sqlSession = sqlSessionFactory.openSession();
        NewsMapper mapper = sqlSession.getMapper(NewsMapper.class);
        List<News> t = mapper.selectByType(new_type,start,end);
        sqlSession.close();
        return t;
    }
    public static List<News> selectNewsByTitle(String title,int start,int end) throws IOException{
        SqlSessionFactory sqlSessionFactory = getSqlSessionFactory();
        SqlSession sqlSession = sqlSessionFactory.openSession();
        NewsMapper mapper = sqlSession.getMapper(NewsMapper.class);
        List<News> t = mapper.selectByTitle("%"+title+"%",start,end);
        sqlSession.close();
        return t;
    }
    public static List<News> selectNews(int start,int limit) throws IOException{
        SqlSessionFactory sqlSessionFactory = getSqlSessionFactory();
        SqlSession sqlSession = sqlSessionFactory.openSession();
        NewsMapper mapper = sqlSession.getMapper(NewsMapper.class);
        List<News> t = mapper.selectList(start,limit);
        sqlSession.close();
        return t;
    }
    public static int insertNews(String new_title,String new_content,String new_type,UUID new_author,String new_time,String new_img,String new_niChen) throws IOException{
        SqlSessionFactory sqlSessionFactory = getSqlSessionFactory();
        SqlSession sqlSession = sqlSessionFactory.openSession();
        NewsMapper mapper = sqlSession.getMapper(NewsMapper.class);
        int i = mapper.addNews(new News(new_title,new_content,new_author,new_time,new_img,new_type,new_niChen));
        if (i==1){
            sqlSession.commit();
        }
        sqlSession.close();
        return i;
    }
    public static int insertNews(News news) throws IOException{
        SqlSessionFactory sqlSessionFactory = getSqlSessionFactory();
        SqlSession sqlSession = sqlSessionFactory.openSession();
        NewsMapper mapper = sqlSession.getMapper(NewsMapper.class);
        int i = mapper.addNews(news);
        if (i==1){
            sqlSession.commit();
        }
        sqlSession.close();
        return i;
    }
    public static List<Comment> selectCommentByNewsId(int news_id,int start,int end) throws IOException{
        SqlSessionFactory sqlSessionFactory = getSqlSessionFactory();
        SqlSession sqlSession = sqlSessionFactory.openSession();
        CommentMapper mapper = sqlSession.getMapper(CommentMapper.class);
        List<Comment> t = mapper.selectList(news_id,start,end);
        sqlSession.close();
        return t;
    }
    public static int insertComment(int news_id,String comment_content,UUID uid,String niChen) throws IOException{
        SqlSessionFactory sqlSessionFactory = getSqlSessionFactory();
        SqlSession sqlSession = sqlSessionFactory.openSession();
        CommentMapper mapper = sqlSession.getMapper(CommentMapper.class);
        //获取现在的时间转为YYYY-MM-DD HH:mm:ss格式的字符串
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式
        String date = df.format(new Date());
        int i = mapper.addComment(new Comment(1,news_id,uid,comment_content,date,niChen));
        if (i==1){
            sqlSession.commit();
            sqlSession.close();
            sqlSessionFactory = getSqlSessionFactory();
            sqlSession = sqlSessionFactory.openSession();
            NewsMapper mapper1 = sqlSession.getMapper(NewsMapper.class);
            List<News> t = mapper1.selectById(news_id);
            if (t.size()==1){
                News a = t.get(0);
                a.setComments(a.getComments()+1);
                i = mapper1.updateNews(a);
                if (i==1){
                    sqlSession.commit();
                }
            }else {
                i=t.size();
            }
        }
        sqlSession.close();
        return i;
    }
    public static int selectNewsIdMax()throws IOException{
        SqlSessionFactory sqlSessionFactory = getSqlSessionFactory();
        SqlSession sqlSession = sqlSessionFactory.openSession();
        NewsMapper mapper = sqlSession.getMapper(NewsMapper.class);
        News t = mapper.selectIdMax();
        int i = -1;
        if (t!=null){
            i = t.getId();
        }
        sqlSession.close();
        return i;
    }
}
