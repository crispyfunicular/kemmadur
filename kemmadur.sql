CREATE TABLE IF NOT EXISTS lexemes (
    id INTEGER PRIMARY KEY,
    breton TEXT,
    français TEXT,
    pluriel TEXT
);

CREATE TABLE IF NOT EXISTS déclencheurs (
    id INTEGER PRIMARY KEY,
    mot TEXT,
    mutation TEXT,
    critère_genre TEXT,
    critère_pl TEXT
);

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

INSERT INTO lexemes (breton, français, nature, genre, pluriel)
VALUES
    ('tad', 'père', 'nom', 'm', 'tadoù'),
    ('ti', 'maison', 'nom', 'm', 'tiez'),
    ('mamm', 'mère', 'nom', 'f', 'mammoù'),
    ('penn', 'tête', 'nom', 'm', 'pennoù'),
    ('gwir', 'vrai', 'adjectif', NULL, NULL),
    ('levr', 'livre', 'nom', 'm', 'levrioù'),
    ('c''hoar', 'sœur', 'nom', 'f', 'c''hoarezed'),
    ('familh', 'famille', 'nom', 'f', 'familhoù'),
    ('anv', 'nom', 'nom', 'm', 'anvioù'),
    ('breur', 'frère', 'nom', 'm', 'breudeur'),
    ('gouel', 'fête', 'nom', 'm', 'gouelioù'),
    ('diaoul', 'diable', 'nom', 'm', 'diaouled'),
    ('skol', 'école', 'nom', 'f', 'skolioù'),
    ('kan', 'chant', 'nom', 'm', 'kanoù'),
    ('kann', 'bagarre', 'nom', 'm', 'kannoù'),
    ('mel', 'miel', 'nom', 'm', NULL),
    ('maez', 'campagne', 'nom', 'm', 'maezioù'),
    ('tud', 'gens', 'nom', 'pl', NULL),
    ('mor', 'mer', 'nom', 'm', 'morioù'),
    ('prenestr', 'fenêtre', 'nom', 'm', 'prenestroù'),
    ('gwezh', 'fois', 'nom', 'f', 'gwezhioù'),
    ('mouezh', 'voix', 'nom', 'f', 'mouezhioù'),
    ('hir', 'long', 'adjectif', NULL, NULL),
    ('hegarat', 'aimable', 'adjectif', NULL, NULL),
    ('plasenn', 'place', 'nom', 'f', 'plasennoù'),
    ('skuizh', 'fatigué', 'adjectif', NULL, NULL),
    ('pell', 'loin', 'adjectif', NULL, NULL),
    ('bro', 'pays', 'nom', 'f', 'broioù'),
    ('straed', 'rue', 'nom', 'f', 'straedoù'),
    ('ti-post', 'poste', 'nom', 'm', 'tiez-post'),
    ('yaouank', 'jeune', 'adjectif', NULL, NULL),
    ('tenn', 'difficile', 'adjectif', NULL, NULL),
    ('studier', 'étudiant', 'nom', 'm', 'studierien'),
    ('plac''h', 'fille', 'nom', 'f', 'merc''hed'),
    ('micher', 'métier', 'nom', 'f', 'micherioù'),
    ('kozh', 'vieux', 'adjectif', NULL, NULL),
    ('glav', 'pluie', 'nom', 'm', 'glaveier'),
    ('brav', 'beau', 'adjectif', NULL, NULL),
    ('bloaz', 'année', 'nom', 'm', 'bloavezhioù'),
    ('matematikoù', 'mathématiques', 'nom', 'pl', NULL),
    ('bed', 'monde', 'nom', 'm', 'bedoù'),
    ('amzer', 'temps', 'nom', 'f', 'amzerioù'),
    ('gwreg', 'épouse', 'nom', 'f', 'gwragez');

INSERT INTO déclencheurs (mot, mutation, critère_genre, critère_pl)
VALUES
    ('da', 'adoucissante', NULL, NULL),
    ('ma', 'spirante', 'f', NULL),
    ('e', 'adoucissante', NULL, NULL),
    ('he', 'spirante', NULL, NULL),
    ('ho', 'durcissante', NULL, NULL),
    ('hon', 'spirante', NULL, NULL),
    ('o', 'mixte', NULL, NULL),
    ('war', 'adoucissante', NULL, NULL),
    ('a', 'adoucissante', NULL, NULL),
    ('en', 'adoucissante', NULL, NULL),
    ('ur', 'adoucissante', NULL, NULL),
    ('daou', 'adoucissante', NULL, NULL),
    ('div', 'adoucissante', NULL, NULL),
    ('re', 'adoucissante', NULL, NULL),
    ('tri', 'spirante', NULL, NULL),
    ('teir', 'spirante', NULL, NULL),
    ('pevar', 'spirante', NULL, NULL),
    ('peder', 'spirante', NULL, NULL),
    ('nav', 'spirante', NULL, NULL),
    ('ar', 'adoucissante', NULL, NULL),
    ('an', 'adoucissante', 'f', NULL),
    ('ur', 'adoucissante', 'f', NULL),
    ('un', 'adoucissante', 'f', NULL);

SELECT
    déclencheurs.mot || ' ' || breton ||' = ?' AS question,
    déclencheurs.mot || ' ' ||
    CASE déclencheurs.mutation
        WHEN 'spirante' THEN mutations.spirante
        WHEN 'adoucissante' THEN mutations.adoucissante
        WHEN 'durcissante' THEN mutations.durcissante
    END || SUBSTR(lexemes.breton, 2) AS réponse
FROM lexemes
JOIN mutations
    ON SUBSTR(breton, 1, 1) = mutations.lettre_initiale
JOIN déclencheurs
    ON 1=1 -- (Astuce pour forcer le croisement de tous les mots avec tous les déclencheurs)

    WHERE 
        -- 1. La règle d'or pour le genre : ça correspond, OU BIEN le déclencheur s'en fiche (IS NULL)
        (déclencheurs.critère_genre = lexemes.genre OR déclencheurs.critère_genre IS NULL)
        
        -- 2. La règle d'or pour le pluriel : ça correspond, OU BIEN le déclencheur s'en fiche
        AND (déclencheurs.critère_pl = lexemes.pluriel OR déclencheurs.critère_pl IS NULL)
        
        -- 3. On ne garde que les cas où la lettre subit bien la mutation demandée
        AND CASE déclencheurs.mutation
            WHEN 'spirante' THEN mutations.spirante
            WHEN 'adoucissante' THEN mutations.adoucissante
            WHEN 'durcissante' THEN mutations.durcissante
    END IS NOT NULL;


SELECT
    déclencheurs.mot || ' ' || breton ||' = ?' AS question,
    déclencheurs.mot || ' ' || mutations.adoucissante || SUBSTR(breton, 2) AS réponse
FROM lexèmes
JOIN mutations
    ON SUBSTR(breton, 1, 1) = mutations.lettre_initiale
WHERE
    lexemes.genre LIKE 'f' AND déclencheurs.mot = 'ar' AND mutations.adoucissante IS NOT NULL;