# Calc Noir

Application Flutter mobile et web pour calculs rapides avec résultats instantanés, historique local et design premium sombre.

## Fonctionnalités

- Calculs basiques : addition, soustraction, multiplication, division, modulo
- Calculs avancés : puissance, racine carrée, sin, cos, log, constantes π et e
- Prévisualisation du résultat pendant la saisie
- Historique local persistant via SharedPreferences
- Écran statistiques
- UI responsive mobile, tablette et web
- Preview statique disponible dans `public/preview.html`

## Lancement

```bash
flutter pub get
flutter run
```

## Build web

```bash
flutter build web --release --base-href "/"
```

## Structure

- `lib/main.dart` : entrée Flutter et routing
- `lib/theme` : thème premium sombre
- `lib/services` : moteur de calcul et stockage local
- `lib/screens` : écrans principaux
- `lib/widgets` : composants réutilisables
- `web/index.html` : entrée Flutter Web
- `public/preview.html` : aperçu HTML/CSS immédiat
