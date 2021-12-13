//
//  UIKitTabView.swift
//  NavigationTitleTest
//
//  Created by Jake Nelson on 17/6/21.
//

import SwiftUI
import Algorithms

struct UIKitTabView: View {
    private var viewControllers: [UIHostingController<AnyView>]
    var selectedIndex: Int = 0
    
    let tabBarControllerView: TabBarController
    
    init(_ views: [Tab]) {
        self.viewControllers = views.map {
            let host = UIHostingController(rootView: $0.view)
            host.tabBarItem = $0.barItem
            return host
        }
        self.tabBarControllerView = TabBarController(controllers: viewControllers, selectedIndex: selectedIndex)
    }
    
    var body: some View {
        tabBarControllerView
            .edgesIgnoringSafeArea(.all)
    }
    
    struct Tab: Hashable {
        var view: AnyView
        var barItem: UITabBarItem
        
        let id = UUID()
        static func == (lhs: Tab, rhs: Tab) -> Bool {
            return lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        init<V: View>(view: V, barItem: UITabBarItem, tag: Int) {
            self.view = AnyView(view)
            self.barItem = barItem
        }
        
        // Convenience
        init<V: View>(view: V, title: String?, image: String, tag: Int) {
            let barItem = UITabBarItem(title: title, image: UIImage(systemName: image), tag: tag)
            self.init(view: view, barItem: barItem, tag: tag)
        }
    }
}

struct TabBarController: UIViewControllerRepresentable {
    
    let defaults: UserDefaults = UserDefaults.standard
    
    var controllers: [UIViewController]
    var selectedIndex: Int
    
    let tabBarController = UITabBarController()
    
    //    func getHeight() -> Double {
    //        // Trying to get the height of the tab bar
    //        print(tabBarController.tabBar.frame.size.height)
    //        return tabBarController.tabBar.frame.size.height
    //    }
    
    func makeUIViewController(context: Context) -> UITabBarController {
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor.secondarySystemBackground
        appearance.backgroundEffect = UIBlurEffect(style: .systemThickMaterial)
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance
        
        // Reorder view controllers to user selected order from defaults
        var tabBarOrder = defaults.object(forKey: "tabBarOrder") as? [Int] ?? [0,1,2,3,4,5,6,7,8]
        
        if controllers.count != tabBarOrder.count && !controllers.isEmpty {
            // if there are tabs not in the tab bar order then put them at end, and update tabBarOrder
            var difference = Array(
                Set(
                    controllers.map{$0.tabBarItem.tag}
                ).subtracting (
                    Set(tabBarOrder)
                )
            )
            if !difference.isEmpty {
                print("controllers.count != tabBarOrder.count")
                print("Missing tabs found:")
                print(difference)
                difference.sort()
                print(difference)
                // Make sure settings always last? Might need to revisit?
                tabBarOrder = tabBarOrder.filter{ $0 != 9 }
                tabBarOrder.append(contentsOf: difference)
                tabBarOrder.append(9)
                
                defaults.set(tabBarOrder, forKey: "tabBarOrder")
            }
        }
        
        tabBarOrder = Array(tabBarOrder.uniqued())
        
        // GET OUT OF JAIL FREE CARD
        //            tabBarOrder = [0,1,2,3,4,5,6,7,8,9,10,11]
        //            tabBarOrder = [0,1,2,3,4,5,6,7,8,9]
        //            defaults.set(tabBarOrder, forKey: "tabBarOrder")
        
        var newOrderViewControllers = [UIViewController]()
        for tag in tabBarOrder {
            let nextViewController = controllers.filter({ $0.tabBarItem.tag == tag})
            newOrderViewControllers.append(contentsOf: nextViewController)
        }
        tabBarController.viewControllers = newOrderViewControllers
        
        tabBarController.delegate = context.coordinator
        if let selectedTabIndex = defaults.object(forKey: "selectedTabIndex") as? Int {
            tabBarController.selectedIndex = selectedTabIndex
        }
        else {
            tabBarController.selectedIndex = selectedIndex
        }
        
        return tabBarController
    }
    
    func updateUIViewController(_ tabBarController: UITabBarController, context: Context) {
        //        print("tab updateUIViewController")
        //        print(tabBarController.tabBar.frame.size.height)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITabBarControllerDelegate {
        var parent: TabBarController
        
        init(_ tabBarController: TabBarController) {
            self.parent = tabBarController
        }
        
        func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            parent.selectedIndex = tabBarController.selectedIndex
            parent.defaults.set(parent.selectedIndex, forKey: "selectedTabIndex")
        }
        
        func tabBarController(_ tabBarController: UITabBarController, didEndCustomizing viewControllers: [UIViewController], changed: Bool) {
            let tabBarOrder = viewControllers.map { $0.tabBarItem.tag }
            parent.defaults.set(tabBarOrder, forKey: "tabBarOrder")
        }
    }
}

struct TabNavigationHostView<Content: View>: View {
    let content: Content
    let tag: Int
    
    init(tag: Int, @ViewBuilder content: () -> Content) {
        self.tag = tag
        self.content = content()
    }
    
    @State var showNavigation: Bool = true
    let defaults: UserDefaults = UserDefaults.standard
    
    var body: some View {
        
        Group{
            if showNavigation {
                NavigationView {
                    content
                }
            }
            else {
                content
            }
        }
        // Set the tabBar and tabBarController
        .background(
            TabBarControllerAccessor(callback: {
                tabBarController in
                print(tabBarController)
            })
                .background(
                    TabBarAccessor(callback: {
                        tabBar in
                        print(tabBar)
                    })
                )
        )
        .onAppear{
            
            let tabBarOrder = self.defaults.object(forKey: "tabBarOrder") as? [Int] ?? [0,1,2,3,4,5,6,7,8]
            
            let visibleTabs = Array(tabBarOrder[0...3])
            
            // TODO: check this for iPad
            showNavigation = visibleTabs.contains(tag)
        }
    }
}


struct UIKitTabView_Previews: PreviewProvider {
    static var previews: some View {
        UIKitTabView([
            UIKitTabView.Tab(
                view: Text("A"),
                title: "B",
                image: "a.circle",
                tag: 0),
            UIKitTabView.Tab(
                view: Text("B"),
                title: "B",
                image: "b.circle",
                tag: 1),
            UIKitTabView.Tab(
                view: Text("C"),
                title: "C",
                image: "c.circle",
                tag: 2),
            UIKitTabView.Tab(
                view: Text("D"),
                title: "D",
                image: "d.circle",
                tag: 3),
            UIKitTabView.Tab(
                view: Text("E"),
                title: "E",
                image: "e.circle",
                tag: 4),
            UIKitTabView.Tab(
                view: Text("F"),
                title: "F",
                image: "f.circle",
                tag: 5),
            UIKitTabView.Tab(
                view: Text("G"),
                title: "G",
                image: "g.circle",
                tag: 6),
            
        ])
    }
}
