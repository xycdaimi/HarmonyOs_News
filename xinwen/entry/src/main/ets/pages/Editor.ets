import router from '@ohos.router'
import {Sex, User} from '../User/User'
import { MediaBean } from '../bean/MediaBean'
import { local, MediaHelper, UploadUser } from '../helper/MediaHelper'
function exception_alert(message:string){
  AlertDialog.show({
    message:message
  })
}
@Entry
@Component
struct Editor {
  @State mediaBean: MediaBean = new MediaBean();
  private mediaHelper: MediaHelper = new MediaHelper(getContext());
  @State username:string = AppStorage.Get("username")
  @State password:string = AppStorage.Get("password")
  @State sex:string = AppStorage.Get("sex")
  @State phone:string = AppStorage.Get("phone")
  @State email:string = AppStorage.Get("email")
  @State niChen:string = AppStorage.Get("niChen")
  @State url:string = AppStorage.Get("url")
  @State head:string = this.url+"/image/"+AppStorage.Get("head")
  @State tLabel:string[][] = [
    ["密码 |",this.password],
    ["性别 |",this.sex],
    ["手机号 |",this.phone],
    ["邮箱 |",this.email],
    ["昵称 |",this.niChen],
  ]
  @State user:User = new User()
  bianRen(value:string){
    if (value == "MALE") {
      value = "男"
    }else if (value == "FEMALE"){
      value = "女"
    }
    return value
  }
  @Builder text_input(label:string,value:string){
    Row() {
      Text(label)
        .width("35%")
        .height("100%")
        .fontSize("20fp")
        .padding({ top: "0vp", bottom: "0vp", left: "10vp", right: "0vp" })
        .fontWeight(FontWeight.Bold)
      TextInput({text:this.bianRen(value)})
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
            case "性别 |":
              this.user.Sex_value = value == "男"?Sex.MALE:Sex.FEMALE
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
      Row(){
        Image($r('app.media.back'))
          .width("10%")
          .height("100%")
          .onClick(()=>{
            router.back()
          })
      }.width("100%")
      .height("7%")
      Image(this.head)
        .width("100vp")
        .height("100vp")
        .borderRadius("1000vp")
        .margin({bottom:"10vp"})
      .onClick(async ()=>{
        let mediaBean: MediaBean;
        mediaBean = await this.mediaHelper.selectPicture();
        if (mediaBean) {
          this.mediaBean = mediaBean;
          this.head = this.mediaBean.localUrl
        }
      })
      Row() {
        Text("账号 |")
          .width("35%")
          .height("100%")
          .fontSize("20fp")
          .padding({ top: "0vp", bottom: "0vp", left: "10vp", right: "0vp" })
          .fontWeight(FontWeight.Bold)
        Text(this.username)
          .width("65%")
          .height("100%")
          .backgroundColor("#ffffff")
      }
      .width("90%")
      .height("8%")
      .borderWidth("3vp")
      .borderRadius("20vp")
      .margin({bottom:"5%"})
      ForEach(this.tLabel,(item,index)=>{
        this.text_input(item[0],item[1])
      })
      Button("提交")
        .width("85%")
        .height("10%")
        .backgroundColor("#07f262")
        .fontSize("40fp")
        .onClick(()=>{
          if (this.user.Password == ""){
            exception_alert("密码不能为空")
          }else if (this.user.Password.length>30){
            exception_alert("密码长度超过限制")
          }else if (this.user.Phone == ""){
            exception_alert("手机号不能为空")
          }else if (!this.user.Phone
            .match("^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199|(147))\\d{8}$")){
            exception_alert("手机号格式错误")
          }else if (this.user.Email !="" && !this.user.Email
            .match('^[A-Za-z0-9\u4e00-\u9fa5]+@[a-zA-Z0-9_-]+(.[a-zA-Z0-9_-]+)+$')){
            exception_alert("邮箱格式错误")
          }else if (this.user.NiChen.length>10){
            exception_alert("昵称大小超过限制")
          }else if (this.user.NiChen==""){
            exception_alert("昵称不能为空")
          }else {
            this.user.Uid = AppStorage.Get("uid")
            this.user.Username = AppStorage.Get("username")
            this.user.Head = AppStorage.Get("head")
            UploadUser(local,this.user,this.url)
          }
        })
    }
    .width("100%")
  }
}