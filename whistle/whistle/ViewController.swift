//
//  ViewController.swift
//  LoadWebData
//
//  Created by midoks on 15/3/9.
//  Copyright (c) 2015年 midoks. All rights reserved.
//


//模仿的APP地址:http://www.zhihu.com/question/25284456
//感觉简单并非常有意思


import UIKit
import Foundation
import AVFoundation


class ViewController: UIViewController , AVAudioPlayerDelegate, AVAudioRecorderDelegate,
MusicListTableViewDelegate, MusicAlertPageViewDelegate,UIActionSheetDelegate{
    
    var player_1:AVAudioPlayer? = nil
    var player:AVAudioPlayer?
    var recorder:AVAudioRecorder?
    
    var clickButton: UIButton!
    
    var playChoose: UISegmentedControl!
    
    var currentSong:NSInteger! = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //获取view的宽度
        var viewW = self.view.bounds.size.width/2;
        
        //展示
        var showText = UILabel(frame: CGRectMake(viewW, 50, self.view.bounds.size.width, 100))
        showText.center = CGPoint(x:viewW, y:showText.frame.origin.y)
        showText.text = "吹完你就尿"
        showText.font = UIFont(name: "", size: 26.0);
        showText.textAlignment = NSTextAlignment.Center
        
        showText.shadowColor = UIColor.grayColor()
        showText.shadowOffset = CGSizeMake(0, 1)
        self.view.addSubview(showText)
        
        //建立button
        clickButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton;
        clickButton.frame = CGRectMake(viewW, 100, 180, 180)
        clickButton.center = CGPoint(x: viewW, y: showText.frame.size.height + 70.0)
        clickButton.backgroundColor = UIColor.redColor()
        clickButton.setTitle("吹", forState: UIControlState.Normal)
        clickButton.titleLabel?.font = UIFont(name: "", size: 30.0)
        clickButton.addTarget(self, action: Selector("clickButton:"), forControlEvents: UIControlEvents.TouchUpInside)
        clickButton.layer.cornerRadius = 90
        clickButton.layer.masksToBounds = true
        clickButton.alpha = 0.8
        self.view.addSubview(clickButton)
        
        //排列播放表
        var listView = MusicListTableView(frame: CGRectMake(0, 0, self.view.bounds.size.width, 60))
        listView.center = CGPoint(x: viewW, y: clickButton.center.y + 150)
        listView.backgroundColor = UIColor.clearColor()
        listView.start()
        listView.delegate = self
        self.view.addSubview(listView)
        
        //播放的方式
        var playChooseItem = ["单曲播放","循序播放","随机播放"]
        playChoose = UISegmentedControl(items: playChooseItem)
        playChoose.center = CGPoint( x:self.view.center.x, y:self.view.bounds.size.height - 40)
        playChoose.selectedSegmentIndex = 1
        self.view.addSubview(playChoose)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //播放音乐
    func clickButton(button: UIButton)
    {
        var name = clickButton.titleLabel?.text
        if(name == "吹"){
            //NSLog("%@", "song")
            RecondPay(0)
            clickButton.setTitle("停止", forState: UIControlState.Normal)
        }else{
            //NSLog("%@", "unsong")
            player?.currentTime = 0
            player?.stop()
            clickButton.setTitle("吹", forState: UIControlState.Normal)
        }
    }
    
    //录制声音
    func audio_setting(pos:NSInteger){
        var setting = NSMutableDictionary()
        //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
        setting.setValue(NSNumber(integer:kAudioFormatMPEG4AAC), forKey: AVFormatIDKey)
        //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000(影响音频的质量)
        setting.setValue(NSNumber(float:44100), forKey: AVSampleRateKey)
        //录音通道数  1 或 2
        setting.setValue(NSNumber(integer: 1), forKey: AVNumberOfChannelsKey)
        //线性采样位数  8、16、24、32
        setting.setValue(NSNumber(integer: 16), forKey: AVLinearPCMBitDepthKey)
        
        //录音的质量
        //setting.setValue(NSNumber(int: AVAudioQuality.High), forKey: AVEncoderAudioQualityKey)
        
        //NSLog("%@", setting)
        
        //NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        //var strUrl:AnyObject? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.AllApplicationsDirectory, NSSearchPathDomainMask.AllDomainsMask, true).last!
        //NSLog("%@", strUrl)
        
        var urlt:NSURL = NSBundle.mainBundle().sharedSupportURL!
        var fm = NSFileManager()
        
        if(fm.fileExistsAtPath(urlt.path!)){
            NSLog("文件存在")
            fm.removeItemAtPath(NSString(format:"%@/md_%d.aac", urlt.path!, pos) as String, error: nil)
        }else{
            NSLog("文件不存在")
            NSLog("%@", urlt.path!)
            fm.createDirectoryAtPath(urlt.path!, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
        
        var stt = NSString(format:"%@/md_%d.aac", urlt.path!, pos)
        var url:NSURL! = NSURL(fileURLWithPath: stt as String)
        var error:NSError?
        
        recorder = AVAudioRecorder(URL:url, settings: setting as [NSObject : AnyObject], error: &error)
        recorder!.delegate = self
        recorder!.meteringEnabled = true
    }
    
    
    func loadSound(filename:NSString, ext:NSString){
        let url = NSBundle.mainBundle().URLForResource(filename as String, withExtension: ext as String)
        //var error:NSError? = nil
        
        if(url != nil){
            NSLog("%@", url!)
            
            var data = NSData(contentsOfURL: url!)
            //NSLog("%@", data!)
            player = AVAudioPlayer(data: data!, error: nil)
            player!.delegate = self
            player!.numberOfLoops = 0
            player!.volume = 1.0
        }else{
            NSLog("没有找到")
        }
    }
    
    func loadSound2(abspath: NSString){
        var urlt:NSURL = NSBundle.mainBundle().sharedSupportURL!
        var stt = NSString(format:"%@/%@", urlt.path!, abspath)
        var url:NSURL! = NSURL(fileURLWithPath: stt as String)
        var data = NSData(contentsOfURL: url!)
        
        //NSLog("%@", data!)
        player = AVAudioPlayer(data: data!, error: nil)
        player!.delegate = self
        player!.numberOfLoops = 0
        player!.volume = 1.0
    }
    
    func sound(filename:NSString){
        player?.play()
    }
    
    //AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool){
        
        NSLog("%d", playChoose.selectedSegmentIndex)
        switch(playChoose.selectedSegmentIndex){
        case 0:player.play();break;
        case 1:listPlay();break;
        case 2:finishRandomPlay();break;
        default:
            clickButton.setTitle("吹", forState: UIControlState.Normal)
            break;
        }
    }
    
    //顺序播放
    func listPlay(){
        var pos = currentSong
        pos = pos + 1
        if(pos>3){pos = 0;}
        RecondPay(pos)
    }
    
    //随机播放
    func finishRandomPlay(){
        let value:UInt32 = 4
        let random:UInt32 = arc4random_uniform(value)
        var pos = NSInteger(random)
        RecondPay(pos)
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!){
        NSLog("error")
    }
    
    
    func MusicClick(selfObj: MusicListTableView, pos: NSInteger) {
        
        var actionSheet = UIActionSheet()
        actionSheet.delegate = self
        actionSheet.title = "请选择操作"
        actionSheet.addButtonWithTitle("播放")
        actionSheet.addButtonWithTitle("重新录制")
        //清空重新录制的音频文件
        actionSheet.addButtonWithTitle("清空录制")
        actionSheet.addButtonWithTitle("取消")
        actionSheet.showInView(self.view)
        actionSheet.tag = pos;
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        //NSLog("%d", buttonIndex)
        //NSLog("%d", actionSheet.tag)
        switch(buttonIndex){
            //播放按钮
        case 0: RecondPay(actionSheet.tag);break;
        case 1: RecondSound(actionSheet.tag);break;
        case 2: RecondDelete(actionSheet.tag);break;
        default:break;
        }
    }
    
    //播放
    func RecondPay(pos: NSInteger){
        
        currentSong = pos
        //NSLog("播放:%d", pos)
        
        var urlt:NSURL = NSBundle.mainBundle().sharedSupportURL!
        var fm = NSFileManager()
        var stt = NSString(format:"%@/md_%d.aac", urlt.path!, pos)
        
        //首先播放自己的录制了。。。
        if(fm.fileExistsAtPath(stt as String)){
            var stt0 = NSString(format: "md_%d.aac", pos)
            loadSound2(stt0)
            sound(stt0)
        }else{
            var stt2 = NSString(format: "sc_%d", pos);
            loadSound(stt2, ext: "wav")
            sound(stt2)
        }
        clickButton.setTitle("停止", forState: UIControlState.Normal)
    }
    
    //重新录制
    func RecondSound(pos:NSInteger){
        var sound = MusicAlertPageView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.frame.height))
        sound.start()
        sound.delegate = self
        self.view.addSubview(sound)
        self.audio_setting(pos)
    }
    
    //删除重新录制的
    func RecondDelete(pos:NSInteger){
        var urlt:NSURL = NSBundle.mainBundle().sharedSupportURL!
        var fm = NSFileManager()
        var stt = NSString(format:"%@/md_%d.aac", urlt.path!, pos)
        
        if(fm.fileExistsAtPath(stt as String)){
            fm.removeItemAtPath(stt as String, error: nil)
        }
        //        NSLog("url:%@", stt)
        //        NSLog("删除:%d", pos)
    }
    
    //开始录制
    func MusicAlertPageViewStart(selfObj: MusicAlertPageView, pos: NSInteger) {
        recorder?.prepareToRecord()
        recorder?.record()
    }
    
    //停止录制
    func MusicAlertPageViewEnd(selfObj: MusicAlertPageView, pos: NSInteger) {
        recorder?.stop()
    }
    
    //录音结束
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool){
        NSLog("录音结束")
    }
    
}

