export class Comment{
  private id:number
  private new_id:number
  private uid:string
  private context:string
  private create_time:string
  private niChen:string
  constructor(id:number=0,new_id:number=0,uid:string="",context:string="",create_time:string="",niChen:string){
    this.id=id
    this.new_id=new_id
    this.uid=uid
    this.context=context
    this.create_time=create_time
    this.niChen=niChen
  }
  get NiChen():string{
    return this.niChen
  }
  get Id():number{
    return this.id
  }
  get New_Id():number{
    return this.new_id
  }
  get Uid():string{
    return this.uid
  }
  get Context():string{
    return this.context
  }
  get Create_Time():string{
    return this.create_time
  }
  set Id(id:number){
    this.id=id
  }
  set NiChen(niChen:string){
    this.niChen=niChen
  }
  set New_Id(new_id:number){
    this.new_id=new_id
  }
  set Uid(uid:string){
    this.uid=uid
  }
  set Context(context:string){
    this.context=context
  }
  set Create_Time(create_time:string){
    this.create_time=create_time
  }
}