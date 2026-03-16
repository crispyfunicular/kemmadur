import sqlite3
import os
import random

from rich.console import Console
from rich.prompt import Prompt

# Console Rich
console = Console()

def init_bdd(bdd: str, tables: str) -> None:
    # Vérification du fichier tables
    if not os.path.isfile(tables):
        console.print(f"[red]Le fichier tables {tables} n'existe pas[/red]")
        return
    
    # Connexion à la base de données
    conn = sqlite3.connect(bdd)
    cursor = conn.cursor()

    # Exécution du fichier de tables
    with open(tables, "r", encoding="utf-8") as f:
        script = f.read()

        # Gestion erreur SQL lors de l'initialisation de la table
        try:
            cursor.executescript(script)
        except sqlite3.Error as e:
            console.print(f"[red]Erreur SQL : {e}[/red]")
            conn.close()
            return

    # Validation des changements (commit)
    conn.commit()
    console.print("[green]Base de données prête à l'emploi[/green]")
    conn.close()


def play(bdd: str) -> None:
    # Connexion à la base de données
    conn = sqlite3.connect(bdd)
    cursor = conn.cursor()

    console.print("[bold blue]Degemer mat ! Bienvenue dans le test de mutations bretonnes.[/bold blue]")

    requete_sql = """
    SELECT
        noms.breton || ' + ' || adjectifs.breton || ' = ?' AS question,
        noms.breton || ' ' || mut.adoucissante || SUBSTR(adjectifs.breton, 2) AS réponse
    FROM adjectifs
    JOIN noms
        ON noms.genre = 'f'
    JOIN mutations mut
        ON SUBSTR(adjectifs.breton, 1, 1) = mut.lettre_initiale
    WHERE
        mut.adoucissante IS NOT NULL
    ORDER BY RANDOM()
    LIMIT 10;
    """

    # Exécution de la requête
    try:
        cursor.execute(requete_sql)
        flashcards = cursor.fetchall() # Renvoie une liste : [('mamm + brav = ?', 'mamm vrav'), ...]
    except sqlite3.Error as e:
        console.print(f"[red]Erreur SQL : {e}[/red]")
        conn.close()
        return

    # Vérification que des questions existent
    if not flashcards:
        console.print("[yellow]Aucune question disponible.[/yellow]")
        conn.close()
        return

    score = 0
    total = len(flashcards)

    # Boucle de jeu
    for question, reponse_attendue in flashcards:
        # Prompt.ask équivaut à input avec Rich
        reponse_user = Prompt.ask(f"[bold yellow]{question}[/]")

        # Comparaison de la réponse données avec celle attendue
        if reponse_user.strip().lower() == reponse_attendue.lower():
            console.print("[bold green]Mat tre ![/bold green]\n")
            score += 1
        else:
            console.print(f"[bold red]Fazi...[/bold red] La bonne réponse était : [bold green]{reponse_attendue}[/bold green]\n")

    # Fin de la partie
    console.print("---")
    console.print(f"[bold cyan]Fin de l'exercice ! Votre score : {score} / {total}[/bold cyan]")

    conn.close()


def main():
    bdd = "kemmadur.db"
    tables = "tables.sql"
    init_bdd(bdd, tables)
    play(bdd)


if __name__ == "__main__":
    main()