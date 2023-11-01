import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertarea/forms/addForm.dart';
import 'package:fluttertarea/forms/editForm.dart';
import 'package:fluttertarea/state_managment.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<CartItem> cartItems = ref.watch(filteredCartListProvider);

    // Conteo total de items para añadir uno nuevo a partir del último
    int totalItems = ref.read(cartListProvider.notifier).countTotalItems();

    // Valor del menu dropDown
    String dropDownValue = ref.watch(menuProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Formulario de tienda'),
        actions: [
          DropdownButton(
              style: const TextStyle(color: Colors.black),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
              value: dropDownValue,

              // se crea una lista de items a partir de la que definimos en state_managment.dart
              items: menuItems
                  .map((String e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),

              // al cambiar se asigna un nuevo valor al provider del menu
              onChanged: (String? value) => ref
                  .read(menuProvider.notifier)
                  .update((state) => state = value!))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
            itemBuilder: ((context, index) {
              return GestureDetector(
                onHorizontalDragEnd: (details) {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return EditItem(
                            id: cartItems[index].id!,
                            currentName: cartItems[index].name.toString(),
                            currentQuantity: cartItems[index].quantity);
                      });
                },
                child: Card(
                  elevation: 2,
                  child: CheckboxListTile(
                    title: Text(
                        '${cartItems[index].quantity} ${cartItems[index].name}'),
                    value: cartItems[index].inCart,
                    onChanged: (value) => ref
                        .read(cartListProvider.notifier)
                        .toggle(cartItems[index].id!),
                  ),
                ),
              );
            }),
            separatorBuilder: ((context, index) => const SizedBox(
                  height: 8,
                )),
            itemCount: cartItems.length),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showModalBottomSheet(
            context: context,
            builder: (context) {
              return AddItem();
            }),
      ),
    );
  }
}
