---
lang: sv-SE
title: 'Kryptolåda'
shorttitle: 'Kryptolåda'
designation: 'XYZ'
version: '0.1'
date: '2024-01-15'
toc: false
fontfamily: courier new
---

# Inledning

Detta dokument beskriver en kryptolåda som kan sättas med utsida mot det
publika Internet (enligt Internetspecifikationen) och på sin insida
erbjuda paketförmedling enligt Internetspecifikationen med trafikskydd och
textskydd.

En kryptolåda ska givet en paketförmedlingstjänst enligt
Internetspecifikationen kunna hitta andra kryptolådor för att upprätta
relevanta koppel.

## Avhängighet

Detta dokument är beroende av Internetspecifikation.

## Begrepp

- **DoS-skydd:** Denial-of-service skydd från trafik som kommer från det
  publika Internet. En del av trafikskyddet.
- **Trafikskydd:** Ibland benämnt *signalskydd*, rör skydd av trafikflöden
  och behandlar bland annat störsändningar, falska meddelanden, och
  hoppande frekvenser / mottagaradresser.
- **Textskydd:** Ofta benämnt som kryptering, rör att skydda
  meddelandeinnehållet även om en antagonist kan läsa trafiken. 

# Arkitektur

Övergripande hanterar arkitekturen för kryptolåda krypterad end-to-end
trafik mellan två godtyckligt valda platser på Internet. Se
[arkitekturskiss](#arkitektur) för exempelritning av arkitekturen. 

![Arkitekturskiss](skiss.svg){ width=50% }

En kryptolåda kan både skicka och ta emot paket. Inkommande paket ska vara
adresserade till kryptolådan

Tunnelidentiteter består av en kombination av: 

 - protokoll
 - mottagaradress (IPv6)
 - mottagarport 

TODO: Vad är begärandet av en ny adress en del av? Använder vi bara prefix
från Internetspecifikationen och växlar mellan dem, eller ska vi lägga
till hur man begär nya adresser via DHCP-PD eller en hel BGP-snurra?

TODO: Vem begär ny tunnelidentitet? Ska vi ha en kontrollenhet / annat som
har ansvar att upprätthålla tunnlar osv.

TODO: Mesh, vilken del beslutar om hur vi bygger vårt mesh? 

TODO: Kontrollplan?

## DoS-skydd

Denial-of-service skyddet ska se till att kryptolådan ej kan sättas ur
funktion genom designade trafikströmmar. Detta görs genom att kryptolådor
ska klara av ett fullt trafikflöde enligt dess datalänklager. 

TODO: Givet korrekt protokoll, port och adress så lämnar DoS över till trafikskydd?

- **Krav:**
  - DoS-skyddet **ska** filtrera bort all trafik som inte är adresserad till aktiv kryptografisk tunnel. 
  - DoS-skyddet **ska** upprätthålla full tillgänglighet vid datalänkslagrets fulla trafikhastighet. 

## Trafikskydd

TODO: Vad gör trafikskyddet i den här lösningen?

TODO: De flesta protokoll idag gör en kombo av trafikskydd och textskydd.
Vill vi dela upp dem? Antar att det finns fördelar med att kunna dela upp
dem även fast de flesta implementationer sköter trafik och textskydd
tillsammans. 

- **Krav:**
  - Trafikskyddet **ska** meddela DoS-skyddet aktiva tunnelidentiteter. 

## Textskydd

TODO: Hur mycket valfrihet ska finnas för textskyddet? Får användare välja vad som helst? 

- **Krav:**
  - Textskyddet **ska** meddela trafikskyddet aktiva tunnelidentiteter. 

# Exempel

## Från klient på insidan till trafik på utsidan

TODO: Reffa internetspecifikationen. På insidan så ska en klient inte se
någon skillnad.

![Trafik som går från klient](inut.svg){ width=100% }

## Trafik utifrån in till klient

TODO: Hur sker avskalning av skydd? 

# Verifikation

TODO: Ta fram mätbara krav på kryptolådan

# Proof of concept

TODO: Ta fram PoC? Ev raspberry pi / liten referensdesign som man kan bygga och testa?

# Annat

TODO: Hur hanterar vi kvantsaker? Ex nyckelutbyte över annan rutt än Internet?

# Från tidigare spec

## Frequency hopping

Kan man använda de sista 64-bitarna i en IPv6-adress för frequency hopping på ett bra sätt?

## Kryptosystem
För de användare som tidigare använt fasta förbindelser eller någon form av VPN-tjänst tillhandahåller Fem små hus-infrastrukturen ett kryptosystem. Kryptosystemet ger skydd mot obehörig trafik, avlyssning och överbelastningsattacker.

Kryptosystemets princip är att det överför Ethernet-paket mellan två punkter genom att man kapslar in det krypterade Ethernet-paketet i ett IPv6-paket som skickas över infrastrukturen. Olika metoder används för att skydda kryptots ändpunktsadresser mot överbelastningsattacker. Har man flera korresponderande motparter via samma krypto identifieras de med ett VLAN per motpart.

Kryptot ansluts till infrastrukuren med 100/400Gbit och tjänsten mot användaren är förmedling av Ethernet-paket med 100/10Gbit-anslutning. Maximal överförd lager 2-Ethernet-MTU är 8210 byte.

För detaljspecifikation av kryptot, se del 4 som tas fram av en separat arbetsgrupp.

En enklare form av tunnling, motsvarande MPLS, är att använda L2TPv3 över IPv6. Funktionaliteten finns i de flesta kommersiella routrar och kan i vissa fall kombineras med routerns kryptofunktion.
