//
//  PlayerDetail.swift
//  JinlogBase
//
//  Created by Ken Oonishi on 2022/09/03.
//

import SwiftUI
//import Charts

struct PlayerDetail: View {
    
    @State var maxNum = 100
    @State var num = 30
    @State var value :CGFloat = 0.3
    @State var score :[Double] = [3.5,4.8,2.5,3.5,2.8]
    let characters = ["長所探し","気遣い","ユーモア","話術","推理力"]
    let colors = [Color(red: 0.204, green: 0.368, blue: 0.499),
                  Color(red: 0.020, green: 0.525, blue: 0.549),
                  Color(red: 0.267, green: 0.765, blue: 0.545),
                  Color(red: 1.000, green: 0.820, blue: 0.224),
                  Color(red: 0.957, green: 0.471, blue: 0.259)]
    
    let username :String
    
    
    var body: some View {
        
        ScrollView {
            VStack {
                
                PlayerRow(username: username)
                    .frame(width:250)
                    .background(InAppColor.textFieldColor)
                    .cornerRadius(20)
                    .shadow(radius: 3)

                ZStack {
                    
                    //背景色　ダークモード対応のため色はAssetsに登録
                    InAppColor.backColor
                    
                    VStack {
                    //                        Text("ステータス画面")
                    //
                    //                        Circle()
                    //                            .stroke(lineWidth: 30.0)
                    //                            .opacity(0.1)
                    //                            .foregroundColor(InAppColor.buttonColor)
                    //                            .frame(width: UIScreen.main.bounds.width - 40,
                    //                                   height: UIScreen.main.bounds.width - 40 )
                    //
                    //                        Circle()
                    //                            .trim(from: 0.0, to: 0.3)
                    //                            .stroke(style: StrokeStyle(lineWidth: 30.0, lineCap: .round, lineJoin: .round))
                    //                            .foregroundColor(InAppColor.buttonColor)
                    //                            .frame(width: UIScreen.main.bounds.width - 40,
                    //                                   height: UIScreen.main.bounds.width - 40)
                    //                            .rotationEffect(Angle(degrees: -90))
                    //                            .opacity(0.5)
                    
                    
                    //TODO: Xcode14.0にアップデートしたら、ビルドエラーが発生してしまう
                    /*
                    //一旦ここにデータを作成。今後どっかへ移動させる
                    Radar(entries: [
                        RadarChartDataEntry(value: 2.6),
                        RadarChartDataEntry(value: 2.8),
                        RadarChartDataEntry(value: 4.1),
                        RadarChartDataEntry(value: 5.0),
                        RadarChartDataEntry(value: 3.4)]
                          ,entries2: [
                            RadarChartDataEntry(value: score[0]),
                            RadarChartDataEntry(value: score[1]),
                            RadarChartDataEntry(value: score[2]),
                            RadarChartDataEntry(value: score[3]),
                            RadarChartDataEntry(value: score[4])]
                    )
                    .frame(width: UIScreen.main.bounds.width,height: 420.0)
                     */
                    }
                    //プログレスバーはviewで作成　　スタックで重ねて表示させる
                    SquareProgressView(maxNum: $maxNum, num: $num)
                        .frame(width: 300, height: 40)
                        .cornerRadius(15)
                        .offset(x: 0, y: 135)
                    

                } //Zstack
                
                                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        VStack {
                            Text("ステータス")
                                .padding(.bottom,1)
                                .foregroundColor(.secondary)
                            Text("\(num)")
                                .font(.system(size: 35, weight: .thin, design: .rounded))
                                
                            withAnimation(){
                                Stepper("ステータス",value: $num, in: 0...100)
                                    .labelsHidden()
                            }
                        }
                        .padding(.top)

                        
                        ForEach(0 ..< 4) { num in
                            VStack {
                                HStack {
                                    if score[num] > 4.99 {
                                        Image(systemName: "crown.fill")
                                            .foregroundColor(Color.yellow)
                                    }
                                    Text(self.characters[num])
                                        .padding(.bottom,1)
                                        .foregroundColor(.secondary)
                                }
                                ZStack {
                                    RadialGradient(gradient: Gradient(colors: [colors[num].opacity(0.3), Color.white.opacity(0.4)]), center: .center, startRadius: 0, endRadius: 35)

                                    Text(String(format: "%.1f", score[num]))
                                        .font(.system(size: 35, weight: .thin, design: .rounded))
                                }
                                Stepper(self.characters[num],value: $score[num], in: 0...5, step: 0.1)
                                    .labelsHidden()
                            }
                            .padding(.top)
                        }
                    } //HStack
                } //ScrollView
            } //Vstack
            .navigationBarTitleDisplayMode(.inline)
        } //ScrollView
    }
}

struct PlayerDetail_Previews: PreviewProvider {
    static var previews: some View {
        PlayerDetail(username: "Ken")
    }
}
