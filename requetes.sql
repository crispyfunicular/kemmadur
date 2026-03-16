-- name: declencheurs()
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


-- name: nom_adjectif()
-- ==============================================================================
-- Nom + adjectif : "mamm + brav = ?"
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


-- name: articles()
-- ==============================================================================
-- Articles définis (an/al/ar) et indéfinis (un/ul/ur)
-- ==============================================================================

WITH ARTICLES AS (
    -- Article défini (an/al/ar)
    SELECT
        breton,
        genre,
        CASE
            WHEN LOWER(SUBSTR(breton, 1, 1)) IN ('n', 't', 'd', 'h', 'a', 'e', 'i', 'o', 'u') THEN 'an'
            -- Variante avec LEFT : WHEN LOWER(LEFT(breton, 1)) IN ('n', 't', 'd', 'h', 'a', 'e', 'i', 'o', 'u') THEN 'an'
            WHEN LOWER(breton) LIKE 'l%' THEN 'al'
            ELSE 'ar'
        END AS article
    FROM noms

    UNION ALL

    -- Article indéfini (un/ul/ur)
    SELECT
        breton,
        genre,
        CASE
            WHEN LOWER(SUBSTR(breton, 1, 1)) IN ('n', 't', 'd', 'h', 'a', 'e', 'i', 'o', 'u') THEN 'un'
            WHEN LOWER(breton) LIKE 'l%' THEN 'ul'
            ELSE 'ur'
        END AS article
    FROM noms
)

-- Ex question : "ar + bro = ?" / "ur + penn = ?"
SELECT
    art.article || ' + ' || art.breton || ' = ?' AS question,
    art.article || ' ' ||
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


-- name: article_nom_adj()
-- ==============================================================================
-- Article + nom + adjectif : "ur + mamm + brav = ?"
-- ==============================================================================

-- Identique requête articles définis et indéfinis
WITH ARTICLES AS (
    -- Article défini (an/al/ar)
    SELECT
        breton,
        genre,
        CASE
            WHEN LOWER(SUBSTR(breton, 1, 1)) IN ('n', 't', 'd', 'h', 'a', 'e', 'i', 'o', 'u') THEN 'an'
            WHEN LOWER(breton) LIKE 'l%' THEN 'al'
            ELSE 'ar'
        END AS article
    FROM noms

    UNION ALL

    -- Article indéfini (un/ul/ur)
    SELECT
        breton,
        genre,
        CASE
            WHEN LOWER(SUBSTR(breton, 1, 1)) IN ('n', 't', 'd', 'h', 'a', 'e', 'i', 'o', 'u') THEN 'un'
            WHEN LOWER(breton) LIKE 'l%' THEN 'ul'
            ELSE 'ur'
        END AS article
    FROM noms
)

-- article + nom muté + adjectif muté = ?
-- Ex : "ur + c'hoar + skuizh = ?"
SELECT
    art.article || ' + ' || art.breton || ' + ' || adj.breton || ' = ?' AS question,
    art.article || ' ' ||
    -- CASE 1 : mutation du nom (féminin uniquement)
    CASE
        -- Si le nom est féminin et que sa lettre initiale a une mutation adoucissante
        WHEN art.genre = 'f' AND mut_nom.adoucissante IS NOT NULL
        -- Ex ('bro' -> 'vro') : 'v' || 'ro'
        -- Ex ('mamm' -> 'vamm') : 'v' || 'amm'
        THEN mut_nom.adoucissante || SUBSTR(art.breton, 2)
        -- Ex 'ur' + 'penn' -> 'penn' (masculin + 'p'.adoucissante = NULL -> pas de mutation)
        ELSE art.breton
    END || ' ' ||
    -- CASE 2 : mutation de l'adjectif (si nom féminin)
    CASE
        -- Si le nom est féminin et que la lettre initiale de l'adjectif a une mutation adoucissante
        WHEN art.genre = 'f' AND mut_adj.adoucissante IS NOT NULL
        -- Ex ('brav' -> 'vrav') : 'v' || 'rav'
        THEN mut_adj.adoucissante || SUBSTR(adj.breton, 2)
        ELSE adj.breton
    END AS réponse
FROM ARTICLES art
JOIN adjectifs adj
    ON 1=1
LEFT JOIN mutations mut_nom
    ON SUBSTR(art.breton, 1, 1) = mut_nom.lettre_initiale
LEFT JOIN mutations mut_adj
    ON SUBSTR(adj.breton, 1, 1) = mut_adj.lettre_initiale;

