// import 'package:flutter/material.dart';

// class AccountModel with ChangeNotifier {
//   String _faturaAtual = "Abril 2020";
//   String get faturaAtual => _faturaAtual;
//   void updateFaturalAtual(fatura) {
//     _faturaAtual = fatura;
//     notifyListeners();
//   }

//   List<String> _faturas = [
//     "Março 2020",
//     "Abril 2020",
//     "Maio 2020",
//     "Junho 2020"
//   ];
//   List<String> get faturas => _faturas;

//   String _currentAccount;
//   String get currentAccount => _currentAccount;
//   void updateCurrentAccount(String account) {
//     _currentAccount = account;
//     notifyListeners();
//   }

//   List cardsInfo = [
//     [
//       "THOMAS J K HELIO",
//       "7896-7897-5456-1231",
//       "10/26",
//       "456",
//       "Nubank",
//       "4565474676",
//       "6756765"
//     ],
//     [
//       "ANNE B M GONCALVES",
//       "4565-4564-4564-4564",
//       "03/24",
//       "123",
//       "Banco do Brasil",
//       "12345-8",
//       "45697846"
//     ],
//     [
//       "FELICIE V S TORRES",
//       "6589-1235-4125-6348",
//       "04/25",
//       "369",
//       "Inter",
//       "9898",
//       "346436-8"
//     ]
//   ];

//   Map get accounts => _accounts;
//   Map _accounts = {
//     '4565-4564-4564-4564': {
//       'saldo': 'R\$ 8.045,56',
//       'limite': 'R\$ 1.000,00',
//       'faturas': {
//         'Março 2020': {
//           'credito': {
//             'total': 'R\$ 740,00',
//             'disponivel': '',
//             'compras': {
//               9: {
//                 'data': '04/03/2020',
//                 'name': 'Renner',
//                 'money': 'R\$ 210,00',
//               },
//               8: {
//                 'data': '05/03/2020',
//                 'name': 'Habib\'s',
//                 'money': 'R\$ 45,00',
//               },
//               7: {
//                 'data': '09/03/2020',
//                 'name': 'Ifood',
//                 'money': 'R\$ 67,00',
//               },
//               6: {
//                 'data': '11/03/2020',
//                 'name': 'Padaria Love Love',
//                 'money': 'R\$ 12,00',
//               },
//               5: {
//                 'data': '11/03/2020',
//                 'name': 'Sol Eletrônicos',
//                 'money': 'R\$ 68,00',
//               },
//               4: {
//                 'data': '14/03/2020',
//                 'name': 'Castelo',
//                 'money': 'R\$ 40,00',
//               },
//               3: {
//                 'data': '17/03/2020',
//                 'name': 'Cia Paulista',
//                 'money': 'R\$ 130,00',
//               },
//               2: {
//                 'data': '17/03/2020',
//                 'name': 'Supermercado Formosa',
//                 'money': 'R\$ 90,00',
//               },
//               1: {
//                 'data': '17/03/2020',
//                 'name': 'Oplima',
//                 'money': 'R\$ 78,00',
//               },
//               0: {
//                 'data': '22/03/2020',
//                 'name': 'DIY Artes',
//                 'money': 'R\$ 45,00',
//               },
//             }
//           },
//           'debito': {
//             6: {
//               'data': '06/03/2020',
//               'name': 'Confeitaria Amor Doce',
//               'money': 'R\$ 20,00',
//             },
//             5: {
//               'data': '12/03/2020',
//               'name': 'Transferência (Recebido) Gabriela Dos Santos',
//               'money': 'R\$ 60,00',
//             },
//             4: {
//               'data': '12/03/2020',
//               'name': 'Cabanos',
//               'money': 'R\$ 10,00',
//             },
//             3: {
//               'data': '17/03/2020',
//               'name': 'Transferência (Recebido) Thomas Matos',
//               'money': 'R\$ 120,00',
//             },
//             2: {
//               'data': '18/03/2020',
//               'name': 'Depósito',
//               'money': 'R\$ 500,00',
//             },
//             1: {
//               'data': '26/03/2020',
//               'name': 'Transferência (Envio) Matheus Correia',
//               'money': 'R\$ 230,00',
//             },
//             0: {
//               'data': '26/03/2020',
//               'name': 'Pagamento de Fatura',
//               'money': 'R\$ 80,00',
//             },
//           }
//         },
//         'Abril 2020': {
//           'credito': {
//             'total': 'R\$ 566,00',
//             'disponivel': 'R\$ 434,00',
//             'compras': {
//               10: {
//                 'data': '02/04/2020',
//                 'name': 'Banca Reporter',
//                 'money': 'R\$ 21,00',
//               },
//               9: {
//                 'data': '03/04/2020',
//                 'name': 'Amorosa',
//                 'money': 'R\$ 37,00',
//               },
//               8: {
//                 'data': '07/04/2020',
//                 'name': 'Chris and Chris',
//                 'money': 'R\$ 24,00',
//               },
//               7: {
//                 'data': '07/04/2020',
//                 'name': 'Chris and Chris',
//                 'money': 'R\$ 24,00',
//               },
//               6: {
//                 'data': '08/04/2020',
//                 'name': 'Bonuelhos',
//                 'money': 'R\$ 17,00',
//               },
//               5: {
//                 'data': '08/04/2020',
//                 'name': 'Confeitaria Tudo Bom',
//                 'money': 'R\$ 6,00',
//               },
//               4: {
//                 'data': '10/04/2020',
//                 'name': 'Centauro',
//                 'money': 'R\$ 54,00',
//               },
//               3: {
//                 'data': '13/04/2020',
//                 'name': 'Sushi Boulevard',
//                 'money': 'R\$ 120,00',
//               },
//               2: {
//                 'data': '13/04/2020',
//                 'name': 'Lanchonete Topper',
//                 'money': 'R\$ 36,00',
//               },
//               1: {
//                 'data': '13/04/2020',
//                 'name': 'Riachuelo parc. 1/3',
//                 'money': 'R\$ 50,00',
//               },
//               0: {
//                 'data': '14/04/2020',
//                 'name': 'Livraria Saraiva',
//                 'money': 'R\$ 89,00',
//               },
//             }
//           },
//           'debito': {
//             4: {
//               'data': '02/04/2020',
//               'name': 'Pagamento de Fatura',
//               'money': 'R\$ 120,00',
//             },
//             3: {
//               'data': '06/04/2020',
//               'name': 'Transferência (Recebido) Haroldo Dos Santos',
//               'money': 'R\$ 36,00',
//             },
//             2: {
//               'data': '06/04/2020',
//               'name': 'Transferência (Envio) Ana Gabriela Souza',
//               'money': 'R\$ 50,00',
//             },
//             1: {
//               'data': '09/04/2020',
//               'name': 'Depósito',
//               'money': 'R\$ 120,00',
//             },
//             0: {
//               'data': '12/04/2020',
//               'name': 'Líder Umarizal',
//               'money': 'R\$ 230,00',
//             },
//           }
//         },
//         'Maio 2020': {
//           'credito': {
//             'total': 'R\$ 50,00',
//             'disponivel': 'R\$ 950,00',
//             'compras': {
//               0: {
//                 'data': '14/05/2020',
//                 'name': 'Riachuelo parc. 2/3',
//                 'money': 'R\$ 50,00',
//               },
//             },
//           },
//           'debito': {}
//         },
//         'Junho 2020': {
//           'credito': {
//             'total': 'R\$ 50,00',
//             'disponivel': 'R\$ 950,00',
//             'compras': {
//               0: {
//                 'data': '14/06/2020',
//                 'name': 'Riachuelo parc. 2/3',
//                 'money': 'R\$ 50,00',
//               },
//             },
//           },
//           'debito': {}
//         },
//       }
//     },
//     '7896-7897-5456-1231': {
//       'saldo': 'R\$ 8.045,56',
//       'limite': 'R\$ 1.000,00',
//       'faturas': {
//         'Março 2020': {
//           'credito': {
//             'total': 'R\$ 740,00',
//             'disponivel': '',
//             'compras': {
//               9: {
//                 'data': '04/03/2020',
//                 'name': 'Renner',
//                 'money': 'R\$ 210,00',
//               },
//               8: {
//                 'data': '05/03/2020',
//                 'name': 'Habib\'s',
//                 'money': 'R\$ 45,00',
//               },
//               7: {
//                 'data': '09/03/2020',
//                 'name': 'Ifood',
//                 'money': 'R\$ 67,00',
//               },
//               6: {
//                 'data': '11/03/2020',
//                 'name': 'Padaria Love Love',
//                 'money': 'R\$ 12,00',
//               },
//               5: {
//                 'data': '11/03/2020',
//                 'name': 'Sol Eletrônicos',
//                 'money': 'R\$ 68,00',
//               },
//               4: {
//                 'data': '14/03/2020',
//                 'name': 'Castelo',
//                 'money': 'R\$ 40,00',
//               },
//               3: {
//                 'data': '17/03/2020',
//                 'name': 'Cia Paulista',
//                 'money': 'R\$ 130,00',
//               },
//               2: {
//                 'data': '17/03/2020',
//                 'name': 'Supermercado Formosa',
//                 'money': 'R\$ 90,00',
//               },
//               1: {
//                 'data': '17/03/2020',
//                 'name': 'Oplima',
//                 'money': 'R\$ 78,00',
//               },
//               0: {
//                 'data': '22/03/2020',
//                 'name': 'DIY Artes',
//                 'money': 'R\$ 45,00',
//               },
//             }
//           },
//           'debito': {
//             6: {
//               'data': '06/03/2020',
//               'name': 'Confeitaria Amor Doce',
//               'money': 'R\$ 20,00',
//             },
//             5: {
//               'data': '12/03/2020',
//               'name': 'Transferência (Recebido) Gabriela Dos Santos',
//               'money': 'R\$ 60,00',
//             },
//             4: {
//               'data': '12/03/2020',
//               'name': 'Cabanos',
//               'money': 'R\$ 10,00',
//             },
//             3: {
//               'data': '17/03/2020',
//               'name': 'Transferência (Recebido) Thomas Matos',
//               'money': 'R\$ 120,00',
//             },
//             2: {
//               'data': '18/03/2020',
//               'name': 'Depósito',
//               'money': 'R\$ 500,00',
//             },
//             1: {
//               'data': '26/03/2020',
//               'name': 'Transferência (Envio) Matheus Correia',
//               'money': 'R\$ 230,00',
//             },
//             0: {
//               'data': '26/03/2020',
//               'name': 'Pagamento de Fatura',
//               'money': 'R\$ 80,00',
//             },
//           }
//         },
//         'Abril 2020': {
//           'credito': {
//             'total': 'R\$ 566,00',
//             'disponivel': 'R\$ 434,00',
//             'compras': {
//               10: {
//                 'data': '02/04/2020',
//                 'name': 'Banca Reporter',
//                 'money': 'R\$ 21,00',
//               },
//               9: {
//                 'data': '03/04/2020',
//                 'name': 'Amorosa',
//                 'money': 'R\$ 37,00',
//               },
//               8: {
//                 'data': '07/04/2020',
//                 'name': 'Chris and Chris',
//                 'money': 'R\$ 24,00',
//               },
//               7: {
//                 'data': '07/04/2020',
//                 'name': 'Chris and Chris',
//                 'money': 'R\$ 24,00',
//               },
//               6: {
//                 'data': '08/04/2020',
//                 'name': 'Bonuelhos',
//                 'money': 'R\$ 17,00',
//               },
//               5: {
//                 'data': '08/04/2020',
//                 'name': 'Confeitaria Tudo Bom',
//                 'money': 'R\$ 6,00',
//               },
//               4: {
//                 'data': '10/04/2020',
//                 'name': 'Centauro',
//                 'money': 'R\$ 54,00',
//               },
//               3: {
//                 'data': '13/04/2020',
//                 'name': 'Sushi Boulevard',
//                 'money': 'R\$ 120,00',
//               },
//               2: {
//                 'data': '13/04/2020',
//                 'name': 'Lanchonete Topper',
//                 'money': 'R\$ 36,00',
//               },
//               1: {
//                 'data': '13/04/2020',
//                 'name': 'Riachuelo parc. 1/3',
//                 'money': 'R\$ 50,00',
//               },
//               0: {
//                 'data': '14/04/2020',
//                 'name': 'Livraria Saraiva',
//                 'money': 'R\$ 89,00',
//               },
//             }
//           },
//           'debito': {
//             4: {
//               'data': '02/04/2020',
//               'name': 'Pagamento de Fatura',
//               'money': 'R\$ 120,00',
//             },
//             3: {
//               'data': '06/04/2020',
//               'name': 'Transferência (Recebido) Haroldo Dos Santos',
//               'money': 'R\$ 36,00',
//             },
//             2: {
//               'data': '06/04/2020',
//               'name': 'Transferência (Envio) Ana Gabriela Souza',
//               'money': 'R\$ 50,00',
//             },
//             1: {
//               'data': '09/04/2020',
//               'name': 'Depósito',
//               'money': 'R\$ 120,00',
//             },
//             0: {
//               'data': '12/04/2020',
//               'name': 'Líder Umarizal',
//               'money': 'R\$ 230,00',
//             },
//           }
//         },
//         'Maio 2020': {
//           'credito': {
//             'total': 'R\$ 50,00',
//             'disponivel': 'R\$ 950,00',
//             'compras': {
//               0: {
//                 'data': '14/05/2020',
//                 'name': 'Riachuelo parc. 2/3',
//                 'money': 'R\$ 50,00',
//               },
//             },
//           },
//           'debito': {}
//         },
//         'Junho 2020': {
//           'credito': {
//             'total': 'R\$ 50,00',
//             'disponivel': 'R\$ 950,00',
//             'compras': {
//               0: {
//                 'data': '14/06/2020',
//                 'name': 'Riachuelo parc. 2/3',
//                 'money': 'R\$ 50,00',
//               },
//             },
//           },
//           'debito': {}
//         },
//       }
//     },
//     '6589-1235-4125-6348': {
//       'saldo': 'R\$ 8.045,56',
//       'limite': 'R\$ 1.000,00',
//       'faturas': {
//         'Março 2020': {
//           'credito': {
//             'total': 'R\$ 740,00',
//             'disponivel': '',
//             'compras': {
//               9: {
//                 'data': '04/03/2020',
//                 'name': 'Renner',
//                 'money': 'R\$ 210,00',
//               },
//               8: {
//                 'data': '05/03/2020',
//                 'name': 'Habib\'s',
//                 'money': 'R\$ 45,00',
//               },
//               7: {
//                 'data': '09/03/2020',
//                 'name': 'Ifood',
//                 'money': 'R\$ 67,00',
//               },
//               6: {
//                 'data': '11/03/2020',
//                 'name': 'Padaria Love Love',
//                 'money': 'R\$ 12,00',
//               },
//               5: {
//                 'data': '11/03/2020',
//                 'name': 'Sol Eletrônicos',
//                 'money': 'R\$ 68,00',
//               },
//               4: {
//                 'data': '14/03/2020',
//                 'name': 'Castelo',
//                 'money': 'R\$ 40,00',
//               },
//               3: {
//                 'data': '17/03/2020',
//                 'name': 'Cia Paulista',
//                 'money': 'R\$ 130,00',
//               },
//               2: {
//                 'data': '17/03/2020',
//                 'name': 'Supermercado Formosa',
//                 'money': 'R\$ 90,00',
//               },
//               1: {
//                 'data': '17/03/2020',
//                 'name': 'Oplima',
//                 'money': 'R\$ 78,00',
//               },
//               0: {
//                 'data': '22/03/2020',
//                 'name': 'DIY Artes',
//                 'money': 'R\$ 45,00',
//               },
//             }
//           },
//           'debito': {
//             6: {
//               'data': '06/03/2020',
//               'name': 'Confeitaria Amor Doce',
//               'money': 'R\$ 20,00',
//             },
//             5: {
//               'data': '12/03/2020',
//               'name': 'Transferência (Recebido) Gabriela Dos Santos',
//               'money': 'R\$ 60,00',
//             },
//             4: {
//               'data': '12/03/2020',
//               'name': 'Cabanos',
//               'money': 'R\$ 10,00',
//             },
//             3: {
//               'data': '17/03/2020',
//               'name': 'Transferência (Recebido) Thomas Matos',
//               'money': 'R\$ 120,00',
//             },
//             2: {
//               'data': '18/03/2020',
//               'name': 'Depósito',
//               'money': 'R\$ 500,00',
//             },
//             1: {
//               'data': '26/03/2020',
//               'name': 'Transferência (Envio) Matheus Correia',
//               'money': 'R\$ 230,00',
//             },
//             0: {
//               'data': '26/03/2020',
//               'name': 'Pagamento de Fatura',
//               'money': 'R\$ 80,00',
//             },
//           }
//         },
//         'Abril 2020': {
//           'credito': {
//             'total': 'R\$ 566,00',
//             'disponivel': 'R\$ 434,00',
//             'compras': {
//               10: {
//                 'data': '02/04/2020',
//                 'name': 'Banca Reporter',
//                 'money': 'R\$ 21,00',
//               },
//               9: {
//                 'data': '03/04/2020',
//                 'name': 'Amorosa',
//                 'money': 'R\$ 37,00',
//               },
//               8: {
//                 'data': '07/04/2020',
//                 'name': 'Chris and Chris',
//                 'money': 'R\$ 24,00',
//               },
//               7: {
//                 'data': '07/04/2020',
//                 'name': 'Chris and Chris',
//                 'money': 'R\$ 24,00',
//               },
//               6: {
//                 'data': '08/04/2020',
//                 'name': 'Bonuelhos',
//                 'money': 'R\$ 17,00',
//               },
//               5: {
//                 'data': '08/04/2020',
//                 'name': 'Confeitaria Tudo Bom',
//                 'money': 'R\$ 6,00',
//               },
//               4: {
//                 'data': '10/04/2020',
//                 'name': 'Centauro',
//                 'money': 'R\$ 54,00',
//               },
//               3: {
//                 'data': '13/04/2020',
//                 'name': 'Sushi Boulevard',
//                 'money': 'R\$ 120,00',
//               },
//               2: {
//                 'data': '13/04/2020',
//                 'name': 'Lanchonete Topper',
//                 'money': 'R\$ 36,00',
//               },
//               1: {
//                 'data': '13/04/2020',
//                 'name': 'Riachuelo parc. 1/3',
//                 'money': 'R\$ 50,00',
//               },
//               0: {
//                 'data': '14/04/2020',
//                 'name': 'Livraria Saraiva',
//                 'money': 'R\$ 89,00',
//               },
//             }
//           },
//           'debito': {
//             4: {
//               'data': '02/04/2020',
//               'name': 'Pagamento de Fatura',
//               'money': 'R\$ 120,00',
//             },
//             3: {
//               'data': '06/04/2020',
//               'name': 'Transferência (Recebido) Haroldo Dos Santos',
//               'money': 'R\$ 36,00',
//             },
//             2: {
//               'data': '06/04/2020',
//               'name': 'Transferência (Envio) Ana Gabriela Souza',
//               'money': 'R\$ 50,00',
//             },
//             1: {
//               'data': '09/04/2020',
//               'name': 'Depósito',
//               'money': 'R\$ 120,00',
//             },
//             0: {
//               'data': '12/04/2020',
//               'name': 'Líder Umarizal',
//               'money': 'R\$ 230,00',
//             },
//           }
//         },
//         'Maio 2020': {
//           'credito': {
//             'total': 'R\$ 50,00',
//             'disponivel': 'R\$ 950,00',
//             'compras': {
//               0: {
//                 'data': '14/05/2020',
//                 'name': 'Riachuelo parc. 2/3',
//                 'money': 'R\$ 50,00',
//               },
//             },
//           },
//           'debito': {}
//         },
//         'Junho 2020': {
//           'credito': {
//             'total': 'R\$ 50,00',
//             'disponivel': 'R\$ 950,00',
//             'compras': {
//               0: {
//                 'data': '14/06/2020',
//                 'name': 'Riachuelo parc. 2/3',
//                 'money': 'R\$ 50,00',
//               },
//             },
//           },
//           'debito': {}
//         },
//       }
//     },
//   };
// }
