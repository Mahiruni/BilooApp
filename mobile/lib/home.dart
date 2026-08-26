part of 'main.dart';

class Home extends ConsumerWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext c, WidgetRef r) => Scaffold(
    appBar: const Top(),
    body: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              SizedBox(height: 310, width: double.infinity, child: Image.network('https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=900&q=74', fit: BoxFit.cover)),
              Container(height: 190, decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0x8A000000)]))),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('NEW COLLECTIONS', style: micro(c).copyWith(color: Colors.white)),
                  Text('20% OFF', style: display(c).copyWith(color: Colors.white)),
                  const SizedBox(height: 12),
                  OutlinedButton(onPressed: () => r.read(appProvider.notifier).tab(1), style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white54), shape: const StadiumBorder()), child: const Text('SHOP NOW')),
                ]),
              ),
            ],
          ),
        ),
        const SliverToBoxAdapter(child: SectionTitle('Shop by Category')),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 96,
            child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 20), children: const [
              Category('Women','https://images.unsplash.com/photo-1525507119028-ed4c629a60a3?auto=format&fit=crop&w=180&q=68'),
              Category('Men','https://images.unsplash.com/photo-1617127365659-c47fa864d8bc?auto=format&fit=crop&w=180&q=68'),
              Category('Teens','https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=180&q=68'),
              Category('Kids','https://images.unsplash.com/photo-1503919005314-30d93d07d823?auto=format&fit=crop&w=180&q=68'),
            ]),
          ),
        ),
        const SliverToBoxAdapter(child: SectionTitle('Curated For You')),
        SliverToBoxAdapter(child: SizedBox(height: 278, child: ListView.separated(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 20), itemCount: products.length, separatorBuilder: (_, __) => const SizedBox(width: 12), itemBuilder: (_, i) => ProductCard(products[i])))),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20,44,20,120),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('THE EDIT OF THE WEEK', style: micro(c)), const SizedBox(height: 12),
              ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.network('https://images.unsplash.com/photo-1558769132-cb1aea458c5e?auto=format&fit=crop&w=760&q=72', height: 330, width: double.infinity, fit: BoxFit.cover)),
              const SizedBox(height: 14), Text('Soft structure. Clear intent.', style: title(c)), Text('A restrained edit chosen to work together.', style: body(c)),
            ]),
          ),
        ),
      ],
    ),
  );
}

class SectionTitle extends StatelessWidget{const SectionTitle(this.text,{super.key});final String text;@override Widget build(BuildContext c)=>Padding(padding:const EdgeInsets.fromLTRB(20,44,20,16),child:Text(text,style:title(c)));}
class Category extends StatelessWidget{const Category(this.name,this.image,{super.key});final String name,image;@override Widget build(BuildContext c)=>Padding(padding:const EdgeInsets.only(right:14),child:Column(children:[ClipOval(child:Image.network(image,width:66,height:66,fit:BoxFit.cover)),const SizedBox(height:7),Text(name,style:const TextStyle(fontSize:12))]));}

class ProductCard extends ConsumerWidget {
  const ProductCard(this.p, {super.key});
  final Product p;
  @override
  Widget build(BuildContext c, WidgetRef r) {
    final w = r.watch(appProvider).wish.contains(p.id);
    return SizedBox(
      width: 146,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => openProduct(c, p),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            Hero(
              tag: 'product-${p.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AspectRatio(
                  aspectRatio: 4 / 5,
                  child: Image.network(p.image, width: double.infinity, fit: BoxFit.cover, alignment: const Alignment(0, -0.2)),
                ),
              ),
            ),
            Positioned(right: 4, top: 4, child: IconButton(style: IconButton.styleFrom(backgroundColor: Colors.white.withValues(alpha: .86), foregroundColor: Colors.black, minimumSize: const Size(38,38)), onPressed: () => r.read(appProvider.notifier).wish(p.id), icon: Icon(w ? Icons.favorite : Icons.favorite_border, size: 18))),
          ]),
          const SizedBox(height: 8),
          Text(p.brand, style: micro(c).copyWith(color: T.muted, fontSize: 10)),
          Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, height: 1.25)),
          const SizedBox(height: 3),
          Text(etb(p.price), style: const TextStyle(fontSize: 14, fontFeatures: [FontFeature.tabularFigures()])),
        ]),
      ),
    );
  }
}
