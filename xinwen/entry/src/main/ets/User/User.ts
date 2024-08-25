export enum Role {
  ADMIN, USER
}
export enum Sex {
  MALE, FEMALE
}
export class User{
  private uid:string
  private username:string
  private password:string
  private rePassword:string
  private phone:string
  private email:string
  private niChen:string
  private role:Role
  private sex:Sex
  private head:string

  constructor(username:string="",password:string="",rePassword:string="",phone:string="",email:string="",niChen:string="",role:Role=Role.USER,sex:Sex=Sex.MALE,head:string="tou.jpg",uid:string=""){
    this.username=username
    this.uid=uid
    this.password=password
    this.rePassword=rePassword
    this.phone=phone
    this.email=email
    this.niChen=niChen
    this.role=role
    this.sex=sex
    this.head=head
  }
  get Uid():string{
    return this.uid
  }
  get Username():string{
    return this.username
  }
  get Password():string{
    return this.password
  }
  get RePassword():string{
    return this.rePassword
  }
  get Phone():string{
    return this.phone
  }
  get Email():string{
    return this.email
  }
  get NiChen():string{
    return this.niChen
  }
  get Role_value():Role{
    return this.role
  }
  get Sex_value():Sex{
    return this.sex
  }
  set Role_value(role:Role){
    this.role=role
  }
  set Sex_value(sex:Sex){
    this.sex=sex
  }
  set Username(username:string){
    this.username=username
  }
  set Password(password:string){
    this.password=password
  }
  set RePassword(rePassword:string){
    this.rePassword=rePassword
  }
  set Phone(phone:string){
    this.phone=phone
  }
  set Email(email:string){
    this.email=email
  }
  set NiChen(niChen:string){
    this.niChen=niChen
  }
  get Head():string{
    return this.head
  }
  set Head(head:string){
    this.head=head
  }
  set Uid(uid:string){
    this.uid=uid
  }
}