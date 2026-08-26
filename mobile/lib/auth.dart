part of 'main.dart';

class Splash extends ConsumerWidget { const Splash({super.key}); @override Widget build(BuildContext c,WidgetRef r)=>Scaffold(body:Stack(fit:StackFit.expand,children:[Image.network('https://images.unsplash.com/photo-1529139574466-a303027c1d8b?auto=format&fit=crop&w=1400&q=85',fit:BoxFit.cover,errorBuilder:(_,__,___)=>Container(color:Colors.black)),Container(decoration:const BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[Colors.transparent,Color(0xB3000000)]))),SafeArea(child:Padding(padding:const EdgeInsets.all(24),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Spacer(),const Mark(size:40),const SizedBox(height:28),Text('WEAR THE MOMENT',style:display(c).copyWith(fontSize:44,color:Colors.white,fontWeight:FontWeight.w300)),const SizedBox(height:14),Text('Curated edits, matched to your size, delivered by tomorrow.',style:body(c).copyWith(color:Colors.white.withOpacity(.85))),const SizedBox(height:28),Primary('Get Started',onTap:r.read(appProvider.notifier).start),])))]));}

class Auth extends ConsumerStatefulWidget { const Auth({super.key}); @override ConsumerState<Auth> createState()=>_AuthState(); }
class _AuthState extends ConsumerState<Auth> {
  final form = GlobalKey<FormState>();
  bool hide = true;
  @override
  Widget build(BuildContext c) => Scaffold(
    body: Stack(fit: StackFit.expand, children: [
      Image.network('https://images.unsplash.com/photo-1539109136881-3be0616acf4b?auto=format&fit=crop&w=1400&q=84', fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: T.stone)),
      Container(color: Colors.black.withOpacity(.12)),
      SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Theme.of(c).colorScheme.surface, borderRadius: BorderRadius.circular(28)),
            child: SingleChildScrollView(
              child: Form(
                key: form,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  const Mark(), const SizedBox(height: 20), Text('Welcome Back', style: title(c)), const SizedBox(height: 8),
                  Text('Sign in to pick up your edit, track orders and keep your saved pieces in one place.', style: body(c)), const SizedBox(height: 22),
                  TextFormField(initialValue: 'demo@biloo.app', decoration: const InputDecoration(labelText: 'Email or username'), validator: (v) => v == null || !v.contains('@') ? 'Enter a valid email address.' : null),
                  const SizedBox(height: 12),
                  TextFormField(initialValue: 'biloo123', obscureText: hide, decoration: InputDecoration(labelText: 'Password', suffixIcon: IconButton(onPressed: () => setState(() => hide = !hide), icon: Icon(hide ? Icons.visibility_outlined : Icons.visibility_off_outlined)))),
                  const SizedBox(height: 18), Primary('Login', onTap: () { if (form.currentState?.validate() ?? false) ref.read(appProvider.notifier).login(); }),
                  const SizedBox(height: 10), Row(children: [Expanded(child: Primary('Google', secondary: true, onTap: ref.read(appProvider.notifier).login)), const SizedBox(width: 8), Expanded(child: Primary('Apple', secondary: true, onTap: ref.read(appProvider.notifier).login))]),
                ]),
              ),
            ),
          ),
        ),
      ),
    ]),
  );
}

class Shell extends ConsumerWidget { const Shell({super.key}); @override Widget build(BuildContext c,WidgetRef r){final s=r.watch(appProvider);final pages=[const Home(),const Explore(),const Notifications(),const Profile()];return Scaffold(body:IndexedStack(index:s.tab,children:pages),bottomNavigationBar:SafeArea(top:false,minimum:const EdgeInsets.fromLTRB(16,0,16,12),child:ClipRRect(borderRadius:BorderRadius.circular(28),child:NavigationBar(height:68,selectedIndex:s.tab,onDestinationSelected:r.read(appProvider.notifier).tab,destinations:const[NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home),label:'Home'),NavigationDestination(icon:Icon(Icons.search_outlined),selectedIcon:Icon(Icons.search),label:'Explore'),NavigationDestination(icon:Icon(Icons.notifications_none),selectedIcon:Icon(Icons.notifications),label:'Notification'),NavigationDestination(icon:Icon(Icons.person_outline),selectedIcon:Icon(Icons.person),label:'Profile')]))));}}

class Top extends ConsumerWidget implements PreferredSizeWidget { const Top({super.key});@override Size get preferredSize=>const Size.fromHeight(64);@override Widget build(BuildContext c,WidgetRef r){final n=r.watch(appProvider).cart.values.fold<int>(0,(a,b)=>a+b);return AppBar(automaticallyImplyLeading:false,title:const Row(mainAxisSize:MainAxisSize.min,children:[Mark(size:26),SizedBox(width:8),Text('BILOO',style:TextStyle(fontSize:14,fontWeight:FontWeight.w700,letterSpacing:2.3))]),actions:[Stack(children:[IconButton(onPressed:()=>showCart(c,r),icon:const Icon(Icons.shopping_bag_outlined)),if(n>0)Positioned(right:4,top:5,child:Container(minWidth:16,height:16,padding:const EdgeInsets.symmetric(horizontal:3),decoration:const BoxDecoration(color:T.alert,shape:BoxShape.circle),alignment:Alignment.center,child:Text('$n',style:const TextStyle(color:Colors.white,fontSize:9))))])]);}}
