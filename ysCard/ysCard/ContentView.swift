//
//  ContentView.swift
//  ysCard
//
//  Created by yoonyeosong on 2023/12/30.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(red: 0.2, green: 0.6, blue: 0.86)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image("yeosong")
                    .resizable() //이미지 크기 조절 가능하게 해줌
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150.0, height: 150.0) //이미지 크기 설정
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 5)
                    )
                
                Text("YoonYeoSong")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                Text("iOSDeveloper")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                Divider()
                InfoView(text: "010 2328 7508", imageName: "phone.fill")
                InfoView(text: "duthd3@naver.com", imageName:"envelope.fill")
                InfoView(text: "github.com/duthd3", imageName: "g.circle.fill")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


