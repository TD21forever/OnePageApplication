//
//  EmojiRating.swift
//  OnePageApplication
//
//  Created by T D on 2022/4/24.
//

import SwiftUI
import Lottie

struct EmojiRating: View {
    let jsonFile = "emoji"
    @State var currentSlideProgress:CGFloat = 0.5
    @GestureState var isDragging:Bool = false
    @State var dragOffset:CGFloat = 0
    var body: some View {
        
       
        
        VStack{

            Text(getAttributedString())
                .font(.system(size: 45))
                .fontWeight(.medium)
                .kerning(1.1)
                .padding(.top)
            
            LottieAnimationView(jsonFile: jsonFile, progress: $currentSlideProgress)
                .scaleEffect(1.2)
            
            Spacer()

            ZStack{
                
                Rectangle()
                    .foregroundColor(.white)
                    .frame(height:1)
                    
                Group{
                    
                    
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.black)
                        .frame(width: 55, height: 55)
                    
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 11, height: 11)
                    
                }
                .frame(maxWidth:.infinity,alignment: .center)
                .offset(x: dragOffset)
                .gesture(
                    
                    DragGesture(minimumDistance: 5)
                        .updating($isDragging, body: { _, out, _ in
                            out = true
                        })
                        .onChanged({ value in
                            
                            
                            var translation = value.location.x
                            let width = (UIScreen.main.bounds.width - 30)
                            print(translation)
                            translation = (translation > 27) ? translation : 27
                            translation = (translation < width - 27) ? translation : (width - 27)
                            translation = isDragging ? translation : 0
                            
                            dragOffset = translation - width / 2
                            
                            
                            let progress = (translation - 27) / (width - 27)
                            
                            currentSlideProgress = progress
                            
                            
                        })
                
                )
               
            }
            .offset(y: -10)
            
            
            Button {

            } label: {
                Text("Done 👍🏻")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.vertical,25)
                    .frame(maxWidth:.infinity)
                    .background(

                        Rectangle()
                            .cornerRadius(25)
                            .foregroundColor(.black)

                    )
                    .padding()
            }
            
            Spacer(minLength: 0)

        }
        .padding(15)
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .background(

            LinearGradient(colors: [


                Color.red.opacity(0.9),
                Color.orange.opacity(0.9),
                Color.orange.opacity(0.9),
                Color.orange.opacity(0.8),

            ],
           startPoint: .top,
           endPoint: .bottom).ignoresSafeArea()
        )
        
    }
    private func getAttributedString()->AttributedString{
        var str = AttributedString("How was \nyour Day?")
        if let range = str.range(of: "Day?"){
            str[range].foregroundColor = .white
        }
        return str
    }
}


struct EmojiRating_Previews: PreviewProvider {
    static var previews: some View {
        EmojiRating()
    }
}

struct LottieAnimationView: UIViewRepresentable{
    
    var jsonFile:String
    @Binding var progress:CGFloat

    func makeUIView(context: Context) -> some UIView {
        
        let rootView = UIView()
    
        addAnimationView(rootView: rootView)
        
        return rootView
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // 从SwiftUI 到 UIKit
        uiView.subviews.forEach { view in
            if view.tag == 1009 {
                
                view.removeFromSuperview()
            }
        }
        addAnimationView(rootView: uiView)
    }
    
    func addAnimationView(rootView:UIView){
     
        let animationView =  AnimationView(name: jsonFile, bundle: .main)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        animationView.tag = 1009
        
        let constraints = [
        
            animationView.widthAnchor.constraint(equalTo: rootView.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: rootView.heightAnchor),
 
        ]
        
        animationView.currentProgress = progress / 2 + 0.49
        
        rootView.addSubview(animationView)
        rootView.addConstraints(constraints)
        
    }
    
    
}
