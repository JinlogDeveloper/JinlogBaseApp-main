//
//  ProgressBar.swift
//  LoginScreen
//
//  Created by Ken Oonishi on 2022/07/03.
//

import Foundation
import SwiftUI



struct SquareProgressView: View {

    var value: CGFloat = 0.0
    @Binding var maxNum :Int
    @Binding var num :Int
    
    var body: some View {
        
        ZStack{
            GeometryReader { geometry in
                VStack(alignment: .trailing) {
                    ZStack(alignment: .leading) {
                        
                        Rectangle()
                            .foregroundColor(InAppColor.buttonColorRvs)
                            .opacity(0.5)
                        
                        Rectangle()
                            .foregroundColor(InAppColor.buttonColor)
                            .opacity(0.6)
                            .frame(minWidth: 0, idealWidth:self.getProgressBarWidth(geometry: geometry),
                                   maxWidth: self.getProgressBarWidth(geometry: geometry))
                    }
                }
            }
            Text("ステータス：\(num)/\(maxNum)")
                .font(.title3)
                .foregroundColor(InAppColor.strColor)
        }
    }

    func getProgressBarWidth(geometry:GeometryProxy) -> CGFloat {
        let frame = geometry.frame(in: .global)
        return frame.size.width * CGFloat(Float(num) / Float(maxNum))
    }
}

struct SquareProgressView_Previews: PreviewProvider {
    
    @State static var max = 100
    @State static var num = 30
    
    static var previews: some View {
        SquareProgressView(maxNum: $max, num: $num)
            .frame(width: 200, height: 50)
    }
}
