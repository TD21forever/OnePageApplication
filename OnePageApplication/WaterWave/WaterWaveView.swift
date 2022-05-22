//
//  WaterWaveView.swift
//  OnePageApplication
//
//  Created by T D on 2022/5/5.
//

import SwiftUI

struct WaterWaveView: View {
    var body: some View {
        ZStack{
            Color.gray.opacity(0.3).ignoresSafeArea()
            
            VStack{
                
                Image("Lorem")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding(10)
                    .background(
                        Circle()
                            .foregroundColor(.white)
                    )
                    .padding()
                
                
                    
                WaterDrop()
                
                Wave(progress: 0.5, waveHeight: 0.1)
                    .foregroundColor(.black)
                    .frame(width: 300, height: 300)
                
                Spacer()
            
            }
            
        }
    
    }
}

struct WaterDrop: View {
    
    var body: some View {
        
        ZStack{
            
            Image(systemName: "drop.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(maxWidth:.infinity, maxHeight: 400)
        }
    }
}


struct Wave: Shape{
    
    var progress: CGFloat
    var waveHeight: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: .zero)
        
//        let progressHeight: CGFloat = (1 - progress) * rect.height
//
        for value in stride(from: 0, to: rect.width, by: 2) {

            let x: CGFloat = value
            let sine: CGFloat = sin(value)
//            let y: CGFloat = progressHeight + sine * rect.height * 0.5
            let y: CGFloat = sine * 100

            path.addLine(to: CGPoint(x: x, y: y))

        }

        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        
        return path
    }
}


struct WaterWaveView_Previews: PreviewProvider {
    static var previews: some View {
        WaterWaveView()
    }
}
