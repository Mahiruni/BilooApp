part of 'main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(overrides: [prefsProvider.overrideWithValue(prefs)], child: const BilooApp()));
}

final prefsProvider = Provider<SharedPreferences>((_) => throw UnimplementedError());
final appProvider = StateNotifierProvider<AppController, AppState>((ref) => AppController(ref.watch(prefsProvider)));

abstract final class T {
  static const ink = Color(0xFF000000), canvas = Color(0xFFF8F7F4), surface = Color(0xFFFFFFFF), stone = Color(0xFFE7E2D9), charcoal = Color(0xFF2A2A2A), muted = Color(0xFF8C8880), accent = Color(0xFFC8B189), alert = Color(0xFFC0392B);
  static const darkInk = Color(0xFFF8F7F4), darkCanvas = Color(0xFF000000), darkSurface = Color(0xFF0B0B0B), darkRaised = Color(0xFF141414), darkStone = Color(0xFF1E1C19), darkMuted = Color(0xFF6E6A64);
  static const gutter = 24.0, section = 56.0, card = 18.0, sheet = 28.0;
  static const hero = Duration(milliseconds: 420), reduced = Duration(milliseconds: 160);
  static final spring = SpringDescription.withDampingRatio(mass: 1, stiffness: 220, ratio: .82);
}

ThemeData theme(Brightness b) {
  final d = b == Brightness.dark, ink = d ? T.darkInk : T.ink, canvas = d ? T.darkCanvas : T.canvas, surface = d ? T.darkSurface : T.surface, stone = d ? T.darkStone : T.stone;
  return ThemeData(useMaterial3: true, brightness: b, scaffoldBackgroundColor: canvas, colorScheme: ColorScheme.fromSeed(seedColor: T.accent, brightness: b).copyWith(primary: ink, onPrimary: canvas, surface: surface, onSurface: ink, outline: stone), textTheme: ThemeData(brightness: b).textTheme.apply(fontFamily: 'Inter', bodyColor: ink, displayColor: ink), inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: surface, contentPadding: const EdgeInsets.fromLTRB(16, 22, 16, 8), border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: stone)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: stone)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: ink))));
}

TextStyle display(BuildContext c) => Theme.of(c).textTheme.displayMedium!.copyWith(fontSize: 34, height: 1.18, fontWeight: FontWeight.w400, letterSpacing: -.5);
TextStyle title(BuildContext c) => Theme.of(c).textTheme.titleLarge!.copyWith(fontSize: 24, height: 1.25, fontWeight: FontWeight.w500);
TextStyle body(BuildContext c) => Theme.of(c).textTheme.bodyMedium!.copyWith(fontSize: 15, height: 1.6);
TextStyle micro(BuildContext c) => Theme.of(c).textTheme.labelSmall!.copyWith(fontSize: 11, height: 1.27, fontWeight: FontWeight.w600, letterSpacing: .88);

class Product {
  const Product(this.id, this.brand, this.name, this.price, this.old, this.image, this.sizes, this.match);
  final String id, brand, name, image, match; final int price, old; final List<String> sizes;
}
const products = [
  Product('p1','TOTEME','Signature Wool Wrap Coat',12800,16000,'https://images.unsplash.com/photo-1539533113208-f6df8cc8b543?auto=format&fit=crop&w=900&q=84',['XS','S','M','L'],'M'),
  Product('p2','AERON','Fluid Tailored Trousers',7200,8900,'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?auto=format&fit=crop&w=900&q=84',['S','M','L','XL'],'M'),
  Product('p3','STUDIO NICHOLSON','Soft Structure Overshirt',8600,0,'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?auto=format&fit=crop&w=900&q=84',['XS','S','M','L','XL'],'L'),
  Product('p4','LEMAIRE','Draped Everyday Shirt',6900,7600,'https://images.unsplash.com/photo-1608234807905-4466023792f5?auto=format&fit=crop&w=900&q=84',['S','M','L'],'M'),
  Product('p5','OUR LEGACY','Relaxed Black Denim',8100,0,'https://images.unsplash.com/photo-1542272604-787c3835535d?auto=format&fit=crop&w=900&q=84',['28','30','32','34','36'],'32'),
  Product('p6','ARKET','Fine Merino Crew Knit',5200,6500,'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?auto=format&fit=crop&w=900&q=84',['XS','S','M','L','XL'],'M'),
];
String etb(int n) => 'ETB ${n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}';

class AppState {
  const AppState({this.started=false,this.auth=false,this.tab=0,this.wish=const{},this.cart=const{},this.sizes=const{},this.measure=const{'Height':'172','Chest':'94','Waist':'81','Hip':'96','Inseam':'79'}});
  final bool started, auth; final int tab; final Set<String> wish; final Map<String,int> cart; final Map<String,String> sizes, measure;
  AppState copyWith({bool? started,bool? auth,int? tab,Set<String>? wish,Map<String,int>? cart,Map<String,String>? sizes,Map<String,String>? measure}) => AppState(started:started??this.started,auth:auth??this.auth,tab:tab??this.tab,wish:wish??this.wish,cart:cart??this.cart,sizes:sizes??this.sizes,measure:measure??this.measure);
}
class AppController extends StateNotifier<AppState> {
  AppController(this.prefs):super(const AppState()){_load();} final SharedPreferences prefs;
  void _load(){final raw=prefs.getString('biloo_state'); if(raw==null)return; try{final j=jsonDecode(raw) as Map<String,dynamic>; state=AppState(started:j['started']==true,auth:j['auth']==true,tab:(j['tab'] as num?)?.toInt()??0,wish:Set<String>.from(j['wish']??const[]),cart:Map<String,int>.from((j['cart'] as Map? ?? const{}).map((k,v)=>MapEntry(k.toString(),(v as num).toInt()))),sizes:Map<String,String>.from(j['sizes']??const{}),measure:Map<String,String>.from(j['measure']??const{'Height':'172','Chest':'94','Waist':'81','Hip':'96','Inseam':'79'}));}catch(_){}}
  Future<void> _save()=>prefs.setString('biloo_state',jsonEncode({'started':state.started,'auth':state.auth,'tab':state.tab,'wish':state.wish.toList(),'cart':state.cart,'sizes':state.sizes,'measure':state.measure}));
  void start(){state=state.copyWith(started:true);_save();} void login(){state=state.copyWith(auth:true);_save();} void logout(){state=state.copyWith(auth:false);_save();} void tab(int i){state=state.copyWith(tab:i);_save();}
  void wish(String id){final x={...state.wish};x.contains(id)?x.remove(id):x.add(id);state=state.copyWith(wish:x);_save();HapticFeedback.lightImpact();}
  void size(String id,String s){state=state.copyWith(sizes:{...state.sizes,id:s});_save();HapticFeedback.lightImpact();}
  void add(String id,{int delta=1}){final m={...state.cart};m[id]=((m[id]??0)+delta).clamp(0,99);if(m[id]==0)m.remove(id);state=state.copyWith(cart:m);_save();HapticFeedback.lightImpact();}
  void clear(){state=state.copyWith(cart:{});_save();} void measurement(String k,String v){state=state.copyWith(measure:{...state.measure,k:v});_save();}
}

class BilooApp extends StatelessWidget { const BilooApp({super.key}); @override Widget build(BuildContext c)=>MaterialApp(debugShowCheckedModeBanner:false,title:'Biloo',theme:theme(Brightness.light),darkTheme:theme(Brightness.dark),themeMode:ThemeMode.system,home:const Gate()); }
class Gate extends ConsumerWidget { const Gate({super.key}); @override Widget build(BuildContext c,WidgetRef r){final s=r.watch(appProvider);return AnimatedSwitcher(duration:MediaQuery.disableAnimationsOf(c)?T.reduced:T.hero,child:!s.started?const Splash(key:ValueKey('s')):!s.auth?const Auth(key:ValueKey('a')):const Shell(key:ValueKey('m')));}}

class Mark extends StatelessWidget { const Mark({super.key,this.size=30}); final double size; @override Widget build(BuildContext c)=>Semantics(label:'Biloo',child:CustomPaint(size:Size(size,size*1.12),painter:MarkPainter(Theme.of(c).colorScheme.onSurface))); }
class MarkPainter extends CustomPainter { MarkPainter(this.color); final Color color; @override void paint(Canvas c,Size s){final p=Paint()..color=color..style=PaintingStyle.stroke..strokeWidth=s.width*.16..strokeJoin=StrokeJoin.miter;final x=s.width*.26;c.drawLine(Offset(x,s.height*.08),Offset(x,s.height*.92),p);final a=Path()..moveTo(x,s.height*.12)..lineTo(s.width*.67,s.height*.12)..lineTo(s.width*.83,s.height*.27)..lineTo(s.width*.67,s.height*.45)..lineTo(x,s.height*.45);final b=Path()..moveTo(x,s.height*.5)..lineTo(s.width*.7,s.height*.5)..lineTo(s.width*.88,s.height*.68)..lineTo(s.width*.7,s.height*.88)..lineTo(x,s.height*.88);c.drawPath(a,p);c.drawPath(b,p);} @override bool shouldRepaint(MarkPainter o)=>o.color!=color;}

class Primary extends StatelessWidget { const Primary(this.label,{super.key,required this.onTap,this.secondary=false});final String label;final VoidCallback? onTap;final bool secondary;@override Widget build(BuildContext c)=>SizedBox(height:56,width:double.infinity,child:secondary?OutlinedButton(onPressed:onTap,style:OutlinedButton.styleFrom(shape:const StadiumBorder()),child:Text(label)):FilledButton(onPressed:onTap,style:FilledButton.styleFrom(shape:const StadiumBorder()),child:Text(label)));}
