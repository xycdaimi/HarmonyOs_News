import router from '@ohos.router'
@Entry
@Component
struct SetUp {
  @State status: string = AppStorage.Get("status") == "0"?"登录":"退出登录"
  build() {
    Column() {
      Column() {
        Row() {
          Image($r('app.media.back'))
            .width("15%")
            .height("80%")
            .onClick(()=>{
              router.back()
            })
          Column() {
            Text("设置")
              .width("100%")
              .height("100%")
              .textAlign(TextAlign.Center)
              .fontSize("28fp")
              .fontWeight(FontWeight.Bold)
          }          
          .width("70%")
          .height("100%")
        }        
        .width("100%")
        .height("8%")
        .backgroundColor("#ffffff")
        .alignItems(VerticalAlign.Center)
        Row() {
          Text("编辑资料")
            .width("85%")
            .height("100%")
            .margin({ left: "0vp" })
            .padding({ left: "10vp" })
            .fontSize("25fp")
          Image($r('app.media.advance'))
            .width("15%")
            .height("100%")
        }        
        .width("100%")
        .height("8%")
        .backgroundColor("#ffffff")
        .margin({top:10})
        .onClick(()=>{
          if (this.status=="登录") {
            AlertDialog.show({
              message:"请登录体验完整功能"
            })
          }else {
            router.pushUrl({
              url:"pages/Editor"
            })
          }
        })
        Row() {
          Text(this.status)
            .width("100%")
            .height("100%")
            .fontColor("#ff0000")
            .textAlign(TextAlign.Center)
            .fontSize("25fp")
        }        
        .width("100%")
        .height("8%")
        .backgroundColor("#ffffff")
        .margin({top:10})
        .onClick(()=>{
          if (this.status=="登录") {
            router.pushUrl({
              url:"pages/Login"
            })
          }else {
            AppStorage.Delete("uid")
            AppStorage.Delete("username")
            AppStorage.Delete("password")
            AppStorage.Delete("phone")
            AppStorage.Delete("email")
            AppStorage.Delete("niChen")
            AppStorage.Delete("role")
            AppStorage.Delete("sex")
            AppStorage.Delete("head")
            AppStorage.Set("status","0")
            router.replaceUrl({
              url:"pages/Index"
            })
          }
        })
      }      
      .width("100%")
      .height("100%")
      .backgroundColor("#e0e0e0")
    }    
    .width("100%")
    .height("100%")
  }
}