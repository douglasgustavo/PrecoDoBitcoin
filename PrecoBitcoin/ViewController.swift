//
//  ViewController.swift
//  PrecoBitcoin
//
//  Created by Douglas Santos on 25/07/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var valorBitcoin: UILabel!
    @IBOutlet weak var botaoAtualizar: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.obterPrecoBitcoin()
    }
    
    @IBAction func btnAtualizar(_ sender: UIButton) {
        self.botaoAtualizar.setTitle("Atualizando...", for: .normal)
        self.obterPrecoBitcoin()
        self.botaoAtualizar.setTitle("Atualizar", for: .normal)
    }
    
    func formatarPreco(preco: NSNumber) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = Locale(identifier: "pt_BR")
        if let precoFinal = nf.string(from: preco) {
            return precoFinal
        }
        return "0,00"
    }
    
    func obterPrecoBitcoin() {
        if let url = URL(string: "https://blockchain.info/pt/ticker") {
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, response, error) in
                if error == nil {
                    if let dadosRetorno = dados {
                        do {
                            if let objetoJson = try JSONSerialization.jsonObject(with: dadosRetorno, options: []) as? [String: Any] {
                                
                                if let brl = objetoJson["BRL"] as? [String: Any] {
                                    if let preco = brl["buy"] as? Double {
                                        let precoFormatado = self.formatarPreco(preco: NSNumber(value: preco))
                                        DispatchQueue.main.async {
                                            self.valorBitcoin.text = "R$ " + precoFormatado
                                        }
                                    }
                                }
                            }
                        } catch {
                            print("Erro na conversão")
                        }
                    }
                } else {
                    print("Erro na consulta")
                }
            }
            tarefa.resume()
        }
    }
}

