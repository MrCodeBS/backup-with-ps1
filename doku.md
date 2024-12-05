# Dokumentation: Backup-Skript für M122

---

## Übersicht

Das **Backup-Skript für M122** ist ein unterhaltsames, PowerShell-basiertes Tool zur Sicherung Ihrer Dateien. Es kombiniert praktische Funktionen wie:
- Automatisierte und zeitgestempelte Backups.
- Anpassbare Quell- und Zielverzeichnisse.
- Optionale Komprimierung von Backups.
- Automatische Bereinigung alter Backups.

Und, das Beste: Es lockert den Backup-Prozess mit **dummen Witzen** auf! 🃏
## Warum
Ich habe mich für die Verwendung von PowerShell als Skriptsprache und die gewählte Backup-Methode entschieden, weil ich eine Herausforderung gesucht habe und etwas Neues lernen wollte. PowerShell bietet eine großartige Gelegenheit, tiefer in die Automatisierung von Aufgaben und die Verwaltung von Dateisystemen einzutauchen, während ich gleichzeitig meine Fähigkeiten in der Skripterstellung erweitere. 

Die gewählte Backup-Methode ermöglicht es mir, nicht nur grundlegende Funktionen wie das Kopieren von Dateien zu implementieren, sondern auch komplexere Konzepte wie Protokollierung, Komprimierung und automatisches Aufräumen zu integrieren. Dies macht das Projekt anspruchsvoll und lehrreich zugleich. 😊

---

## Funktionen im Überblick

1. **Standard- und benutzerdefinierte Pfade**:
   - Geben Sie eigene Pfade ein oder verwenden Sie die Standardeinstellungen.
2. **Witze-Modus**:
   - Während des Backups bekommen Sie dumme (aber urkomische) Witze zu hören.
3. **Automatische Bereinigung**:
   - Löscht alte Backups, wenn das festgelegte Limit überschritten wird.
4. **Komprimierung**:
   - Nach der Sicherung können Sie Ihre Dateien in `.zip`-Dateien verpacken.
5. **Benutzerfreundliche Eingabeaufforderungen**:
   - Das Skript erklärt jeden Schritt und motiviert Sie mit gelegentlichen Scherzen.

---

## So führen Sie das Backup-Skript aus

Verwenden Sie diesen Befehl in PowerShell, um das Skript auszuführen:

```powershell
powershell.exe -File backup-script.ps1
```

### Wichtig:
Wenn PowerShell die Ausführung blockiert (Standardrichtlinie), verwenden Sie die Option `-ep bypass`, um Skripte auszuführen.

---

### Skript mit Witzen

Das Skript liefert bei jedem Schritt humorvolle Kommentare. Hier einige Beispiele:

- **Beim Starten des Backups**:
  - *"Backup starten? Endlich jemand, der sich um seine Dateien kümmert!"*
- **Während des Fortschritts**:
  - *"Warum hat der Computer nicht gearbeitet? Er hatte einen Byte genommen!"*
  - *"Ich mache gerade ein Backup. Das ist wie ein Duplikat, nur cooler!"*
- **Nach Abschluss**:
  - *"Backup abgeschlossen! Dein zukünftiges Ich bedankt sich bei dir."*

---

### Beispiele für lustige Witze während des Fortschritts

Während Dateien kopiert werden, erscheint alle 25 % ein zufälliger Witz. Sie können die folgenden Witze erwarten (und viele mehr!):

1. *"Warum ging die Festplatte zum Arzt? Sie hatte einen schlechten Sektor!"*
2. *"Ich wollte ein Buch über Sicherungskopien schreiben, aber es wurde schon einmal veröffentlicht."*
3. *"Warum gehen Dateinamen immer in Rente? Weil sie .old werden."*
4. *"Mein Backup und ich sind wie Pech und Schwefel. Wenn ich falle, fängt es mich auf."*
5. *"Der IT-Witz der Woche: Ich habe endlich ein Backup gemacht... und das erste, was ich tat, war, es zu löschen."*

---

## Ausführungsbeispiele

### 1. Standardpfade verwenden
```powershell
powershell.exe -File backup-script.ps1
```

Nach dem Start:
```text
Enter source directory path (or press Enter for default): 
Enter backup directory path (or press Enter for default): 
```
Das Skript verwendet die Standardpfade.

---

### 2. Benutzerdefinierte Pfade eingeben
```text
Enter source directory path (or press Enter for default): D:\Projekte
Enter backup directory path (or press Enter for default): E:\Backups
```
Das Backup wird in `E:\Backups` gespeichert.

---

### 3. Automatische Bereinigung und Komprimierung
Am Ende des Backups:
```text
[Compression]: Wanna zip it up? (So it looks cooler!)
1. Yes
2. No, thanks
Enter your choice (1 or 2): 1
```

---

## Häufige Fragen

### 1. Was passiert, wenn ich die Komprimierung überspringe?
Das Backup bleibt als Ordner erhalten. Die Komprimierung ist nur optional.

### 2. Kann ich die Anzahl der Backups erhöhen?
Ja! Ändern Sie die Variable `$maxBackups` im Skript:
```powershell
$maxBackups = 10
```

### 3. Wo finde ich die Protokolldatei?
Die Protokolldatei `backup_log.txt` befindet sich im Backup-Ordner.

---

## Fazit

Das **Backup-Skript für M122** macht nicht nur Ihre Dateien sicherer, sondern auch Ihre Laune besser. Wer wusste, dass ein so ernster Prozess so viel Spass machen kann? 😄

Holen Sie sich eine Tasse Kaffee, starten Sie das Skript und lassen Sie sich von den besten schlechten Witzen der IT-Welt unterhalten! 🎉
