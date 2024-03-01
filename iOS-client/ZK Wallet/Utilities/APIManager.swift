//
//  APIManager.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 02/26/24.
//

import Foundation

class APIManager {
    static let shared = APIManager()

    func getStates(completion: @escaping ([StateModel]) -> Void) {
        guard let url = URL(string: "https://339a-63-149-110-127.ngrok-free.app/states") else { // 8000
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([StateModel].self, from: data) {
                    DispatchQueue.main.async {
                        print("States Response: \(decodedResponse)")
                        completion(decodedResponse)
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }

    func getOrganizationsByStateId(stateId: Int, completion: @escaping ([OrganizationModel]) -> Void) {
        guard let url = URL(string: "https://339a-63-149-110-127.ngrok-free.app/organizations/\(stateId)") else { //8000
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([OrganizationModel].self, from: data) {
                    DispatchQueue.main.async {
                        print("Organizations Response: \(decodedResponse)")
                        completion(decodedResponse)
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }

    func sendOTPRequest(phoneNumber: String, id_type: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://rnfzs-63-149-110-127.a.free.pinggy.online/sendSms") else { //8082
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let fullPhoneNumber = "+1\(phoneNumber)"
        let body: [String: Any] = ["phoneNumber": fullPhoneNumber, "address": "0x03fcDbb718cDDb25ab4c07D77e1511c5bbF5D126", "id_type": id_type]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error sending OTP request: \(error)")
                    completion(false)
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }.resume()
    }

    func verifyOTP(phoneNumber: String, otpCode: String, id_type: String, completion: @escaping (IdModel?, Error?) -> Void) {
        guard let url = URL(string: "https://rnfzs-63-149-110-127.a.free.pinggy.online/verifyOtp") else { //8082
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let fullPhoneNumber = "+1\(phoneNumber)"
        let body: [String: Any] = [
            "otp": otpCode,
            "phoneNumber": fullPhoneNumber,
            "id_type": id_type
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(nil, error)
                    return
                }

                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print("Response JSON: \(json)") // Print the response JSON
                        if let dictionary = json as? [String: Any] {
                            let idModel = IdModel.from(dictionary: dictionary)
                            completion(idModel, nil)
                        } else {
                            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON"])
                            completion(nil, error)
                        }
                    } catch {
                        print("JSON Error: \(error.localizedDescription)")
                        completion(nil, error)
                    }
                }
            }
        }.resume()
    }

    func executeProofs(UID: String, address: String, dob: Int, ageThreshold: Int, id_type: String ,completion: @escaping (Proof?, Error?) -> Void) {
        guard let url = URL(string: "https://339a-63-149-110-127.ngrok-free.app/proof") else { // 8000
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }

        print("execute proofs")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "id": UID,
            "address": address,
            "dob": dob,
            "ageThreshold": ageThreshold,
            "id_type": id_type
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error)
                    return
                }

                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let dictionary = json as? [String: Any] {
                            let proof = Proof.from(dictionary: dictionary)
                            completion(proof, nil)

                        } else {
                            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON"]))
                        }
                    } catch {
                        completion(nil, error)
                    }
                }
            }
        }.resume()
    }

    func sendProof(proof: Proof, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "https://339a-63-149-110-127.ngrok-free.app/sendProof") else { //8000
            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(proof)
            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { _, _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(true))
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
}
