export class  News{
  private id:number;
  private title:string;
  private content:string;
  private author:string;
  private date_time:string;
  private image:string;
  private new_type:string;
  private comments:number;
  private niChen:string;
  constructor(id:number,title:string,content:string,author:string,date_time:string,image:string,new_type:string,niChen:string,comments:number){
    this.id=id
    this.title=title
    this.content=content
    this.author=author
    this.date_time=date_time
    this.image=image
    this.new_type=new_type
    this.niChen=niChen
    this.comments=comments
  }
  get Id():number{
    return this.id
  }
  set Id(id:number){
    this.id=id
  }
  get Title():string{
    return this.title
  }
  set Title(title:string){
    this.title=title
  }
  get Content():string{
    return this.content
  }
  set Content(content:string){
    this.content=content
  }
  get Author():string{
    return this.author
  }
  set Author(author:string){
    this.author=author
  }
  get Date_Time():string{
    return this.date_time
  }
  set Date_Time(date_time:string){
    this.date_time=date_time
  }
  get Image():string{
    return this.image
  }
  set Image(image:string){
    this.image=image
  }
  get New_Type():string{
    return this.new_type
  }
  set New_Type(new_type:string){
    this.new_type=new_type
  }
  get Comments():number{
    return this.comments
  }
  set Comments(comments:number){
    this.comments=comments
  }
  get NiChen():string{
    return this.niChen
  }
  set NiChen(niChen:string){
    this.niChen=niChen
  }
}