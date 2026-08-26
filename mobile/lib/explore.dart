part of 'main.dart';

class Explore extends ConsumerStatefulWidget {
  const Explore({super.key});
  @override
  ConsumerState<Explore> createState() => _ExploreState();
}
class _ExploreState extends ConsumerState<Explore> {
  String q = '';
  Timer? timer;
  @override
  void dispose() { timer?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext c) {
    final list = products.where((p) => ('${p.brand} ${p.name}').toLowerCase().contains(q.toLowerCase())).toList();
    return Scaffold(
      appBar: const Top(),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24,22,24,16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('DISCOVER', style: micro(c)), Text('Explore', style: display(c)), const SizedBox(height: 20),
              TextField(decoration: const InputDecoration(labelText: 'Search pieces and brands', prefixIcon: Icon(Icons.search)), onChanged: (v) { timer?.cancel(); timer = Timer(const Duration(milliseconds: 180), () => setState(() => q = v)); }),
            ]),
          ),
        ),
        if (list.isEmpty)
          SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(48), child: Column(children: [Text('Nothing exact for “$q”', style: title(c)), const SizedBox(height: 8), Text('Try tailoring, knitwear or relaxed essentials.', style: body(c))])))
        else
          SliverPadding(padding: const EdgeInsets.fromLTRB(24,8,24,120), sliver: SliverGrid.builder(itemCount: list.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 22, childAspectRatio: .52), itemBuilder: (_, i) => ProductCard(list[i]))),
      ]),
    );
  }
}

void openProduct(BuildContext c, Product p) {
  Navigator.of(c).push(PageRouteBuilder(
    transitionDuration: MediaQuery.disableAnimationsOf(c) ? T.reduced : T.hero,
    pageBuilder: (_, __, ___) => ProductPage(p),
    transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
  ));
}
class ProductPage extends ConsumerWidget {
  const ProductPage(this.p, {super.key});
  final Product p;
  @override
  Widget build(BuildContext c, WidgetRef r) {
    final s = r.watch(appProvider), sel = s.sizes[p.id] ?? p.match;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(padding: const EdgeInsets.only(bottom: 100), children: [
        Hero(tag: 'product-${p.id}', child: InteractiveViewer(maxScale: 4, child: Image.network(p.image, height: 470, width: double.infinity, fit: BoxFit.cover))),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${p.brand} · ★ 4.8', style: micro(c).copyWith(color: T.muted)), const SizedBox(height: 8),
            Text(p.name, style: title(c)), const SizedBox(height: 10),
            Text(etb(p.price), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFeatures: [FontFeature.tabularFigures()])),
            const SizedBox(height: 22), Text('An intentionally cut piece with a soft hand and controlled drape.', style: body(c)),
            const SizedBox(height: 30), const Text('Size'), const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: p.sizes.map((x) => ChoiceChip(label: Text(x), selected: sel == x, showCheckmark: false, onSelected: (_) => r.read(appProvider.notifier).size(p.id, x))).toList()),
            const SizedBox(height: 12),
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: T.accent.withValues(alpha: .22), borderRadius: BorderRadius.circular(16)), child: Text('Size ${p.match} · matched to your profile', style: const TextStyle(fontSize: 12))),
            const SizedBox(height: 28), const Text('Delivery tomorrow', style: TextStyle(fontWeight: FontWeight.w600)),
            Text('Order before the local fulfillment cutoff.', style: body(c).copyWith(color: T.muted)),
          ]),
        ),
      ]),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Expanded(child: Primary('ADD TO CART', secondary: true, onTap: () => r.read(appProvider.notifier).add(p.id))),
            const SizedBox(width: 10),
            Expanded(child: Primary('BUY NOW', onTap: () { r.read(appProvider.notifier).add(p.id); showCheckout(c, r); })),
          ]),
        ),
      ),
    );
  }
}

class Notifications extends StatelessWidget {
  const Notifications({super.key});
  @override
  Widget build(BuildContext c) => Scaffold(
    appBar: const Top(),
    body: ListView(padding: const EdgeInsets.only(bottom: 120), children: [
      Padding(padding: const EdgeInsets.all(24), child: Text('Notifications', style: display(c))),
      const Padding(padding: EdgeInsets.fromLTRB(24,12,24,8), child: Text('TODAY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: .88))),
      const Note('Your next-day edit is ready', 'Six pieces match your fit profile and can arrive tomorrow.'),
      const Note('Saved piece back in your size', 'The Soft Structure Overshirt is available again in L.'),
    ]),
  );
}
class Note extends StatelessWidget {
  const Note(this.a, this.b, {super.key});
  final String a, b;
  @override
  Widget build(BuildContext c) => ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8), leading: const CircleAvatar(radius: 4, backgroundColor: T.ink), title: Text(a), subtitle: Text(b), trailing: const Text('now', style: TextStyle(fontSize: 11, color: T.muted)));
}

class Profile extends ConsumerWidget {
  const Profile({super.key});
  @override
  Widget build(BuildContext c, WidgetRef r) {
    final s = r.watch(appProvider);
    return Scaffold(
      appBar: const Top(),
      body: ListView(padding: const EdgeInsets.fromLTRB(24,24,24,120), children: [
        Text('YOUR BILOO', style: micro(c)), Text('Mahir', style: display(c)), Text('View and edit account', style: body(c).copyWith(color: T.muted)), const SizedBox(height: 28),
        _row(c, 'Orders', 'Recent delivery · tomorrow', () => snack(c, 'Orders are ready for backend connection')),
        _row(c, 'Saved Pieces', '${s.wish.length} saved', () => snack(c, 'Wishlist is stored locally')),
        _row(c, 'Style Preferences', 'Quiet tailoring · neutral', () => snack(c, 'Style preferences are ready')),
        _row(c, 'Measurement Profile', 'Completed', () => showFit(c, r)),
        _row(c, 'Addresses', 'Addis Ababa', () => snack(c, 'Addresses are ready for backend connection')),
        _row(c, 'Payments', 'Demo mode', () => snack(c, 'Live payments need merchant credentials')),
        const SizedBox(height: 24), Primary('Sign out', secondary: true, onTap: r.read(appProvider.notifier).logout),
      ]),
    );
  }
}
Widget _row(BuildContext c, String a, String b, VoidCallback tap) => ListTile(contentPadding: EdgeInsets.zero, minTileHeight: 62, title: Text(a), trailing: Text('$b  ›', style: const TextStyle(color: T.muted)), onTap: tap);
void snack(BuildContext c, String t) => ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(t)));
