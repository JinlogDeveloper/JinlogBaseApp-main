//
//  ButtonRow.swift
//  LoginScreen
//
//  Created by Ken Oonishi on 2022/08/11.
//

import SwiftUI

struct ButtonLabel: View {
    
    var message: String = "Button"
    var buttonColor: Color
    
    var body: some View {
        Text(message)
            .font(.title3)
            .padding(.all, 12)
            .frame(maxWidth: 400)
            .foregroundColor(InAppColor.strColorRvs)
            .background(buttonColor)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding(.horizontal, 20.0)
            .shadow(radius: 3)
        }
}


struct ButtonRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ButtonLabel(buttonColor: InAppColor.buttonColor)
            ButtonLabel(buttonColor: InAppColor.buttonColor2)
        }
        .previewLayout(.fixed(width: 300, height: 100))
    }
}
