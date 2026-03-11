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
Réessayer (1), voir la règle (2) ou voir la réponse (3) ? 3
e c'hazh — Lénition : k → c'h
Score : 1/2
```

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

---

*Projet développé par Morgane Bona-Pellissier — 2026*
