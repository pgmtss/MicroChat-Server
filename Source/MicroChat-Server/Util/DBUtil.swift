//
//  DBUtil.swift
//  COpenSSL
//
//  Created by Tian Ming on 2019/5/30.
//

import Foundation
import PerfectMySQL

// MARK: 数据库信息
#if os(Linux) // 在Ubuntu下
let user = "root"
let password = "123456"
let dataBase = "MicroChat"
let host = "0.0.0.0"

#else
let user = "root"
let password = "123456"
let dataBase = "MicroChat"
let host = "0.0.0.0"
#endif



open class DataBaseManager {
    
    fileprivate var mysql: MySQL
    internal init() {
        mysql = MySQL.init()                           //创建MySQL对象
        guard connectedDataBase() else {               //开启MySQL连接
            return
        }
    }
    
    // MARK: 开启连接
    private func connectedDataBase() -> Bool {
        
        let connected = mysql.connect(host: host, user: user, password: password, db: dataBase)
        guard connected else {
            print(mysql.errorMessage())
            return false
        }
        print("MySQL Connect Success")
        return true
        
    }
    
    // MARK: 执行SQL语句
    /// 执行SQL语句
    ///
    /// - Parameter sql: sql语句
    /// - Returns: 返回元组(success:是否成功 result:结果)
    @discardableResult
    func mysqlStatement(_ sql: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        
        guard mysql.selectDatabase(named: dataBase) else {            //指定database
            let msg = "NO\(dataBase)Database"
            print(msg)
            return (false, nil, msg)
        }
        
        let successQuery = mysql.query(statement: sql)                      //sql语句
        guard successQuery else {
            let msg = "SQL_Error: \(sql)"
            print(msg)
            return (false, nil, msg)
        }
        let msg = "SQL_Success: \(sql)"
        print(msg)
        return (true, mysql.storeResults(), msg)                            //sql执行成功
        
    }
    
    /// 创建表 (查询是否有此表，若否，则创建)
    func createTable(tableName: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String){
        let insert = "SELECT * FROM \(tableName)"
        let statement = mysqlStatement(insert)
        if !statement.success {
            let SQL = "CREATE TABLE \(tableName) (id INT(10) PRIMARY KEY AUTO_INCREMENT, path VARCHAR(255), companyName VARCHAR(255),phoneNumber VARCHAR(255))"
            return mysqlStatement(SQL)
        }
        return mysqlStatement(insert)
    }
    //    CREATE TABLE samples (id INT PRIMARY KEY AUTO_INCREMENT, created_at DATETIME, location POINT, reading JSON)
    /// 增
    ///
    /// - Parameters:
    ///   - tableName: 表
    ///   - key: 键  （键，键，键）
    ///   - value: 值  ('值', '值', '值')
    func insertDatabaseSQL(tableName: String, key: String, value: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String){
        let SQL = "INSERT INTO \(tableName) (\(key)) VALUES (\(value))"
        return mysqlStatement(SQL)
    }
    
    /// 删
    ///
    /// - Parameters:
    ///   - tableName: 表
    ///   - key: 键
    ///   - value: 值
    func deleteDatabaseSQL(tableName: String, key: String, value: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        
        let SQL = "DELETE FROM \(tableName) WHERE \(key) = '\(value)'"
        return mysqlStatement(SQL)
        
    }
    
    /// 改
    ///
    /// - Parameters:
    ///   - tableName: 表
    ///   - keyValue: 键值对( 键='值', 键='值', 键='值' )
    ///   - whereKey: 查找key
    ///   - whereValue: 查找value
    func updateDatabaseSQL(tableName: String, keyValue: String, whereKey: String, whereValue: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        
        let SQL = "UPDATE \(tableName) SET \(keyValue) WHERE \(whereKey) = '\(whereValue)'"
        return mysqlStatement(SQL)
        
    }
    
    /// 查所有
    ///
    /// - Parameters:
    ///   - tableName: 表
    ///   - key: 键
    func selectAllDatabaseSQL(tableName: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        
        let SQL = "SELECT * FROM \(tableName)"
        return mysqlStatement(SQL)
        
    }
    
    /// 查
    ///
    /// - Parameters:
    ///   - tableName: 表
    ///   - keyValue: 键值对
    func selectAllDataBaseSQLwhere(tableName: String, keyValue: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        
        let SQL = "SELECT * FROM \(tableName) WHERE \(keyValue)"
        return mysqlStatement(SQL)
        
    }
    
    // 获取数据库某个表中的所有数据
    func mysqlGetUserDataResult(tableName: String) -> [Dictionary<String, String>]? {
        
        let result = selectAllDatabaseSQL(tableName: tableName)
        var resultArray = [Dictionary<String, String>]()
        var dic = [String:String]()
        result.mysqlResult?.forEachRow(callback: { (row) in
            dic["uuid"] = row[1]
            resultArray.append(dic)
        })
        
        return resultArray
        
    }
}
