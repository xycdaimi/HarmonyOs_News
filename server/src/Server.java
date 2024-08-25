import java.awt.image.BufferedImage;
import java.io.*;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;
import com.zcxy.pojo.*;
import org.junit.Test;
import javax.imageio.ImageIO;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @author 谢宇宸
 * #Date: 2024/5/8 9:47
 * @version 1.0
 */
public class Server {
    public static void main(String[] args) throws Exception {
        HttpServer server = HttpServer.create(new InetSocketAddress(8887), 0);

        // 处理登录请求
        server.createContext("/login", t -> {
            InputStream is = t.getRequestBody();
            StringBuilder sb = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line).append("\n");
                }
            }
            // 这里假设你已经有了一个 JSON 字符串，你可以使用库如 Jackson 或 Gson 来解析它
            String jsonData = sb.toString();
            // 使用JsonParser解析JSON字符串为JsonObject
            JsonObject jsonObject = JsonParser.parseString(jsonData).getAsJsonObject();
            // 访问JsonObject中的数据
            String username = jsonObject.get("username").getAsString();
            String password = jsonObject.get("password").getAsString();
            List<User> user = ServerSql.selectUserByUsername(username);
            Map<String, Object> result = new HashMap<>();
            if (user.size()==0){
                result.put("status", "failure");
                result.put("message", "User not found");
            }
            else if(user.size()>1){
                result.put("status", "failure");
                result.put("message", "Duplicate user");
            }else {
                if (user.get(0).getPassword().equals(password)){
                    result.put("status", "success");
                    result.put("message", "Login successful");
                    result.put("user", user.get(0));
                }else{
                    result.put("status", "failure");
                    result.put("message", "Wrong password");
                }
            }
            Gson gson = new Gson();
            sendResponse(t, 200, gson.toJson(result));
        });

        server.createContext("/register", new HttpHandler() {
            @Override
            public void handle(HttpExchange t) throws IOException {
                InputStream is = t.getRequestBody();
                StringBuilder sb = new StringBuilder();
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        sb.append(line).append("\n");
                    }
                }
                // 这里假设你已经有了一个 JSON 字符串，你可以使用库如 Jackson 或 Gson 来解析它
                String jsonData = sb.toString();
                // 使用JsonParser解析JSON字符串为JsonObject
                JsonObject jsonObject = JsonParser.parseString(jsonData).getAsJsonObject();
                JsonObject user = jsonObject.get("user").getAsJsonObject();
                // 访问JsonObject中的数据
                String username = user.get("username").getAsString();
                String password = user.get("password").getAsString();
                String phone = user.get("phone").getAsString();
                String email = user.get("email").getAsString();
                String niChen = user.get("niChen").getAsString();
                Role role = Objects.equals(user.get("role").getAsString(), "0") ? Role.ADMIN : Role.USER;
                Sex sex = Objects.equals(user.get("sex").getAsString(), "0") ? Sex.MALE : Sex.FEMALE;
                if (Objects.equals(niChen, "")){
                    int i = ServerSql.selectUserCount();
                    if (i>=0){
                        niChen = "niChen"+i;
                    }
                }
                List<User> users1 = ServerSql.selectUserByUsername(username);
                List<User> users2 = ServerSql.selectUserByUsername(phone);
                Map<String, Object> result = new HashMap<>();
                if (users1.size()==0&&users2.size()==0){
                    int i = ServerSql.insertUser(username, password, phone, email, niChen, role, sex);
                    if (i==1){
                        List<User> register = ServerSql.selectUserByUsername(username);
                        if (register.size()==1){
                            result.put("user", register.get(0));
                            result.put("status", "success");
                            result.put("message", "Registration successful");
                        }
                        else {
                            result.put("status", "failure");
                            result.put("message", "Registration failed");
                        }
                    }
                    else {
                        result.put("status", "failure");
                        result.put("message", "Registration failed");
                    }
                }else if (users1.size()==1){
                    result.put("status", "failure");
                    result.put("message", "Username already exists");
                }else if (users2.size()==1){
                    result.put("status", "failure");
                    result.put("message", "Phone number already exists");
                }
                Gson gson = new Gson();
                sendResponse(t, 200, gson.toJson(result));
            }
        });

        server.createContext("/getUser", t -> {
            InputStream is = t.getRequestBody();
            StringBuilder sb = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line).append("\n");
                }
            }
            // 这里假设你已经有了一个 JSON 字符串，你可以使用库如 Jackson 或 Gson 来解析它
            String jsonData = sb.toString();
            // 使用JsonParser解析JSON字符串为JsonObject
            JsonObject jsonObject = JsonParser.parseString(jsonData).getAsJsonObject();
            // 访问JsonObject中的数据
            UUID uid = UUID.fromString(jsonObject.get("uid").getAsString());
            User user = ServerSql.selectUserByUid(uid);
            Map<String, Object> result = new HashMap<>();
            if (user==null){
                result.put("status", "failure");
                result.put("message", "User not found");
            }else {
                result.put("status", "success");
                result.put("message", "getAuthor successful");
                result.put("userHead", user.getHead());
            }
            Gson gson = new Gson();
            sendResponse(t, 200, gson.toJson(result));
        });

        server.createContext("/addComment", t -> {
            InputStream is = t.getRequestBody();
            StringBuilder sb = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line).append("\n");
                }
            }
            // 这里假设你已经有了一个 JSON 字符串，你可以使用库如 Jackson 或 Gson 来解析它
            String jsonData = sb.toString();
            // 使用JsonParser解析JSON字符串为JsonObject
            JsonObject jsonObject = JsonParser.parseString(jsonData).getAsJsonObject();
            // 访问JsonObject中的数据
            int id = jsonObject.get("new_id").getAsInt();
            UUID uid = UUID.fromString(jsonObject.get("uid").getAsString());
            String context = jsonObject.get("context").getAsString();
            String niChen = jsonObject.get("niChen").getAsString();
            int i = ServerSql.insertComment(id, context, uid,niChen);
            Map<String, Object> result = new HashMap<>();
            if (i==1){
                result.put("status", "success");
                result.put("message", "add Comment successful");
            }else {
                result.put("status", "failure");
                result.put("message", "add Comment failed");
            }
            Gson gson = new Gson();
            sendResponse(t, 200, gson.toJson(result));
        });

        server.createContext("/CommentList", t -> {
            InputStream is = t.getRequestBody();
            StringBuilder sb = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line).append("\n");
                }
            }
            // 这里假设你已经有了一个 JSON 字符串，你可以使用库如 Jackson 或 Gson 来解析它
            String jsonData = sb.toString();
            // 使用JsonParser解析JSON字符串为JsonObject
            JsonObject jsonObject = JsonParser.parseString(jsonData).getAsJsonObject();
            // 访问JsonObject中的数据
            int id = jsonObject.get("new_id").getAsInt();
            int start = jsonObject.get("start").getAsInt();
            int limit = jsonObject.get("limit").getAsInt();
            List<Comment> list = ServerSql.selectCommentByNewsId(id,start,limit);
            Map<String, Object> result = new HashMap<>();
            if (list.size()<=0){
                result.put("status", "failure");
                result.put("message", "Comment not found");
            }else {
                result.put("status", "success");
                result.put("message", "get Comments successful");
                result.put("CommentList", list);
            }
            Gson gson = new Gson();
            sendResponse(t, 200, gson.toJson(result));
        });

        server.createContext("/works", new HttpHandler() {
            @Override
            public void handle(HttpExchange t) throws IOException {
                InputStream is = t.getRequestBody();
                StringBuilder sb = new StringBuilder();
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        sb.append(line).append("\n");
                    }
                }
                // 这里假设你已经有了一个 JSON 字符串，你可以使用库如 Jackson 或 Gson 来解析它
                String jsonData = sb.toString();
                // 使用JsonParser解析JSON字符串为JsonObject
                JsonObject jsonObject = JsonParser.parseString(jsonData).getAsJsonObject();
                UUID uid = UUID.fromString(jsonObject.get("uid").getAsString());
                int start = jsonObject.get("start").getAsInt();
                int end = jsonObject.get("limit").getAsInt();
                List<News> newsList = ServerSql.selectNewsByUid(uid, start, end);
                Map<String, Object> result = new HashMap<>();
                if (newsList.size()>0){
                    result.put("newsList", newsList);
                    result.put("status", "success");
                    result.put("message", "Successfully retrieved news list");
                }else {
                    result.put("status", "failure");
                    result.put("message", "Failed to retrieve news list");
                }
                Gson gson = new Gson();
                sendResponse(t, 200, gson.toJson(result));
            }
        });

        server.createContext("/search", new HttpHandler() {
            @Override
            public void handle(HttpExchange t) throws IOException {
                System.out.println("search");
                InputStream is = t.getRequestBody();
                StringBuilder sb = new StringBuilder();
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        sb.append(line).append("\n");
                    }
                }
                // 这里假设你已经有了一个 JSON 字符串，你可以使用库如 Jackson 或 Gson 来解析它
                String jsonData = sb.toString();
                // 使用JsonParser解析JSON字符串为JsonObject
                JsonObject jsonObject = JsonParser.parseString(jsonData).getAsJsonObject();
                String search = jsonObject.get("text").getAsString();
                int start = jsonObject.get("start").getAsInt();
                int end = jsonObject.get("limit").getAsInt();
                System.out.println(search);
                List<News> newsList = ServerSql.selectNewsByTitle(search,start,end);
                Map<String, Object> result = new HashMap<>();
                if (newsList.size()>0){
                    result.put("newsList", newsList);
                    result.put("status", "success");
                    result.put("message", "Successfully retrieved news list");
                }else {
                    result.put("status", "failure");
                    result.put("message", "Failed to retrieve news list");
                }
                Gson gson = new Gson();
                sendResponse(t, 200, gson.toJson(result));
            }
        });

        server.createContext("/list", new HttpHandler() {
            @Override
            public void handle(HttpExchange t) throws IOException {
                InputStream is = t.getRequestBody();
                StringBuilder sb = new StringBuilder();
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        sb.append(line).append("\n");
                    }
                }
                // 这里假设你已经有了一个 JSON 字符串，你可以使用库如 Jackson 或 Gson 来解析它
                String jsonData = sb.toString();
                // 使用JsonParser解析JSON字符串为JsonObject
                JsonObject jsonObject = JsonParser.parseString(jsonData).getAsJsonObject();
                String new_type = jsonObject.get("type").getAsString();
                int start = jsonObject.get("start").getAsInt();
                int end = jsonObject.get("limit").getAsInt();
                List<News> newsList = ServerSql.selectNewsByType(new_type,start,end);
                Map<String, Object> result = new HashMap<>();
                if (newsList.size()>0){
                    result.put("newsList", newsList);
                    result.put("status", "success");
                    result.put("message", "Successfully retrieved news list");
                }else {
                    result.put("status", "failure");
                    result.put("message", "Failed to retrieve news list");
                }
                Gson gson = new Gson();
                sendResponse(t, 200, gson.toJson(result));
            }
        });

        server.createContext("/hotList", new HttpHandler() {
            @Override
            public void handle(HttpExchange t) throws IOException {
                InputStream is = t.getRequestBody();
                StringBuilder sb = new StringBuilder();
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        sb.append(line).append("\n");
                    }
                }
                // 这里假设你已经有了一个 JSON 字符串，你可以使用库如 Jackson 或 Gson 来解析它
                String jsonData = sb.toString();
                // 使用JsonParser解析JSON字符串为JsonObject
                JsonObject jsonObject = JsonParser.parseString(jsonData).getAsJsonObject();
                int start = jsonObject.get("start").getAsInt();
                int end = jsonObject.get("limit").getAsInt();
                List<News> newsList = ServerSql.selectNews(start,end);
                Map<String, Object> result = new HashMap<>();
                if (newsList.size()>0){
                    result.put("newsList", newsList);
                    result.put("status", "success");
                    result.put("message", "Successfully retrieved news list");
                }else {
                    result.put("status", "failure");
                    result.put("message", "Failed to retrieve news list");
                }
                Gson gson = new Gson();
                sendResponse(t, 200, gson.toJson(result));
            }
        });
        //前端可以通过图片的Url来获取后端上的图片显示在页面组件上
        server.createContext("/image", new HttpHandler() {
            @Override
            public void handle(HttpExchange t) throws IOException {
                String imageUrl = t.getRequestURI().toString().substring("/image".length());
                Path imagePath = Paths.get("src/images", imageUrl); // 替换为你的实际路径
                if (imagePath.toFile().exists()) {
                    byte[] imageBytes = Files.readAllBytes(imagePath);
//                    byte[] imageBytes = imageStream.readAllBytes();
                    String contentType = "image/jpeg"; // 根据图片格式设置contentType
                    t.getResponseHeaders().set("Content-Type", contentType);
                    t.sendResponseHeaders(200, imageBytes.length);
                    OutputStream os = t.getResponseBody();
                    os.write(imageBytes);
                    os.close();
                } else {
                    t.sendResponseHeaders(404, 0);
                    OutputStream os = t.getResponseBody();
                    os.close();
                }
            }
        });

        server.createContext("/upload", new HttpHandler() {
            @Override
            public void handle(HttpExchange t) throws IOException {
                //从post请求里获取图片base64数据，在images文件夹下保存为jpg文件
                InputStream is = t.getRequestBody();
                StringBuilder sb = new StringBuilder();
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        sb.append(line).append("\n");
                    }
                }
                // 这里假设你已经有了一个 JSON 字符串，你可以使用库如 Jackson 或 Gson 来解析它
                String jsonData = sb.toString();
                // 使用JsonParser解析JSON字符串为JsonObject
                JsonObject jsonObject = JsonParser.parseString(jsonData).getAsJsonObject();
                String base64ImageData = jsonObject.get("image").getAsString();
                String title = jsonObject.get("title").getAsString();
                String context = jsonObject.get("context").getAsString();
                String type = jsonObject.get("type").getAsString();
                UUID uid = UUID.fromString(jsonObject.get("uid").getAsString());
                String niChen = jsonObject.get("niChen").getAsString();
                String imgName = "img"+ServerSql.selectNewsIdMax()+".jpg";
                Map<String, Object> result = new HashMap<>();
                // 解码Base64字符串为字节数据
                if (base64ImageData!=""){
                    byte[] imageData = Base64.getDecoder().decode(base64ImageData);
                    try {
                        // 将字节数据转换为图片
                        ByteArrayInputStream bis = new ByteArrayInputStream(imageData);
                        BufferedImage image = ImageIO.read(bis);
                        bis.close();
                        // 指定输出文件的路径和名称
                        String outputFilePath = "src/images/" + imgName;
                        File outputFile = new File(outputFilePath);
                        // 创建输出文件所在的目录（如果不存在）
                        if (!outputFile.getParentFile().exists()) {
                            outputFile.getParentFile().mkdirs();
                        }
                        // 写入图片到文件
                        FileOutputStream fos = new FileOutputStream(outputFile);
                        ImageIO.write(image, "jpg", fos);
                        fos.close();
                        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式
                        String date = df.format(new Date());
                        int i = ServerSql.insertNews(title,context,type,uid,date,imgName,niChen);
                        if (i == 1){
                            result.put("status", "success");
                            result.put("message", "Image uploaded successfully");
                            System.out.println("Image uploaded successfully");
                        }else {
                            result.put("status", "error");
                            result.put("message", "Failed to upload image");
                            System.out.println("Failed to upload image");
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                        result.put("status", "error");
                        result.put("message", "Failed to upload image");
                    }
                }else {
                    imgName = "";
                    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式
                    String date = df.format(new Date());
                    int i = ServerSql.insertNews(title,context,type,uid,date,imgName,niChen);
                    if (i == 1){
                        result.put("status", "success");
                        result.put("message", "Image uploaded successfully");
                        System.out.println("Image uploaded successfully");
                    }else {
                        result.put("status", "error");
                        result.put("message", "Failed to upload image");
                        System.out.println("Failed to upload image");
                    }
                }
                // 返回响应
                Gson gson = new Gson();
                sendResponse(t, 200, gson.toJson(result));
            }
        });

        server.createContext("/change", new HttpHandler() {
            @Override
            public void handle(HttpExchange t) throws IOException {
                InputStream is = t.getRequestBody();
                StringBuilder sb = new StringBuilder();
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        sb.append(line).append("\n");
                    }
                }
                Map<String, Object> result = new HashMap<>();
                // 这里假设你已经有了一个 JSON 字符串，你可以使用库如 Jackson 或 Gson 来解析它
                String jsonData = sb.toString();
                // 使用JsonParser解析JSON字符串为JsonObject
                JsonObject jsonObject = JsonParser.parseString(jsonData).getAsJsonObject();
                String base64ImageData = jsonObject.get("base").getAsString();
                JsonObject user = jsonObject.get("user").getAsJsonObject();
                // 访问JsonObject中的数据
                UUID uid = UUID.fromString(user.get("uid").getAsString());
                String head = user.get("head").getAsString();
                String username = user.get("username").getAsString();
                String password = user.get("password").getAsString();
                String phone = user.get("phone").getAsString();
                String email = user.get("email").getAsString();
                String niChen = user.get("niChen").getAsString();
                Role role = Objects.equals(user.get("role").getAsString(), "0") ? Role.ADMIN : Role.USER;
                Sex sex = Objects.equals(user.get("sex").getAsString(), "0") ? Sex.MALE : Sex.FEMALE;
                List<User> j = ServerSql.selectUserByPhone(phone);
                if (j.size() == 0){
                    if (base64ImageData != null && !base64ImageData.isEmpty()) {
                        String imgName = "img"+username+".jpg";
                        // 解码Base64字符串为字节数据
                        byte[] imageData = Base64.getDecoder().decode(base64ImageData);
                        try {
                            // 将字节数据转换为图片
                            ByteArrayInputStream bis = new ByteArrayInputStream(imageData);
                            BufferedImage image = ImageIO.read(bis);
                            bis.close();
                            // 指定输出文件的路径和名称
                            String outputFilePath = "src/images/" + imgName;
                            File outputFile = new File(outputFilePath);
                            // 创建输出文件所在的目录（如果不存在）
                            if (!outputFile.getParentFile().exists()) {
                                outputFile.getParentFile().mkdirs();
                            }
                            // 写入图片到文件
                            FileOutputStream fos = new FileOutputStream(outputFile);
                            ImageIO.write(image, "jpg", fos);
                            fos.close();
                            User users = ServerSql.selectUserByUid(uid);
                            if (users!=null){
                                users.setAvatar(niChen);
                                users.setHead(imgName);
                                users.setEmail(email);
                                users.setPassword(password);
                                users.setRole(role);
                                users.setSex(sex);
                                users.setPhone(phone);
                            }
                            int i = ServerSql.updateUser(users);
                            if (i == 1){
                                result.put("status", "success");
                                result.put("message", "Image uploaded successfully");
                                System.out.println("Image uploaded successfully");
                            }else {
                                result.put("status", "error");
                                result.put("message", "Failed to upload image");
                                System.out.println("Failed to upload image");
                            }
                        } catch (IOException e) {
                            e.printStackTrace();
                            result.put("status", "error");
                            result.put("message", "Failed to upload image");
                            System.out.println("Failed to upload image");
                        }
                    }else {
                        User users = ServerSql.selectUserByUid(uid);
                        if (users!=null){
                            users.setAvatar(niChen);
                            users.setHead(head);
                            users.setEmail(email);
                            users.setPassword(password);
                            users.setRole(role);
                            users.setSex(sex);
                            users.setPhone(phone);
                        }
                        int i = ServerSql.updateUser(users);
                        if (i == 1){
                            result.put("status", "success");
                            result.put("message", "uploaded successfully");
                        }else {
                            result.put("status", "error");
                            result.put("message", "Failed to upload");
                        }
                    }
                    User users = ServerSql.selectUserByUid(uid);
                    if (users!=null){
                        result.put("user", users);
                    }
                }else {
                    result.put("status", "error");
                    result.put("message", "手机号已存在");
                }

                Gson gson = new Gson();
                sendResponse(t, 200, gson.toJson(result));
            }
        });

        // 处理默认路径或其他未指定的路径
//        server.createContext("/", new HttpHandler() {
//            @Override
//            public void handle(HttpExchange t) throws IOException {
//                String response = "Welcome to the server!";
//                sendResponse(t, 200, response);
//            }
//        });

        server.setExecutor(null); // 创建一个默认的执行器
        server.start();
    }

    // 辅助方法，用于发送HTTP响应
    private static void sendResponse(HttpExchange t, int status, String response) throws IOException {
        t.sendResponseHeaders(status, response.getBytes(StandardCharsets.UTF_8).length);
        OutputStream os = t.getResponseBody();
        os.write(response.getBytes(StandardCharsets.UTF_8));
        os.close();
    }
//    @Test
//    public void adder()throws IOException{
//        List<User> users1 = ServerSql.selectUserByUsername("xhs");
//        System.out.println(users1.get(0).getAccount());
//        News a = new News(1,"欧央行鹰派管委：未来政策将取决于数据，美联储是不可忽视的因素","    财联社6月9日讯（编辑 夏军雄）欧洲央行管委会成员、奥地利央行行长罗伯特·霍尔兹曼表示，尽管欧洲央行\n" +
//                "本周宣布了降息，但现在就判断该央行未来将继续降息还为时过早。\n" +
//                "    欧洲央行周四宣布降息25个基点，成为继加拿大央行之后，又一家放松货币政策的央行。欧洲央行三大关键利率主要再融资利率、边际借贷利率和存款机制利率分别下调至4.25%、4.50%和3.75%。\n" +
//                "    由于欧元区最近几周的通胀数据令人失望，欧洲央行没有承诺进一步降息。根据欧盟统计局此前发布的初步统计数据，5月欧元区CPI同比增速从4月的2.4%反弹至2.6%。\n" +
//                "    事实上，即使是本周的降息行动，欧洲央行内部也没有完全达成一致。霍尔兹曼是欧洲央行管理委员会26名成员中唯一反对降息的成员，他通常被视为欧洲央行管委会中鹰派阵营的代表人物。\n" +
//                "    霍尔兹曼接受了奥地利电台的采访，采访于当地时间周六播出。他强调，数据驱动型决策应该以数据为指导，以此解释自己为何反对降息。\n" +
//                "    当被问及本次降息是否代表者利率将进一步下降时，霍尔兹曼持谨慎态度。他表示，未来的政策决定将取决于数据。\n" +
//                "    霍尔兹曼在采访中表示，需要考虑的因素之一是欧洲央行和美联储之间的利差。他警告称，如果美联储没有像美国决策者年初暗示的那样降息三次，那将影响美元兑欧元的汇率，从而可能加剧欧元区的通胀。\n" +
//                "    尽管包括欧洲央行行长拉加德在内的政策制定者多次强调，欧洲央行将依据经济数据来行动，而不是美联储的动向，但霍尔兹曼曾多次公开承认，欧洲决策者必须考虑到美联储和美国的通胀形势。\n" +
//                "    霍尔兹曼说，欧洲央行只有在通胀率降至2%的目标水平后，才能宣布取得胜利。他补充道：“我们希望能在2026年到达那里，这是模型预测的结果，而这一切都是基于没有进一步冲击的假设。”",
//                users1.get(0).getUid(),
//                "2024-06-09 12:30:00",
//                "3.jpg",
//                "经济",
//                "新华社");
//        int i = ServerSql.insertNews(a);
//        if (i==1){
//            System.out.println("ok");
//        }else {
//            System.out.println("no");
//        }
//    }
//    @Test
//    public void selectt()throws IOException{
//        List<News> a = ServerSql.selectNewsByTitle("|",0,2);
//        System.out.println(a.get(0).getTitle());
//    }
}
