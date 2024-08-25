import router from '@ohos.router'
import { News } from '../News/News';
import UpDownRefreshCom from './UpDownRefresh'
import http from '@ohos.net.http';
@Entry
@Component
struct SearchNews {
  @State list:Array<any>=[]
  @State pages:number=0
  @State limitNum:number=10
  @State url:string=AppStorage.Get("url")
  @State text:string = ""
  @State flag:boolean = false
  @Builder DomBuilder(item: any) {
    Row() {
      Column() {
        Text(item.Title)
          .width("100%")
          .height("65%")
          .fontSize("20fp")
          .fontWeight(FontWeight.Bold)
        Text(item.NiChen+"  "+item.Comments+"评论")
          .width("100%")
          .height("35%")
          .fontColor("#8f8f8f")
      }
      .width("70%")
      .height("100%")
      .padding({left:20})
      Image("http://3396a58a.r21.cpolar.top/image/"+item.Image)
        .width("30%")
        .height("100%")
    }
    .width("100%")
    .height("20%")
    .onClick(()=>{
      let httpRequest = http.createHttp();
      let promise = httpRequest.request(
        AppStorage.Get("url")+"/getUser",
        {
          method: http.RequestMethod.POST,
          extraData: {
            "uid":item.Author,
          },
          header: {
            'Content-Type': 'application/json'
          }
        }).then((data)=>{
        let res = JSON.parse(data.result.toString());
        if (res.status == "success"){
          router.pushUrl({
            url:"pages/NewsDetail",
            params:{
              "News":item,
              "head":res.userHead
            }
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
  }
  refreshData(){
    this.list = []
    this.pages = 0
    if (this.text!="") {
      let httpRequest = http.createHttp();
      let promise = httpRequest.request(
        this.url+"/search",
        {
          method: http.RequestMethod.POST,
          extraData: {
            "text":this.text,
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
          res.newsList.forEach(element => {
            this.list.push(new News(element.id,element.title,element.content,
              element.author,element.date_time,element.image,element.new_type,element.niChen,element.comments))
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
    }
    return this.list;
  }
  loadMoreData(){
    if (this.text!="") {
      let httpRequest = http.createHttp();
      let promise = httpRequest.request(
        this.url+"/search",
        {
          method: http.RequestMethod.POST,
          extraData: {
            "text":this.text,
            "start":this.pages,
            "limit":this.limitNum,
          },
          header: {
            'Content-Type': 'application/json'
          }
        }).then((data)=>{
        let res = JSON.parse(data.result.toString());
        if (res.status == "success") {
          this.pages= this.pages+this.limitNum
          res.newsList.forEach(element => {
            this.list.push(new News(element.id,element.title,element.content,
              element.author,element.date_time,element.image,element.new_type,element.niChen,element.comments))
          });
        }else {
          AlertDialog.show({
            message:res.message
          })
        }
      }).catch((err)=>{
        console.error('error:'+JSON.stringify(err))
      })
    }
    return this.list;
  }
  build() {
    Column() {
      Stack(){
        if (this.flag){
          Row() {
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
          .offset({y:"8%"})
          .backgroundColor("#ffffff")
        }
        Row() {
          Image($r('app.media.back'))
            .width("15%")
            .height("100%")
            .onClick(()=>{
              router.back()
            })
          Search({value:this.text})
            .width("60%")
            .height("65%")
            .onChange((value:string)=>{
              this.text = value
              if (this.text == "") {
                this.flag = false
              }
            })
            .onSubmit((value:string)=>{
              this.text = value
              this.flag = true
            })
          Button("搜索")
            .width("25%")
            .height("80%")
            .backgroundColor("#ffffff")
            .fontColor("#ff0000")
            .type(ButtonType.Normal)
            .fontSize("20fp")
            .onClick(()=>{
              this.flag = true
            })
        }
        .width("100%")
        .height("8%")
        .backgroundColor("#ffffff")
        .position({x:"0vp",y:"0vp"})
      }
    }    
    .width("100%")
    .height("100%")
  }
}