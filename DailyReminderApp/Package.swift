// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DailyReminderAppWorkspace",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "DailyReminderLib", targets: ["DailyReminderLib"]) 
    ],
    targets: [
        .target(
            name: "DailyReminderLib",
            path: "DailyReminderApp",
            exclude: [
                "Assets.xcassets",
                "DailyReminderAppApp.swift"
            ]
        )
    ]
)