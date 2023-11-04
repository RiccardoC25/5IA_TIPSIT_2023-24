# Cronometro in Flutter
Questo è un semplice esempio di un cronometro implementato in Flutter. L'applicazione utilizza gli stream per generare eventi di tick regolari e tener traccia del tempo trascorso. L'interfaccia utente offre i seguenti controlli:

* Avvia/Ferma: Permette di avviare o fermare il cronometro.
* Reset: Reimposta il cronometro a zero.

## Funzionamento
Il cronometro è basato su stream e utilizza gli oggetti Stream e StreamSubscription per generare e gestire gli eventi di tick. Ecco una panoramica del funzionamento:

* Inizialmente, il cronometro è fermo, e il tempo trascorso è a zero.
* Premendo "Avvia," il cronometro inizia a generare eventi di tick regolari.
* Premendo "Ferma," il cronometro si ferma e il tempo viene bloccato al valore corrente.
* "Reset" reimposta il cronometro a zero.
* Il tempo trascorso è visualizzato nell'interfaccia utente nel formato "ore:minuti:secondi."