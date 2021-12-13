//
//  ContentView.swift
//  NavigationViewTabBarExample
//
//  Created by Jake Nelson on 12/12/21.
//

import SwiftUI

struct ContentView: View {
    
    @State var tabPages: [UIKitTabView.Tab] = []
    
    var body: some View {
        UIKitTabView(tabPages)
            .id(tabPages)
            .onAppear(perform: getTabPages)
    }
    
    func getTabPages(){
        
        var newTabPages: [UIKitTabView.Tab] = []
        
        for index in 0..<8 {
            newTabPages.append(
                UIKitTabView.Tab(
                    view:
                        TabViewProxyHeightWrapperView(
                            content: List(0..<50){
                                NavigationLink("\($0)", destination: Text("\($0)"))
                                    .navigationBarTitle("\(index) title")
                            },
                            tag: index),
                    title: "\(index) title",
                    image: "\(index).square.fill",
                    tag: index)
                )
            
        }
        
        print(tabPages.count)
        tabPages = newTabPages
        print(tabPages.count)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
