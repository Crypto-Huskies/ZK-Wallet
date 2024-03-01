//
//  DBManager.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 02/26/24.
//

import SQLite

struct DatabaseManager {
    private var db: Connection?

    private let idModels = Table("idModels")
    private let address = Expression<String>("address")
    private let idType = Expression<String>("idType")
    private let firstName = Expression<String>("firstName")
    private let lastName = Expression<String>("lastName")
    private let dateOfBirth = Expression<Int>("dateOfBirth")
    private let phone = Expression<String>("phone")
    private let UID = Expression<String>("UID")

    private let proofs = Table("proofs")
    private let pi_a = Expression<String>("pi_a")
    private let pi_b = Expression<String>("pi_b")
    private let pi_c = Expression<String>("pi_c")
    private let protocolType = Expression<String>("protocolType")
    private let curve = Expression<String>("curve")
    private let publicSignals = Expression<String>("publicSignals")
    private let txType = Expression<String?>("txType")

    private let transactions = Table("transactions")
    private let id = Expression<String>("id")
    private let from = Expression<String>("from")
    private let message = Expression<String>("message")
    private let timestamp = Expression<String>("timestamp")

    init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

            print(path)
            db = try Connection("\(path)/db.sqlite3")

            try createIdModelTable()
            try createProofTable()
            try createTransactionTable()

        } catch {
            print("Unable to open or create database: \(error)")
        }
    }

    private func createIdModelTable() throws {
        let idModels = Table("idModels")
        let address = Expression<String>("address")
        let idType = Expression<String>("idType")
        let firstName = Expression<String>("firstName")
        let lastName = Expression<String>("lastName")
        let dateOfBirth = Expression<Int>("dateOfBirth")
        let phone = Expression<String>("phone")
        let UID = Expression<String>("UID")

        try db?.run(idModels.create(ifNotExists: true) { t in
            t.column(UID, primaryKey: true)
            t.column(address)
            t.column(idType)
            t.column(firstName)
            t.column(lastName)
            t.column(dateOfBirth)
            t.column(phone)

        })
    }

    func insertIdModel(idModel: IdModel) {
        let idModels = Table("idModels")
        let address = Expression<String>("address")
        let idType = Expression<String>("idType")
        let firstName = Expression<String>("firstName")
        let lastName = Expression<String>("lastName")
        let dateOfBirth = Expression<Int>("dateOfBirth")
        let phone = Expression<String>("phone")
        let UID = Expression<String>("UID")

        let insert = idModels.insert(or: .replace, address <- idModel.address, idType <- idModel.idType, firstName <- idModel.firstName, lastName <- idModel.lastName, dateOfBirth <- idModel.dateOfBirth, phone <- idModel.phone, UID <- idModel.UID)

        do {
            try db?.run(insert)
        } catch {
            print("Insert failed: \(error)")
        }
    }

    func getIdModels() -> [IdModel] {
        let idModels = Table("idModels")
        var models = [IdModel]()

        do {
            for model in try db!.prepare(idModels) {
                let idModel = IdModel(
                    address: model[address],
                    idType: model[idType],
                    firstName: model[firstName],
                    lastName: model[lastName],
                    dateOfBirth: model[dateOfBirth],
                    phone: model[phone],
                    UID: model[UID]
                )
                models.append(idModel)
            }
        } catch {
            print("Select failed: \(error)")
        }

        return models
    }

    // Update an existing IdModel record
    func updateIdModel(idModel: IdModel) {
        let idModels = Table("idModels")
        let modelToUpdate = idModels.filter(UID == idModel.UID)

        let update = modelToUpdate.update(
            address <- idModel.address,
            idType <- idModel.idType,
            firstName <- idModel.firstName,
            lastName <- idModel.lastName,
            dateOfBirth <- idModel.dateOfBirth,
            phone <- idModel.phone
        )

        do {
            if try db?.run(update) == 0 {
                print("Record not found")
            } else {
                print("Record updated successfully")
            }
        } catch {
            print("Update failed: \(error)")
        }
    }

    func deleteIdModelByUID(UID: String) {
        let idModels = Table("idModels")
        let modelToDelete = idModels.filter(self.UID == UID)

        let delete = modelToDelete.delete()

        do {
            if try db?.run(delete) == 0 {
                print("Record not found")
            } else {
                print("Record deleted successfully")
            }
        } catch {
            print("Delete failed: \(error)")
        }
    }

    private func createProofTable() throws {
        try db?.run(proofs.create(ifNotExists: true) { t in
            t.column(UID, primaryKey: true)
            t.column(pi_a)
            t.column(pi_b)
            t.column(pi_c)
            t.column(protocolType)
            t.column(curve)
            t.column(publicSignals)
            t.column(txType)
        })
    }

    func insertProof(proof: Proof) {
        let pi_a_json = convertArrayToJsonString(proof.pi_a) ?? "[]"
        let pi_b_json = convertArrayToJsonString(proof.pi_b) ?? "[]"
        let pi_c_json = convertArrayToJsonString(proof.pi_c) ?? "[]"
        let publicSignals_json = convertArrayToJsonString(proof.publicSignals) ?? "[]"

        let insert = proofs.insert(
            UID <- proof.UID,
            pi_a <- pi_a_json,
            pi_b <- pi_b_json,
            pi_c <- pi_c_json,
            protocolType <- proof.protocolType,
            curve <- proof.curve,
            publicSignals <- publicSignals_json,
            txType <- proof.txType
        )

        do {
            print("insert proof")
            try db?.run(insert)
        } catch {
            print("Insert failed: \(error)")
        }
    }

    func getProofs() -> [Proof] {
        var proofsList = [Proof]()

        do {
            for proof in try db!.prepare(proofs) {
                let pi_a_array = convertJsonStringToArray(proof[pi_a]) as? [String] ?? []
                let pi_b_array = convertJsonStringToArray(proof[pi_b]) as? [[String]] ?? [[]]
                let pi_c_array = convertJsonStringToArray(proof[pi_c]) as? [String] ?? []
                let publicSignals_array = convertJsonStringToArray(proof[publicSignals]) as? [String] ?? []

                let proofObject = Proof(
                    UID: proof[UID],
                    pi_a: pi_a_array,
                    pi_b: pi_b_array,
                    pi_c: pi_c_array,
                    protocolType: proof[protocolType],
                    curve: proof[curve],
                    publicSignals: publicSignals_array,
                    txType: proof[txType]
                )
                proofsList.append(proofObject)
            }
        } catch {
            print("Select failed: \(error)")
        }

        return proofsList
    }

    func getProofForTxType(txTypeValue: String) -> Proof? {
        do {
            // This line is correct, as it creates an expression for filtering
            let txTypeExpression = Expression<String?>("txType")

            if let proofRow = try db!.pluck(proofs.filter(txTypeExpression == txTypeValue)) {
                let pi_a_array = convertJsonStringToArray(proofRow[pi_a]) as? [String] ?? []
                let pi_b_array = convertJsonStringToArray(proofRow[pi_b]) as? [[String]] ?? [[]]
                let pi_c_array = convertJsonStringToArray(proofRow[pi_c]) as? [String] ?? []
                let publicSignals_array = convertJsonStringToArray(proofRow[publicSignals]) as? [String] ?? []

                let proofObject = Proof(
                    UID: proofRow[UID],
                    pi_a: pi_a_array,
                    pi_b: pi_b_array,
                    pi_c: pi_c_array,
                    protocolType: proofRow[protocolType],
                    curve: proofRow[curve],
                    publicSignals: publicSignals_array,
                    txType: proofRow[txType] ?? nil
                )

                return proofObject
            }
        } catch {
            print("Select failed: \(error)")
        }

        return nil
    }

    func updateProof(proof: Proof) {
        let pi_a_json = convertArrayToJsonString(proof.pi_a) ?? "[]"
        let pi_b_json = convertArrayToJsonString(proof.pi_b) ?? "[]"
        let pi_c_json = convertArrayToJsonString(proof.pi_c) ?? "[]"
        let publicSignals_json = convertArrayToJsonString(proof.publicSignals) ?? "[]"

        let proofToUpdate = proofs.filter(UID == proof.UID)

        let update = proofToUpdate.update(
            pi_a <- pi_a_json,
            pi_b <- pi_b_json,
            pi_c <- pi_c_json,
            protocolType <- proof.protocolType,
            curve <- proof.curve,
            publicSignals <- publicSignals_json,
            txType <- proof.txType
        )

        do {
            if try db?.run(update) == 0 {
                print("Record not found")
            } else {
                print("Record updated successfully")
            }
        } catch {
            print("Update failed: \(error)")
        }
    }

    func deleteProof(UID: String) {
        let proofToDelete = proofs.filter(self.UID == UID)

        let delete = proofToDelete.delete()

        do {
            if try db?.run(delete) == 0 {
                print("Record not found")
            } else {
                print("Record deleted successfully")
            }
        } catch {
            print("Delete failed: \(error)")
        }
    }

    func convertArrayToJsonString(_ array: [Any]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: array, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Error converting array to JSON string: \(error)")
        }
        return nil
    }

    private func convertJsonStringToArray(_ jsonString: String) -> [Any]? {
        if let data = jsonString.data(using: .utf8) {
            return (try? JSONSerialization.jsonObject(with: data)) as? [Any]
        }
        return nil
    }

    private func createTransactionTable() throws {
        try db?.run(transactions.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(from)
            t.column(message)
            t.column(timestamp)
            t.column(txType)
        })
    }

    func insertTransaction(transaction: Transaction) {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        let currentTimestamp = dateFormatter.string(from: Date())

        let insert = transactions.insert(
            id <- transaction.txId,
            from <- transaction.from,
            message <- transaction.message,
            timestamp <- currentTimestamp,
            txType <- transaction.txType
        )
        print("insert")
        print(transaction)

        do {
            let rowId = try db?.run(insert)
            print("Inserted transaction with id: \(String(describing: rowId))")
        } catch {
            print("Insert transaction failed: \(error)")
        }
    }

    func getTransactions() -> [Transaction] {
        var transactionsList = [Transaction]()

        do {
            for transaction in try db!.prepare(transactions) {
                let transactionObject = Transaction(
                    txId: transaction[id],
                    from: transaction[from],
                    message: transaction[message],
                    timestamp: transaction[timestamp],
                    txType: transaction[txType]
                )
                transactionsList.append(transactionObject)
            }
            print("txs")
            print(transactionsList)
        } catch {
            print("Select transactions failed: \(error)")
        }

        return transactionsList
    }
}
