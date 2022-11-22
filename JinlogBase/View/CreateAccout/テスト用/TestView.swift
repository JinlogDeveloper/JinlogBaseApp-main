//
//  TestView.swift
//  LoginScreen
//
//  Created by Ken Oonishi on 2022/08/15.
//

import SwiftUI


enum PageSelect: String, CaseIterable{
    case birthdayEdit = "誕生日"
    case sexEdit = "性別"
    case areaEdit = "都道府県"
    case unSelected = "未選択"
    
    static func GetSelectPage(page: PageSelect) -> AnyView {

        switch page {
        case .birthdayEdit:
            return AnyView(ButtonLabel(buttonColor: Color.red))
        case .sexEdit:
            return AnyView(ButtonLabel(buttonColor: Color.blue))
        case .areaEdit:
            return AnyView(ButtonLabel(buttonColor: Color.yellow))
        case .unSelected:
            return AnyView(ButtonLabel(buttonColor: Color.green))
        }
    }
}


struct TestView: View {
    
    @State var pages = PageSelect.unSelected
    
    var body: some View {
        
        VStack {
            Spacer().frame(height:100)

            Text(pages.rawValue)
            
            
            ForEach(PageSelect.allCases, id: \.self) { page in
//                if page != .unSelected {
                    VStack {
                        if pages == page || pages == .unSelected {
                            Button {
                                withAnimation {
                                    pages = pages != page ? page : .unSelected
                                }
                            } label: {
                                ButtonLabel(message: page.rawValue, buttonColor: InAppColor.buttonColor)
                            }
                        }
                        
                        if pages == page {
                            PageSelect.GetSelectPage(page: page)
                                .transition(AnyTransition.asymmetric(
                                    insertion: .scale.animation(Animation.spring().delay(0.2)),
                                    removal: .opacity))
                        }
//                    }
                }
            }
            Spacer()
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
