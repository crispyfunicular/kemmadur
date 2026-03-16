-- ==============================================================================
-- Déclencheurs (nombres, prépositions, possessifs...)
-- ==============================================================================

SELECT
    décl.mot || ' + ' || noms.breton ||' = ?' AS question,
    -- Variante avec CONCAT : CONCAT(décl.mot, ' + ', noms.breton, ' = ?') AS question,
    décl.mot || ' ' ||
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


-- ==============================================================================
-- Nom + adjectif : mamm + brav = ?
-- ==============================================================================

-- Noms féminins : mutation adoucissante de l'adjectif
SELECT
    noms.breton || ' + ' || adjectifs.breton || ' = ?' AS question,
    -- Variante avec CONCAT : CONCAT(noms.breton, ' + ', adjectifs.breton, ' = ?') AS question,
    noms.breton || ' ' || mut.adoucissante || SUBSTR(adjectifs.breton, 2) AS réponse
FROM adjectifs
JOIN noms
    ON noms.genre = 'f'
JOIN mutations mut
    ON SUBSTR(adjectifs.breton, 1, 1) = mut.lettre_initiale
WHERE
    mut.adoucissante IS NOT NULL

UNION ALL

-- Noms masculins : pas de mutation (piège)
SELECT
    noms.breton || ' + ' || adjectifs.breton || ' = ?' AS question,
    noms.breton || ' ' || adjectifs.breton AS réponse
FROM adjectifs
JOIN noms
    ON noms.genre = 'm';


-- ==============================================================================
-- Articles définis (an/al/ar) et indéfinis (un/ul/ur)
-- ==============================================================================

WITH ARTICLES AS (
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

-- Article défini (an/al/ar)
-- Ex question : "ar + bro = ?" / "an + penn = ?"
SELECT
    art.article_def || ' + ' || art.breton || ' = ?' AS question,
    art.article_def || ' ' || 
    CASE 
        WHEN art.genre = 'f' AND mut.adoucissante IS NOT NULL 
        -- Ex ('bro' -> 'vro') : 'v' || 'ro'
        THEN mut.adoucissante || SUBSTR(art.breton, 2)
        -- Ex 'penn' -> 'penn' (masculin + 'p'.adoucissante = NULL)
        ELSE art.breton 
    END AS réponse
FROM ARTICLES art
LEFT JOIN mutations mut 
    ON LOWER(SUBSTR(art.breton, 1, 1)) = mut.lettre_initiale

UNION ALL

-- Article indéfini (un/ul/ur)
-- Ex question : "ur + bro = ?" / "un + penn = ?"
SELECT
    art.article_indef || ' + ' || art.breton || ' = ?' AS question,
    art.article_indef || ' ' || 
    CASE 
        WHEN art.genre = 'f' AND mut.adoucissante IS NOT NULL
        -- Ex ('bro' -> 'vro') : 'v' || 'ro'
        THEN mut.adoucissante || SUBSTR(art.breton, 2)
        -- Ex 'penn' -> 'penn' (masculin + 'p'.adoucissante = NULL)
        ELSE art.breton 
    END AS réponse
FROM ARTICLES art
LEFT JOIN mutations mut 
    ON LOWER(SUBSTR(art.breton, 1, 1)) = mut.lettre_initiale;


WITH ARTICLES AS (
    -- même CTE que la requête 3
    ...
)
SELECT
    -- article + nom muté + adjectif muté = ?
    ...
FROM ARTICLES art
JOIN adjectifs ...
LEFT JOIN mutations ...
