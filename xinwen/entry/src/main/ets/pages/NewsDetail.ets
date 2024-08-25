import router from '@ohos.router'
import { News } from '../News/News'
import http from '@ohos.net.http'
import UpDownRefreshCom from './UpDownRefresh'
import { Comment } from '../Comment/Comment'
let commentsText = ""
let status = AppStorage.Get("status")
@Entry
@Component
struct NewsDetail {
  @State param:object = router.getParams()
  @State news:News = this.param?.["News"]
  scroller: Scroller = new Scroller()
  @State head_img:string = this.param?.["head"]
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogComments(),
    alignment: DialogAlignment.Bottom
  })
  dialoglistController: CustomDialogController = new CustomDialogController({
    builder: CustomDialoglist(),
    alignment: DialogAlignment.Bottom
  })
  @Provide newsId: number = 0
  @Provide testId:number = 0
  build() {
    Column() {
      Column() {
        Row() {
          Image($r('app.media.back'))
            .width("10%")
            .height("100%")
            .onClick(()=>{
              router.back()
            })
        }
        .width("100%")
        .height("7%")
        Scroll(this.scroller){
          Column(){
            Row() {
              Text(this.news["title"])
                .width("100%")
                .height("100%")
                .fontSize("25fp")
                .fontWeight(FontWeight.Bolder)
                .padding({left:20,right:20})
            }
            .width("100%")
            .height("15%")
            Row() {
              Image(AppStorage.Get("url")+"/image/"+this.head_img)
                .width("20%")
                .height("100%")
                .borderRadius("1080vp")
                .margin({ right: "10vp" })
              Row() {
                Text(this.news["niChen"])
                  .fontSize("20fp")
                  .fontWeight(FontWeight.Bold)
              }.width("30%")
              .height("40%")
              .margin({ top: "-10%" })
              Row(){
                Text(this.news["date_time"])
                  .fontSize("15fp")
                  .fontColor("#CCCCCC")
                  .fontStyle(FontStyle.Italic)
              }.width("60%")
              .height("30%")
              .margin({left:"-24%",top:"6%"})
            }
            .width("100%")
            .height("10%")
            .padding({left:20})
            Row() {
              Image(AppStorage.Get("url")+"/image/"+this.news["image"])
                .width("80%")
                .height("213.65vp")
            }
            .margin({top:"10vp"})
            Column() {
              Text(this.news["content"])
                .width("90%")
                .fontSize("25fp")
            }
            .width("100%")
          }
          .width("100%")
        }
        .scrollable(ScrollDirection.Vertical)
        .width("100%")
        .height("87%")
        Row() {
          TextInput({ placeholder: "友善评论" })
            .width("60%")
            .height("90%")
            .placeholderFont({ weight: FontWeight.Lighter, family: "sans-serif", style: FontStyle.Normal,size:20})
            .onClick(() => {
              if (status == "1") {
                this.dialogController.open()
              }else {
                AlertDialog.show({
                  message:"请登录体验完整功能"
                })
              }
            })
            .margin({left:"4%"})
          Image($r('app.media.say'))
            .width("15%")
            .height("80%")
            .margin({left:"4%"})
            .onClick(() => {
              this.dialoglistController.open()
            })
          Image($r('app.media.share'))
            .width("10%")
            .height("80%")
            .margin({left:"4%"})
        }
        .width("100%")
        .height("6%")
        .backgroundColor("#ffffff")
        .position({ x: "0%", y: "94%" })
      }
      .width("100%")
      .height("100%")
    }
    .width("100%")
    .height("100%")
  }
}
@CustomDialog
struct CustomDialogComments {
  //弹出控制器，控制弹出打开和关闭
  commentsDialogController: CustomDialogController
  @State commentsText: string = commentsText
  @Consume newsId:number
  @Consume testId:number
  @State param:object = router.getParams()
  @State news:News = this.param?.["News"]
  @State tan:boolean = true
  build() {
    Column() {
      Row() {
        Text("X")
          .fontSize(20)
          .margin(10)
          .onClick(() => {
            this.commentsDialogController.close()
          })

        Text("评论")
          .fontSize(16)
          .fontWeight(800)
        Button("发表")
          .backgroundColor(this.commentsText.length > 0 ? Color.Red : "#f1f2f3")
          .fontColor(this.commentsText.length > 0 ? Color.White : Color.Gray)
          .onClick(() => {
            this.tan = false
            if (this.commentsText.length > 0) {
              let httpRequest = http.createHttp();
              let promise = httpRequest.request(
                AppStorage.Get("url")+"/addComment",
                {
                  method: http.RequestMethod.POST,
                  extraData: {
                    "new_id":this.news["id"],
                    "uid":AppStorage.Get("uid"),
                    "niChen":AppStorage.Get("niChen"),
                    "context":this.commentsText
                  },
                  header: {
                    'Content-Type': 'application/json'
                  }
                }).then((data)=>{
                let res = JSON.parse(data.result.toString());
                if (res.status == "success") {
                  commentsText = ""
                  this.commentsText = ""
                  AlertDialog.show({
                    message:"发布成功"
                  })
                }else {
                  AlertDialog.show({
                    message:res.message
                  })
                }
              }).catch((err)=>{
                console.error('error:'+JSON.stringify(err))
              })
              this.commentsDialogController.close()
            }
          })
      }.width("100%")
      .justifyContent(FlexAlign.SpaceBetween)
      .padding(10)
      TextArea({ placeholder: "优质评论会优先显示",text:commentsText })
        .height(150)
        .align(Alignment.TopStart)
        .onChange((value) => {
          this.commentsText = value
        })
    }
  }

  aboutToAppear() {
    this.commentsText = ""
  }

  aboutToDisappear() {
    //一个页面不能弹出框再弹出框
    if (this.commentsText.length > 0 && this.tan) {
      //系统有自带弹出框，类似js里面alert
      AlertDialog.show(
        {
          title: '警告',
          message: '是否保留本次编辑？',
          autoCancel: true,
          gridCount: 4,
          offset: { dx: 0, dy: -20 },
          primaryButton: {
            value: "不保留",
            action: () => {
              commentsText = ""
            }
          },
          secondaryButton: {
            value: "保留",
            action: () => {
              commentsText = this.commentsText
            }
          }
        }
      )
    }else {
      commentsText = ""
      this.tan = true
    }
  }
}
@CustomDialog
struct CustomDialoglist {
  commentsDialogController: CustomDialogController
  @State param:object = router.getParams()
  @State news:News = this.param?.["News"]
  @State commentsText: string = ""
  @State pages:number = 0
  @State list:Array<any> = []
  @State limitNum:number = 10
  @State url:string = AppStorage.Get("url")
  @Builder DomBuilder(item: Comment) {
    Column() {
      Row() {
        Text(item.NiChen)
          .fontSize("18fp")
          .margin({left:10,top:5})
      }.width("100%")
      .height("22%")
      Row() {
        Text(item.Create_Time)
          .width("100%")
          .height("100%")
          .fontSize("13fp")
          .margin({left:10,top:10})
          .fontColor("#CCCCCC")
      }.width("100%")
      .height("20%")
      Row(){
        Text(item.Context)
          .width("100%")
      }.width("80%")
    }.width("100%")
    .height("20%")
  }
  // 刷新测试数据
  refreshData(){
    this.list = []
    this.pages = 0
    let httpRequest = http.createHttp();
    let promise = httpRequest.request(
      this.url+"/CommentList",
      {
        method: http.RequestMethod.POST,
        extraData: {
          "new_id":this.news["id"],
          "start":this.pages,
          "limit": this.limitNum,
        },
        header: {
          'Content-Type': 'application/json'
        }
      }).then((data)=>{
      let res = JSON.parse(data.result.toString());
      if (res.status == "success") {
        this.pages = this.pages+this.limitNum
        res.CommentList.forEach(element => {
          this.list.push(new Comment(element.id,element.new_id,element.uid,
            element.context,element.create_time,element.niChen))
        });
      }else {
        if (this.pages!=0) {
          AlertDialog.show({
            message:res.message
          })
        }
      }
    }).catch((err)=>{
      console.error('error:'+JSON.stringify(err))
    })
    return this.list;
  }
  // 加载更多测试数据
  loadMoreData(){
    let httpRequest = http.createHttp();
    let promise = httpRequest.request(
      this.url+"/CommentList",
      {
        method: http.RequestMethod.POST,
        extraData: {
          "new_id":this.news["id"],
          "start":this.pages,
          "limit": this.limitNum,
        },
        header: {
          'Content-Type': 'application/json'
        }
      }).then((data)=>{
      let res = JSON.parse(data.result.toString());
      if (res.status == "success") {
        this.pages = this.pages+this.limitNum
        res.CommentList.forEach(element => {
          this.list.push(new Comment(element.id,element.new_id,element.uid,
            element.context,element.create_time,element.niChen))
        });
      }else {
        AlertDialog.show({
          message:res.message
        })
      }
    }).catch((err)=>{
      console.error('error:'+JSON.stringify(err))
    })
    return this.list;
  }
  build() {
    Column() {
      Stack({alignContent:Alignment.Start}){
        Row(){
          UpDownRefreshCom({
            dataList: this.list,
            total: 120,
            builderDom: this.DomBuilder,
            getDataList: (type: string) => {
              let data = []
              if(type === 'refresh') {
                data = this.refreshData()
              } else {
                data = this.loadMoreData();
              }
              return data;
            }
          })
        }
        .width("100%")
        .height("100%")
        .offset({y:"10%"})
        .justifyContent(FlexAlign.End)
        Column(){
          Text("用户评论")
            .fontSize(16)
            .fontWeight(800)
            .width("100%")
            .height("100%")
            .textAlign(TextAlign.Center)
        }.width("100%")
        .height("10%")
        .backgroundColor("#ffffff")
        .position({x:"0vp",y:"0vp"})
        Row() {
          Text("X")
            .fontSize(20)
            .width("15%")
            .height("100%")
            .padding({left:"30vp"})
            .position({x:"0vp",y:"0vp"})
            .onClick(() => {
              this.commentsDialogController.close()
            })
        }.width("100%")
        .height("10%")
        .position({x:"0vp",y:"0vp"})
      }
    }
    .height("100%")
  }
}