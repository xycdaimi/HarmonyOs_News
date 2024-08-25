import router from '@ohos.router'
import { MediaBean } from '../bean/MediaBean';
import { local, MediaHelper, Upload } from '../helper/MediaHelper';
import UpDownRefreshCom from './UpDownRefresh'
import http from '@ohos.net.http';
import { News } from '../News/News';
let flag = AppStorage.Link("status")
if (flag==null){
  AppStorage.SetOrCreate("status","0")
}
AppStorage.SetOrCreate("url","http://3396a58a.r21.cpolar.top")
@Entry
@Component
struct Index {
  controller: TextAreaController = new TextAreaController()
  @State status:string =AppStorage.Get("status")
  @State mediaBean: MediaBean = new MediaBean();
  @State img_flag:boolean = false
  private mediaHelper: MediaHelper = new MediaHelper(getContext());
  @State niChen:string = AppStorage.Get("status") == "0"?"未登录":AppStorage.Get("niChen")
  @State list0: Array<any> = []
  @State list1: Array<any> = []
  @State list2: Array<any> = []
  @State list3: Array<any> = []
  @State list4: Array<any> = []
  @State list5: Array<any> = []
  @State list6: Array<any> = []
  @State list7: Array<any> = []
  @State pages0:number=0
  @State pages1:number=0
  @State pages2:number=0
  @State pages3:number=0
  @State pages4:number=0
  @State pages5:number=0
  @State pages6:number=0
  @State pages7:number=0
  @State limitNum:number = 10
  @State url:string=AppStorage.Get("url")
  @State head:string = this.status=="0"?"tou.jpg":AppStorage.Get("head")
  @State img:string = this.url+"/image/"
  @State touXiang:string=this.img+this.head
  @State type:string = "经济"
  @State title:string = ""
  @State context:string = ""
  @Builder DomBuilder(item: News) {
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
  // 刷新测试数据
  refreshData(new_type:string){
    if (new_type == "热榜") {
      this.list0 = []
      this.pages0 = 0
      let httpRequest = http.createHttp();
      let promise = httpRequest.request(
        this.url+"/hotList",
        {
          method: http.RequestMethod.POST,
          extraData: {
            "start":this.pages0,
            "limit": this.limitNum,
          },
          header: {
            'Content-Type': 'application/json'
          }
        }).then((data)=>{
        let res = JSON.parse(data.result.toString());
        if (res.status == "success") {
          this.pages0 = this.pages0+this.limitNum
          res.newsList.forEach(element => {
            this.list0.push(new News(element.id,element.title,element.content,
              element.author,element.date_time,element.image,element.new_type,element.niChen,element.comments))
          });
        }else {
          if (this.pages0!=0) {
            AlertDialog.show({
              message:res.message
            })
          }
        }
      }).catch((err)=>{
        console.error('error:'+JSON.stringify(err))
      })
      return this.list0;
    }else if (new_type == "经济"){
      this.list1 = []
      this.pages1 = 0
      let httpRequest = http.createHttp();
      let promise = httpRequest.request(
        this.url+"/list",
        {
          method: http.RequestMethod.POST,
          extraData: {
            "type":new_type,
            "start":this.pages1,
            "limit": this.limitNum,
          },
          header: {
            'Content-Type': 'application/json'
          }
        }).then((data)=>{
        let res = JSON.parse(data.result.toString());
        if (res.status == "success") {
          this.pages1 = this.pages1+this.limitNum
          res.newsList.forEach(element => {
            this.list1.push(new News(element.id,element.title,element.content,
              element.author,element.date_time,element.image,element.new_type,element.niChen,element.comments))
          });
        }else {
          if (this.pages1!=0) {
            AlertDialog.show({
              message:res.message
            })
          }
        }
      }).catch((err)=>{
        console.error('error:'+JSON.stringify(err))
      })
      return this.list1;
    }else if (new_type == "社会"){
      this.list2 = []
      this.pages2 = 0
      let httpRequest = http.createHttp();
      let promise = httpRequest.request(
        this.url+"/list",
        {
          method: http.RequestMethod.POST,
          extraData: {
            "type":new_type,
            "start":this.pages2,
            "limit": this.limitNum,
          },
          header: {
            'Content-Type': 'application/json'
          }
        }).then((data)=>{
        let res = JSON.parse(data.result.toString());
        if (res.status == "success") {
          this.pages2 = this.pages2+this.limitNum
          res.newsList.forEach(element => {
            this.list2.push(new News(element.id,element.title,element.content,
              element.author,element.date_time,element.image,element.new_type,element.niChen,element.comments))
          });
        }else {
          if (this.pages2!=0) {
            AlertDialog.show({
              message:res.message
            })
          }
        }
      }).catch((err)=>{
        console.error('error:'+JSON.stringify(err))
      })
      return this.list2;
    }else if (new_type == "政治"){
      this.list3 = []
      this.pages3 = 0
      let httpRequest = http.createHttp();
      let promise = httpRequest.request(
        this.url+"/list",
        {
          method: http.RequestMethod.POST,
          extraData: {
            "type":new_type,
            "start":this.pages3,
            "limit": this.limitNum,
          },
          header: {
            'Content-Type': 'application/json'
          }
        }).then((data)=>{
        let res = JSON.parse(data.result.toString());
        if (res.status == "success") {
          this.pages3 = this.pages3+this.limitNum
          res.newsList.forEach(element => {
            this.list3.push(new News(element.id,element.title,element.content,
              element.author,element.date_time,element.image,element.new_type,element.niChen,element.comments))
          });
        }else {
          if (this.pages3!=0) {
            AlertDialog.show({
              message:res.message
            })
          }
        }
      }).catch((err)=>{
        console.error('error:'+JSON.stringify(err))
      })
      return this.list3;
    }else if (new_type == "科技"){
      this.list4 = []
      this.pages4 = 0
      let httpRequest = http.createHttp();
      let promise = httpRequest.request(
        this.url+"/list",
        {
          method: http.RequestMethod.POST,
          extraData: {
            "type":new_type,
            "start":this.pages4,
            "limit": this.limitNum,
          },
          header: {
            'Content-Type': 'application/json'
          }
        }).then((data)=>{
        let res = JSON.parse(data.result.toString());
        if (res.status == "success") {
          this.pages4 = this.pages4+this.limitNum
          res.newsList.forEach(element => {
            this.list4.push(new News(element.id,element.title,element.content,
              element.author,element.date_time,element.image,element.new_type,element.niChen,element.comments))
          });
        }else {
          if (this.pages4!=0) {
            AlertDialog.show({
              message:res.message
            })
          }
        }
      }).catch((err)=>{
        console.error('error:'+JSON.stringify(err))
      })
      return this.list4;
    }else if (new_type == "体育"){
      this.list5 = []
      this.pages5 = 0
      let httpRequest = http.createHttp();
      let promise = httpRequest.request(
        this.url+"/list",
        {
          method: http.RequestMethod.POST,
          extraData: {
            "type":new_type,
            "start":this.pages5,
            "limit": this.limitNum,
          },
          header: {
            'Content-Type': 'application/json'
          }
        }).then((data)=>{
        let res = JSON.parse(data.result.toString());
        if (res.status == "success") {
          this.pages5 = this.pages5+this.limitNum
          res.newsList.forEach(element => {
            this.list5.push(new News(element.id,element.title,element.content,
              element.author,element.date_time,element.image,element.new_type,element.niChen,element.comments))
          });
        }else {
          if (this.pages5!=0) {
            AlertDialog.show({
              message:res.message
            })
          }
        }
      }).catch((err)=>{
        console.error('error:'+JSON.stringify(err))
      })
      return this.list5;
    }else if (new_type == "文化"){
      this.list6 = []
      this.pages6 = 0
      let httpRequest = http.createHttp();
      let promise = httpRequest.request(
        this.url+"/list",
        {
          method: http.RequestMethod.POST,
          extraData: {
            "type":new_type,
            "start":this.pages6,
            "limit": this.limitNum,
          },
          header: {
            'Content-Type': 'application/json'
          }
        }).then((data)=>{
        let res = JSON.parse(data.result.toString());
        if (res.status == "success") {
          this.pages6 = this.pages6+this.limitNum
          res.newsList.forEach(element => {
            this.list6.push(new News(element.id,element.title,element.content,
              element.author,element.date_time,element.image,element.new_type,element.niChen,element.comments))
          });
        }else {
          if (this.pages6!=0) {
            AlertDialog.show({
              message:res.message
            })
          }
        }
      }).catch((err)=>{
        console.error('error:'+JSON.stringify(err))
      })
      return this.list6;
    }else if (new_type == "作品"){
      this.list7 = []
      this.pages7 = 0
      let httpRequest = http.createHttp();
      let promise = httpRequest.request(
        this.url+"/works",
        {
          method: http.RequestMethod.POST,
          extraData: {
            "uid":AppStorage.Get("uid"),
            "start":this.pages6,
            "limit": this.limitNum,
          },
          header: {
            'Content-Type': 'application/json'
          }
        }).then((data)=>{
        let res = JSON.parse(data.result.toString());
        if (res.status == "success") {
          this.pages7 = this.pages7+this.limitNum
          res.newsList.forEach(element => {
            this.list7.push(new News(element.id,element.title,element.content,
              element.author,element.date_time,element.image,element.new_type,element.niChen,element.comments))
          });
        }else {
          if (this.pages7!=0) {
            AlertDialog.show({
              message:res.message
            })
          }
        }
      }).catch((err)=>{
        console.error('error:'+JSON.stringify(err))
      })
      return this.list7;
    }
  }

  // 加载更多测试数据
  loadMoreData(new_type:string){
    if (new_type == "热榜") {
      let httpRequest = http.createHttp();
      let promise = httpRequest.request(
        this.url+"/hotList",
        {
          method: http.RequestMethod.POST,
          extraData: {
            "start":this.pages0,
            "limit":this.limitNum,
          },
          header: {
            'Content-Type': 'application/json'
          }
        }).then((data)=>{
        let res = JSON.parse(data.result.toString());
        if (res.status == "success") {
          this.pages0 = this.pages0+this.limitNum
          res.newsList.forEach(element => {
            this.list0.push(new News(element.id,element.title,element.content,
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
      return this.list0;
    }else if (new_type == "经济"){
      let httpRequest = http.createHttp();
      let promise = httpRequest.request(
        this.url+"/list",
        {
          method: http.RequestMethod.POST,
          extraData: {
            "type":new_type,
            "start":this.pages1,
            "limit": this.limitNum,
          },
          header: {
            'Content-Type': 'application/json'
          }
        }).then((data)=>{
        let res = JSON.parse(data.result.toString());
        if (res.status == "success") {
          this.pages1 = this.pages1+this.limitNum
          res.newsList.forEach(element => {
            this.list1.push(new News(element.id,element.title,element.content,
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
      return this.list1;
    }else if (new_type == "社会"){
      let httpRequest = http.createHttp();
      let promise = httpRequest.request(
        this.url+"/list",
        {
          method: http.RequestMethod.POST,
          extraData: {
            "type":new_type,
            "start":this.pages2,
            "limit": this.limitNum,
          },
          header: {
            'Content-Type': 'application/json'
          }
        }).then((data)=>{
        let res = JSON.parse(data.result.toString());
        if (res.status == "success") {
          this.pages2 = this.pages2+this.limitNum
          res.newsList.forEach(element => {
            this.list2.push(new News(element.id,element.title,element.content,
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
      return this.list2;
    }else if (new_type == "政治"){
      let httpRequest = http.createHttp();
      let promise = httpRequest.request(
        this.url+"/list",
        {
          method: http.RequestMethod.POST,
          extraData: {
            "type":new_type,
            "start":this.pages3,
            "limit": this.limitNum,
          },
          header: {
            'Content-Type': 'application/json'
          }
        }).then((data)=>{
        let res = JSON.parse(data.result.toString());
        if (res.status == "success") {
          this.pages3 = this.pages3+this.limitNum
          res.newsList.forEach(element => {
            this.list3.push(new News(element.id,element.title,element.content,
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
      return this.list3;
    }else if (new_type == "科技"){
      let httpRequest = http.createHttp();
      let promise = httpRequest.request(
        this.url+"/list",
        {
          method: http.RequestMethod.POST,
          extraData: {
            "type":new_type,
            "start":this.pages4,
            "limit": this.limitNum,
          },
          header: {
            'Content-Type': 'application/json'
          }
        }).then((data)=>{
        let res = JSON.parse(data.result.toString());
        if (res.status == "success") {
          this.pages4 = this.pages4+this.limitNum
          res.newsList.forEach(element => {
            this.list4.push(new News(element.id,element.title,element.content,
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
      return this.list4;
    }else if (new_type == "体育"){
      let httpRequest = http.createHttp();
      let promise = httpRequest.request(
        this.url+"/list",
        {
          method: http.RequestMethod.POST,
          extraData: {
            "type":new_type,
            "start":this.pages5,
            "limit": this.limitNum,
          },
          header: {
            'Content-Type': 'application/json'
          }
        }).then((data)=>{
        let res = JSON.parse(data.result.toString());
        if (res.status == "success") {
          this.pages5 = this.pages5+this.limitNum
          res.newsList.forEach(element => {
            this.list5.push(new News(element.id,element.title,element.content,
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
      return this.list5;
    }else if (new_type == "文化"){
      let httpRequest = http.createHttp();
      let promise = httpRequest.request(
        this.url+"/list",
        {
          method: http.RequestMethod.POST,
          extraData: {
            "type":new_type,
            "start":this.pages6,
            "limit": this.limitNum,
          },
          header: {
            'Content-Type': 'application/json'
          }
        }).then((data)=>{
        let res = JSON.parse(data.result.toString());
        if (res.status == "success") {
          this.pages6 = this.pages6+this.limitNum
          res.newsList.forEach(element => {
            this.list6.push(new News(element.id,element.title,element.content,
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
      return this.list6;
    }else if (new_type == "作品"){
      let httpRequest = http.createHttp();
      let promise = httpRequest.request(
        this.url+"/works",
        {
          method: http.RequestMethod.POST,
          extraData: {
            "uid":AppStorage.Get("uid"),
            "start":this.pages6,
            "limit": this.limitNum,
          },
          header: {
            'Content-Type': 'application/json'
          }
        }).then((data)=>{
        let res = JSON.parse(data.result.toString());
        if (res.status == "success") {
          this.pages7 = this.pages6+this.limitNum
          res.newsList.forEach(element => {
            this.list7.push(new News(element.id,element.title,element.content,
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
      return this.list7;
    }
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End }) {
        TabContent() {
          Column() {
            Column() {
              Search({})
                .width("90%")
                .height("60%")
                .offset({y:"2%"})
                .backgroundColor("#ffffff")
                .onTouch((event: TouchEvent)=>{
                  if (event.type === TouchType.Down) {
                    router.pushUrl({
                      url:'pages/SearchNews'
                    })
                  }
                })
            }
            .width("100%")
            .height("10%")
            .backgroundColor("#289a83")
            Column(){
              Tabs() {
                TabContent() {
                  Row() {
                    UpDownRefreshCom({
                      dataList: this.list0,
                      total: 120,
                      builderDom: this.DomBuilder,
                      getDataList: (type: string) => {
                        let data = []
                        if(type === 'refresh') {
                          data = this.refreshData("热榜")
                        } else {
                          data = this.loadMoreData("热榜");
                        }
                        return data;
                      }
                    })
                  }
                  .width("100%")
                  .height("100%")
                  .backgroundColor("#ffffff")
                }
                .backgroundColor("#ffffff")
                .tabBar({ text: "热榜" })
                TabContent(){
                  Row(){
                    UpDownRefreshCom({
                      dataList: this.list1,
                      total: 120,
                      builderDom: this.DomBuilder,
                      getDataList: (type: string) => {
                        let data = []
                        if(type === 'refresh') {
                          data = this.refreshData("经济")
                        } else {
                          data = this.loadMoreData("经济");
                        }
                        return data;
                      }
                    })
                  }
                  .width("100%")
                  .height("100%")
                }
                  .backgroundColor("#ffffff")
                  .tabBar({ text: "经济" })
                TabContent(){
                  Row(){
                    UpDownRefreshCom({
                      dataList: this.list2,
                      total: 120,
                      builderDom: this.DomBuilder,
                      getDataList: (type: string) => {
                        let data = []
                        if(type === 'refresh') {
                          data = this.refreshData("社会")
                        } else {
                          data = this.loadMoreData("社会");
                        }
                        return data;
                      }
                    })
                  }
                  .width("100%")
                  .height("100%")
                }
                  .backgroundColor("#ffffff")
                  .tabBar({ text: "社会" })
                TabContent(){
                  Row(){
                    UpDownRefreshCom({
                      dataList: this.list3,
                      total: 120,
                      builderDom: this.DomBuilder,
                      getDataList: (type: string) => {
                        let data = []
                        if(type === 'refresh') {
                          data = this.refreshData("政治")
                        } else {
                          data = this.loadMoreData("政治");
                        }
                        return data;
                      }
                    })
                  }
                  .width("100%")
                  .height("100%")
                }
                  .backgroundColor("#ffffff")
                  .tabBar({ text: "政治" })
                TabContent(){
                  Row(){
                    UpDownRefreshCom({
                      dataList: this.list4,
                      total: 120,
                      builderDom: this.DomBuilder,
                      getDataList: (type: string) => {
                        let data = []
                        if(type === 'refresh') {
                          data = this.refreshData("科技")
                        } else {
                          data = this.loadMoreData("科技");
                        }
                        return data;
                      }
                    })
                  }
                  .width("100%")
                  .height("100%")
                }
                  .backgroundColor("#ffffff")
                  .tabBar({ text: "科技" })
                TabContent(){
                  Row(){
                    UpDownRefreshCom({
                      dataList: this.list5,
                      total: 120,
                      builderDom: this.DomBuilder,
                      getDataList: (type: string) => {
                        let data = []
                        if(type === 'refresh') {
                          data = this.refreshData("体育")
                        } else {
                          data = this.loadMoreData("体育");
                        }
                        return data;
                      }
                    })
                  }
                  .width("100%")
                  .height("100%")
                }
                  .backgroundColor("#ffffff")
                  .tabBar({ text: "体育" })
                TabContent(){
                  Row(){
                    UpDownRefreshCom({
                      dataList: this.list6,
                      total: 120,
                      builderDom: this.DomBuilder,
                      getDataList: (type: string) => {
                        let data = []
                        if(type === 'refresh') {
                          data = this.refreshData("文化")
                        } else {
                          data = this.loadMoreData("文化");
                        }
                        return data;
                      }
                    })
                  }
                  .width("100%")
                  .height("100%")
                }
                  .backgroundColor("#ffffff")
                  .tabBar({ text: "文化" })
              }
              .width("100%")
              .height("100%")
              .backgroundColor("#ededed")
              .barMode(BarMode.Scrollable)
              .onChange((index:number)=>{
              })
            }
            .width("100%")
            .height("90%")
          }          
          .width("100%")
          .height("100%")
        }
        .backgroundColor("#ffffff")
        .tabBar({ icon: $r('app.media.shouye'), text: "首页" })
        TabContent() {
          Column(){
            TextInput({ placeholder: "请输入标题",text:this.title})
              .width("90%")
              .height("10%")
              .backgroundColor("#ffffff")
              .onChange((value:string)=>{
                this.title = value
              })
              .onClick(()=>{
                if (this.status == "0") {
                  AlertDialog.show({
                    message:"请登录体验完整功能"
                  })
                }
              })
            Select([{ value: '经济'},
              { value: '社会'},
              { value: '政治'},
              { value: '科技'},
              { value: '体育'},
              { value: '文化'}])
              .selected(0)
              .value('新闻类别')
              .font({ size: 16, weight: 500 })
              .fontColor('#182431')
              .selectedOptionFont({ size: 16, weight: 400 })
              .optionFont({ size: 16, weight: 400 })
              .onSelect((index: number) => {
                switch (index){
                  case 0:
                    this.type = "经济"
                    break
                  case 1:
                    this.type = "社会"
                    break
                  case 2:
                    this.type = "政治"
                    break
                  case 3:
                    this.type = "科技"
                    break
                  case 4:
                    this.type = "体育"
                    break
                  case 5:
                    this.type = "文化"
                    break
                  default :
                    this.type = "经济"
                    break
                }
              })
            TextArea({
              placeholder: '请输入文本内容',
              controller: this.controller,
              text:this.context
            })
              .width("90%")
              .height("50%")
              .copyOption(CopyOptions.LocalDevice)
              .onChange((value:string)=>{
                this.context = value
              })
              .onClick(()=>{
                if (this.status == "0") {
                  AlertDialog.show({
                    message:"请登录体验完整功能"
                  })
                }
              })
            Row(){
              Image(this.img_flag == false?$r("app.media.update"):this.mediaBean.localUrl)
                .width("130vp")
                .height("100vp")
                .onClick(async ()=>{
                  if (this.status == "0") {
                    AlertDialog.show({
                      message:"请登录体验完整功能"
                    })
                  }else {
                    let mediaBean: MediaBean;
                    mediaBean = await this.mediaHelper.selectPicture();
                    if (mediaBean) {
                      this.img_flag = true
                      this.mediaBean = mediaBean;
                    }
                  }
                })
            }
            Row(){
              Button("发布")
                .onClick(()=>{
                  if (this.status == "0") {
                    AlertDialog.show({
                      message:"请登录体验完整功能"
                    })
                  }else {
                    if (this.context == "") {
                      AlertDialog.show({
                        message:"正文不能为空"
                      })
                    }else if (this.title == ""){
                      AlertDialog.show({
                        message:"标题不能为空"
                      })
                    }else {
                      this.img_flag = false
                      Upload(local,this.title,this.context,this.type,AppStorage.Get("uid"),AppStorage.Get("niChen"),AppStorage.Get("url"))
                    }
                  }
                })
            }
          }
          .width("100%")
          .height("100%")
        }
        .backgroundColor("#ffffff")
        .tabBar({ icon: $r('app.media.fabu'), text: "发布" })
        TabContent() {
          Row(){
            Column(){
              Row(){
                Column(){
                  Row(){
                    Image($r("app.media.shezhi"))
                      .height(50)
                      .width(50)
                      .borderRadius(80)
                      .backgroundColor("#959393")
                      .position({x:"80%",y:0})
                  }
                  .margin({top:20})
                  .width("100%")
                  .height("20%")
                  .onClick(()=>{
                    router.pushUrl({
                      url:"pages/SetUp"
                    })
                  })
                  Row(){
                    Image(this.touXiang)
                      .width("25%")
                      .height("100%")
                      .borderRadius(5000)
                      .borderColor("#ffffff")
                      .borderWidth(2)
                      .margin({left:30})
                    Column(){
                      Text(this.niChen)
                        .fontSize(30)
                        .fontColor("#ffffff")
                        .fontWeight(FontWeight.Bold)
                        .position({x:10})
                    }
                    .height("100%")
                    .width("70%")
                  }
                  .width("100%")
                  .height("35%")
                  .onClick(()=>{
                    if (this.status == "0") {
                      router.pushUrl({
                        url:"pages/Login"
                      })
                    }
                  })
                }
                .width("100%")
                .height("100%")
              }
              .width("100%")
              .height("35%")
              .backgroundImage($r("app.media.background"),ImageRepeat.NoRepeat)
              .backgroundImageSize(ImageSize.Cover)
              Tabs(){
                TabContent(){
                  Row(){
                    UpDownRefreshCom({
                      dataList: this.list7,
                      total: 120,
                      builderDom: this.DomBuilder,
                      getDataList: (type: string) => {
                        let data = []
                        if (this.status == "1"){
                          if(type === 'refresh') {
                            data = this.refreshData("作品")
                          } else {
                            data = this.loadMoreData("作品");
                          }
                        }
                        return data;
                      }
                    })
                  }
                  .width("100%")
                  .height("100%")
                }
                  .backgroundColor("#ffffff")
                  .tabBar({ text: "作品" })
              }
              .width("100%")
              .height("100%")
              .barMode(BarMode.Scrollable)
            }
            .width("100%")
            .height("100%")
          }
          .width("100%")
          .height("100%")
        }
        .backgroundColor("#ffffff")
        .tabBar({ icon: $r('app.media.wode'), text: "我的" })
      }      
      .width("100%")
      .height("100%")
      .borderColor("#000000")
      .backgroundColor("#289a83")
      .opacity(0.99)
      .onChange((index:number)=>{
        console.info(this.head)
      })
    }
    .width("100%")
    .height("100%")
  }
}