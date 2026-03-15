CREATE TABLE IF NOT EXISTS noms (
    id INTEGER PRIMARY KEY,
    breton TEXT,
    français TEXT,
    genre TEXT,
    pluriel TEXT
);

CREATE TABLE IF NOT EXISTS adjectifs (
    id TEXT PRIMARY KEY,
    breton TEXT,
    français TEXT
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
    ('p', NULL, NULL, 'f'),
    ('kozh', 'vieux', NULL),
    ('brav', 'beau', NULL);

INSERT INTO adjectifs (breton, français)
VALUES
    ('gwir', 'vrai'),
    ('hir', 'long'),
    ('hegarat', 'aimable'),
    ('skuizh', 'fatigué'),
    ('yaouank', 'jeune'),
    ('tenn', 'difficile'),
    ('pell', 'loin', 'adjectif');

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
    

SELECT
    décl.mot || ' + ' || noms.breton ||' = ?' AS question,
    -- Variante avec CONCAT : CONCAT(décl.mot, ' + ', noms.breton, ' = ?') AS question,
    décl.mot || ' + ' ||
    CASE décl.mutation
        WHEN 'spirante' THEN mut.spirante
        WHEN 'adoucissante' THEN mut.adoucissante
        WHEN 'durcissante' THEN mut.durcissante
    END || SUBSTR(noms.breton, 2) AS réponse
FROM noms
JOIN mutations mut
    ON SUBSTR(noms.breton, 1, 1) = mut.lettre_initiale
JOIN déclencheurs décl
    -- Cross join (produit cartésien) -> force le croisement de tous les mots avec tous les déclencheurs
    ON 1=1

    -- Filtrage
    WHERE
        -- Si le déclencheur exige un genre, celui-ci doit correspondre au genre du nom
        (décl.critère_genre = noms.genre OR décl.critère_genre IS NULL)
        
        -- Si le déclencheur exige un nombre, celui-ci doit correspondre au nombre du nom
        AND (décl.critère_pl = noms.pluriel OR décl.critère_pl IS NULL)
        
        -- On ne garde que les cas où la lettre subit bien la mutation demandée
        AND CASE décl.mutation
            WHEN 'spirante' THEN mut.spirante
            WHEN 'adoucissante' THEN mut.adoucissante
            WHEN 'durcissante' THEN mut.durcissante
    END IS NOT NULL;


-- Nom + adjectif : mamm + brav = ?
SELECT
    noms.breton || ' + ' || adjectifs.breton ||' = ?' AS question,
    -- Variante avec CONCAT : CONCAT(noms.breton, ' + ', adjectifs.breton, ' = ?') AS question,
    noms.breton || ' + ' || mut.adoucissante || SUBSTR(adjectifs.breton, 2) AS réponse
FROM adjectifs
JOIN noms
    ON noms.genre = 'f'
JOIN mutations mut
    ON SUBSTR(adjectifs.breton, 1, 1) = mut.lettre_initiale
WHERE
    mut.adoucissante IS NOT NULL;


-- Articles définis (an/al/ar) et indéfinis (un/ul/ur)
WITH ARTICLES_DEF_INDEF AS (
    SELECT
        breton,
        genre,
        -- Article défini (an/al/ar)
        CASE
            WHEN LOWER(SUBSTR(breton, 1, 1)) IN ('n', 't', 'd', 'h', 'a', 'e', 'i', 'o', 'u') THEN 'an'
            -- Variante avec LEFT : WHEN LOWER(LEFT(breton, 1)) IN ('n', 't', 'd', 'h', 'a', 'e', 'i', 'o', 'u') THEN 'an'
            WHEN LOWER(breton) LIKE 'l%' THEN 'al'
            ELSE 'ar'
        END AS article_def,

        -- Article indéfini (un/ul/ur)
        CASE
            WHEN LOWER(SUBSTR(breton, 1, 1)) IN ('n', 't', 'd', 'h', 'a', 'e', 'i', 'o', 'u') THEN 'un'
            WHEN LOWER(breton) LIKE 'l%' THEN 'ul'
            ELSE 'ur'
        END AS article_indef
    FROM noms
)

SELECT
    -- # Article + nom
    art.breton,

    -- ## Article défini (an/al/ar)
    -- ### Question - ex: "an bro = ?" / "ar penn = ?"
    art.article_def || ' + ' || art.breton || ' = ?' AS question_def,
    
    -- ### Réponse
    art.article_def || ' ' || 
    CASE 
        WHEN art.genre = 'f' AND mut.adoucissante IS NOT NULL 
        -- Ex ('bro' -> 'vro') : 'v' || 'ro'
        THEN mut.adoucissante || SUBSTR(art.breton, 2)

        -- Ex 'penn' -> 'penn' (masculin + 'p'.adoucissante = NULL)
        ELSE art.breton 
    END AS reponse_def,

    -- ## Article indéfini (un/ul/ur)
    -- ### Question - ex: "un bro = ?" / "ur penn = ?"
    art.article_indef || ' + ' || art.breton || ' = ?' AS question_indefini,

    -- ### Réponse
    art.article_indef || ' ' || 
    CASE 
        WHEN art.genre = 'f' AND mut.adoucissante IS NOT NULL
        -- Ex ('bro' -> 'vro') : 'v' || 'ro'
        THEN mut.adoucissante || SUBSTR(art.breton, 2)

        -- Ex 'penn' -> 'penn' (masculin + 'p'.adoucissante = NULL)
        ELSE art.breton 
    END AS reponse_indefini

FROM ARTICLES_DEF_INDEF art
LEFT JOIN mutations mut 
    ON LOWER(SUBSTR(art.breton, 1, 1)) = mut.lettre_initiale;