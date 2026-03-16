-- Mutations
CREATE TABLE IF NOT EXISTS mutations (
    lettre_initiale TEXT PRIMARY KEY,
    durcissante TEXT,
    adoucissante TEXT,
    spirante TEXT
);

INSERT INTO mutations (lettre_initiale, durcissante, adoucissante, spirante)
VALUES
    ('g', 'k', 'c''h', NULL),
    ('k', NULL, 'g', 'c''h'),
    ('gw', 'kw', 'w', NULL),
    ('d', 't', 'z', NULL),
    ('t', NULL, 'd', 'z'),
    ('m', NULL, 'v', NULL),
    ('b', 'p', 'v', NULL),
    ('p', NULL, NULL, 'f');

-- Adjectifs
CREATE TABLE IF NOT EXISTS adjectifs (
    id TEXT PRIMARY KEY,
    breton TEXT,
    français TEXT
);

INSERT INTO adjectifs (breton, français)
VALUES
    ('gwir', 'vrai'),
    ('hir', 'long'),
    ('hegarat', 'aimable'),
    ('skuizh', 'fatigué'),
    ('yaouank', 'jeune'),
    ('tenn', 'difficile'),
    ('pell', 'loin'),
    ('kozh', 'vieux'),
    ('brav', 'beau');


-- Noms
CREATE TABLE IF NOT EXISTS noms (
    id INTEGER PRIMARY KEY,
    breton TEXT,
    français TEXT,
    genre TEXT,
    pluriel TEXT
);

INSERT INTO noms (breton, français, genre, pluriel)
VALUES
    ('tad', 'père', 'm', 'tadoù'),
    ('ti', 'maison', 'm', 'tiez'),
    ('mamm', 'mère', 'f', 'mammoù'),
    ('penn', 'tête', 'm', 'pennoù'),
    ('levr', 'livre', 'm', 'levrioù'),
    ('c''hoar', 'sœur', 'f', 'c''hoarezed'),
    ('familh', 'famille', 'f', 'familhoù'),
    ('anv', 'nom', 'm', 'anvioù'),
    ('breur', 'frère', 'm', 'breudeur'),
    ('gouel', 'fête', 'm', 'gouelioù'),
    ('diaoul', 'diable', 'm', 'diaouled'),
    ('skol', 'école', 'f', 'skolioù'),
    ('kan', 'chant', 'm', 'kanoù'),
    ('kann', 'bagarre', 'm', 'kannoù'),
    ('mel', 'miel', 'm', NULL),
    ('maez', 'campagne', 'm', 'maezioù'),
    ('tud', 'gens', 'pl', NULL),
    ('mor', 'mer', 'm', 'morioù'),
    ('prenestr', 'fenêtre', 'm', 'prenestroù'),
    ('gwezh', 'fois', 'f', 'gwezhioù'),
    ('mouezh', 'voix', 'f', 'mouezhioù'),
    ('plasenn', 'place', 'f', 'plasennoù'),
    ('bro', 'pays', 'f', 'broioù'),
    ('straed', 'rue', 'f', 'straedoù'),
    ('ti-post', 'poste', 'm', 'tiez-post'),
    ('studier', 'étudiant', 'm', 'studierien'),
    ('plac''h', 'fille', 'f', 'merc''hed'),
    ('micher', 'métier', 'f', 'micherioù'),
    ('glav', 'pluie', 'm', 'glaveier'),
    ('bloaz', 'année', 'm', 'bloavezhioù'),
    ('matematikoù', 'mathématiques', 'pl', NULL),
    ('bed', 'monde', 'm', 'bedoù'),
    ('amzer', 'temps', 'f', 'amzerioù'),
    ('gwreg', 'épouse', 'f', 'gwragez');


-- Déclencheurs
CREATE TABLE IF NOT EXISTS déclencheurs (
    id INTEGER PRIMARY KEY,
    mot TEXT,
    mutation TEXT,
    critère_genre TEXT,
    critère_pl TEXT
);

INSERT INTO déclencheurs (mot, mutation, critère_genre)
VALUES
    -- Les articles (en fonction du mot suivant)
    ('ar', 'adoucissante', 'f'),
    ('an', 'adoucissante', 'f'),
    ('al', 'adoucissante', 'f'),
    ('ur', 'adoucissante', 'f'),
    ('un', 'adoucissante', 'f'),
    ('ul', 'adoucissante', 'f'),
    -- L'exception des hommes au pluriel
    ('ar', 'adoucissante', 'm'), 

    -- Les pronoms possessifs (peu importe le mot suivant)
    ('ma', 'spirante', NULL),    -- mon
    ('va', 'spirante', NULL),    -- mon
    ('e', 'adoucissante', NULL), -- son/sa (à lui)
    ('he', 'spirante', NULL),    -- son/sa (à elle)
    ('ho', 'durcissante', NULL), -- votre
    ('o', 'spirante', NULL),     -- leur

    -- Les nombres (peu importe le mot suivant)
    ('daou', 'adoucissante', NULL),
    ('div', 'adoucissante', NULL),
    ('tri', 'spirante', NULL),
    ('teir', 'spirante', NULL),
    ('pevar', 'spirante', NULL),
    ('peder', 'spirante', NULL),
    ('nav', 'spirante', NULL),

    -- Les prépositions
    ('da', 'adoucissante', NULL),
    ('war', 'adoucissante', NULL),
    ('a', 'adoucissante', NULL),
    ('dre', 'adoucissante', NULL),
    ('dindan', 'adoucissante', NULL);