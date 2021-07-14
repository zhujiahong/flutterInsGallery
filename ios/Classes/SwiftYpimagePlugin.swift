import Flutter
import UIKit
import YPImagePicker
import Photos


public class SwiftYpimagePlugin: NSObject, FlutterPlugin {
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "ypimage", binaryMessenger: registrar.messenger())
    let instance = SwiftYpimagePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
    var results:FlutterResult?;
    var images:[Any] = [] ;
    var videos:[Any] = [] ;
    
    

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//    result("iOS " + UIDevice.current.systemVersion)
    switch call.method {
    case "presentInsImage":
        self.results = result;
        btnclick()

       
        
      
    default:
      result(nil)
      
    }
  }

      func btnclick (){
        var config = YPImagePickerConfiguration()
        config.isScrollToChangeModesEnabled = true
        config.onlySquareImagesFromCamera = true
        config.usesFrontCamera = false
        config.showsPhotoFilters = true
        config.showsVideoTrimmer = true
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "DefaultYPImagePickerAlbumName"
        config.startOnScreen = YPPickerScreen.library
        config.screens = [.library, .photo,.video]
        config.showsCrop = .none
        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = true
        config.hidesBottomBar = false
        config.hidesCancelButton = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
        
        
    
//        config.filters = [DefaultYPFilters...]
        config.maxCameraZoomFactor = 1.0
        
        
        config.library.options = nil
        config.library.onlySquare = false
        config.library.isSquareByDefault = true
        config.library.minWidthForItem = nil
        config.library.mediaType = YPlibraryMediaType.photoAndVideo
        config.library.defaultMultipleSelection = false
        
        
//        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 4
        config.library.spacingBetweenItems = 1.0
        config.library.skipSelectionsGallery = false
        config.library.preselectedItems = nil
        config.library.maxNumberOfItems = 9
        let picker = YPImagePicker(configuration: config)
        
        
    
        picker.didFinishPicking { [unowned picker] items, cancelled in

            self.videos.removeAll(keepingCapacity: true)
            self.images.removeAll(keepingCapacity: true)
            
       
            
            var lastImageIndex:Int?;
            var imageNum:Int? = 0;
            var videoNum:Int? = 0;
            
            for i in 0..<items.count {
                let item = items[i]
                switch item {
                case .photo:
                    lastImageIndex = i;
                    imageNum!+=1;
                case .video:
                    videoNum!+=1;
                    continue;
                }
            }
            
            if imageNum! > 0 && videoNum! > 0 {
                let alertController = UIAlertController(title: "", message: "最多可选择九张图片或一个视频", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "确定", style: .default) { (action) in
                    print("点击了确定")
                }
                
                alertController.addAction(okAction)
              
              picker.present(alertController, animated: true, completion: nil)
                return;
            }
            
            for i in 0..<items.count {
                let item = items[i]
                
                switch item {
                case .photo(let photo):
//                    if photo.fromCamera {
                    let imageData = photo.image.jpegData(compressionQuality: 1)
                    self.images.append(imageData!);
                    if i == items.count - 1 {
                  
                        let retDic:Dictionary = ["images":self.images,"videos":self.videos]
                                               print(retDic)
                                               if self.results != nil {
                                                   self.results!(retDic)
                                               }
                    }
             


                    
                    
                    
                case .video(let video):
                 
                    print(video.url.absoluteString)
                    self.videos.append(video.url.absoluteString)
                    if i == items.count - 1 {
                        let retDic:Dictionary = ["images":self.images,"videos":self.videos]
                                               print(retDic)
                                               if self.results != nil {
                                                   self.results!(retDic)
                                               }
                    }

                }
            
            
         
            }
            
//            let retDic:Dictionary = ["images":self.images,"videos":self.videos]
//            print(retDic)
//            if self.results != nil {
//                self.results!(retDic)
//            }
            
//            self.results!("hahahahaha")
       
            picker.dismiss(animated: true, completion: nil)
        }
        
       
        
        let vc = UIApplication.shared.keyWindow?.rootViewController
        vc?.present(picker, animated: true, completion: nil)
        
//        let fluttervc:UIViewController = UIApplication.shared.delegate?.window
//        fluttervc.present(picker, animated: true, completion: nil)
    }
    
    func numAlert(){
    
      }
  
    
    
}

extension PHAsset {
    var originalFilename: String? {
        return PHAssetResource.assetResources(for: self).first?.originalFilename
    }
    
    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
}
