# KEMMADUR : Entraînement aux mutations initiales bretonnes

> ⚠️ **Ce projet est en cours de développement.**

Outil CLI en Python pour s'entraîner aux mutations initiales en breton (*kemmadurioù*). Quiz interactif couvrant la lénition, la spirantisation, le durcissement et la mutation mixte.

## Description

Les mutations initiales (*kemmadurioù*) sont l'un des aspects les plus caractéristiques — et les plus redoutés — de la morphophonologie bretonne. La consonne initiale d'un mot est modifiée en fonction du mot grammatical qui le précède (possessifs, articles, prépositions, numéraux…).

Ce programme permet de les pratiquer sous forme de quiz interactif :
- Le programme affiche un **déclencheur** et un **mot** (ex : `da + tad`)
- L'utilisateur doit donner la forme mutée (ex : `da dad`)

```
$ python scripts/kemmadur.py --mutation lénition
Combien de mots voulez-vous pratiquer (entre 1 et 10) ? 3

Quel est le résultat de : da + tad ?
Réponse : da dad
Bravo !

Quel est le résultat de : e + kazh ?
Réponse : e gazh
Mauvaise réponse ! Gwall eo...
Réessayer (1), voir le genre (2), voir la catégorie de mutation (3) voir la réponse (4) ? 2
Genre : kazh est masculin (g.m.)
Réessayer (1), voir le genre (2), voir la catégorie de mutation (3) ou voir la réponse (4) ? 3
Catégorie : lénition (adoucissement)
Réessayer (1), voir le genre (2), voir la catégorie de mutation (3) ou voir la réponse (4) ? 5
e c'hazh — Lénition : k → c'h
Score : 1/2
```

À l'image du fonctionnement de [Magister Conjugationis](https://github.com/crispyfunicular/magister_conjugationis/) (qui propose de « voir les temps primitifs » ou « voir le lemme » en cas d'erreur), Kemmadur propose un **système d'indices progressifs** en cas de mauvaise réponse :

1. **Réessayer** — Tenter de nouveau sa chance.
2. **Voir le genre** — Affiche le genre grammatical du mot (*masculin*, *féminin*), indice utile car certaines mutations sont déclenchées par le genre.
3. **Voir la catégorie de mutation** — Affiche le type de mutation attendu (*lénition*, *spirantisation*, *durcissement*, *mixte*), sans donner directement la forme mutée.
4. **Voir la règle** — Affiche la règle de mutation applicable (ex : `k → c'h`).
5. **Voir la réponse** — Affiche la réponse complète (aucun point attribué).

## Rappel : les mutations bretonnes

| Lettre | Lénition | Spirantisation | Durcissement |
|--------|----------|----------------|--------------|
| **k**  | g        | c'h            | —            |
| **p**  | b        | f              | —            |
| **t**  | d        | z              | —            |
| **b**  | v        | —              | p            |
| **d**  | z        | —              | t            |
| **g**  | c'h      | —              | k            |
| **gw** | w        | —              | kw           |
| **m**  | v        | —              | —            |

**Exemples de déclencheurs :**
- **Lénition** : *da* (ton), *e* (son/sa masc.)…
- **Spirantisation** : *ma* (mon), *he* (son/sa fém.), *o* (leur), *tri/teir* (trois)…
- **Durcissement** : *ho* (votre), *az* (de)…

## Installation

```bash
git clone https://github.com/<username>/kemmadur.git
cd kemmadur
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## Utilisation

Les scripts sont conçus pour être lancés depuis la racine du projet :

```bash
python scripts/kemmadur.py --help
```

### Options disponibles

| Option | Description |
|--------|-------------|
| `--mutation` | Filtrer par type de mutation (`lénition`, `spirantisation`, `durcissement`, `mixte`) |
| `--trigger` | Filtrer par déclencheur (`da`, `ma`, `he`…) |
| `--debug` | Activer le mode debug |

## Structure du projet

```
kemmadur/
├── scripts/
│   ├── kemmadur.py         # Script CLI principal
│   ├── mutations.py        # Moteur de mutations
│   └── test_kemmadur.py    # Tests unitaires
├── data/
│   ├── words.json          # Mots à étudier
│   └── triggers.json       # Déclencheurs de mutations
├── README.md
├── requirements.txt
└── LICENSE
```

## Feuille de route

- [x] Modélisation des mutations (lénition, spirantisation, durcissement, mixte)
- [ ] Quiz interactif (déclencheur + mot → forme mutée)
- [ ] Mode traduction (forme mutée → traduction française)
- [ ] Interface web

## Licence

MIT
