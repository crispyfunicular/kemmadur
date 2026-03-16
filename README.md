# KEMMADUR : Entraînement aux mutations initiales bretonnes

> ⚠️ **Ce projet est en cours de développement.**

Outil pour s'entraîner aux mutations initiales en breton (*kemmadurioù*). Le projet génère des questions de type quiz à partir d'une base de données SQLite couvrant la lénition (adoucissement), la spirantisation, le durcissement et la mutation mixte.

## Description

Les mutations initiales (*kemmadurioù*) sont l'un des aspects les plus caractéristiques — et les plus redoutés — de la morphophonologie bretonne. La consonne initiale d'un mot est modifiée en fonction du mot grammatical qui le précède (articles, possessifs, prépositions, numéraux…).

Ce projet modélise ces mutations en SQL et génère automatiquement des questions d'entraînement :
- **Déclencheur + nom** → forme mutée (ex : `da + tad = da dad`)
- **Nom féminin + adjectif** → adjectif muté (ex : `mamm + brav = mamm vrav`)
- **Article + nom** → article correct + mutation éventuelle (ex : `ar + bro = ar vro`)
- **Article + nom + adjectif** → mutations combinées (ex : `ur + mamm + brav = ur vamm vrav`)

Un quiz interactif en ligne de commande (Python + Rich) permet de s'entraîner sur ces combinaisons, à l'image de [Magister Conjugationis](https://github.com/crispyfunicular/magister_conjugationis/).

## Rappel : les mutations bretonnes

| Lettre | Lénition (adoucissement) | Spirantisation | Durcissement | Mixte |
|--------|--------------------------|----------------|--------------|-------|
| **k**  | g                        | c'h            | —            | —     |
| **kw** | —                        | —              | —            | —     |
| **p**  | b                        | f              | —            | —     |
| **t**  | d                        | z              | —            | —     |
| **g**  | c'h                      | —              | k            | c'h   |
| **gw** | w                        | —              | kw           | w     |
| **d**  | z                        | —              | t            | z     |
| **b**  | v                        | —              | p            | v     |
| **m**  | v                        | —              | —            | v     |

**Déclencheurs :**
- **Lénition (adoucissement)** : *a*, *da*, *daou*, *div*, *dindan*, *diwar*, *dre*, *e* (possessif masc.), *eme*, *en em*, *en ur*, *hanter*, *holl*, *na*, *ne*, *pa*, *pe*, *re*, *war*… + article + nom féminin singulier, article + nom masculin pluriel (en *-ou*), nom féminin + adjectif
- **Spirantisation** : *ma/va* (mon), *he* (son/sa fém.), *o* (leur), *tri/teir* (trois), *pevar/peder* (quatre), *nav* (neuf)
- **Durcissement** : *ho* (votre), *az/ez* (te/toi), *da'z* (à toi)…
- **Mixte** : participe présent (*o* + verbe), après la particule verbale *e*, après *ma* (que)

## Installation

```bash
git clone https://github.com/crispyfunicular/kemmadur.git
cd kemmadur
pip install rich
```

La base SQLite `kemmadur.db` est fournie prête à l'emploi. Pour la recréer depuis les fichiers source :

```bash
sqlite3 kemmadur.db < tables.sql
```

## Utilisation

Lancer le quiz interactif :

```bash
python3 kemmadur.py
```

Exemple de session :

```
Degemer mat ! Bienvenue dans le test de mutations bretonnes.
ar + mamm + brav = ?: ar vamm vrav
Mat tre !
ur + tad + kozh = ?: ur tad kozh
Mat tre !
---
Fin de l'exercice ! Votre score : 2 / 2
```

## Structure du projet

```
kemmadur/
├── kemmadur.py         # Script principal (quiz interactif CLI)
├── tables.sql          # Schéma + données (noms, adjectifs, déclencheurs, mutations)
├── requetes.sql        # Requêtes SQL (tagées @query pour chargement Python)
├── kemmadur.db         # Base SQLite pré-remplie
├── anki/               # Deck Anki source
├── README.md
└── LICENSE
```

## Feuille de route

- [x] Modélisation des mutations (lénition, spirantisation, durcissement, mixte)
- [x] Base de données SQL + requêtes de génération de questions
- [x] Quiz interactif CLI en Python
- [ ] Choix du type d'exercice (déclencheurs, adjectifs, articles, complet)
- [ ] Système d'indices progressifs (genre, catégorie de mutation, règle, réponse)
- [ ] Mode traduction (forme mutée → traduction française)
- [ ] Interface web

## Licence

MIT
