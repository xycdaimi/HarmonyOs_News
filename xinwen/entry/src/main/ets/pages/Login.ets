import http from '@ohos.net.http'
import router from '@ohos.router'
@Entry
@Component
struct Login {
  @State username:string = ""
  @State password:string = ""
  @State url:string = AppStorage.Get("url")+"/login"
  build() {
    Column() {
      Column() {
        Button("X",{type:ButtonType.Normal,stateEffect:true})
          .offset({x:"-140vp",y:"20vp"})
          .backgroundColor("#ffffff")
          .fontColor("#000000")
          .fontSize("30vp")
          .onClick(()=>{
            router.back()
          })
        Image($r('app.media.icon'))
          .width("184.93vp")
          .height("171.75vp")
          .offset({ x: "-0.2vp", y: "70.62vp" })
          .borderStyle(BorderStyle.Dashed)
        Row() {
          Text(" 账号 |")
            .width("30%")
            .height("100%")
            .fontSize("30fp")
          TextInput({ placeholder: "请输入账号" })
            .width("70%")
            .height("100%")
            .offset({ x: "3.46vp", y: "-0.04vp" })
            .backgroundColor("#ffffff")
            .onChange((textChange:string)=>{
              this.username = textChange
            })
        }        
        .width("90%")
        .height("10%")
        .offset({ x: "0vp", y: "93.16vp" })
        .borderWidth("2vp")
        .borderRadius("20vp")
        Row() {
          Text(" 密码 |")
            .width("30%")
            .height("100%")
            .fontSize("30fp")
          TextInput({ placeholder: "请输入密码" })
            .width("70%")
            .height("100%")
            .backgroundColor("#ffffff")
            .placeholderFont({ style: FontStyle.Normal })
            .onChange((textChange:string)=>{
              this.password = textChange
            })
        }        
        .width("90%")
        .height("10%")
        .offset({ x: "0vp", y: "119.01vp" })
        .borderWidth("2vp")
        .borderRadius("20vp")
        Button("登录")
          .width("90%")
          .height("10%")
          .offset({ x: "0vp", y: "141.07vp" })
          .borderRadius("20vp")
          .backgroundColor("#289a83")
          .type(ButtonType.Normal)
          .fontSize("30fp")
          .fontWeight(FontWeight.Bolder)
          .fontFamily("sans-serif")
          .onClick(()=>{
            let httpRequest = http.createHttp();
            let promise = httpRequest.request(
              this.url,
              {
                method: http.RequestMethod.POST,
                extraData: {
                  "username":this.username,
                  "password": this.password,
                },
                header: {
                  'Content-Type': 'application/json'
                }
              }).then((data)=>{
              let res = JSON.parse(data.result.toString());
              if (res.status == "success") {
                let uid = AppStorage.Get("uid")
                if (uid != res.user.uid) {
                  AppStorage.SetOrCreate("uid",res.user.uid)
                  AppStorage.SetOrCreate('username',res.user.account)
                  AppStorage.SetOrCreate('password',res.user.password)
                  AppStorage.SetOrCreate('phone',res.user.phone)
                  AppStorage.SetOrCreate('email',res.user.email)
                  AppStorage.SetOrCreate('niChen',res.user.avatar)
                  AppStorage.SetOrCreate('role',res.user.role)
                  AppStorage.SetOrCreate('sex',res.user.sex)
                  AppStorage.SetOrCreate('head',res.user.head)
                }
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
          })
        Button("注册")
          .width("90%")
          .height("10%")
          .offset({ x: "0vp", y: "155.44vp" })
          .borderRadius("20vp")
          .backgroundColor("#289a83")
          .type(ButtonType.Normal)
          .fontSize("30fp")
          .fontWeight(FontWeight.Bolder)
          .onClick(()=>{
            router.pushUrl({
              url:'pages/Register'
            })
          })
      }      
      .width("100%")
      .height("100%")
      .borderStyle(BorderStyle.Solid)
    }
    .width("100%")
    .height("100%")
  }
}