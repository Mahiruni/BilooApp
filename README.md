# Biloo

**Wear the Moment** — a quiet-luxury fashion commerce concept with fit-aware curation and next-day delivery messaging.

This repository contains two implementations of the same product specification:

- `/` — deployable browser preview/PWA for stakeholder testing before APK packaging.
- `/mobile` — Flutter source intended for Android/iOS/Web builds.

## Browser preview

The preview is dependency-free and can be served as static files:

```bash
python3 -m http.server 8080
```

Then open `http://localhost:8080`.

The preview includes splash/auth, Home, Explore/search, Product Detail, wishlist, cart, checkout demo, measurement profile, browser camera permission flow, notifications permission flow, Profile, offline messaging, local persistence and OLED-aware styling.

### Demo authentication

Use the prefilled credentials or either social demo button. Production Google/Apple OAuth requires provider credentials and is intentionally kept behind an integration seam.

### Payments

Checkout is a functional demo flow, not a live money movement integration. Apple Pay / Google Pay / card processing require merchant/provider credentials before production use.

## Flutter mobile app

```bash
cd mobile
./scripts/bootstrap_flutter.sh
flutter run
```

The bootstrap script generates standard Flutter platform folders if they are not yet present, gets packages, and keeps `lib/` intact.

### Production integration seams

- Authentication provider
- Product/catalog API
- Recommendation/fit service
- Inventory + delivery promise API
- Payment provider
- Order backend
- Push notification backend

Until those credentials/services are supplied, the app runs against curated demo data with local persistence.
