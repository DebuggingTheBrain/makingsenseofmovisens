# MakingSenseOfUniSens 🎛️✂️

### Für Hermine ✨

**MakingSenseOfUniSens** ist ein benutzerfreundliches MATLAB-GUI-Tool zum Zuschneiden von UniSens-Datensätzen. Lege einfach eine Start- und Endzeit fest – das Tool kürzt automatisch die zugehörigen Signaldaten und CSV-Dateien.

## Features ✨

* Intuitive Benutzeroberfläche zur Auswahl des UniSens-Datensatzes
* Präzise Eingabe von Start- und Endzeit in Sekunden
* Automatische Erkennung der Abtastrate
* Zuschneiden der UniSens-Signale auf das gewünschte Zeitfenster
* Automatische Verarbeitung der zugehörigen CSV-Dateien:

  * `nn_live.csv`
  * `bpmbxb_live.csv`
* Speicherung des zugeschnittenen Datensatzes in einem neuen Ausgabeordner
* Statusmeldungen und verständliche Fehlermeldungen direkt in der GUI

## Verwendung 🚀

1. Starte das Tool in MATLAB:

   ```matlab
   makingsenseofunisens
   ```

2. Klicke auf **Durchsuchen** und wähle den Ordner mit deinem UniSens-Datensatz aus.

3. Gib unter **Startzeit** und **Endzeit** das gewünschte Zeitfenster in Sekunden ein.

4. Trage unter **Name Ausgabeordner** einen Namen für den neuen Datensatz ein.

5. Klicke auf **Dataset zuschneiden**.

Der zugeschnittene UniSens-Datensatz sowie die bearbeiteten CSV-Dateien werden anschließend im neuen Ausgabeordner gespeichert.

## Voraussetzungen 📦

Für die Verwendung benötigst du:

* MATLAB mit aktivierter Java-Unterstützung
* die Datei `Unisens-2.3.0.jar` im selben Ordner wie das MATLAB-Skript
* einen gültigen UniSens-Datensatz
* die Funktion `unisensCrop` im MATLAB-Pfad

## Hinweise 📝

* Das Tool sucht im ausgewählten Eingabeordner automatisch nach den Dateien `nn_live.csv` und `bpmbxb_live.csv`.
* Die CSV-Dateien müssen mit Semikolons getrennt sein.
* Zeitstempel in Millisekunden werden automatisch erkannt und für das Zuschneiden in Sekunden umgerechnet.
* Falls der gewünschte Ausgabeordner bereits existiert, fragt das Tool, ob dieser überschrieben werden soll.

## Fehlerbehebung ⚠️

### Die JAR-Datei wird nicht gefunden

Stelle sicher, dass sich `Unisens-2.3.0.jar` im selben Ordner wie das MATLAB-Skript befindet.

### Die Abtastrate kann nicht erkannt werden

Überprüfe, ob der UniSens-Datensatz gültige Signaleinträge und Informationen zur Abtastrate enthält.

### Die CSV-Dateien werden nicht verarbeitet

Überprüfe, ob:

* die Dateien `nn_live.csv` und `bpmbxb_live.csv` im Eingabeordner vorhanden sind,
* die Werte durch Semikolons getrennt sind,
* die Dateien gültige Zeitstempel enthalten und
* innerhalb des gewählten Zeitfensters Daten vorhanden sind.

## Lizenz

Dieses Projekt steht unter der [MIT-Lizenz](LICENSE).

Wenn du das Tool verwendest oder weiterentwickelst, freue ich mich über eine Nennung als Autorin.
