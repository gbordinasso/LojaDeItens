import Foundation

enum ErroEntrada: Error {
    case valorInvalido
}

func lerNumero() throws -> Int {
    if let texto = readLine(), let numero = Int(texto) {
        return numero
    } else {
        throw ErroEntrada.valorInvalido
    }
}


struct Item {
    var nome: String
    var custo: Int
    var nivelMinimo: Int
}

struct Jogador {
    var nome: String
    var dinheiro: Int
    var nivel: Int
    var mochila: [Item]
}


let itensLoja: [Item] = [
    Item(nome: "Espada Simples", custo: 40, nivelMinimo: 1),
    Item(nome: "Arco e Flecha", custo: 70, nivelMinimo: 2),
    Item(nome: "Bomba", custo: 30, nivelMinimo: 1),
    Item(nome: "Poção de Vida", custo: 20, nivelMinimo: 1),
    Item(nome: "Carrinho de Canhão", custo: 45, nivelMinimo: 3)
]


func menu() {
    print("""
    
    --- Loja de Itens ---
    1 - Ver status do jogador
    2 - Ver itens da loja
    3 - Comprar item
    4 - Vender item
    5 - Ver mochila
    6 - Sair
    """)
}

func mostrarJogador(_ j: Jogador) {
    print("\nNome: \(j.nome)")
    print("Dinheiro: \(j.dinheiro)")
    print("Nível: \(j.nivel)\n")
}

func mostrarLoja() {
    print("\nItens disponíveis:")
    for i in 0..<itensLoja.count {
        let item = itensLoja[i]
        print("\(i + 1) - \(item.nome) (Preço: \(item.custo), Nível mínimo: \(item.nivelMinimo))")
    }
    print("")
}

func mostrarMochila(_ jogador: Jogador) {
    if jogador.mochila.isEmpty {
        print("\nSua mochila está vazia.\n")
        return
    }
    
    print("\nMochila:")
    for i in 0..<jogador.mochila.count {
        let item = jogador.mochila[i]
        print("\(i + 1) - \(item.nome) (Vende por: \(item.custo / 2))")
    }
    print("")
}


func comprarItem(_ jogador: inout Jogador) {
    mostrarLoja()
    print("Qual item deseja comprar?")

    do {
        let escolha = try lerNumero()
        
        if escolha < 1 || escolha > itensLoja.count {
            throw ErroEntrada.valorInvalido
        }
        
        let item = itensLoja[escolha - 1]
        
        if jogador.nivel < item.nivelMinimo {
            print("Seu nível é muito baixo para comprar este item.\n")
            return
        }
        
        if jogador.dinheiro < item.custo {
            print("Você não tem dinheiro suficiente.\n")
            return
        }
        
        jogador.dinheiro -= item.custo
        jogador.mochila.append(item)
        
        print("Você comprou \(item.nome)!\n")
        
    } catch {
        print("Entrada inválida. Digite um número válido.\n")
    }
}


func venderItem(_ jogador: inout Jogador) {
    mostrarMochila(jogador)
    if jogador.mochila.isEmpty { return }
    
    print("Qual item deseja vender?")
    
    do {
        let escolha = try lerNumero()
        
        if escolha < 1 || escolha > jogador.mochila.count {
            throw ErroEntrada.valorInvalido
        }
        
        let item = jogador.mochila[escolha - 1]
        let ganho = item.custo / 2
        
        jogador.dinheiro += ganho
        jogador.mochila.remove(at: escolha - 1)
        
        print("Você vendeu \(item.nome) por \(ganho)!\n")
        
    } catch {
        print("Entrada inválida.\n")
    }
}


print("Digite o nome do seu personagem:")
let nomeDigitado = readLine() ?? "Jogador"

// valores fixos (como você pediu)
let dinheiroInicial = 300
let nivelInicial = 2

var jogador = Jogador(
    nome: nomeDigitado,
    dinheiro: dinheiroInicial,
    nivel: nivelInicial,
    mochila: []
)

// ------------ Loop principal ------------

var jogando = true

while jogando {
    menu()
    
    if let opcao = readLine() {
        switch opcao {
        case "1":
            mostrarJogador(jogador)
        case "2":
            mostrarLoja()
        case "3":
            comprarItem(&jogador)
        case "4":
            venderItem(&jogador)
        case "5":
            mostrarMochila(jogador)
        case "6":
            print("Saindo da loja...")
            jogando = false
        default:
            print("Opção inválida.\n")
        }
    }
}