//
//  AppDelegate.swift
//  SQLiteTest
//
//  Created by Leo on 21/06/2017.
//  Copyright © 2017 Lio. All rights reserved.
//

import UIKit
import SQLite

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        var dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        dbPath = dbPath + "/epc.sqlite"
        debugPrint(dbPath)
        
        let db:Connection = try! Connection(dbPath)
        
        let photoDBModel = Table("EPCPhotoDBModel")
        let pk = Expression<Int64>("pk")
        let photoID = Expression<String?>("photoID")
        let transferState = Expression<Int64>("transferState")
        let timestamp = Expression<String?>("timestamp")
        let hotelID = Expression<String?>("hotelID")
        let userID = Expression<String?>("userID")
        let didCallBackToWeb = Expression<Int64>("didCallBackToWeb")
        let mediaInfo = Expression<String?>("mediaInfo")
        
        _ = try? db.run(photoDBModel.create(block: { (t) in
            t.column(pk, primaryKey: true)
            t.column(photoID)
            t.column(transferState)
            t.column(timestamp)
            t.column(hotelID)
            t.column(userID)
            t.column(didCallBackToWeb)
            t.column(mediaInfo)
        }))
        
        // MARK: - insert
        let insert = photoDBModel.insert(photoID <- "0987",
                                         transferState <- 0,
                                         timestamp <- "\(Int64(Date().timeIntervalSince1970))",
                                        hotelID <- "6606",
                                        userID <- "007",
                                        didCallBackToWeb <- 0,
                                        mediaInfo <- "{}")
        _ = try? db.run(insert)
        
        
        // MARK: - update
        let fetch = photoDBModel.filter(photoID == "123qewrqwe" && userID == "007" )
        let updateSql = fetch.update(transferState <- 6, mediaInfo <- "{\"key\":\"value\"}")
        _ = try? db.run(updateSql)
        
//        let updateSql = "UPDATE EPCPhotoDBModel SET transferState = 1 WHERE photoID = '123qewrqwe'"
//        _ = try? db.run(updateSql)
        
        
        // MARK: - query
        for row in try! db.prepare("SELECT * FROM EPCPhotoDBModel WHERE userID = '007' ") {
            print(row[0], row[1])
        }
        
        
        // MARK: - delete
//        let fetch = photoDBModel.filter(photoID == "0987" && userID == "007" )
//        _ = try? db.run(fetch.delete())
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

