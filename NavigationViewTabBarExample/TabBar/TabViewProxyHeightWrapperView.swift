//
//  TabViewProxyHeightWrapperView.swift
//  Mixtapes (iOS)
//
//  Created by Jake Nelson on 12/9/20.
//

import SwiftUI

struct TabViewProxyHeightWrapperView<Content: View>: View {
    
    var content: Content
    
    let tag: Int
    
    var body: some View {
        GeometryReader { proxy in
            TabNavigationHostView(tag: tag){
                content
                    .background(TabBarAccessor { tabBar in
                        print(tabBar)
                    })
                    .onChange(of: proxy.size.height, perform: {
                        _ in
                        print("height changed")
                    })
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        TabViewProxyHeightWrapperView(
            content: AnyView(Text("Ayy")),
            tag: 6
        )
    }
}
