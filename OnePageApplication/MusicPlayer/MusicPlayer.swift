//
//  MusicPlayer.swift
//  OnePageApplication
//
//  Created by T D on 2022/4/14.
//

import SwiftUI
import AVKit


struct MusicPlayer: View {
    @State var audioPlayer:AVAudioPlayer? = nil
    @State var isPlaying:Bool = false
    @State var progressPercentage:Double = 0
    @State var audioTitle:String = ""
    @State var audioImageData:Data? = nil
    @State var audioIndex:Int = 0
    let del = AVDelegate()
    let audioNameList:[String] = ["bad","black"]
    let timer = Timer.TimerPublisher(interval: 0.2, runLoop: .main, mode: .default).autoconnect()
    let applicationWidth = UIScreen.main.bounds.width - 30
    
    var body: some View {
        NavigationView{
            
            VStack(spacing:20){
                                
                centerImageView
                    
                Text(audioTitle)
                    .font(.title)

                progressBarView
                
                controlButtonsView

                
            }
            .padding()
            .onAppear {
                initPlayer()
                
                getAudioAsset()
                
                NotificationCenter.default.addObserver(forName: Notification.Name("Finished"), object: nil, queue: .main) { _ in
                    isPlaying = false
                    progressPercentage = 0
                    audioPlayer?.currentTime = 0
                }
            }
            .onReceive(timer) { _ in
                updateProgressBar()
            }
            .navigationTitle("Music Player")
        }
      
    }
}

extension MusicPlayer{
    
    private func updateProgressBar(){
        
        if isPlaying{
            
            guard
                let currentTime = audioPlayer?.currentTime,
                let totalTime = audioPlayer?.duration
            else{
                return
            }
            progressPercentage = currentTime / totalTime
        }
    }
    
    private var progressBarView :some View{
        
        ZStack(alignment:.leading){
            Capsule()
                .frame(width:applicationWidth, height: 8)
                .foregroundColor(Color.primary.opacity(0.1))
            Capsule()
                .frame(width: (applicationWidth) * progressPercentage, height: 8)
                .foregroundColor(Color.red)
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            let x = value.location.x
                            progressPercentage = x / applicationWidth
                })
                        .onEnded({ value in
                            let x = value.location.x
                            progressPercentage = x / applicationWidth
                            audioPlayer?.currentTime = (audioPlayer?.duration ?? 0) * progressPercentage
                        })
                )
        }
    }
    
    private var controlButtonsView :some View{
        HStack(spacing:applicationWidth / 5 - 30){
            Button {
                if audioIndex != 0 {
                    audioIndex -= 1
                    changeSongs()
                }
            } label: {
                Image(systemName: "backward.fill")
            }
            
            Button {
                if let audioPlayer = audioPlayer,audioPlayer.currentTime - 15 >= 0{
                    audioPlayer.currentTime -= 15
                }
            } label: {
                Image(systemName: "gobackward.15")
            }
            
            Button {
                withAnimation(.default) {
                    isPlaying.toggle()
                    print(isPlaying)
                }
                if isPlaying {
                   
                    audioPlayer?.play()
                }
                else{
                    audioPlayer?.pause()
                }
          
                
            } label: {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
            }
            
            Button {
                if let audioPlayer = audioPlayer,audioPlayer.currentTime + 15 <= audioPlayer.duration{
                    audioPlayer.currentTime += 15
                }
            } label: {
                Image(systemName: "goforward.15")
            }
            Button {
                if audioIndex != audioNameList.count - 1{
                    audioIndex += 1
                    changeSongs()
                }
            } label: {
                Image(systemName: "forward.fill")
            }

        }
        .font(.title)
        .foregroundColor(.primary)
    }
    
    private var centerImageView : some View{
        ZStack{
            if  let audioImageData = audioImageData,
                let audioImage = UIImage(data: audioImageData){
                Image(uiImage: audioImage)
                    .resizable()
                    .frame(height: 250)
                    .cornerRadius(15)
            }
            else{
                Image("itunes")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .cornerRadius(15)
            }
        }
    }
    // 初始化播放器
    private func initPlayer(){
        
        guard let audioPath = Bundle.main.path(forResource: audioNameList[audioIndex], ofType: ".mp3") else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
            audioPlayer?.prepareToPlay()
            audioPlayer?.delegate = del
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func getAudioAsset(){
        
      
        guard let audioPath = audioPlayer?.url else { return }
        let audioAsset = AVAsset(url:audioPath)
  
        
        for item in audioAsset.commonMetadata{
            // title type albumNane artist artwork
            guard let itemValue = item.commonKey?.rawValue else {return}
            if itemValue == "title"{
                
                audioTitle = item.value as? String ?? ""
            }
            else if itemValue == "artwork"{
                print(itemValue)
                audioImageData = item.value as? Data ?? Data(count: 0)
            }
        }
    }
    
    private func changeSongs(){
        audioTitle = ""
        isPlaying = false
        progressPercentage = 0
        audioImageData = nil
        
        initPlayer()
        getAudioAsset()
        
    }
    
}

class AVDelegate: NSObject, AVAudioPlayerDelegate{
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        NotificationCenter.default.post(name:  Notification.Name("Finished"), object: nil)
        
    }
}

struct MusicPlayer_Previews: PreviewProvider {
    static var previews: some View {
        
            MusicPlayer()
        
    }
}
