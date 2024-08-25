import router from '@ohos.router'
import http from '@ohos.net.http'
import {User} from '../User/User'
function exception_alert(message:string){
  AlertDialog.show({
    message:message
  })
}
@Entry
@Component
struct Register {
  @State tLabel:string[][] = [
    ["账号 |","请输入账号，必填"],
    ["密码 |","请输入密码，必填"],
    ["确认密码 |","请再次输入密码，必填"],
    ["手机号 |","请输入手机号，必填"],
    ["邮箱 |","请输入邮箱，选填"],
    ["昵称 |","请输入昵称，选填"],
  ]
  @State url:string = AppStorage.Get("url")+"/register"
  @State user:User = new User()
  @Builder text_input(label:string,placeholder:string){
    Row() {
      Text(label)
        .width("35%")
        .height("100%")
        .fontSize("20fp")
        .padding({ top: "0vp", bottom: "0vp", left: "10vp", right: "0vp" })
        .fontWeight(FontWeight.Bold)
      TextInput({ placeholder: placeholder })
        .width("65%")
        .height("100%")
        .backgroundColor("#ffffff")
        .onChange((value:string)=>{
          switch (label){
            case "账号 |":
              this.user.Username = value
              break
            case "密码 |":
              this.user.Password = value
              break
            case "确认密码 |":
              this.user.RePassword = value
              break
            case "手机号 |":
              this.user.Phone = value
              break
            case "邮箱 |":
              this.user.Email = value
              break
            case "昵称 |":
              this.user.NiChen = value
              break
            default :
              break
          }
        })
    }
    .width("90%")
    .height("8%")
    .borderWidth("3vp")
    .borderRadius("20vp")
    .margin({bottom:"5%"})
  }
  build() {
    Column() {
      Image($r('app.media.icon'))
        .width("174.84vp")
        .height("139.21vp")
      ForEach(this.tLabel,(item,index)=>{
        this.text_input(item[0],item[1])
      })
      Button("注册")
        .width("85%")
        .height("10%")
        .backgroundColor("#07f262")
        .fontSize("40fp")
        .onClick(()=>{
          if (this.user.Username == "") {
            exception_alert("账号不能为空")
          }else if (this.user.Username.length>20){
            exception_alert("账号长度超过限制")
          }else if (this.user.Password.length>30){
            exception_alert("密码长度超过限制")
          }else if (this.user.NiChen.length>10){
            exception_alert("昵称大小超过限制")
          }else if (this.user.Password == ""){
            exception_alert("密码不能为空")
          }else if (this.user.RePassword != this.user.Password){
            exception_alert("密码不一致")
          }else if (this.user.Phone == ""){
            exception_alert("手机号不能为空")
          }else if (!this.user.Phone
            .match("^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199|(147))\\d{8}$")){
            exception_alert("手机号格式错误")
          }else if (this.user.Email !="" && !this.user.Email
            .match('^[A-Za-z0-9\u4e00-\u9fa5]+@[a-zA-Z0-9_-]+(.[a-zA-Z0-9_-]+)+$')){
            exception_alert("邮箱格式错误")
          }else {
            let httpRequest = http.createHttp();
            let promise = httpRequest.request(
              this.url,
              {
                method: http.RequestMethod.POST,
                extraData: {
                  "user":this.user,
                },
                header: {
                  'Content-Type': 'application/json'
                }
              }).then((data)=>{
              let res = JSON.parse(data.result.toString());
              if (res.status == "success"){
                AppStorage.SetOrCreate('uid',res.user.uid)
                AppStorage.SetOrCreate('username',res.user.account)
                AppStorage.SetOrCreate('password',res.user.password)
                AppStorage.SetOrCreate('phone',res.user.phone)
                AppStorage.SetOrCreate('email',res.user.email)
                AppStorage.SetOrCreate('niChen',res.user.avatar)
                AppStorage.SetOrCreate('role',res.user.role)
                AppStorage.SetOrCreate('sex',res.user.sex)
                AppStorage.SetOrCreate('head',res.user.head)
                AppStorage.Set("status","1")
                router.replaceUrl({
                  url:"pages/Index",
                })
              }else {
                AlertDialog.show({
                  message:res.message
                })
              }
            }).catch((err)=>{
              console.error('error:'+JSON.stringify(err))
            })
          }
        })
      Text("已有账号？立即登录")
        .width("197.92vp")
        .height("20.57vp")
        .fontColor("#0484fb")
        .textAlign(TextAlign.Center)
        .margin({top:"3%"})
        .onClick(()=>{
          router.back()
        })
    }
    .width("100%")
  }
}