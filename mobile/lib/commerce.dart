part of 'main.dart';

void showCart(BuildContext c, WidgetRef r) {
  showModalBottomSheet(
    context: c,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => Consumer(builder: (c, r, _) {
      final s = r.watch(appProvider), items = s.cart.entries.toList();
      final total = items.fold<int>(0, (a, e) => a + products.firstWhere((p) => p.id == e.key).price * e.value);
      return Container(
        height: MediaQuery.sizeOf(c).height * .88,
        decoration: BoxDecoration(color: Theme.of(c).brightness == Brightness.dark ? T.darkRaised : T.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(28))),
        child: SafeArea(
          top: false,
          child: Column(children: [
            Padding(padding: const EdgeInsets.fromLTRB(24,18,12,12), child: Row(children: [Expanded(child: Text('Your Cart', style: title(c))), IconButton(onPressed: () => Navigator.pop(c), icon: const Icon(Icons.close))])),
            Expanded(
              child: items.isEmpty
                ? Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [Text('Your cart is clear', style: title(c)), const SizedBox(height: 8), Text('Saved pieces and your current edit are still waiting.', style: body(c))])))
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final e = items[i], p = products.firstWhere((x) => x.id == e.key);
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        leading: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(p.image, width: 64, height: 86, fit: BoxFit.cover)),
                        title: Text(p.name),
                        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('${s.sizes[p.id] ?? p.match} · Delivery tomorrow'),
                          Row(children: [IconButton(onPressed: () => r.read(appProvider.notifier).add(p.id, delta: -1), icon: const Icon(Icons.remove_circle_outline)), Text('${e.value}'), IconButton(onPressed: () => r.read(appProvider.notifier).add(p.id), icon: const Icon(Icons.add_circle_outline))]),
                        ]),
                        trailing: Text(etb(p.price * e.value)),
                      );
                    },
                  ),
            ),
            if (items.isNotEmpty)
              Padding(padding: const EdgeInsets.all(24), child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)), Text(etb(total), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18))]),
                const SizedBox(height: 16),
                Primary('CHECKOUT', onTap: () { Navigator.pop(c); showCheckout(c, r); }),
              ])),
          ]),
        ),
      );
    }),
  );
}

void showCheckout(BuildContext c, WidgetRef r) {
  showModalBottomSheet(context: c, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (_) => Checkout(ref: r));
}
class Checkout extends StatefulWidget {
  const Checkout({super.key, required this.ref});
  final WidgetRef ref;
  @override
  State<Checkout> createState() => _CheckoutState();
}
class _CheckoutState extends State<Checkout> {
  final form = GlobalKey<FormState>();
  bool loading = false;
  @override
  Widget build(BuildContext c) {
    final s = widget.ref.read(appProvider);
    final total = s.cart.entries.fold<int>(0, (a, e) => a + products.firstWhere((p) => p.id == e.key).price * e.value);
    return Container(
      height: MediaQuery.sizeOf(c).height * .94,
      decoration: BoxDecoration(color: Theme.of(c).brightness == Brightness.dark ? T.darkRaised : T.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(28))),
      child: SafeArea(
        top: false,
        child: ListView(padding: const EdgeInsets.all(24), children: [
          Row(children: [Expanded(child: Text('Checkout', style: title(c))), IconButton(onPressed: () => Navigator.pop(c), icon: const Icon(Icons.close))]),
          Form(key: form, child: Column(children: [
            TextFormField(initialValue: 'Mahir', decoration: const InputDecoration(labelText: 'Name'), validator: (v) => v == null || v.isEmpty ? 'Enter your name.' : null),
            const SizedBox(height: 12),
            TextFormField(initialValue: '912345678', keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone', prefixText: '+251 '), validator: (v) => v == null || v.length < 9 ? 'Enter the remaining digits.' : null),
            const SizedBox(height: 12), TextFormField(initialValue: 'Addis Ababa', decoration: const InputDecoration(labelText: 'City')),
            const SizedBox(height: 12), TextFormField(initialValue: 'Bole', decoration: const InputDecoration(labelText: 'Area / address')),
          ])),
          const SizedBox(height: 30), Align(alignment: Alignment.centerLeft, child: Text('Pay', style: title(c))), const SizedBox(height: 12),
          Wrap(spacing: 8, children: ['Apple Pay','Google Pay','Card · demo'].map((x) => ActionChip(label: Text(x), onPressed: () => snack(c, '$x selected for demo checkout'))).toList()),
          const SizedBox(height: 28),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)), Text(etb(total), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18))]),
          const SizedBox(height: 20),
          Primary(loading ? 'Placing order…' : 'PLACE ORDER', onTap: loading ? null : () {
            if (!(form.currentState?.validate() ?? false)) return;
            setState(() => loading = true);
            Future.delayed(const Duration(milliseconds: 650), () {
              if (!mounted) return;
              widget.ref.read(appProvider.notifier).clear(); HapticFeedback.mediumImpact(); Navigator.pop(c);
              showDialog(context: c, builder: (d) => AlertDialog(title: const Text('Order placed'), content: const Text('Delivery expected tomorrow.\n\nThis is a demo checkout; no money was charged.'), actions: [TextButton(onPressed: () => Navigator.pop(d), child: const Text('Continue'))]));
            });
          }),
        ]),
      ),
    );
  }
}

void showFit(BuildContext c, WidgetRef r) {
  showModalBottomSheet(
    context: c,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => Consumer(builder: (c, r, _) {
      final m = r.watch(appProvider).measure;
      return Container(
        height: MediaQuery.sizeOf(c).height * .92,
        decoration: BoxDecoration(color: Theme.of(c).brightness == Brightness.dark ? T.darkRaised : T.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(28))),
        child: SafeArea(
          top: false,
          child: ListView(padding: const EdgeInsets.all(24), children: [
            Row(children: [Expanded(child: Text('Size & Fit Profile', style: title(c))), IconButton(onPressed: () => Navigator.pop(c), icon: const Icon(Icons.close))]),
            Text('Fit that starts with you', style: display(c)), const SizedBox(height: 10),
            Text('Add measurements yourself or use guided sizing. Camera permission is requested only in context.', style: body(c)), const SizedBox(height: 16),
            Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Theme.of(c).colorScheme.surface, borderRadius: BorderRadius.circular(18)), child: Text('Privacy: production camera scanning should store measurement results rather than unnecessary footage. Manual measurement always remains available.', style: body(c))),
            const SizedBox(height: 18),
            ...m.entries.map((e) => Padding(padding: const EdgeInsets.only(bottom: 12), child: TextFormField(initialValue: e.value, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: '${e.key} · cm'), onChanged: (v) => r.read(appProvider.notifier).measurement(e.key, v)))),
            Primary('Use guided scan', secondary: true, onTap: () => snack(c, 'Native camera adapter requires the camera package and platform permissions. Manual fit remains available.')),
            const SizedBox(height: 10), Primary('Save profile', onTap: () { HapticFeedback.lightImpact(); Navigator.pop(c); }),
          ]),
        ),
      );
    }),
  );
}
