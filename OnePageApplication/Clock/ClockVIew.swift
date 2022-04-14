//
//  ClockVIew.swift
//  OnePageApplication
//
//  Created by T D on 2022/4/11.
//

import SwiftUI

struct ClockVIew: View {
    @State var isDarkMode:Bool = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var now = Now(hour: 0, minute: 0, second: 0)
    private let width = UIScreen.main.bounds.width

    
    var body: some View {
        NavigationView{
            VStack{

                header
                    .padding()
                
                Spacer()
                
                clock
                    
                
                Text(Locale.current.localizedString(forRegionCode: Locale.current.regionCode!) ?? "")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding(.top,30)

                currentDate
                    
                
                Spacer(minLength: 0)
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .navigationBarHidden(true)
            .onAppear(){
                now = getNow()
            }
            .onReceive(timer) { data in
                withAnimation(Animation.linear(duration: 0.01)){
                    now = getNow()
                }
            }
        }
     
    }

}


struct Now{
    var hour:Int
    var minute:Int
    var second:Int
}

extension ClockVIew{
    
    private func getNow()->Now{
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let min = calendar.component(.minute, from: date)
        let sec = calendar.component(.second, from: date)
        return Now(hour: hour, minute: min, second: sec)

    }
    private var currentDate: some View{
        HStack{
            
            Text(getDate())
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(Color.clock.accent)
                .padding()
        }
    }
    private var clock: some View{
        
        ZStack{
            
            Circle()
                .fill(Color.clock.accent.opacity(0.1))
                .frame(width: width-80, height: width-80)
            
            ForEach(0..<60, id: \.self) { i in
                Rectangle()
                    .foregroundColor(.clock.accent)
                    .frame(width: 2, height: i % 5 == 0 ? 15 : 5)
                    .offset(y: (width - 110) / 2)
                    .rotationEffect(Angle(degrees: Double(i * 6)))
                    
            }
            
            Circle()
                .frame(width: 15, height: 15)
                .foregroundColor(.primary)
            
            pointers
                
        }
    }
    
    private var pointers: some View{
        
        ZStack{
            
            // sec
            Rectangle()
                .frame(width: 3, height: (width - 180 ) / 2)
                .offset(y: -(width - 180 ) / 4)
                .foregroundColor(.clock.accent)
                .rotationEffect(Angle(degrees: Double(now.second) * 6))
            // min
            Rectangle()
                .frame(width: 5, height: (width - 200 ) / 2)
                .offset(y: -(width - 200 ) / 4)
                .rotationEffect(Angle(degrees: Double(now.minute) * 6))
                .foregroundColor(.clock.accent)
            // hour
            Rectangle()
                .frame(width: 5, height: (width - 260 ) / 2)
                .offset(y: -(width - 260 ) / 4)
                
                .rotationEffect(Angle(degrees:(Double(now.minute)/60 + Double(now.hour)) * 30))
                .foregroundColor(.clock.accent)
        }
       
    }
    
    private func getDate()->String{
        return dataFormater.string(from: Date())
    }
    
    private var dataFormater:DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }
    
    private var header: some View{
        HStack{
            Text("OnePageClock")
                .font(.title)
                .fontWeight(.heavy)
            Spacer()
            Button {
                isDarkMode.toggle()
            } label: {
                Image(systemName: isDarkMode ? "sun.min.fill" : "moon.fill")
                    .font(.title)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 30, height: 30)
                    .foregroundColor(isDarkMode ? .black : .white)
                    .padding()
                    .background(Color.primary)
                    .clipShape(Circle())
            }
        }
    }
}
struct ClockVIew_Previews: PreviewProvider {
    static var previews: some View {
        ClockVIew()
    }
}
