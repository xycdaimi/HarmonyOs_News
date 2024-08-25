import common from '@ohos.app.ability.common';
import picker from '@ohos.file.picker';
import mediaLibrary from '@ohos.multimedia.mediaLibrary';
import wantConstant from '@ohos.ability.wantConstant';
import fs from '@ohos.file.fs';
import util from '@ohos.util';
import image from '@ohos.multimedia.image';
import { MediaBean } from '../bean/MediaBean';
import Fetch from '@system.fetch';
import http from '@ohos.net.http';
import { User } from '../User/User';
import router from '@ohos.router';
// import { StringUtils } from '../utils/StringUtils';
// import { Log } from '../utils/Log';
export let local = "";
export function UploadUser(userAvatar:any,user:any,url:any) {
  console.log('uploadImage:fileuri:' + userAvatar);
  if (local!=""){
    fs.open(userAvatar, fs.OpenMode.READ_ONLY).then((file) => {
      console.info("uploadImage:file fd: " + file.fd);
      const imageSource = image.createImageSource(file.fd);
      const imagePackerApi: image.ImagePacker = image.createImagePacker();
      let packOpts: image.PackingOption = { format: 'image/jpeg', quality: 30 };
      imagePackerApi.packing(imageSource, packOpts).then((readBuffer) => {
        let bufferArr = new Uint8Array(readBuffer)
        let help = new util.Base64Helper
        var base = help.encodeToStringSync(bufferArr)
        console.info("uploadImage:base is : " + base);
        let httpRequest = http.createHttp();
        let promise = httpRequest.request(
          url+"/change",
          {
            method: http.RequestMethod.POST,
            extraData: {
              "user":user,
              "base":base
            },
            header: {
              'Content-Type': 'application/json'
            }
          }).then((data)=>{
          let res = JSON.parse(data.result.toString());
          if (res.status == "success") {
            local=""
            AppStorage.SetOrCreate('password',res.user.password)
            AppStorage.SetOrCreate('phone',res.user.phone)
            AppStorage.SetOrCreate('email',res.user.email)
            AppStorage.SetOrCreate('niChen',res.user.avatar)
            AppStorage.SetOrCreate('role',res.user.role)
            AppStorage.SetOrCreate('sex',res.user.sex)
            AppStorage.SetOrCreate('head',res.user.head)
            AppStorage.Set("status","1")
            AlertDialog.show({
              message:"修改成功",
              cancel:()=>{
                router.replaceUrl({
                  url:"pages/Index"
                })
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
      });
    }).catch((err) => {
      console.info("uploadImage:copy file failed with error message: " + err.message + ", error code: " + err.code);
    });
  }else {
    var base = ""
    let httpRequest = http.createHttp();
    let promise = httpRequest.request(
      url+"/change",
      {
        method: http.RequestMethod.POST,
        extraData: {
          "user":user,
          "base":base
        },
        header: {
          'Content-Type': 'application/json'
        }
      }).then((data)=>{
      let res = JSON.parse(data.result.toString());
      if (res.status == "success") {
        local=""
        AppStorage.SetOrCreate('password',res.user.password)
        AppStorage.SetOrCreate('phone',res.user.phone)
        AppStorage.SetOrCreate('email',res.user.email)
        AppStorage.SetOrCreate('niChen',res.user.avatar)
        AppStorage.SetOrCreate('role',res.user.role)
        AppStorage.SetOrCreate('sex',res.user.sex)
        AppStorage.SetOrCreate('head',res.user.head)
        AppStorage.Set("status","1")
        AlertDialog.show({
          message:"修改成功",
          cancel:()=>{
            router.replaceUrl({
              url:"pages/Index"
            })
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
  }
}
export function Upload(userAvatar:any,title:any,context:any,type:any,uid:any,niChen:any,url:any) {
  console.log('uploadImage:fileuri:' + userAvatar);
  if (local!=""){
    fs.open(userAvatar, fs.OpenMode.READ_ONLY).then((file) => {
      console.info("uploadImage:file fd: " + file.fd);
      const imageSource = image.createImageSource(file.fd);
      const imagePackerApi: image.ImagePacker = image.createImagePacker();
      let packOpts: image.PackingOption = { format: 'image/jpeg', quality: 30 };
      imagePackerApi.packing(imageSource, packOpts).then((readBuffer) => {
        let bufferArr = new Uint8Array(readBuffer)
        let help = new util.Base64Helper
        var base = help.encodeToStringSync(bufferArr)
        console.info("uploadImage:base is : " + base);
        let httpRequest = http.createHttp();
        let promise = httpRequest.request(
          url+"/upload",
          {
            method: http.RequestMethod.POST,
            extraData: {
              "image":base,
              "context":context,
              "title":title,
              "type":type,
              "uid":uid,
              "niChen":niChen
            },
            header: {
              'Content-Type': 'application/json'
            }
          }).then((data)=>{
          let res = JSON.parse(data.result.toString());
          if (res.status == "success") {
            local = ""
            AlertDialog.show({
              message:"发布成功",
              cancel:()=>{
                router.replaceUrl({
                  url:"pages/Index"
                })
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
      });
    }).catch((err) => {
      console.info("uploadImage:copy file failed with error message: " + err.message + ", error code: " + err.code);
    });
  }else {
    var base = ""
    let httpRequest = http.createHttp();
    let promise = httpRequest.request(
      url+"/upload",
      {
        method: http.RequestMethod.POST,
        extraData: {
          "image":base,
          "context":context,
          "title":title,
          "type":type,
          "uid":uid,
          "niChen":niChen
        },
        header: {
          'Content-Type': 'application/json'
        }
      }).then((data)=>{
      let res = JSON.parse(data.result.toString());
      if (res.status == "success") {
        local = ""
        AlertDialog.show({
          message:"发布成功",
          cancel:()=>{
            router.replaceUrl({
              url:"pages/Index"
            })
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
  }
}
/**
 * 多媒体辅助类
 */
export class MediaHelper {
  private readonly TAG: string = 'MediaHelper';

  private mContext: common.Context;

  constructor(context: common.Context) {
    this.mContext = context;
  }

  /**
   * 选择图片
   */
  public selectPicture(): Promise<MediaBean> {

    try {
      let photoSelectOptions = new picker.PhotoSelectOptions();
      photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
      photoSelectOptions.maxSelectNumber = 1;
      let photoPicker = new picker.PhotoViewPicker();
      return photoPicker.select(photoSelectOptions)
        .then((photoSelectResult) => {
          if (photoSelectResult && photoSelectResult.photoUris && photoSelectResult.photoUris.length > 0) {
            let filePath = photoSelectResult.photoUris[0];
            local = filePath
            return filePath;
          }
        }).catch((err) => {
          return err;
        }).then(async (filePath) => {
          const mediaBean = await this.buildMediaBean(filePath);
          return mediaBean;
        });
    } catch (err) {
      //Log.error(this.TAG, 'PhotoViewPicker failed with err: ' + err);
      return Promise.reject(err);
    }
  }

  /**
   * 选择文件
   */
  public selectFile(): Promise<MediaBean> {
    try {
      let documentSelectOptions = new picker.DocumentSelectOptions();
      let documentPicker = new picker.DocumentViewPicker();
      return documentPicker.select(documentSelectOptions)
        .then((documentSelectResult) => {
          //Log.info(this.TAG, 'DocumentViewPicker.select successfully, DocumentSelectResult uri: ' + JSON.stringify(documentSelectResult));

          if (documentSelectResult && documentSelectResult.length > 0) {
            let filePath = documentSelectResult[0];
            //Log.info(this.TAG, 'DocumentViewPicker.select successfully, DocumentSelectResult uri: ' + filePath);
            return filePath;
          }

        }).catch((err) => {
          //Log.error(this.TAG, 'PhotoViewPicker.select failed with err: ' + err);
          return err;
        }).then(async (filePath) => {

          const mediaBean = await this.buildMediaBean(filePath);
          return mediaBean;

        });
    } catch (err) {
      //Log.error(this.TAG, 'PhotoViewPicker failed with err: ' + err);
      return Promise.reject(err);
    }
  }

  /**
   * 拍照
   */
  public async takePhoto(context: common.UIAbilityContext): Promise<MediaBean> {

    let want = {
      'uri': '',
      'action': wantConstant.Action.ACTION_IMAGE_CAPTURE,
      'parameters': {},
    };
    return context.startAbilityForResult(want)
      .then((result) => {
        //Log.info(this.TAG, `startAbility call back , ${JSON.stringify(result)}`);
        if (result.resultCode === 0 && result.want && (result.want.uri == null || result.want.uri == "")) {
          //拍照成功
          //Log.info(this.TAG, 'takePhoto successfully, takePhotoResult uri: ' + result.want.uri);
          return result.want.uri;
        }
      }).catch((error) => {
        //Log.info(this.TAG, `startAbility error , ${JSON.stringify(error)}`);
        return error;
      }).then(async (uri: string) => {
        const mediaBean = await this.buildMediaBean(uri);
        return mediaBean;
      });
  }

  /**
   * 封装多媒体实体类
   *
   * @param uri 文件路径
   */
  private async buildMediaBean(uri: string): Promise<MediaBean> {

    if (uri == null || uri == "") {
      return null;
    }

    const mediaBean: MediaBean = new MediaBean();
    mediaBean.localUrl = uri;
    await this.appendFileInfoToMediaBean(mediaBean, uri);
    return mediaBean;
  }

  /**
   * 通过Uri查找所选文件信息，插入到MediaBean中
   * @param mediaBean
   * @param uri
   */
  private async appendFileInfoToMediaBean(mediaBean: MediaBean, uri: string) {

    if (uri == null || uri == "") {
      return;
    }
    let fileList: Array<mediaLibrary.FileAsset> = [];

    const parts: string[] = uri.split('/');
    const id: string = parts.length > 0 ? parts[parts.length - 1] : '-1';

    try {

      let media = mediaLibrary.getMediaLibrary(this.mContext);
      let mediaFetchOptions: mediaLibrary.MediaFetchOptions = {
        selections: mediaLibrary.FileKey.ID + '= ?',
        selectionArgs: [id],
        uri: uri
      };

      let fetchFileResult = await media.getFileAssets(mediaFetchOptions);
      //Log.info(this.TAG, `fileList getFileAssetsFromType fetchFileResult.count = ${fetchFileResult.getCount()}`);
      fileList = await fetchFileResult.getAllObject();
      fetchFileResult.close();
      await media.release();

    } catch (e) {
      //Log.error(this.TAG, "query: file data  exception ");
    }

    if (fileList && fileList.length > 0) {

      let fileInfoObj = fileList[0];
      //Log.info(this.TAG, `file id = ${JSON.stringify(fileInfoObj.id)} , uri = ${JSON.stringify(fileInfoObj.uri)}`);
      //Log.info(this.TAG, `file fileList displayName = ${fileInfoObj.displayName} ,size = ${fileInfoObj.size} ,mimeType = ${fileInfoObj.mimeType}`);

      mediaBean.fileName = fileInfoObj.displayName;
      mediaBean.fileSize = fileInfoObj.size;
      mediaBean.fileType = fileInfoObj.mimeType;

    }
  }
}

