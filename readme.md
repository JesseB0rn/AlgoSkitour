# Algorithmische Skiotourenplanung

## Maturaarbeit von Jesse Born, Alte Kantonsschule Aarau, 2024

Sourcecode und Schriftliche Arbeit finden sich in diesem Repository.

# Abstract

In der vorliegenden Arbeit wird die Umsetzung eines Computerprogramms zur automatisierten
Planung von Ski- und Bergtouren erörtert. Zwei Aspekte stehen dabei im
Vordergrund: Methodik: Wie können Risikowerte berechnet werden? Technik: Wie
kann ein Computer diese Berechnungen effizient ausführen?
Auf Basis des digitalen Höhenmodells (DEM / DHM) SwissAlti3D mit einer Auflösung
von 0.5m, der Bodenbedeckungskarte SwissTLM3D sowie von historischen
Unfalldaten des WSL-Institut für Schnee-und Lawinenforschung (SLF) wird eine
computeroptimierte Reduktionsmethode entwickelt, welche flächendeckend individuelle
Gefahrenwerte für einzelne Rasterpunkte innerhalb der Schweiz errechnen kann.
Um sinnvolle Risikowerte zu errechnen, wird das Risiko aus historischen Unfalldaten
und Begehungshäufigkeiten abgeleitet. Die Berechnung der Risikokarten soll dabei
in Echtzeit erfolgen können, um das täglich erscheinende Lawinenbulletin sowie –
als Erweiterung des Projekts – im Tagesverlauf wahrgenommene Warnzeichen in die
Beurteilung aufzunehmen.
Aus den obigen Datengrundlagen können anhand vom Benutzer eingetragenen
Start- und Zielkoordinaten sichere, bzw. risikooptimierte Routen automatisiert geplant
werden. Die resultierenden Routen werden mit Literaturtouren aus SAC-legitimierten
Tourenführern verglichen und gegenüber diesen bewertet.
